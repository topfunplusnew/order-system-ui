<script>
import {addRebate} from "@/api/system/Rebate";
import SearchOption from "@/components/SearchOption.vue";
import {listCompany} from "@/api/system/company";
import {listBankAccount} from "@/api/system/bankAccount";
import {getGoodsOrder, updateGoodsOrder} from "@/api/system/goodsOrder";
import {excludeParams} from "@/api/tool/exclude";
import {listRebate} from "../../../../api/system/Rebate";
import {getDicts, listData} from "../../../../api/system/dict/data";

export default {
  name: "OrderDetailInfo",
  components: {SearchOption},
  props: {
    orderDetailInfoList: {
      type: Array
    },
    ban: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      addMoneyBackVisible: false,
      //返利回扣信息
      moneyBackInfo: {
        orderDetailID: '',
        rebateDate: '',
        rebate: '',
        rebateMethod: '',
        inAcountsName: '',
        inBankNo: '',
        supplier: '',
        outAcountsName: '',
        outBankNo: '',
        rebateReason: '',
        comments: ''
      },
      // 从字典中拿
      rebateMethods: [],
      loading: false,
    }
  },
  created() {
    // 拿取返利方式
    this.listRebateMethods();
  },
  methods: {
    listBankAccount,
    listCompany,
    // 返利方式
    listRebateMethods() {
      getDicts('order_rebate_type').then(res => {
        this.rebateMethods = res.data;
      })
    },
    //点击确认
    handleCommitBankAccount(val) {
      this.moneyBackInfo.inAcountsName = val.acountsName;
      this.moneyBackInfo.inBankNo = val.bankNo;
    },
    handleCommitCompany(val) {
      this.moneyBackInfo.supplierID = val.id;
      this.moneyBackInfo.supplier = val.companyName;
    },
    handleCommitBankAccountOut(val) {
      this.moneyBackInfo.outAcountsName = val.acountsName;
      this.moneyBackInfo.outBankNo = val.bankNo;
    },
    //返利回扣
    handleMoneyBack(row) {
      this.moneyBackInfo.orderDetailID = row.id;
      this.addMoneyBackVisible = true;
    },
    //添加返利回扣信息
    addMoneyBackInfo() {
      addRebate(this.moneyBackInfo)
          .then(res => {
            this.$message.success('添加成功~')
            this.addMoneyBackVisible = false
          })
    },
    //删除订单详情个体
    deleteOrderDetail(row) {
      //拿到订单个体 修改这个订单的信息
      let order_id = sessionStorage.getItem('order_id')
      let delete_order_detail = {}
      // 提醒用户第二次确认 避免误删
      this.$confirm('是否要删除该货物?', '删除货物', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }).then(() => {
        //获取订单的信息
        getGoodsOrder(order_id).then(res => {
          delete_order_detail = res.data
          //过滤参数
          delete_order_detail = excludeParams(delete_order_detail, this.$exclude)
          //删除row.id对应的订单详情
          delete_order_detail.orderDetailList = delete_order_detail.orderDetailList.filter(item => item.id !== row.id)
          //修改订单信息
          updateGoodsOrder(delete_order_detail).then(res => {
            this.$message({
              type: 'success',
              message: '删除成功!'
            });
            // 提醒父组件要修改状态 刷新列表
            this.$emit('updateOrderDetailList', order_id)
          })
        })
      })
    }
  }
}
</script>

