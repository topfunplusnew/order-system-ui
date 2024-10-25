/**
 * 订单申请打款功能
 */

export var mixin_order_applyPayment = {
  data: function () {
    return {
      tID: '',
      paymentApplyVisible: false,
      needMoney: 0,
    }
  },
  methods: {
    // 订单申请打款
    applyForPayment(row) {
      this.paymentApplyVisible = true;
      this.tID = row.id;
    },
    handleCloseApply() {
      this.needMoney = 0
      this.paymentApplyVisible = false
      this.getList()
    },
  },
}
