<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="queryParams.beginTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd" clearable />
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd" clearable />
			</el-form-item>
			<el-form-item label="客户名称" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入客户名称" clearable />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">客户佣金台账</el-row>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="tableData"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
		>
			<el-table-column show-overflow-tooltip label="科目编码" align="center" prop="subjectNo" width="140" />
		</el-table>
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';

export default {
	name: 'CustomerCommission',
	mixins: [mixin_printHTML],
	data() {
		return {
			queryParams: {
				beginTime: '',
				endTime: '',
				companyName: ''
			},
			columns: [],
			loading: false,
			tableData: []
		};
	},
	methods: {
		handleQuery() {},
		getList() {},
		refresh() {}
	}
};
</script>
