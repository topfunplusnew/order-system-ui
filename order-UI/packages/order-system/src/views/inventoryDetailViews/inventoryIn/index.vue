<template>
	<div class="app-container">
		<el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
			<el-form-item label="日期" prop="date">
				<el-date-picker v-model="queryParams.date" type="date" value-format="yyyy-MM-dd" placeholder="选择日期" clearable />
			</el-form-item>
			<el-form-item label="车号" prop="carNumber">
				<el-input v-model="queryParams.carNumber" placeholder="请输入车号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="供应商/库房" prop="supplier">
				<el-input v-model="queryParams.supplier" placeholder="请输入供应商/库房" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="产品级别" prop="productLevel">
				<el-input v-model="queryParams.productLevel" placeholder="请输入产品级别" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="厚度" prop="thickness">
				<el-input v-model="queryParams.thickness" placeholder="请输入厚度" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="长度" prop="length">
				<el-input v-model="queryParams.length" placeholder="请输入长度" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="宽度" prop="width">
				<el-input v-model="queryParams.width" placeholder="请输入宽度" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="总片数" prop="totalPieces">
				<el-input v-model="queryParams.totalPieces" placeholder="请输入总片数" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="包数" prop="packages">
				<el-input v-model="queryParams.packages" placeholder="请输入包数" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="入库金额" prop="amount">
				<el-input v-model="queryParams.amount" placeholder="请输入入库金额" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['system:inventoryMain:add']">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="primary" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['system:inventoryMain:edit']">修改</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['system:inventoryMain:remove']">删除</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['system:inventoryMain:export']">导出</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList"></right-toolbar>
		</el-row>

		<el-table v-loading="loading" :data="inventoryList" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column label="日期" align="center" prop="date" />
			<el-table-column label="车号" align="center" prop="carNumber" />
			<el-table-column label="供应商/库房" align="center" prop="supplier" />
			<el-table-column label="产品级别" align="center" prop="productLevel" />
			<el-table-column label="厚度" align="center" prop="thickness" />
			<el-table-column label="长度" align="center" prop="length" />
			<el-table-column label="宽度" align="center" prop="width" />
			<el-table-column label="总片数" align="center" prop="totalPieces" />
			<el-table-column label="包数" align="center" prop="packages" />
			<el-table-column label="入库金额" align="center" prop="amount" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="{ row }">
					<el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(row)" v-hasPermi="['system:inventoryMain:edit']">修改</el-button>
					<el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(row)" v-hasPermi="['system:inventoryMain:remove']">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改对话框 -->
		<el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="日期" prop="date">
					<el-date-picker v-model="form.date" type="date" value-format="yyyy-MM-dd" placeholder="选择日期" />
				</el-form-item>
				<el-form-item label="车号" prop="carNumber">
					<el-input v-model="form.carNumber" placeholder="请输入车号" />
				</el-form-item>
				<el-form-item label="供应商/库房" prop="supplier">
					<el-input v-model="form.supplier" placeholder="请输入供应商/库房" />
				</el-form-item>
				<el-form-item label="产品级别" prop="productLevel">
					<el-input v-model="form.productLevel" placeholder="请输入产品级别" />
				</el-form-item>
				<el-form-item label="厚度" prop="thickness">
					<el-input v-model="form.thickness" placeholder="请输入厚度" />
				</el-form-item>
				<el-form-item label="长度" prop="length">
					<el-input v-model="form.length" placeholder="请输入长度" />
				</el-form-item>
				<el-form-item label="宽度" prop="width">
					<el-input v-model="form.width" placeholder="请输入宽度" />
				</el-form-item>
				<el-form-item label="总片数" prop="totalPieces">
					<el-input v-model="form.totalPieces" placeholder="请输入总片数" />
				</el-form-item>
				<el-form-item label="包数" prop="packages">
					<el-input v-model="form.packages" placeholder="请输入包数" />
				</el-form-item>
				<el-form-item label="入库金额" prop="amount">
					<el-input v-model="form.amount" placeholder="请输入入库金额" />
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
import { listInventoryMain, addInventoryMain, updateInventoryMain, delInventoryMain } from '../../../api/system/inventoryMain';

export default {
	name: 'InventoryIn',
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
			// 表格数据
			inventoryList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				date: null,
				carNumber: null,
				supplier: null,
				productLevel: null,
				thickness: null,
				length: null,
				width: null,
				totalPieces: null,
				packages: null,
				amount: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				date: [{ required: true, message: '日期不能为空', trigger: 'blur' }],
				carNumber: [{ required: true, message: '车号不能为空', trigger: 'blur' }],
				supplier: [{ required: true, message: '供应商/库房不能为空', trigger: 'blur' }],
				productLevel: [{ required: true, message: '产品级别不能为空', trigger: 'blur' }],
				thickness: [{ required: true, message: '厚度不能为空', trigger: 'blur' }],
				length: [{ required: true, message: '长度不能为空', trigger: 'blur' }],
				width: [{ required: true, message: '宽度不能为空', trigger: 'blur' }],
				totalPieces: [{ required: true, message: '总片数不能为空', trigger: 'blur' }],
				packages: [{ required: true, message: '包数不能为空', trigger: 'blur' }],
				amount: [{ required: true, message: '入库金额不能为空', trigger: 'blur' }]
			},
			// 列信息
			columns: []
		};
	},
	created() {
		this.getList();
	},
	methods: {
		/** 查询列表 */
		getList() {
			this.loading = true;
			listInventoryMain(this.queryParams).then(response => {
				this.inventoryList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		/** 取消按钮 */
		cancel() {
			this.open = false;
			this.reset();
		},
		/** 表单重置 */
		reset() {
			this.form = {
				date: null,
				carNumber: null,
				supplier: null,
				productLevel: null,
				thickness: null,
				length: null,
				width: null,
				totalPieces: null,
				packages: null,
				amount: null
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
		/** 多选框选中数据 */
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			listInventoryMain(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateInventoryMain(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addInventoryMain(this.form).then(response => {
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
				.confirm('是否确认删除数据项？')
				.then(function () {
					return delInventoryMain(ids);
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
				'system/inventoryMain/export',
				{
					...this.queryParams
				},
				`inventory_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>

<style scoped lang="scss"></style>
