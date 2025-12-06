<script>
import { create, all } from 'mathjs';
import { getCompany } from '@/api/system/company';
import CompanysList from '@/views/dashboard/components/common/CompanysList.vue';
// import CompanyInformation from '@/views/dashboard/components/common/CompanyInformation.vue';
import InvoiceBody from '@/views/dashboard/components/common/InvoiceBody.vue';
import SelectGoods from '@/views/dashboard/components/common/SelectGoods.vue';
import { mixin_excel_server } from '@/views/dashboard/components/common/utils/excelServer';
import DragDiv from '@/components/DragDiv/index.vue';
import { getOperatedMap } from '@/api/excelTemplateStore';
import { listBatchInvoiceIn, listBatchInvoiceOut, deleteBatchInvoiceInByVoucher, deleteBatchInvoiceInById, deleteBatchInvoiceInInvoice, deleteBatchInvoiceOutByVoucher, deleteBatchInvoiceOutById, deleteBatchInvoiceOutInvoice } from '@/api/system/batchInvoice';

// 默认导出组件
export default {
	name: 'SheetList',
	computed: {},
	components: {
		CompanysList,
		InvoiceBody,
		// CompanyInformation,
		SelectGoods,
		DragDiv
	},
	mixins: [mixin_excel_server],
	// 接收文件读取到的sheetList 渲染出来给用户看 并且可以选择看哪一个
	props: {
		mode: {
			type: String,
			default: 'in',
			validator: value => ['in', 'out'].includes(value)
		},
		initialVoucher: {
			type: String,
			default: ''
		}
	},
	data() {
		return {
			math: null,
			listLoading: false,
			batchList: [],
			queryForm: {
				voucher: '',
				sellerName: '',
				buyerName: '',
				invoiced: null
			},
			pagination: {
				pageNum: 1,
				pageSize: 10,
				total: 0
			},
			currentVoucher: '',
			// 左上角供应商的信息
			companyInfo: {},
			// 本批开的票点
			// 订单选择弹窗
			invoiceAllVisible: false,
			// 供应商价税合计表
			invoiceSupplierList: [],
			// 购买方统计
			purchaseTotalInfo: [],
			// 销方统计
			sellerTotalInfo: [],
			// 我方公司搜索字段
			myCompany: null,
			// 对方公司搜索字段
			otherCompany: null,
			// 已操作状态搜索字段（null: 全部, true: 已操作, false: 未操作）
			operatedStatus: null,
			// 减去的金额
			minusValue: 0,
			// 统计信息
			statisticsInfo: {
				// 购买方统计
				purchaseStats: {
					suppliers: { total: 0, count: 0 }, // 供应商作为购买方的统计
					customers: { total: 0, count: 0 } // 客户作为购买方的统计
				},
				// 销方统计
				sellerStats: {
					suppliers: { total: 0, count: 0 }, // 供应商作为销方的统计
					customers: { total: 0, count: 0 } // 客户作为销方的统计
				}
			},
			// 模板数据（按对方身份拆分）
			// 本次导入的版本号（时间戳）
			currentVersion: null,
			// 已操作映射（来自 IndexedDB）
			templateOperatedMap: {}
			// 当前Sheet名称
			// currentSheetName 已废弃
		};
	},
	watch: {
		initialVoucher: {
			handler(value) {
				this.queryForm.voucher = value || '';
				this.pagination.pageNum = 1;
				this.fetchBatchList();
			},
			immediate: true
		}
	},
	created() {
		this.math = create(all, { number: 'BigNumber', precision: 64 });
	},
	mounted() {
		// 支持外部触发"继续上次开票"
		this.$bus.$on('excel:resume', this.openFromSession);
		// 监听已操作状态变更，实时刷新映射
		this.$bus.$on('excel:operated-updated', async payload => {
			const { companyIds } = payload || {};
			// 乐观更新：先把传入的公司ID标记为已操作
			if (Array.isArray(companyIds) && companyIds.length > 0) {
				const nextMap = { ...(this.templateOperatedMap || {}) };
				companyIds.forEach(id => (nextMap[id] = true));
				this.templateOperatedMap = nextMap;
			}
			// 再从 IndexedDB 拉一次，确保最终一致
			try {
				const map = await getOperatedMap();
				this.templateOperatedMap = map || {};
				this.$nextTick(() => {});
			} catch (e) {
				console.error('刷新已操作映射失败:', e);
			}
		});
	},
	beforeDestroy() {
		this.$bus.$off('excel:resume', this.openFromSession);
		this.$bus.$off('excel:operated-updated');
	},
	methods: {
		getApiHandlers() {
			if (this.mode === 'out') {
				return {
					list: listBatchInvoiceOut,
					deleteVoucher: deleteBatchInvoiceOutByVoucher,
					deleteRecord: deleteBatchInvoiceOutById,
					deleteInvoice: deleteBatchInvoiceOutInvoice
				};
			}
			return {
				list: listBatchInvoiceIn,
				deleteVoucher: deleteBatchInvoiceInByVoucher,
				deleteRecord: deleteBatchInvoiceInById,
				deleteInvoice: deleteBatchInvoiceInInvoice
			};
		},
		async fetchBatchList() {
			const api = this.getApiHandlers();
			if (!api || !api.list) {
				return;
			}
			this.listLoading = true;
			const query = {
				pageNum: this.pagination.pageNum,
				pageSize: this.pagination.pageSize
			};
			if (this.queryForm.voucher) {
				query.voucher = this.queryForm.voucher;
			}
			if (this.queryForm.sellerName) {
				query.sellerName = this.queryForm.sellerName;
			}
			if (this.queryForm.buyerName) {
				query.buyerName = this.queryForm.buyerName;
			}
			if (this.queryForm.invoiced !== null && this.queryForm.invoiced !== undefined && this.queryForm.invoiced !== '') {
				query.invoiced = this.queryForm.invoiced;
			}
			try {
				const res = await api.list(query);
				this.batchList = res?.rows || [];
				this.pagination.total = res?.total || 0;
			} catch (error) {
				console.error('加载批量导入记录失败:', error);
				this.$message.error('加载批量导入记录失败');
			} finally {
				this.listLoading = false;
			}
		},
		handleQuery() {
			this.pagination.pageNum = 1;
			this.fetchBatchList();
		},
		handleResetSearch() {
			this.queryForm = {
				voucher: '',
				sellerName: '',
				buyerName: '',
				invoiced: null
			};
			this.pagination.pageNum = 1;
			this.fetchBatchList();
		},
		handlePagination({ page, limit }) {
			this.pagination.pageNum = page;
			this.pagination.pageSize = limit;
			this.fetchBatchList();
		},
		handleDeleteVoucher(row) {
			const api = this.getApiHandlers();
			if (!row || !row.voucher || !api.deleteVoucher) {
				return;
			}
			this.$modal
				.confirm(`是否确认删除凭证号【${row.voucher}】的全部导入记录？该操作会级联删除已生成的发票。`)
				.then(() => api.deleteVoucher(row.voucher))
				.then(() => {
					this.$message.success('删除成功');
					this.fetchBatchList();
				})
				.catch(() => {});
		},
		handleDeleteRecord(row) {
			const api = this.getApiHandlers();
			if (!row || row.id === undefined || !api.deleteRecord) {
				return;
			}
			this.$modal
				.confirm(`是否确认删除导入记录 ID【${row.id}】？对应的发票数据也会被删除。`)
				.then(() => api.deleteRecord(row.id))
				.then(() => {
					this.$message.success('删除成功');
					this.fetchBatchList();
				})
				.catch(() => {});
		},
		handleDeleteInvoice(row) {
			const api = this.getApiHandlers();
			const invoiceId = row?.invoiceId;
			if (!invoiceId || !api.deleteInvoice) {
				this.$message.warning('该记录暂无已生成的发票');
				return;
			}
			this.$modal
				.confirm(`是否仅删除导入记录 ID【${row.id}】已生成的发票？导入数据将被保留，可重新开票。`)
				.then(() => api.deleteInvoice(invoiceId))
				.then(() => {
					this.$message.success('操作成功');
					this.fetchBatchList();
				})
				.catch(() => {});
		},
		hasInvoiceInfo(row) {
			return !!(row && row.invoiceId);
		},
		async handleOpenBatch(row) {
			if (!row || !row.voucher) {
				this.$message.warning('未找到有效的批次号');
				return;
			}
			this.reset();
			this.handleClearPurchaseInfo();
			this.handleClearSellerInfo();
			this.currentVoucher = row.voucher;
			const batchRows = await this.fetchVoucherDetails(row.voucher);
			if (!batchRows || batchRows.length === 0) {
				this.$message.warning('该批次暂无明细数据');
				return;
			}
			this.currentVersion = Date.now();
			await this.processExcelData(batchRows);
			this.invoiceAllVisible = true;
			this.saveBatchInvoiceSession({ voucher: row.voucher });
		},
		async fetchVoucherDetails(voucher) {
			const api = this.getApiHandlers();
			if (!api || !api.list) {
				return [];
			}
			try {
				const res = await api.list({
					voucher,
					pageNum: 1,
					pageSize: 1000
				});
				return res?.rows || [];
			} catch (error) {
				console.error('加载批次详情失败:', error);
				this.$message.error('加载批次详情失败');
				return [];
			}
		},
		// 保存当前批量开票会话（模板/聚合/统计/已生成列表）
		saveBatchInvoiceSession(extra = {}) {
			try {
				const payload = {
					purchaseTemplateData: this.$store?.state?.excel?.purchaseTemplateData || [],
					sellerTemplateData: this.$store?.state?.excel?.sellerTemplateData || [],
					purchaseTotalInfo: this.purchaseTotalInfo || [],
					sellerTotalInfo: this.sellerTotalInfo || [],
					statisticsInfo: this.statisticsInfo || {},
					generatedInvoices: this.$store?.getters?.selectedInvoiceList || [],
					timestamp: Date.now(),
					...extra
				};
				localStorage.setItem('batch-invoice-session', JSON.stringify(payload));
			} catch (e) {
				console.error('保存批量开票会话失败:', e);
			}
		},
		// 从本地恢复批量开票会话，并直接打开全屏弹窗
		openFromSession() {
			try {
				const raw = localStorage.getItem('batch-invoice-session');
				if (!raw) {
					this.$message.info('暂无上次开票会话');
					return;
				}
				const session = JSON.parse(raw);
				// 恢复版本号
				this.currentVersion = session && session.timestamp ? session.timestamp : null;
				// 恢复模板到 Vuex
				if (Array.isArray(session.purchaseTemplateData)) {
					this.$store.dispatch('excel/setPurchaseTemplateData', session.purchaseTemplateData);
				}
				if (Array.isArray(session.sellerTemplateData)) {
					this.$store.dispatch('excel/setSellerTemplateData', session.sellerTemplateData);
				}
				// 恢复聚合与统计
				this.purchaseTotalInfo = Array.isArray(session.purchaseTotalInfo) ? session.purchaseTotalInfo : [];
				this.sellerTotalInfo = Array.isArray(session.sellerTotalInfo) ? session.sellerTotalInfo : [];
				this.statisticsInfo = session.statisticsInfo || {
					purchaseStats: { suppliers: { total: 0, count: 0 }, customers: { total: 0, count: 0 } },
					sellerStats: { suppliers: { total: 0, count: 0 }, customers: { total: 0, count: 0 } }
				};
				// 恢复已生成的发票清单（如有）
				if (Array.isArray(session.generatedInvoices)) {
					this.$store.dispatch('excel/setSelectedInvoiceList', session.generatedInvoices);
				}
				// 打开全屏弹窗
				this.invoiceAllVisible = true;
				// 加载已操作映射
				getOperatedMap().then(map => (this.templateOperatedMap = map || {}));
			} catch (e) {
				console.error('恢复批量开票会话失败:', e);
				this.$message.error('无法恢复上次开票会话');
			}
		},
		/**
		 * 处理批量数据
		 * @param {Array} rows - 批次明细
		 */
		async processExcelData(rows = []) {
			let arr = [];
			let purchaseMap = new Map();
			let sellerMap = new Map();

			for (let item of rows) {
				const mapped = this.mapperParams(item);
				if (mapped) {
					arr.push(mapped);
				}
			}

			// 过滤掉arr中 属性全部为undefined的元素
			arr = arr.filter(item => item && !Object.values(item).every(value => value === undefined || value === null));
			// 检查excel中是否有同时存在的
			let ok = arr.every(item => this.purchaseHandler(item));
			if (!ok) {
				this.$message.error('存在订单中存在购买方和销方的信息，请检查');
				return;
			}
			// 构建批次校验信息
			const batchMetaMap = {};
			arr.forEach(element => {
				const batchId = element.batchInvoiceId || element.id;
				if (batchId && batchMetaMap[batchId] === undefined) {
					batchMetaMap[batchId] = {
						totalAmount: element.total || 0,
						voucher: element.voucher || this.currentVoucher
					};
				}
			});
			this.$store.dispatch('excel/setBatchMetaMap', batchMetaMap);
			// 对数组每一个进行遍历 收集元素
			arr.forEach(element => {
				// 判断对方是否是购买方
				const isPurchase = element.sellerId === 0;
				// 根据判断选择 Map
				const map = isPurchase ? purchaseMap : sellerMap;
				// 购买方或销售方的 id
				const id = isPurchase ? element.purchaseId : element.sellerId;
				// 购买方或销售方的 name
				const name = isPurchase ? element.purchaseName : element.sellerName;
				// 购买方或销售方的 type
				const type = isPurchase ? element.purchaseType : element.sellerType;
				// 必然有一方是我方 对方如果是购买方 那么我方就是销售方 反之一样
				const us = isPurchase ? element.sellerName : element.purchaseName;
				// 确保 id 不为 undefined 或空值
				if (id == null || id === '') {
					return; // 跳过当前元素
				}
				// 唯一键
				const _onlyKey = id + us;
				// 获取当前 Map 中的记录，如果存在则累加总数，不存在则直接插入
				const _existing = map.get(_onlyKey);
				if (_existing) {
					const totalSum = this.math.add(this.math.bignumber(_existing.total || 0), this.math.bignumber(element.total || 0));
					const ticketSum = this.math.add(this.math.bignumber(_existing.ticketPointAmount || 0), this.math.bignumber(element.ticketPointAmount || 0));
					_existing.total = Number(this.math.format(totalSum, { precision: 12, notation: 'fixed' }));
					_existing.ticketPointAmount = Number(this.math.format(ticketSum, { precision: 12, notation: 'fixed' }));
				} else {
					map.set(_onlyKey, {
						id,
						type,
						name,
						us,
						total: element.total,
						ticketPoint: element.ticketPoint,
						ticketPointAmount: element.ticketPointAmount
					});
				}
			});
			this.purchaseTotalInfo = Array.from(purchaseMap.values());
			this.sellerTotalInfo = Array.from(sellerMap.values());

			// 保存模板原始数据到 Vuex，按对方身份拆分
			this.$store.dispatch(
				'excel/setPurchaseTemplateData',
				arr.filter(e => e && e.sellerId === 0)
			);
			this.$store.dispatch(
				'excel/setSellerTemplateData',
				arr.filter(e => e && e.sellerId !== 0)
			);

			// 计算统计信息
			this.calculateStatistics(arr);

			// 暂存购买方和销方的信息
			this.handleStorePurchaseInfo(this.purchaseTotalInfo);
			this.handleStoreSellerInfo(this.sellerTotalInfo);
			// 保存一次会话快照
			this.saveBatchInvoiceSession();
			getOperatedMap().then(map => (this.templateOperatedMap = map || {}));
		},
		// 映射关系
		mapperParams(item) {
			if (!item) return null;
			// 已结构化的后端数据
			if (item.sellerId !== undefined || item.purchaseId !== undefined || item.batchInvoiceId) {
				const totalAmount = Number(item.totalAmount ?? item.total ?? item.invoiceAmount ?? 0);
				const ticketPoint = Number(item.taxPoint ?? item.ticketPoint ?? 0);
				const ticketPointAmountRaw = item.ticketPointAmount;
				const normalizedTicketPointAmount = ticketPointAmountRaw !== undefined && ticketPointAmountRaw !== null ? Number(ticketPointAmountRaw) : this.calculateTicketPointAmount(totalAmount, ticketPoint);

				return {
					sellerId: Number(item.sellerId) || 0,
					sellerName: item.sellerName || '',
					sellerType: item.sellerType || '',
					purchaseId: Number(item.buyerId ?? item.purchaseId) || 0,
					purchaseType: item.buyerType ?? item.purchaseType ?? '',
					purchaseName: item.buyerName ?? item.purchaseName ?? '',
					total: Number(totalAmount),
					ticketPoint: ticketPoint,
					ticketPointAmount: Number(normalizedTicketPointAmount),
					batchInvoiceId: item.batchInvoiceId || item.id || null,
					voucher: item.voucher || '',
					comments: item.comments || '',
					params: item.params || {},
					id: item.id
				};
			}

			// Excel 原始数据（中文表头）
			const ticketPoint = Number(item['票点']) || 0;
			const totalAmount = Number(item['价税合计']) || 0;
			const ticketPointAmount = this.calculateTicketPointAmount(totalAmount, ticketPoint);

			return {
				sellerId: item['销方ID'],
				sellerName: item['销方名称'],
				sellerType: item['销方类型'],
				purchaseId: item['购买方ID'],
				purchaseType: item['购买方类型'],
				purchaseName: item['购买方名称'],
				total: totalAmount,
				ticketPoint: ticketPoint,
				ticketPointAmount: Number(ticketPointAmount.toFixed(2))
			};
		},
		calculateTicketPointAmount(totalAmount, ticketPoint) {
			const total = this.math ? this.math.bignumber(totalAmount || 0) : totalAmount || 0;
			const rate = this.math ? this.math.bignumber(ticketPoint || 0) : ticketPoint || 0;
			if (this.math) {
				if (this.math.equal(rate, this.math.bignumber(0))) {
					return 0;
				}
				const denominator = this.math.add(this.math.bignumber(1), rate);
				const fraction = this.math.divide(total, denominator);
				const result = this.math.multiply(fraction, rate);
				return Number(this.math.format(result, { precision: 12, notation: 'fixed' }));
			}
			return totalAmount > 0 && ticketPoint > 0 ? (totalAmount / (1 + ticketPoint)) * ticketPoint : 0;
		},
		// 计算统计信息
		calculateStatistics(dataArray) {
			// 重置统计信息
			this.statisticsInfo = {
				purchaseStats: {
					suppliers: { total: 0, count: 0 },
					customers: { total: 0, count: 0 }
				},
				sellerStats: {
					suppliers: { total: 0, count: 0 },
					customers: { total: 0, count: 0 }
				}
			};

			// 用唯一 ID 去重计数，避免同一公司被重复计数
			const purchaseSupplierIds = new Set();
			const purchaseCustomerIds = new Set();
			const sellerSupplierIds = new Set();
			const sellerCustomerIds = new Set();

			dataArray.forEach(element => {
				const amount = Number(element.total) || 0;

				// 统计购买方（排除己方公司）
				if (element.purchaseType && element.purchaseType !== '己方公司') {
					const pid = element.purchaseId;
					if (element.purchaseType === '供应商') {
						this.statisticsInfo.purchaseStats.suppliers.total += amount;
						if (pid !== undefined && pid !== null && pid !== '' && Number(pid) !== 0) {
							purchaseSupplierIds.add(String(pid));
						}
					} else if (element.purchaseType === '客户') {
						this.statisticsInfo.purchaseStats.customers.total += amount;
						if (pid !== undefined && pid !== null && pid !== '' && Number(pid) !== 0) {
							purchaseCustomerIds.add(String(pid));
						}
					}
				}

				// 统计销方（排除己方公司）
				if (element.sellerType && element.sellerType !== '己方公司') {
					const sid = element.sellerId;
					if (element.sellerType === '供应商') {
						this.statisticsInfo.sellerStats.suppliers.total += amount;
						if (sid !== undefined && sid !== null && sid !== '' && Number(sid) !== 0) {
							sellerSupplierIds.add(String(sid));
						}
					} else if (element.sellerType === '客户') {
						this.statisticsInfo.sellerStats.customers.total += amount;
						if (sid !== undefined && sid !== null && sid !== '' && Number(sid) !== 0) {
							sellerCustomerIds.add(String(sid));
						}
					}
				}
			});

			// 用去重后的 ID 数量作为 count
			this.statisticsInfo.purchaseStats.suppliers.count = purchaseSupplierIds.size;
			this.statisticsInfo.purchaseStats.customers.count = purchaseCustomerIds.size;
			this.statisticsInfo.sellerStats.suppliers.count = sellerSupplierIds.size;
			this.statisticsInfo.sellerStats.customers.count = sellerCustomerIds.size;

			// 保留两位小数
			this.statisticsInfo.purchaseStats.suppliers.total = Number(this.statisticsInfo.purchaseStats.suppliers.total.toFixed(2));
			this.statisticsInfo.purchaseStats.customers.total = Number(this.statisticsInfo.purchaseStats.customers.total.toFixed(2));
			this.statisticsInfo.sellerStats.suppliers.total = Number(this.statisticsInfo.sellerStats.suppliers.total.toFixed(2));
			this.statisticsInfo.sellerStats.customers.total = Number(this.statisticsInfo.sellerStats.customers.total.toFixed(2));
		},
		// 对公司进行校验
		purchaseHandler(item) {
			// 如果都为0
			if (item.purchaseId === 0 && item.sellerId === 0) {
				return false;
				// 如果购买方和销方的id都不为0
			} else return !(item.purchaseId !== 0 && item.sellerId !== 0);
		},
		// 判断公司是否已操作
		isCompanyOperated(row) {
			if (!row || !row.id) return false;
			const companyId = Number(row.id);
			return !!(companyId && this.templateOperatedMap && this.templateOperatedMap[companyId]);
		},
		// 弹窗左侧供应商列表的筛选
		handleFilter() {
			// 从暂存数据中获取原始数据
			const purchaseTempData = this.$store.getters.purchaseTempInfo || [];
			const sellerTempData = this.$store.getters.sellerTempInfo || [];

			// 筛选购买方信息
			this.purchaseTotalInfo = purchaseTempData.filter(item => {
				// 我方公司筛选
				if (this.myCompany && item.us) {
					if (item.us.indexOf(this.myCompany) === -1) {
						return false;
					}
				}
				// 对方公司筛选
				if (this.otherCompany && item.name) {
					if (item.name.indexOf(this.otherCompany) === -1) {
						return false;
					}
				}
				// 已操作状态筛选
				if (this.operatedStatus !== null) {
					const isOperated = this.isCompanyOperated(item);
					if (isOperated !== this.operatedStatus) {
						return false;
					}
				}
				return true;
			});

			// 筛选销方信息
			this.sellerTotalInfo = sellerTempData.filter(item => {
				// 我方公司筛选
				if (this.myCompany && item.us) {
					if (item.us.indexOf(this.myCompany) === -1) {
						return false;
					}
				}
				// 对方公司筛选
				if (this.otherCompany && item.name) {
					if (item.name.indexOf(this.otherCompany) === -1) {
						return false;
					}
				}
				// 已操作状态筛选
				if (this.operatedStatus !== null) {
					const isOperated = this.isCompanyOperated(item);
					if (isOperated !== this.operatedStatus) {
						return false;
					}
				}
				return true;
			});
		},

		//查看某一个公司的信息
		handleCheck(row) {
			this.handleResetCompanyInfo();
			this.companyInfo.supplierLoading = true;
			getCompany(row.id, row.type).then(res => {
				if (!res.data && !res.rows) {
					this.$message.error('暂无该公司的数据');
					this.companyInfo.supplierLoading = false;
					return;
				}
				this.companyInfo = res.data;
				this.companyInfo.supplierLoading = false;
			});
		},
		handleResetCompanyInfo() {
			this.companyInfo = {
				companyName: '选择公司以查看',
				companyType: '暂无',
				leader: '暂无',
				region: '暂无',
				leaderTel: '暂无',
				comments: '暂无',
				supplierLoading: false
			};
		},
		// 重置筛选结果
		handleReset() {
			this.purchaseTotalInfo = this.$store.getters.purchaseTempInfo;
			this.sellerTotalInfo = this.$store.getters.sellerTempInfo;
			// 清空搜索条件
			this.myCompany = null;
			this.otherCompany = null;
			this.operatedStatus = null;
		},
		// 重置订单列表的数据 通过事件总线实现
		handleResetOrderList() {
			this.$bus.$emit('select-goods:update');
			// 将高亮行去除样式
			this.$bus.$emit('select-goods-row:update');
		},

		// 关闭的逻辑 要清除所有状态
		handleClose() {
			this.reset();
			this.invoiceAllVisible = false;
		},
		reset() {
			// sessionStorage
			sessionStorage.removeItem('us');
			sessionStorage.removeItem('invoiceAmount');
			// 清除左上角公司信息
			this.handleResetCompanyInfo();
			// 清除订单列表的数据
			this.handleResetOrderList();
			// 重置公司筛选结果
			this.handleReset();
			// 清除票点
			this.$store.dispatch('excel/clearTicketPoint');
			// 清除备注
			this.$store.dispatch('excel/clearComment');
			// 清除模板数据
			this.$store.dispatch('excel/clearPurchaseTemplateData');
			this.$store.dispatch('excel/clearSellerTemplateData');
			this.$store.dispatch('excel/clearBatchMetaMap');
			// 重置统计信息
			this.statisticsInfo = {
				purchaseStats: {
					suppliers: { total: 0, count: 0 },
					customers: { total: 0, count: 0 }
				},
				sellerStats: {
					suppliers: { total: 0, count: 0 },
					customers: { total: 0, count: 0 }
				}
			};
			// 发布事件 组件中清除自己状态
			this.$bus.$emit('invoice-clear');
		}
	}
};
</script>

