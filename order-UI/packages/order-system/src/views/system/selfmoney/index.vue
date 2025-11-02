<template>
	<div class="app-container">
		<!-- 筛选框 -->
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="开始时间" prop="endDate">
				<el-date-picker v-model="queryParams.endDate" type="datetime" placeholder="选择开始时间" value-format="yyyy-MM-dd HH:mm:ss" size="mini" clearable></el-date-picker>
			</el-form-item>
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
			<el-form-item label="己方公司" prop="displayName">
				<el-input v-model="queryParams.displayName" placeholder="请输入己方公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<el-col>
				<right-toolbar :columns="columns" @queryTable="getList">
					<template #left>
						<el-row :gutter="10">
							<el-col :span="1.5">
								<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
							</el-col>
							<el-col :span="1.5">
								<el-select v-model="value" placeholder="余额排序" size="mini">
									<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
								</el-select>
							</el-col>
						</el-row>
					</template>
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
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
		>
			<el-table-column v-if="columns[0].visible" label="排序序号" align="center" prop="sort" width="100">
				<template #default="scope">
					<span>{{ scope.row.sort }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="己方公司" align="center" prop="displayName" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="开户名称" align="center" prop="acountsName" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="银行账号" align="center" prop="bankNo" show-overflow-tooltip width="260">
				<template #default="scope">
					<div>
						<span style="color: red">[{{ scope.row.bankCardType }}]</span>
						{{ scope.row.bankNo }}
					</div>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[4].visible" label="开户行" align="center" prop="bankName" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="余额" align="center" prop="sumMoney" show-overflow-tooltip />
			<el-table-column label="排序操作" align="center" width="200" fixed="right">
				<template #default="scope">
					<el-input v-model="scope.row.sort" size="mini" style="width: 50px; margin-right: 10px" placeholder="序号" @input="val => handleSortInput(scope.row, val)"></el-input>
					<el-button size="mini" type="primary" icon="el-icon-check" @click="handleSaveSort(scope.row)">保存</el-button>
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<script>
import { listCompany } from '@/api/system/company';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { listBankAccount, listBankAccountSelf, updateBankAccountSort } from '../../../api/system/bankAccount';

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
				{ key: 0, label: `排序序号`, visible: true },
				{ key: 1, label: `己方公司`, visible: true },
				{ key: 2, label: `开户名称`, visible: true },
				{ key: 3, label: `银行账号`, visible: true },
				{ key: 4, label: `开户行`, visible: true },
				{ key: 5, label: `余额`, visible: true }
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
			// 升序和降序的值 - 从localStorage读取排序状态
			value: localStorage.getItem('selfMoneySort') || '',
			// 银行账户类型
			type: ''
		};
	},
	watch: {
		// 监听value并保存排序状态
		value: {
			handler(value) {
				// 保存排序状态到localStorage
				if (value) {
					localStorage.setItem('selfMoneySort', value);
				} else {
					localStorage.removeItem('selfMoneySort');
				}

				// 应用排序
				this.applySort();
			}
		}
	},
	created() {
		this.getList();
	},
	methods: {
		listBankAccount,
		listCompany,
		updateBankAccountSort,
		// 获取当前时间的方法
		getCurrentDateTime() {
			const now = new Date();
			const year = now.getFullYear();
			const month = String(now.getMonth() + 1).padStart(2, '0');
			const day = String(now.getDate()).padStart(2, '0');
			const hours = String(now.getHours()).padStart(2, '0');
			const minutes = String(now.getMinutes()).padStart(2, '0');
			const seconds = String(now.getSeconds()).padStart(2, '0');
			return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
		},
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

				// 应用保存的排序
				this.applySort();
			});
		},
		// 应用当前排序
		applySort() {
			if (this.value === '1') {
				this.bankAccountList.sort(function (a, b) {
					return a.sort - b.sort;
				});
			} else if (this.value === '2') {
				this.bankAccountList.sort(function (a, b) {
					return b.sort - a.sort;
				});
			}
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
			// 保存当前排序状态
			const currentSort = this.value;

			// 重置查询参数
			this.queryParams = {
				endDate: this.getCurrentDateTime(), // 重置为当前时间
				bankCardType: null,
				bankName: null,
				acountsName: null,
				bankNo: null,
				displayName: null
			};

			this.getList();
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download('system/bankAccount/exportSelfMoneySummary?endDate=' + (this.queryParams.endDate ? this.queryParams.endDate : ''), null, `selfMoneySummary_${new Date().getTime()}.xlsx`);
		},
		/**
		 * 处理排序序号输入，只允许输入数字
		 * @param {Object} row - 当前行数据
		 * @param {string|number} val - 输入值
		 */
		handleSortInput(row, val) {
			// 移除所有非数字字符
			const numericValue = String(val).replace(/[^\d]/g, '');
			// 如果输入为空，设置为 null；否则转换为数字
			row.sort = numericValue === '' ? null : Number(numericValue);
		},
		/**
		 * 保存排序序号
		 * @param {Object} row - 当前行数据
		 */
		handleSaveSort(row) {
			if (!row.bankAccountId) {
				this.$message.error('该行数据缺少ID，无法保存');
				return;
			}

			// 构建更新数据，只包含id和sort字段
			const updateData = {
				id: row.bankAccountId,
				sort: row.sort || 0
			};

			// 调用更新排序接口
			updateBankAccountSort(updateData)
				.then(() => {
					this.$message.success('排序序号保存成功');
					// 保存成功后，重新抓取数据
					this.getList();
				})
				.catch(error => {
					this.$message.error('排序序号保存失败：' + (error.message || '未知错误'));
					// 保存失败时，刷新列表恢复原值
					this.getList();
				});
		}
	}
};
</script>
<style scoped>
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
</style>
