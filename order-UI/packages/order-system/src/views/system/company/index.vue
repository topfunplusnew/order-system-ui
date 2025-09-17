<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px" class="form-container">
			<el-form-item label="客户名称" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入客户名称" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'companyName')" />
			</el-form-item>
			<el-form-item label="联系人" prop="relationName">
				<el-input
					v-model="queryParams.relationName"
					placeholder="请输入联系人名称"
					clearable
					@keyup.enter.native="handleQuery"
					@input="handleInputTrim($event, 'queryParams', 'relationName')"
				/>
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
				<el-button v-hasPermi="['system:company:add']" type="danger" size="mini" @click="handleAdd">新增客户信息</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="tableColumns" @queryTable="getList" @column-change="handleColumnChange">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:company:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" border :data="companyList" size="mini" :cell-style="cellStyle" @selection-change="handleSelectionChange">
			<CustomTableColumn v-for="column in visibleColumns" :key="column.key" v-bind="getColumnProps(column)" />
			<CustomTableColumn label="操作" align="center" class-name="small-padding fixed-width" width="200">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="jumpBankNo(scope.row)">银行卡号</el-button>
					<el-button v-hasPermi="['system:company:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
					<el-button v-hasPermi="['system:company:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</CustomTableColumn>
		</el-table>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<script>
import { delCompany, getCompany, listCompany } from '@/api/system/company';
import { INFO_TYPE, isUsed } from '../../../api/system/isUsed';
import { createConfigManager } from '@/utils/configManager';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { tableColumnMixin } from '@/mixins/tableColumnMixin';
import columnConfig from './base/columns';
import CompanyForm from './base/CompanyForm.vue';
import BankManage from './options/BankManage.vue';
import { PUBLIC_DICT_TYPE } from '../../../api/tool/enums';

export default {
	name: 'Company',
	mixins: [common_dialog, tableColumnMixin],
	data() {
		return {
			// 配置管理器
			configManager: null,
			// 表格列配置
			tableColumns: [],
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			companyList: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				companyName: null,
				relationName: null,
				relationTel: null,
				address: null,
				bankName: null,
				acountsName: null,
				bankNo: null,
				surplusMoney: null,
				companyType: PUBLIC_DICT_TYPE.CUSTOMER,
				salesman: null,
				leader: null,
				leaderTel: null,
				region: null,
				salesManager: null,
				province: null,
				city: null,
				county: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			}
		};
	},
	created() {
		// 初始化配置管理器
		this.configManager = createConfigManager(columnConfig);
		this.tableColumns = this.configManager.getTableColumns();

		this.getList();
	},
	methods: {
		getStorageKey() {
			return 'company-columns';
		},

		cellStyle() {
			return { padding: '.5px' };
		},

		// 点击银行卡后弹窗 - 使用 openDialog
		jumpBankNo(row) {
			const companyInfo = {
				relationName: row.relationName,
				id: row.id,
				relationTel: row.relationTel,
				address: row.address,
				surplusMoney: row.surplusMoney,
				salesman: row.salesman,
				leader: row.leader,
				leaderTel: row.leaderTel,
				region: row.region,
				salesManager: row.salesManager,
				province: row.province,
				city: row.city,
				county: row.county,
				comments: row.comments,
				companyName: row.companyName
			};

			this.openDialog(
				BankManage,
				'银行卡管理',
				'80%',
				{
					companyInfo: companyInfo
				},
				false
			);
		},

		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},

		/** 查询客户、供应商信息列表 */
		getList() {
			this.loading = true;
			listCompany(this.queryParams).then(response => {
				this.companyList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},

		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},

		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},

		// 多选框选中数据
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},

		/** 新增按钮操作 */
		handleAdd() {
			// 使用配置管理器获取默认表单数据
			const defaultForm = this.getDefaultFormData();

			this.openDialog(
				CompanyForm,
				'添加客户信息',
				'600px',
				{
					formData: defaultForm,
					isEdit: false,
					title: '添加客户信息'
				},
				false
			);
		},

		/** 修改按钮操作 */
		handleUpdate(row) {
			const id = row.id || this.ids;
			getCompany(id, PUBLIC_DICT_TYPE.CUSTOMER).then(response => {
				this.openDialog(
					CompanyForm,
					'修改客户信息',
					'600px',
					{
						formData: response.data,
						isEdit: true,
						title: '修改客户信息'
					},
					false
				);
			});
		},

		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			// 删除前要去检索一下是否有用到该数据 要给用户提示
			const query = {
				id: ids,
				type: INFO_TYPE.CUSTOMER
			};
			// 弹窗删除
			this.$modal
				.confirm('是否确认删除编号为"' + ids + '"的数据项？')
				.then(() => {
					// 查询该数据是否被使用
					isUsed(query).then(res => {
						if (res.data.isUsed) {
							this.$modal
								.confirm('系统检测该信息:"' + ids + '"的客户数据在系统中被使用，是否要继续删除?')
								.then(function () {
									return delCompany(ids, PUBLIC_DICT_TYPE.CUSTOMER);
								})
								.then(() => {
									this.getList();
									this.$modal.msgSuccess('删除成功');
								})
								.catch(() => {});
						} else {
							delCompany(ids, PUBLIC_DICT_TYPE.CUSTOMER).then(() => {
								this.getList();
								this.$modal.msgSuccess('删除成功');
							});
						}
					});
				})
				.catch(() => {});
		},

		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/company/export',
				{
					...this.queryParams
				},
				`company_${new Date().getTime()}.xlsx`
			);
		},

		// 处理输入框禁止输入空格
		handleInputTrim(val, obj, prop) {
			if (val.indexOf(' ') !== -1) {
				this[obj][prop] = val.replace(/\s+/g, '');
			}
		}
	}
};
</script>

<style scoped>
.form-container {
	background-color: #f9f9f9;
	padding: 10px;
	border-radius: 5px;
	margin-bottom: 10px;
}

/* 添加新的样式，确保弹窗不会捕获点击事件 */
:deep(.non-blocking-dialog) {
	pointer-events: auto;
}

:deep(.el-dialog__wrapper) {
	pointer-events: none;
}

:deep(.el-dialog) {
	pointer-events: auto;
	background-color: #fff;
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

:deep(.el-overlay) {
	pointer-events: none !important;
}
</style>
