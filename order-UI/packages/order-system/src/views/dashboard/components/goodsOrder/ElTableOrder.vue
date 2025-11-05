<script>
import { delGoodsOrder, getGoodsOrder, updateGoodsOrder } from '@/api/system/goodsOrder';
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
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import reLength from '@/views/dashboard/mixins/reLength';
import GOODS_ORDER from '../../../../components/NeedToShow/GOODS_ORDER.vue';
import QuerySearchBar from './QuerySearchBar.vue';
import { mixin_order_orderHistory } from '@/views/dashboard/mixins/order/order_history';
import OrderHistoryCheck from '@/views/dashboard/components/goodsOrder/OrderHistoryCheck.vue';
import { parseTime } from '@/utils/ruoyi';
import HistoryList from '@/views/dashboard/components/goodsOrder/HistoryList.vue';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import StateTag from '@/views/dashboard/components/common/StateTag.vue';
import { auditGoodsOrder, listGoodsOrder } from '../../../../api/system/goodsOrder';
import CheckOrder from '@/views/dashboard/components/goodsOrder/CheckOrder.vue';
// 前端Excel导出依赖
import * as XLSX from 'xlsx';
import { debounce } from 'lodash';
import ExpandCursor from '../common/ExpandCursor.vue';
import { batchGetUserConfig, getUserConfig, listUserConfig, saveUserConfig } from '../../../../api/user-config';

