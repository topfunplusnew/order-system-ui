<template>
	<div class="app-container">
		<!--    搜索框-->
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="操作时间" prop="beginTime">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd HH:mm:ss" type="daterange" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>
			<el-form-item label="对方公司类型" prop="companyType">
				<el-select v-model="queryParams.companyType" placeholder="请选择对方公司类型" clearable style="width: 180px">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="对方公司" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入对方公司" clearable @keyup.enter.native="handleQuery" />
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
				<el-button v-hasPermi="['system:balanceaccounts:add']" type="danger" size="mini" @click="handleAdd">新增平账信息</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" tableName="balanceaccounts-columns">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:balanceaccounts:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="BalanceAccountsList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column label="ID" align="center" prop="id" width="80" show-overflow-tooltip />
			<el-table-column v-if="columns[0].visible" label="操作时间" align="center" prop="operateDate" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="金额" align="center" prop="moneyAmount" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="对方公司" align="center" prop="companyName" show-overflow-tooltip />
			<el-table-column label="对方公司类型" align="center" prop="companyType" v-if="columns[3].visible" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[4].visible" label="备注" align="center" prop="comments" show-overflow-tooltip />
			<el-table-column v-if="columns[5] && columns[5].visible" label="新增时间" align="center" prop="addtime" width="170" show-overflow-tooltip />
			<el-table-column v-if="columns[6] && columns[6].visible" label="最后修改时间" align="center" prop="updateTime" width="170" show-overflow-tooltip />
			<el-table-column v-if="columns[7] && columns[7].visible" label="最后修改人" align="center" prop="updateByUserName" width="120" show-overflow-tooltip />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:balanceaccounts:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
					<el-button v-hasPermi="['system:balanceaccounts:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改平账信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="700px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="120px">
				<el-form-item label="操作时间" prop="operateDate">
					<el-date-picker v-model="form.operateDate" type="datetime" placeholder="选择操作时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<el-form-item label="金额" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
				</el-form-item>
				<el-form-item label="对方公司类型(请确认)">
					<el-select v-model="form.companyType" placeholder="请选择">
						<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
					</el-select>
					<span style="color: #1c84c6; font-size: 12px">请注意选择正确的对方公司类型!</span>
				</el-form-item>
				<el-form-item label="对方公司" prop="companyName">
					<el-row>
						<el-col :span="12">
							<el-input v-model="form.companyName" placeholder="请输入对方公司" />
						</el-col>
						<SearchOption :limit-info="{ companyType: form.companyType }" :get-data="listCompany" query-info="companyName" query-label="公司名称" :query-name="queryCompanyName" @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
							<template #table-columns>
								<el-table-column :label="form.companyType" align="center" prop="companyName" />
								<el-table-column label="对方公司类型" align="center" prop="companyType" />
								<el-table-column label="老板姓名" align="center" prop="leader" />
								<el-table-column label="老板电话" align="center" prop="leaderTel" />
								<el-table-column label="区域" align="center" prop="region" />
								<el-table-column label="销售经理" align="center" prop="salesManager" />
							</template>
						</SearchOption>
					</el-row>
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    点击公司查询的弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="公司查询" :visible.sync="companyDialogVisible" width="40%">
			<el-row>
				<el-table :data="companyInfoList" border style="width: 100%">
					<el-table-column label="公司名称" align="center" prop="companyName" />
					<el-table-column label="公司id" align="center" prop="id" />
					<el-table-column fixed="right" label="操作" width="100">
						<template slot-scope="scope">
							<el-button type="danger" size="mini" @click="commitCompanyInfo(scope.row)">确定</el-button>
						</template>
					</el-table-column>
				</el-table>
			</el-row>
			<span slot="footer" class="dialog-footer">
				<el-button @click="companyDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="companyDialogVisible = false">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { listBalanceAccounts, getBalanceAccounts, delBalanceAccounts, addBalanceAccounts, updateBalanceAccounts } from '@/api/system/BalanceAccounts';
