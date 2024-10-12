import instance from "../../../../utils/request";

export function paymentAudit(params) {
  return instance.request({
    url: '/system/payment/audit',
    method: 'put',
    params: {
      id: params.id,
      auditStatus: params.auditStatus
    }
  })
}

export var mixin_payment_audit = {
  data: function () {
    return {}
  },

  methods: {
    handlePaymentAudit(row) {
      this.$confirm('是否复核该付款信息?', '提示', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        paymentAudit({...row, auditStatus: '1'}).then(res => {
          this.$message({
            type: 'success',
            message: '审核成功!'
          });
          location.reload()
        })
      })
    }
  },
}
