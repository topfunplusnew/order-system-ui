<template>
	<div class="app-container">
		<!-- 筛选框 -->
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="开始时间" prop="endDate">
				<el-date-picker
					v-model="queryParams.endDate"
					type="datetime"
					placeholder="选择开始时间"
					value-format="yyyy-MM-dd HH:mm:ss"
					size="mini"
					clearable
					@change="handleQuery"
				></el-date-picker>
			</el-form-item>
			<el-form-item label="账户类型">
				<el-select v-model="queryParams.bankCardType" placeholder="账户类型" size="mini" clearable @change="applyFrontendFilter">
					<el-option v-for="item in typeOption" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="开户名称" prop="acountsName">
				<el-input v-model="queryParams.acountsName" placeholder="请输入开户名称" clearable @keyup.enter.native="applyFrontendFilter" @input="applyFrontendFilter" />
			</el-form-item>
			<el-form-item label="开户行" prop="acountsName">
				<el-input v-model="queryParams.bankName" placeholder="请输入开户行" clearable @keyup.enter.native="applyFrontendFilter" @input="applyFrontendFilter" />
			</el-form-item>
			<el-form-item label="银行账号" prop="bankNo">
				<el-input v-model="queryParams.bankNo" placeholder="请输入银行账号" clearable @keyup.enter.native="applyFrontendFilter" @input="applyFrontendFilter" />
			</el-form-item>
			<el-form-item label="己方公司" prop="displayName">
				<el-input v-model="queryParams.displayName" placeholder="请输入己方公司" clearable @keyup.enter.native="applyFrontendFilter" @input="applyFrontendFilter" />
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
					<template #export>
						<el-col :span="1.5">
							<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
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
			<el-table-column v-if="columns[1].visible" label="己方公司" align="center" prop="displayName" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="开户名称" align="center" prop="acountsName" show-overflow-tooltip />
			<el-table-column v-if="columns[0].visible" label="银行账号" align="center" prop="bankNo" show-overflow-tooltip>
				<template #default="scope">
					<div>
						<span style="color: red">[{{ scope.row.bankCardType }}]</span>
						{{ scope.row.bankNo }}
					</div>
				</template>
			</el-table-column>
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
	name: 'SelfMoney',
	mixins: [mixin_printHTML],
	data() {
		// 获取当前时间，格式化为 yyyy-MM-dd HH:mm:ss
		const getCurrentDateTime = () => {
			const now = new Date();
			const year = now.getFullYear();
			const month = String(now.getMonth() + 1).padStart(2, '0');
			const day = String(now.getDate()).padStart(2, '0');
			const hours = String(now.getHours()).padStart(2, '0');
			const minutes = String(now.getMinutes()).padStart(2, '0');
			const seconds = String(now.getSeconds()).padStart(2, '0');
			return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
		};

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
				endDate: getCurrentDateTime(), // 默认为当前时间
				bankCardType: null,
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
				{ key: 1, label: `己方公司`, visible: true },
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
					value: '银行活期存款',
					label: '银行活期存款'
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
			// 构建API查询参数，只传递有值的参数
			const apiParams = {};
			if (this.queryParams.endDate) {
				apiParams.endDate = this.queryParams.endDate;
			}

			listBankAccountSelf(apiParams).then(response => {
				this.bankAccountList = response.data;
				// 存储到本地，用于前端筛选
				localStorage.setItem('bankAccountList', JSON.stringify(this.bankAccountList));
				// 应用前端筛选
				this.applyFrontendFilter();
				this.total = this.bankAccountList.length;
				this.loading = false;
			});
		},
		// 银行卡筛选 - 主要查询方法
		handleQuery() {
			// 当有endDate参数变化时，重新调用API获取数据
			this.getList();
		},
		// 前端筛选方法 - 对已获取的数据进行筛选
		applyFrontendFilter() {
			// 从本地存储获取原始数据
			const originalData = JSON.parse(localStorage.getItem('bankAccountList') || '[]');

			// 构建前端筛选参数（排除endDate，因为它用于API查询）
			const frontendParams = {
				bankCardType: this.queryParams.bankCardType,
				bankName: this.queryParams.bankName,
				acountsName: this.queryParams.acountsName,
				bankNo: this.queryParams.bankNo,
				displayName: this.queryParams.displayName
			};

			// 检查是否有前端筛选条件
			const hasFilterConditions = Object.values(frontendParams).some(value => value !== null && value !== '');

			if (!hasFilterConditions) {
				// 没有筛选条件，显示所有数据
				this.bankAccountList = originalData;
			} else {
				// 应用前端筛选
				this.bankAccountList = originalData.filter(item => this.handleFilter(item, frontendParams));
			}
		},
		// 筛选函数
		handleFilter(item, filterParams = null) {
			// 如果没有传入筛选参数，使用queryParams（排除endDate）
			const params = filterParams || {
				bankCardType: this.queryParams.bankCardType,
				bankName: this.queryParams.bankName,
				acountsName: this.queryParams.acountsName,
				bankNo: this.queryParams.bankNo,
				displayName: this.queryParams.displayName
			};

			let flag = true;
			Object.keys(params).forEach(key => {
				if (item[key] && params[key]) {
					if (item[key].indexOf(params[key]) === -1) {
						flag = false;
					}
				}
			});
			return flag;
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.getList();
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download('system/bankAccount/exportSelfMoneySummary?endDate=' + (this.queryParams.endDate ? this.queryParams.endDate : ''), null, `selfMoneySummary_${new Date().getTime()}.xlsx`);
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