export default {
	name: 'ElTableOrder',
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		paddingFix() {
			return { padding: '.4px' };
		}
	},
	components: {
		StateTag,
		HistoryList,
		OrderHistoryCheck,
		CheckFiles,
		QuerySearchBar,
		ExpandCursor
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
		mixin_order_orderHistory
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
				{ key: 4, label: '审核状态', visible: true },
				{ key: 5, label: '车队', visible: true },
				{ key: 6, label: '陆运车牌', visible: true },
				{ key: 7, label: '陆运司机电话', visible: true },
				{ key: 8, label: '陆地司机姓名', visible: true },
				{ key: 9, label: '海运柜号', visible: true },
				{ key: 10, label: '海运司机电话', visible: true },
				{ key: 11, label: '海运公司', visible: true },
				{ key: 12, label: '总货款', visible: true },
				{ key: 13, label: '总吨位', visible: true },
				{ key: 14, label: '陆运费', visible: true },
				{ key: 15, label: '海运费', visible: true },
				{ key: 16, label: '总利润(含税)', visible: true },
				{ key: 17, label: '总利润(不含税)', visible: true },
				{ key: 18, label: '销售经理', visible: true },
				{ key: 19, label: '录入员', visible: true },
				{ key: 20, label: '备注', visible: true },
				{ key: 21, label: '附件', visible: true },
				{ key: 22, label: '收到条附件', visible: true },
				{ key: 23, label: '是否可编辑', visible: true },
				{ key: 24, label: '客户是否含税', visible: true },
				{ key: 25, label: '供应商是否开票', visible: true }
			]
		};
	},
	watch: {
		columns: {
			handler(newVal, oldVal) {
				newVal.forEach((column, index) => {
					if (column.visible !== oldVal[index]?.visible) {
						debounce(() => {
							localStorage.setItem('goodsorder-columns', JSON.stringify(newVal));
						}, 500);
					}
				});
			},
			deep: true
		},
		// 监听 loading 状态，当数据加载完成后确保滚动事件已绑定
		loading(newVal, oldVal) {
			if (oldVal === true && newVal === false) {
				// 数据加载完成，确保滚动事件已绑定
				this.$nextTick(() => {
					this.bindTableScroll();
				});
			}
		}
	},
	created() {
		if (localStorage.getItem('goodsorder-columns') === 'null' || !localStorage.getItem('goodsorder-columns')) {
			localStorage.setItem('goodsorder-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('goodsorder-columns'));
		}
	},
	mounted() {
		this.$bus.$on('refreshList', () => {
			this.getList();
		});
		getUserConfig('goodsorder-columns').then(res => {
			console.log(res);
		});
		// 绑定表格滚动事件，实现滚动加载
		this.$nextTick(() => {
			this.bindTableScroll();
		});
	},
	beforeDestroy() {
		this.$bus.$off('refreshList');
		// 移除滚动事件监听
		this.unbindTableScroll();
	},
	methods: {
		// 行操作中点击查看 查看当前行订单的信息
		checkOrderItemInfo(row) {
			const id = row.id;
			// 读取订单信息
			getGoodsOrder(id).then(res => {
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
			});
		},
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
		},
		// 统一行样式，保持固定列与主体区域行高一致
		rowStyle({ row }) {
			const base = { height: '28px', lineHeight: '28px' };
			if (!row.isAdjust) return base;
			// 基础统一高度
			if (row.isAdjust > 0 && this.isAdjustOrder) {
				// 返回需要的背景色
				if (row.isAdjust === 1) return { ...base, background: '#f0f0f0' };
				if (row.isAdjust === 2) return { ...base, background: '#f0f9eb' };
				if (row.isAdjust === 3) return { ...base, background: '#fdf6ec' };
				return { ...base, background: '#ffcccc' };
			}
			return base;
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
					this.customerInvoiceList = response.rows || [];
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

		// 计算累计开票金额
		calculateAccumulatedInvoiceAmount(index) {
			let accumulated = 0;
			for (let i = 0; i <= index; i++) {
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

		// 计算供应商累计开票金额
		calculateSupplierAccumulatedInvoiceAmount(invoices, index) {
			let accumulated = 0;
			for (let i = 0; i <= index; i++) {
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
			// 根据不同操作委派不同的方法
			switch (command) {
				// 修改订单
				case 'handleUpdate':
					this.handleUpdate(row);
					break;
				// 删除订单
				case 'handleDelete':
					this.handleDelete(row);
					break;
				default:
					break;
			}
		},
		// 处理顶部搜索框
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
		// 表格的导出 - 前端Excel导出
		handleExport() {
			try {
				// 开始导出提示
				this.$message({
					message: '正在生成Excel文件，请稍候...',
					type: 'info'
				});

				// 生成Excel数据
				const excelData = this.generateExcelData();

				// 创建工作簿并下载
				this.downloadExcel(excelData);

				// 成功提示
				this.$message({
					message: 'Excel文件导出成功！',
					type: 'success'
				});
			} catch (error) {
				console.error('Excel导出失败:', error);
				this.$message({
					message: 'Excel导出失败，请重试',
					type: 'error'
				});
			}
		},

		/**
		 * 生成Excel数据
		 * @returns {Object} 包含表头和数据的对象
		 * 时间复杂度: O(n×m), 空间复杂度: O(n×m)
		 */
		generateExcelData() {
			// 获取可见列配置
			const visibleColumns = this.columns.filter(col => col.visible);

			// 生成表头
			const headers = visibleColumns.map(col => col.label);

			// 生成数据行
			const rows = this.goodsOrderList.map(row => {
				return visibleColumns.map(col => {
					return this.formatCellValue(row, col.key);
				});
			});

			return {
				headers,
				rows
			};
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
					return row.id || '';
				case 1: // 日期
					return row.orderDate ? parseTime(row.orderDate, '{y}-{m}-{d}') : '';
				case 2: // 客户
					return row.customer || '';
				case 3: // 供应商/仓库
					return this.formatSupplierWarehouse(row);
				case 4: // 审核状态
					return row.checkState || '';
				case 5: // 车队
					return row.fleet || '';
				case 6: // 陆运车牌
					return row.landCarNo || '';
				case 7: // 陆运司机电话
					return row.landDriverTel || '';
				case 8: // 陆地司机姓名
					return row.landDriverName || '';
				case 9: // 海运柜号
					return row.seaCarNo || '无';
				case 10: // 海运司机电话
					return row.seaDriverTel || '无';
				case 11: // 海运公司
					return row.seaDriverName || '无';
				case 12: // 总货款
					return row.allPayments || '';
				case 13: // 总吨位
					return row.allTonnage || '';
				case 14: // 陆运费
					return row.landFreight || '';
				case 15: // 海运费
					return row.seaFreight || '';
				case 16: // 总利润(含税)
					return row.allProfit || '';
				case 17: // 总利润(不含税)
					return row.allProfitNoTax || '';
				case 18: // 销售经理
					return row.saleManager || '';
				case 19: // 录入员
					return row.userName || '';
				case 20: // 备注
					return row.comments || '';
				case 21: // 附件
					return this.formatAttachments(row.attachmentList, 'path');
				case 22: // 收到条附件
					return this.formatAttachments(row.attachmentList, 'receiveProof');
				case 23: // 是否可编辑
					return row.isedit === 0 ? '否' : '是';
				case 24: // 客户是否含税
					return this.hasInvoice(row, PUBLIC_DICT_TYPE.CUSTOMER) ? '是' : '否';
				case 25: // 供应商是否开票
					return this.hasInvoice(row, PUBLIC_DICT_TYPE.SUPPLIER) ? '是' : '否';
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
		 * @param {Object} data - Excel数据
		 */
		downloadExcel(data) {
			// 创建工作表数据
			const worksheetData = [data.headers, ...data.rows];

			// 创建工作表
			const worksheet = XLSX.utils.aoa_to_sheet(worksheetData);

			// 设置列宽（可选优化）
			const colWidths = data.headers.map(() => ({ wch: 15 }));
			worksheet['!cols'] = colWidths;

			// 创建工作簿
			const workbook = XLSX.utils.book_new();
			XLSX.utils.book_append_sheet(workbook, worksheet, '订单列表');

			// 生成文件名
			const fileName = `订单列表_${parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`;

			// 下载文件
			XLSX.writeFile(workbook, fileName);
		},
		// 订单列表 不分页的导出
		handleExportNoPage() {
			this.download(
				'system/goodsOrder/export',
				{
					...this.queryParams,
					isAdjusted: this.isAdjustOrder ? 1 : 0,
					// 不分页的导出
					noPage: true
				},
				`goodsOrder_${new Date().getTime()}.xlsx`
			);
		},
		/**
		 * 计算表格合计行
		 * @param {Object} param - 包含 columns 和 data
		 * @returns {Array} 合计行数据数组
		 */
		getSummary(param) {
			const { columns, data } = param;
			const sums = [];
			// 需要合计的数字列（根据 prop 属性判断）
			const summaryColumns = ['allPayments', 'allTonnage', 'landFreight', 'seaFreight', 'allProfit', 'allProfitNoTax'];

			columns.forEach((column, index) => {
				// 第一列显示"合计"文字
				if (index === 0) {
					sums[index] = '合计';
					return;
				}

				// 判断当前列是否需要合计
				if (summaryColumns.includes(column.property)) {
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
				} else {
					// 不需要合计的列显示空字符串
					sums[index] = '';
				}
			});

			return sums;
		},
		/**
		 * 绑定表格滚动事件
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
					this._handleTableScroll = event => {
						this.handleTableScroll(event);
					};
					table.bodyWrapper.addEventListener('scroll', this._handleTableScroll);
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
		}
	}
};
</script>

<template>
	<div>
		<!--    这是框架自带的搜索模组，封装成了组件并且放在与index.vue同级目录下-->
		<QuerySearchBar @updateQuery="handleGetQueryParams" :is-adjust="isAdjustOrder" />
		<br />
		<!--    订单修改记录查看-->
		<div>
			<OrderHistoryCheck
				:check-history-order-visible="checkHistoryOrderVisible"
				:order-history-info-list="orderHistoryInfoList"
				:current-info="currentOrderItemInfo"
				@close="closeOrderHistoryCheck"
			/>
		</div>
		<!--      右侧的工具栏-->
		<div>
			<right-toolbar :columns="columns" @queryTable="getList">
				<!-- 左侧的新增订单的按钮 -->
				<template #left>
					<div style="padding: 10px">
						<el-row :gutter="10" class="mb8">
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

		<!--    订单表格 数据量较大-->
		<div>
			<el-table
				ref="orderTable"
				id="printBox"
				:row-key="row => row.id"
				v-loading="loading"
				v-horizontal-scroll="'always'"
				fit
				:row-style="rowStyle"
				border
				size="mini"
				max-height="750"
				:cell-style="paddingFix"
				:data="renderedList"
				show-summary
				:summary-method="getSummary"
				@header-dragend="changeColWidth"
			>
				<el-table-column label="行操作" align="center" class-name="small-padding fixed-width" width="180" fixed="left">
					<template slot-scope="scope">
						<!-- 查看按钮 -->
						<el-button size="mini" type="text" @click="checkOrderItemInfo(scope.row)">
							<span v-once>查看</span>
						</el-button>

						<!-- 操作下拉菜单 -->
						<el-dropdown size="mini" @command="command => handleCommand(command, scope.row)">
							<el-button size="mini" type="text">
								<span v-once>操作</span>
							</el-button>
							<el-dropdown-menu slot="dropdown">
								<el-dropdown-item v-hasPermi="['system:goodsorder:edit']" command="handleUpdate">
									<el-button
										size="mini"
										type="primary"
										:disabled="!scope.row.isedit || scope.row.isAdjust < 0 || isOrderExpired(scope.row.addtime)"
										:title="isOrderExpired(scope.row.addtime) ? '订单已超过7天，无法修改' : ''"
									>
										修 改
									</el-button>
								</el-dropdown-item>
								<el-dropdown-item v-hasPermi="['system:goodsorder:remove']" command="handleDelete">
									<el-button size="mini" type="danger" v-once>删 除</el-button>
								</el-dropdown-item>
							</el-dropdown-menu>
						</el-dropdown>

						<!-- 修改记录下拉菜单 -->
						<el-dropdown size="mini">
							<el-button size="mini" type="text">
								<span v-once>修改记录</span>
							</el-button>
							<el-dropdown-menu slot="dropdown">
								<el-dropdown-item>
									<HistoryList :row="scope.row" />
								</el-dropdown-item>
								<!-- <el-dropdown-item>
									<el-button style="margin-left: 5px" size="mini" type="text" @click="checkOrderHistory(scope.row)">历史对比</el-button>
								</el-dropdown-item> -->
							</el-dropdown-menu>
						</el-dropdown>
					</template>
				</el-table-column>
				<!-- 1. ID -->
				<CustomTableColumn v-if="columns[0].visible" show-overflow-tooltip label="ID" align="center" prop="id" fixed="left" />
				<!-- 2. 日期 -->
				<CustomTableColumn v-if="columns[1].visible" show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left">
					<template #default="scope">
						<div>{{ parseTime(scope.row.orderDate, '{y}-{m}-{d}') }}</div>
					</template>
				</CustomTableColumn>
				<!-- 3. 客户 -->
				<CustomTableColumn v-if="columns[2].visible" show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left" width="100px" />
				<!-- 4. 供应商/仓库 -->
				<el-table-column v-if="columns[3].visible" show-overflow-tooltip label="供应商/仓库" align="center" prop="supplierNames" fixed="left" width="200">
					<template #default="scope">
						<ExpandCursor>
							<div class="supplier-warehouse-container">
								<!-- 显示预处理的供应商列表 -->
								<span
									v-for="supplier in scope.row._uniqueSuppliers"
									:key="`supplier-${supplier.supplierID}`"
									class="supplier-name"
									@click="updateOrderItemVisibleSupplierInvoice(scope.row, supplier.supplierID)"
								>
									{{ supplier.supplier }}
								</span>
								<!-- 显示预处理的仓库列表 -->
								<span v-for="warehouse in scope.row._uniqueWarehouses" :key="`warehouse-${warehouse.storeHouseID}`" class="warehouse-name">
									{{ warehouse.storeHouseName }}
								</span>
								<!-- 如果既没有供应商也没有仓库，显示横线 -->
								<span v-if="scope.row._uniqueSuppliers.length === 0 && scope.row._uniqueWarehouses.length === 0" class="empty-item">-</span>
							</div>
						</ExpandCursor>
					</template>
				</el-table-column>
				<!-- 5. 审核状态 -->
				<el-table-column v-if="columns[4].visible" show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120">
					<template #default="scope">
						<el-row v-if="scope.row.checkState === '已审核'">
							<StateTag :state-title="scope.row.checkState" :state-mapper="{ 2: '已审核' }" @click.native="handleReCheck(scope.row)" style="cursor: pointer" />
						</el-row>
						<el-row v-else>
							<el-row>
								<el-button v-hasPermi="['system:goodsorder:audit']" type="text" size="mini" @click="handleCheck(scope.row)">
									<span v-once>审核</span>
								</el-button>
							</el-row>
						</el-row>
					</template>
				</el-table-column>
				<!-- 6. 车队 -->
				<CustomTableColumn v-if="columns[5].visible" show-overflow-tooltip label="车队" align="center" prop="fleet" width="100px" />
				<!-- 7. 陆运车牌 -->
				<CustomTableColumn v-if="columns[6].visible" show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" width="100px" />
				<!-- 8. 陆运司机电话 -->
				<CustomTableColumn v-if="columns[7].visible" show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel" width="100px" />
				<!-- 9. 陆地司机姓名 -->
				<CustomTableColumn v-if="columns[8].visible" show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName" width="100px" />
				<!-- 10. 海运柜号 -->
				<CustomTableColumn v-if="columns[9].visible" show-overflow-tooltip label="海运柜号" align="center" prop="seaCarNo" width="100px">
					<template #default="scope">
						{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
					</template>
				</CustomTableColumn>
				<!-- 11. 海运司机电话 -->
				<CustomTableColumn v-if="columns[10].visible" show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel" width="100px">
					<template #default="scope">
						{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
					</template>
				</CustomTableColumn>
				<!-- 12. 海运公司 -->
				<CustomTableColumn v-if="columns[11].visible" show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="100px">
					<template #default="scope">
						{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverName }}
					</template>
				</CustomTableColumn>
				<!-- 13. 总货款 -->
				<CustomTableColumn v-if="columns[12].visible" show-overflow-tooltip label="总货款" align="center" prop="allPayments" width="100px">
					<template #default="scope">
						{{ scope.row.allPayments | changeNumber(changeLength) }}
					</template>
				</CustomTableColumn>
				<!-- 14. 总吨位 -->
				<CustomTableColumn v-if="columns[13].visible" show-overflow-tooltip label="总吨位" align="center" prop="allTonnage" width="120px">
					<template #default="scope">
						{{ scope.row.allTonnage | changeNumber(changeLength) }}
					</template>
				</CustomTableColumn>
				<!-- 15. 陆运费 -->
				<CustomTableColumn v-if="columns[14].visible" show-overflow-tooltip label="陆运费" align="center" prop="landFreight" width="100px" />
				<!-- 16. 海运费 -->
				<CustomTableColumn v-if="columns[15].visible" show-overflow-tooltip label="海运费" align="center" prop="seaFreight" width="100px" />
				<!-- 17. 总利润(含税) -->
				<CustomTableColumn v-if="columns[16].visible" show-overflow-tooltip label="总利润(含税)" align="center" prop="allProfit" width="120px">
					<template #default="scope">
						{{ scope.row.allProfit | changeNumber(changeLength) }}
					</template>
				</CustomTableColumn>
				<!-- 18. 总利润(不含税) -->
				<CustomTableColumn v-if="columns[17].visible" show-overflow-tooltip label="总利润(不含税)" align="center" prop="allProfitNoTax" width="120px">
					<template #default="scope">
						{{ scope.row.allProfitNoTax | changeNumber(changeLength) }}
					</template>
				</CustomTableColumn>
				<!-- 19. 销售经理 -->
				<CustomTableColumn v-if="columns[18].visible" show-overflow-tooltip label="销售经理" align="center" prop="saleManager" width="100px" />
				<!-- 20. 录入员 -->
				<CustomTableColumn v-if="columns[19].visible" show-overflow-tooltip label="录入员" align="center" prop="userName" width="120px" />
				<!-- 21. 备注 -->
				<CustomTableColumn v-if="columns[20].visible" show-overflow-tooltip label="备注" align="center" prop="comments" />
				<!-- 22. 附件 -->
				<el-table-column v-if="columns[21].visible" show-overflow-tooltip label="附件" align="center" prop="path" width="150px">
					<template slot-scope="scope">
						<div v-if="Array.isArray(scope.row.attachmentList)">
							<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'path'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getGoodsOrder, updateGoodsOrder)" />
						</div>
						<div v-else>
							<el-tag type="danger" v-once>加载错误</el-tag>
						</div>
					</template>
				</el-table-column>
				<!-- 23. 收到条附件 -->
				<el-table-column v-if="columns[22].visible" show-overflow-tooltip label="收到条附件" align="center" prop="receiveProof" width="150px">
					<template #default="scope">
						<div v-if="Array.isArray(scope.row.attachmentList)">
							<CheckFiles
								:attachmentList="scope.row.attachmentList"
								:flag="'receiveProof'"
								@needToUpdate="value => handleUpdateFilePath(value, scope.row, getGoodsOrder, updateGoodsOrder)"
							/>
						</div>
						<div v-else>
							<el-tag type="danger" v-once>加载错误</el-tag>
						</div>
					</template>
				</el-table-column>
				<!-- 24. 是否可编辑 -->
				<CustomTableColumn v-if="columns[23].visible" show-overflow-tooltip label="是否可编辑" align="center" prop="isedit" width="100px">
					<template slot-scope="scope">
						<StateTag :state-title="scope.row.isedit === 0 ? '否' : '是'" :state-mapper="{ 0: '否', 2: '是' }" />
					</template>
				</CustomTableColumn>
				<!-- 25. 客户是否含税 -->
				<el-table-column v-if="columns[24].visible" show-overflow-tooltip label="客户是否含税" align="center" prop="customerTaxIncluded" width="120">
					<template #default="scope">
						<el-row>
							<el-row v-if="hasInvoice(scope.row, PUBLIC_DICT_TYPE.CUSTOMER)">
								<el-row>
									<el-button type="text" size="mini" @click="showCustomerInvoiceList(scope.row)">是</el-button>
								</el-row>
							</el-row>
							<el-row v-else>
								<StateTag :state-title="`否`" :state-mapper="{ 3: '否' }" />
							</el-row>
						</el-row>
					</template>
				</el-table-column>
				<!-- 26. 供应商是否开票 -->
				<el-table-column v-if="columns[25].visible" show-overflow-tooltip label="供应商是否开票" align="center" width="120px">
					<template #default="scope">
						<el-row>
							<el-row v-if="hasInvoice(scope.row, PUBLIC_DICT_TYPE.SUPPLIER)">
								<el-row>
									<el-button type="text" size="mini" @click="showSupplierInvoiceList(scope.row)">是</el-button>
								</el-row>
							</el-row>
							<el-row v-else>
								<StateTag :state-title="`否`" :state-mapper="{ 3: '否' }" />
							</el-row>
						</el-row>
					</template>
				</el-table-column>
				<!--      右侧操作栏-->
				<el-table-column show-overflow-tooltip label="订单操作" align="center" class-name="small-padding fixed-width" width="320px" fixed="right">
					<template slot-scope="scope">
						<el-button size="mini" type="text" :disabled="scope.row.isAdjusted !== 1" v-if="!isAdjustOrder" @click="handleCheckAdjust(scope.row)">查看调整单</el-button>
						<el-button size="mini" type="text" :disabled="scope.row.isAdjusted === 1" @click="handleOrderItemInfo(scope.row)">调整单</el-button>
						<el-button v-if="isAdjustOrder" size="mini" type="text" @click="handleCheckPrevious(scope.row)">查看原单据</el-button>
						<!-- 发货单操作：单独展示发货单1 + 下拉中的发货单2/3 -->
						<el-button size="mini" type="text" @click="handleOrder1(scope.row)">发货单1</el-button>
						<el-dropdown size="mini" type="text" trigger="click">
							<el-button type="text" size="mini">
								发货单
								<i class="el-icon-arrow-down el-icon--right" />
							</el-button>
							<el-dropdown-menu slot="dropdown">
								<el-dropdown-item>
									<el-button size="mini" type="text" @click="handleOrder2(scope.row)">发货单2</el-button>
								</el-dropdown-item>
								<el-dropdown-item>
									<el-button size="mini" type="text" @click="handleOrder3(scope.row)">发货单3</el-button>
								</el-dropdown-item>
							</el-dropdown-menu>
						</el-dropdown>
					</template>
				</el-table-column>
			</el-table>
			<!-- 加载更多提示 -->
			<transition name="fade">
				<div v-if="isLoadingBatch" class="loading-more-container">
					<div class="loading-more-content">
						<i class="el-icon-loading"></i>
						<span class="loading-text">正在加载更多数据...</span>
					</div>
				</div>
			</transition>
			<!-- 已加载全部提示 -->
			<transition name="fade">
				<div v-if="!isLoadingBatch && currentIndex >= goodsOrderList.length && goodsOrderList.length > batchSize" class="load-complete-container">
					<div class="load-complete-content">
						<i class="el-icon-success"></i>
						<span class="complete-text">已加载全部数据</span>
					</div>
				</div>
			</transition>
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
					<el-table
						v-loading="customerInvoiceListLoading"
						:data="customerInvoiceList"
						border
						stripe
						class="invoice-table compact-table"
						size="small"
						:header-cell-style="{ background: '#f8f9fa', color: '#495057', fontWeight: 600 }"
						:row-class-name="getInvoiceRowClassName"
					>
						<CustomTableColumn prop="orderDate" label="日期" align="center" width="170">
							<template #default>
								<div class="date-cell">
									<i class="el-icon-date"></i>
									{{ currentOrderInfo && currentOrderInfo.orderDate ? parseTime(currentOrderInfo.orderDate, '{y}-{m}-{d}') : '-' }}
								</div>
							</template>
						</CustomTableColumn>

						<CustomTableColumn prop="companyName" label="客户名称" align="center" min-width="120">
							<template #default="scope">
								<div class="company-cell">
									<i class="el-icon-office-building"></i>
									{{ scope.row.companyName }}
								</div>
							</template>
						</CustomTableColumn>

						<CustomTableColumn prop="allPayments" label="需开票金额" align="center" width="110">
							<template #default>
								<div class="amount-cell need-amount">
									<span class="currency-symbol">¥</span>
									{{ Number(currentOrderInfo ? currentOrderInfo.allPayments : 0).toLocaleString() }}
								</div>
							</template>
						</CustomTableColumn>

						<CustomTableColumn prop="invoiceDate" label="开票时间" align="center" width="200">
							<template #default="scope">
								<div class="datetime-cell">
									<i class="el-icon-time"></i>
									{{ scope.row.invoiceDate ? parseTime(scope.row.invoiceDate, '{y}-{m}-{d} {h}:{i}') : '-' }}
								</div>
							</template>
						</CustomTableColumn>

						<CustomTableColumn prop="invoiceAmount" label="开票金额" align="center" width="130">
							<template #default="scope">
								<div class="amount-cell invoiced-amount">
									<span class="currency-symbol">¥</span>
									{{ Number(scope.row.invoiceAmount || 0).toLocaleString() }}
								</div>
							</template>
						</CustomTableColumn>

						<CustomTableColumn label="累计开票金额" align="center" width="140">
							<template #default="scope">
								<div class="amount-cell accumulated-amount">
									<span class="currency-symbol">¥</span>
									{{ Number(calculateAccumulatedInvoiceAmount(scope.$index)).toLocaleString() }}
								</div>
							</template>
						</CustomTableColumn>
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
							<el-table
								:data="group.invoices"
								border
								stripe
								size="small"
								class="supplier-invoice-table"
								:header-cell-style="{ background: '#f8f9fa', color: '#495057', fontWeight: 600 }"
							>
								<CustomTableColumn prop="orderDate" label="日期" align="center" width="170">
									<template #default>
										<div class="date-cell">
											<i class="el-icon-date"></i>
											{{ currentOrderInfo && currentOrderInfo.orderDate ? parseTime(currentOrderInfo.orderDate, '{y}-{m}-{d}') : '-' }}
										</div>
									</template>
								</CustomTableColumn>

								<CustomTableColumn prop="companyName" label="供应商名称" align="center" min-width="120">
									<template #default="scope">
										<div class="company-cell">
											<i class="el-icon-office-building"></i>
											{{ scope.row.companyName }}
										</div>
									</template>
								</CustomTableColumn>

								<CustomTableColumn label="需开票金额" align="center" width="130">
									<template #default>
										<div class="amount-cell need-amount">
											<span class="currency-symbol">¥</span>
											{{ Number(group.needInvoiceAmount).toLocaleString() }}
										</div>
									</template>
								</CustomTableColumn>

								<CustomTableColumn prop="invoiceDate" label="开票时间" align="center" width="200">
									<template #default="scope">
										<div class="datetime-cell">
											<i class="el-icon-time"></i>
											{{ scope.row.invoiceDate }}
										</div>
									</template>
								</CustomTableColumn>

								<CustomTableColumn prop="invoiceAmount" label="开票金额" align="center" width="130">
									<template #default="scope">
										<div class="amount-cell invoiced-amount">
											<span class="currency-symbol">¥</span>
											{{ Number(scope.row.invoiceAmount || 0).toLocaleString() }}
										</div>
									</template>
								</CustomTableColumn>

								<CustomTableColumn label="累计开票金额" align="center" width="140">
									<template #default="scope">
										<div class="amount-cell accumulated-amount">
											<span class="currency-symbol">¥</span>
											{{ Number(calculateSupplierAccumulatedInvoiceAmount(group.invoices, scope.$index)).toLocaleString() }}
										</div>
									</template>
								</CustomTableColumn>
							</el-table>
						</div>
					</div>
				</div>
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

		// 表格行样式
		:deep(.invoice-row-completed) {
			background-color: #f0f9ff !important;
		}

		:deep(.invoice-row-pending) {
			background-color: #fffbf0 !important;
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

					:deep(.el-table__header) {
						border-radius: 0;
					}

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
	flex-wrap: nowrap; /* 避免换行导致高度不一致 */
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

.separator {
	color: #909399;
	font-weight: bold;
	margin: 0 6px;
	display: inline-block;
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

// 加载更多提示样式
.loading-more-container {
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 20px 0;
	margin: 10px 0;
	background: #f8f9fa;
	border-radius: 4px;

	.loading-more-content {
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 8px;
		color: #409eff;
		font-size: 14px;

		.el-icon-loading {
			font-size: 16px;
			animation: rotating 1s linear infinite;
		}

		.loading-text {
			font-weight: 500;
		}
	}
}

// 加载完成提示样式
.load-complete-container {
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 15px 0;
	margin: 10px 0;

	.load-complete-content {
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 8px;
		color: #67c23a;
		font-size: 14px;

		.el-icon-success {
			font-size: 16px;
		}

		.complete-text {
			font-weight: 500;
		}
	}
}

// 旋转动画
@keyframes rotating {
	0% {
		transform: rotate(0deg);
	}

	100% {
		transform: rotate(360deg);
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

// 表格行过渡效果
::v-deep .el-table__body-wrapper {
	.el-table__row {
		transition: opacity 0.2s ease-in-out, transform 0.2s ease-in-out;
	}

	// 新添加的行会有淡入效果
	.el-table__row.fade-enter-active {
		animation: fadeInRow 0.3s ease-in-out;
	}
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
</style>
