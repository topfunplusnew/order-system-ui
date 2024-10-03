import {getGoodsOrder} from "../../../../api/system/goodsOrder";

/**
 * 行操作点击查看的功能
 */
export var mixin_order_checkOrder = {
    data: function () {
        return {
            checkOrderVisible: false,
        }
    },
    methods: {
        //行操作中点击查看 查看当前行订单的信息
        checkOrderItemInfo(row) {
            const id = row.id;
            getGoodsOrder(id).then(res => {
                this.orderInfo = res.data
                this.orderDetailInfo = res.data.orderDetailList;
                this.checkOrderVisible = true;
            })
        },
        // 关闭查看订单的弹窗
        closeCheckOrderDialog() {
            this.checkOrderVisible = false
            this.reset()
        },
    },
}
