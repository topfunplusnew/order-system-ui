<template>
	<div class="app-container">
		<!-- 查询表单 -->
		<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="付款方" prop="payerCompanyAccount">
				<el-input v-model="queryParams.payerCompanyAccount" placeholder="请输入付款方" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="收款方" prop="beneficiaryCompanyAccount">
				<el-input v-model="queryParams.beneficiaryCompanyAccount" placeholder="请输入收款方" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" @click="handleQuery" size="mini">查询</el-button>
				<el-button @click="reset" size="mini">刷新</el-button>
				<el-button type="success" @click="handleExport" size="mini">导出Excel</el-button>
			</el-form-item>
		</el-form>

		<el-divider>内部往来余额</el-divider>

		<!-- 工具栏 -->
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<!-- 不显示搜索按钮，减少误触 -->

				<!--			<right-toolbar :columns="columns" @queryTable="getList">-->
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<!-- 表格 -->
		<el-table id="printBox" v-loading="loading" border :data="tableData" size="mini" :cell-style="() => ({ padding: '1.5px' })">
			<el-table-column v-if="columns[0].visible" label="付款方" prop="payerCompanyAccount" align="center" />
			<el-table-column v-if="columns[1].visible" label="收款方" prop="beneficiaryCompanyAccount" align="center" />
			<el-table-column v-if="columns[2].visible" label="应收金额" prop="amountReceivable" align="center" />
		</el-table>

		<!-- 分页 -->
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';
import { getInternalFundsSummary, exportInternalFunds } from '@/api/system/transactionBalance';

export default {
	name: 'TransactionBalance',
	mixins: [mixin_printHTML, common_excel],
	data() {
		return {
			reqLock: false,
			loading: false,
			total: 0,
			tableData: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				payerCompanyAccount: '',
				beneficiaryCompanyAccount: ''
			},
			columns: [
				{ key: 0, label: '付款方', visible: true },
				{ key: 1, label: '收款方', visible: true },
				{ key: 2, label: '应收金额', visible: true }
			]
		};
	},

	created() {
		this.getList();
	},

	methods: {
		// 查询
		// 查询
		async getList() {
			if (this.reqLock) return; // ← 2. 防重入
			this.reqLock = true;
			this.loading = true;

			try {
				const res = await getInternalFundsSummary(this.queryParams);
				// console.log('接口返回数据:', res); //
				if (res.code === 200) {
					this.tableData = res.rows || [];
					this.total = res.total || 0;
				} else {
					this.$message.error(res.msg || '查询失败');
				}
			} catch (e) {
				console.error('查询接口错误:', e);
				this.$message.error('服务器异常，请稍后再试');
			} finally {
				this.loading = false;
				this.reqLock = false;
			}
		},
		// 搜索
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},

		// 重置
		reset() {
			this.queryParams = {
				pageNum: 1,
				pageSize: 20,
				payerCompanyAccount: '',
				beneficiaryCompanyAccount: ''
			};
			this.getList();
		},

		// 导出
		async handleExport() {
			try {
				const res = await exportInternalFunds(this.queryParams);
				const blob = new Blob([res], { type: 'application/vnd.ms-excel' });
				const url = window.URL.createObjectURL(blob);
				const link = document.createElement('a');
				link.href = url;
				link.download = '内部往来管理.xlsx';
				link.click();
				window.URL.revokeObjectURL(url);
			} catch (e) {
				console.error('导出失败:', e);
				this.$message.error('导出失败，请重试');
			}
		}
	}
};
</script>
