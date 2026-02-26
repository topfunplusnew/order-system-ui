import OrderGiven from '@/views/dashboard/components/goodsOrder/OrderGiven.vue';
import { getSameDayOrders } from '@/api/system/goodsOrder';
import _ from 'lodash';

/**
 *  点击订单的发货单按钮 查看发货单
 */
export var mixin_order_deliverGoods = {
	methods: {
		/**
		 * 根据同日订单数据构建带车号/柜号信息的合并明细列表
		 * 不同订单的明细保留各自主表上的车号字段，便于在发货单表格中逐行展示。
		 * @param {Array<Object>} orders 同一天的订单列表
		 * @returns {Array<Object>} 带有车号/柜号信息的订单明细数组
		 */
		buildMergedOrderDetailsWithCarInfo(orders) {
			if (!Array.isArray(orders) || orders.length === 0) {
				return [];
			}
			var allOrderDetails = [];
			orders.forEach(function (order) {
				if (!order || !Array.isArray(order.orderDetailList) || order.orderDetailList.length === 0) {
					return;
				}
				var currentLandCarNo = order.landCarNo;
				var currentSeaCarNo = order.seaCarNo;
				var currentSeaDriverName = order.seaDriverName;
				var detailsWithCarInfo = _.map(order.orderDetailList, function (detail) {
					var detailCopy = _.cloneDeep(detail) || {};
					detailCopy.landCarNo = currentLandCarNo;
					detailCopy.seaCarNo = currentSeaCarNo;
					detailCopy.seaDriverName = currentSeaDriverName;
					return detailCopy;
				});
				allOrderDetails.push.apply(allOrderDetails, detailsWithCarInfo);
			});
			return allOrderDetails;
		},
		// 订单发货单1
		async handleOrder1(row) {
			try {
				const res = await getSameDayOrders(row.id);
				if (res.code === 200 && res.data && res.data.length > 0) {
					const allOrderDetails = this.buildMergedOrderDetailsWithCarInfo(res.data);
					this.openDialog(
						OrderGiven,
						'销货发货单',
						'1050px',
						{
							type: 1,
							orderGivenInfo: row,
							mergedOrderDetails: allOrderDetails
						},
						true,
						false
					);
				} else {
					this.$message.warning('暂无发货单数据');
				}
			} catch (error) {
				this.$message.error('获取发货单数据失败');
			}
		},
		// 发货单2
		async handleOrder2(row) {
			try {
				const res = await getSameDayOrders(row.id);
				console.log(res);
				if (res.code === 200 && res.data && res.data.length > 0) {
					const allOrderDetails = this.buildMergedOrderDetailsWithCarInfo(res.data);
					this.openDialog(
						OrderGiven,
						'发货单2',
						'1050px',
						{
							type: 2,
							orderGivenInfo: row,
							mergedOrderDetails: allOrderDetails
						},
						true
					);
				} else {
					this.$message.warning('暂无发货单2数据');
				}
			} catch (error) {
				this.$message.error('获取发货单2数据失败');
			}
		},
		// 发货单3
		async handleOrder3(row) {
			try {
				const res = await getSameDayOrders(row.id);
				if (res.code === 200 && res.data && res.data.length > 0) {
					const allOrderDetails = this.buildMergedOrderDetailsWithCarInfo(res.data);
					this.openDialog(
						OrderGiven,
						'发货单3',
						'1050px',
						{
							type: 3,
							orderGivenInfo: row,
							mergedOrderDetails: allOrderDetails
						},
						true
					);
				} else {
					this.$message.warning('暂无发货单3数据');
				}
			} catch (error) {
				this.$message.error('获取发货单3数据失败');
			}
		}
	}
};
