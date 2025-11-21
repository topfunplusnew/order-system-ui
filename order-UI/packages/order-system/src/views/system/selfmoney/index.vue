<template>
	<div class="app-container">
		<!-- 筛选框 -->
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="100px" class="search-form">
			<el-form-item label="开始时间" prop="endDate">
				<el-date-picker v-model="queryParams.endDate" type="date" placeholder="选择开始时间" value-format="yyyy-MM-dd" size="mini" clearable class="form-input"></el-date-picker>
			</el-form-item>
			<el-form-item label="账户类型">
				<el-select v-model="queryParams.bankCardType" placeholder="账户类型" size="mini" clearable class="form-input" @keyup.enter.native="handleQuery">
					<el-option v-for="item in typeOption" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="开户名称" prop="acountsName">
				<el-input v-model="queryParams.acountsName" placeholder="请输入开户名称" clearable class="form-input" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="开户行" prop="bankName">
				<el-input v-model="queryParams.bankName" placeholder="请输入开户行" clearable class="form-input" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="银行账号" prop="bankNo">
				<el-input v-model="queryParams.bankNo" placeholder="请输入银行账号" clearable class="form-input" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="己方公司" prop="displayName">
				<el-input v-model="queryParams.displayName" placeholder="请输入己方公司" clearable class="form-input" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<!-- 右侧工具栏 -->
		<div class="toolbar-wrapper">
			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList">
				<!-- 左侧操作按钮 -->
				<template #left>
					<div class="toolbar-left">
						<el-row :gutter="10" class="mb8">
							<el-col :span="1.5">
								<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
							</el-col>
							<el-col :span="1.5">
								<el-select v-model="value" placeholder="余额排序" size="mini" style="width: 120px">
									<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
								</el-select>
							</el-col>
						</el-row>
					</div>
				</template>

				<!-- 打印按钮 -->
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" :disabled="bankAccountList.length === 0" />
					</el-col>
				</template>

				<!-- 导出按钮 -->
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport" :disabled="bankAccountList.length === 0" />
					</el-col>
				</template>
			</right-toolbar>
		</div>

		<!-- 银行账户表格 -->
		<div class="table-container" v-loading="loading">
			<el-table
				id="printBox"
				ref="table"
				v-horizontal-scroll="'always'"
				border
				:data="bankAccountList"
				size="mini"
				:cell-style="
					() => {
						return { padding: '.5px' };
					}
				"
			>
		<el-table-column v-if="columns[0].visible" label="排序序号" align="center" prop="sort" width="100" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.sort }}</div>
					<span>{{ scope.row.sort }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
		<el-table-column v-if="columns[1].visible" label="己方公司" align="center" prop="displayName" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.displayName }}</div>
					<span>{{ scope.row.displayName }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
		<el-table-column v-if="columns[2].visible" label="开户名称" align="center" prop="acountsName" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.acountsName }}</div>
					<span>{{ scope.row.acountsName }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
		<el-table-column v-if="columns[3].visible" label="银行账号" align="center" prop="bankNo" show-overflow-tooltip width="260">
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">
						<span style="color: red">[{{ scope.row.bankCardType }}]</span>
						{{ scope.row.bankNo }}
					</div>
					<div>
						<span style="color: red">[{{ scope.row.bankCardType }}]</span>
						{{ scope.row.bankNo }}
					</div>
				</el-tooltip>
			</template>
		</el-table-column>
		<el-table-column v-if="columns[4].visible" label="开户行" align="center" prop="bankName" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.bankName }}</div>
					<span>{{ scope.row.bankName }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
		<el-table-column v-if="columns[5].visible" label="余额" align="right" prop="sumMoney" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.sumMoney }}</div>
					<span style="text-align: right; display: block;">{{ scope.row.sumMoney }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
			<el-table-column label="排序操作" align="center" width="200" fixed="right">
				<template #default="scope">
					<el-input v-model="scope.row.sort" size="mini" style="width: 50px; margin-right: 10px" placeholder="序号" @input="val => handleSortInput(scope.row, val)"></el-input>
					<el-button size="mini" type="primary" icon="el-icon-check" @click="handleSaveSort(scope.row)">保存</el-button>
				</template>
			</el-table-column>
			</el-table>
		</div>

		<!-- 分页组件 -->
		<div class="pagination-wrapper">
			<pagination
				:total="total"
				:page.sync="queryParams.pageNum"
				:limit.sync="queryParams.pageSize"
				:page-sizes="[10, 20, 50, 100, 200, 500]"
				layout="total, sizes, prev, pager, next, jumper"
				background
				@pagination="handlePagination"
			/>
		</div>
	</div>
</template>

<script>
import { listCompany } from '@/api/system/company';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { listBankAccount, listBankAccountSelf, updateBankAccountSort } from '../../../api/system/bankAccount';

export default {
	name: 'SelfMoney',
	mixins: [mixin_printHTML],
	data() {
		// 获取当前日期，格式化为 yyyy-MM-dd
		const getCurrentDateTime = () => {
			const now = new Date();
			const year = now.getFullYear();
			const month = String(now.getMonth() + 1).padStart(2, '0');
			const day = String(now.getDate()).padStart(2, '0');
			return `${year}-${month}-${day}`;
		};

		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			bankAccountList: [],
			title: '',
			open: false,
			queryParams: {
				endDate: getCurrentDateTime(), // 默认为当前时间
				bankCardType: null,
				bankName: null,
				acountsName: null,
				bankNo: null,
				displayName: null,
				pageNum: 1,
				pageSize: 20
			},
			// 筛选后的完整数据列表（用于分页）
			filteredList: [],
			// 表单参数
			form: {
				bankNo: '',
				bankName: '',
				acountsName: '',
				companyName: '',
				acountsType: ''
			},
			columns: [
				{ key: 0, label: `排序序号`, visible: true },
				{ key: 1, label: `己方公司`, visible: true },
				{ key: 2, label: `开户名称`, visible: true },
				{ key: 3, label: `银行账号`, visible: true },
				{ key: 4, label: `开户行`, visible: true },
				{ key: 5, label: `余额`, visible: true }
			],
			// 排序选择
			options: [
				{
					value: '1',
					label: '升序'
				},
				{
					value: '2',
					label: '降序'
				}
			],
			// 银行卡账户类型的筛选
			typeOption: [
				{
					value: '银行活期存款',
					label: '银行活期存款'
				},
				{
					value: '承兑',
					label: '承兑'
				}
			],
			// 升序和降序的值 - 从localStorage读取排序状态
			value: localStorage.getItem('selfMoneySort') || '',
			// 银行账户类型
			type: '',
			// 窗口大小变化防抖定时器
			resizeTimer: null
		};
	},
	computed: {},
	watch: {
		// 监听value并保存排序状态
		value: {
			handler(value) {
				// 保存排序状态到localStorage
				if (value) {
					localStorage.setItem('selfMoneySort', value);
				} else {
					localStorage.removeItem('selfMoneySort');
				}

				// 应用排序
				this.applySort();
				// 排序后重新应用分页
				this.applyPagination();
			}
		}
	},
	created() {
		this.getList();
		// 监听窗口大小变化，重新计算表格高度
		window.addEventListener('resize', this.handleResize);
	},
	beforeDestroy() {
		// 移除窗口大小变化监听
		window.removeEventListener('resize', this.handleResize);
		// 清理定时器
		if (this.resizeTimer) {
			clearTimeout(this.resizeTimer);
			this.resizeTimer = null;
		}
	},
	methods: {
		listBankAccount,
		listCompany,
		updateBankAccountSort,
		// 处理窗口大小变化
		handleResize() {
			// 使用防抖，避免频繁触发
			if (this.resizeTimer) {
				clearTimeout(this.resizeTimer);
			}
			this.resizeTimer = setTimeout(() => {
				// 强制更新表格布局，确保表头正确显示
				this.$nextTick(() => {
					if (this.$refs.table) {
						this.$refs.table.doLayout();
					}
				});
			}, 100);
		},
		// 获取当前日期的方法
		getCurrentDateTime() {
			const now = new Date();
			const year = now.getFullYear();
			const month = String(now.getMonth() + 1).padStart(2, '0');
			const day = String(now.getDate()).padStart(2, '0');
			return `${year}-${month}-${day}`;
		},
		getList() {
			this.loading = true;
			// 构建API查询参数，只传递有值的参数
			const apiParams = {};
			if (this.queryParams.endDate) {
				apiParams.endDate = this.queryParams.endDate;
			}

			listBankAccountSelf(apiParams)
				.then(response => {
					// 存储原始数据到本地，用于前端筛选
					const originalData = response.data || [];
					localStorage.setItem('bankAccountList', JSON.stringify(originalData));
					
					// 应用前端筛选
					this.applyFrontendFilter();
					
					// 应用保存的排序
					this.applySort();
					
					// 应用分页
					this.applyPagination();
				})
				.catch(error => {
					console.error('查询银行账户列表失败:', error);
					this.$message.error('查询失败，请重试');
					this.bankAccountList = [];
					this.filteredList = [];
					this.total = 0;
				})
				.finally(() => {
					this.loading = false;
				});
		},
		// 应用当前排序
		applySort() {
			if (this.value === '1') {
				this.filteredList.sort(function (a, b) {
					return a.sort - b.sort;
				});
			} else if (this.value === '2') {
				this.filteredList.sort(function (a, b) {
					return b.sort - a.sort;
				});
			}
		},
		// 银行卡筛选 - 主要查询方法
		handleQuery() {
			// 重置到第一页
			this.queryParams.pageNum = 1;
			// 当有endDate参数变化时，重新调用API获取数据
			this.getList();
		},
		// 前端筛选方法 - 对已获取的数据进行筛选
		applyFrontendFilter() {
			// 从本地存储获取原始数据
			const originalData = JSON.parse(localStorage.getItem('bankAccountList') || '[]');

			// 构建前端筛选参数（排除endDate，因为它用于API查询）
			const frontendParams = {
				bankCardType: this.queryParams.bankCardType,
				bankName: this.queryParams.bankName,
				acountsName: this.queryParams.acountsName,
				bankNo: this.queryParams.bankNo,
				displayName: this.queryParams.displayName
			};

			// 检查是否有前端筛选条件
			const hasFilterConditions = Object.values(frontendParams).some(value => value !== null && value !== '');

			if (!hasFilterConditions) {
				// 没有筛选条件，显示所有数据
				this.filteredList = [...originalData];
			} else {
				// 应用前端筛选
				this.filteredList = originalData.filter(item => this.handleFilter(item, frontendParams));
			}
			
			// 更新总数
			this.total = this.filteredList.length;
			
			// 如果当前页超出范围，重置到第一页
			const maxPage = Math.ceil(this.total / this.queryParams.pageSize) || 1;
			if (this.queryParams.pageNum > maxPage) {
				this.queryParams.pageNum = 1;
			}
		},
		// 应用分页
		applyPagination() {
			// 如果当前页超出范围，重置到第一页
			const maxPage = Math.ceil(this.total / this.queryParams.pageSize) || 1;
			if (this.queryParams.pageNum > maxPage && maxPage > 0) {
				this.queryParams.pageNum = 1;
			}
    const start = (this.queryParams.pageNum - 1) * this.queryParams.pageSize;
    const end = start + this.queryParams.pageSize;
    this.bankAccountList = this.filteredList.slice(start, end);
  },
		// 分页变化处理
		handlePagination({ page, limit }) {
			// 由于使用了 .sync，pageNum 和 pageSize 已经自动更新
			// 但我们需要确保页码在有效范围内
			if (limit !== undefined && limit !== this.queryParams.pageSize) {
				this.queryParams.pageSize = limit;
			}
			if (page !== undefined && page !== this.queryParams.pageNum) {
				this.queryParams.pageNum = page;
			}
			
			// 如果当前页超出范围，重置到第一页
			const maxPage = Math.ceil(this.total / this.queryParams.pageSize) || 1;
			if (this.queryParams.pageNum > maxPage && maxPage > 0) {
				this.queryParams.pageNum = 1;
			}
			
			// 重新应用分页
			this.applyPagination();
		},
		// 筛选函数
		handleFilter(item, filterParams = null) {
			// 如果没有传入筛选参数，使用queryParams（排除endDate）
			const params = filterParams || {
				bankCardType: this.queryParams.bankCardType,
				bankName: this.queryParams.bankName,
				acountsName: this.queryParams.acountsName,
				bankNo: this.queryParams.bankNo,
				displayName: this.queryParams.displayName
			};

			let flag = true;
			Object.keys(params).forEach(key => {
				if (item[key] && params[key]) {
					if (item[key].indexOf(params[key]) === -1) {
						flag = false;
					}
				}
			});
			return flag;
		},
		/** 重置按钮操作 */
		resetQuery() {
			// 保存当前排序状态
			const currentSort = this.value;

			// 重置查询参数
			this.queryParams = {
				endDate: this.getCurrentDateTime(), // 重置为当前时间
				bankCardType: null,
				bankName: null,
				acountsName: null,
				bankNo: null,
				displayName: null,
				pageNum: 1,
				pageSize: 20
			};

			this.getList();
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download('system/bankAccount/exportSelfMoneySummary?endDate=' + (this.queryParams.endDate ? this.queryParams.endDate : ''), null, `selfMoneySummary_${new Date().getTime()}.xlsx`);
		},
		/**
		 * 处理排序序号输入，只允许输入数字
		 * @param {Object} row - 当前行数据
		 * @param {string|number} val - 输入值
		 */
		handleSortInput(row, val) {
			// 移除所有非数字字符
			const numericValue = String(val).replace(/[^\d]/g, '');
			// 如果输入为空，设置为 null；否则转换为数字
			row.sort = numericValue === '' ? null : Number(numericValue);
		},
		/**
		 * 保存排序序号
		 * @param {Object} row - 当前行数据
		 */
		handleSaveSort(row) {
			if (!row.bankAccountId) {
				this.$message.error('该行数据缺少ID，无法保存');
				return;
			}

			// 构建更新数据，只包含id和sort字段
			const updateData = {
				id: row.bankAccountId,
				sort: row.sort || 0
			};

			// 调用更新排序接口
			updateBankAccountSort(updateData)
				.then(() => {
					this.$message.success('排序序号保存成功');
					// 保存成功后，重新抓取数据
					this.getList();
				})
				.catch(error => {
					this.$message.error('排序序号保存失败：' + (error.message || '未知错误'));
					// 保存失败时，刷新列表恢复原值
					this.getList();
				});
		}
	}
};
</script>
<style scoped lang="scss">
// 统一的容器padding，确保各组件对齐
$container-padding: 20px;
$form-item-spacing: 20px; // 表单项之间的间距

