<template>
	<div>
		<virtual-list :keeps="60" style="height: 800px; overflow-y: auto" :data-key="'uid'" :data-sources="items" :data-component="itemComponent" :extra-props="extraProps" />
	</div>
</template>
<script>
import Item from './Item';
import VirtualList from 'vue-virtual-scroll-list';
import { delGoodsOrder, getGoodsOrder, auditGoodsOrder, listGoodsOrder } from '@/api/system/goodsOrder';
import { listInvoiceOut } from '@/api/system/invoiceOut';
import { listInvoiceIn } from '@/api/system/invoiceIn';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { mixin_order_Invoice } from '@/views/dashboard/mixins/order/order_Invoice';
import { mixin_order_add } from '@/views/dashboard/mixins/order/order_addOrder';
import { mixin_order_adjustOrder } from '@/views/dashboard/mixins/order/order_adjustOrder';
import { mixin_order_deliverGoods } from '@/views/dashboard/mixins/order/order_deliverGoods';
import { parseTime } from '@/utils/ruoyi';
import CheckOrder from '@/views/dashboard/components/goodsOrder/CheckOrder.vue';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
import { PUBLIC_DICT_TYPE } from '@/utils/order';

export default {
	name: 'root',
	mixins: [
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
		// 生成50000条数据 并放在items中
		const items = [];
		const suppliers = ['供应商A', '供应商B', '供应商C', '供应商D', '供应商E'];
		const warehouses = ['仓库1', '仓库2', '仓库3'];
		const customers = ['客户A', '客户B', '客户C', '客户D', '客户E'];
		const fleets = ['车队1', '车队2', '车队3', '车队4', '车队5'];
		const managers = ['经理1', '经理2', '经理3'];
		const users = ['用户1', '用户2'];

		for (let i = 0; i < 50000; i++) {
			const date = new Date();
			date.setDate(date.getDate() - i);
			const year = date.getFullYear();
			const month = String(date.getMonth() + 1).padStart(2, '0');
			const day = String(date.getDate()).padStart(2, '0');

			// 随机供应商和仓库数量
			const supplierCount = Math.floor(Math.random() * 2) + 1; // 1-2个
			const warehouseCount = Math.floor(Math.random() * 2); // 0-1个
			const selectedSuppliers = [];
			const selectedWarehouses = [];

			for (let j = 0; j < supplierCount; j++) {
				selectedSuppliers.push(suppliers[(i + j) % suppliers.length]);
			}
			for (let j = 0; j < warehouseCount; j++) {
				selectedWarehouses.push(warehouses[(i + j) % warehouses.length]);
			}

			// 生成订单创建时间（addtime）
			const addDate = new Date();
			addDate.setDate(addDate.getDate() - (i % 15)); // 0-14天前

			items.push({
				uid: `unique_${i}`,
				id: i + 1,
				orderDate: `${year}-${month}-${day}`,
				customer: customers[i % customers.length],
				suppliers: selectedSuppliers,
				warehouses: selectedWarehouses,
				checkState: i % 3 === 0 ? '已审核' : '未审核',
				fleet: fleets[i % fleets.length],
				landCarNo: 'A' + String(i + 1000).slice(-4),
				allPayments: (i + 1) * 10000 + Math.floor(Math.random() * 5000),
				allTonnage: (i + 1) * 10.5 + Math.random() * 5,
				allProfit: (i + 1) * 2000 + Math.floor(Math.random() * 1000),
				saleManager: managers[i % managers.length],
				userName: users[i % users.length],
				comments: `测试备注信息 ${i + 1}`,
				isedit: i % 2 === 0 ? 1 : 0,
				customerTaxIncluded: i % 3 === 0,
				supplierInvoice: i % 4 === 0,
				addtime: addDate.toISOString(), // 添加创建时间
				isAdjust: i % 10 === 0 ? 1 : 0, // 模拟调整单状态
				isAdjusted: i % 5 === 0 ? 1 : 0, // 模拟是否已调整
				adjustOrderid: i % 5 === 0 ? i - 1 : null, // 模拟调整单ID
				historyCount: i % 7 === 0 ? Math.floor(Math.random() * 5) : 0, // 模拟历史记录数量
				// 模拟订单详情数据（用于开票功能）
				smailOrderDetails: selectedSuppliers.map((supplier, idx) => ({
					supplier: supplier,
					supplierID: idx + 1,
					isIncludeTaxSale: i % 3 === 0 ? 1 : 0,
					isIncludeTaxFactory: i % 4 === 0 ? 1 : 0,
					paymentFactory: (i + 1) * 5000,
					storeHouseID: idx + 1,
					storeHouseName: selectedWarehouses[idx] || null
				}))
			});
		}
		return {
			itemComponent: Item,
			items: items,
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
		// 处理修改事件
		handleUpdate(row) {
			// 混入中的 handleUpdate 方法会自动被调用，因为 mixin_order_add 已经混入
			// 这里直接调用父类方法（来自 mixin）
			// 注意：由于混入机制，this.handleUpdate 已经指向混入中的方法
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
					// 从列表中移除该订单
					const index = this.items.findIndex(item => item.id === ids);
					if (index > -1) {
						this.items.splice(index, 1);
					}
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {
					// 如果是测试数据，模拟删除
					const index = this.items.findIndex(item => item.id === ids);
					if (index > -1) {
						this.items.splice(index, 1);
						this.$message.success('删除成功（测试数据）');
					}
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
							// 更新本地数据
							const item = this.items.find(item => item.id === row.id);
							if (item) {
								item.checkState = '已审核';
							}
							this.$message.success('操作成功~!');
						})
						.catch(() => {
							// 如果是测试数据，模拟审核
							const item = this.items.find(item => item.id === row.id);
							if (item) {
								item.checkState = '已审核';
							}
							this.$message.success('审核成功（测试数据）');
						});
				}
			});
		},
		// 处理供应商点击事件
		handleSupplierClick(supplier, row) {
			// 调用供应商开票方法
			this.updateOrderItemVisibleSupplierInvoice(row, supplier.id || 1);
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