<template>
  <div>
    <el-row>
      <el-col :span="8">
        <span style="font-weight: bolder">订单货物详情列表</span>
      </el-col>
    </el-row>
    <el-row>
      <el-table border :data="orderDetailInfoList" id="printBox" max-height="700"
                :cell-style="()=>{return {padding:'.5px'}}" size="mini">
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="170px" fixed="left"
                         v-if="!ban">
          <template slot-scope="scope">
            <el-button
                size="mini"
                type="warning"
                @click="handleMoneyBack(scope.row)"
            >货物返利
            </el-button>
            <el-button
                size="mini"
                type="danger"
                @click="deleteOrderDetail(scope.row)"
            >删除货物
            </el-button>
          </template>
        </el-table-column>
        <el-table-column label="订单日期" align="center" prop="orderDate" fixed="left" show-overflow-tooltip/>
        <el-table-column label="客户" align="center" prop="customer" show-overflow-tooltip>
          <template slot-scope="scope">
            {{ scope.row.customer ? scope.row.customer : "-" }}
          </template>
        </el-table-column>
        <el-table-column label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip>
          <!--          如果有 显示 如果没有 显示- -->
          <template slot-scope="scope">
            {{ scope.row.storeHouseName ? scope.row.storeHouseName : "-" }}
          </template>
        </el-table-column>
        <el-table-column label="供应商" align="center" prop="supplier" show-overflow-tooltip/>
        <el-table-column label="级别名称" align="center" prop="levelName" show-overflow-tooltip/>
        <el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip/>
        <el-table-column label="厚度" align="center" prop="height" show-overflow-tooltip/>
        <el-table-column label="长度" align="center" prop="length" show-overflow-tooltip/>
        <el-table-column label="宽度" align="center" prop="width" show-overflow-tooltip/>
        <el-table-column label="出厂片数" align="center" prop="pieces" show-overflow-tooltip/>
        <el-table-column label="每包片数" align="center" prop="piecesPerPack" show-overflow-tooltip/>
        <el-table-column label="包数" align="center" prop="packs" show-overflow-tooltip/>
        <el-table-column label="出厂单价" align="center" prop="price" show-overflow-tooltip/>
        <el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" show-overflow-tooltip>
          <template slot-scope="scope">
            <el-tag
                disable-transitions>{{ scope.row.isIncludeTaxFactory === 0 ? "否" : "是" }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="杂费" align="center" prop="sundryCost" show-overflow-tooltip/>
        <el-table-column label="出厂货款" align="center" prop="paymentFactory" show-overflow-tooltip/>
        <el-table-column label="卸货价" align="center" prop="paymentUnload" show-overflow-tooltip/>
        <el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale" show-overflow-tooltip>
          <template slot-scope="scope">
            <el-tag
                disable-transitions>{{ scope.row.isIncludeTaxSale === 0 ? "否" : "是" }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="总货款" align="center" prop="payments" show-overflow-tooltip/>
        <el-table-column label="误差" align="center" prop="erro" show-overflow-tooltip/>
        <el-table-column label="吨位" align="center" prop="tonnage" show-overflow-tooltip/>
        <el-table-column label="陆运费单价" align="center" prop="landFreightPrice" show-overflow-tooltip/>
        <el-table-column label="陆运费" align="center" prop="landFreight" show-overflow-tooltip/>
        <el-table-column label="海运费" align="center" prop="seaFreight" show-overflow-tooltip/>
        <el-table-column label="总运费" align="center" prop="freight" show-overflow-tooltip/>
        <el-table-column label="其他费用" align="center" prop="otherCost" show-overflow-tooltip/>
        <el-table-column label="利润" align="center" prop="profit" show-overflow-tooltip/>
        <el-table-column label="不含税利润" align="center" prop="profitNoTax" show-overflow-tooltip/>
        <el-table-column label="实际片数" align="center" prop="actualPieces" show-overflow-tooltip/>
        <el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" show-overflow-tooltip/>
        <el-table-column label="加费" align="center" prop="additionalFees" show-overflow-tooltip/>
        <el-table-column label="物流利润" align="center" prop="logisticsProfit" show-overflow-tooltip/>
        <el-table-column label="客户佣金" align="center" prop="customerCommission" show-overflow-tooltip/>
      </el-table>
    </el-row>

    <!--    返利回扣-->
    <el-dialog :close-on-click-modal="false"
        title="添加返利信息"
        :visible.sync="addMoneyBackVisible"
        width="40%" append-to-body>
      <el-form :model="moneyBackInfo" label-width="80px">
        <el-form-item label="日期" prop="rebateDate">
          <el-date-picker
              v-model="moneyBackInfo.rebateDate"
              type="date"
              placeholder="选择日期" value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="金额" prop="rebate">
          <el-input v-model="moneyBackInfo.rebate" placeholder="请输入金额"/>
        </el-form-item>
        <el-form-item label="收款户名" prop="inAcountsName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="moneyBackInfo.inAcountsName" placeholder="请输入收款户名"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :limit-info="{}" :get-data="listBankAccount" @commitBack="handleCommitBankAccount">
                <template #table-columns>
                  <el-table-column label="开户行" align="center" prop="bankName"/>
                  <el-table-column label="开户名" align="center" prop="acountsName"/>
                  <el-table-column label="账号" align="center" prop="bankNo"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="收款账号" prop="inBankNo">
          <el-input v-model="moneyBackInfo.inBankNo" placeholder="请输入收款账号"/>
        </el-form-item>
        <el-form-item label="供应商" prop="supplier">
          <el-row>
            <el-col :span="10">
              <el-input v-model="moneyBackInfo.supplier" placeholder="请输入供应商"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listCompany" @commitBack="handleCommitCompany"
                            :limit-info="{companyType:'供应商'}">
                <template #table-columns>
                  <el-table-column label="公司名称" align="center" prop="companyName"/>
                  <el-table-column label="老板姓名" align="center" prop="leader"/>
                  <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                  <el-table-column label="开户行" align="center" prop="bankName"/>
                  <el-table-column label="开户名" align="center" prop="acountsName"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="付款户名" prop="outAcountsName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="moneyBackInfo.outAcountsName" placeholder="请输入付款户名"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :limit-info="{}" :get-data="listBankAccount" @commitBack="handleCommitBankAccountOut">
                <template #table-columns>
                  <el-table-column label="开户行" align="center" prop="bankName"/>
                  <el-table-column label="开户名" align="center" prop="acountsName"/>
                  <el-table-column label="账号" align="center" prop="bankNo"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="付款款账号" prop="outBankNo">
          <el-input v-model="moneyBackInfo.outBankNo" placeholder="请输入付款款账号"/>
        </el-form-item>
        <el-form-item label="返利方式" prop="rebateMethod">
          <el-select
              v-model="moneyBackInfo.rebateMethod"
              default-first-option
              placeholder="请选择返利方式">
            <el-option
                v-for="item in rebateMethods"
                :key="item.dictValue"
                :label="item.dictLabel"
                :value="item.dictLabel">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="返利原因" prop="rebateReason">
          <el-input v-model="moneyBackInfo.rebateReason" placeholder="请输入返利原因"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="moneyBackInfo.comments" placeholder="请输入备注"/>
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

</style>