.app-container {
	position: relative;
	overflow: visible;
	min-height: 100vh;
	padding: 20px $container-padding;
	background-color: #f5f7fa;
}

/* 固定搜索表单（如果显示） */
#top-search-form-item {
	position: sticky;
	top: 0;
	z-index: 102;
	background-color: #fff;
	padding: 15px $container-padding;
	margin: -20px (-$container-padding) 15px (-$container-padding);
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	border-bottom: 1px solid #ebeef5;

	::v-deep .el-form-item {
		margin-bottom: 10px;
		margin-right: $form-item-spacing;
		vertical-align: top;
	}

	::v-deep .el-form-item:last-child {
		margin-right: 0;
	}

	::v-deep .el-form-item__label {
		text-align: right;
		padding-right: 12px;
		width: 100px !important;
		line-height: 28px;
		font-weight: normal;
	}

	// 统一所有输入框宽度
	.form-input {
		width: 180px !important;
	}

	// 日期选择器宽度
	::v-deep .el-date-editor {
		width: 180px !important;
	}

	// 下拉选择框宽度
	::v-deep .el-select {
		width: 180px !important;
	}

	// 确保表单项垂直对齐
	::v-deep .el-form-item__content {
		line-height: 28px;
	}
}

.toolbar-wrapper {
	margin-bottom: 15px;
	padding: 0;
	background-color: transparent;
	width: 100%;

	.toolbar-left {
		padding: 0;
	}

	::v-deep .el-row {
		margin: 0 !important;
		display: flex;
		align-items: center;
	}

	::v-deep .el-col {
		padding: 0;
	}

	// 确保工具栏按钮对齐
	::v-deep .el-button,
	::v-deep .el-select {
		vertical-align: middle;
	}
}