<template>
	<div>
		<!-- 批次管理区域 - 简化结构，移除多余边框 -->
		<div class="batch-manager">
			<!-- 搜索表单 -->
			<el-form :inline="true" size="mini" class="batch-search-form">
				<el-form-item label="凭证号">
					<el-input v-model="queryForm.voucher" placeholder="支持模糊查询" clearable />
				</el-form-item>
				<el-form-item label="销方名称">
					<el-input v-model="queryForm.sellerName" placeholder="支持模糊查询" clearable />
				</el-form-item>
				<el-form-item label="购买方名称">
					<el-input v-model="queryForm.buyerName" placeholder="支持模糊查询" clearable />
				</el-form-item>
				<el-form-item label="是否已开票">
					<el-select v-model="queryForm.invoiced" placeholder="全部" clearable>
						<el-option label="全部" :value="null" />
						<el-option label="是" :value="true" />
						<el-option label="否" :value="false" />
					</el-select>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">查询</el-button>
					<el-button type="warning" icon="el-icon-refresh" size="mini" @click="handleResetSearch">重置</el-button>
				</el-form-item>
			</el-form>

			<!-- 数据表格 -->
			<el-table :data="batchList" size="mini" border :loading="listLoading" style="width: 100%" class="batch-table" :cell-style="() => ({ padding: '6px 4px' })" :header-cell-style="() => ({ background: '#f5f7fa', color: '#606266', fontWeight: '600' })">
				<el-table-column label="ID" align="center" prop="id" width="70" />
				<el-table-column label="批次号" align="center" prop="voucher" min-width="140" show-overflow-tooltip />
				<el-table-column label="销方名称" align="center" prop="sellerName" min-width="150" show-overflow-tooltip />
				<el-table-column label="购买方名称" align="center" prop="buyerName" min-width="150" show-overflow-tooltip />
				<el-table-column label="价税合计" align="center" prop="totalAmount" width="110" show-overflow-tooltip>
					<template #default="scope">
						<span class="amount-text">{{ scope.row.totalAmount }}</span>
					</template>
				</el-table-column>
				<el-table-column label="票点" align="center" prop="taxPoint" width="70" show-overflow-tooltip />
				<el-table-column label="已开票" align="center" prop="invoiced" width="80">
					<template #default="scope">
						<el-tag size="mini" :type="scope.row.invoiced ? 'success' : 'info'" effect="light">
							{{ scope.row.invoiced ? '是' : '否' }}
						</el-tag>
					</template>
				</el-table-column>
				<el-table-column label="导入时间" align="center" prop="createTime" width="150" show-overflow-tooltip />
				<el-table-column label="操作" align="center" width="300" fixed="right">
					<template #default="scope">
						<el-button type="text" size="mini" class="action-btn primary" @click="handleOpenBatch(scope.row)">发起开票</el-button>
						<el-button type="text" size="mini" class="action-btn danger" @click="handleDeleteVoucher(scope.row)">整批删除</el-button>
						<el-button type="text" size="mini" class="action-btn warning" @click="handleDeleteRecord(scope.row)">删除导入</el-button>
						<el-tooltip v-if="!hasInvoiceInfo(scope.row)" effect="dark" content="暂无已生成的发票" placement="top">
							<span>
								<el-button type="text" size="mini" class="action-btn" :disabled="true">仅删发票</el-button>
							</span>
						</el-tooltip>
						<el-button v-else type="text" size="mini" class="action-btn info" @click="handleDeleteInvoice(scope.row)">仅删发票</el-button>
					</template>
				</el-table-column>
			</el-table>

			<!-- 分页 -->
			<pagination v-show="pagination.total > 0" :total="pagination.total" :page.sync="pagination.pageNum" :limit.sync="pagination.pageSize" @pagination="handlePagination" />
		</div>

		<div>
			<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="批量开票" fullscreen :visible.sync="invoiceAllVisible" append-to-body>
				<div class="invoice-container">
					<!-- 上下布局：上面是 CompanysList + InvoiceBody（DragDiv），下面是 SelectGoods -->
					<div class="invoice-layout">
						<!-- 上半部分：公司列表和开票信息（左右布局，使用DragDiv） -->
						<div class="top-section">
							<DragDiv style="height: 100%" :initial-left-width="1350" :min-left-width="600" :min-right-width="300" :divider-width="6">
								<template #left>
									<div class="section-wrapper">
										<div class="company-list-section-full">
											<el-card class="full-height-card">
												<div slot="header" class="card-header">
													<span class="bold-text">公司列表</span>
												</div>
												<el-form class="search-form">
													<el-row :gutter="8">
														<el-col :span="7">
															<el-form-item label="我方公司" label-width="160px">
																<el-input v-model="myCompany" placeholder="我方公司名称" size="mini" clearable />
															</el-form-item>
														</el-col>
														<el-col :span="7">
															<el-form-item label="对方公司" label-width="160px">
																<el-input v-model="otherCompany" placeholder="对方公司名称" size="mini" clearable />
															</el-form-item>
														</el-col>
														<el-col :span="7">
															<el-form-item label="已操作状态" label-width="160px">
																<el-select v-model="operatedStatus" placeholder="全部" size="mini" clearable style="width: 100%">
																	<el-option label="全部" :value="null" />
																	<el-option label="已操作" :value="true" />
																	<el-option label="未操作" :value="false" />
																</el-select>
															</el-form-item>
														</el-col>
														<el-col :span="3">
															<div class="button-group">
																<el-button type="primary" size="mini" @click="handleFilter">查询</el-button>
																<el-button type="warning" size="mini" @click="handleReset">重置</el-button>
															</div>
														</el-col>
													</el-row>
												</el-form>

												<div class="company-lists">
													<el-divider>
														<span class="bold-text">购买方信息</span>
													</el-divider>
													<CompanysList
														side="purchase"
														:company-total-info="purchaseTotalInfo"
														:statistics-info="statisticsInfo ? statisticsInfo.purchaseStats : { suppliers: { total: 0, count: 0 }, customers: { total: 0, count: 0 } }"
														:operated-map="templateOperatedMap"
														@handleCheck="handleCheck"
													/>
													<el-divider>
														<span class="bold-text">销方信息</span>
													</el-divider>
													<CompanysList
														side="seller"
														:company-total-info="sellerTotalInfo"
														:statistics-info="statisticsInfo ? statisticsInfo.sellerStats : { suppliers: { total: 0, count: 0 }, customers: { total: 0, count: 0 } }"
														:operated-map="templateOperatedMap"
														@handleCheck="handleCheck"
													/>
												</div>
											</el-card>
										</div>
									</div>
								</template>

								<template #right>
									<div class="section-wrapper">
										<InvoiceBody />
									</div>
								</template>
							</DragDiv>
						</div>

						<!-- 下半部分：订单列表（占满宽度） -->
						<div class="bottom-section">
							<el-card class="full-height-card">
								<div slot="header" class="card-header">
									<span class="bold-text">订单列表(未开票)</span>
									<el-button class="header-button" type="text" @click="handleResetOrderList">重置筛选</el-button>
								</div>
								<div class="select-goods-wrapper">
									<SelectGoods />
								</div>
							</el-card>
						</div>
					</div>
				</div>
				<span slot="footer" class="dialog-footer">
					<el-button @click="handleClose">关 闭</el-button>
				</span>
			</el-dialog>
		</div>
	</div>
