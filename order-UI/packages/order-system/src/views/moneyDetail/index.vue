<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="80px">
			<el-form-item label="开始日期" prop="startDate">
				<el-date-picker v-model="queryParams.startDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择开始日期" style="width: 200px" />
			</el-form-item>
			<el-form-item label="结束日期" prop="endDate">
				<el-date-picker v-model="queryParams.endDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择结束日期" style="width: 200px" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<right-toolbar :showSearch.sync="showSearch" @queryTable="getList">
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport">导出</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table v-loading="loading" :data="moneyDetailList" border size="mini" style="margin-top: 10px">
			<el-table-column label="序号" type="index" width="60" align="center" show-overflow-tooltip />
			<el-table-column label="支付日期" prop="paymentDate" align="center" show-overflow-tooltip />
			<el-table-column label="支付类型" prop="paymentType" align="center" show-overflow-tooltip />
			<el-table-column label="支付金额" prop="paymentAmount" align="center" show-overflow-tooltip />
			<el-table-column label="对方公司" prop="otherCompany" align="center" show-overflow-tooltip />
			<el-table-column label="对方账号" prop="otherAccountNo" align="center" show-overflow-tooltip />
			<el-table-column label="对方开户行" prop="otherBankName" align="center" show-overflow-tooltip />
			<el-table-column label="己方户名" prop="selfAccountName" align="center" show-overflow-tooltip />
			<el-table-column label="己方账号" prop="selfAccountNo" align="center" show-overflow-tooltip />
			<el-table-column label="己方开户行" prop="selfBankName" align="center" show-overflow-tooltip />
			<el-table-column label="支付状态" prop="paymentStatus" align="center" show-overflow-tooltip />
			<el-table-column label="对方公司类型" prop="otherCompanyType" align="center" show-overflow-tooltip />
			<el-table-column label="备注" prop="remarks" align="center" show-overflow-tooltip />
		</el-table>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<script>
import { listMoneyDetail } from '@/api/moneyDetail';
import rightToolbar from '@/components/RightToolbar';
export default {
	name: 'MoneyDetail',
	components: { rightToolbar },
	data() {
		return {
			loading: false,
			total: 0,
			moneyDetailList: [],
			showSearch: true,
			queryParams: {
				startDate: '',
				endDate: '',
				pageNum: 1,
				pageSize: 10
			}
		};
	},
	created() {
		this.initDefaultDate();
		this.getList();
	},
	methods: {
		initDefaultDate() {
			// 默认今天
			const today = new Date();
			const yyyy = today.getFullYear();
			const mm = String(today.getMonth() + 1).padStart(2, '0');
			const dd = String(today.getDate()).padStart(2, '0');
			this.queryParams.startDate = `${yyyy}-${mm}-${dd} 00:00:00`;
			this.queryParams.endDate = `${yyyy}-${mm}-${dd} 23:00:00`;
		},
		getList() {
			this.loading = true;
			listMoneyDetail(this.queryParams)
				.then(res => {
					this.moneyDetailList = res.rows || [];
					this.total = res.total || 0;
					this.loading = false;
				})
				.catch(() => {
					this.loading = false;
				});
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.initDefaultDate();
			this.queryParams.pageNum = 1;
			this.queryParams.pageSize = 10;
			this.getList();
		},
		handleExport() {
			this.download('/system/expenseDetail/export', { ...this.queryParams }, `费用明细表_${new Date().getTime()}.xlsx`);
		}
	}
};
</script>
