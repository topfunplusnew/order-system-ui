<script>
export default {
  name: "OrderDetailList",
  props: {
    orderDetailList: {
      type: Array,
      default: []
    },
  },
  data() {
    return {
      loading: false,
      selectedList: []
    }
  },
  methods: {
    handleSelectionChange(selection) {
      this.selectedList = selection
    },
    submitSelectOrderDetail() {
      this.$emit('handleSelect', this.selectedList)
    }
  }
}
</script>

<template>
  <div>
    <el-button @click="submitSelectOrderDetail" :disabled="orderDetailList.length === 0" type="success" size="mini">
      选择所选货物
    </el-button>
    <el-table border
              v-horizontal-scroll="'always'"
              v-loading="loading"
              :data="orderDetailList"
              @selection-change="handleSelectionChange"
              id="printBox"
              max-height="700">
      <el-table-column type="selection" width="55" align="center" fixed="left"/>
      <el-table-column label="id" align="center" prop="id" fixed="left"/>
      <el-table-column label="订单日期" align="center" prop="orderDate" fixed="left"/>
      <el-table-column label="客户" align="center" prop="customer" fixed="left"/>
      <el-table-column label="供应商" align="center" prop="supplier" fixed="left"/>
      <el-table-column label="级别编码" align="center" prop="levelID"/>
      <el-table-column label="级别名称" align="center" prop="levelName"/>
      <el-table-column label="计量单位" align="center" prop="countingUnit"/>
      <el-table-column label="厚度" align="center" prop="height"/>
      <el-table-column label="长度" align="center" prop="length"/>
      <el-table-column label="宽度" align="center" prop="width"/>
      <el-table-column label="出厂片数" align="center" prop="pieces"/>
      <el-table-column label="每包片数" align="center" prop="piecesPerPack"/>
      <el-table-column label="包数" align="center" prop="packs"/>
      <el-table-column label="出厂单价" align="center" prop="price"/>
      <el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.isIncludeTaxFactory === '否' ? 'danger' :'success'"
            disable-transitions>{{ scope.row.isIncludeTaxFactory }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="杂费" align="center" prop="sundryCost"/>
      <el-table-column label="出厂货款" align="center" prop="paymentFactory"/>
      <el-table-column label="卸货价" align="center" prop="paymentUnload"/>
      <el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.isIncludeTaxSale === '否' ? 'danger' :'success'"
            disable-transitions>{{ scope.row.isIncludeTaxSale }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="总货款" align="center" prop="payments"/>
      <el-table-column label="误差" align="center" prop="erro"/>
      <el-table-column label="吨位" align="center" prop="tonnage"/>
      <el-table-column label="陆运费单价" align="center" prop="landFreightPrice"/>
      <el-table-column label="陆运费" align="center" prop="landFreight"/>
      <el-table-column label="海运费" align="center" prop="seaFreight"/>
      <el-table-column label="总运费" align="center" prop="freight"/>
      <el-table-column label="其他费用" align="center" prop="otherCost"/>
      <el-table-column label="利润" align="center" prop="profit"/>
      <el-table-column label="不含税利润" align="center" prop="profitNoTax"/>
      <el-table-column label="实际片数" align="center" prop="actualPieces"/>
      <el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry"/>
      <el-table-column label="加费" align="center" prop="additionalFees"/>
      <el-table-column label="仓库名称" align="center" prop="storeHouseName"/>
      <el-table-column label="物流利润" align="center" prop="logisticsProfit"/>
      <el-table-column label="客户佣金" align="center" prop="customerCommission"/>
    </el-table>
  </div>
</template>

<style scoped lang="scss">

</style>
