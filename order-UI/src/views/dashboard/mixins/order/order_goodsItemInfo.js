import { getGoodsOrder } from '../../../../api/system/goodsOrder';
import OrderDetailInfo from '@/views/dashboard/components/goodsOrder/OrderDetailInfo.vue';

/**
 *  行操作中点击货物按钮，查看该订单的货物信息
 */
export var mixin_order_goodsItemInfo = {
	data: function () {
		return {
			/**
			 * 查看货物信息功能
			 */
			// 查看订单中的列表
			orderDetailInfo: {},
			checkOrderDetailInfoVisible: false,
			orderDetailInfoList: []
		};
	},
	methods: {
		handleCheckOrderDetailInfo(row) {
			// 赋值 以便于给子组件id
			sessionStorage.setItem('order_id', row.id);
			// 查询该订单的订单详情，根据id查询  然后扔到暂存里
			getGoodsOrder(row.id).then(res => {
				this.orderDetailInfoList = res.data.orderDetailList;
				// 打开弹窗
				this.openDialog(OrderDetailInfo, '查看订单货物', '1300px', {
					orderDetailInfoList: this.orderDetailInfoList,
					ban: false
				});
			});
		},
		// 当订单详情组件删除个体后，这里要进行刷新列表操作
		handleUpdateOrderDetailInfoList(order_id) {
			getGoodsOrder(order_id).then(res => {
				this.orderDetailInfoList = res.data.orderDetailList;
			});
		}
	}
};
