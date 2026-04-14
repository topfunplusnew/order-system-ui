<script>
import { delGoodsOrder, getGoodsOrder, updateGoodsOrder, importOrderData } from '@/api/system/goodsOrder';
import { listInvoiceOut } from '@/api/system/invoiceOut';
import { listInvoiceIn } from '@/api/system/invoiceIn';
import CheckFiles from '@/components/CheckFiles.vue';
import { mixin_checkfile } from '@/views/dashboard/mixins/checkfiles/mixin_checkfile';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { mixin_order_Invoice } from '@/views/dashboard/mixins/order/order_Invoice';
import { mixin_order_uploadFiles } from '@/views/dashboard/mixins/order/order_UploadFiles';
import { mixin_order_add } from '@/views/dashboard/mixins/order/order_addOrder';
import { mixin_order_adjustOrder } from '@/views/dashboard/mixins/order/order_adjustOrder';
import { mixin_order_base } from '@/views/dashboard/mixins/order/order_base';
import { mixin_order_deliverGoods } from '@/views/dashboard/mixins/order/order_deliverGoods';
import { mixin_order_freeApply } from '@/views/dashboard/mixins/order/order_freeApply';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import reLength from '@/views/dashboard/mixins/reLength';
import GOODS_ORDER from '../../../../components/NeedToShow/GOODS_ORDER.vue';
import QuerySearchBar from './QuerySearchBar.vue';
import { mixin_order_orderHistory } from '@/views/dashboard/mixins/order/order_history';
import OrderHistoryCheck from '@/views/dashboard/components/goodsOrder/OrderHistoryCheck.vue';
import OrderHistoryList from '@/views/dashboard/components/goodsOrder/OrderHistoryList.vue';
import { parseTime } from '@/utils/ruoyi';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { batchDeleteUserConfig, getUserConfig, saveUserConfig } from '@/api/user-config';
import { UserConfigKey } from '@/api/tool/user-config';
import StateTag from '@/views/dashboard/components/common/StateTag.vue';
import { auditGoodsOrder, listGoodsOrder, getHistoryGoodsOrder } from '../../../../api/system/goodsOrder';
import CheckOrder from '@/views/dashboard/components/goodsOrder/CheckOrder.vue';
// 前端Excel导出依赖
import * as XLSX from 'xlsx';
import { debounce, throttle } from 'lodash';
import VirtualScroll, { VirtualColumn } from 'el-table-virtual-scroll';
import { requestAnimationFrame } from 'vue-count-to/src/requestAnimationFrame';
import { download } from '@/utils/request';