</template>

<style scoped lang="scss">
/* 批次管理区域 - 简化后的样式 */
.batch-manager {
	background: #fff;
	border-radius: 8px;
	padding: 0;
}

/* 搜索表单样式 */
.batch-search-form {
	padding: 12px 0 16px 0;
	border-bottom: 1px solid #ebeef5;
	margin-bottom: 16px;

	.el-form-item {
		margin-bottom: 0;
		margin-right: 16px;
	}

	.el-form-item__label {
		color: #606266;
		font-weight: 500;
	}

	.el-input {
		width: 160px;
	}

	.el-select {
		width: 100px;
	}
}

/* 表格样式 */
.batch-table {
	border-radius: 6px;
	overflow: hidden;

	&::before {
		display: none; // 移除表格底部边框线
	}
}

/* 金额文字样式 */
.amount-text {
	color: #e6a23c;
	font-weight: 600;
}

/* 操作按钮样式 */
.action-btn {
	padding: 4px 8px;
	margin: 0 2px;
	border-radius: 4px;
	font-size: 12px;
	transition: all 0.2s ease;

	&.primary {
		color: #409eff;
		&:hover {
			background: rgba(64, 158, 255, 0.1);
		}
	}

	&.danger {
		color: #f56c6c;
		&:hover {
			background: rgba(245, 108, 108, 0.1);
		}
	}

	&.warning {
		color: #e6a23c;
		&:hover {
			background: rgba(230, 162, 60, 0.1);
		}
	}

	&.info {
		color: #909399;
		&:hover {
			background: rgba(144, 147, 153, 0.1);
		}
	}

	&:disabled {
		color: #c0c4cc;
		cursor: not-allowed;
	}
}

