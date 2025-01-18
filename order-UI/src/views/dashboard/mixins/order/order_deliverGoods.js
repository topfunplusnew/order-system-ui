import OrderGiven from '@/views/dashboard/components/goodsOrder/OrderGiven.vue';

/**
 *  点击订单的发货单按钮 查看发货单
 */
export var mixin_order_deliverGoods = {
	methods: {
		// 订单发货单1
		handleOrder1(row) {
			this.openDialog(
				OrderGiven,
				'销货发货单',
				'1050px',
				{
					type: 1,
					orderGivenInfo: row
				},
				true
			);
		},
		// 发货单2
		handleOrder2(row) {
			this.openDialog(
				OrderGiven,
				'发货单2',
				'1050px',
				{
					type: 2,
					orderGivenInfo: row
				},
				true
			);
		},
		// 发货单3
		handleOrder3(row) {
			this.openDialog(
				OrderGiven,
				'发货单3',
				'1050px',
				{
					type: 3,
					orderGivenInfo: row
				},
				true
			);
		}
	}
};
