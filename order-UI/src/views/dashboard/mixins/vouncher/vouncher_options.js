import {getGoodsOrder} from "../../../../api/system/goodsOrder";

export var mixin_vouncher_options = {
  data() {
    return {
      goodsOrderVisible: false,
      orderInfo: {}
    }
  },
  methods: {
    // 查看该凭证信息
    handleView() {

    },
    // 查看订单列表信息
    handleGoodsOrder(row) {
      getGoodsOrder(row.pid).then(res => {
        this.orderInfo = res.data
        this.goodsOrderVisible = true
      })
    }
  }
}
