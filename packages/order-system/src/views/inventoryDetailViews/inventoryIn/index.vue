<template>
	<div class="app-container">
		<el-form id="top-search-form-item" :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="150">
			<el-form-item label="开始日期" prop="startDate">
				<el-date-picker v-model="queryParams.startDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="选择开始日期" clearable />
			</el-form-item>
			<el-form-item label="结束日期" prop="endDate">
				<el-date-picker v-model="queryParams.endDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="选择结束日期" clearable />
			</el-form-item>
			<!-- 因为没用，后端要求删除 -->
			<!-- <el-form-item label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入仓库名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item> -->
			<el-form-item label="产品级别" prop="levelName">
				<el-input v-model="queryParams.levelName" placeholder="请输入产品级别" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="供应商/库房" prop="supplierOrWarehouse">
				<el-input v-model="queryParams.supplierOrWarehouse" placeholder="请输入供应商/库房" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="入库库房" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入入库库房" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['system:inventoryStatistics:inStatistics']">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<!-- 只保留导出按钮和右侧工具栏 -->
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" tableName="detail-inventory-in-columns">
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['system:inventoryStatistics:exportIn']"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table v-loading="loading" :data="inventoryList" size="mini" border>
			<el-table-column v-for="col in columns" v-if="col.visible" :key="col.prop" :label="col.label" :prop="col.prop" align="center" show-overflow-tooltip />
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
import _ from 'lodash';
import { listInStatistics } from '../../../api/inventory/index';
import { fix_2 } from '../../../api/tool/format';

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
				pageSize: 20,
				startDate: '', // 开始日期
				endDate: '', // 结束日期
				storeHouseName: '', // 仓库名称
				levelName: '', // 产品级别
				supplier: '', // 供应商
				supplierOrWarehouse: '', // 供应商/库房（模糊查询）
				inType: '' // 入库类型
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
			columns: [
				{ label: '入库日期', prop: 'storeDate', visible: true },
				{ label: '入库库房', prop: 'storeHouseName', visible: true },
				{ label: '车号', prop: 'carNo', visible: true },
				{ label: '供应商/库房', prop: 'supplierOrWarehouse', visible: true },
				{ label: '产品级别', prop: 'levelName', visible: true },
				{ label: '厚度', prop: 'height', visible: true },
				{ label: '长度', prop: 'length', visible: true },
				{ label: '宽度', prop: 'width', visible: true },
				{ label: '总片数', prop: 'totalPieces', visible: true },
				{ label: '包数', prop: 'packs', visible: true },
				{ label: '入库金额', prop: 'inAmount', visible: true },
				{ label: '入库类型', prop: 'inType', visible: true }
			]
		};
	},
	created() {
		this.getList();
	},
	methods: {
		/** 查询列表 */
		getList() {
			this.loading = true;
			const params = {
				pageNum: this.queryParams.pageNum,
				pageSize: this.queryParams.pageSize,
				startDate: this.queryParams.startDate ? this.queryParams.startDate + ' 00:00:00' : undefined,
				endDate: this.queryParams.endDate ? this.queryParams.endDate + ' 23:59:59' : undefined,
				storeHouseName: this.queryParams.storeHouseName,
				levelName: this.queryParams.levelName,
				supplier: this.queryParams.supplier,
				supplierOrWarehouse: this.queryParams.supplierOrWarehouse,
				inType: this.queryParams.inType
			};
			listInStatistics(params).then(response => {
				this.inventoryList = _.cloneDeep(response.rows).map(item => {
					return {
						...item,
						inAmount: fix_2(item.inAmount)
					};
				});
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
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/inventoryStatistics/exportInStatistics',
				{
					...this.queryParams
				},
				`入库信息统计_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>

<style scoped lang="scss"></style>
