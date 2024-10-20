<template>
  <el-dialog :close-on-click-modal="false" :show-close="false" title="订单打款申请" :visible.sync="paymentApplyVisible" width="48%">
    <keep-alive>
      <ApplyPayment :table-name="TableName.GOODS_ORDER" :t-i-d="tID" :need-money="needMoney"
                    :need-info="{}"
                    @changeupdateOrderItemVisible="handleCloseApply"/>
    </keep-alive>
  </el-dialog>
</template>
<script>
import ApplyPayment from "@/views/dashboard/components/common/ApplyPayment.vue"

export default {
  name: 'OrderMoneyReceive',
  components: {ApplyPayment},
  props: {
    TableName: {},
    handleCloseApply: {},
    needMoney: {},
    paymentApplyVisible: {},
    tID: {}
  },
  methods: {
  }
}
</script>