export default {
	name: 'ElTableOrder',
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		// 调整单：使用 el-table + el-table-column（订单模式不变），所有列不固定
		adjustTableColumns() {
			const dataCols = [
				{ idx: 0, label: 'ID', prop: 'id' },
				{ idx: 1, label: '日期', prop: 'orderDate', width: 110 },
				{ idx: 2, label: '客户', prop: 'customer', width: 196 },
				{ idx: 3, label: '供应商/仓库', prop: 'supplierNames', width: 280 },
				{ idx: 4, label: '陆运车牌', prop: 'landCarNo', width: 112 },
				{ idx: 5, label: '审核', prop: 'checkState', width: 112 },
				{ idx: 25, label: '客户含税', prop: 'customerTaxIncluded', width: 112 },
				{ idx: 6, label: '车队', prop: 'fleet', width: 112 },
				{ idx: 7, label: '陆运电话', prop: 'landDriverTel', width: 176 },
				{ idx: 8, label: '司机', prop: 'landDriverName', width: 84 },
				{ idx: 9, label: '海运柜号', prop: 'seaCarNo', width: 176 },
				{ idx: 10, label: '海运电话', prop: 'seaDriverTel', width: 176 },
				{ idx: 11, label: '海运公司', prop: 'seaDriverName', width: 168 },
				{ idx: 12, label: '总货款', prop: 'allPayments', width: 144 },
				{ idx: 13, label: '总吨位', prop: 'allTonnage', width: 80 },
				{ idx: 14, label: '出厂货款', prop: 'allPaymentFactory', width: 144 },
				{ idx: 15, label: '陆运费', prop: 'landFreight', width: 112 },
				{ idx: 16, label: '海运费', prop: 'seaFreight', width: 112 },
				{ idx: 17, label: '含税利润', prop: 'allProfit', width: 112 },
				{ idx: 18, label: '不含税利润', prop: 'allProfitNoTax', width: 112 },
				{ idx: 19, label: '销售经理', prop: 'saleManager', width: 112 },
				{ idx: 20, label: '录入员', prop: 'userName', width: 84 },
				{ idx: 21, label: '备注', prop: 'comments', width: 140 },
				{ idx: 22, label: '出库单', prop: 'path', width: 84 },
				{ idx: 23, label: '收到条附件', prop: 'receiveProof' },
				{ idx: 24, label: '可否编辑', prop: 'isedit', width: 112 },
				{ idx: 26, label: '出厂含税', prop: 'supplierTaxIncluded', width: 112 },
				{ idx: 27, label: '审核人', prop: 'checkUserName', width: 112 }
			];

			return [
				{ idx: 'index', label: '序号', width: 50, align: 'center' },
				{ idx: 'rowActions', label: '行操作', width: 100, align: 'center' },
				...dataCols.filter(col => {
					const colConfig = this.columns.find(c => c.key === col.idx);
					return colConfig && colConfig.visible;
				}),
				{ idx: 'orderActions', label: '订单操作', width: 250, align: 'center' }
			];
		}
	},
	components: {
		StateTag,
		OrderHistoryCheck,
		OrderHistoryList,
		CheckFiles,
		QuerySearchBar,
		VirtualScroll,
		VirtualColumn
	},
	// 引入打印的混入、拖动表头宽度引起的变化、订单的基本信息的混入
	mixins: [
		// 打印功能
		mixin_printHTML,
		// 通用的弹窗组件配套的混入
		common_dialog,
		// 表头拖动功能
		reLength,
		// 订单基本功能
		mixin_order_base,
		// 文件查看功能
		mixin_checkfile,
		// 订单开票的功能
		mixin_order_Invoice,
		// 订单的添加或者修改
		mixin_order_add,
		// 调整单功能
		mixin_order_adjustOrder,
		// 上传附件
		mixin_order_uploadFiles,
		// 发货单
		mixin_order_deliverGoods,
		// 订单修改记录查看
		mixin_order_orderHistory,
		// 运费申请功能
		mixin_order_freeApply
	],
	props: {
		// 是否为调整单
		isAdjustOrder: {
			type: Boolean,
			default: false
		}
	},
	data() {
		return {
			// 加载中的效果
			loading: true,
			// 订单总数 用于分页
			total: 0,
			// 本地维护的查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 50
			},
			// 客户开票列表相关数据
			customerInvoiceListVisible: false,
			customerInvoiceList: [],
			customerInvoiceListLoading: false,
			currentOrderInfo: null, // 当前订单信息
			// 供应商开票列表相关数据
			supplierInvoiceListVisible: false,
			supplierInvoiceList: [],
			supplierInvoiceListLoading: false,
			supplierInvoiceGroups: [], // 按供应商分组的开票记录
			columns: [
				{ key: 0, label: 'ID', visible: true },
				{ key: 1, label: '日期', visible: true },
				{ key: 2, label: '客户', visible: true },
				{ key: 3, label: '供应商/仓库', visible: true },
				{ key: 4, label: '陆运车牌', visible: true },
				{ key: 5, label: '审核', visible: true },
				{ key: 25, label: '客户含税', visible: true },
				{ key: 6, label: '车队', visible: true },
				{ key: 7, label: '陆运电话', visible: true },
				{ key: 8, label: '司机', visible: true },
				{ key: 9, label: '海运柜号', visible: true },
				{ key: 10, label: '海运电话', visible: true },
				{ key: 11, label: '海运公司', visible: true },
				{ key: 12, label: '总货款', visible: true },
				{ key: 13, label: '总吨位', visible: true },
				{ key: 14, label: '出厂货款', visible: true },
				{ key: 15, label: '陆运费', visible: true },
				{ key: 16, label: '海运费', visible: true },
				{ key: 17, label: '含税利润', visible: true },
				{ key: 18, label: '不含税利润', visible: true },
				{ key: 19, label: '销售经理', visible: true },
				{ key: 20, label: '录入员', visible: true },
				{ key: 21, label: '备注', visible: true },
				{ key: 22, label: '出库单', visible: true },
				{ key: 23, label: '收到条附件', visible: true },
				{ key: 24, label: '可否编辑', visible: true },
				{ key: 26, label: '出厂含税', visible: true },
				{ key: 27, label: '审核人', visible: true }
			],
			// 性能优化相关：缓存 DOM 尺寸信息，避免频繁访问
			cachedScrollInfo: {
				scrollTop: 0,
				scrollHeight: 0,
				clientHeight: 0,
				lastUpdateTime: 0
			},
			// 列配置保存的防抖函数
			saveColumnsDebounced: null,
			// 用于批量更新 DOM 的 RAF ID
			columnsUpdateRafId: null,
			// 搜索查询参数的防抖函数
			handleGetQueryParamsDebounced: null,

			// 导入结果弹窗
			importResultVisible: false,
			importResultMessage: '',
			activeOrderActionRowId: null
		};
	},
	watch: {
		// 监听 loading 状态，当数据加载完成后确保滚动事件已绑定
		loading(newVal, oldVal) {
			if (oldVal === true && newVal === false) {
				// 数据加载完成，确保滚动事件已绑定并重新布局以显示合计行
				this.$nextTick(() => {
					this.bindTableScroll();
					// 强制表格重绘，解决合计行不显示的问题
					if (this.$refs.orderTable) {
						this.$refs.orderTable.doLayout();
					}
					// 如果虚拟滚动引用存在，也确保表头同步
					if (this.$refs.virtualScroll) {
						this.$refs.virtualScroll.doHeaderLayout();
					}
				});
			}
		}
	},
	created() {
		this.initOrderActionRowState();
		this.getList();
		// 创建防抖的搜索方法，延迟 300ms 执行
		this.handleGetQueryParamsDebounced = debounce(this.handleGetQueryParams, 300);
	},
	mounted() {
		this.$bus.$on('refreshList', () => {
			this.getList();
		});
		// 监听订单添加成功事件，自动创建运费申请
		this.$bus.$on('orderAddedSuccess', this.handleOrderAddedSuccess);
		// 绑定表格滚动事件
		this.$nextTick(() => {
			this.bindTableScroll();
		});
	},
	beforeDestroy() {
		this.$bus.$off('refreshList');
		this.$bus.$off('orderAddedSuccess', this.handleOrderAddedSuccess);
		// 移除滚动事件监听
		this.unbindTableScroll();
		// 取消滚动事件的 RAF
		if (this._scrollRafId) {
			cancelAnimationFrame(this._scrollRafId);
			this._scrollRafId = null;
		}
		// 取消列配置更新的 RAF
		if (this.columnsUpdateRafId) {
			cancelAnimationFrame(this.columnsUpdateRafId);
			this.columnsUpdateRafId = null;
		}
		// 取消防抖函数
		if (this.saveColumnsDebounced) {
			this.saveColumnsDebounced.cancel();
			this.saveColumnsDebounced = null;
		}
		// 取消搜索防抖函数
		if (this.handleGetQueryParamsDebounced) {
			this.handleGetQueryParamsDebounced.cancel();
			this.handleGetQueryParamsDebounced = null;
		}
	},
	methods: {
		normalizeOrderActionRowId(value) {
			if (value === null || value === undefined || value === '') {
				return null;
			}
			return String(value);
		},
		parseUserConfigValue(response) {
			const configValue = response?.data?.value ?? response?.data ?? null;
			if (typeof configValue !== 'string') {
				return configValue;
			}
			try {
				return JSON.parse(configValue);
			} catch (error) {
				return configValue;
			}
		},
		extractOrderActionRowId(configValue) {
			if (!configValue) {
				return null;
			}
			if (typeof configValue === 'object') {
				const nestedConfig = configValue.key;
				if (nestedConfig && typeof nestedConfig === 'object') {
					return this.normalizeOrderActionRowId(nestedConfig.id ?? nestedConfig.rowId ?? null);
				}
				return this.normalizeOrderActionRowId(configValue.id ?? configValue.rowId ?? null);
			}
			return this.normalizeOrderActionRowId(configValue);
		},
		isPageReload() {
			if (typeof window === 'undefined' || !window.performance) {
				return false;
			}
			if (typeof window.performance.getEntriesByType === 'function') {
				const navigationEntries = window.performance.getEntriesByType('navigation');
				if (Array.isArray(navigationEntries) && navigationEntries.length > 0) {
					return navigationEntries[0].type === 'reload';
				}
			}
			if (window.performance.navigation) {
				return window.performance.navigation.type === 1;
			}
			return false;
		},
		async initOrderActionRowState() {
			if (this.isPageReload()) {
				await this.clearOrderActionRowState();
				return;
			}
			await this.loadOrderActionRowState();
		},
		async loadOrderActionRowState() {
			try {
				const response = await getUserConfig(UserConfigKey.GOODS_ORDER_ACTIVE_ACTION_ROW);
				const configValue = this.parseUserConfigValue(response);
				this.activeOrderActionRowId = this.extractOrderActionRowId(configValue);
			} catch (error) {
				void error;
				this.activeOrderActionRowId = null;
			}
		},
		async clearOrderActionRowState() {
			this.activeOrderActionRowId = null;
			try {
				await batchDeleteUserConfig([UserConfigKey.GOODS_ORDER_ACTIVE_ACTION_ROW]);
			} catch (error) {
				void error;
			}
		},
		trackOrderActionRow(row) {
			const rowId = this.normalizeOrderActionRowId(row && row.id);
			if (!rowId) {
				return;
			}
			this.activeOrderActionRowId = rowId;
			saveUserConfig(UserConfigKey.GOODS_ORDER_ACTIVE_ACTION_ROW, {
				key: {
					id: rowId
				}
			}).catch(error => {
				void error;
			});
		},
		handleTrackedRowAction(methodName, row, ...args) {
			this.trackOrderActionRow(row);
			const handler = this[methodName];
			if (typeof handler === 'function') {
				return handler.call(this, row, ...args);
			}
			return undefined;
		},
		handleSupplierInvoiceClick(row, supplierId) {
			this.trackOrderActionRow(row);
			this.updateOrderItemVisibleSupplierInvoice(row, supplierId);
		},
		getOrderRowClassName({ row }) {
			const classNames = [];
			const currentRowId = this.normalizeOrderActionRowId(row && row.id);
			if (currentRowId && currentRowId === this.activeOrderActionRowId) {
				classNames.push('active-order-action-row');
			}
			const adjustClassName = this.getAdjustRowLevelClassName(row);
			if (adjustClassName) {
				classNames.push(adjustClassName);
			}
			return classNames.join(' ');
		},
		getAdjustRowLevelClassName(row) {
			if (!this.isAdjustOrder) return '';
			const adjust = Number(row && row.isAdjust);
			if (!adjust) return '';
			if (adjust < 0) return 'adjust-row-negative';
			if (adjust === 1) return 'adjust-row-1';
			if (adjust === 2) return 'adjust-row-2';
			if (adjust === 3) return 'adjust-row-3';
			return 'adjust-row-gt3';
		},
		orderDataAppendChange(renderData) {
			// 直接使用虚拟滚动组件传递的数据，不要重新排序
			// 虚拟滚动组件已经根据滚动位置计算好了可见区域的数据顺序
			// this.pendingData = renderData;
			// const updateVisibleRows = renderData => this.virtualGoodsOrderList.splice(0, this.virtualGoodsOrderList.length, ...renderData);
			// // const updateVisibleRows = throttle(renderData => {
			// // }, 100);
			// if (!this.ticking) {
			// 	requestAnimationFrame(() => {
			// 		// 检查 pendingData 是否存在（包括空数组的情况）
			// 		if (this.pendingData !== null && this.pendingData !== undefined) {
			// 			updateVisibleRows(this.pendingData);
			// 			this.pendingData = null;
			// 		}
			// 		this.ticking = false;
			// 	});
			// 	this.ticking = true;
			// }
			this.virtualGoodsOrderList = renderData;
		},
		handleColumnRefresh(updatedColumns) {
			// 更新表格列的显示状态
			this.columns = [...updatedColumns];
			// 触发表格重新加载
			this.getList();
		},
		onColumnChange({ index, column, visible }) {
			// 可以在这里处理列可见性变化的逻辑
			// 例如：更新列配置或执行其他相关操作
			this.$set(this.columns, index, { ...column, visible });
		},
		// 检查用户是否具有指定权限
		hasPermission(roles) {
			// 从 Vuex store 或其他地方获取当前用户角色
			const userRoles = this.$store.getters.roles || [];
			// 检查是否包含所需角色
			return userRoles.some(role => roles.includes(role));
		},
		// 行操作中点击查看 查看当前行订单的信息
		checkOrderItemInfo(row) {
			this.trackOrderActionRow(row);
			const id = row.id;
			// 读取订单信息
			getGoodsOrder(id)
				.then(res => {
					if (!res || !res.data) {
						this.$message.error('获取订单信息失败');
						return;
					}
					this.orderInfo = res.data;
					this.orderDetailInfo = res.data.orderDetailList || [];
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
				.catch(error => {
					console.error('获取订单信息失败:', error);
					this.$message.error('获取订单信息失败，请重试');
				});
		},
		// 查看订单修改记录
		checkHistoryList(row) {
			const id = row.id;
			// 获取订单修改记录信息
			getHistoryGoodsOrder({ goodsOrderID: id })
				.then(res => {
					if (res.total === 0) {
						this.$message.warning('无订单历史信息');
						return;
					}
					this.orderHistoryInfoList = res.rows;
					this.openDialog(
						OrderHistoryList,
						'订单修改记录',
						'50%',
						{
							goodsOrderList: this.orderHistoryInfoList
						},
						true
					);
				})
				.catch(error => {
					console.error('获取订单修改记录失败:', error);
					this.$message.error('获取订单修改记录失败，请重试');
				});
		},
		handleCheck(row) {
			this.trackOrderActionRow(row);
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
		},
		// 统一行样式，保持固定列与主体区域行高一致
		// 注意：如果使用 row-height 属性，不要在这里设置 height，避免冲突
		rowStyle({ row }) {
			// 只设置背景色，不设置高度，让 row-height 属性控制行高
			if (!row.isAdjust) return {};
			// 基础统一高度
			if (row.isAdjust > 0 && this.isAdjustOrder) {
				// 返回需要的背景色
				if (row.isAdjust === 1) return { background: '#f0f0f0' };
				if (row.isAdjust === 2) return { background: '#f0f9eb' };
				if (row.isAdjust === 3) return { background: '#fdf6ec' };
				return { background: '#ffcccc' };
			}
			return {};
		},
		// 调整单行高亮：ElementUI 的背景通常绘制在 td 上，使用 row-class-name + CSS 更稳定
		getAdjustRowClassName({ row }) {
			return this.getOrderRowClassName({ row });
		},
		// 获取客户开票列表
		async getCustomerInvoiceList(orderId) {
			this.customerInvoiceListLoading = true;
			try {
				const response = await listInvoiceOut({
					noPage: true,
					isOrderTax: orderId
				});
				if (response.code === 200) {
					// 按开票时间倒序排序（最新的在前），累计从下往上累加
					const list = response.rows || [];
					this.customerInvoiceList = list.sort((a, b) => {
						const timeA = a.invoiceDate ? new Date(a.invoiceDate).getTime() : 0;
						const timeB = b.invoiceDate ? new Date(b.invoiceDate).getTime() : 0;
						return timeB - timeA; // 倒序：最新的在前面
					});
				} else {
					this.$message.error(response.msg || '获取开票列表失败');
					this.customerInvoiceList = [];
				}
			} catch (error) {
				this.$message.error('获取开票列表失败');
				this.customerInvoiceList = [];
			} finally {
				this.customerInvoiceListLoading = false;
			}
		},

		// 显示客户开票列表弹窗
		showCustomerInvoiceList(row) {
			this.trackOrderActionRow(row);
			this.currentOrderInfo = row;
			this.customerInvoiceListVisible = true;
			this.getCustomerInvoiceList(row.id);
		},

		// 关闭客户开票列表弹窗
		closeCustomerInvoiceList() {
			this.customerInvoiceListVisible = false;
			this.customerInvoiceList = [];
			this.currentOrderInfo = null;
		},

		// 添加新的客户开票 - 打开原有的开票弹窗
		handleAddCustomerInvoice() {
			if (!this.currentOrderInfo) return;

			// 调用原有的客户开票方法
			this.updateOrderItemVisibleCustomerInvoice(this.currentOrderInfo);
			// 关闭列表弹窗
			this.closeCustomerInvoiceList();
		},

		// 计算累计开票金额（从最后一行累加到当前行）
		// 数据排序：最新的在第一行（索引0），最早的 in 最后一行（索引 length-1）
		// 累计计算：从最后一行（数组最后一个元素）累加到当前行
		calculateAccumulatedInvoiceAmount(index) {
			let accumulated = 0;
			// 从最后一行（数组最后一个元素）开始，往前累加到当前行
			for (let i = this.customerInvoiceList.length - 1; i >= index; i--) {
				accumulated += Number(this.customerInvoiceList[i].invoiceAmount || 0);
			}
			return accumulated.toFixed(2);
		},

		// 获取开票记录行样式
		getInvoiceRowClassName({ row, rowIndex }) {
			// 可以根据开票状态等条件返回不同的样式类名
			if (row.isInvoiced) {
				return 'invoice-row-completed';
			}
			return 'invoice-row-pending';
		},

		// ==================== 供应商开票列表相关方法 ====================

		// 获取供应商开票列表
		async getSupplierInvoiceList(orderId) {
			this.supplierInvoiceListLoading = true;
			try {
				const response = await listInvoiceIn({
					noPage: true,
					isOrderTax: orderId
				});
				if (response.code === 200) {
					// 按开票时间倒序排序（最新的在前），累计从下往上累加
					const list = response.rows || [];
					this.supplierInvoiceList = list.sort((a, b) => {
						const timeA = a.invoiceDate ? new Date(a.invoiceDate).getTime() : 0;
						const timeB = b.invoiceDate ? new Date(b.invoiceDate).getTime() : 0;
						return timeB - timeA; // 倒序：最新的在前面
					});
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
			// 根据开票记录分组
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

			// 对每个供应商的开票记录按时间倒序排序（最新的在前），累计从下往上累加
			Object.values(groups).forEach(group => {
				group.invoices.sort((a, b) => {
					const timeA = a.invoiceDate ? new Date(a.invoiceDate).getTime() : 0;
					const timeB = b.invoiceDate ? new Date(b.invoiceDate).getTime() : 0;
					return timeB - timeA; // 倒序：最新的在前面
				});
			});

			// 计算每个供应商的需开票金额（从订单详情中获取）
			if (this.currentOrderInfo && this.currentOrderInfo.smailOrderDetails) {
				this.currentOrderInfo.smailOrderDetails.forEach(detail => {
					if (detail.supplierID && groups[detail.supplierID]) {
						groups[detail.supplierID].needInvoiceAmount += Number(detail.paymentFactory || 0);
					}
				});
			}

			// 如果订单中有供应商但没有开票记录，也要创建分组
			if (this.currentOrderInfo && this.currentOrderInfo.smailOrderDetails) {
				this.currentOrderInfo.smailOrderDetails.forEach(detail => {
					if (detail.supplierID && !groups[detail.supplierID] && detail.supplier) {
						groups[detail.supplierID] = {
							companyId: detail.supplierID,
							companyName: detail.supplier,
							invoices: [],
							totalInvoiceAmount: 0,
							needInvoiceAmount: Number(detail.paymentFactory || 0)
						};
					}
				});
			}

			this.supplierInvoiceGroups = Object.values(groups);
		},

		// 显示供应商开票列表弹窗
		showSupplierInvoiceList(row) {
			this.trackOrderActionRow(row);
			this.currentOrderInfo = row;
			this.supplierInvoiceListVisible = true;
			this.getSupplierInvoiceList(row.id);
		},

		// 关闭供应商开票列表弹窗
		closeSupplierInvoiceList() {
			this.supplierInvoiceListVisible = false;
			this.supplierInvoiceList = [];
			this.supplierInvoiceGroups = [];
			this.currentOrderInfo = null;
		},

		// 添加新的供应商开票
		handleAddSupplierInvoice(supplierGroup) {
			if (!this.currentOrderInfo) return;

			// 调用原有的供应商开票方法
			this.updateOrderItemVisibleSupplierInvoice(this.currentOrderInfo, supplierGroup.companyId);
			// 关闭列表弹窗
			this.closeSupplierInvoiceList();
		},

		// 计算供应商累计开票金额（从最后一行累加到当前行）
		// 数据排序：最新的在第一行（索引0），最早的 in 最后一行（索引 length-1）
		// 累计计算：从最后一行（数组最后一个元素）累加到当前行
		calculateSupplierAccumulatedInvoiceAmount(invoices, index) {
			let accumulated = 0;
			// 从最后一行（数组最后一个元素）开始，往前累加到当前行
			for (let i = invoices.length - 1; i >= index; i--) {
				accumulated += Number(invoices[i].invoiceAmount || 0);
			}
			return accumulated.toFixed(2);
		},

		// 计算订单是否超过7天
		isOrderExpired(addtime) {
			if (!addtime) return false;
			const addDate = new Date(addtime);
			const currentDate = new Date();
			// 计算时间差（毫秒）
			const timeDiff = currentDate.getTime() - addDate.getTime();
			// 转换为天数（1天 = 24小时 * 60分钟 * 60秒 * 1000毫秒）
			const daysDiff = timeDiff / (24 * 60 * 60 * 1000);
			// 如果天数差大于等于7，返回true（已过期）
			return daysDiff >= 7;
		},
		parseTime,
		updateGoodsOrder,
		getGoodsOrder,
		// 处理下拉菜单  使用的是事件委托
		handleCommand(command, row) {
			this.trackOrderActionRow(row);
			// 根据不同操作委派不同的方法
			switch (command) {
				// 查看订单
				case 'checkOrderItemInfo':
					this.checkOrderItemInfo(row);
					break;
				// 修改订单
				case 'handleUpdate':
					this.handleUpdate(row);
					break;
				// 删除订单
				case 'handleDelete':
					this.handleDelete(row);
					break;
				// 查看修改记录
				case 'checkHistoryList':
					this.checkHistoryList(row);
					break;
				default:
					break;
			}
		},
		// 处理顶部搜索框（内部方法，供防抖函数调用）
		handleGetQueryParams(value) {
			if (value) {
				this.queryParams = value;
			}
			this.getList();
		},
		// 删除某一个订单
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除订单ID为"' + ids + '"的订单？')
				.then(function () {
					return delGoodsOrder(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				});
		},
		// 查看调整单信息
		handleCheckAdjust(row) {
			this.trackOrderActionRow(row);
			listGoodsOrder({ adjustOrderid: row.id }).then(res => {
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
			});
		},
		// 查看原订单的信息
		handleCheckPrevious(row) {
			this.trackOrderActionRow(row);
			const { adjustOrderid } = row;
			getGoodsOrder(adjustOrderid).then(res => {
				this.openDialog(
					GOODS_ORDER,
					'查看原订单信息',
					'1400px',
					{
						needToShowInfo: res.data
					},
					true
				);
			});
		},
		handleReCheck(row) {
			this.trackOrderActionRow(row);
			this.$antdconfirm({
				title: '是否取消审核',
				okText: '确定',
				cancelText: '取消',
				onOk: () => {
					auditGoodsOrder({
						id: row.id,
						isaudit: false
					}).then(() => {
						this.$message.success('取消审核成功');
						this.getList();
					});
				}
			});
		},
		// 订单目录导出改为后端接口，参数与列表查询保持一致
		handleExport() {
			const baseName = this.isAdjustOrder ? '调整单' : '订单';
			this.download(
				'system/goodsOrder/exportDirectory',
				{
					...this.queryParams,
					isAdjust: this.isAdjustOrder ? -1 : 0
				},
				`${baseName}目录_${new Date().getTime()}.xlsx`
			);
		},

		/**
		 * 数字类型列 key 集合，导出时需设为 Excel 数值型以支持计算
		 * @returns {number[]}
		 */
		getNumericColKeys() {
			return [0, 12, 13, 14, 15, 16, 17, 18];
		},

		/**
		 * 生成Excel数据
		 * @returns {Object} 包含表头、数据行、数字列索引
		 * 时间复杂度: O(n×m), 空间复杂度: O(n×m)
		 */
		generateExcelData() {
			const visibleColumns = this.columns.filter(col => col.visible);
			const headers = visibleColumns.map(col => col.label);
			const numericColIndices = visibleColumns.map((col, idx) => (this.getNumericColKeys().includes(col.key) ? idx : -1)).filter(idx => idx >= 0);

			const rows = this.goodsOrderList.map(row => {
				return visibleColumns.map(col => this.formatCellValue(row, col.key));
			});

			return { headers, rows, numericColIndices };
		},

		/**
		 * 格式化单元格值
		 * @param {Object} row - 行数据
		 * @param {number} colKey - 列键值
		 * @returns {string} 格式化后的值
		 */
		formatCellValue(row, colKey) {
			switch (colKey) {
				case 0: // ID
					if (row.id === null || row.id === undefined || row.id === '') return '';
					const idNum = Number(row.id);
					return isNaN(idNum) ? row.id : idNum;
				case 1: // 日期
					return row.orderDate ? parseTime(row.orderDate, '{y}-{m}-{d}') : '';
				case 2: // 客户
					return row.customer || '';
				case 3: // 供应商/仓库
					return this.formatSupplierWarehouse(row);
				case 4: // 陆运车牌
					return row.landCarNo || '';
				case 5: // 审核
					return row.checkState || '';
				case 6: // 车队
					return row.fleet || '';
				case 7: // 陆运电话
					return row.landDriverTel || '';
				case 8: // 司机
					return row.landDriverName || '';
				case 9: // 海运柜号
					return row.seaCarNo || '无';
				case 10: // 海运电话
					return row.seaDriverTel || '无';
				case 11: // 海运公司
					return row.seaDriverName || '无';
				case 12: // 总货款
					// 任务1：前端 Excel 导出 - 将数字字符串转为 Number，确保导出到 Excel 后可直接运算
					if (row.allPayments === null || row.allPayments === undefined || row.allPayments === '') return '';
					{
						const num = Number(String(row.allPayments).replace(/,/g, '').trim());
						return isNaN(num) ? row.allPayments : num;
					}
				case 13: // 总吨位
					if (row.allTonnage === null || row.allTonnage === undefined || row.allTonnage === '') return '';
					{
						const num = Number(String(row.allTonnage).replace(/,/g, '').trim());
						return isNaN(num) ? row.allTonnage : num;
					}
				case 14: // 出厂货款
					if (row.allPaymentFactory === null || row.allPaymentFactory === undefined || row.allPaymentFactory === '') return '';
					{
						const num = Number(String(row.allPaymentFactory).replace(/,/g, '').trim());
						return isNaN(num) ? row.allPaymentFactory : num;
					}
				case 15: // 陆运费
					if (row.landFreight === null || row.landFreight === undefined || row.landFreight === '') return '';
					{
						const num = Number(String(row.landFreight).replace(/,/g, '').trim());
						return isNaN(num) ? row.landFreight : num;
					}
				case 16: // 海运费
					if (row.seaFreight === null || row.seaFreight === undefined || row.seaFreight === '') return '';
					{
						const num = Number(String(row.seaFreight).replace(/,/g, '').trim());
						return isNaN(num) ? row.seaFreight : num;
					}
				case 17: // 含税利润
					if (row.allProfit === null || row.allProfit === undefined || row.allProfit === '') return '';
					{
						const num = Number(String(row.allProfit).replace(/,/g, '').trim());
						return isNaN(num) ? row.allProfit : num;
					}
				case 18: // 不含税利润
					if (row.allProfitNoTax === null || row.allProfitNoTax === undefined || row.allProfitNoTax === '') return '';
					{
						const num = Number(String(row.allProfitNoTax).replace(/,/g, '').trim());
						return isNaN(num) ? row.allProfitNoTax : num;
					}
				case 19: // 销售经理
					return row.saleManager || '';
				case 20: // 录入员
					return row.userName || '';
				case 21: // 备注
					return row.comments || '';
				case 22: // 出库单
					return this.formatAttachments(row.attachmentList, 'path');
				case 23: // 收到条附件
					return this.formatAttachments(row.attachmentList, 'receiveProof');
				case 24: // 可否编辑
					return row.isedit === 0 ? '否' : '是';
				case 25: // 客户含税
					return this.hasInvoice(row, this.PUBLIC_DICT_TYPE.CUSTOMER) ? row.customerInvoiceStatus : '否';
				case 26: // 出厂含税
					return this.hasInvoice(row, this.PUBLIC_DICT_TYPE.SUPPLIER) ? row.supplierInvoiceStatus : '否';
				case 27: // 审核人
					return row.checkUserName || '';
				default:
					return '';
			}
		},

		/**
		 * 格式化供应商/仓库信息
		 * @param {Object} row - 行数据
		 * @returns {string} 格式化后的字符串
		 */
		formatSupplierWarehouse(row) {
			// 使用预处理的供应商和仓库数据
			const suppliers = row._uniqueSuppliers || [];
			const warehouses = row._uniqueWarehouses || [];

			const supplierNames = suppliers.map(s => s.supplier).join(', ');
			const warehouseNames = warehouses.map(w => w.storeHouseName).join(', ');

			if (supplierNames && warehouseNames) {
				return `${supplierNames} | ${warehouseNames}`;
			} else if (supplierNames) {
				return supplierNames;
			} else if (warehouseNames) {
				return warehouseNames;
			} else {
				return '-';
			}
		},

		/**
		 * 格式化附件信息
		 * @param {Array} attachmentList - 附件列表
		 * @param {string} type - 附件类型
		 * @returns {string} 格式化后的附件信息
		 */
		formatAttachments(attachmentList, type) {
			if (!Array.isArray(attachmentList)) return '无';

			const filteredAttachments = attachmentList.filter(item => item.flag === type);

			if (filteredAttachments.length === 0) return '无';

			return filteredAttachments.map(item => item.fileName || '附件').join(', ');
		},

		/**
		 * 下载Excel文件
		 * @param {Object} data - Excel数据 { headers, rows, numericColIndices }
		 */
		downloadExcel(data) {
			const worksheetData = [data.headers, ...data.rows];
			const worksheet = XLSX.utils.aoa_to_sheet(worksheetData);

			// 数字列显式设为 Excel 数值类型，支持公式计算
			const numericColIndices = data.numericColIndices || [];
			const colToLetter = n => (n >= 26 ? colToLetter(Math.floor(n / 26) - 1) : '') + String.fromCharCode(65 + (n % 26));
			for (let r = 1; r < worksheetData.length; r++) {
				numericColIndices.forEach(colIdx => {
					const cellRef = colToLetter(colIdx) + (r + 1);
					const raw = worksheetData[r][colIdx];
					if (raw !== '' && raw !== null && raw !== undefined) {
						const num = typeof raw === 'number' ? raw : Number(String(raw).replace(/,/g, '').trim());
						worksheet[cellRef] = !isNaN(num) ? { t: 'n', v: num, z: '#,##0.00' } : worksheet[cellRef];
					}
				});
			}

			worksheet['!cols'] = data.headers.map(() => ({ wch: 15 }));

			const workbook = XLSX.utils.book_new();
			const baseName = this.isAdjustOrder ? '调整单' : '订单';
			XLSX.utils.book_append_sheet(workbook, worksheet, `${baseName}列表`);

			const fileName = `${baseName}列表_${parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`;
			XLSX.writeFile(workbook, fileName);
		},
		// 订单列表 不分页的导出
		handleExportNoPage() {
			const baseName = this.isAdjustOrder ? '调整单' : '订单';
			this.download(
				'system/goodsOrder/export',
				{
					...this.queryParams,
					isAdjust: this.isAdjustOrder ? -1 : 0,
					noPage: true
				},
				`${baseName}列表_${new Date().getTime()}.xlsx`
			);
		},
		// 表头拖动结束后更新虚拟滚动表头布局
		onHeaderDragend() {
			// 使用自定义列，改变列宽度后，需要手动更新table头部
			if (this.$refs.virtualScroll) {
				this.$refs.virtualScroll.doHeaderLayout();
			}
		},
		/**
		 * 计算表格合计行
		 * @param {Object} param - 包含 columns 和 data
		 * @returns {Array} 合计行数据数组
		 */
		getSummary(param) {
			const { columns } = param;
			const sums = [];
			// 使用整个 goodsOrderList 数组进行合计计算，而不是只计算已渲染的数据
			const data = this.goodsOrderList || [];
			// 需要合计的数字列（根据 prop 属性判断）
			const summaryColumns = ['allPaymentFactory', 'allTonnage', 'allPayments', 'allProfit', 'allProfitNoTax', 'landFreight', 'seaFreight'];

			// 确保 sums 数组长度与 columns 数组长度一致
			// 先初始化所有位置为空字符串
			for (let i = 0; i < columns.length; i++) {
				sums[i] = ' ';
			}

			// 遍历所有列，为每一列生成合计值
			columns.forEach((column, index) => {
				// 通过 label 判断是否是序号列
				if (column.label === '序号') {
					sums[index] = '合计';
					return;
				}

				// 判断当前列是否需要合计
				// 只有当列有 property 属性且属于需要合计的列时才计算
				if (column.property && summaryColumns.includes(column.property)) {
					// 计算该列的所有数据之和
					const values = data.map(item => {
						const value = item[column.property];
						// 转换为数字，如果转换失败则返回0
						const numValue = Number(value);
						return isNaN(numValue) ? 0 : numValue;
					});

					// 计算总和
					const sum = values.reduce((prev, curr) => {
						return prev + curr;
					}, 0);

					// 格式化显示（使用与数据列相同的格式）
					if (column.property === 'allTonnage') {
						// 吨位保留2位小数
						sums[index] = sum.toFixed(2);
					} else {
						// 金额类保留2位小数
						sums[index] = sum.toFixed(2);
					}
				}
			});

			return sums;
		},
		/**
		 * 绑定表格滚动事件
		 * 优化：使用 requestAnimationFrame 合并滚动事件，避免频繁触发
		 */
		bindTableScroll() {
			this.$nextTick(() => {
				const table = this.$refs.orderTable;
				if (table && table.bodyWrapper) {
					// 如果已经绑定过，先移除
					if (this._handleTableScroll) {
						table.bodyWrapper.removeEventListener('scroll', this._handleTableScroll);
					}
					// 保存滚动事件处理函数引用，方便后续移除
					// 使用 requestAnimationFrame 优化滚动事件处理
					this._handleTableScroll = event => {
						// 使用 RAF 合并滚动事件，避免频繁触发
						// 如果已经有待处理的 RAF，取消它，使用最新的滚动位置
						if (this._scrollRafId) {
							cancelAnimationFrame(this._scrollRafId);
						}
						this._scrollRafId = requestAnimationFrame(() => {
							this.handleTableScroll(event);
							this._scrollRafId = null;
						});
					};
					// 使用 passive: true 优化滚动性能，告诉浏览器不会调用 preventDefault
					table.bodyWrapper.addEventListener('scroll', this._handleTableScroll, { passive: true });
				}
			});
		},
		/**
		 * 移除表格滚动事件监听
		 */
		unbindTableScroll() {
			const table = this.$refs.orderTable;
			if (table && table.bodyWrapper && this._handleTableScroll) {
				table.bodyWrapper.removeEventListener('scroll', this._handleTableScroll);
				this._handleTableScroll = null;
			}
		},
		// 下载导入模板
		handleDownloadTemplate() {
			download('system/goodsOrder/importTemplate', {}, `订单导入模板_${parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`);
		},
		// 导入订单数据
		handleImportData() {
			const input = document.createElement('input');
			input.type = 'file';
			input.accept = '.xlsx,.xls';
			input.onchange = e => {
				const file = e.target.files[0];
				if (!file) return;

				// 校验文件格式
				const fileName = file.name.toLowerCase();
				const validExtensions = ['.xlsx', '.xls'];
				const isValidFormat = validExtensions.some(ext => fileName.endsWith(ext));

				if (!isValidFormat) {
					this.$message.error('请上传Excel格式的文件（.xlsx 或 .xls）');
					return;
				}

				// 上传文件
				const formData = new FormData();
				formData.append('file', file);

				this.$message.info('正在导入，请稍候...');
				importOrderData(formData)
					.then(res => {
						this.importResultMessage = res.msg || '导入完成';
						this.importResultVisible = true;
						// 如果导入成功，刷新列表
						if (res.code === 200 && !res.msg.includes('无有效数据')) {
							this.getList();
						}
					})
					.catch(error => {
						console.error('导入失败:', error);
						this.importResultMessage = error.msg || '导入失败，请重试';
						this.importResultVisible = true;
					});
			};
			input.click();
		},
		// 关闭导入结果弹窗
		closeImportResult() {
			this.importResultVisible = false;
			this.importResultMessage = '';
		},
		// 处理订单添加成功事件，自动创建运费申请
		handleOrderAddedSuccess(orderData) {
			// 检查是否有陆运费
			if (orderData.landFreight && Number(orderData.landFreight) > 0 && orderData.landCarID) {
				const landFreightRow = {
					sourceId: orderData.id,
					source: '订单',
					transportType: 'land',
					freight: orderData.landFreight,
					carId: orderData.landCarID,
					fleet: orderData.fleet
				};
				// 延迟执行，确保订单列表已刷新
				this.$nextTick(() => {
					this.handleApplyLandFree(landFreightRow);
				});
			}
			// 检查是否有海运费
			if (orderData.seaFreight && Number(orderData.seaFreight) > 0 && orderData.seaCarID) {
				const seaFreightRow = {
					sourceId: orderData.id,
					source: '订单',
					transportType: 'sea',
					freight: orderData.seaFreight,
					carId: orderData.seaCarID,
					fleet: orderData.fleet
				};
				// 延迟执行，确保订单列表已刷新
				this.$nextTick(() => {
					this.handleApplySeaFree(seaFreightRow);
				});
			}
		}
	}
};
</script>

<template>
	<div>
		<!--    这是框架自带的搜索模组，封装成了组件并且放在与index.vue同级目录下-->
		<QuerySearchBar @updateQuery="handleGetQueryParamsDebounced" :is-adjust="isAdjustOrder" :current-page-num="queryParams.pageNum" :current-page-size="queryParams.pageSize" />
		<!--    订单修改记录查看-->
		<div>
			<OrderHistoryCheck :check-history-order-visible="checkHistoryOrderVisible" :order-history-info-list="orderHistoryInfoList" :current-info="currentOrderItemInfo" @close="closeOrderHistoryCheck" />
		</div>
		<!--      右侧的工具栏-->
		<div>
			<right-toolbar :columns="columns" @column-change="onColumnChange" @column-refresh="handleColumnRefresh" tableName="goodsorder-columns">
				<!-- 左侧的新增订单的按钮 -->
				<template #left>
					<div style="padding: 10px">
						<el-row :gutter="10">
							<el-col v-if="!isAdjustOrder" :span="1.5">
								<el-button v-hasPermi="['system:goodsorder:import']" size="mini" @click="handleDownloadTemplate">下载导入模板</el-button>
							</el-col>
							<el-col v-if="!isAdjustOrder" :span="1.5">
								<el-button v-hasPermi="['system:goodsorder:import']" size="mini" @click="handleImportData">导入模板</el-button>
							</el-col>
							<el-col v-if="!isAdjustOrder" :span="1.5">
								<el-button v-hasPermi="['system:goodsorder:add']" type="danger" size="mini" @click="handleAdd">添加订单信息</el-button>
							</el-col>
						</el-row>
					</div>
				</template>
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:goodsorder:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport">导出订单目录</el-button>
						<el-button v-hasPermi="['system:goodsorder:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExportNoPage">导出全部订单</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</div>

		<!--    订单表格  -->
		<virtual-scroll v-if="!isAdjustOrder" ref="virtualScroll" :data="goodsOrderList" :item-size="30" key-prop="id" @change="orderDataAppendChange">
			<template slot-scope="{ headerCellFixedStyle, cellFixedStyle }">
				<el-table
					border
					ref="orderTable"
					id="printBox"
					:row-key="row => row.id"
					v-loading="loading"
					v-horizontal-scroll="'always'"
					size="mini"
					height="650"
					style="width: 100%"
					:data="virtualGoodsOrderList"
					tooltip-effect="light"
					:headerCellStyle="headerCellFixedStyle"
					:cellStyle="cellFixedStyle"
					:row-class-name="getOrderRowClassName"
					@header-dragend="onHeaderDragend"
					show-summary
					:summary-method="getSummary"
				>
					<!-- 序号列 -->
					<VirtualColumn vfixed label="序号" align="center" width="50">
						<template slot-scope="scope">
							{{ scope.row._rowIndex }}
						</template>
					</VirtualColumn>
					<VirtualColumn vfixed label="行操作" align="center" class-name="small-padding fixed-width" width="100">
						<template slot-scope="scope">
							<el-dropdown size="mini" trigger="hover" @command="command => handleCommand(command, scope.row)">
								<el-button size="mini" type="text" @click.stop="checkOrderItemInfo(scope.row)">
									<span v-once>查看</span>
									<i class="el-icon-arrow-down el-icon--right" />
								</el-button>
								<el-dropdown-menu slot="dropdown">
									<!-- 修改 -->
									<el-dropdown-item v-hasPermi="['system:goodsorder:edit']" command="handleUpdate" :disabled="!scope.row.isedit || scope.row.isAdjust < 0 || isOrderExpired(scope.row.addtime)">
										<span :title="isOrderExpired(scope.row.addtime) ? '订单已超过7天，无法修改' : ''">修改</span>
									</el-dropdown-item>
									<!-- 删除 -->
									<el-dropdown-item v-hasPermi="['system:goodsorder:remove']" command="handleDelete">
										<span>删除</span>
									</el-dropdown-item>
									<!-- 修改记录 -->
									<el-dropdown-item :disabled="scope.row.historyCount === 0" divided command="checkHistoryList">
										<span>修改记录</span>
									</el-dropdown-item>
								</el-dropdown-menu>
							</el-dropdown>
						</template>
					</VirtualColumn>
					<!-- 1. ID -->
					<VirtualColumn v-if="columns[0].visible" vfixed show-overflow-tooltip label="ID" align="center" prop="id">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.id }}</div>
								<span>{{ scope.row.id }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 2. 日期 -->
					<VirtualColumn v-if="columns[1].visible" vfixed show-overflow-tooltip label="日期" align="center" prop="orderDate" width="200">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ parseTime(scope.row.orderDate, '{y}-{m}-{d}') }}</div>
								<span>{{ parseTime(scope.row.orderDate, '{y}-{m}-{d}') }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 3. 客户 -->
					<VirtualColumn v-if="columns[2].visible" vfixed show-overflow-tooltip label="客户" align="center" prop="customer" width="196">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.customer }}</div>
								<span class="customer-cell">
									<span>{{ scope.row.customer }}</span>
									<i v-if="!isAdjustOrder && scope.row._updatedAfter24Hours" class="el-icon-warning-outline customer-update-icon" title="该订单在创建超过24小时后有过修改"></i>
								</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 4. 供应商/仓库 -->
					<VirtualColumn v-if="columns[3].visible" vfixed show-overflow-tooltip label="供应商/仓库" align="center" prop="supplierNames" width="280">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content" @click.stop>
									<div class="supplier-warehouse-container">
										<span v-if="scope.row._uniqueSuppliers.length === 0 && scope.row._uniqueWarehouses.length === 0" class="empty-item">-</span>
										<span v-else>
											<span v-for="supplier in scope.row._uniqueSuppliers" :key="`supplier-${supplier.supplierID}`" class="supplier-name" @click="handleSupplierInvoiceClick(scope.row, supplier.supplierID)">
												{{ supplier.supplier }}
											</span>
											<span v-for="warehouse in scope.row._uniqueWarehouses" :key="`warehouse-${warehouse.storeHouseID}`" class="warehouse-name">
												{{ warehouse.storeHouseName }}
											</span>
										</span>
									</div>
								</div>
								<div ref="supplier-warehouse" class="supplier-warehouse-container">
									<span v-if="scope.row._uniqueSuppliers.length === 0 && scope.row._uniqueWarehouses.length === 0" class="empty-item" v-once>-</span>
									<span v-else>
										<span v-for="supplier in scope.row._uniqueSuppliers" :key="`supplier-${supplier.supplierID}`" class="supplier-name" @click="handleSupplierInvoiceClick(scope.row, supplier.supplierID)">
											{{ supplier.supplier }}
										</span>
										<!-- 显示预处理的仓库列表 -->
										<span v-for="warehouse in scope.row._uniqueWarehouses" :key="`warehouse-${warehouse.storeHouseID}`" class="warehouse-name">
											{{ warehouse.storeHouseName }}
										</span>
									</span>
								</div>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 5. 陆运车牌 -->
					<VirtualColumn v-if="columns[4].visible" vfixed show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" width="112">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.landCarNo }}</div>
								<span>{{ scope.row.landCarNo }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 6. 审核 -->
					<VirtualColumn v-if="columns[5].visible" show-overflow-tooltip label="审核" align="center" prop="checkState" width="112">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
								<div slot="content" @click.stop>
									<el-row v-if="scope.row.checkState === '已审核'">
										<StateTag :state-title="scope.row.checkState" :state-mapper="{ 2: '已审核' }" @click.native.stop="hasPermission(['finance', 'admin']) && handleReCheck(scope.row)" :style="{ cursor: hasPermission(['finance', 'admin']) ? 'pointer' : 'default' }" />
									</el-row>
									<el-row v-else>
										<!-- 只有财务和超级管理员可以审核 -->
										<el-button v-if="hasPermission(['finance', 'admin'])" type="text" size="mini" @click.stop="handleCheck(scope.row)">
											<span>审核</span>
										</el-button>
										<!-- 其他用户显示状态文本 -->
										<span v-else style="color: #909399; font-size: 12px">待审核</span>
									</el-row>
								</div>
								<el-row v-if="scope.row.checkState === '已审核'">
									<!-- 只有财务和超级管理员可以取消审核 -->
									<StateTag :state-title="scope.row.checkState" :state-mapper="{ 2: '已审核' }" @click.native="hasPermission(['finance', 'admin']) && handleReCheck(scope.row)" :style="{ cursor: hasPermission(['finance', 'admin']) ? 'pointer' : 'default' }" />
								</el-row>
								<el-row v-else>
									<el-row>
										<!-- 只有财务和超级管理员可以审核 -->
										<el-button v-if="hasPermission(['finance', 'admin'])" type="text" size="mini" @click="handleCheck(scope.row)">
											<span v-once>审核</span>
										</el-button>
										<!-- 其他用户显示状态文本 -->
										<span v-else style="color: #909399; font-size: 12px">
											<span v-once>待审核</span>
										</span>
									</el-row>
								</el-row>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 客户含税 -->
					<VirtualColumn v-if="columns[6].visible" show-overflow-tooltip label="客户含税" align="center" prop="customerTaxIncluded" width="112">
						<template #default="scope">
							<el-tooltip v-if="hasInvoice(scope.row, PUBLIC_DICT_TYPE.CUSTOMER)" effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
								<div slot="content" @click.stop>
									<el-row>
										<el-button type="text" size="mini" @click.stop="showCustomerInvoiceList(scope.row)">{{ scope.row.customerInvoiceStatus }}</el-button>
									</el-row>
								</div>
								<el-button type="text" size="mini" @click="showCustomerInvoiceList(scope.row)">{{ scope.row.customerInvoiceStatus }}</el-button>
							</el-tooltip>
							<el-tooltip v-else effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">否</div>
								<StateTag :state-title="'否'" :state-mapper="{ 3: '否' }" />
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 7. 车队 -->
					<VirtualColumn v-if="columns[7].visible" show-overflow-tooltip label="车队" align="center" prop="fleet" width="112">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.fleet }}</div>
								<span>{{ scope.row.fleet }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 8. 陆运电话 -->
					<VirtualColumn v-if="columns[8].visible" show-overflow-tooltip label="陆运电话" align="center" prop="landDriverTel" width="176">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.landDriverTel }}</div>
								<span>{{ scope.row.landDriverTel }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 9. 司机 -->
					<VirtualColumn v-if="columns[9].visible" show-overflow-tooltip label="司机" align="center" prop="landDriverName" width="84">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.landDriverName }}</div>
								<span>{{ scope.row.landDriverName }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 10. 海运柜号 -->
					<VirtualColumn v-if="columns[10].visible" show-overflow-tooltip label="海运柜号" align="center" prop="seaCarNo" width="176">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}</div>
								<span>{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 11. 海运电话 -->
					<VirtualColumn v-if="columns[11].visible" show-overflow-tooltip label="海运电话" align="center" prop="seaDriverTel" width="176">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}</div>
								<span>{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 12. 海运公司 -->
					<VirtualColumn v-if="columns[12].visible" show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="168">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverName }}</div>
								<span>{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverName }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 13. 总货款 -->
					<VirtualColumn v-if="columns[13].visible" show-overflow-tooltip label="总货款" align="center" prop="allPayments" width="144">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.allPayments | changeNumber(changeLength) }}</div>
								<span>{{ scope.row.allPayments | changeNumber(changeLength) }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 14. 总吨位 -->
					<VirtualColumn v-if="columns[14].visible" show-overflow-tooltip label="总吨位" align="center" prop="allTonnage" width="80">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.allTonnage | changeNumber(changeLength) }}</div>
								<span>{{ scope.row.allTonnage | changeNumber(changeLength) }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 出厂货款 -->
					<VirtualColumn v-if="columns[15].visible" show-overflow-tooltip label="出厂货款" align="center" prop="allPaymentFactory" width="144">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.allPaymentFactory | changeNumber(changeLength) }}</div>
								<span>{{ scope.row.allPaymentFactory | changeNumber(changeLength) }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 15. 陆运费 -->
					<VirtualColumn v-if="columns[16].visible" show-overflow-tooltip label="陆运费" align="center" prop="landFreight" width="112">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.landFreight }}</div>
								<span>{{ scope.row.landFreight }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 16. 海运费 -->
					<VirtualColumn v-if="columns[17].visible" show-overflow-tooltip label="海运费" align="center" prop="seaFreight" width="112">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.seaFreight }}</div>
								<span>{{ scope.row.seaFreight }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 17. 含税利润 -->
					<VirtualColumn v-if="columns[18].visible" show-overflow-tooltip label="含税利润" align="center" prop="allProfit" width="112">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.allProfit | changeNumber(changeLength) }}</div>
								<span>{{ scope.row.allProfit | changeNumber(changeLength) }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 18. 不含税利润 -->
					<VirtualColumn v-if="columns[19].visible" show-overflow-tooltip label="不含税利润" align="center" prop="allProfitNoTax" width="112">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.allProfitNoTax | changeNumber(changeLength) }}</div>
								<span>{{ scope.row.allProfitNoTax | changeNumber(changeLength) }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 19. 销售经理 -->
					<VirtualColumn v-if="columns[20].visible" show-overflow-tooltip label="销售经理" align="center" prop="saleManager" width="112">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.saleManager }}</div>
								<span>{{ scope.row.saleManager }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 20. 录入员 -->
					<VirtualColumn v-if="columns[21].visible" show-overflow-tooltip label="录入员" align="center" prop="userName" width="84">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.userName }}</div>
								<span>{{ scope.row.userName }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 21. 备注 -->
					<VirtualColumn v-if="columns[22].visible" show-overflow-tooltip label="备注" align="center" prop="comments" width="140">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.comments }}</div>
								<span>{{ scope.row.comments }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 22. 出库单 -->
					<VirtualColumn v-if="columns[23].visible" show-overflow-tooltip label="出库单" align="center" prop="path" width="84">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
								<div slot="content" @click.stop>
									<div v-if="Array.isArray(scope.row.attachmentList)">
										<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'path'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getGoodsOrder, updateGoodsOrder)" />
									</div>
									<div v-else>
										<el-tag type="danger">加载错误</el-tag>
									</div>
								</div>
								<div v-if="Array.isArray(scope.row.attachmentList)">
									<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'path'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getGoodsOrder, updateGoodsOrder)" />
								</div>
								<div v-else>
									<el-tag type="danger" v-once>加载错误</el-tag>
								</div>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 23. 收到条附件 -->
					<VirtualColumn v-if="columns[24].visible" show-overflow-tooltip label="收到条附件" align="center" prop="receiveProof">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
								<div slot="content" @click.stop>
									<div v-if="Array.isArray(scope.row.attachmentList)">
										<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'receiveProof'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getGoodsOrder, updateGoodsOrder)" />
									</div>
									<div v-else>
										<el-tag type="danger">加载错误</el-tag>
									</div>
								</div>
								<div v-if="Array.isArray(scope.row.attachmentList)">
									<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'receiveProof'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getGoodsOrder, updateGoodsOrder)" />
								</div>
								<div v-else>
									<el-tag type="danger" v-once>加载错误</el-tag>
								</div>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 24. 可否编辑 -->
					<VirtualColumn v-if="columns[25].visible" show-overflow-tooltip label="可否编辑" align="center" prop="isedit" width="112">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">
									<StateTag :state-title="scope.row.isedit === 0 ? '否' : '是'" :state-mapper="{ 0: '否', 2: '是' }" />
								</div>
								<StateTag :state-title="scope.row.isedit === 0 ? '否' : '是'" :state-mapper="{ 0: '否', 2: '是' }" />
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 26. 出厂含税 -->
					<VirtualColumn v-if="columns[26].visible" show-overflow-tooltip label="出厂含税" align="center" width="112">
						<template #default="scope">
							<el-tooltip v-if="hasInvoice(scope.row, PUBLIC_DICT_TYPE.SUPPLIER)" effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
								<div slot="content" @click.stop>
									<el-row>
										<el-button type="text" size="mini" @click.stop="showSupplierInvoiceList(scope.row)">{{ scope.row.supplierInvoiceStatus }}</el-button>
									</el-row>
								</div>
								<el-button type="text" size="mini" @click="showSupplierInvoiceList(scope.row)">{{ scope.row.supplierInvoiceStatus }}</el-button>
							</el-tooltip>
							<el-tooltip v-else effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">否</div>
								<StateTag :state-title="'否'" :state-mapper="{ 3: '否' }" />
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!-- 27. 审核人 -->
					<VirtualColumn v-if="columns[27].visible" show-overflow-tooltip label="审核人" align="center" prop="checkUserName" width="112">
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.checkUserName || '-' }}</div>
								<span>{{ scope.row.checkUserName || '-' }}</span>
							</el-tooltip>
						</template>
					</VirtualColumn>
					<!--      右侧操作栏-->
					<VirtualColumn vfixed="right" show-overflow-tooltip label="订单操作" align="center" class-name="small-padding fixed-width" width="250">
						<template slot-scope="scope">
							<div>
								<el-button size="mini" :disabled="scope.row.isAdjusted !== 1" v-if="!isAdjustOrder" @click="handleCheckAdjust(scope.row)">查看调整单</el-button>
								<el-button size="mini" :disabled="scope.row.isAdjusted === 1" @click="handleTrackedRowAction('handleOrderItemInfo', scope.row)">调整单</el-button>
								<el-button v-if="isAdjustOrder" size="mini" @click="handleCheckPrevious(scope.row)">查看原单据</el-button>
								<!-- 发货单操作：单独展示发货单1 + 下拉中的发货单2/3 -->
								<el-button size="mini" @click="handleTrackedRowAction('handleOrder1', scope.row)">发货单1</el-button>
								<el-dropdown size="mini" trigger="click">
									<el-button type="text" size="mini">
										<span v-once>发货单</span>
										<i class="el-icon-arrow-down el-icon--right" />
									</el-button>
									<el-dropdown-menu slot="dropdown">
										<el-dropdown-item>
											<el-button size="mini" @click="handleTrackedRowAction('handleOrder2', scope.row)">发货单2</el-button>
										</el-dropdown-item>
										<el-dropdown-item>
											<el-button size="mini" @click="handleTrackedRowAction('handleOrder3', scope.row)">发货单3</el-button>
										</el-dropdown-item>
									</el-dropdown-menu>
								</el-dropdown>
							</div>
						</template>
					</VirtualColumn>
				</el-table>
			</template>
		</virtual-scroll>
		<el-table
			v-else
			border
			ref="orderTable"
			id="printBox"
			:row-key="row => row.id"
			v-loading="loading"
			size="mini"
			height="650"
			style="width: 100%"
			:data="goodsOrderList"
			tooltip-effect="light"
			:row-class-name="getOrderRowClassName"
			show-summary
			:summary-method="getSummary"
			@header-dragend="onHeaderDragend"
		>
			<el-table-column v-for="col in adjustTableColumns" :key="col.idx" :label="col.label" :prop="col.prop" :width="col.width" :fixed="col.fixed" :align="col.align || 'center'" show-overflow-tooltip>
				<template slot-scope="scope">
					<!-- 序号 -->
					<template v-if="col.idx === 'index'">
						{{ scope.row && scope.row._rowIndex !== undefined && scope.row._rowIndex !== null ? scope.row._rowIndex : scope.$index + 1 }}
					</template>
					<!-- 行操作 -->
					<template v-else-if="col.idx === 'rowActions'">
						<el-dropdown size="mini" trigger="hover" @command="command => handleCommand(command, scope.row)">
							<el-button size="mini" type="text" @click.stop="checkOrderItemInfo(scope.row)">
								<span v-once>查看</span>
								<i class="el-icon-arrow-down el-icon--right" />
							</el-button>
							<el-dropdown-menu slot="dropdown">
								<el-dropdown-item v-hasPermi="['system:goodsorder:edit']" command="handleUpdate" :disabled="!scope.row.isedit || scope.row.isAdjust < 0 || isOrderExpired(scope.row.addtime)">
									<span :title="isOrderExpired(scope.row.addtime) ? '订单已超过7天，无法修改' : ''">修改</span>
								</el-dropdown-item>
								<el-dropdown-item v-hasPermi="['system:goodsorder:remove']" command="handleDelete">
									<span>删除</span>
								</el-dropdown-item>
								<el-dropdown-item :disabled="scope.row.historyCount === 0" divided command="checkHistoryList">
									<span>修改记录</span>
								</el-dropdown-item>
							</el-dropdown-menu>
						</el-dropdown>
					</template>
					<!-- 客户 -->
					<template v-else-if="col.idx === 2">
						<span class="customer-cell">
							<span>{{ scope.row.customer }}</span>
							<i v-if="!isAdjustOrder && scope.row._updatedAfter24Hours" class="el-icon-warning-outline customer-update-icon" title="该订单在创建超过24小时后有过修改"></i>
						</span>
					</template>
					<!-- 供应商/仓库 -->
					<template v-else-if="col.idx === 3">
						<div class="supplier-warehouse-container">
							<span v-if="(scope.row._uniqueSuppliers || []).length === 0 && (scope.row._uniqueWarehouses || []).length === 0" class="empty-item">-</span>
							<span v-else>
								<span v-for="supplier in scope.row._uniqueSuppliers || []" :key="`supplier-${supplier.supplierID}`" class="supplier-name" @click="handleSupplierInvoiceClick(scope.row, supplier.supplierID)">
									{{ supplier.supplier }}
								</span>
								<span v-for="warehouse in scope.row._uniqueWarehouses || []" :key="`warehouse-${warehouse.storeHouseID}`" class="warehouse-name">
									{{ warehouse.storeHouseName }}
								</span>
							</span>
						</div>
					</template>
					<!-- 审核 -->
					<template v-else-if="col.idx === 5">
						<el-row v-if="scope.row.checkState === '已审核'">
							<StateTag :state-title="scope.row.checkState" :state-mapper="{ 2: '已审核' }" @click.native.stop="hasPermission(['finance', 'admin']) && handleReCheck(scope.row)" :style="{ cursor: hasPermission(['finance', 'admin']) ? 'pointer' : 'default' }" />
						</el-row>
						<el-row v-else>
							<el-button v-if="hasPermission(['finance', 'admin'])" type="text" size="mini" @click.stop="handleCheck(scope.row)">
								<span>审核</span>
							</el-button>
							<span v-else style="color: #909399; font-size: 12px">待审核</span>
						</el-row>
					</template>
					<!-- 出库单 -->
					<template v-else-if="col.idx === 22">
						<div v-if="Array.isArray(scope.row.attachmentList)">
							<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'path'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getGoodsOrder, updateGoodsOrder)" />
						</div>
						<el-tag v-else type="danger">加载错误</el-tag>
					</template>
					<!-- 收到条附件 -->
					<template v-else-if="col.idx === 23">
						<div v-if="Array.isArray(scope.row.attachmentList)">
							<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'receiveProof'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getGoodsOrder, updateGoodsOrder)" />
						</div>
						<el-tag v-else type="danger">加载错误</el-tag>
					</template>
					<!-- 可否编辑 -->
					<template v-else-if="col.idx === 24">
						<StateTag :state-title="scope.row.isedit === 0 ? '否' : '是'" :state-mapper="{ 0: '否', 2: '是' }" />
					</template>
					<!-- 客户含税 -->
					<template v-else-if="col.idx === 25">
						<template v-if="hasInvoice(scope.row, PUBLIC_DICT_TYPE.CUSTOMER)">
							<el-button type="text" size="mini" @click="showCustomerInvoiceList(scope.row)">{{ scope.row.customerInvoiceStatus }}</el-button>
						</template>
						<StateTag v-else :state-title="'否'" :state-mapper="{ 3: '否' }" />
					</template>
					<!-- 出厂含税 -->
					<template v-else-if="col.idx === 26">
						<template v-if="hasInvoice(scope.row, PUBLIC_DICT_TYPE.SUPPLIER)">
							<el-button type="text" size="mini" @click="showSupplierInvoiceList(scope.row)">{{ scope.row.supplierInvoiceStatus }}</el-button>
						</template>
						<StateTag v-else :state-title="'否'" :state-mapper="{ 3: '否' }" />
					</template>
					<!-- 订单操作 -->
					<template v-else-if="col.idx === 'orderActions'">
						<div>
							<el-button size="mini" :disabled="scope.row.isAdjusted !== 1" v-if="!isAdjustOrder" @click="handleCheckAdjust(scope.row)">查看调整单</el-button>
							<el-button size="mini" :disabled="scope.row.isAdjusted === 1" @click="handleTrackedRowAction('handleOrderItemInfo', scope.row)">调整单</el-button>
							<el-button v-if="isAdjustOrder" size="mini" @click="handleCheckPrevious(scope.row)">查看原单据</el-button>
							<el-button size="mini" @click="handleTrackedRowAction('handleOrder1', scope.row)">发货单1</el-button>
							<el-dropdown size="mini" trigger="click">
								<el-button type="text" size="mini">
									<span v-once>发货单</span>
									<i class="el-icon-arrow-down el-icon--right" />
								</el-button>
								<el-dropdown-menu slot="dropdown">
									<el-dropdown-item>
										<el-button size="mini" @click="handleTrackedRowAction('handleOrder2', scope.row)">发货单2</el-button>
									</el-dropdown-item>
									<el-dropdown-item>
										<el-button size="mini" @click="handleTrackedRowAction('handleOrder3', scope.row)">发货单3</el-button>
									</el-dropdown-item>
								</el-dropdown-menu>
							</el-dropdown>
						</div>
					</template>
					<!-- 默认展示 -->
					<template v-else>
						<template v-if="[12, 13, 14, 17, 18].includes(col.idx)">
							{{ scope.row[col.prop] | changeNumber(changeLength) }}
						</template>
						<template v-else-if="[9, 10, 11].includes(col.idx)">
							{{ scope.row[col.prop] || '无' }}
						</template>
						<template v-else>
							{{ scope.row[col.prop] || (scope.row[col.prop] === 0 ? 0 : '') }}
						</template>
					</template>
				</template>
			</el-table-column>
		</el-table>
		<!--    分页组件-->
		<pagination v-if="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<br />
		<div v-if="isAdjustOrder">
			<el-row>
				<el-card class="box-card">
					<div slot="header" class="clearfix">
						<span style="font-weight: bold; font-size: 16px">调整次数示意</span>
						<el-tooltip
							content="负数单，表示该订单为调整订单A后，A订单产生的负数订单，数值与A订单为相反数调整一次意为订单A调整一次,产生的调整单B,记录此时该调整单B为一次调整;调整两次为，对调整单B进行调整，生成调整单C,记录该调整单C为二次调整,以此类推"
							placement="bottom"
							effect="light"
							:open-delay="1000"
						>
							<el-button style="float: right; padding: 3px 0" type="text">解释?</el-button>
						</el-tooltip>
					</div>
					<el-alert title="订单列表点击调整单后，会在此生成调整单，不能对负数单进行调整，且负数单不可修改!" type="warning" style="margin-bottom: 10px" show-icon effect="light" />
					<el-tag class="custom-tag">负数单</el-tag>
					<el-tag type="info" class="tag-spacing">调整一次</el-tag>
					<el-tag type="success" class="tag-spacing">调整两次</el-tag>
					<el-tag type="warning" class="tag-spacing">调整三次</el-tag>
					<el-tag style="background-color: #ed5b3a; color: white" class="tag-spacing">三次以上</el-tag>
				</el-card>
			</el-row>
		</div>

		<!-- 客户开票列表弹窗 -->
		<el-dialog
			:modal="false"
			title="客户开票记录"
			:visible.sync="customerInvoiceListVisible"
			width="70%"
			:before-close="closeCustomerInvoiceList"
			class="invoice-list-dialog compact-dialog"
			append-to-body
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:close-on-press-escape="false"
			:destroy-on-close="false"
		>
			<div v-if="currentOrderInfo" class="invoice-dialog-content">
				<!-- 订单信息卡片 -->
				<el-card class="order-info-card" shadow="hover">
					<div class="order-info-header">
						<i class="el-icon-document-checked"></i>
						<span class="order-title">订单信息</span>
					</div>
					<div class="order-info-content">
						<div class="order-info-item">
							<span class="info-label">订单ID:</span>
							<span class="info-value order-id">#{{ currentOrderInfo.id }}</span>
						</div>
						<div class="order-info-item">
							<span class="info-label">客户名称:</span>
							<span class="info-value customer-name">{{ currentOrderInfo.customer }}</span>
						</div>
						<div class="order-info-item">
							<span class="info-label">总货款:</span>
							<span class="info-value total-amount">¥{{ Number(currentOrderInfo.allPayments || 0).toLocaleString() }}</span>
						</div>
					</div>
				</el-card>

				<!-- 操作按钮区域 -->
				<div class="action-bar">
					<div class="action-left">
						<el-tag v-if="customerInvoiceList.length > 0" type="info" size="medium">
							<i class="el-icon-tickets"></i>
							已开票 {{ customerInvoiceList.length }} 次
						</el-tag>
					</div>
					<div class="action-right">
						<el-button type="primary" size="medium" @click="handleAddCustomerInvoice" class="add-invoice-btn">
							<i class="el-icon-plus"></i>
							新增开票
						</el-button>
					</div>
				</div>

				<!-- 开票记录表格 -->
				<div class="invoice-table-container">
					<el-table v-loading="customerInvoiceListLoading" :data="customerInvoiceList" border stripe class="invoice-table compact-table" size="small" :header-cell-style="{ background: '#f8f9fa', color: '#495057', fontWeight: 600 }" :row-class-name="getInvoiceRowClassName">
						<el-table-column prop="orderDate" label="日期" align="center">
							<template #default="scope">
								<div class="date-cell">
									<i class="el-icon-date"></i>
									{{ currentOrderInfo && currentOrderInfo.orderDate ? parseTime(currentOrderInfo.orderDate, '{y}-{m}-{d}') : '-' }}
								</div>
							</template>
						</el-table-column>

						<el-table-column prop="companyName" label="客户名称" align="center">
							<template #default="scope">
								<div class="company-cell">
									<i class="el-icon-office-building"></i>
									{{ scope.row.companyName }}
								</div>
							</template>
						</el-table-column>

						<el-table-column prop="allPayments" label="需开票金额" align="center">
							<template #default="scope">
								<div class="amount-cell need-amount">
									<span class="currency-symbol">¥</span>
									{{ Number(currentOrderInfo ? currentOrderInfo.allPayments : 0).toLocaleString() }}
								</div>
							</template>
						</el-table-column>

						<el-table-column prop="invoiceDate" label="开票时间" align="center">
							<template #default="scope">
								<div class="datetime-cell">
									<i class="el-icon-time"></i>
									{{ scope.row.invoiceDate ? parseTime(scope.row.invoiceDate, '{y}-{m}-{d} {h}:{i}') : '-' }}
								</div>
							</template>
						</el-table-column>

						<el-table-column prop="invoiceAmount" label="开票金额" align="center">
							<template #default="scope">
								<div class="amount-cell invoiced-amount">
									<span class="currency-symbol">¥</span>
									{{ Number(scope.row.invoiceAmount || 0).toLocaleString() }}
								</div>
							</template>
						</el-table-column>

						<el-table-column label="累计开票金额" align="center">
							<template #default="scope">
								<div class="amount-cell accumulated-amount">
									<span class="currency-symbol">¥</span>
									{{ Number(calculateAccumulatedInvoiceAmount(scope.$index)).toLocaleString() }}
								</div>
							</template>
						</el-table-column>
					</el-table>
				</div>
			</div>
		</el-dialog>

		<!-- 供应商开票列表弹窗 -->
		<el-dialog
			:modal="false"
			title="供应商开票记录"
			:visible.sync="supplierInvoiceListVisible"
			width="75%"
			:before-close="closeSupplierInvoiceList"
			class="invoice-list-dialog supplier-invoice-dialog compact-dialog"
			append-to-body
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:close-on-press-escape="false"
			:destroy-on-close="false"
		>
			<div v-if="currentOrderInfo" class="invoice-dialog-content">
				<!-- 订单信息卡片 -->
				<el-card class="order-info-card" shadow="hover">
					<div class="order-info-header">
						<i class="el-icon-document-checked"></i>
						<span class="order-title">订单信息</span>
					</div>
					<div class="order-info-content">
						<div class="order-info-item">
							<span class="info-label">订单ID:</span>
							<span class="info-value order-id">{{ currentOrderInfo.id }}</span>
						</div>
						<div class="order-info-item">
							<span class="info-label">供应商数量:</span>
							<span class="info-value total-amount">{{ supplierInvoiceGroups.length }} 家</span>
						</div>
					</div>
				</el-card>

				<!-- 供应商开票记录分组展示 -->
				<div v-if="supplierInvoiceGroups.length > 0" class="supplier-groups-container">
					<div v-for="group in supplierInvoiceGroups" :key="group.companyId" class="supplier-group-card">
						<!-- 供应商信息标题 -->
						<div class="supplier-group-header">
							<div class="supplier-info">
								<i class="el-icon-office-building"></i>
								<span class="supplier-name">{{ group.companyName }}</span>
								<el-tag type="warning" size="small" style="margin-left: 10px">{{ group.invoices.length }} 条记录</el-tag>
							</div>
							<div class="supplier-actions">
								<el-button type="primary" size="small" @click="handleAddSupplierInvoice(group)">
									<i class="el-icon-plus"></i>
									新增开票
								</el-button>
							</div>
						</div>

						<!-- 该供应商的开票记录表格 -->
						<div class="supplier-table-container">
							<el-table :data="group.invoices" border stripe size="small" class="supplier-invoice-table" :header-cell-style="{ background: '#f8f9fa', color: '#495057', fontWeight: 600 }">
								<el-table-column prop="orderDate" label="日期" align="center">
									<template #default="scope">
										<div class="date-cell">
											<i class="el-icon-date"></i>
											{{ currentOrderInfo && currentOrderInfo.orderDate ? parseTime(currentOrderInfo.orderDate, '{y}-{m}-{d}') : '-' }}
										</div>
									</template>
								</el-table-column>

								<el-table-column prop="companyName" label="供应商名称" align="center">
									<template #default="scope">
										<div class="company-cell">
											<i class="el-icon-office-building"></i>
											{{ scope.row.companyName }}
										</div>
									</template>
								</el-table-column>

								<el-table-column label="需开票金额" align="center">
									<template #default="scope">
										<div class="amount-cell need-amount">
											<span class="currency-symbol">¥</span>
											{{ Number(group.needInvoiceAmount).toLocaleString() }}
										</div>
									</template>
								</el-table-column>

								<el-table-column prop="invoiceDate" label="开票时间" align="center">
									<template #default="scope">
										<div class="datetime-cell">
											<i class="el-icon-time"></i>
											{{ scope.row.invoiceDate }}
										</div>
									</template>
								</el-table-column>

								<el-table-column prop="invoiceAmount" label="开票金额" align="center">
									<template #default="scope">
										<div class="amount-cell invoiced-amount">
											<span class="currency-symbol">¥</span>
											{{ Number(scope.row.invoiceAmount || 0).toLocaleString() }}
										</div>
									</template>
								</el-table-column>

								<el-table-column label="累计开票金额" align="center">
									<template #default="scope">
										<div class="amount-cell accumulated-amount">
											<span class="currency-symbol">¥</span>
											{{ Number(calculateSupplierAccumulatedInvoiceAmount(group.invoices, scope.$index)).toLocaleString() }}
										</div>
									</template>
								</el-table-column>
							</el-table>
						</div>
					</div>
				</div>
			</div>
		</el-dialog>

		<!-- 导入结果弹窗 -->
		<el-dialog title="导入结果" :visible.sync="importResultVisible" width="500px" :close-on-click-modal="false" append-to-body>
			<div style="padding: 20px 0">
				<div style="margin-bottom: 15px; font-weight: 600; font-size: 16px">导入结果：完成</div>
				<div style="color: #606266; line-height: 1.6; white-space: pre-line">{{ importResultMessage }}</div>
			</div>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="closeImportResult">确定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
