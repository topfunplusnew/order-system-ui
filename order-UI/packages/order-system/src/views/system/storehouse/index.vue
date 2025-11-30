<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入仓库名称" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'storeHouseName')" />
			</el-form-item>
			<el-form-item label="地址" prop="address">
				<el-input v-model="queryParams.address" placeholder="请输入地址" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'address')" />
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
				<el-button v-hasPermi="['system:storehouse:add']" type="danger" size="mini" @click="handleAdd">添加仓库商信息</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:storehouse:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" v-horizontal-scroll="'always'" v-loading="loading" size="mini" border :data="StoreHouseList" @selection-change="handleSelectionChange">
			<el-table-column v-if="columns[0].visible" label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.storeHouseName }}</div>
						<span>{{ scope.row.storeHouseName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="地址" align="center" prop="address" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.address }}</div>
						<span>{{ scope.row.address }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:storehouse:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
					<el-button v-hasPermi="['system:storehouse:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改库房对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form size="mini" ref="form" :model="form" :rules="rules" label-width="80px" @keyup.enter.native.prevent="submitForm" @submit.native.prevent="submitForm">
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-input v-model="form.storeHouseName" placeholder="请输入仓库名称" @input="handleInputTrim($event, 'form', 'storeHouseName')" />
				</el-form-item>
				<el-form-item label="地址" prop="address">
					<el-input v-model="form.address" placeholder="请输入地址" @input="handleInputTrim($event, 'form', 'address')" />
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
import { listStoreHouse, getStoreHouse, delStoreHouse, addStoreHouse, updateStoreHouse } from '@/api/system/StoreHouse';
import { excludeParams } from '@/api/tool/exclude';

export default {
	name: 'StoreHouse',
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
			// 库房表格数据
			StoreHouseList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				storeHouseName: null,
				address: null,
				delFlag: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				storeHouseName: [
					{
						required: true,
						message: '仓库名称不能为空',
						trigger: 'blur'
					}
				],
				address: [{ required: true, message: '地址不能为空', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, label: `仓库名称`, visible: true },
				{ key: 1, label: `地址`, visible: true }
			]
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('storehouse-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('storehouse-columns') === 'null' || !localStorage.getItem('storehouse-columns')) {
			// 设置localStorage
			localStorage.setItem('storehouse-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('storehouse-columns'));
		}
	},
	methods: {
		// 处理输入框禁止输入空格
		handleInputTrim(val, obj, prop) {
			if (val.indexOf(' ') !== -1) {
				this[obj][prop] = val.replace(/\s+/g, '');
			}
		},
		/* 打印信息*/
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		/** 查询库房列表 */
		getList() {
			this.loading = true;
			listStoreHouse(this.queryParams).then(response => {
				this.StoreHouseList = response.rows;
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
				storeHouseName: null,
				address: null,
				delFlag: null
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
			this.title = '添加库房';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getStoreHouse(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改库房';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateStoreHouse(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addStoreHouse(this.form).then(() => {
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
				.confirm('是否确认删除库房编号为"' + ids + '"的数据项？')
				.then(function () {
					return delStoreHouse(ids);
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
				'system/StoreHouse/export',
				{
					...this.queryParams
				},
				`StoreHouse_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
