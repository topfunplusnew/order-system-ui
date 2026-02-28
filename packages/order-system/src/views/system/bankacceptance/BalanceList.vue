<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="日期" prop="operateDate">
				<el-date-picker v-model="queryParams.operateDate" type="date" placeholder="选择截止日期" value-format="yyyy-MM-dd" clearable />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table v-loading="loading" border :data="balanceList" size="mini" show-summary :summary-method="getSummaries">
			<el-table-column v-if="columns[0].visible" label="票号" align="center" prop="billNo" show-overflow-tooltip>
				<template #default="scope">
					<CheckTotal :row="scope.row" />
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="我方承兑账户" align="center" prop="billAccount" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="余额" align="center" prop="balance" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="开票日期" align="center" prop="issueDate" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="到期日期" align="center" prop="dueDate" show-overflow-tooltip />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<script>
import { listBankAcceptanceBalance } from '@/api/system/bankAcceptance';
import CheckTotal from '../../dashboard/components/bankacceptance/CheckTotal.vue';
import { Pagination } from '@order-system/ui-components';
import { add, round, bignumber } from 'mathjs';

export default {
	name: 'BankAcceptanceBalanceList',
	components: { CheckTotal, Pagination },
	data() {
		return {
			loading: false,
			showSearch: true,
			total: 0,
			balanceList: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				operateDate: ''
			},
			columns: [
				{ label: '票号', visible: true },
				{ label: '我方承兑账户', visible: true },
				{ label: '余额', visible: true },
				{ label: '开票日期', visible: true },
				{ label: '到期日期', visible: true }
			]
		};
	},
	created() {
		this.getList();
	},
	methods: {
		/** 查询票据余额列表 */
		getList() {
			this.loading = true;
			listBankAcceptanceBalance(this.queryParams).then(res => {
				this.balanceList = res.rows || [];
				this.total = res.total || 0;
				this.loading = false;
			});
		},
		/** 搜索 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置 */
		resetQuery() {
			this.queryParams = {
				pageNum: 1,
				pageSize: 20,
				operateDate: ''
			};
			this.$refs.queryForm?.resetFields();
			this.handleQuery();
		},
		/** 导出 */
		handleExport() {
			this.download('/system/bankAcceptance/exportBalance', { ...this.queryParams }, `票据余额表_${new Date().getTime()}.xlsx`);
		},
		/**
		 * 合计行计算（余额列）
		 * @param {Object} param - { columns, data }
		 * @returns {string[]}
		 */
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}
				if (column.property === 'balance') {
					const values = (data || []).map(item => Number(item.balance) || 0);
					const total = values.reduce((acc, val) => add(acc, bignumber(val)), bignumber(0));
					sums[index] = round(total, 2).toString();
				} else {
					sums[index] = '';
				}
			});
			return sums;
		}
	}
};
</script>