// 客户开票列表弹窗样式
.invoice-list-dialog {
	.invoice-dialog-content {
		padding: 0;
	}

	.order-info-card {
		margin-bottom: 20px;
		border-radius: 8px;
		border: 1px solid #e4e7ed;

		.order-info-header {
			display: flex;
			align-items: center;
			margin-bottom: 15px;
			color: #409eff;

			i {
				font-size: 18px;
				margin-right: 8px;
			}

			.order-title {
				font-size: 16px;
				font-weight: 600;
			}
		}

		.order-info-content {
			display: flex;
			flex-wrap: wrap;
			gap: 20px;

			.order-info-item {
				display: flex;
				align-items: center;
				flex: 1;
				min-width: 200px;

				.info-label {
					color: #606266;
					font-weight: 500;
					margin-right: 8px;
					white-space: nowrap;
				}

				.info-value {
					font-weight: 600;

					&.order-id {
						color: #409eff;
					}

					&.customer-name {
						color: #67c23a;
					}

					&.total-amount {
						color: #e6a23c;
						font-size: 16px;
					}
				}
			}
		}
	}

	.action-bar {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 20px;

		.action-left {
			.el-tag {
				font-size: 13px;

				i {
					margin-right: 5px;
				}
			}
		}

		.add-invoice-btn {
			border-radius: 6px;
			font-weight: 500;
			box-shadow: 0 2px 4px rgba(64, 158, 255, 0.3);

			&:hover {
				box-shadow: 0 4px 8px rgba(64, 158, 255, 0.4);
				transform: translateY(-1px);
			}

			i {
				margin-right: 5px;
			}
		}
	}

	.invoice-table-container {
		.invoice-table {
			border-radius: 8px;
			overflow: hidden;

			.date-cell,
			.datetime-cell,
			.company-cell {
				display: flex;
				align-items: center;
				justify-content: center;

				i {
					margin-right: 6px;
					color: #909399;
				}
			}

			.amount-cell {
				display: flex;
				align-items: center;
				justify-content: center;
				font-weight: 600;

				.currency-symbol {
					margin-right: 2px;
					color: #909399;
				}

				&.need-amount {
					color: #e6a23c;
				}

				&.invoiced-amount {
					color: #67c23a;
				}

				&.accumulated-amount {
					color: #409eff;
					font-size: 14px;
				}
			}
		}
	}

	.empty-state {
		text-align: center;
		padding: 60px 20px;

		.empty-content {
			max-width: 300px;
			margin: 0 auto;

			.empty-icon {
				font-size: 64px;
				color: #c0c4cc;
				margin-bottom: 20px;
			}

			.empty-title {
				color: #303133;
				font-size: 18px;
				font-weight: 500;
				margin: 0 0 10px 0;
			}

			.empty-description {
				color: #909399;
				font-size: 14px;
				margin: 0 0 25px 0;
				line-height: 1.5;
			}

			.empty-action-btn {
				border-radius: 20px;
				padding: 8px 20px;
				font-size: 13px;
				box-shadow: 0 2px 6px rgba(64, 158, 255, 0.3);

				&:hover {
					box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
					transform: translateY(-2px);
				}

				i {
					margin-right: 5px;
				}
			}
		}
	}
}

