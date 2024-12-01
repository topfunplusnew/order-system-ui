import {
	getGoodsOrder,
	getHistoryGoodsOrder
} from '../../../../api/system/goodsOrder';
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
			activeNames: [],
			// 订单详情映射对象 然后每一个订单的详情列表都按照这个映射以后进行比较渲染
			/**
			 * 查看原订单信息的功能
			 */
			currentOrderItemInfo: {},
			currentOrderItemInfoVisible: false
		};
	},
	methods: {
		// 查看原订单信息
		checkcurrentOrderItemInfo() {
			this.currentOrderItemInfoVisible = true;
		},
		// 查看订单历史信息
		checkOrderHistory(row) {
			console.log('行数据:', row);
			const id = row.id;
			// 先获取原订单的信息
			getGoodsOrder(id).then(res => {
				this.currentOrderItemInfo = res.data;
			});
			// 查询订单历史信息
			getHistoryGoodsOrder({ goodsOrderID: id }).then(res => {
				if (res.rows.length === 0) {
					this.$message.warning('没有修改记录');
					return;
				}
				this.orderHistoryInfoList = res.rows;

				// 将最新的数据推入
				for (let i = 0; i < this.orderHistoryInfoList.length; i++) {
					const current = this.orderHistoryInfoList[i];
					const previous = this.orderHistoryInfoList[i + 1] || {}; // 保证不会越界
					current.diff = {
						new: this.formatData(
							excludeParams(current, this.$excludeWithUpdate)
						),
						old: this.formatData(
							excludeParams(previous, this.$excludeWithUpdate)
						),
						updateTime: this.parseTime(current.updateTime)
					};
				}

				// 处理最后一个元素
				const len = this.orderHistoryInfoList.length;
				if (len > 0) {
					this.orderHistoryInfoList.push({
						diff: {
							new: this.formatData(
								excludeParams(
									this.orderHistoryInfoList[len - 1],
									this.$excludeWithUpdate
								)
							),
							old: null,
							updateTime: this.parseTime(
								this.orderHistoryInfoList[len - 1].updateTime
							)
						}
					});

					// 处理第一个元素
					if (row) {
						this.orderHistoryInfoList.unshift({
							diff: {
								new: this.formatData(
									excludeParams(row, this.$excludeWithUpdate)
								),
								old: this.formatData(
									excludeParams(
										this.orderHistoryInfoList[0],
										this.$excludeWithUpdate
									)
								),
								updateTime: this.parseTime(row.updateTime)
							}
						});
					}
				}

				this.checkHistoryOrderVisible = true;
			});
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
