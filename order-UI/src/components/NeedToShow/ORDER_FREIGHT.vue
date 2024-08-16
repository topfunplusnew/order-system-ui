<script>
export default {
  name: "ORDER_FREIGHT",
  props: {
    needToShowInfo: {
      type: Object
    }
  },
  data() {
    return {
      needToShow: {}
    }
  },
  watch: {
    needToShowInfo(val) {
      console.log('展示组件', val)
      this.needToShow = val
    }
  }
}
</script>

<template>
  <div>
    <el-descriptions title="订单运费信息">
      <el-descriptions-item label="运费类型">{{ needToShow.freightType }}</el-descriptions-item>
      <el-descriptions-item label="金额">{{ needToShow.moneyAmount }}</el-descriptions-item>
      <el-descriptions-item label="己方户名">{{ needToShow.selfAcountsName }}</el-descriptions-item>
      <el-descriptions-item label="己方账号">{{ needToShow.selfBankNo }}</el-descriptions-item>
      <el-descriptions-item label="己方开户行">{{ needToShow.selfBankName }}</el-descriptions-item>
      <el-descriptions-item label="对方户名">{{ needToShow.otherAcountsName }}</el-descriptions-item>
      <el-descriptions-item label="对方账号">{{ needToShow.otherBankNo }}</el-descriptions-item>
      <el-descriptions-item label="对方开户行">{{ needToShow.otherBankName }}</el-descriptions-item>
      <el-descriptions-item label="支付状态">{{ needToShow.paymentState }}</el-descriptions-item>
      <el-descriptions-item label="司机姓名">{{ needToShow.driverName }}</el-descriptions-item>
      <el-descriptions-item label="车牌号">{{ needToShow.CarNo }}</el-descriptions-item>
      <el-descriptions-item label="车队">{{ needToShow.fleet }}</el-descriptions-item>
      <el-descriptions-item label="付款人员姓名">{{ needToShow.payUserName }}</el-descriptions-item>
      <el-descriptions-item label="备注">{{ needToShow.comments }}</el-descriptions-item>
    </el-descriptions>
  </div>
</template>

<style scoped lang="scss">

</style>
