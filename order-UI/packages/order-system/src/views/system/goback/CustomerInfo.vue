<template>
	<div class="customer-info">
		<!-- 搜索区域 -->
		<div class="search-area">
			<el-form :inline="true" :model="searchForm" class="demo-form-inline" size="small">
				<el-form-item label="开始时间：">
					<el-date-picker v-model="searchForm.startTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd" size="small"></el-date-picker>
				</el-form-item>
				<el-form-item label="结束时间：">
					<el-date-picker v-model="searchForm.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd" size="small"></el-date-picker>
				</el-form-item>
				<el-form-item label="客户">
					<el-row>
						<el-col :span="4">
							<SearchOption
								:limit-info="{ companyType: PUBLIC_DICT_TYPE.CUSTOMER }"
								:get-data="listCompany"
								query-info="companyName"
								query-label="公司名称"
								:query-name="companyName"
								@update:queryName="handleUpdateCompanyName"
								@commitBack="handleCommitBackCompany"
							>
								<template #table-columns>
									<el-table-column :label="PUBLIC_DICT_TYPE.CUSTOMER" align="center" prop="companyName" />
									<el-table-column label="老板姓名" align="center" prop="leader" />
									<el-table-column label="老板电话" align="center" prop="leaderTel" />
									<el-table-column label="区域" align="center" prop="region" />
									<el-table-column label="销售经理" align="center" prop="salesManager" />
								</template>
							</SearchOption>
						</el-col>
						<el-col :span="20">
							<el-input v-model="searchForm.customer" placeholder="请输入客户" clearable size="small">
								<i slot="prefix" class="el-input__icon el-icon-search"></i>
							</el-input>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="handleSearch" size="small">查询</el-button>
					<el-button type="success" @click="handleExport" size="small">导出Excel</el-button>
				</el-form-item>
			</el-form>
		</div>

		<!-- 表格区域 -->
		<el-table :data="tableData" border style="width: 100%" v-loading="loading" size="small">
			<el-table-column prop="date" label="日期" width="120"></el-table-column>
			<el-table-column prop="name" label="名称" min-width="120"></el-table-column>
			<el-table-column prop="debtAmount" label="欠款明细" width="120">
				<template slot-scope="scope">
					<span :class="{ negative: scope.row.debtAmount < 0 }">{{ scope.row.debtAmount }}</span>
				</template>
			</el-table-column>
			<el-table-column prop="debtBalance" label="欠款金额" width="120">
				<template slot-scope="scope">
					<span :class="{ negative: scope.row.debtBalance < 0 }">{{ scope.row.debtBalance }}</span>
				</template>
			</el-table-column>
			<el-table-column prop="paymentBalance" label="汇款金额" width="120">
				<template slot-scope="scope">
					<span :class="{ negative: scope.row.paymentBalance < 0 }">{{ scope.row.paymentBalance }}</span>
				</template>
			</el-table-column>
			<el-table-column prop="balance" label="余额" width="120">
				<template slot-scope="scope">
					<span :class="{ negative: scope.row.balance < 0 }">{{ scope.row.balance }}</span>
				</template>
			</el-table-column>
		</el-table>

		<!-- 分页 -->
		<div class="pagination-container">
			<el-pagination
				@size-change="handleSizeChange"
				@current-change="handleCurrentChange"
				:current-page="currentPage"
				:page-sizes="[10, 20, 50, 100]"
				:page-size="pageSize"
				:total="total"
				layout="total, sizes, prev, pager, next, jumper"
				size="small"
			></el-pagination>
		</div>
	</div>
</template>

<script>
import SearchOption from '@/components/SearchOption.vue';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { listCompany } from '@/api/system/company';

export default {
	name: 'CustomerInfo',
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		}
	},
	components: { SearchOption },
	data() {
		return {
			loading: false,
			currentPage: 1,
			pageSize: 10,
			total: 0,
			searchForm: {
				startTime: '',
				endTime: '',
				customer: ''
			},
			companyName: null,
			tableData: [
				{
					date: '2025-02-16',
					name: '测试客户',
					debtAmount: -100,
					debtBalance: -100,
					paymentBalance: 200,
					balance: 100
				}
			]
		};
	},
	created() {
		this.handleSearch();
	},
	methods: {
		listCompany,
		// 查询方法
		handleSearch() {
			this.loading = true;

			this.loading = false;
		},
		handleUpdateCompanyName(value) {
			this.companyName = value;
		},
		handleCommitBackCompany(value) {
			this.searchForm.customer = value.companyName;
		},

		// 导出Excel
		handleExport() {
			// TODO: 实现导出功能
			this.$message.success('导出成功');
		},

		// 分页方法
		handleSizeChange(val) {
			this.pageSize = val;
			this.handleSearch();
		},

		handleCurrentChange(val) {
			this.currentPage = val;
			this.handleSearch();
		}
	}
};
</script>

<style scoped lang="scss">
.customer-info {
	padding: 15px;

	.search-area {
		margin-bottom: 15px;
		padding: 15px;
		background-color: #fff;
		border-radius: 4px;
	}

	.pagination-container {
		margin-top: 15px;
		display: flex;
		justify-content: flex-end;
	}

	.negative {
		color: red;
	}

	:deep(.el-form-item) {
		margin-bottom: 10px;
		margin-right: 10px;
	}

	:deep(.el-form-item__label) {
		padding-right: 8px;
	}
}
</style>
