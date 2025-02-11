<template>
	<div class="app-container">
		<el-form
			:model="queryParams"
			ref="queryForm"
			size="small"
			:inline="true"
			v-show="showSearch"
			label-width="68px"
		>
			<el-form-item label="关联表名" prop="tableName">
				<el-input
					v-model="queryParams.tableName"
					placeholder="请输入关联表名"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="关联表的 ID" prop="tableId">
				<el-input
					v-model="queryParams.tableId"
					placeholder="请输入关联表的 ID"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="附件的 URL" prop="url">
				<el-input
					v-model="queryParams.url"
					placeholder="请输入附件的 URL"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="文件名" prop="fileName">
				<el-input
					v-model="queryParams.fileName"
					placeholder="请输入文件名"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="上传日期" prop="uploadDate">
				<el-date-picker
					clearable
					v-model="queryParams.uploadDate"
					type="date"
					value-format="yyyy-MM-dd"
					placeholder="请选择上传日期"
				>
				</el-date-picker>
			</el-form-item>
			<el-form-item label="标记" prop="flag">
				<el-input
					v-model="queryParams.flag"
					placeholder="请输入标记"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="逻辑删除标记" prop="delFlag">
				<el-input
					v-model="queryParams.delFlag"
					placeholder="请输入逻辑删除标记"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
					>搜索</el-button
				>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery"
					>重置</el-button
				>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button
					type="primary"
					plain
					icon="el-icon-plus"
					size="mini"
					@click="handleAdd"
					v-hasPermi="['system:attachments:add']"
					>新增</el-button
				>
			</el-col>
			<el-col :span="1.5">
				<el-button
					type="success"
					plain
					icon="el-icon-edit"
					size="mini"
					:disabled="single"
					@click="handleUpdate"
					v-hasPermi="['system:attachments:edit']"
					>修改</el-button
				>
			</el-col>
			<el-col :span="1.5">
				<el-button
					type="danger"
					plain
					icon="el-icon-delete"
					size="mini"
					:disabled="multiple"
					@click="handleDelete"
					v-hasPermi="['system:attachments:remove']"
					>删除</el-button
				>
			</el-col>
			<el-col :span="1.5">
				<el-button
					type="warning"
					plain
					icon="el-icon-download"
					size="mini"
					@click="handleExport"
					v-hasPermi="['system:attachments:export']"
					>导出</el-button
				>
			</el-col>
			<right-toolbar
				:showSearch.sync="showSearch"
				@queryTable="getList"
			></right-toolbar>
		</el-row>

		<el-table
			v-loading="loading"
			:data="attachmentsList"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column label="主键，自增" align="center" prop="id" />
			<el-table-column label="关联表名" align="center" prop="tableName" />
			<el-table-column label="关联表的 ID" align="center" prop="tableId" />
			<el-table-column label="附件的 URL" align="center" prop="url" />
			<el-table-column label="文件名" align="center" prop="fileName" />
			<el-table-column label="文件扩展名" align="center" prop="fileType" />
			<el-table-column
				label="上传日期"
				align="center"
				prop="uploadDate"
				width="180"
			>
				<template slot-scope="scope">
					<span>{{ parseTime(scope.row.uploadDate, '{y}-{m}-{d}') }}</span>
				</template>
			</el-table-column>
			<el-table-column label="描述" align="center" prop="description" />
			<el-table-column label="标记" align="center" prop="flag" />
			<el-table-column label="逻辑删除标记" align="center" prop="delFlag" />
			<el-table-column label="扩展性保留字段" align="center" prop="extraInfo" />
			<el-table-column
				label="操作"
				align="center"
				class-name="small-padding fixed-width"
			>
				<template slot-scope="scope">
					<el-button
						size="mini"
						type="text"
						icon="el-icon-edit"
						@click="handleUpdate(scope.row)"
						v-hasPermi="['system:attachments:edit']"
						>修改</el-button
					>
					<el-button
						size="mini"
						type="text"
						icon="el-icon-delete"
						@click="handleDelete(scope.row)"
						v-hasPermi="['system:attachments:remove']"
						>删除</el-button
					>
				</template>
			</el-table-column>
		</el-table>

		<pagination
			v-show="total > 0"
			:total="total"
			:page.sync="queryParams.pageNum"
			:limit.sync="queryParams.pageSize"
			@pagination="getList"
		/>

		<!-- 添加或修改通用附件对话框 -->
		<el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="关联表名" prop="tableName">
					<el-input v-model="form.tableName" placeholder="请输入关联表名" />
				</el-form-item>
				<el-form-item label="关联表的 ID" prop="tableId">
					<el-input v-model="form.tableId" placeholder="请输入关联表的 ID" />
				</el-form-item>
				<el-form-item label="附件的 URL" prop="url">
					<el-input v-model="form.url" placeholder="请输入附件的 URL" />
				</el-form-item>
				<el-form-item label="文件名" prop="fileName">
					<el-input v-model="form.fileName" placeholder="请输入文件名" />
				</el-form-item>
				<el-form-item label="上传日期" prop="uploadDate">
					<el-date-picker
						clearable
						v-model="form.uploadDate"
						type="date"
						value-format="yyyy-MM-dd"
						placeholder="请选择上传日期"
					>
					</el-date-picker>
				</el-form-item>
				<el-form-item label="描述" prop="description">
					<el-input
						v-model="form.description"
						type="textarea"
						placeholder="请输入内容"
					/>
				</el-form-item>
				<el-form-item label="标记" prop="flag">
					<el-input v-model="form.flag" placeholder="请输入标记" />
				</el-form-item>
				<el-form-item label="逻辑删除标记" prop="delFlag">
					<el-input v-model="form.delFlag" placeholder="请输入逻辑删除标记" />
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
import {
	listAttachments,
	getAttachments,
	delAttachments,
	addAttachments,
	updateAttachments
} from '@/api/system/attachments';