// 供应商开票列表弹窗专属样式
.supplier-invoice-dialog {
	.supplier-groups-container {
		.supplier-group-card {
			margin-bottom: 25px;
			border: 1px solid #e4e7ed;
			border-radius: 8px;
			overflow: hidden;
			background: #fff;
			box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

			&:last-child {
				margin-bottom: 0;
			}

			.supplier-group-header {
				display: flex;
				justify-content: space-between;
				align-items: center;
				padding: 15px 20px;
				background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
				border-bottom: 1px solid #e4e7ed;

				.supplier-info {
					display: flex;
					align-items: center;

					i {
						font-size: 18px;
						color: #e6a23c;
						margin-right: 8px;
					}

					.supplier-name {
						font-size: 16px;
						font-weight: 600;
						color: #303133;
					}
				}

				.supplier-actions {
					.el-button {
						border-radius: 6px;
						font-size: 13px;
						padding: 6px 12px;
						box-shadow: 0 2px 4px rgba(230, 162, 60, 0.3);

						&:hover {
							box-shadow: 0 4px 8px rgba(230, 162, 60, 0.4);
							transform: translateY(-1px);
						}

						i {
							margin-right: 4px;
						}
					}
				}
			}

			.supplier-table-container {
				padding: 0;

				.supplier-invoice-table {
					border: none;
					margin: 0;

					.date-cell,
					.datetime-cell,
					.company-cell {
						display: flex;
						align-items: center;
						justify-content: center;

						i {
							margin-right: 6px;
							color: #909399;
						}
					}

					.amount-cell {
						display: flex;
						align-items: center;
						justify-content: center;
						font-weight: 600;

						.currency-symbol {
							margin-right: 2px;
							color: #909399;
						}

						&.need-amount {
							color: #e6a23c;
						}

						&.invoiced-amount {
							color: #67c23a;
						}

						&.accumulated-amount {
							color: #409eff;
							font-size: 14px;
						}
					}
				}

				.supplier-empty-state {
					text-align: center;
					padding: 30px 20px;
					background: #fafafa;

					.empty-content {
						max-width: 250px;
						margin: 0 auto;

						.empty-icon {
							font-size: 48px;
							color: #d3d4d6;
							margin-bottom: 15px;
						}

						.empty-title {
							color: #606266;
							font-size: 14px;
							font-weight: 500;
							margin: 0 0 8px 0;
						}

						.empty-description {
							color: #909399;
							font-size: 12px;
							margin: 0 0 15px 0;
							line-height: 1.4;
						}

						.empty-action-btn {
							border-radius: 15px;
							padding: 6px 15px;
							font-size: 12px;
							box-shadow: 0 2px 4px rgba(230, 162, 60, 0.3);

							&:hover {
								box-shadow: 0 4px 8px rgba(230, 162, 60, 0.4);
								transform: translateY(-1px);
							}

							i {
								margin-right: 4px;
							}
						}
					}
				}
			}
		}
	}
}

