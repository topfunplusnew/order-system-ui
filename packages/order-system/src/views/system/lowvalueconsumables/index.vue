<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="付款时间">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd HH:mm:ss" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
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
				<el-button type="danger" size="mini" @click="handleAdd">新增低值易耗品台账信息</el-button>
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
						<el-button v-hasPermi="['system:company:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="lowvalueconsumablesList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="购入日期" align="center" prop="buyDate" width="120px" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.buyDate }}</div>
						<span>{{ scope.row.buyDate }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="资产编号" align="center" prop="assetNo" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.assetNo }}</div>
						<span>{{ scope.row.assetNo }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="资产名称" align="center" prop="assetName" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.assetName }}</div>
						<span>{{ scope.row.assetName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="规格型号" align="center" prop="specification" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.specification }}</div>
						<span>{{ scope.row.specification }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[4].visible" label="数量" align="center" prop="number" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.number }}</div>
						<span>{{ scope.row.number }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[5].visible" label="计量单位" align="center" prop="measurementUnit" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.measurementUnit }}</div>
						<span>{{ scope.row.measurementUnit }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="含税金额" align="center" prop="amountIncludeTax" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.amountIncludeTax }}</div>
						<span>{{ scope.row.amountIncludeTax }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[7].visible" label="不含税金额" align="center" prop="amountNoTax" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.amountNoTax }}</div>
						<span>{{ scope.row.amountNoTax }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="户名名称" align="center" prop="account" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.account }}</div>
						<span>{{ scope.row.account }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[9].visible" label="使用部门" align="center" prop="department" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.department }}</div>
						<span>{{ scope.row.department }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="低值易耗品台账清理时间" align="center" prop="scrapDate" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.scrapDate }}</div>
						<span>{{ scope.row.scrapDate }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="清理/变卖价值" align="center" prop="saleAmount" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.saleAmount }}</div>
						<span>{{ scope.row.saleAmount }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="备注" align="center" prop="comments" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.comments }}</div>
						<span>{{ scope.row.comments }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:lowvalueconsumables:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:lowvalueconsumables:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改低值易耗品台账对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="50%" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="120px">
				<el-row>
					<el-col :span="12">
						<el-form-item label="购入日期" prop="buyDate">
							<el-date-picker v-model="form.buyDate" type="datetime" placeholder="购入日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>
						<el-form-item label="资产编号" prop="assetNo">
							<el-input v-model="form.assetNo" placeholder="请输入资产编号" />
						</el-form-item>
						<el-form-item label="资产名称" prop="assetName">
							<el-input v-model="form.assetName" placeholder="请输入资产名称" />
						</el-form-item>
						<el-form-item label="规格型号" prop=" specification">
							<el-input v-model="form.specification" placeholder="请输入规格型号" />
						</el-form-item>
						<el-form-item label="数量" prop="number">
							<el-input v-model="form.number" placeholder="请输入数量" />
						</el-form-item>
						<el-form-item label="计量单位" prop="measurementUnit">
							<el-input v-model="form.measurementUnit" placeholder="请输入计量单位" />
						</el-form-item>
						<el-form-item label="含税金额" prop="amountIncludeTax">
							<el-input v-model="form.amountIncludeTax" placeholder="请输入含税金额" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="不含税金额" prop="amountNoTax">
							<el-input v-model="form.amountNoTax" placeholder="请输入不含税金额" />
						</el-form-item>
						<el-form-item label="户名名称" prop="account">
							<el-radio v-model="form.account" label="公户">公户</el-radio>
							<el-radio v-model="form.account" label="个人">个人</el-radio>
						</el-form-item>
						<el-form-item label="使用部门" prop="department">
							<el-input v-model="form.department" placeholder="请输入使用部门" />
						</el-form-item>
						<el-form-item label="低值易耗品台账清理时间" prop="scrapDate">
							<el-date-picker v-model="form.scrapDate" type="datetime" placeholder="低值易耗品台账清理时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>
						<el-form-item label="清理/变卖价值" prop="saleAmount">
							<el-input v-model="form.saleAmount" placeholder="请输入清理/变卖价值" />
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" />
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listFixedAssets, getFixedAssets, delFixedAssets, addFixedAssets, updateFixedAssets } from '@/api/system/fixedAssets';
import { excludeParams } from '@/api/tool/exclude';
import { addDateRange } from '@/utils/ruoyi';

