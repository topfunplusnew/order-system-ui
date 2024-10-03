/**
 *  点击订单的发货单按钮 查看发货单
 */
export var mixin_order_deliverGoods = {
    data: function () {
        return {
            // 发货单功能
            Order1Visible: false,
        }
    },
    methods: {
        // 订单发货单
        handleOrder1(row) {
            this.Order1Visible = true
        },
        // 关闭发货单的弹窗
        closeOrderGivenDialog() {
            this.Order1Visible = false;
        },
    },
}