// 供应商和仓库的容器
.supplier-warehouse-container {
	display: inline-flex;
	align-items: center;
	justify-content: flex-start;
	flex-wrap: nowrap;
	/* 避免换行导致高度不一致 */
	gap: 4px;
	max-width: 100%;
	overflow: hidden;
	line-height: 1.2;
}

.supplier-name {
	color: #409eff; // 蓝色表示供应商
	cursor: pointer;
	display: inline-block;
	margin-right: 4px;
	white-space: nowrap;
	font-weight: 500;

	&:hover {
		color: #df6565;
		font-weight: bold;
	}

	&:not(:last-of-type)::after {
		content: ',';
		margin-right: 4px;
		color: #909399;
	}
}

.warehouse-name {
	color: #67c23a; // 绿色表示仓库
	display: inline-block;
	margin-right: 4px;
	white-space: nowrap;
	font-weight: 500;

	&:not(:last-of-type)::after {
		content: ',';
		margin-right: 4px;
		color: #909399;
	}
}

.empty-item {
	color: #909399; // 灰色表示空项
	display: inline-block;
	font-style: italic;
}

.invoice {
	width: 100%;
	height: 100%;

	&:hover {
		cursor: pointer;
		color: #df6565;
		font-weight: bold;
	}
}

.tag-spacing {
	margin-right: 8px;
}

