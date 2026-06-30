<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="日期" prop="dateRange">
				<el-date-picker v-model="queryParams.dateRange" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" style="width: 240px" />
			</el-form-item>
			<el-form-item label="我方户名" prop="selfAccountName">
				<el-input v-model="queryParams.selfAccountName" placeholder="请输入我方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方公司" prop="otherCompanyName">
				<el-input v-model="queryParams.otherCompanyName" placeholder="请输入对方公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAccountName">
				<el-input v-model="queryParams.otherAccountName" placeholder="请输入对方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" table-name="views-system-statement-payment-report-columns">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport">导出</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" border :data="tableData" size="mini" :cell-style="() => ({ padding: '1.5px' })">
			<el-table-column type="index" label="序号" width="60" align="center" :index="indexMethod" />
			<el-table-column v-if="columns[0].visible" label="来源" align="center" prop="source" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="日期" align="center" width="120" show-overflow-tooltip>
				<template #default="{ row }">{{ getReportDate(row) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="支出类型" align="center" prop="businessType" width="140" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="对方公司名称" align="center" prop="otherCompanyName" width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="对方公司类型" align="center" prop="otherCompanyType" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="金额" align="center" prop="amount" width="120" show-overflow-tooltip>
				<template #default="{ row }">{{ formatAmount(row.amount) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="我方户名" align="center" prop="selfAccountName" width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="我方账号" align="center" prop="selfBankNo" width="180" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="我方开户行" align="center" prop="selfBankName" width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="我方账户类型" align="center" prop="selfBankCardType" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[10].visible" label="对方户名" align="center" prop="otherAccountName" width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[11].visible" label="对方账号" align="center" prop="otherBankNo" width="180" show-overflow-tooltip />
			<el-table-column v-if="columns[12].visible" label="对方开户行" align="center" prop="otherBankName" width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[13].visible" label="备注" align="center" prop="comments" width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[14].visible" label="银行卡流水编号" align="center" prop="bankFlowNo" width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[15].visible" label="录入人员" align="center" prop="createByName" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[16].visible" label="新增时间" align="center" prop="createTime" width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[17].visible" label="最后修改时间" align="center" prop="updateTime" width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[18].visible" label="最后修改人员" align="center" prop="updateByName" width="100" show-overflow-tooltip />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<script>
import { getPaymentReport } from '@/api/system/statement';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import financeReportMixin from '@/views/system/Statement/FinanceReport.mixin';
import { createPaymentReportColumns } from '@/views/system/Statement/FinanceReport.config';

export default {
	name: 'PaymentReport',
	mixins: [mixin_printHTML, financeReportMixin],
	data() {
		return {
			reportType: 'payment',
			columns: createPaymentReportColumns()
		};
	},
	methods: {
		/**
		 * 查询付款报表
		 * @param {Object} query
		 * @returns {Promise}
		 */
		fetchReportList(query) {
			return getPaymentReport(query);
		}
	}
};
</script>