// 表格容器样式
.table-container {
	position: relative;
	background-color: #fff;
	border-radius: 4px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
	overflow: hidden;
	padding: 0;

	.el-table {
		width: 100%;

		th {
			background-color: #f5f7fa;
			color: #909399;
			font-weight: 500;
			text-align: center;
			padding: 12px 10px;
		}

		td {
			padding: 8px 10px;
			font-size: 12px;
			color: #606266;
		}

		// 默认居中对齐
		.el-table-column--center {
			text-align: center;
		}

		// 右对齐列
		.el-table-column--right {
			text-align: right;
		}
	}

	// 确保余额列右对齐
	::v-deep .el-table__body-wrapper .el-table__body .el-table__row .el-table__cell.is-right {
		text-align: right !important;
	}

	::v-deep .el-table__header-wrapper .el-table__header .el-table__row .el-table__cell.is-right {
		text-align: right !important;
	}

	#printBox {
		position: relative;

		::v-deep .el-table__header-wrapper {
			position: sticky !important;
			top: 0 !important;
			z-index: 99 !important;
			background-color: #fff !important;
			box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05) !important;
		}

		::v-deep .el-table__header {
			position: relative;
		}

		::v-deep .el-table__body-wrapper {
			overflow-x: auto;
		}
	}
}

.pagination-wrapper {
	position: relative;
	margin-top: 10px;
	padding: 15px $container-padding;
	background-color: #fff;
	border-radius: 4px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
	text-align: right;
}

.pagination-wrapper ::v-deep .pagination-container {
	margin: 0;
	padding: 0;
}

// 响应式优化
@media screen and (max-width: 768px) {
	.app-container {
		padding: 0 10px;
	}

	#top-search-form-item {
		padding: 15px 10px;
		margin: 0 -10px 15px -10px;
	}

	.table-container {
		overflow-x: auto;
	}

	.pagination-wrapper {
		padding: 10px 10px;
	}
}

// 确保表格列对齐
::v-deep .el-table {
	.el-table__cell {
		padding: 8px 10px;
	}
}
</style>
