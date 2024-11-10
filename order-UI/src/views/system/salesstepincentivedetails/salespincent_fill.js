// handleFillOrderInfo


// 台阶
export var mixin_step_order_fill = {
  data: function () {
    return {}
  },
  methods: {
    //  填充订单信息 包含日期 业务员(UserName) 客户名称 不含税利润
    handleFillOrderInfo(value) {
      this.form.orderNo = value.ordersNo
      this.form.orderDate = value.orderDate
      this.form.salesPerson = value.userName
      this.form.companyName = value.customer
      this.form.orderProfit = value.orderDetailList.reduce((pre, cur) => {
        return pre + (cur.profitNoTax || 0)
      }, 0)

      // 填充id和type
      this.form.customerId = value.customerID
      this.form.customerType = '客户'
    }
  }
}
