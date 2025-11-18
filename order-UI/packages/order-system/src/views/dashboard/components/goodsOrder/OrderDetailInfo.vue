<!--订单详情列表-->

<script>
import { addRebate } from '@/api/system/Rebate';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { listBankAccount } from '@/api/system/bankAccount';
// 不再通过字典接口获取返利方式，使用硬编码选项
import { fix, fix_2 } from '@/api/tool/format';
import { RebateType } from '@/api/tool/enums';
import ExpandCursor from '../common/ExpandCursor.vue';
import FitColumnPlugin from 'v-fit-columns';

export default {
  name: 'OrderDetailInfo',
  components: { SearchOption, ExpandCursor },
  props: {
    orderDetailInfoList: {
      type: Array,
      default: () => []
    },
    ban: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    filteredOrderDetailInfoList() {
      // 显示所有行，包括没有备注的行
      return this.orderDetailInfoList;
    },
    RebateType() {
      return RebateType;
    }
  },
  data() {
    return {
      addMoneyBackVisible: false,
      // 控制表格展开行的keys
      expandRowKeys: [],
      // 返利回扣信息
      moneyBackInfo: {
        // 后端期望的是 orderDetailIds 数组
        orderDetailIds: [],
        rebateDate: '',
        // （返利/降价）单价
        unitPrice: null,
        // 最终金额
        rebate: '',
        // 使用 RebateType 常量（Weight / Square）
        rebateMethod: RebateType.Weight,
        // 供应商/账号信息
        inAcountsName: '',
        inBankNo: '',
        supplier: '',
        outAcountsName: '',
        outBankNo: '',
        rebateReason: '',
        comments: '',
        // 计算字段：面积 / 重箱
        area: 0,
        weightBox: 0
      },
      // 硬编码的返利方式：重箱(Weight)、面积(Square)，值使用 RebateType
      rebateMethods: [
        { dictValue: RebateType.Weight, dictLabel: '重箱' },
        { dictValue: RebateType.Square, dictLabel: '面积' }
      ],
      loading: false
    };
  },
  watch: {
    // 监听订单详情列表变化，更新默认展开的行
    orderDetailInfoList: {
      handler(newVal) {
        this.updateExpandRows(newVal);
        // 数据变化后重新计算列宽
        if (newVal && newVal.length > 0) {
          this.$nextTick(() => {
            this.$nextTick(() => {
              this.fitColumns();
            });
          });
        }
      },
      immediate: true
    }
  },
  mounted() {
    // 组件挂载后，等待DOM渲染完成再调整列宽
    this.$nextTick(() => {
      this.$nextTick(() => {
        setTimeout(() => {
          if (this.filteredOrderDetailInfoList && this.filteredOrderDetailInfoList.length > 0) {
            this.fitColumns();
          }
        }, 100);
      });
    });
  },
  // 不再需要在 created 中请求字典，返利方式已硬编码
  methods: {

    listBankAccount,
    listCompany,
    // 更新默认展开的行
    updateExpandRows(list) {
      // 如果有需要展开的行，可以在这里处理
      // 暂时保留空实现，避免报错
    },
    // 调整列宽方法
    fitColumns() {
      if (!this.$refs.tableRef) {
        return;
      }

      // 确保表格有数据
      if (!this.filteredOrderDetailInfoList || this.filteredOrderDetailInfoList.length === 0) {
        return;
      }

      // 先调用表格的 doLayout 方法，确保表格布局完成
      this.$refs.tableRef.doLayout();

      // 使用 requestAnimationFrame 确保在浏览器下一次重绘时执行
      requestAnimationFrame(() => {
        setTimeout(() => {
          if (this.$refs.tableRef) {
            try {
              // 调用 v-fit-columns 插件的方法重新计算列宽
              FitColumnPlugin.resize(this.$refs.tableRef);
            } catch (error) {
              console.warn('调整列宽失败:', error);
            }
          }
        }, 50);
      });
    },
    // 处理表头点击事件（如果需要）
    handleHeaderClick(column, event) {
      // 表头点击后重新调整列宽
      this.$nextTick(() => {
        this.fitColumns();
      });
    },
    tableRowClassName({ row }) {
      // 所有行都显示展开图标
      return 'expandable-row';
    },

    getSummaries(param) {
      const { columns, data } = param;
      const sums = [];
      const summaryColumns = ['paymentFactory', 'payments', 'tonnage', 'landFreight', 'seaFreight', 'freight', 'profit', 'profitNoTax', 'sundryCost', 'paymentsWithSundry'];

      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = '合计';
          return;
        }

        // 如果列没有属性（如expand列、操作列），跳过计算
        if (!column.property) {
          return;
        }

        if (summaryColumns.includes(column.property)) {
          const values = data.map(item => Number(item[column.property]));
          if (!values.every(value => isNaN(value))) {
            sums[index] = values.reduce((prev, curr) => {
              const value = Number(curr);
              if (!isNaN(value)) {
                return prev + curr;
              } else {
                return prev;
              }
            }, 0);
            sums[index] = fix_2(sums[index]);
            sums[index] += column.property === 'tonnage' ? ' 吨' : ' 元';
          } else {
            sums[index] = 'N/A';
          }
        }
      });

      return sums;
    },

    // 每一个组件必须要实现的方法
    handleProcess(that) {
      that.dialogVisible = false;
      return Promise.resolve();
    },
    handleReject() {
      return Promise.resolve();
    },
    // 点击确认
    handleCommitBankAccount(val) {
      this.moneyBackInfo.inAcountsName = val.acountsName;
      this.moneyBackInfo.inBankNo = val.bankNo;
    },
    handleCommitCompany(val) {
      this.moneyBackInfo.supplierID = val.id;
      this.moneyBackInfo.supplier = val.companyName;
    },
    // 返利回扣（从行创建）
    handleMoneyBack(row) {
      this.reset();
      // 通过行确定订单明细 id
      this.moneyBackInfo.orderDetailIds = [row.id];
      // 按照 rebate/index.vue 的公式计算该行的面积与重箱
      const area = (Number(row.length) * Number(row.width) * Number(row.pieces)) / 1000000 || 0;
      const weightBox = (Number(row.height) * Number(row.length) * Number(row.width) * Number(row.pieces)) / 1000000 / 20 || 0;
      this.moneyBackInfo.area = area;
      this.moneyBackInfo.weightBox = weightBox;
      // 默认选重箱（与主页面一致）
      this.moneyBackInfo.rebateMethod = RebateType.Weight;
      this.addMoneyBackVisible = true;
    },
    // 添加返利回扣信息（提交前计算金额并转换 rebateMethod）
    addMoneyBackInfo() {
      // 计算金额：根据选择的返利方式，使用面积或重箱乘以单价
      const base = this.moneyBackInfo.rebateMethod === RebateType.Weight ? this.moneyBackInfo.weightBox : this.moneyBackInfo.area;
      const unit = Number(this.moneyBackInfo.unitPrice) || 0;
      this.moneyBackInfo.rebate = fix_2((base || 0) * unit);
      // 不要直接修改组件使用的 rebateMethod（仍为 RebateType），为后端构造 payload 时转换为 1/2
      const payload = Object.assign({}, this.moneyBackInfo, {
        rebateMethod: this.moneyBackInfo.rebateMethod === RebateType.Weight ? 1 : 2
      });
      addRebate(payload).then(res => {
        this.$message.success('添加成功~');
        this.addMoneyBackVisible = false;
      });
    },
    // 重置moneyBackInfo
    reset() {
      this.moneyBackInfo = {
        orderDetailIds: [],
        rebateDate: '',
        unitPrice: null,
        rebate: '',
        rebateMethod: RebateType.Weight,
        inAcountsName: '',
        inBankNo: '',
        supplier: '',
        outAcountsName: '',
        outBankNo: '',
        rebateReason: '',
        comments: '',
        area: 0,
        weightBox: 0
      };
    },
    // 处理展开行变化
    handleExpandChange(row, expandedRows) {
      // 展开/收起行后重新调整列宽
      this.$nextTick(() => {
        this.fitColumns();
      });
    },
    // 处理表格滚动（可选，用于某些场景下的列宽调整）
    handleTableScroll() {
      // 滚动时不需要调整列宽，避免性能问题
    }
  }
};
</script>