.bold-text {
	font-weight: bold;
	color: #161617;
	font-size: 14px;
	line-height: 18px;
	display: inline-block;
}

.minus-text {
	margin-left: 12px;
	color: #ff0000;
	font-weight: bold;
	font-size: 14px;
	line-height: 20px;
}

/* 开票弹窗相关的样式 */
.invoice-container {
	height: calc(100vh - 100px);
	padding: 0 16px;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	background: #f5f7fa;
}

/* 新的上下布局 */
.invoice-layout {
	height: 100%;
	display: flex;
	flex-direction: column;
	gap: 16px;
}

/* 上半部分：公司列表和开票信息 */
.top-section {
	flex: 0 0 50%;
	min-height: 0;
	height: 50%;
	overflow: hidden;
}

/* 下半部分：订单列表 */
.bottom-section {
	flex: 1;
	min-height: 0;
	display: flex;
	flex-direction: column;
}

.column-section {
	padding-left: 8px !important;
	padding-right: 8px !important;
	height: 100%;

	&.left-section,
	&.middle-section,
	&.right-section {
		margin-bottom: 0;
	}
}

.section-wrapper {
	height: 100%;
	display: flex;
	flex-direction: column;
}

/* 左侧区域样式 */
.left-section {
	.company-list-section-full {
		height: 100%;
		display: flex;
		flex-direction: column;
	}

	// 原来的样式保留以防需要回滚
	.company-info-section {
		margin-bottom: 16px;
		flex-shrink: 0;
	}

	.company-list-section {
		flex: 1;
		min-height: 0;
	}
}

