<script>
import {getGoodsOrder} from "../../../../api/system/goodsOrder";

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
      selectedList: [],
    }
  },
  methods: {
    handleSelectionChange(selection) {
      this.selectedList = selection
    },
    submitSelectOrderDetail() {
      this.$emit('handleSelect', this.selectedList)
    },
  },
  computed: {}
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
              id="printBox" :cell-style="()=>{return {padding:'.5px'}}"
              max-height="700" size="mini">
      <el-table-column type="selection" width="70" align="center" fixed="left"/>
      <el-table-column label="id" align="center" prop="id" min-width="80"/>
      <el-table-column label="订单日期" align="center" prop="orderDate" min-width="100"/>
      <el-table-column label="客户" align="center" prop="customer" min-width="120"/>
      <el-table-column label="供应商" align="center" prop="supplier" min-width="150"/>
      <el-table-column label="级别编码" align="center" prop="levelID" min-width="100"/>
      <el-table-column label="级别名称" align="center" prop="levelName" min-width="120"/>
      <el-table-column label="计量单位" align="center" prop="countingUnit" min-width="100"/>
      <el-table-column label="厚度" align="center" prop="height" min-width="80"/>
      <el-table-column label="长度" align="center" prop="length" min-width="80"/>
      <el-table-column label="宽度" align="center" prop="width" min-width="80"/>
      <el-table-column label="出厂片数" align="center" prop="pieces" min-width="90"/>
      <el-table-column label="每包片数" align="center" prop="piecesPerPack" min-width="90"/>
      <el-table-column label="包数" align="center" prop="packs" min-width="70"/>
      <el-table-column label="出厂单价" align="center" prop="price" min-width="90"/>
      <el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.isIncludeTaxFactory === '否' ? 'danger' :'success'"
            disable-transitions>{{ scope.row.isIncludeTaxFactory }}
          </el-tag>
        </template>
      </el-table-column>
      <!-- 其他列保持类似 -->
      <el-table-column label="客户佣金" align="center" prop="customerCommission" min-width="90"/>
    </el-table>

  </div>
</template>

<style scoped lang="scss">

</style>
