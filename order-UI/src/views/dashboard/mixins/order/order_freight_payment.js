// 运费一键申请
export var mixin_order_freight_payment = {
  data: function () {
    return {}
  },
  computed: {
    freightPaymentOnceDisabled() {
      return this.ids.length <= 0;
    }
  },
  methods: {
    // 一键申请运费
    handleFreightPaymentOnce(row) {
      alert('功能未实现')
    },
  },
}
