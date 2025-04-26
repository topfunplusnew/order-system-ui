import { adjustGoodsOrder, getGoodsOrder } from '../../../../api/system/goodsOrder';
import { excludeParams } from '../../../../api/tool/exclude';
import { parseTime } from '../../../../utils/ruoyi';

/**
 * 调整单功能
 */
export var mixin_order_adjustOrder = {
	data: function () {
		return {
			// 订单信息
			orderInfo: {}
		};
	},
	methods: {
		// 点击调整单的弹窗
		handleOrderItemInfo(row) {
			this.$confirm({
				title: '提示',
				content: '是否将该订单设置为调整单',
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: async () => {
					try {
						const id = row.id;
						const res = await getGoodsOrder(id);
						let orderInfo = res.data;
						orderInfo.orderDetailList.forEach(item => {
							Object.assign(item, excludeParams(item, this.$exclude));
						});
						orderInfo = excludeParams(orderInfo, this.$exclude);
						await adjustGoodsOrder({ ...orderInfo });
						this.$message.success('调整单提交成功');
						this.getList();
					} catch (error) {
						this.$message.error('调整单提交失败，请重试');
					}
				},
				onCancel: () => {
					this.$message.info('已取消调整单操作');
				}
			});
		}
	}
};
