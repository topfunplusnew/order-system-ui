export var mixin_receive_money_fill = {
  data: function () {
    return {
      // 客户银行卡搜索
      queryCustomerBank: ''
    }
  },
  methods: {
    handleUpdateQueryNameCustomer(val) {
      this.queryCustomerBank = val;
    }
  }
}