/* 中间和右侧区域样式 */
.middle-section,
.right-section {
	.section-wrapper {
		height: 100%;
	}
}

/* 卡片通用样式 - 简化边框，减少嵌套感 */
.full-height-card {
	height: 100%;
	display: flex;
	flex-direction: column;
	border: none !important;
	box-shadow: none !important;
	background: #fff;
	border-radius: 8px;

	::v-deep .el-card__header {
		padding: 10px 16px;
		border-bottom: 1px solid #eef1f6;
		flex-shrink: 0;
		background: linear-gradient(135deg, #f8fafc 0%, #fff 100%);
		border-radius: 8px 8px 0 0;
	}

	::v-deep .el-card__body {
		flex: 1;
		padding: 12px 16px;
		overflow: hidden;
		display: flex;
		flex-direction: column;
		background: #fff;
	}
}

/* 卡片头部样式 */
.card-header {
	display: flex;
	justify-content: space-between;
	align-items: center;

	.header-button {
		padding: 3px 0;
		font-size: 12px;
	}
}

/* 搜索表单样式 */
.search-form {
	margin-bottom: 16px;
	flex-shrink: 0;

	.el-form-item {
		margin-bottom: 12px;
	}

	.el-form-item__label {
		font-size: 12px;
		color: #666;
	}

	.button-group {
		text-align: center;

		.el-button {
			margin: 0 4px;
		}
	}
}

/* 公司列表样式 - 统一使用单一滚动条 */
.company-lists {
	flex: 1;
	overflow-y: auto;
	overflow-x: hidden;
	min-height: 0;
	padding-right: 4px;

	.el-divider {
		margin: 12px 0 10px 0;

		.el-divider__text {
			background-color: #fff;
			padding: 0 12px;
			color: #409eff;
			font-weight: 500;
		}
	}

	/* 统一美化滚动条样式 */
	&::-webkit-scrollbar {
		width: 6px;
	}

	&::-webkit-scrollbar-thumb {
		background: #c0c4cc;
		border-radius: 3px;

		&:hover {
			background: #909399;
		}
	}

	&::-webkit-scrollbar-track {
		background: transparent;
	}
}

/* 订单选择组件包装 - 统一滚动条 */
.select-goods-wrapper {
	flex: 1;
	overflow-y: auto;
	overflow-x: hidden;
	min-height: 0;
	max-height: calc(50vh - 80px);
	padding-right: 4px;

	/* 统一美化滚动条样式 */
	&::-webkit-scrollbar {
		width: 6px;
	}

	&::-webkit-scrollbar-thumb {
		background: #c0c4cc;
		border-radius: 3px;

		&:hover {
			background: #909399;
		}
	}

	&::-webkit-scrollbar-track {
		background: transparent;
	}
}

/* 响应式布局 */
@media screen and (max-width: 1200px) {
	.invoice-container {
		height: auto;
		min-height: calc(100vh - 120px);
	}

	.invoice-layout {
		flex-direction: column;
	}

	.top-section {
		flex: 0 0 auto;
		height: auto;
		min-height: 400px;
	}

	.bottom-section {
		flex: 0 0 auto;
		min-height: 400px;
	}

	.section-wrapper {
		height: auto;
		min-height: 400px;
	}

	.company-lists {
		max-height: 300px;
	}

	.select-goods-wrapper {
		height: 400px;
	}
}

@media screen and (max-width: 768px) {
	.invoice-container {
		padding: 0 12px;
	}

	.search-form {
		.el-row {
			margin-left: 0 !important;
			margin-right: 0 !important;
		}

		.el-col {
			padding-left: 4px !important;
			padding-right: 4px !important;
		}
	}

	.section-wrapper {
		min-height: 350px;
	}

	.company-lists {
		max-height: 250px;
	}
}

@media screen and (max-width: 480px) {
	.invoice-container {
		padding: 0 8px;
	}

	.search-form {
		.el-form-item__label {
			width: 50px !important;
		}

		.el-row:first-child .el-col {
			flex: 0 0 100%;
			max-width: 100%;
		}
	}

	.section-wrapper {
		min-height: 300px;
	}

	.card-header {
		flex-direction: column;
		align-items: flex-start;
		gap: 8px;

		.header-button {
			align-self: flex-end;
		}
	}
}

/* 弹窗底部按钮样式 */
.dialog-footer {
	text-align: center;
	padding: 12px 0;

	.el-button {
		min-width: 80px;
	}
}

/* 平滑过渡效果 */
.section-wrapper,
.full-height-card,
.company-lists {
	transition: all 0.3s ease;
}

/* 新的公司列表全屏布局优化 */
.company-list-section-full {
	.company-lists {
		// 增加表格的最大高度以适应更大的空间
		max-height: calc(100vh - 300px);

		// 为每个公司列表分配更多空间
		> div {
			margin-bottom: 12px;

			&:last-child {
				margin-bottom: 0;
			}
		}
	}

	// 优化搜索表单的间距
	.search-form {
		margin-bottom: 16px;
		border-bottom: 1px solid #ebeef5;
		padding-bottom: 12px;
	}

	// 优化分割线样式
	.el-divider {
		&:first-of-type {
			margin-top: 8px;
		}
	}
}
</style>
