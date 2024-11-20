<script>
import SheetItem from "@/views/dashboard/components/common/SheetItem.vue";
import SelectGoods from "@/views/dashboard/components/common/SelectGoods.vue";
import {mixin_excel_server} from "@/views/dashboard/components/common/utils/excelServer";

export default {
  name: "SheetList",
  components: {SelectGoods, SheetItem},
  mixins: [mixin_excel_server],
  // 接收文件读取到的sheetList 渲染出来给用户看 并且可以选择看哪一个
  props: {
    // sheet列表
    sheetList: {
      type: Array,
      default: []
    }
  },
  data() {
    return {
      // 订单选择弹窗
      invoiceAllVisible: false,
      // 供应商价税合计表
      invoiceSupplierList: [],
      // 供应商统计
      supplierTotalInfo: [],
      // 供应商搜索字段
      querySupplier: null,
      // 减去的金额
      minusValue: 0,
    }
  },
  methods: {
    // 点击某一个 打开订单的列表 todo 对excel中开票的金额分类统计 这里需要审计一下
    handleInvoiceAll(item, index) {
      const excelInfo = this.handleReadExcel()
      // 购买方统计
      const purchaseMap = new Map()
      // 对供应商进行统计的函数
      const purchaseHandler = (item, purchaseMap) => {
        // 如果没有这个供应商 那么就返回
        if (!item.purchaseId) {
          return
        }
        // 对供应商进行分类统计
        if (purchaseMap.has(item.purchaseId)) {
          purchaseMap.set(item.purchaseId, {
            id: item.purchaseId,
            name: item.purchaseName,
            // 主要统计的逻辑
            money: item.total + purchaseMap.get(item.purchaseId)
          })
        }
        // 添加到MAP中
        purchaseMap.set(item.purchaseId, {
          id: item.purchaseId,
          name: item.purchaseName,
          money: item.total
        })
      }
      // 先把需要的列拿出来
      excelInfo[index].map(item => {
        return {
          sellerId: item['销方ID'],
          sellerName: item['销方名称'],
          purchaseId: item['购买方ID'],
          purchaseType: item['购买方类型'],
          purchaseName: item['购买方名称'],
          total: item['价税合计']
        }
      }).forEach((item) => purchaseHandler(item, purchaseMap))
      // 存储响应式变量
      this.supplierTotalInfo = Array.from(purchaseMap.values())
      // 存储到暂存 方便后面使用
      this.$store.dispatch('excel/setTempData', this.supplierTotalInfo)
      // 打开弹窗
      this.invoiceAllVisible = true
    },
    // 弹窗左侧供应商列表的筛选
    handleFilter() {
      // 每次操作之前都要重置 重置的逻辑就是从暂存拿出新的进行复制
      this.supplierTotalInfo = this.$store.getters.tempData
      // 筛选
      this.supplierTotalInfo = this.supplierTotalInfo.filter(item => {
        return item.name.indexOf(this.querySupplier) !== -1
      })
    },
    // todo 查看某个供应商分配情况
    handleCheck() {

    },
    // 重置筛选结果
    handleReset() {
      this.supplierTotalInfo = this.$store.getters.tempData
    },
    // 重置订单列表的数据 通过事件总线实现
    handleResetOrderList() {
      console.log('之前选择的订单列表', this.$store.getters.selectedOrder)
      this.$bus.$emit('select-goods:update')
    },
  }
}
</script>

<template>
  <div>
    <!--    Excel Sheet的选择列表-->
    <div class="sheet-container">
      <!--      点击某一个sheet-->
      <SheetItem v-for="(item,index) in sheetList" :key="item" :title="item"
                 @click.native="handleInvoiceAll(item,index)"/>
    </div>


    <!--    批量开票的弹窗-->
    <div>
      <el-dialog
        title="批量开票"
        fullscreen
        :visible.sync="invoiceAllVisible"
        append-to-body>
        <!--        展示某个公司有多少钱可以开-->
        <el-row :gutter="12">
          <el-col :span="12">
            <el-card class="box-card">
              <div slot="header" class="clearfix">
                <span class="bold-text">供应商分配剩余金额</span>
                <el-button style="float: right; padding: 3px 0" type="text" @click="handleReset">重置筛选</el-button>
              </div>
              <!--              供应商搜索区域-->
              <el-form :inline="true" class="demo-form-inline">
                <el-form-item label="供应商名称">
                  <el-input v-model="querySupplier" placeholder="请输入供应商名称" size="mini" clearable></el-input>
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="handleFilter" size="mini">查询</el-button>
                </el-form-item>
              </el-form>
              <!--          每一个供应商可以开的钱的统计表格-->
              <el-table
                :data="supplierTotalInfo" size="mini" :cell-style="()=>{return {padding:'2px'}}"
                style="width: 100%" max-height="700px" border>
                <el-table-column prop="id" label="ID">
                </el-table-column>
                <el-table-column prop="name" label="供应商">
                </el-table-column>
                <el-table-column prop="money" label="金额">
                  <template slot-scope="scope">
                    <span class="bold-text">{{ scope.row.money }}</span>
                    <!--   todo 想法：选择某个订单后，做一个动态减少数值的效果-->
                    <!--  <span class="bold-text minus-text" ref="minusValueRef">{{ minusValue }}</span>-->
                  </template>
                </el-table-column>
                <el-table-column label="已分配订单">
                  <template slot-scope="scope">
                    <el-button size="mini" type="text" @click="handleCheck">查看</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </el-card>
          </el-col>
          <!-- 右侧的订单选择-->
          <el-col :span="12">
            <!-- 展示读取的excel基本信息-->
            <el-card class="box-card">
              <div slot="header" class="clearfix">
                <span class="bold-text">订单列表(可分配)</span>
                <el-button style="float: right; padding: 3px 0" type="text" @click="handleResetOrderList">重置筛选
                </el-button>
              </div>
              <!--          订单选择模块-->
              <SelectGoods/>
            </el-card>
          </el-col>
        </el-row>
        <span slot="footer" class="dialog-footer">
        <el-button @click="invoiceAllVisible = false">取 消</el-button>
        <el-button type="primary" @click="invoiceAllVisible = false">确 定</el-button>
       </span>
      </el-dialog>
    </div>
  </div>
</template>

<style scoped lang="scss">
.sheet-container {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
}

.bold-text {
  font-weight: bold;
  color: #161617;
  font-size: 14px;
  line-height: 18px;
  display: inline-block;
}

.minus-text {
  margin-left: 12px;
  color: #ff0000;
  font-weight: bold;
  font-size: 14px;
  line-height: 20px;
}
</style>
