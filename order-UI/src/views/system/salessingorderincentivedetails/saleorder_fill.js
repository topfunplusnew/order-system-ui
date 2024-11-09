// handleFillOrderInfo


//  唱台
export var mixin_sing_order_fill = {
  data: function () {
    return {}
  },
  methods: {
    handleFillOrderInfo(value) {
      // 填充订单信息
      this.form.orderNo = value.ordersNo
      this.form.orderDate = value.orderDate
      // 填充奖励人员
      this.form.rewardReceiver = value.userName
      this.form.companyName = value.customer
      this.form.orderProfit = value.orderDetailList.reduce((pre, cur) => {
        return pre + (cur.profitNoTax || 0)
      }, 0)
    }
  }
}
