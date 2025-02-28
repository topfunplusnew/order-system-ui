<template>
	<div class="app-container">
		<!-- 筛选框 -->
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="账户类型">
				<el-select v-model="queryParams.bankCardType" placeholder="账户类型" size="mini" clearable>
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
			<el-form-item label="显示名称" prop="displayName">
				<el-input v-model="queryParams.displayName" placeholder="请输入显示名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-select v-model="value" placeholder="余额排序" size="mini">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-col>

			<el-col>
				<right-toolbar :columns="columns" @queryTable="getList">
					<template #print>
						<el-col :span="1.5">
							<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
						</el-col>
					</template>
				</right-toolbar>
			</el-col>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="bankAccountList"
			height="450px"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
		>
			<el-table-column v-if="columns[0].visible" label="银行账号" align="center" prop="bankNo" show-overflow-tooltip>
				<template #default="scope">
					<div>
						<span style="color: red">[{{ scope.row.bankCardType }}]</span>
						{{ scope.row.bankNo }}
					</div>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="显示名称" align="center" prop="displayName" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="开户名称" align="center" prop="acountsName" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="开户行" align="center" prop="bankName" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="余额" align="center" prop="sumMoney" show-overflow-tooltip />
		</el-table>
	</div>
</template>

<script>
import { listCompany } from '@/api/system/company';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { listBankAccount, listBankAccountSelf } from '../../../api/system/bankAccount';

export default {
	name: 'BankAccount',
	mixins: [mixin_printHTML],
	data() {
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
				bankName: null,
				acountsName: null,
				bankNo: null,
				displayName: null
			},
			// 表单参数
			form: {
				bankNo: '',
				bankName: '',
				acountsName: '',
				companyName: '',
				acountsType: ''
			},
			columns: [
				{ key: 0, label: `银行账号`, visible: true },
				{ key: 1, label: `显示名称`, visible: true },
				{ key: 2, label: `开户名称`, visible: true },
				{ key: 3, label: `开户行`, visible: true },
				{ key: 4, label: `余额`, visible: true }
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
					value: '现金户',
					label: '现金户'
				},
				{
					value: '承兑',
					label: '承兑'
				}
			],
			// 升序和降序的值
			value: '',
			// 银行账户类型
			type: ''
		};
	},
	watch: {
		// 监听value
		value: {
			handler(value) {
				if (value === '1') {
					this.bankAccountList.sort(function (a, b) {
						return a.sumMoney - b.sumMoney;
					});
				} else {
					this.bankAccountList.sort(function (a, b) {
						return b.sumMoney - a.sumMoney;
					});
				}
			}
		}
	},
	created() {
		this.getList();
	},
	methods: {
		listBankAccount,
		listCompany,
		getList() {
			this.loading = true;
			listBankAccountSelf().then(response => {
				this.bankAccountList = response.data;
				// 存储到本地
				localStorage.setItem('bankAccountList', JSON.stringify(this.bankAccountList));
				this.total = response.data.length;
				this.loading = false;
			});
		},
		// 银行卡筛选
		handleQuery() {
			// 每次重新刷新数组后筛选
			this.bankAccountList = JSON.parse(localStorage.getItem('bankAccountList'));
			// 如果queryParams都是空 那么就返回全部数据
			const values = Object.values(this.queryParams);

			// 对每一个参数进行判断
			if (
				values.every(item => {
					return item === null || item === '';
				})
			) {
				return this.bankAccountList;
			}
			// 对银行卡列表进行筛选
			this.bankAccountList = this.bankAccountList.filter(item => this.handleFilter(item));
		},
		// 筛选函数
		handleFilter(item) {
			let flag = true;
			Object.keys(this.queryParams).forEach(key => {
				if (item[key] && this.queryParams[key]) {
					if (item[key].indexOf(this.queryParams[key]) === -1) {
						flag = false;
					}
				}
			});
			return flag;
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.getList();
			this.resetForm('queryForm');
			this.handleQuery();
		}
	}
};
</script>
<style scoped>
/* 整体容器样式 */
.app-container {
	padding: 20px;
	background-color: #f9f9f9;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* 筛选框样式 */
.el-form {
	background-color: #ffffff;
	padding: 15px;
	border-radius: 8px;
	box-shadow: 0 1px 6px rgba(0, 0, 0, 0.1);
	margin-bottom: 20px;
}

.el-form-item {
	margin-right: 15px;
}

/* 按钮样式 */
.el-button {
	font-size: 14px;
	border-radius: 6px;
	transition: background-color 0.3s;
}

.el-button:hover {
	background-color: #409eff;
	color: white;
}

/* 筛选框中的按钮样式 */
.el-button.icon-refresh {
	background-color: #67c23a;
}

.el-button.icon-refresh:hover {
	background-color: #52b233;
}

/* 表格样式 */
#printBox {
	background-color: #ffffff;
	border-radius: 8px;
	box-shadow: 0 1px 6px rgba(0, 0, 0, 0.1);
}

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

/* 搜索框外部的操作区域 */
.mb8 {
	margin-bottom: 20px;
}

/* 列表筛选 */
.el-select {
	width: 100%;
}

.el-select .el-input__inner {
	border-radius: 6px;
}

/* 自定义滚动条 */
.el-scrollbar__wrap {
	scrollbar-width: thin;
}

.el-scrollbar__wrap::-webkit-scrollbar {
	width: 6px;
}

.el-scrollbar__wrap::-webkit-scrollbar-thumb {
	background: #dcdfe6;
	border-radius: 10px;
}

.el-scrollbar__wrap::-webkit-scrollbar-thumb:hover {
	background: #c0c4cc;
}

.el-scrollbar__wrap::-webkit-scrollbar-track {
	background: #f5f5f5;
}
</style>
