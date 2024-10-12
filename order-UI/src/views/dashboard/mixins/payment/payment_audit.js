import instance from "../../../../utils/request";

export function paymentAudit(params) {
  return instance.request({
    url: '/system/payment/audit',
    method: 'put',
    params: {
      id: params.id,
      auditStatus: params.auditStatus
    },
  })
}

export var mixin_payment_audit = {
  data: function () {
    return {}
  },

  methods: {
    handlePaymentAudit(row, e) {
      if (e === true) {
        paymentAudit({...row, auditStatus: '1'}).then(res => {
          this.$message({
            type: 'success',
            message: '复核成功!'
          });
          location.reload()
        })
      } else {
        paymentAudit({...row, auditStatus: '0'}).then(res => {
          this.$message({
            type: 'success',
            message: '取消复核!'
          });
          location.reload()
        })
      }
    }
  },
}
