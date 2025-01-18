import { addReason } from '../../../../api/system/user';
import { TableName } from '../../../../api/tool/enums';
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
			// 获取当前订单日期的时间戳
			const orderTimestamp = new Date(row.orderDate).getTime();
			// 设置时间为当天的 00:00:00
			const today = new Date();
			today.setHours(0, 0, 0, 0);
			const todayTimestamp = today.getTime();

			// 如果订单的日期和今天的日期相差超过一天
			const diffInMs = Math.abs(orderTimestamp - todayTimestamp);
			const oneDayInMs = 1000 * 60 * 60 * 24; // 一天的毫秒数

			if (diffInMs < oneDayInMs) {
				// 打开弹窗
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
			} else {
				this.$prompt('请输入编辑订单原因', '提示', {
					confirmButtonText: '确定',
					cancelButtonText: '取消',
					type: 'warning'
				})
					.then(({ value }) => {
						addReason({
							reason: value,
							tableName: TableName.GOODS_ORDER,
							tid: row.id,
							modifyTime: this.modifyTime
						}).then(() => {
							// 先暂存订单修改原因
							sessionStorage.setItem('order-edit-reason', value);
							this.$message.success('提交成功');
							// 打开弹窗
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
						});
					})
					.catch(() => {
						this.$message({
							type: 'warning',
							message: '请先输入编辑原因!'
						});
					});
			}
		}
	}
};
