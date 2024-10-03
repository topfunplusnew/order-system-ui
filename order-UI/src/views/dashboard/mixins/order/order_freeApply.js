import {listOrderFreight} from "../../../../api/system/orderFreight";

/**
 *  运费申请
 */
export var mixin_order_freeApply = {
    data: function () {
        return {
            /**
             * 海陆运费申请信息 海陆运费申请功能
             */
            //订单中的司机相关信息 自动填充响应的收款方账号信息
            driverInfo: {},
            //运费
            landFreightFree: 0,
            seaFreightFree: 0,
            landFreightInfo: {},
            seaFreightInfo: {},
            //运费的弹窗
            landFreeDialogVisible: false,
            seaFreeDialogVisible: false,
        }
    },
    methods: {

        /**
         *  海陆运费申请功能
         */
        //申请陆运费
        handleApplyLandFree(row) {
            //组装订单运费信息 己方银行卡信息弹窗自己选
            this.landFreightInfo = {
                ordersNo: row.ordersNo,
                freightType: '陆运',
                moneyAmount: row.landFreight,
                otherAcountsName: row.landDriverName,
                otherBankNo: row.landBankNo,
                otherBankName: row.landBankName,
                paymentState: '申请中',
                driverName: row.landDriverName,
                driverId: row.landCarID,
                carNo: row.landCarNo,
                fleet: row.fleet,
            }
            //首先去运费表查看是否有运费信息
            listOrderFreight({...this.landFreightInfo, paymentState: '未支付'}).then(res => {
                if (res.rows.length === 0) {
                    this.landFreightFree = row.landFreight
                    //组装司机信息
                    this.driverInfo = {
                        otherAcountsName: row.landDriverName,
                        companyName: null,
                        isExit: true,//用这个字段来表示有司机信息
                    }
                    this.landFreeDialogVisible = true;
                } else {
                    this.$message.error('该订单已有陆运费信息!!!')
                }
            })
        },
        //申请海运费
        handleApplySeaFree(row) {
            //组装海运费信息
            this.seaFreightInfo = {
                ordersNo: row.ordersNo,
                freightType: '海运',
                moneyAmount: row.seaFreight,
                otherAcountsName: row.seaDriverName,
                otherBankNo: row.seaBankNo,
                otherBankName: row.seaBankName,
                paymentState: '申请中',
                driverName: row.seaDriverName,
                driverId: row.seaCarID,
                carNo: row.seaCarNo,
                fleet: '',
            }
            listOrderFreight({...this.seaFreightInfo, paymentState: '未支付'}).then(res => {
                if (res.rows.length === 0) {
                    this.seaFreightFree = row.seaFreight
                    this.driverInfo = {
                        otherAcountsName: row.seaDriverName,
                        companyName: null,
                        isExit: true,
                    }
                    this.seaFreeDialogVisible = true;
                } else {
                    this.$message.error('该订单已有运费信息!!!')
                }
            })

        },
    },
}