<template>
  <div>
    <el-row>
      <el-col :span="8">
        <span style="font-weight: bolder">订单货物详情列表</span>
      </el-col>
    </el-row>
    <el-row>
      <el-table ref="tableRef" border :data="filteredOrderDetailInfoList" row-key="id" max-height="700" fit
                :cell-style="() => ({ padding: '.5px' })" size="mini" show-summary :summary-method="getSummaries"
                :row-class-name="tableRowClassName" :expand-row-keys="expandRowKeys" v-fit-columns
                @header-click="handleHeaderClick" @expand-change="handleExpandChange" @body-wrapper-scroll="handleTableScroll">

        <el-table-column v-if="!ban" label="操作" align="center" class-name="small-padding fixed-width leave-alone"
                         fixed="left" min-width="90">
          <template slot-scope="scope">
            <el-button size="mini" type="warning" @click="handleMoneyBack(scope.row)">货物返利</el-button>
          </template>
        </el-table-column>
        <el-table-column label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip>
          <!--          如果有 显示 如果没有 显示- -->
          <template slot-scope="scope" >
            <ExpandCursor>
              {{ scope.row.storeHouseName ? scope.row.storeHouseName : '-' }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="供应商" align="center" prop="supplier" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.supplier }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="级别名称" align="center" prop="levelName" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.levelName }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip>
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.countingUnit }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="厚度" align="center" prop="height" show-overflow-tooltip>
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.height }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="长度" align="center" prop="length" show-overflow-tooltip>
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.length }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="宽度" align="center" prop="width" show-overflow-tooltip>
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.width }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="每包片数" align="center" prop="piecesPerPack" show-overflow-tooltip>
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.piecesPerPack }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="包数" align="center" prop="packs" show-overflow-tooltip>
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.packs }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="出厂片数" align="center" prop="pieces" show-overflow-tooltip>
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.pieces }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="出厂单价" align="center" prop="price" show-overflow-tooltip>
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.price }}
            </ExpandCursor>
          </template>
        </el-table-column>

        <el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" show-overflow-tooltip>
          <template slot-scope="scope">
            <ExpandCursor>
              <el-tag disable-transitions>{{ scope.row.isIncludeTaxFactory == 0 ? '否' : '是' }}</el-tag>
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="杂费" align="center" prop="sundryCost" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.sundryCost }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="出厂货款" align="center" prop="paymentFactory" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.paymentFactory }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="卸货片数" align="center" prop="actualPieces" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.actualPieces }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="卸货价" align="center" prop="paymentUnload" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.paymentUnload }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              <el-tag disable-transitions>{{ scope.row.isIncludeTaxSale == 0 ? '否' : '是' }}</el-tag>
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.paymentsWithSundry }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="总货款" align="center" prop="payments" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.payments }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="误差" align="center" prop="erro" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.erro }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="吨位" align="center" prop="tonnage" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.tonnage }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="陆运费单价" align="center" prop="landFreightPrice" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.landFreightPrice }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="加费" align="center" prop="additionalFees" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.additionalFees }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="陆运费" align="center" prop="landFreight" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.landFreight }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="海运费" align="center" prop="seaFreight" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.seaFreight }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="总运费" align="center" prop="freight" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.freight }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="其他费用" align="center" prop="otherCost" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.otherCost }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="利润" align="center" prop="profit" show-overflow-tooltip min-width="80">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.profit }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="不含税利润" align="center" prop="profitNoTax" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.profitNoTax }}
            </ExpandCursor>
          </template>
        </el-table-column>

        <el-table-column label="物流利润" align="center" prop="logisticsProfit" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.logisticsProfit }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="客户佣金" align="center" prop="customerCommission" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.customerCommission }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="厂家佣金" align="center" prop="factoryCommission" show-overflow-tooltip min-width="100">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.factoryCommission }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="计提厂家返利金额" align="center" prop="factoryRebateAmount" show-overflow-tooltip min-width="120">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.factoryRebateAmount }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column label="计提厂家降价金额" align="center" prop="factoryDiscountAmount" show-overflow-tooltip min-width="120">
          <template slot-scope="scope">
            <ExpandCursor>
              {{ scope.row.factoryDiscountAmount }}
            </ExpandCursor>
          </template>
        </el-table-column>
        <el-table-column type="expand" label="备注" align="center" min-width="100">
          <template slot-scope="scope">
            <div class="expand-row">
              <div class="expand-label">备注：</div>
              <div class="expand-content">{{ scope.row.comments }}</div>
            </div>
          </template>
        </el-table-column>
      </el-table> </el-row>

    <!--    返利回扣-->
    <el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false"
               title="添加返利信息" :visible.sync="addMoneyBackVisible" width="40%" append-to-body>
      <el-form :model="moneyBackInfo" label-width="80px">
        <el-form-item label="日期" prop="rebateDate">
          <el-date-picker v-model="moneyBackInfo.rebateDate" type="datetime" placeholder="选择日期"
                          value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
        </el-form-item>
        <!-- （返利/降价）单价 -->
        <el-form-item label="（返利/降价）单价" prop="unitPrice">
          <el-input v-model="moneyBackInfo.unitPrice" placeholder="请输入（返利/降价）单价" />
        </el-form-item>
        <el-form-item label="金额" prop="rebate">
          <el-input v-model="moneyBackInfo.rebate" placeholder="请输入金额" />
        </el-form-item>
        <el-form-item label="供应商" prop="supplier">
          <el-row>
            <el-col :span="10">
              <el-input v-model="moneyBackInfo.supplier" placeholder="请输入供应商" />
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listCompany" :limit-info="{ companyType: '供应商' }"
                            @commitBack="handleCommitCompany">
                <template #table-columns>
                  <el-table-column label="公司名称" align="center" prop="companyName" />
                  <el-table-column label="老板姓名" align="center" prop="leader" />
                  <el-table-column label="老板电话" align="center" prop="leaderTel" />
                  <el-table-column label="开户行" align="center" prop="bankName" />
                  <el-table-column label="开户名" align="center" prop="acountsName" />
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="返利方式" prop="rebateMethod">
          <el-select v-model="moneyBackInfo.rebateMethod" default-first-option placeholder="请选择返利方式">
            <el-option v-for="item in rebateMethods" :key="item.dictValue" :label="item.dictLabel"
                       :value="item.dictValue"></el-option>
          </el-select>
        </el-form-item>
        <!-- 重箱值 -->
        <el-form-item label="重箱值" prop="weightBox" v-if="moneyBackInfo.rebateMethod === RebateType.Weight">
          <el-input v-model="moneyBackInfo.weightBox" placeholder="根据订单自动计算" disabled />
        </el-form-item>
        <!-- 面积值 -->
        <el-form-item label="面积值" prop="area" v-if="moneyBackInfo.rebateMethod === RebateType.Square">
          <el-input v-model="moneyBackInfo.area" placeholder="根据订单自动计算" disabled />
        </el-form-item>
        <el-form-item label="返利原因" prop="rebateReason">
          <el-input v-model="moneyBackInfo.rebateReason" placeholder="请输入返利原因" />
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="moneyBackInfo.comments" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
				<el-button @click="addMoneyBackVisible = false">取 消</el-button>
				<el-button type="primary" @click="addMoneyBackInfo">添加</el-button>
			</span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">
