import OrderForm from '@/views/dashboard/components/goodsOrder/OrderForm.vue';

/**
 * 添加或者修改订单的功能
 */
export var mixin_order_add = {
	data: function () {
		return {
			// 当前订单id
			orderId: null,
			// 添加新订单的弹窗
			orderItemVisible: false,
			orderTitle: '',
			submitInfo: ''
		};
	},
	methods: {
		// 新增按钮操作
		handleAdd() {
			// 打开弹窗
			this.openDialog(
				OrderForm,
				'添加订单',
				'1300px',
				{
					orderId: null,
					submitInfo: '添加订单'
				},
				false
			);
		},
		// 修改订单的操作
		handleUpdate(row) {
			// 直接打开弹窗，修改原因在表单中填写
			this.openDialog(
				OrderForm,
				'修改订单',
				'1300px',
				{
					orderId: row.id,
					submitInfo: '修改订单'
				},
				false
			);
		}
	}
};
