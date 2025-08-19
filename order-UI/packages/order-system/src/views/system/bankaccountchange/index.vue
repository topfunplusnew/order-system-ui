<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="我方账号" prop="selfBankNo">
				<el-input v-model="queryParams.selfBankNo" placeholder="请输入我方账号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="发生操作行为的表" prop="tableName">
				<el-input v-model="queryParams.tableName" placeholder="请输入发生操作行为的表" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="发生操作行为的付款编号" prop="payNO">
				<el-input v-model="queryParams.payNO" placeholder="请输入发生操作行为的付款编号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="日期" prop="operateDate">
				<el-input v-model="queryParams.operateDate" placeholder="请输入日期" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="金额" prop="moneyAmount">
				<el-input v-model="queryParams.moneyAmount" placeholder="请输入金额" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="备注" prop="comments">
				<el-input v-model="queryParams.comments" placeholder="请输入备注" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="添加时间" prop="addtime">
				<el-input v-model="queryParams.addtime" placeholder="请输入添加时间" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="操作人员ID" prop="userId">
				<el-input v-model="queryParams.userId" placeholder="请输入操作人员ID" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="操作人员姓名" prop="UserName">
				<el-input v-model="queryParams.UserName" placeholder="请输入操作人员姓名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:bankaccountchange:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:bankaccountchange:edit']" type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate">修改</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:bankaccountchange:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:bankaccountchange:export']" type="warning" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
		</el-row>

		<el-table v-loading="loading" :data="bankAccountChangeList" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column label="id" align="center" prop="id" />
			<el-table-column label="我方账号" align="center" prop="selfBankNo" />
			<el-table-column label="发生操作行为的表" align="center" prop="tableName" />
			<el-table-column label="发生操作行为的付款编号" align="center" prop="payNO" />
			<el-table-column label="日期" align="center" prop="operateDate" />
			<el-table-column label="变动类型" align="center" prop="changeType" />
			<el-table-column label="金额" align="center" prop="moneyAmount" />
			<el-table-column label="备注" align="center" prop="comments" />
			<el-table-column label="添加时间" align="center" prop="addtime" />
			<el-table-column label="操作人员ID" align="center" prop="userId" />
			<el-table-column label="操作人员姓名" align="center" prop="UserName" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:bankaccountchange:edit']" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:bankaccountchange:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改银行账号变动流水对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="我方账号" prop="selfBankNo">
					<el-input v-model="form.selfBankNo" placeholder="请输入我方账号" />
				</el-form-item>
				<el-form-item label="发生操作行为的表" prop="tableName">
					<el-input v-model="form.tableName" placeholder="请输入发生操作行为的表" />
				</el-form-item>
				<el-form-item label="发生操作行为的付款编号" prop="payNO">
					<el-input v-model="form.payNO" placeholder="请输入发生操作行为的付款编号" />
				</el-form-item>
				<el-form-item label="日期" prop="operateDate">
					<el-input v-model="form.operateDate" placeholder="请输入日期" />
				</el-form-item>
				<el-form-item label="金额" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
				<el-form-item label="添加时间" prop="addtime">
					<el-input v-model="form.addtime" placeholder="请输入添加时间" />
				</el-form-item>
				<el-form-item label="操作人员ID" prop="userId">
					<el-input v-model="form.userId" placeholder="请输入操作人员ID" />
				</el-form-item>
				<el-form-item label="操作人员姓名" prop="UserName">
					<el-input v-model="form.UserName" placeholder="请输入操作人员姓名" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listBankAccountChange, getBankAccountChange, delBankAccountChange, addBankAccountChange, updateBankAccountChange } from '@/api/system/bankAccountChange';

export default {
	name: 'BankAccountChange',
	data() {
		return {
			// 遮罩层
			loading: true,
			// 选中数组
			ids: [],
			// 非单个禁用
			single: true,
			// 非多个禁用
			multiple: true,
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 银行账号变动流水表格数据
			bankAccountChangeList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				selfBankNo: null,
				tableName: null,
				payNO: null,
				operateDate: null,
				changeType: null,
				moneyAmount: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {}
		};
	},
	created() {
		this.getList();
	},
	methods: {
		/** 查询银行账号变动流水列表 */
		getList() {
			this.loading = true;
			listBankAccountChange(this.queryParams).then(response => {
				this.bankAccountChangeList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				selfBankNo: null,
				tableName: null,
				payNO: null,
				operateDate: null,
				changeType: null,
				moneyAmount: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null
			};
			this.resetForm('form');
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
			this.reset();
			this.open = true;
			this.title = '添加银行账号变动流水';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getBankAccountChange(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改银行账号变动流水';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateBankAccountChange(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addBankAccountChange(this.form).then(response => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除银行账号变动流水编号为"' + ids + '"的数据项？')
				.then(function () {
					return delBankAccountChange(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/bankAccountChange/export',
				{
					...this.queryParams
				},
				`bankAccountChange_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