import company from '@/views/system/company/index.vue';
import { mapGetters } from 'vuex';
import { addDateRange, parseTime } from '@/utils/ruoyi';
import { excludeParams } from '@/api/tool/exclude';
import SearchOption from '../../../components/SearchOption.vue';
import { listCompany } from '../../../api/system/company';

export default {
	name: 'Balanceaccounts',
	components: { SearchOption },
	computed: {
		company() {
			return company;
		},
		...mapGetters(['tempbalanceaccountsList'])
	},
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
			// 平账信息表格数据
			BalanceAccountsList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			dateRange: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				operateDate: null,
				moneyAmount: null,
				companyName: null,
				companyID: null,
				companyType: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 搜索参数
			timesQuery: {
				beginTime: '',
				endTime: ''
			},
			// 表单参数
			// 表单参数
			form: {
				companyType: '客户', // 添加这行设置默认值
				operateDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}') // 默认今天
			},

			columns: [
				{ key: 0, label: `操作时间`, visible: true },
				{ key: 1, label: `金额`, visible: true },
				{ key: 2, label: `对方公司`, visible: true },
				{ key: 3, label: `对方公司类型`, visible: true },
				{ key: 4, label: `备注`, visible: true },
				{ key: 5, label: `新增时间`, visible: true },
				{ key: 6, label: `最后修改时间`, visible: true },
				{ key: 7, label: `最后修改人`, visible: true }
			],
			// 表单校验
			rules: {
				// 添加校验信息
				operateDate: [
					{
						required: true,
						message: '操作时间不能为空',
						trigger: 'blur'
					}
				],

				moneyAmount: [
					{
						required: true,
						message: '金额不能为空',
						trigger: 'blur'
					},
					// 数字校验（支持负数，最多两位小数）
					{
						validator: (rule, value, callback) => {
							if (!/^-?\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('请输入正确的金额'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				companyName: [
					{
						required: true,
						message: '对方公司不能为空',
						trigger: 'blur'
					}
				],
				companyType: [
					{
						required: true,
						message: '对方公司类型不能为空',
						trigger: 'blur'
					}
				]
			},
			// 点击公司的弹窗
			companyDialogVisible: false,
			// 公司信息
			companyInfoList: [],
			queryCompanyName: '',

			// 对方公司类型
			options: [
				{
					value: '客户',
					label: '客户'
				},
				{
					value: '供应商',
					label: '供应商'
				}
			],
			value: '客户'
		};
	},
	// 展示与隐藏
	created() {
		this.getList();
		// 获取平账信息
		this.$store.dispatch('balanceaccounts/getbalanceaccountsList');
		// 控制隐藏列
	},
	methods: {
		listCompany,
		// 自动填充
		handleUpdateCompanyName(val) {
			this.queryCompanyName = val;
		},
		handleCommitBackCompany(val) {
			this.form.companyName = val.companyName;
			this.form.companyID = val.id;
		},
		// 点击确认公司
		commitCompanyInfo(row) {
			this.form.companyName = row.companyName;
			this.form.companyID = row.id;
			this.companyDialogVisible = false;
		},
		/* 打印信息*/
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		/** 查询平账信息列表 */
		getList() {
			this.loading = true;
			listBalanceAccounts(addDateRange(this.queryParams, this.dateRange)).then(response => {
				this.BalanceAccountsList = response.rows;
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
				operateDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'), // 默认今天
				moneyAmount: null,
				companyName: null,
				companyID: null,
				companyType: '客户', // 默认客户
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
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
			this.title = '添加平账信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getBalanceAccounts(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改平账信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form.operateDate = parseTime(this.form.operateDate, '{y}-{m}-{d} {h}:{i}:{s}');
						this.form = excludeParams(this.form, this.$exclude);
						updateBalanceAccounts(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form.operateDate = parseTime(this.form.operateDate, '{y}-{m}-{d} {h}:{i}:{s}');
						this.form = excludeParams(this.form, this.$exclude);
						addBalanceAccounts(this.form).then(response => {
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
				.confirm('是否确认删除平账信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delBalanceAccounts(ids);
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
				'system/BalanceAccounts/export',
				{
					...this.queryParams
				},
				`平账记录_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
