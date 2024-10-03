import {getHistoryGoodsOrder} from "../../../../api/system/goodsOrder";
import {excludeParams} from "../../../../api/tool/exclude";

/**
 * 2.查看订单历史修改记录功能
 */
export var mixin_order_orderHistory = {
    data: function () {
        return {
            /**
             * 查看订单历史信息
             */
            checkHistoryOrderVisible: false,
            // 订单历史信息列表
            orderHistoryInfoList: [],
            activeNames: [],
            // 订单详情映射对象 然后每一个订单的详情列表都按照这个映射以后进行比较渲染
            /**
             * 查看原订单信息的功能
             */
            currentOrderItemInfo: {},
            currentOrderItemInfoVisible: false,
        }
    },
    methods: {
        // 查看原订单信息
        checkcurrentOrderItemInfo() {
            this.currentOrderItemInfoVisible = true;
        },
        // 查看订单历史信息
        checkOrderHistory(row) {
            // 保存原订单的信息
            this.currentOrderItemInfo = JSON.parse(JSON.stringify(row));
            const id = row.id;
            // 查询订单历史信息
            getHistoryGoodsOrder({goodsOrderID: id}).then(res => {
                if (res.rows.length === 0) {
                    this.$message.warning('没有修改记录')
                    return;
                }
                this.orderHistoryInfoList = res.rows;
                for (let i = 0; i < this.orderHistoryInfoList.length - 1; i++) {
                    this.orderHistoryInfoList[i].diff = {
                        old: this.formatData(excludeParams(this.orderHistoryInfoList[i], this.$excludeWithUpdate)),
                        new: this.formatData(excludeParams(this.orderHistoryInfoList[i + 1], this.$excludeWithUpdate)),
                        updateTime: this.parseTime(this.orderHistoryInfoList[i + 1].updateTime)
                    }
                }
                if (this.orderHistoryInfoList.length > 0) {
                    this.orderHistoryInfoList[this.orderHistoryInfoList.length - 1].diff = {
                        old: this.formatData(excludeParams(this.orderHistoryInfoList[this.orderHistoryInfoList.length - 1], this.$excludeWithUpdate)),
                        new: this.formatData(excludeParams(this.currentOrderItemInfo, this.$excludeWithUpdate)),
                        updateTime: this.parseTime(this.currentOrderItemInfo.updateTime)
                    }
                }
                this.checkHistoryOrderVisible = true;
            })
        },
        // 关闭历史订单的弹窗
        closeOrderHistoryCheck() {
            this.checkHistoryOrderVisible = false
        },
        // 关闭查看原始订单
        closePrimativeOrderInfo() {
            this.currentOrderItemInfoVisible = false
        },
    },
}
