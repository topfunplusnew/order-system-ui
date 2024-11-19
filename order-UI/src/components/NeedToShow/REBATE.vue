<script>
export default {
  name: "REBATE",
  props: {
    needToShowInfo: {
      type: Object
    }
  }
}
</script>

<template>
  <div>
    <el-card>
      <el-descriptions title="返利信息">
        <el-descriptions-item label="返利金额">{{ needToShowInfo.rebate }} 元</el-descriptions-item>
        <el-descriptions-item label="返利日期">{{
            new Date(needToShowInfo.rebateDate).toLocaleString()
          }}
        </el-descriptions-item>
        <el-descriptions-item label="返利类型">{{ needToShowInfo.rebateType }}</el-descriptions-item>
        <el-descriptions-item label="返利原因">{{ needToShowInfo.rebateReason }}</el-descriptions-item>
        <el-descriptions-item label="供应商">{{ needToShowInfo.supplier }}</el-descriptions-item>
        <el-descriptions-item label="入账账户名称">{{ needToShowInfo.inAcountsName }}</el-descriptions-item>
        <el-descriptions-item label="入账银行账号">{{ needToShowInfo.inBankNo }}</el-descriptions-item>
        <el-descriptions-item label="出账账户名称">{{ needToShowInfo.outAcountsName }}</el-descriptions-item>
        <el-descriptions-item label="出账银行账号">{{ needToShowInfo.outBankNo }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ needToShowInfo.comments || '无' }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

  </div>
</template>

<style scoped lang="scss">

</style>
