<template>
	<div>
		<virtual-list :keeps="60" style="height: 800px; overflow-y: auto" :data-key="'uid'" :data-sources="orderList" :data-component="itemComponent" :extra-props="extraProps" />
	</div>
</template>
<script>
import Item from './Item';
import VirtualList from 'vue-virtual-scroll-list';
import { delGoodsOrder, getGoodsOrder, auditGoodsOrder, listGoodsOrder } from '@/api/system/goodsOrder';
import { listInvoiceIn } from '@/api/system/invoiceIn';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { mixin_order_Invoice } from '@/views/dashboard/mixins/order/order_Invoice';
import { mixin_order_add } from '@/views/dashboard/mixins/order/order_addOrder';
import { mixin_order_adjustOrder } from '@/views/dashboard/mixins/order/order_adjustOrder';
import { mixin_order_deliverGoods } from '@/views/dashboard/mixins/order/order_deliverGoods';
import { mixin_order_base } from '@/views/dashboard/mixins/order/order_base';
import CheckOrder from '@/views/dashboard/components/goodsOrder/CheckOrder.vue';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
import { PUBLIC_DICT_TYPE } from '@/utils/order';

export default {
	name: 'root',
	mixins: [
		// 订单基础功能（包含数据获取逻辑）
		mixin_order_base,
		// 通用的弹窗组件配套的混入
		common_dialog,
		// 订单开票的功能
		mixin_order_Invoice,
		// 订单的添加或者修改
		mixin_order_add,
		// 调整单功能
		mixin_order_adjustOrder,
		// 发货单
		mixin_order_deliverGoods
	],
	data() {
		return {
			itemComponent: Item,
			items: [], // 从 goodsOrderList 获取，在 watch 中同步
			// 加载中的效果
			loading: true,
			// 订单总数 用于分页
			total: 0,
			// 本地维护的查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 1000
			},
			// 是否为调整单页面
			isAdjustOrder: false,
			// 传递给虚拟列表的额外属性
			extraProps: {
				isAdjustOrder: false,
				// 将父组件的方法传递给子组件
				parentMethods: null // 将在 mounted 中设置
			},
			// 供应商开票列表相关数据
			supplierInvoiceListVisible: false,
			supplierInvoiceList: [],
			supplierInvoiceListLoading: false,
			supplierInvoiceGroups: [],
			currentOrderInfo: null
		};
	},
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		orderList() {
			return this.goodsOrderList.map((item, index) => ({
				...item,
				uid: item.uid || `order_${item.id || index}`
			}));
		}
	},
	methods: {
		// 行操作中点击查看 查看当前行订单的信息
		checkOrderItemInfo(row) {
			const id = row.id;
			// 读取订单信息
			getGoodsOrder(id)
				.then(res => {
					this.orderInfo = res.data;
					this.orderDetailInfo = res.data.orderDetailList;
					// 打开弹窗
					this.openDialog(
						CheckOrder,
						'查看订单详情',
						'100%',
						{
							orderInfo: this.orderInfo,
							orderDetailInfo: this.orderDetailInfo
						},
						true
					);
				})
				.catch(() => {
					// 如果是测试数据，模拟显示
					this.$message.info('这是测试数据，实际环境中将显示订单详情');
				});
		},
		// 处理查看事件
		handleView(row) {
			this.checkOrderItemInfo(row);
		},
		// 处理删除事件
		handleDelete(row) {
			const ids = row.id;
			this.$modal
				.confirm('是否确认删除订单ID为"' + ids + '"的订单？')
				.then(() => {
					return delGoodsOrder(ids);
				})
				.then(() => {
					// 刷新列表
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {
					this.$message.error('删除失败');
				});
		},
		// 处理审核事件
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
					auditGoodsOrder({ id: row.id, isaudit: true })
						.then(() => {
							// 刷新列表
							this.getList();
							this.$message.success('操作成功~!');
						})
						.catch(() => {
							this.$message.error('审核失败');
						});
				}
			});
		},
		// 处理供应商点击事件
		handleSupplierClick(supplier, row) {
			// 调用供应商开票方法
			// supplier 可能是对象（有 supplierID）或字符串
			const supplierId = supplier?.supplierID || supplier?.id || 1;
			this.updateOrderItemVisibleSupplierInvoice(row, supplierId);
		},
		// 处理客户开票事件
		handleCustomerInvoice(row) {
			// 调用客户开票方法
			this.updateOrderItemVisibleCustomerInvoice(row);
		},
		// 处理供应商开票事件
		handleSupplierInvoice(row) {
			// 显示供应商开票列表
			this.showSupplierInvoiceList(row);
		},
		// 显示供应商开票列表
		showSupplierInvoiceList(row) {
			this.currentOrderInfo = row;
			this.supplierInvoiceListVisible = true;
			this.getSupplierInvoiceList(row.id);
		},
		// 获取供应商开票列表
		async getSupplierInvoiceList(orderId) {
			this.supplierInvoiceListLoading = true;
			try {
				const response = await listInvoiceIn({
					noPage: true,
					isOrderTax: orderId
				});
				if (response.code === 200) {
					this.supplierInvoiceList = response.rows || [];
					this.groupSupplierInvoicesByCompany();
				} else {
					this.$message.error(response.msg || '获取供应商开票列表失败');
					this.supplierInvoiceList = [];
					this.supplierInvoiceGroups = [];
				}
			} catch (error) {
				this.$message.error('获取供应商开票列表失败');
				this.supplierInvoiceList = [];
				this.supplierInvoiceGroups = [];
			} finally {
				this.supplierInvoiceListLoading = false;
			}
		},
		// 按供应商分组开票记录
		groupSupplierInvoicesByCompany() {
			const groups = {};
			this.supplierInvoiceList.forEach(invoice => {
				const companyId = invoice.companyID;
				if (!groups[companyId]) {
					groups[companyId] = {
						companyId: companyId,
						companyName: invoice.companyName,
						invoices: [],
						totalInvoiceAmount: 0,
						needInvoiceAmount: 0
					};
				}
				groups[companyId].invoices.push(invoice);
				groups[companyId].totalInvoiceAmount += Number(invoice.invoiceAmount || 0);
			});

			if (this.currentOrderInfo && this.currentOrderInfo.smailOrderDetails) {
				this.currentOrderInfo.smailOrderDetails.forEach(detail => {
					if (detail.supplierID && groups[detail.supplierID]) {
						groups[detail.supplierID].needInvoiceAmount += Number(detail.paymentFactory || 0);
					}
				});
			}

			this.supplierInvoiceGroups = Object.values(groups);
		},
		// 处理调整单事件
		handleAdjustOrder(row) {
			// 调用混入中的 handleOrderItemInfo 方法
			if (typeof this.handleOrderItemInfo === 'function') {
				this.handleOrderItemInfo(row);
			} else {
				this.$message.info('调整单功能需要调用 handleOrderItemInfo 方法');
			}
		},
		// 查看调整单信息
		handleCheckAdjust(row) {
			listGoodsOrder({ adjustOrderid: row.id })
				.then(res => {
					// 筛选出不是负数的那一条订单数据
					const adjustOrder = res.rows.filter(item => item.isAdjust !== -1)[0];
					if (!adjustOrder) {
						this.$modal.msgError('该订单没有调整单或者数据错误!');
						return;
					}
					getGoodsOrder(adjustOrder.id).then(response => {
						this.openDialog(
							GOODS_ORDER,
							'查看调整单信息',
							'1400px',
							{
								needToShowInfo: response.data
							},
							true
						);
					});
				})
				.catch(() => {
					this.$message.info('这是测试数据，实际环境中将显示调整单信息');
				});
		},
		// 查看原订单的信息
		handleCheckPrevious(row) {
			const { adjustOrderid } = row;
			if (!adjustOrderid) {
				this.$message.error('原订单ID不存在');
				return;
			}
			getGoodsOrder(adjustOrderid)
				.then(res => {
					this.openDialog(
						GOODS_ORDER,
						'查看原订单信息',
						'1400px',
						{
							needToShowInfo: res.data
						},
						true
					);
				})
				.catch(() => {
					this.$message.info('这是测试数据，实际环境中将显示原订单信息');
				});
		},
		// 处理发货单1事件
		handleOrder1(row) {
			// 调用混入中的 handleOrder1 方法
			if (typeof this.handleOrder1 === 'function') {
				this.handleOrder1(row);
			} else {
				this.$message.info('发货单1功能需要调用 handleOrder1 方法');
			}
		},
		// 处理发货单2事件
		handleOrder2(row) {
			// 调用混入中的 handleOrder2 方法
			if (typeof this.handleOrder2 === 'function') {
				this.handleOrder2(row);
			} else {
				this.$message.info('发货单2功能需要调用 handleOrder2 方法');
			}
		},
		// 处理发货单3事件
		handleOrder3(row) {
			// 调用混入中的 handleOrder3 方法
			if (typeof this.handleOrder3 === 'function') {
				this.handleOrder3(row);
			} else {
				this.$message.info('发货单3功能需要调用 handleOrder3 方法');
			}
		}
	},
	components: { 'virtual-list': VirtualList },
	mounted() {
		// 初始化时获取数据
		this.getList();

		// 将父组件的方法绑定到 extraProps，以便 Item 组件可以通过 $parent 访问
		// 由于虚拟列表的限制，我们通过 Vue 的响应式系统来传递方法引用
		this.extraProps.parentMethods = {
			handleView: this.handleView,
			handleUpdate: this.handleUpdate,
			handleDelete: this.handleDelete,
			handleCheck: this.handleCheck,
			handleSupplierClick: this.handleSupplierClick,
			handleCustomerInvoice: this.handleCustomerInvoice,
			handleSupplierInvoice: this.handleSupplierInvoice,
			handleAdjustOrder: this.handleAdjustOrder,
			handleCheckAdjust: this.handleCheckAdjust,
			handleCheckPrevious: this.handleCheckPrevious,
			handleOrder1: this.handleOrder1,
			handleOrder2: this.handleOrder2,
			handleOrder3: this.handleOrder3
		};
	},
	beforeDestroy() {
		// 清理资源
		this.extraProps.parentMethods = null;
	}
};
</script>
<style lang="scss" scoped></style>
