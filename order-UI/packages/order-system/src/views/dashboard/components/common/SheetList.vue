<script>
import { getCompany } from '@/api/system/company';
import CompanysList from '@/views/dashboard/components/common/CompanysList.vue';
// import CompanyInformation from '@/views/dashboard/components/common/CompanyInformation.vue';
import InvoiceBody from '@/views/dashboard/components/common/InvoiceBody.vue';
import SelectGoods from '@/views/dashboard/components/common/SelectGoods.vue';
import SheetItem from '@/views/dashboard/components/common/SheetItem.vue';
import { mixin_excel_server } from '@/views/dashboard/components/common/utils/excelServer';

// 默认导出组件
export default {
	name: 'SheetList',
	computed: {},
	components: {
		CompanysList,
		InvoiceBody,
		// CompanyInformation,
		SelectGoods,
		SheetItem
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
			// 购买方搜索字段
			purchase: null,
			// 卖出方搜索字段
			seller: null,
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
			purchaseTemplateData: [],
			sellerTemplateData: []
		};
	},
	methods: {
		/**
		 * 对某一个excel点击打开的函数
		 * @param excelItem 选中的某一个excel 例:信息汇总表
		 * @param excelIndex 选中的excel的索引 例:0
		 */
		handleInvoiceAll(excelItem, excelIndex) {
			// 先清除
			this.reset();
			// 清除购买方和销方的信息
			this.handleClearPurchaseInfo();
			this.handleClearSellerInfo();
			let arr = [];
			let purchaseMap = new Map();
			let sellerMap = new Map();
			// 读取excel的数据
			const excelInfo = this.handleReadExcel();
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

			// 保存模板原始数据，按对方身份拆分，供 CompanysList 查看
			this.purchaseTemplateData = arr.filter(e => e && e.sellerId === 0);
			this.sellerTemplateData = arr.filter(e => e && e.sellerId !== 0);

			// 计算统计信息
			this.calculateStatistics(arr);

			// 暂存购买方和销方的信息
			this.handleStorePurchaseInfo(this.purchaseTotalInfo);
			this.handleStoreSellerInfo(this.sellerTotalInfo);
			// 打开弹窗
			this.invoiceAllVisible = true;
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
		// 弹窗左侧供应商列表的筛选
		handleFilter() {
			// 每次操作之前都要重置 重置的逻辑就是从暂存拿出新的进行复制
			this.handleReset();
			// 筛选
			if (this.purchase) {
				this.purchaseTotalInfo = this.purchaseTotalInfo.filter(item => {
					return item.name.indexOf(this.purchase) !== -1;
				});
			}
			if (this.seller) {
				this.sellerTotalInfo = this.sellerTotalInfo.filter(item => {
					return item.name.indexOf(this.seller) !== -1;
				});
			}
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
		<!--    Excel Sheet的选择列表-->
		<div class="sheet-container">
			<!--      点击某一个sheet-->
			<SheetItem v-for="(item, index) in sheetList" :key="item" :title="item" @click.native="handleInvoiceAll(item, index)" />
		</div>

		<!--    批量开票的弹窗-->
		<div>
			<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="批量开票" fullscreen :visible.sync="invoiceAllVisible" append-to-body>
				<div class="invoice-container">
					<el-row :gutter="16" class="invoice-row">
						<!-- 左侧区域 -->
						<el-col :xl="6" :lg="7" :md="8" :sm="24" :xs="24" class="column-section left-section">
							<div class="section-wrapper">
								<!-- 公司列表卡片 - 占用整个左侧空间 -->
								<div class="company-list-section-full">
									<el-card class="full-height-card">
										<div slot="header" class="card-header">
											<span class="bold-text">公司列表</span>
										</div>
										<!-- 搜索表单 -->
										<el-form class="search-form">
											<el-row :gutter="8">
												<el-col :span="12">
													<el-form-item label="购买方" label-width="60px">
														<el-input v-model="purchase" placeholder="购买方名称" size="mini" clearable />
													</el-form-item>
												</el-col>
												<el-col :span="12">
													<el-form-item label="销方" label-width="40px">
														<el-input v-model="seller" placeholder="销方名称" size="mini" clearable />
													</el-form-item>
												</el-col>
											</el-row>
											<el-row>
												<el-col :span="24">
													<div class="button-group">
														<el-button type="primary" size="mini" @click="handleFilter">查询</el-button>
														<el-button type="warning" size="mini" @click="handleReset">重置</el-button>
													</div>
												</el-col>
											</el-row>
										</el-form>

										<!-- 公司列表 -->
										<div class="company-lists">
											<el-divider>
												<span class="bold-text">购买方信息</span>
											</el-divider>
											<CompanysList
												side="purchase"
												:company-total-info="purchaseTotalInfo"
												:statistics-info="statisticsInfo ? statisticsInfo.purchaseStats : { suppliers: { total: 0, count: 0 }, customers: { total: 0, count: 0 } }"
												:template-data="purchaseTemplateData"
												@handleCheck="handleCheck"
											/>
											<el-divider>
												<span class="bold-text">销方信息</span>
											</el-divider>
											<CompanysList
												side="seller"
												:company-total-info="sellerTotalInfo"
												:statistics-info="statisticsInfo ? statisticsInfo.sellerStats : { suppliers: { total: 0, count: 0 }, customers: { total: 0, count: 0 } }"
												:template-data="sellerTemplateData"
												@handleCheck="handleCheck"
											/>
										</div>
									</el-card>
								</div>
							</div>
						</el-col>

						<!-- 中间区域 -->
						<el-col :xl="12" :lg="11" :md="10" :sm="24" :xs="24" class="column-section middle-section">
							<div class="section-wrapper">
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
						</el-col>

						<!-- 右侧区域 -->
						<el-col :xl="6" :lg="6" :md="6" :sm="24" :xs="24" class="column-section right-section">
							<div class="section-wrapper">
								<InvoiceBody />
							</div>
						</el-col>
					</el-row>
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

	.invoice-row {
		height: 100%;
		margin: 0;
	}
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
	min-height: 0;

	.el-divider {
		margin: 16px 0 12px 0;

		.el-divider__text {
			background-color: #f5f7fa;
		}
	}

	/* 美化滚动条 */
	&::-webkit-scrollbar {
		width: 6px;
	}

	&::-webkit-scrollbar-thumb {
		background: #dcdfe6;
		border-radius: 3px;

		&:hover {
			background: #c0c4cc;
		}
	}

	&::-webkit-scrollbar-track {
		background: transparent;
	}
}

/* 订单选择组件包装 */
.select-goods-wrapper {
	flex: 1;
	overflow: hidden;
	min-height: 0;
}

/* 响应式布局 */
@media screen and (max-width: 1200px) {
	.invoice-container {
		height: auto;
		min-height: calc(100vh - 120px);

		.invoice-row {
			height: auto;
		}
	}

	.column-section {
		height: auto;
		margin-bottom: 16px;

		&:last-child {
			margin-bottom: 0;
		}
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
