<!-- 银行卡搜索组件 -->
<template>
	<div class="bank-search-container">
		<el-form :model="queryBankInfo" :label-width="formLabelWidth">
			<el-row :gutter="4">
				<el-col :span="8">
					<el-form-item label="账号类型">
						<el-select v-model="queryBankInfo.acountsType" placeholder="请选择">
							<el-option v-for="item in acountsTypeList" :key="item.value" :label="item.label" :value="item.value" />
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="8">
					<el-form-item label="账户名">
						<el-input v-model="queryBankInfo.acountsName" autocomplete="off" placeholder="请输入账户名" @input="handleInputTrim" />
					</el-form-item>
				</el-col>
				<el-col :span="3">
					<el-button type="primary" @click="handleSearch">搜索</el-button>
				</el-col>
			</el-row>
		</el-form>

		<el-row>
			<el-table v-loading="loading" :data="bankInfo" class="table-container">
				<el-table-column label="银行卡号" align="center" prop="bankNo" />
				<el-table-column label="账户类型" align="center" prop="acountsType" />
				<el-table-column label="账户名" align="center" prop="acountsName" />
				<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
					<template slot-scope="scope">
						<el-button type="danger" @click="handleAddBank(scope.row)" size="mini">添加该银行卡</el-button>
					</template>
				</el-table-column>
			</el-table>
		</el-row>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="handleSearch" />
	</div>
</template>

<script>
import { listBankAccount } from '@/api/system/bankAccount';

export default {
	name: 'BankSearch',
	props: {
		// 当前公司信息
		companyInfo: {
			type: Object,
			default: () => ({})
		}
	},
	data() {
		return {
			loading: false,
			formLabelWidth: '140px',
			queryBankInfo: {
				acountsType: '',
				acountsName: ''
			},
			queryParams: {
				pageNum: 1,
				pageSize: 20
			},
			bankInfo: [],
			total: 0,
			// 账户类型列表
			acountsTypeList: [
				{ value: '己方公司', label: '己方公司' },
				{ value: '客户', label: '客户' },
				{ value: '供应商', label: '供应商' },
				{ value: '司机', label: '司机' },
				{ value: '其他', label: '其他' }
			]
		};
	},
	methods: {
		handleProcess() {},
		handleReject() {},
		/**
		 * 搜索银行卡信息
		 */
		handleSearch() {
			this.loading = true;
			const params = {
				...this.queryBankInfo,
				...this.queryParams
			};

			listBankAccount(params)
				.then(response => {
					this.bankInfo = response.rows;
					this.total = response.total;
					this.loading = false;
				})
				.catch(() => {
					this.loading = false;
				});
		},

		/**
		 * 添加银行卡
		 * @param {Object} row 银行卡信息
		 */
		handleAddBank(row) {
			// 验证账户名是否匹配
			if (this.companyInfo.relationName !== row.acountsName) {
				this.$message.error('不允许添加非己银行卡!');
				return;
			}

			// 触发添加事件
			this.$emit('add-bank', {
				...row,
				companyInfo: this.companyInfo
			});
		},

		/**
		 * 处理输入框去空格
		 * @param {String} value 输入值
		 */
		handleInputTrim(value) {
			if (value.indexOf(' ') !== -1) {
				this.queryBankInfo.acountsName = value.replace(/\s+/g, '');
			}
		}
	},

	created() {
		// 组件创建后自动搜索
		this.handleSearch();
	}
};
</script>

<style scoped>
.bank-search-container {
	padding: 10px;
}

.table-container {
	background-color: #fff;
	border-radius: 5px;
	padding: 10px;
	margin-top: 15px;
}
</style>
