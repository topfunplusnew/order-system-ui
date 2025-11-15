<template>
	<div class="SUPPLIER-total">
		<!-- 搜索区域 -->
		<div class="search-area">
			<el-form id="top-search-form-item" :inline="true" :model="searchForm" ref="form" :rules="rules" class="demo-form-inline" size="mini" label-width="150">
				<el-form-item label="时间：" prop="endTime">
					<el-date-picker clearable v-model="searchForm.endTime" type="date" placeholder="请选择时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
				<el-form-item label="供应商" prop="supplier">
					<el-row>
						<el-col :span="4">
							<SearchOption
								:limit-info="{ companyType: PUBLIC_DICT_TYPE.SUPPLIER }"
								:get-data="listCompany"
								query-info="companyName"
								query-label="公司名称"
								:query-name="companyName"
								@update:queryName="handleUpdateCompanyName"
								@commitBack="handleCommitBackCompany"
							>
								<template #table-columns>
									<el-table-column :label="PUBLIC_DICT_TYPE.SUPPLIER" align="center" prop="companyName" />
									<el-table-column label="老板姓名" align="center" prop="leader" />
									<el-table-column label="老板电话" align="center" prop="leaderTel" />
									<el-table-column label="区域" align="center" prop="region" />
									<el-table-column label="销售经理" align="center" prop="salesManager" />
								</template>
							</SearchOption>
						</el-col>
						<el-col :span="20">
							<el-input disabled clearable @keyup.enter.native="getList" v-model="searchForm.supplier" placeholder="请选择供应商" size="mini">
								<i slot="prefix" class="el-input__icon el-icon-search"></i>
							</el-input>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="类型：" prop="creditType">
					<el-select clearable @keyup.enter.native="getList" v-model="searchForm.creditType" placeholder="请选择类型" size="mini" style="width: 100px">
						<el-option label="借" value="借"></el-option>
						<el-option label="贷" value="贷"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="余额：" prop="balanceCompare">
					<el-select clearable @keyup.enter.native="getList" v-model="searchForm.balanceCompare" placeholder="请选择" style="width: 80px" size="mini">
						<el-option label="≥" value="ge"></el-option>
						<el-option label="≤" value="le"></el-option>
						<el-option label="=" value="eq"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item prop="balanceValue">
					<el-input clearable @keyup.enter.native="getList" v-model="searchForm.balanceValue" placeholder="请输入余额" size="mini" style="width: 120px; margin-left: 5px" @blur="validateBalance"></el-input>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="getList" size="mini">查询</el-button>
					<el-button @click="reset" size="mini">刷新</el-button>
					<el-button type="success" @click="excelExport(['查看供应商信息'])" size="mini">导出Excel</el-button>
				</el-form-item>
			</el-form>
		</div>

		<!-- 表格区域 -->
		<el-table id="educe-table" :data="tableData" border style="width: 100%" v-loading="loading" size="mini">
			<el-table-column prop="time" label="日期" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.time }}</div>
						<span>{{ scope.row.time }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column prop="companyName" label="供应商" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.companyName }}</div>
						<span>{{ scope.row.companyName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column prop="moneyAmount" label="余额" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">
							<span :class="{ negative: scope.row.moneyAmount < 0 }">
								{{ formatBalance(scope.row.moneyAmount) }}
							</span>
						</div>
						<span :class="{ negative: scope.row.moneyAmount < 0 }">
							{{ formatBalance(scope.row.moneyAmount) }}
						</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="查看供应商信息" align="center">
				<template slot-scope="scope">
					<el-link :underline="false" type="primary" @click="handleViewSUPPLIERInfo(scope.row.companyId)">查看</el-link>
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<script>
import { QueryCustomer } from '@/api/system/goback';
import { parseTime } from '@/utils/ruoyi';
import SearchOption from '@/components/SearchOption.vue';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { getCompany, listCompany } from '@/api/system/company';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import COMPANY from '@/components/NeedToShow/COMPANY.vue';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';
import { formatBalance } from '@/utils/trash/utils';

export default {
	name: 'SUPPLIERTotal',
	mixins: [common_dialog, common_excel],
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
			pageSize: 20,
			total: 0,
			searchForm: {
				endTime: parseTime(new Date(), '{y}-{m}-{d}'),
				supplier: null,
				companyId: '',
				balanceCompare: '',
				balanceValue: '',
				creditType: ''
			},
			tableData: [],
			companyName: null,
			rules: {
				endTime: [{ required: true, message: '请选择时间', trigger: 'blur' }],
				balanceValue: [
					{
						validator: (rule, value, callback) => {
							if (value && parseFloat(value) < 0) {
								callback(new Error('余额不能为负数'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				]
			}
		};
	},
	created() {
		this.getList();
	},
	methods: {
		formatBalance,
		listCompany,
		// 查询方法
		getList() {
			this.$refs['form']?.validate(valid => {
				if (valid) {
					this.loading = true;
					const querySupplier = new QueryCustomer();
					querySupplier.getSupplierBalance(this.searchForm).then(res => {
						if (!res.rows && !res.data) {
							this.$message.warning('当前搜索条件下，无相关信息');
							this.loading = false;
							return;
						}
						this.tableData = res.rows || res.data;
						// this.total = res.total;
						this.loading = false;
					});
				}
			});
		},
		reset() {
			Object.assign(this.searchForm, {
				endTime: parseTime(new Date(), '{y}-{m}-{d}'),
				supplier: null,
				companyId: '',
				balanceCompare: '',
				balanceValue: '',
				creditType: ''
			});
			this.tableData = [];
		},
		handleCommitBackCompany(value) {
			this.searchForm.companyId = value.id;
			this.searchForm.supplier = value.companyName;
		},
		handleUpdateCompanyName(value) {
			this.companyName = value;
		},
		// 查看供应商信息
		handleViewSUPPLIERInfo(id) {
			getCompany(id, PUBLIC_DICT_TYPE.SUPPLIER).then(res => {
				if (!res.data && !res.rows) {
					this.$message.warning('当前搜索条件下，无相关信息');
					return;
				}
				this.openDialog(
					COMPANY,
					'供应商信息',
					'800px',
					{
						needToShowInfo: res.data || res.rows[0]
					},
					false
				);
			});
		},
		validateBalance() {
			this.$refs.form.validateField('balanceValue');
		}
	}
};
</script>

<style scoped lang="scss">
.SUPPLIER-total {
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
