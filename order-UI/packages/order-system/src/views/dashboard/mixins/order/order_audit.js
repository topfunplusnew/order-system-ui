/**
 * 订单审核功能 点击后审核订单
 */
import { auditGoodsOrder } from '../../../../api/system/goodsOrder';

export var mixin_order_audit = {
	data: function () {
		return {};
	},
	methods: {
		// 订单审核
		handleCheck(row) {
			// 弹出确认和取消
			this.$antdconfirm({
				title: '提示',
				content: '是否审核该信息?',
				okText: '确定',
				cancelText: '取消',
				zIndex: 2600,
				onOk: () => {
					// 修改审核状态
					auditGoodsOrder({ id: row.id, isaudit: true }).then(res => {
						this.$message.success('操作成功~!');
						this.getList();
					});
				}
			});
		}
	}
};