.custom-tag {
	background-color: #ffffff !important;
	/* 背景颜色设为白色 */
	border: 0.4px solid #aed3fa !important;
	/* 边框颜色自定义（这里用了蓝色） */
	color: #a6a5a5 !important;
	/* 文本颜色与边框一致 */
	font-weight: bold;
	/* 字体加粗 */
	margin-right: 8px;
}

// 紧凑型对话框样式
::v-deep .compact-dialog {
	.el-dialog__body {
		padding: 15px;
	}

	.el-dialog__header {
		padding: 15px 20px 10px;
	}
}

// 淡入淡出过渡效果
.fade-enter-active,
.fade-leave-active {
	transition: opacity 0.3s ease;
}

.fade-enter,
.fade-leave-to {
	opacity: 0;
}

// 调整单行高亮：需要作用到 td（ElementUI 背景绘制在单元格上）
// 同时覆盖：主表体 / 左固定列 / 右固定列（它们是不同的 wrapper）
::v-deep .el-table__body-wrapper tr.adjust-row-1 > td,
::v-deep .el-table__fixed-body-wrapper tr.adjust-row-1 > td,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.adjust-row-1 > td {
	background-color: #e9e9e9 !important;
}
::v-deep .el-table__body-wrapper tr.adjust-row-2 > td,
::v-deep .el-table__fixed-body-wrapper tr.adjust-row-2 > td,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.adjust-row-2 > td {
	background-color: #e1f3d8 !important;
}
::v-deep .el-table__body-wrapper tr.adjust-row-3 > td,
::v-deep .el-table__fixed-body-wrapper tr.adjust-row-3 > td,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.adjust-row-3 > td {
	background-color: #faecd8 !important;
}
::v-deep .el-table__body-wrapper tr.adjust-row-gt3 > td,
::v-deep .el-table__fixed-body-wrapper tr.adjust-row-gt3 > td,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.adjust-row-gt3 > td {
	background-color: #fbc4c4 !important;
}

