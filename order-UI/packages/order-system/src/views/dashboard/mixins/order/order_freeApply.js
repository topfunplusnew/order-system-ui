import FreeApply from '@/components/FreeApply.vue';
import { getCars } from '../../../../api/system/cars';
import { FreightSource } from '../../../../api/tool/enums';
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
			let source = null;
			if (row.source === '订单' || row.source === '调整单') source = FreightSource.GOODS_ORDER;
			else source = FreightSource.INVENTORY_MAIN;

			getCars(row.car_id).then(res => {
				if (!res.data) {
					this.$message.error('请先添加车辆信息');
					return;
				}
				// 组装订单运费信息 我方银行卡信息弹窗自己选
				const landFreightInfo = {
					ordersNo: row.source_id,
					freightType: row.transport_type === 'sea' ? '海运' : '陆运',
					moneyAmount: row.freight,
					otherAcountsName: res.data.acountsName,
					otherBankNo: res.data.bankNo,
					otherBankName: res.data.bankName,
					paymentState: '申请中',
					driverName: res.data.driver,
					driverId: row.car_id,
					carNo: res.data.carNo,
					fleet: row.fleet,
					source: source
				};
				// 打开弹窗
				this.openDialog(
					FreeApply,
					'添加陆运费',
					'600px',
					{
						orderInfo: landFreightInfo
					},
					false
				);
			});
		},
		// 申请海运费
		handleApplySeaFree(row) {
			let source = null;
			if (row.source === '订单' || row.source === '调整单') source = FreightSource.GOODS_ORDER;
			else source = FreightSource.INVENTORY_MAIN;
			// 首先获取车辆信息
			getCars(row.car_id).then(res => {
				if (!res.data) {
					this.$message.error('请先添加车辆信息');
					return;
				}
				// 组装海运费信息
				const seaFreightInfo = {
					ordersNo: row.source_id,
					freightType: row.transport_type === 'sea' ? '海运' : '陆运',
					moneyAmount: row.freight,
					// 对方银行卡信息
					otherAcountsName: res.data.acountsName,
					otherBankNo: res.data.bankNo,
					otherBankName: res.data.bankName,
					paymentState: '申请中',
					driverName: res.data.driver,
					driverId: row.car_id,
					carNo: res.data.carNo,
					fleet: row.fleet,
					// 区分订单还是库存开的运费字段
					source: source
				};
				// 打开弹窗
				this.openDialog(
					FreeApply,
					'添加海运费',
					'600px',
					{
						orderInfo: seaFreightInfo
					},
					false
				);
			});
		}
	}
};
