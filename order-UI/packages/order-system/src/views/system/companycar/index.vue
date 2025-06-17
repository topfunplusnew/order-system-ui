<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="车牌" prop="carNo">
				<el-input v-model="queryParams.carNo" placeholder="请输入车牌" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:companycar:add']" type="danger" size="mini" @click="handleAdd">添加公司车辆信息</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:companycar:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" border :data="carsList" height="450px" size="mini" @selection-change="handleSelectionChange">
			<!--      <el-table-column label="id" align="center" prop="dictCode"/>-->
			<el-table-column v-if="columns[0].visible" label="车牌" align="center" prop="dictLabel" min-width="70%" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" min-width="30%">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:companycar:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
					<el-button v-hasPermi="['system:companycar:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改外部车辆信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" label-width="80px">
				<el-form-item label="车牌" prop="carNo">
					<el-input v-model="form.dictLabel" placeholder="请输入车牌" />
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
import { excludeParams } from '@/api/tool/exclude';
import { addData, getData, listData } from '@/api/system/dict/data';
import { getUuid } from '@/utils/trash/utils';
import { delData } from '../../../api/system/dict/data';

export default {
	name: 'Cars',
	data() {
		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			carsList: [],
			title: '',
			open: false,
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				carNo: null,
				driver: null,
				tel: null,
				bankName: null,
				carsName: null,
				bankNo: null,
				carsType: null,
				carType: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			form: {},
			options: [
				{
					value: '收款',
					label: '收款'
				},
				{
					value: '付款',
					label: '付款'
				}
			],
			columns: [{ key: 0, label: `车牌`, visible: true }],
			companyList: []
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('companycar-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('companycar-columns') === 'null' || !localStorage.getItem('companycar-columns')) {
			localStorage.setItem('companycar-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('companycar-columns'));
		}
	},

	methods: {
		// 获取本公司的车辆信息列表
		getList() {
			this.loading = true;
			// 查询公司车辆信息  使用字典查询
			const query = {
				dictType: 'order_cars',
				pageNum: this.queryParams.pageNum,
				pageSize: this.queryParams.pageSize
			};
			listData(query).then(res => {
				this.carsList = res.rows;
				this.total = res.total;
				this.loading = false;
			});
		},
		// 打印
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
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
				dictCode: null,
				dictLabel: null
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
			this.title = '添加外部车辆信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			// getCode
			getData(row.dictCode).then(res => {
				this.form = res.data;
				this.open = true;
				this.title = '修改外部车辆信息';
			});
		},
		// /** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						addData({
							...this.form,
							dictType: 'order_cars',
							dictValue: getUuid()
						}).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addData({
							...this.form,
							dictType: 'order_cars',
							dictValue: getUuid()
						}).then(response => {
							this.form = excludeParams(this.form, this.$exclude);
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},

		// 删除公司车辆信息
		handleDelete(row) {
			this.$modal
				.confirm('是否删除该公司车辆信息?')
				.then(function () {
					return delData(row.dictCode);
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
				'system/companycar/export',
				{
					...this.queryParams
				},
				`cars_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