// 表格滚动条样式
::v-deep .el-table__body-wrapper {
  &::-webkit-scrollbar {
    width: 12px;
    height: 22px;
  }

  &::-webkit-scrollbar-thumb {
    background-color: #909399;
    border-radius: 2px;
    border: 2px solid #f2f6fc;

    &:hover {
      background-color: #606266;
    }
  }

  &::-webkit-scrollbar-track {
    background-color: #f2f6fc;
    border-radius: 6px;
  }
}

::v-deep .non-expandable-row {
  .el-table__expand-column .el-table__expand-icon {
    display: none;
  }
}

::v-deep .expandable-row {
  .el-table__expand-column .el-table__expand-icon {
    display: inline-block;
  }
}

// 全局滚动条样式
::-webkit-scrollbar {
  width: 12px;
  height: 22px;
}

::-webkit-scrollbar-thumb {
  background-color: #909399;
  border-radius: 6px;
  border: 2px solid #f2f6fc;

  &:hover {
    background-color: #606266;
  }
}

::-webkit-scrollbar-track {
  background-color: #f2f6fc;
  border-radius: 6px;
}

::v-deep .el-table {
  width: 100% !important;
  table-layout: fixed;
}

// 展开行样式
.expand-row {
  padding: 4px 5px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #fafafa;
  border-left: 3px solid #409eff;

  .expand-label {
    font-weight: bold;
    color: #606266;
    margin-right: 10px;
    flex-shrink: 0;
    font-size: 13px;
  }

  .expand-content {
    color: #303133;
    word-break: break-all;
    white-space: pre-wrap;
    line-height: 1.4;
    font-size: 13px;
    text-align: center;
  }
}
</style>