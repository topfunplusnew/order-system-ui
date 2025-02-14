<!-- 批量开票的主要组件  -->

<!-- 开票主要有 销方id  销方公司名称 销方类型  购买方id 购买方公司名称 购买方类型 -->

<!-- 我方处于不同的位置 如果我方是销方，那么就选择订单 然后给购买方批量开票 -->

<script>
import { getCompany } from '@/api/system/company';
import CompanyInformation from '@/views/dashboard/components/common/CompanyInformation.vue';
import CompanysList from '@/views/dashboard/components/common/CompanysList.vue';
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
		CompanyInformation,
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
			minusValue: 0
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
			arr = excelInfo[excelIndex].map(item => {
				return this.mapperParams(item); // 映射关系
			});

			let ok = arr.every(item => this.purchaseHandler(item));

			if (!ok) {
				this.$message.error('存在订单中存在购买方和销方的信息，请检查');
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

					// 插入新的记录
				} else {
					map.set(_onlyKey, {
						id,
						type,
						name,
						// 我方公司名称
						us,
						total: element.total
					});
				}
			});

			this.purchaseTotalInfo = Array.from(purchaseMap.values());
			this.sellerTotalInfo = Array.from(sellerMap.values());

			// 暂存购买方和销方的信息
			this.handleStorePurchaseInfo(this.purchaseTotalInfo);
			this.handleStoreSellerInfo(this.sellerTotalInfo);
			// 打开弹窗
			this.invoiceAllVisible = true;
		},
		// 映射关系 这里可以自定义
		mapperParams(item) {
			return {
				sellerId: item['销方ID'],
				sellerName: item['销方名称'],
				sellerType: item['销方类型'],
				purchaseId: item['购买方ID'],
				purchaseType: item['购买方类型'],
				purchaseName: item['购买方名称'],
				total: item['价税合计']
			};
		},
		// 对公司进行校验
		purchaseHandler(item) {
			// 如果都为0
			if (!item.purchaseId && !item.sellerId) {
				return false;
			}
			// 如果购买方和销方的id都不为0
			if (item.purchaseId && item.sellerId) {
				return false;
			}

			return !(item.purchaseId < 0 || item.sellerId < 0);
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
			<SheetItem
				v-for="(item, index) in sheetList"
				:key="item"
				:title="item"
				@click.native="handleInvoiceAll(item, index)"
			/>
		</div>

		<!--    批量开票的弹窗-->
		<div>
			<el-dialog
				title="批量开票"
				fullscreen
				:visible.sync="invoiceAllVisible"
				append-to-body
			>
				<el-row :gutter="12" class="invoice-container">
					<!-- 左侧区域 -->
					<el-col :span="8" :sm="24" :md="8" class="left-section">
						<div class="left-box">
							<!-- 公司信息卡片 -->
							<CompanyInformation
								:company-info="companyInfo"
								class="company-info-card"
							/>

							<!-- 导入公司列表卡片 -->
							<div class="left-box-item">
								<el-card class="box-card">
									<div slot="header" class="clearfix">
										<span class="bold-text">导入公司列表</span>
									</div>
									<!-- 搜索表单 -->
									<el-form :inline="true" class="search-form">
										<el-form-item label="购买方名称">
											<el-input
												v-model="purchase"
												placeholder="请输入购买方名称"
												size="mini"
												clearable
											/>
										</el-form-item>
										<el-form-item label="销方名称">
											<el-input
												v-model="seller"
												placeholder="请输入销方名称"
												size="mini"
												clearable
											/>
										</el-form-item>
										<el-form-item class="button-group">
											<el-button
												type="primary"
												size="mini"
												@click="handleFilter"
											>
												查询
											</el-button>
											<el-button
												type="warning"
												size="mini"
												@click="handleReset"
											>
												重置
											</el-button>
										</el-form-item>
									</el-form>

									<!-- 公司列表 -->
									<div class="pay-others">
										<el-divider>
											<span class="bold-text">购买方信息</span>
										</el-divider>
										<CompanysList
											:company-total-info="purchaseTotalInfo"
											@handleCheck="handleCheck"
										/>
										<el-divider>
											<span class="bold-text">销方信息</span>
										</el-divider>
										<CompanysList
											:company-total-info="sellerTotalInfo"
											@handleCheck="handleCheck"
										/>
									</div>
								</el-card>
							</div>
						</div>
					</el-col>

					<!-- 中间区域 -->
					<el-col :span="12" :sm="24" :md="12" class="middle-section">
						<el-card class="box-card">
							<div slot="header" class="clearfix">
								<span class="bold-text">订单列表(未开票)</span>
								<el-button
									style="float: right; padding: 3px 0"
									type="text"
									@click="handleResetOrderList"
								>
									重置筛选
								</el-button>
							</div>
							<SelectGoods />
						</el-card>
					</el-col>

					<!-- 右侧区域 -->
					<el-col :span="4" :sm="24" :md="4" class="right-section">
						<InvoiceBody />
					</el-col>
				</el-row>
				<span slot="footer" class="dialog-footer">
					<el-button @click="handleClose">关 闭</el-button>
					<!--					<el-button type="primary" @click="invoiceAllVisible = false"-->
					<!--						>确 定</el-button-->
					<!--					>-->
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

/*开票弹窗相关的样式*/
.left-box {
	height: 100%;
	display: flex;
	flex-direction: column;
	gap: 20px;

	.company-info-card {
		flex-shrink: 0;
	}

	.left-box-item {
		flex: 1;
		overflow: hidden;

		.box-card {
			height: 100%;
			display: flex;
			flex-direction: column;

			::v-deep .el-card__body {
				flex: 1;
				overflow: hidden;
				display: flex;
				flex-direction: column;
			}
		}
	}
}

.search-form {
	margin-bottom: 15px;

	@media screen and (max-width: 768px) {
		.el-form-item {
			display: block;
			margin-right: 0;
			margin-bottom: 10px;

			.el-input {
				width: 100%;
			}
		}

		.button-group {
			text-align: right;
		}
	}
}

.pay-others {
	flex: 1;
	overflow-y: auto;
	padding-right: 5px;

	&::-webkit-scrollbar {
		width: 4px;
	}

	&::-webkit-scrollbar-thumb {
		background: #dcdfe6;
		border-radius: 2px;
	}

	&::-webkit-scrollbar-track {
		background: transparent;
	}
}

.box-card {
	height: 100%;

	::v-deep .el-card__body {
		height: calc(100% - 50px);
		overflow-y: auto;
	}
}

@media screen and (max-width: 768px) {
	.invoice-container {
		height: auto;
		overflow: visible;
	}

	.left-box {
		gap: 10px;
	}

	.pay-others {
		max-height: 300px;
	}
}
</style>
