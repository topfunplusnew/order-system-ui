<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="流程名称" prop="flowname">
				<el-input v-model="queryParams.flowname" placeholder="请输入流程名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对应的表主键" prop="applyID">
				<el-input v-model="queryParams.applyID" placeholder="请输入对应的表主键" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="审核总共步骤" prop="stepnum">
				<el-input v-model="queryParams.stepnum" placeholder="请输入审核总共步骤" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="步骤序号" prop="step">
				<el-input v-model="queryParams.step" placeholder="请输入步骤序号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="允许的审核人员ID" prop="auditauthority">
				<el-input v-model="queryParams.auditauthority" placeholder="请输入允许的审核人员ID" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="审核时间" prop="auditdate">
				<el-date-picker v-model="queryParams.auditdate" clearable type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择审核时间"></el-date-picker>
			</el-form-item>
			<el-form-item label="审核人员ID" prop="userId">
				<el-input v-model="queryParams.userId" placeholder="请输入审核人员ID" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="审核人员姓名" prop="UserName">
				<el-input v-model="queryParams.UserName" placeholder="请输入审核人员姓名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="审核状态" prop="checkState">
				<el-input v-model="queryParams.checkState" placeholder="请输入审核状态" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="审核意见" prop="auditcomment">
				<el-input v-model="queryParams.auditcomment" placeholder="请输入审核意见" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="提交标记" prop="submitflag">
				<el-input v-model="queryParams.submitflag" placeholder="请输入提交标记" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:auditinfo:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:auditinfo:edit']" type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate">修改</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:auditinfo:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:auditinfo:export']" type="warning" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
		</el-row>

		<el-table v-loading="loading" :data="auditInfoList" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column label="${comment}" align="center" prop="id" />
			<el-table-column label="流程名称" align="center" prop="flowname" />
			<el-table-column label="对应的表主键" align="center" prop="applyID" />
			<el-table-column label="审核总共步骤" align="center" prop="stepnum" />
			<el-table-column label="步骤序号" align="center" prop="step" />
			<el-table-column label="允许的审核人员ID" align="center" prop="auditauthority" />
			<el-table-column label="审核时间" align="center" prop="auditdate" width="180">
				<template slot-scope="scope">
					<span>{{ parseTime(scope.row.auditdate, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
				</template>
			</el-table-column>
			<el-table-column label="审核人员ID" align="center" prop="userId" />
			<el-table-column label="审核人员姓名" align="center" prop="UserName" />
			<el-table-column label="审核状态" align="center" prop="checkState" />
			<el-table-column label="审核意见" align="center" prop="auditcomment" />
			<el-table-column label="提交标记" align="center" prop="submitflag" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:auditinfo:edit']" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:auditinfo:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改审核流程对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="流程名称" prop="flowname">
					<el-input v-model="form.flowname" placeholder="请输入流程名称" />
				</el-form-item>
				<el-form-item label="对应的表主键" prop="applyID">
					<el-input v-model="form.applyID" placeholder="请输入对应的表主键" />
				</el-form-item>
				<el-form-item label="审核总共步骤" prop="stepnum">
					<el-input v-model="form.stepnum" placeholder="请输入审核总共步骤" />
				</el-form-item>
				<el-form-item label="步骤序号" prop="step">
					<el-input v-model="form.step" placeholder="请输入步骤序号" />
				</el-form-item>
				<el-form-item label="允许的审核人员ID" prop="auditauthority">
					<el-input v-model="form.auditauthority" placeholder="请输入允许的审核人员ID" />
				</el-form-item>
				<el-form-item label="审核时间" prop="auditdate">
					<el-date-picker v-model="form.auditdate" clearable type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择审核时间"></el-date-picker>
				</el-form-item>
				<el-form-item label="审核人员ID" prop="userId">
					<el-input v-model="form.userId" placeholder="请输入审核人员ID" />
				</el-form-item>
				<el-form-item label="审核人员姓名" prop="UserName">
					<el-input v-model="form.UserName" placeholder="请输入审核人员姓名" />
				</el-form-item>
				<el-form-item label="审核状态" prop="checkState">
					<el-input v-model="form.checkState" placeholder="请输入审核状态" />
				</el-form-item>
				<el-form-item label="审核意见" prop="auditcomment">
					<el-input v-model="form.auditcomment" placeholder="请输入审核意见" />
				</el-form-item>
				<el-form-item label="提交标记" prop="submitflag">
					<el-input v-model="form.submitflag" placeholder="请输入提交标记" />
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
import { listAuditInfo, getAuditInfo, delAuditInfo, addAuditInfo, updateAuditInfo } from '@/api/system/auditInfo';

export default {
	name: 'AuditInfo',
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
			// 审核流程表格数据
			auditInfoList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				flowname: null,
				applyID: null,
				stepnum: null,
				step: null,
				auditauthority: null,
				auditdate: null,
				userId: null,
				UserName: null,
				checkState: null,
				auditcomment: null,
				submitflag: null
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
		/** 查询审核流程列表 */
		getList() {
			this.loading = true;
			listAuditInfo(this.queryParams).then(response => {
				this.auditInfoList = response.rows;
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
				flowname: null,
				applyID: null,
				stepnum: null,
				step: null,
				auditauthority: null,
				auditdate: null,
				userId: null,
				UserName: null,
				checkState: null,
				auditcomment: null,
				submitflag: null
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
			this.title = '添加审核流程';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getAuditInfo(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改审核流程';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateAuditInfo(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addAuditInfo(this.form).then(response => {
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
				.confirm('是否确认删除审核流程编号为"' + ids + '"的数据项？')
				.then(function () {
					return delAuditInfo(ids);
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
				'system/auditInfo/export',
				{
					...this.queryParams
				},
				`auditInfo_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
