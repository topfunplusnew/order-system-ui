// 用于区分是否是订单开的运费还是库存开的运费
import FreeApply from '@/components/FreeApply.vue';

export const FREIGHT_TYPE = {
	GOODS_ORDER: 'goodsorder',
	INVENTORY: 'inventory'
};

export var mixin_freight_payment = {
	data: function () {
		return {};
	},
	methods: {
		// 进货单运费的付款
		handlePayment(row) {
			console.log(row);
			// 组装订单运费信息 己方银行卡信息弹窗自己选
			const freight = {
				ordersNo: row.id,
				freightType: '陆运',
				moneyAmount: row.landFreight,
				paymentState: '申请中',
				driverId: row.landCarID,
				carNo: row.landCarNo,
				fleet: row.fleet,
				driverName: row.landDriverName,
				// 区分订单还是库存开的运费字段
				source: FREIGHT_TYPE.INVENTORY
			};
			// 直接添加运费信息 统一在运费模块付款
			this.openDialog(
				FreeApply,
				'添加运费',
				'650px',
				{
					orderInfo: freight
				},
				false
			);
		}
	}
};