export default {
	name: 'Attachments',
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
			// 通用附件表格数据
			attachmentsList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				tableName: null,
				tableId: null,
				url: null,
				fileName: null,
				fileType: null,
				uploadDate: null,
				description: null,
				flag: null,
				delFlag: null,
				extraInfo: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				tableName: [
					{ required: true, message: '关联表名不能为空', trigger: 'blur' }
				],
				tableId: [
					{ required: true, message: '关联表的 ID不能为空', trigger: 'blur' }
				],
				url: [
					{ required: true, message: '附件的 URL不能为空', trigger: 'blur' }
				],
				fileName: [
					{ required: true, message: '文件名不能为空', trigger: 'blur' }
				],
				fileType: [
					{ required: true, message: '文件扩展名不能为空', trigger: 'change' }
				],
				uploadDate: [
					{ required: true, message: '上传日期不能为空', trigger: 'blur' }
				],
				delFlag: [
					{ required: true, message: '逻辑删除标记不能为空', trigger: 'blur' }
				]
			}
		};
	},
	created() {
		this.getList();
	},
	methods: {
		/** 查询通用附件列表 */
		getList() {
			this.loading = true;
			listAttachments(this.queryParams).then(response => {
				this.attachmentsList = response.rows;
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
				tableName: null,
				tableId: null,
				url: null,
				fileName: null,
				fileType: null,
				uploadDate: null,
				description: null,
				flag: null,
				delFlag: null,
				extraInfo: null
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
			this.title = '添加通用附件';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getAttachments(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改通用附件';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateAttachments(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addAttachments(this.form).then(response => {
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
				.confirm('是否确认删除通用附件编号为"' + ids + '"的数据项？')
				.then(function () {
					return delAttachments(ids);
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
				'system/attachments/export',
				{
					...this.queryParams
				},
				`attachments_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