export default {
	name: 'lowvalueconsumables',
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
			// 低值易耗品台账表格数据
			lowvalueconsumablesList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			dateRange: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				type: 1
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				// 添加校验
				buyDate: [
					{
						required: true,
						message: '购入日期不能为空',
						trigger: 'blur'
					}
				],
				assetNo: [
					{
						required: true,
						message: '资产编号不能为空',
						trigger: 'blur'
					}
				],
				assetName: [
					{
						required: true,
						message: '资产名称不能为空',
						trigger: 'blur'
					}
				],
				specification: [
					{
						required: true,
						message: '规格型号不能为空',
						trigger: 'blur'
					}
				],
				number: [{ required: true, message: '数量不能为空', trigger: 'blur' }],
				measurementUnit: [
					{
						required: true,
						message: '计量单位不能为空',
						trigger: 'blur'
					}
				],
				amountIncludeTax: [
					{
						required: true,
						message: '含税金额不能为空',
						trigger: 'blur'
					},
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				amountNoTax: [
					{
						required: true,
						message: '不含税金额不能为空',
						trigger: 'blur'
					},
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				account: [
					{
						required: true,
						message: '户名名称不能为空',
						trigger: 'blur'
					}
				],
				department: [
					{
						required: true,
						message: '使用部门不能为空',
						trigger: 'blur'
					}
				],
				scrapDate: [
					{
						required: true,
						message: '低值易耗品台账清理时间不能为空',
						trigger: 'blur'
					}
				],
				saleDate: [
					{
						required: true,
						message: '销售日期不能为空',
						trigger: 'blur'
					}
				],
				saleAmount: [
					{
						required: true,
						message: '清理/变卖价值不能为空',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `购入日期`, visible: true },
				{ key: 1, label: `资产编号`, visible: true },
				{ key: 2, label: `资产名称`, visible: true },
				{ key: 3, label: `规格型号`, visible: true },
				{ key: 4, label: `数量`, visible: true },
				{ key: 5, label: `计量单位`, visible: true },
				{ key: 6, label: `含税金额`, visible: true },
				{ key: 7, label: `不含税金额`, visible: true },
				{ key: 8, label: `户名名称`, visible: true },
				{ key: 9, label: `使用部门`, visible: true },
				{ key: 10, label: `低值易耗品台账清理时间`, visible: true },
				{ key: 11, label: `清理/变卖价值`, visible: true },
				{ key: 12, label: `备注`, visible: true }
			],
			// 开始时间
			timesQuery: {
				beginTime: '',
				endTime: '',
				objectType: ''
			},
			options: [
				{
					label: 'test',
					value: 'test'
				}
			]
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('lowvalueconsumables-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		// 获取信息
		this.getList();
		this.$store.dispatch('lowvalueconsumables/getFixedAssetsList');
		this.loading = false;
		if (localStorage.getItem('lowvalueconsumables-columns') === 'null' || !localStorage.getItem('lowvalueconsumables-columns')) {
			// 设置localStorage
			localStorage.setItem('lowvalueconsumables-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('lowvalueconsumables-columns'));
		}
	},
	methods: {
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		/** 查询低值易耗品台账列表 */
		getList() {
			this.loading = true;
			listFixedAssets(addDateRange(this.queryParams, this.dateRange, 'fixedassets')).then(response => {
				this.lowvalueconsumablesList = response.rows;
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
				buyDate: null,
				assetNo: null,
				assetName: null,
				specification: null,
				number: null,
				measurementUnit: null,
				amountIncludeTax: null,
				amountNoTax: null,
				account: null,
				department: null,
				scrapDate: null,
				saleAmount: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				type: 1
			};
			this.dateRange = [];
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
			this.dateRange = [];
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
			this.title = '添加低值易耗品台账';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getFixedAssets(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改低值易耗品台账';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						// 排除无用字段
						this.form = excludeParams(this.form, this.$exclude);
						updateFixedAssets(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addFixedAssets(this.form).then(response => {
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
				.confirm('是否确认删除低值易耗品台账编号为"' + ids + '"的数据项？')
				.then(function () {
					return delFixedAssets(ids);
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
				'system/fixedassets/export',
				{
					...this.queryParams
				},
				`低值易耗_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
