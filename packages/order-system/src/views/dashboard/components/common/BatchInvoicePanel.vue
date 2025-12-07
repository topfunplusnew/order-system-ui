<script>
import { create, all } from 'mathjs';
import { getCompany } from '@/api/system/company';
import InvoiceCompanysList from '@/views/dashboard/components/common/InvoiceCompanysList.vue';
import QueueInvoiceList from '@/views/dashboard/components/common/QueueInvoiceList.vue';
import SelectGoods from '@/views/dashboard/components/common/SelectGoods.vue';
import DragDiv from '@/components/DragDiv/index.vue';
import {
	listBatchInvoiceIn,
	listBatchInvoiceOut,
	deleteBatchInvoiceInByVoucher,
	deleteBatchInvoiceInById,
	deleteBatchInvoiceInInvoice,
	deleteBatchInvoiceOutByVoucher,
	deleteBatchInvoiceOutById,
	deleteBatchInvoiceOutInvoice
} from '@/api/system/batchInvoice';

// 默认导出组件
export default {
	name: 'BatchInvoicePanel',
	computed: {
		// 判断当前应该显示购买方还是销方
		currentSide() {
			const hasPurchase = this.purchaseTotalInfo && this.purchaseTotalInfo.length > 0;
			const hasSeller = this.sellerTotalInfo && this.sellerTotalInfo.length > 0;
			return hasPurchase ? 'purchase' : hasSeller ? 'seller' : 'purchase';
		},
		// 当前显示的公司列表数据
		currentCompanyTotalInfo() {
			return this.currentSide === 'purchase' ? this.purchaseTotalInfo : this.sellerTotalInfo;
		},
		// 当前显示的统计信息
		currentStatisticsInfo() {
			if (this.currentSide === 'purchase') {
				return this.statisticsInfo ? this.statisticsInfo.purchaseStats : { suppliers: { total: 0, count: 0 }, customers: { total: 0, count: 0 } };
			}
			return this.statisticsInfo ? this.statisticsInfo.sellerStats : { suppliers: { total: 0, count: 0 }, customers: { total: 0, count: 0 } };
		},
		// 当前显示的标题
		currentSideTitle() {
			return this.currentSide === 'purchase' ? '购买方信息' : '销方信息';
		}
	},
	components: {
		InvoiceCompanysList,
		QueueInvoiceList,
		SelectGoods,
		DragDiv
	},
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
			companyInfo: {},
			invoiceAllVisible: false,
			invoiceSupplierList: [],
			// 购买方统计（从后端获取）
			purchaseTotalInfo: [],
			// 销方统计（从后端获取）
			sellerTotalInfo: [],
			// 原始批次数据（从后端获取）
			batchDetailRows: [],
			// 我方公司搜索字段
			myCompany: null,
			// 对方公司搜索字段
			otherCompany: null,
			// 已操作状态搜索字段（null: 全部, true: 已操作, false: 未操作）
			operatedStatus: null,
			// 统计信息
			statisticsInfo: {
				purchaseStats: {
					suppliers: { total: 0, count: 0 },
					customers: { total: 0, count: 0 }
				},
				sellerStats: {
					suppliers: { total: 0, count: 0 },
					customers: { total: 0, count: 0 }
				}
			}
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
		// 监听开票成功事件，刷新数据
		this.$bus.$on('batch-invoice:refresh', this.handleRefreshBatchData);
	},
	beforeDestroy() {
		this.$bus.$off('batch-invoice:refresh', this.handleRefreshBatchData);
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
		// 打开批量开票全屏弹窗
		async handleOpenBatch(row) {
			if (!row || !row.voucher) {
				this.$message.warning('未找到有效的批次号');
				return;
			}
			this.reset();
			this.currentVoucher = row.voucher;
			// 从后端获取批次详情
			const batchRows = await this.fetchVoucherDetails(row.voucher);
			if (!batchRows || batchRows.length === 0) {
				this.$message.warning('该批次暂无明细数据');
				return;
			}
			// 保存原始数据
			this.batchDetailRows = batchRows;
			// 处理并聚合数据
			this.processAndAggregateData(batchRows);
			this.invoiceAllVisible = true;
		},
		// 从后端获取批次详情
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
		// 刷新批次数据（开票成功后调用）
		async handleRefreshBatchData() {
			if (!this.currentVoucher) {
				return;
			}
			const batchRows = await this.fetchVoucherDetails(this.currentVoucher);
			if (batchRows && batchRows.length > 0) {
				this.batchDetailRows = batchRows;
				this.processAndAggregateData(batchRows);
			}
			// 同时刷新列表
			this.fetchBatchList();
		},
		// 处理并聚合后端数据（纯计算，不存入 Vuex）
		processAndAggregateData(rows = []) {
			let purchaseMap = new Map();
			let sellerMap = new Map();
			const arr = [];

			for (const item of rows) {
				const mapped = this.mapBackendData(item);
				if (mapped) {
					arr.push(mapped);
				}
			}

			// 过滤无效数据
			const validArr = arr.filter(item => item && !Object.values(item).every(v => v === undefined || v === null));

			// 检查数据有效性
			const isValid = validArr.every(item => this.validateCompanyData(item));
			if (!isValid) {
				this.$message.error('数据中存在同时包含购买方和销方信息的记录，请检查');
				return;
			}

			// 聚合公司信息
			validArr.forEach(element => {
				// 判断对方是否是购买方（sellerId 为 0 表示对方是购买方）
				const isPurchase = element.sellerId === 0;
				const map = isPurchase ? purchaseMap : sellerMap;
				const id = isPurchase ? element.purchaseId : element.sellerId;
				const name = isPurchase ? element.purchaseName : element.sellerName;
				const type = isPurchase ? element.purchaseType : element.sellerType;
				// 我方公司名称
				const us = isPurchase ? element.sellerName : element.purchaseName;

				if (id == null || id === '') {
					return;
				}

				// 唯一键：公司ID + 我方公司
				const _onlyKey = id + '::' + us;
				const _existing = map.get(_onlyKey);
				if (_existing) {
					// 累加金额（仅累加未开票的记录）
					if (!element.invoiced) {
						const totalSum = this.math.add(this.math.bignumber(_existing.total || 0), this.math.bignumber(element.total || 0));
						const ticketSum = this.math.add(this.math.bignumber(_existing.ticketPointAmount || 0), this.math.bignumber(element.ticketPointAmount || 0));
						_existing.total = Number(this.math.format(totalSum, { precision: 12, notation: 'fixed' }));
						_existing.ticketPointAmount = Number(this.math.format(ticketSum, { precision: 12, notation: 'fixed' }));
					}
					// 记录相关的批次ID
					if (!_existing.batchIds.includes(element.id)) {
						_existing.batchIds.push(element.id);
					}
					// 更新已操作状态（只要有一条已开票，就标记为已操作）
					if (element.invoiced) {
						_existing.invoiced = true;
					}
				} else {
					map.set(_onlyKey, {
						id,
						type,
						name,
						us,
						total: element.invoiced ? 0 : element.total,
						ticketPoint: element.ticketPoint,
						ticketPointAmount: element.invoiced ? 0 : element.ticketPointAmount,
						invoiced: element.invoiced || false,
						batchIds: [element.id]
					});
				}
			});

			this.purchaseTotalInfo = Array.from(purchaseMap.values());
			this.sellerTotalInfo = Array.from(sellerMap.values());

			// 计算统计信息
			this.calculateStatistics(validArr);

			// 存储原始数据供 QueueInvoiceList 使用
			this.$store.dispatch('excel/setBatchDetailRows', validArr);
		},
		// 映射后端数据为统一格式
		mapBackendData(item) {
			if (!item) return null;
			const totalAmount = Number(item.totalAmount ?? item.total ?? 0);
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
				total: totalAmount,
				ticketPoint: ticketPoint,
				ticketPointAmount: normalizedTicketPointAmount,
				id: item.id,
				voucher: item.voucher || '',
				invoiced: item.invoiced || false,
				invoiceId: item.invoiceId || null
			};
		},
		// 计算票点金额
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

			const purchaseSupplierIds = new Set();
			const purchaseCustomerIds = new Set();
			const sellerSupplierIds = new Set();
			const sellerCustomerIds = new Set();

			dataArray.forEach(element => {
				// 只统计未开票的记录
				if (element.invoiced) {
					return;
				}
				const amount = Number(element.total) || 0;

				// 统计购买方
				if (element.purchaseType && element.purchaseType !== '己方公司') {
					const pid = element.purchaseId;
					if (element.purchaseType === '供应商') {
						this.statisticsInfo.purchaseStats.suppliers.total += amount;
						if (pid && Number(pid) !== 0) {
							purchaseSupplierIds.add(String(pid));
						}
					} else if (element.purchaseType === '客户') {
						this.statisticsInfo.purchaseStats.customers.total += amount;
						if (pid && Number(pid) !== 0) {
							purchaseCustomerIds.add(String(pid));
						}
					}
				}

				// 统计销方
				if (element.sellerType && element.sellerType !== '己方公司') {
					const sid = element.sellerId;
					if (element.sellerType === '供应商') {
						this.statisticsInfo.sellerStats.suppliers.total += amount;
						if (sid && Number(sid) !== 0) {
							sellerSupplierIds.add(String(sid));
						}
					} else if (element.sellerType === '客户') {
						this.statisticsInfo.sellerStats.customers.total += amount;
						if (sid && Number(sid) !== 0) {
							sellerCustomerIds.add(String(sid));
						}
					}
				}
			});

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
		// 校验公司数据有效性
		validateCompanyData(item) {
			if (item.purchaseId === 0 && item.sellerId === 0) {
				return false;
			}
			return !(item.purchaseId !== 0 && item.sellerId !== 0);
		},
		// 弹窗左侧供应商列表的筛选
		handleFilter() {
			// 重新从原始数据聚合
			this.processAndAggregateData(this.batchDetailRows);

			// 通用筛选函数
			const filterItems = items => {
				return items.filter(item => {
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
					// 已操作状态筛选（基于后端的 invoiced 字段）
					if (this.operatedStatus !== null) {
						if (item.invoiced !== this.operatedStatus) {
							return false;
						}
					}
					return true;
				});
			};

			// 应用筛选
			if (this.currentSide === 'purchase') {
				this.purchaseTotalInfo = filterItems(this.purchaseTotalInfo);
			} else {
				this.sellerTotalInfo = filterItems(this.sellerTotalInfo);
			}
		},

		// 查看某一个公司的信息
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
			// 重新从原始数据聚合
			this.processAndAggregateData(this.batchDetailRows);
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

		// 关闭弹窗并清除所有状态
		handleClose() {
			this.reset();
			this.invoiceAllVisible = false;
		},
		// 重置所有状态
		reset() {
			// 清除sessionStorage
			this.clearSessionStorage();
			// 清除组件状态
			this.clearComponentState();
			// 清除Vuex状态
			this.clearVuexState();
			// 发布清除事件
			this.$bus.$emit('invoice-clear');
		},
		// 清除sessionStorage
		clearSessionStorage() {
			sessionStorage.removeItem('us');
			sessionStorage.removeItem('invoiceAmount');
			sessionStorage.removeItem('companyList_selected_company_id');
			sessionStorage.removeItem('merged_company_info');
		},
		// 清除组件状态
		clearComponentState() {
			this.handleResetCompanyInfo();
			this.handleResetOrderList();
			this.purchaseTotalInfo = [];
			this.sellerTotalInfo = [];
			this.batchDetailRows = [];
			this.myCompany = null;
			this.otherCompany = null;
			this.operatedStatus = null;
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
		},
		// 清除Vuex状态
		clearVuexState() {
			this.$store.dispatch('excel/clearTicketPoint');
			this.$store.dispatch('excel/clearComment');
			this.$store.dispatch('excel/clearBatchDetailRows');
			this.$store.dispatch('excel/clearSelectedInvoiceList');
			this.$store.dispatch('excel/clearInvoiceAmount');
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
			<el-table :data="batchList" size="mini" :loading="listLoading" style="width: 100%" class="batch-table" :cell-style="() => ({ padding: '6px 4px' })" :header-cell-style="() => ({ background: '#f5f7fa', color: '#606266', fontWeight: '600' })">
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
			<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="批量开票" fullscreen :visible.sync="invoiceAllVisible" append-to-body class="invoice-dialog">
				<div class="invoice-container">
					<!-- 上下布局：上面是 InvoiceCompanysList + QueueInvoiceList（DragDiv），下面是 SelectGoods -->
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
													<div v-if="currentCompanyTotalInfo && currentCompanyTotalInfo.length > 0" class="section-title-wrapper">
														<div class="section-title">
															<span class="title-icon"></span>
															<span class="title-text">{{ currentSideTitle }}</span>
														</div>
													</div>
													<InvoiceCompanysList
														v-if="currentCompanyTotalInfo && currentCompanyTotalInfo.length > 0"
														:side="currentSide"
														:company-total-info="currentCompanyTotalInfo"
														:statistics-info="currentStatisticsInfo"
														:mode="mode"
														:voucher="currentVoucher"
														@handleCheck="handleCheck"
													/>
													<div v-else class="empty-company-list">
														<el-empty description="暂无公司数据" :image-size="100" />
													</div>
												</div>
											</el-card>
										</div>
									</div>
								</template>

								<template #right>
									<div class="section-wrapper">
										<QueueInvoiceList :mode="mode" />
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
	border-bottom: none;
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

/* 表格样式 - 仅保留必要的行分割 */
.batch-table {
	::v-deep .el-table {
		border: none;
	}

	::v-deep .el-table__header-wrapper {
		.el-table__header {
			th {
				border-bottom: 1px solid rgba(0, 0, 0, 0.08);
				border-right: none;
				background: transparent;

				&:last-child {
					border-right: none;
				}
			}
		}
	}

	::v-deep .el-table__body-wrapper {
		.el-table__body {
			td {
				border-bottom: 1px solid rgba(0, 0, 0, 0.06);
				border-right: none;

				&:last-child {
					border-right: none;
				}
			}

			tr:hover {
				background-color: rgba(64, 158, 255, 0.04);
			}

			tr:last-child td {
				border-bottom: none;
			}
		}
	}

	&::before {
		display: none;
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

/* 批量开票弹窗样式 - 移除边框 */
.invoice-dialog {
	::v-deep .el-dialog {
		border: none;
		box-shadow: none;
		background: #f5f7fa;
	}

	::v-deep .el-dialog__header {
		border-bottom: none;
		padding: 16px 20px;
		background: transparent;
	}

	::v-deep .el-dialog__body {
		padding: 0;
		background: transparent;
	}

	::v-deep .el-dialog__footer {
		border-top: none;
		padding: 12px 20px;
		background: transparent;
	}
}

/* 开票弹窗相关的样式 */
.invoice-container {
	height: calc(100vh - 100px);
	padding: 0 16px;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	background: transparent;
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
	border: 1px solid rgba(0, 0, 0, 0.12);
	border-radius: 8px;
	background: #ffffff;
	overflow: hidden;
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
	border: 1px solid rgba(0, 0, 0, 0.12);
	border-radius: 8px;
	background: #ffffff;
	overflow: hidden;
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

/* 卡片通用样式 - 移除边框，由外层区域边框控制 */
.full-height-card {
	height: 100%;
	display: flex;
	flex-direction: column;
	border: none !important;
	box-shadow: none !important;
	background: transparent;
	overflow: hidden;

	::v-deep .el-card__header {
		padding: 12px 16px;
		border-bottom: 1px solid rgba(0, 0, 0, 0.08);
		flex-shrink: 0;
		background: transparent;
	}

	::v-deep .el-card__body {
		flex: 1;
		padding: 12px 16px;
		overflow: hidden;
		display: flex;
		flex-direction: column;
		background: transparent;
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

/* 公司列表样式 - 不显示滚动条，完全展示所有内容 */
.company-lists {
	flex: 1;
	overflow: visible;
	min-height: 0;
	padding-right: 4px;

	/* 区域标题样式 - 紧凑美化设计 */
	.section-title-wrapper {
		margin: 12px 0 10px 0;
		position: relative;
		display: flex;
		align-items: center;

		&::before {
			content: '';
			position: absolute;
			left: 0;
			right: 0;
			top: 50%;
			height: 1px;
			background: linear-gradient(to right, rgba(64, 158, 255, 0.2) 0%, rgba(64, 158, 255, 0.15) 50%, transparent 100%);
			z-index: 0;
		}

		.section-title {
			position: relative;
			z-index: 1;
			background: #ffffff;
			padding: 4px 12px 4px 8px;
			border-radius: 4px;
			border-left: 3px solid #409eff;
			display: inline-flex;
			align-items: center;
			gap: 6px;
			box-shadow: 0 1px 2px rgba(64, 158, 255, 0.1);

			.title-icon {
				width: 4px;
				height: 4px;
				background: #409eff;
				border-radius: 50%;
				flex-shrink: 0;
			}

			.title-text {
				color: #409eff;
				font-size: 13px;
				font-weight: 600;
				line-height: 1;
			}
		}
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
		// 移除高度限制，让表格完全显示所有内容，不出现滚动条

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
		border-bottom: 1px solid rgba(0, 0, 0, 0.08);
		padding-bottom: 16px;
	}

	// 优化分割线样式
	.el-divider {
		&:first-of-type {
			margin-top: 8px;
		}
	}

	// 空状态样式
	.empty-company-list {
		display: flex;
		align-items: center;
		justify-content: center;
		min-height: 200px;
		padding: 40px 20px;
	}
}
</style>