::v-deep .el-table__body-wrapper tr.active-order-action-row > td,
::v-deep .el-table__fixed-body-wrapper tr.active-order-action-row > td,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.active-order-action-row > td {
	background-color: #fff7e8 !important;
	box-shadow: inset 0 1px 0 #e6a23c, inset 0 -1px 0 #e6a23c;
}

::v-deep .el-table__body-wrapper tr.active-order-action-row > td:first-child,
::v-deep .el-table__fixed-body-wrapper tr.active-order-action-row > td:first-child,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.active-order-action-row > td:first-child {
	box-shadow: inset 3px 0 0 #e6a23c, inset 0 1px 0 #e6a23c, inset 0 -1px 0 #e6a23c;
}

::v-deep .el-table__body-wrapper tr.adjust-row-negative.active-order-action-row > td,
::v-deep .el-table__fixed-body-wrapper tr.adjust-row-negative.active-order-action-row > td,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.adjust-row-negative.active-order-action-row > td {
	background-color: #f9dfdf !important;
}

::v-deep .el-table__body-wrapper tr.adjust-row-1.active-order-action-row > td,
::v-deep .el-table__fixed-body-wrapper tr.adjust-row-1.active-order-action-row > td,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.adjust-row-1.active-order-action-row > td {
	background-color: #f3ead7 !important;
}

