<template>
	<div class="app-container">
		<!-- 筛选框 -->
		<el-form id="top-search-form-item" v-show="showSearch" v-fixed="{ position: 'top', zIndex: 1001, offset: 0 }" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="开始时间" prop="endDate">
				<el-date-picker v-model="queryParams.endDate" type="date" placeholder="选择开始时间" value-format="yyyy-MM-dd" size="mini" clearable></el-date-picker>
			</el-form-item>
			<el-form-item label="账户类型">
				<el-select v-model="queryParams.bankCardType" placeholder="账户类型" size="mini" clearable @keyup.enter.native="handleQuery">
					<el-option v-for="item in typeOption" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="开户名称" prop="acountsName">
				<el-input v-model="queryParams.acountsName" placeholder="请输入开户名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="开户行" prop="acountsName">
				<el-input v-model="queryParams.bankName" placeholder="请输入开户行" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="银行账号" prop="bankNo">
				<el-input v-model="queryParams.bankNo" placeholder="请输入银行账号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="己方公司" prop="displayName">
				<el-input v-model="queryParams.displayName" placeholder="请输入己方公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row v-fixed="{ position: 'top', zIndex: 1000, offset: toolbarOffset }">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #left>
					<el-row :gutter="10">
						<el-col :span="1.5">
							<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
						</el-col>
						<el-col :span="1.5">
							<el-select v-model="value" placeholder="余额排序" size="mini">
								<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
							</el-select>
						</el-col>
					</el-row>
				</template>
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			ref="table"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="bankAccountList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			:max-height="getTableHeight()"
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
		<el-table-column v-if="columns[5].visible" label="余额" align="center" prop="sumMoney" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.sumMoney }}</div>
					<span>{{ scope.row.sumMoney }}</span>
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

		<!-- 显示总条数 -->
		<div class="total-info" v-if="!loading">
			<span class="total-text">共 <strong>{{ total }}</strong> 条记录</span>
		</div>

		<div v-fixed="{ position: 'bottom', zIndex: 1000 }" class="pagination-wrapper">
			<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="handlePagination" />
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
	computed: {
		// 计算工具栏的偏移量
		toolbarOffset() {
			// 如果搜索表单显示，工具栏需要向下偏移搜索表单的高度
			return this.showSearch ? 60 : 0;
		}
	},
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
		// 计算表格高度
		getTableHeight() {
			// 根据窗口高度动态计算表格高度，减去固定元素占用的空间
			const searchFormHeight = this.showSearch ? 60 : 0; // 搜索表单高度
			const toolbarHeight = 50; // 工具栏高度
			const paginationHeight = 50; // 分页器高度
			const totalInfoHeight = 40; // 总条数显示高度
			const otherSpace = 20; // 其他间距
			const height = window.innerHeight - searchFormHeight - toolbarHeight - paginationHeight - totalInfoHeight - otherSpace;
			// 确保最小高度，避免表头不显示
			return Math.max(height, 200);
		},
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

			listBankAccountSelf(apiParams).then(response => {
				// 存储原始数据到本地，用于前端筛选
				const originalData = response.data || [];
				localStorage.setItem('bankAccountList', JSON.stringify(originalData));
				
				// 应用前端筛选
				this.applyFrontendFilter();
				
				// 应用保存的排序
				this.applySort();
				
				// 应用分页
				this.applyPagination();
				
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
<style scoped>
.el-table th {
	background-color: #f4f4f4;
	color: #333;
	font-weight: bold;
	text-align: center;
}

.el-table td {
	text-align: center;
	padding: 12px;
	font-size: 14px;
	color: #555;
}

.el-table .el-table-column--center {
	text-align: center;
}

/* Element UI 的 max-height 会自动处理表头固定 */
/* 确保表头在缩放时也能正确显示 */
#printBox {
	position: relative;
}

#printBox ::v-deep .el-table__header-wrapper {
	position: sticky !important;
	top: 0 !important;
	z-index: 99 !important;
	background-color: #fff !important;
}

#printBox ::v-deep .el-table__header {
	position: relative;
}

/* 总条数显示样式 */
.total-info {
	margin: 0;
	padding: 5px 0;
	text-align: left;
	border-top: 1px solid #ebeef5;
}

.total-text {
	font-size: 14px;
	color: #606266;
}

.total-text strong {
	color: #409eff;
	font-weight: 600;
	font-size: 16px;
}

/* 分页器容器样式 */
.pagination-wrapper {
	margin: 0;
	padding: 0;
}

/* 分页器组件样式 */
.pagination-wrapper ::v-deep .pagination-container {
	margin: 0;
	padding: 5px 0;
}
</style>
