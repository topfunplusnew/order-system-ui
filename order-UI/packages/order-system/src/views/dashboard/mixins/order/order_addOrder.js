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
			this.$prompt('请输入修改原因', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				inputType: 'textarea',
				inputPlaceholder: '请输入修改原因',
				inputValidator: value => {
					if (!value || value.trim() === '') {
						return '修改原因不能为空';
					}
					return true;
				}
			})
				.then(({ value }) => {
					// 将修改原因存储到sessionStorage
					sessionStorage.setItem('goodsorder-edit-reason', value);
					
					// 打开OrderForm弹窗
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
				})
				.catch(() => {
					this.$message({
						type: 'info',
						message: '已取消修改'
					});
				});
		}
	}
};
