import OrderGiven from '@/views/dashboard/components/goodsOrder/OrderGiven.vue';
import { getSameDayOrders } from '@/api/system/goodsOrder';

/**
 *  点击订单的发货单按钮 查看发货单
 */
export var mixin_order_deliverGoods = {
	methods: {
		// 订单发货单1
		async handleOrder1(row) {
			try {
				const res = await getSameDayOrders(row.id);
				if (res.code === 200 && res.data && res.data.length > 0) {
					const allOrderDetails = [];
					res.data.forEach(order => {
						if (order.orderDetailList && order.orderDetailList.length > 0) {
							allOrderDetails.push(...order.orderDetailList);
						}
					});
					this.openDialog(
						OrderGiven,
						'销货发货单',
						'1050px',
						{
							type: 1,
							orderGivenInfo: row,
							mergedOrderDetails: allOrderDetails
						},
						true
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
					const allOrderDetails = [];
					res.data.forEach(order => {
						if (order.orderDetailList && order.orderDetailList.length > 0) {
							allOrderDetails.push(...order.orderDetailList);
						}
					});
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
					const allOrderDetails = [];
					res.data.forEach(order => {
						if (order.orderDetailList && order.orderDetailList.length > 0) {
							allOrderDetails.push(...order.orderDetailList);
						}
					});
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
