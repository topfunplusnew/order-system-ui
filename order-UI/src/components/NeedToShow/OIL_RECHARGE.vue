<script>
export default {
  name: "OIL_RECHARGE",
  props: {
    needToShowInfo: {
      type: Object
    }
  }
}
</script>

<template>
  <div>
    <el-descriptions title="加油卡充值信息">
      <el-descriptions-item label="审核状态">{{ needToShowInfo.checkState }}</el-descriptions-item>
      <el-descriptions-item label="加油卡卡号">{{ needToShowInfo.oilCardNo }}</el-descriptions-item>
      <el-descriptions-item label="充值类型">{{ needToShowInfo.rechargeType }}</el-descriptions-item>
      <el-descriptions-item label="充值时间">{{ needToShowInfo.rechargeDate }}</el-descriptions-item>
      <el-descriptions-item label="银行开户名">{{ needToShowInfo.acountsName }}</el-descriptions-item>
      <el-descriptions-item label="银行账号">{{ needToShowInfo.bankNo }}</el-descriptions-item>
      <el-descriptions-item label="充值人员姓名">{{ needToShowInfo.rechargeName }}</el-descriptions-item>
    </el-descriptions>
  </div>
</template>

<style scoped lang="scss">

</style>
