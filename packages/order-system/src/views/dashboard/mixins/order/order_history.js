import { getGoodsOrder, getHistoryGoodsOrder } from '../../../../api/system/goodsOrder';
import { excludeParams } from '../../../../api/tool/exclude';

/**
 * 2.查看订单历史修改记录功能
 */
export var mixin_order_orderHistory = {
	data: function () {
		return {
			/**
			 * 查看订单历史信息
			 */
			checkHistoryOrderVisible: false,
			// 订单历史信息列表
			orderHistoryInfoList: [],
			// 订单详情映射对象 然后每一个订单的详情列表都按照这个映射以后进行比较渲染
			/**
			 * 查看原订单信息的功能
			 */
			currentOrderItemInfo: {},
			currentOrderItemInfoVisible: false
		};
	},
	methods: {
		// 查看订单历史信息
		checkOrderHistory(row) {
			const id = row.id;
			// 先获取原订单的信息
			getGoodsOrder(row.id).then(res => {
				this.currentOrderItemInfo = res.data;
				// 获取订单修改记录信息
				getHistoryGoodsOrder({ goodsOrderID: id }).then(res => {
					if (res.total === 0) {
						this.$message.warning('无订单历史信息');
						return;
					}
					this.orderHistoryInfoList = [];
					let array = res.rows;

					array.unshift(JSON.parse(JSON.stringify(row)));

					for (let i = array.length - 1; i > 0; i--) {
						const item = array[i];
						const new_item = array[i - 1];
						this.orderHistoryInfoList.push({
							diff: {
								old: this.format(excludeParams(item, this.$excludeWithUpdate)),
								new: this.format(excludeParams(new_item, this.$excludeWithUpdate)),
								updateTime: item.updateTime,
								userName: item.userName,
								remark: item.remark
							}
						});
					}
					this.orderHistoryInfoList.reverse();
					this.checkHistoryOrderVisible = true;
				});
			});
			// 查询订单历史信息
		},
		format(data) {
			return this.formatData(excludeParams(data, this.$excludeWithUpdate));
		},
		// 关闭历史订单的弹窗
		closeOrderHistoryCheck() {
			this.checkHistoryOrderVisible = false;
		},
		// 关闭查看原始订单
		closePrimativeOrderInfo() {
			this.currentOrderItemInfoVisible = false;
		}
	}
};
