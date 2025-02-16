<template>
	<div class="supplier-info">
		<!-- 搜索区域 -->
		<div class="search-area">
			<el-form :inline="true" :model="searchForm" class="demo-form-inline" size="small">
				<el-form-item label="开始时间：">
					<el-date-picker v-model="searchForm.startTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd" size="small"></el-date-picker>
				</el-form-item>
				<el-form-item label="结束时间：">
					<el-date-picker v-model="searchForm.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd" size="small"></el-date-picker>
				</el-form-item>
				<el-form-item label="供应商：">
					<el-input v-model="searchForm.supplier" placeholder="请输入供应商" clearable size="small">
						<i slot="prefix" class="el-input__icon el-icon-search"></i>
					</el-input>
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
			<el-table-column prop="transactionDetail" label="交易明细" width="120">
				<template slot-scope="scope">
					<span :class="{ negative: scope.row.transactionDetail < 0 }">{{ scope.row.transactionDetail }}</span>
				</template>
			</el-table-column>
			<el-table-column prop="debtBalance" label="欠款余额" width="120">
				<template slot-scope="scope">
					<span :class="{ negative: scope.row.debtBalance < 0 }">{{ scope.row.debtBalance }}</span>
				</template>
			</el-table-column>
			<el-table-column prop="paymentBalance" label="正欠余额" width="120">
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
export default {
	name: 'SupplierInfo',
	data() {
		return {
			loading: false,
			currentPage: 1,
			pageSize: 10,
			total: 0,
			searchForm: {
				startTime: '',
				endTime: '',
				supplier: ''
			},
			tableData: [
				{
					date: '2025-02-16',
					name: '供应商A',
					transactionDetail: -1000,
					debtBalance: -1000,
					paymentBalance: 2000,
					balance: 1000
				}
			]
		};
	},
	methods: {
		// 查询方法
		handleSearch() {
			this.loading = true;
			// TODO: 调用接口获取数据
			setTimeout(() => {
				this.loading = false;
			}, 500);
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
.supplier-info {
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
