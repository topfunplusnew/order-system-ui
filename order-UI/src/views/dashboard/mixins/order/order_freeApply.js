import { listOrderFreight } from '../../../../api/system/orderFreight';
import FreeApply from '@/components/FreeApply.vue';
import { FREIGHT_TYPE } from '@/views/dashboard/mixins/freight/freight_payment';

/**
 *  运费申请
 */
export var mixin_order_freeApply = {
	data: function () {
		return {};
	},
	methods: {
		/**
		 *  海陆运费申请功能
		 */
		// 申请陆运费
		handleApplyLandFree(row) {
			// 组装订单运费信息 己方银行卡信息弹窗自己选
			const landFreightInfo = {
				ordersNo: row.ordersNo,
				freightType: '陆运',
				moneyAmount: row.landFreight,
				// fixme 待完善 这个地方 用的是订单信息中的司机名称 而非银行卡户名
				otherAcountsName: row.landDriverName,
				otherBankNo: row.landBankNo,
				otherBankName: row.landBankName,
				paymentState: '申请中',
				driverName: row.landDriverName,
				driverId: row.landCarID,
				carNo: row.landCarNo,
				fleet: row.fleet,
				// 区分订单还是库存开的运费字段
				source: FREIGHT_TYPE.GOODS_ORDER
			};
			// 首先去运费表查看是否有运费信息 查找list接口中 未支付的运费信息 如果运费信息存在 那么就提示已经有运费信息
			listOrderFreight({ ...landFreightInfo, paymentState: '未支付' }).then(
				res => {
					if (res.rows.length === 0) {
						// 打开弹窗
						this.openDialog(FreeApply, '添加陆运费', '600px', {
							orderInfo: landFreightInfo
						});
					} else {
						this.$message.error('该订单已有陆运费信息!!!');
					}
				}
			);
		},
		// 申请海运费
		handleApplySeaFree(row) {
			// 组装海运费信息
			const seaFreightInfo = {
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
				// 区分订单还是库存开的运费字段
				source: FREIGHT_TYPE.GOODS_ORDER
			};
			listOrderFreight({ ...seaFreightInfo, paymentState: '未支付' }).then(
				res => {
					if (res.rows.length === 0) {
						// 打开弹窗
						this.openDialog(FreeApply, '添加海运费', '600px', {
							orderInfo: seaFreightInfo
						});
					} else {
						this.$message.error('该订单已有运费信息!!!');
					}
				}
			);
		}
	}
};
