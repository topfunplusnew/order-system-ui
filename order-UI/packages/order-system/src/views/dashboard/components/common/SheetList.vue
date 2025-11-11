<script>
import { getCompany } from '@/api/system/company';
import CompanysList from '@/views/dashboard/components/common/CompanysList.vue';
// import CompanyInformation from '@/views/dashboard/components/common/CompanyInformation.vue';
import InvoiceBody from '@/views/dashboard/components/common/InvoiceBody.vue';
import SelectGoods from '@/views/dashboard/components/common/SelectGoods.vue';
import SheetItem from '@/views/dashboard/components/common/SheetItem.vue';
import { mixin_excel_server } from '@/views/dashboard/components/common/utils/excelServer';
import DragDiv from '@/components/DragDiv/index.vue';
import { importTemplateCompanies, updateTemplateCompanies, getOperatedMap, extractCompanyId, isSheetOperated, markSheetOperated, clearSheetRecordsByFileId } from '@/api/excelTemplateStore';

// 默认导出组件
export default {
	name: 'SheetList',
	computed: {},
	components: {
		CompanysList,
		InvoiceBody,
		// CompanyInformation,
		SelectGoods,
		SheetItem,
		DragDiv
	},
	mixins: [mixin_excel_server],
	// 接收文件读取到的sheetList 渲染出来给用户看 并且可以选择看哪一个
	props: {
		// sheet列表
		sheetList: {
			type: Array,
			default: () => {
				return [];
			}
		},
		// 工作簿引用（用于大文件懒加载）
		workbookRef: {
			type: Object,
			default: null
		},
		// 是否为大文件
		isLargeFile: {
			type: Boolean,
			default: false
		},
		// 当前文件标识
		currentFileId: {
			type: String,
			default: null
		}
	},
	data() {
		return {
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
			templateOperatedMap: {},
			// 当前Sheet名称
			currentSheetName: null,
			// 是否为新文件导入（true: 新文件，false: 同一文件的不同工作表）
			isNewFileImport: true
		};
	},
	watch: {
		// 监听文件标识变化
		currentFileId: {
			handler(newFileId, oldFileId) {
				if (newFileId && newFileId !== oldFileId) {
					// 文件标识发生变化，说明是新文件导入
					this.isNewFileImport = true;
				} else if (newFileId && newFileId === oldFileId) {
					// 文件标识相同，说明是同一文件的不同工作表
					this.isNewFileImport = false;
				}
			},
			immediate: true
		}
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
		 * 对某一个excel点击打开的函数
		 * @param excelItem 选中的某一个excel 例:信息汇总表
		 * @param excelIndex 选中的excel的索引 例:0
		 */
		async handleInvoiceAll(excelItem, excelIndex) {
			// 检查当前Sheet是否已被操作过
			const sheetName = excelItem;
			const isCurrentSheetOperated = await isSheetOperated(this.currentFileId, sheetName);

			// 保存 isNewFileImport 的值，因为 reset() 会重置它
			const wasNewFileImport = this.isNewFileImport;

			// 先清除
			this.reset();
			// 清除购买方和销方的信息
			this.handleClearPurchaseInfo();
			this.handleClearSellerInfo();

			// 在reset之后重新设置当前Sheet名称
			this.currentSheetName = sheetName;

			// 恢复 isNewFileImport 的值
			this.isNewFileImport = wasNewFileImport;

			// 显示加载状态
			const loadingInstance = this.$loading({
				lock: true,
				text: '正在处理数据，请稍候...',
				spinner: 'el-icon-loading',
				background: 'rgba(0, 0, 0, 0.7)'
			});

			// 使用setTimeout来确保loading能够显示
			setTimeout(async () => {
				try {
					let excelInfo;

					// 如果是大文件，需要懒加载数据
					if (this.isLargeFile && this.workbookRef) {
						excelInfo = await this.loadSheetData(excelIndex);
					} else {
						excelInfo = this.handleReadExcel();
					}

					// 本次导入版本：使用时间戳
					this.currentVersion = Date.now();
					await this.processExcelData(excelInfo, excelIndex);
					// 将模板公司数据导入到 IndexedDB
					try {
						const templates = (this.$store.state.excel.purchaseTemplateData || []).concat(this.$store.state.excel.sellerTemplateData || []);

						if (this.isNewFileImport) {
							await importTemplateCompanies(templates, this.currentFileId);
						} else if (!isCurrentSheetOperated) {
							// 同一文件但Sheet未操作过，清空数据并导入
							await importTemplateCompanies(templates, this.currentFileId);
						} else {
							// 同一文件且Sheet已操作过，保持现有数据
							await updateTemplateCompanies(templates);
						}

						this.templateOperatedMap = await getOperatedMap();
					} catch (err) {
						console.error('导入模板公司数据至 IndexedDB 失败:', err);
					}
					// 打开弹窗
					this.invoiceAllVisible = true;
					// 首次打开后，保存一次会话
					this.saveBatchInvoiceSession();
					// 发送当前文件ID和Sheet名称到子组件
					this.$bus.$emit('sheet-info-updated', {
						fileId: this.currentFileId,
						sheetName: this.currentSheetName
					});

					// 标记当前Sheet为已操作（因为用户已经打开了批量开票弹窗）
					try {
						await markSheetOperated(this.currentFileId, this.currentSheetName);
					} catch (e) {
						console.error('SheetList: 标记Sheet已操作失败:', e);
					}

					// 第一次处理后，标记为非新文件导入
					if (this.isNewFileImport) {
						this.isNewFileImport = false;
					}
				} catch (error) {
					console.error('处理Excel数据失败:', error);
					this.$message.error('处理数据时发生错误，请重试');
				} finally {
					loadingInstance.close();
				}
			}, 100);
		},
		/**
		 * 懒加载Sheet数据（用于大文件）
		 * @param {number} sheetIndex - Sheet索引
		 * @returns {Array} - 加载的数据
		 */
		async loadSheetData(sheetIndex) {
			if (!this.workbookRef) {
				throw new Error('工作簿引用不存在');
			}

			const sheetName = this.workbookRef.SheetNames[sheetIndex];
			const sheet = this.workbookRef.Sheets[sheetName];

			// 对于大文件，分批读取数据
			const data = await this.readSheetInBatches(sheet);

			// 创建类似于原始结构的数组
			const result = [];
			for (let i = 0; i < this.sheetList.length; i++) {
				if (i === sheetIndex) {
					result.push(data);
				} else {
					result.push([]);
				}
			}

			return result;
		},
		/**
		 * 分批读取Sheet数据
		 * @param {Object} sheet - Sheet对象
		 * @returns {Array} - 读取的数据
		 */
		async readSheetInBatches(sheet) {
			const { utils } = await import('xlsx');

			// 获取数据范围
			const range = utils.decode_range(sheet['!ref'] || 'A1:A1');
			const totalRows = range.e.r - range.s.r + 1;

			// 如果数据量不大，直接读取
			if (totalRows <= 1000) {
				return utils.sheet_to_json(sheet);
			}

			// 分批读取
			const batchSize = 500;
			const result = [];

			for (let startRow = range.s.r + 1; startRow <= range.e.r; startRow += batchSize) {
				const endRow = Math.min(startRow + batchSize - 1, range.e.r);

				// 创建临时范围
				const tempRange = {
					s: { r: range.s.r, c: range.s.c },
					e: { r: endRow, c: range.e.c }
				};

				// 创建临时Sheet
				const tempSheet = {};
				tempSheet['!ref'] = utils.encode_range(tempRange);

				// 复制数据
				for (let row = range.s.r; row <= endRow; row++) {
					for (let col = range.s.c; col <= range.e.c; col++) {
						const cellAddr = utils.encode_cell({ r: row, c: col });
						if (sheet[cellAddr]) {
							tempSheet[cellAddr] = sheet[cellAddr];
						}
					}
				}

				const batchData = utils.sheet_to_json(tempSheet);
				result.push(...batchData);

				// 给UI一点时间更新
				await new Promise(resolve => setTimeout(resolve, 10));
			}

			return result;
		},
		/**
		 * 处理Excel数据的通用方法
		 * @param {Array} excelInfo - Excel数据
		 * @param {number} excelIndex - 选中的索引
		 */
		async processExcelData(excelInfo, excelIndex) {
			let arr = [];
			let purchaseMap = new Map();
			let sellerMap = new Map();

			// 需要销售方id 销售方的名称和类型 以及购买方id  购买方类型 和名称
			for (let item of excelInfo[excelIndex]) {
				if (item['销方ID'] && !/^\d+$/.test(item['销方ID'])) {
					this.$message.error('导入的excel格式有误,请仔细阅读excel模板中的注意！');
					return;
				}
				arr.push(this.mapperParams(item)); // 映射关系
			}

			// 过滤掉arr中 属性全部为undefined的元素
			arr = arr.filter(item => !Object.values(item).every(value => !value));
			// 检查excel中是否有同时存在的
			let ok = arr.every(item => this.purchaseHandler(item));
			if (!ok) {
				this.$message.error('存在订单中存在购买方和销方的信息，请检查');
				return;
			}
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
				// 如果存在id 并且 我方名称不一样
				if (_existing) {
					_existing.total += element.total; // 累加 total
					_existing.ticketPointAmount += element.ticketPointAmount; // 累加票点金额
				} else {
					map.set(_onlyKey, {
						id,
						type,
						name,
						// 己方公司名称
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
		},
		// 映射关系 这里可以自定义
		mapperParams(item) {
			const ticketPoint = Number(item['票点']) || 0; // 获取票点，默认为0
			const totalAmount = Number(item['价税合计']) || 0; // 获取价税合计

			// 计算票点金额：票点金额 = 开票金额 / (1 + 票点) * 票点
			const ticketPointAmount = totalAmount > 0 && ticketPoint > 0 ? (totalAmount / (1 + ticketPoint)) * ticketPoint : 0;

			return {
				sellerId: item['销方ID'],
				sellerName: item['销方名称'],
				sellerType: item['销方类型'],
				purchaseId: item['购买方ID'],
				purchaseType: item['购买方类型'],
				purchaseName: item['购买方名称'],
				total: totalAmount,
				ticketPoint: ticketPoint,
				ticketPointAmount: Number(ticketPointAmount.toFixed(2)) // 保留两位小数
			};
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
			// 重置文件标识状态
			this.isNewFileImport = true;
			// 重置当前Sheet名称
			this.currentSheetName = null;
		}
	}
};
</script>

<template>
	<div>
		<!--    Excel Sheet的选择列表-->
		<div class="sheet-container">
			<!--      点击某一个sheet-->
			<SheetItem v-for="(item, index) in sheetList" :key="item" :title="item" @click.native="handleInvoiceAll(item, index)" />
		</div>

		<!--    批量开票的弹窗-->
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
.sheet-container {
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;
	gap: 12px;
	margin-bottom: 20px;
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
	height: calc(100vh - 120px);
	padding: 0 20px;
	overflow: hidden;
	display: flex;
	flex-direction: column;
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

/* 卡片通用样式 */
.full-height-card {
	height: 100%;
	display: flex;
	flex-direction: column;

	::v-deep .el-card__header {
		padding: 12px 16px;
		border-bottom: 1px solid #ebeef5;
		flex-shrink: 0;
	}

	::v-deep .el-card__body {
		flex: 1;
		padding: 16px;
		overflow: hidden;
		display: flex;
		flex-direction: column;
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

/* 公司列表样式 */
.company-lists {
	flex: 1;
	overflow-y: auto;
	overflow-x: visible; /* 允许子元素水平滚动 */
	min-height: 0;

	.el-divider {
		margin: 16px 0 12px 0;

		.el-divider__text {
			background-color: #f5f7fa;
		}
	}

	/* 美化滚动条 */
	&::-webkit-scrollbar {
		width: 16px;
	}

	&::-webkit-scrollbar-thumb {
		background: #dcdfe6;
		border-radius: 13px;

		&:hover {
			background: #c0c4cc;
		}
	}

	&::-webkit-scrollbar-track {
		background: transparent;
		width: 10px;
	}
}

/* 订单选择组件包装 */
.select-goods-wrapper {
	flex: 1;
	overflow-y: auto;
	overflow-x: hidden;
	min-height: 0;
	max-height: calc(50vh - 100px); /* 设置最大高度，减去头部和间距 */

	/* 美化滚动条 */
	&::-webkit-scrollbar {
		width: 8px;
	}

	&::-webkit-scrollbar-thumb {
		background: #dcdfe6;
		border-radius: 4px;

		&:hover {
			background: #c0c4cc;
		}
	}

	&::-webkit-scrollbar-track {
		background: #f5f7fa;
		border-radius: 4px;
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
	padding: 16px 0;
	border-top: 1px solid #ebeef5;

	.el-button {
		min-width: 80px;
	}
}

/* 优化卡片阴影和边框 */
.full-height-card {
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
	border: 1px solid #ebeef5;
	border-radius: 6px;

	&:hover {
		box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.12);
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
