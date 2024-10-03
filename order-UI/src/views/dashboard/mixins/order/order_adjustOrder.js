import {adjustGoodsOrder, getGoodsOrder} from "../../../../api/system/goodsOrder";
import {excludeParams} from "../../../../api/tool/exclude";
import {parseTime} from "../../../../utils/ruoyi";

/**
 * 调整单功能
 */
export var mixin_order_adjustOrder = {
    data: function () {
        return {
            /**
             * 调整单功能
             */
            //调整单的id`
            tempId: '',
            //调整单的弹窗
            handleOrderVisible: false,
            //订单信息
            orderInfo: {},
        }
    },
    methods: {
        /**
         *  4.点击调整单按钮，调整订单
         */
        //点击调整单的弹窗
        handleOrderItemInfo(row) {
            this.handleOrderVisible = true
            this.tempId = row.id;
        },
        // 调整单
        submitChangeOrder() {
            const id = this.tempId  // 拿到上个方法赋值的状态
            // 查询该id的订单详细信息
            getGoodsOrder(id).then(res => {
                // 调整单 调用调整订单接口 传入数据 将ordersNo赋值为空 后端自动填充
                let orderInfo = res.data
                // 将每个货物信息的ordersNo赋值为空 并且去除不必要的参数
                orderInfo.orderDetailList.forEach(item => {
                    item.ordersNo = '';
                    item = excludeParams(item, this.$exclude)
                })
                // 去除字段
                orderInfo = excludeParams(orderInfo, this.$exclude)
                // 调整单
                adjustGoodsOrder({...orderInfo, ordersNo: '', adjustDate: parseTime(new Date())}).then(res => {
                    this.$message.success('调整单提交成功')
                    this.getList();
                })
                this.handleOrderVisible = false
            })
        },
    },
}