::v-deep .el-table__body-wrapper tr.adjust-row-2.active-order-action-row > td,
::v-deep .el-table__fixed-body-wrapper tr.adjust-row-2.active-order-action-row > td,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.adjust-row-2.active-order-action-row > td {
	background-color: #e7f4dc !important;
}

::v-deep .el-table__body-wrapper tr.adjust-row-3.active-order-action-row > td,
::v-deep .el-table__fixed-body-wrapper tr.adjust-row-3.active-order-action-row > td,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.adjust-row-3.active-order-action-row > td {
	background-color: #fbf0de !important;
}

::v-deep .el-table__body-wrapper tr.adjust-row-gt3.active-order-action-row > td,
::v-deep .el-table__fixed-body-wrapper tr.adjust-row-gt3.active-order-action-row > td,
::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.adjust-row-gt3.active-order-action-row > td {
	background-color: #f8d2c5 !important;
}

@keyframes fadeInRow {
	from {
		opacity: 0;
		transform: translateY(-10px);
	}

	to {
		opacity: 1;
		transform: translateY(0);
	}
}

// 交互式 tooltip 样式，确保内容可以点击
::v-deep .interactive-tooltip {
	pointer-events: auto !important;

	.el-tooltip__popper {
		pointer-events: auto !important;
	}

	.el-tooltip__popper__inner {
		pointer-events: auto !important;
	}

	// 确保按钮和可点击元素可以正常交互
	.el-button,
	.el-tag,
	span[style*='cursor: pointer'],
	* {
		pointer-events: auto !important;
	}
}

.customer-cell {
	display: inline-flex;
	align-items: center;
	gap: 4px;
}

.customer-update-icon {
	color: #e6a23c;
	font-size: 14px;
	flex-shrink: 0;
}
</style>
