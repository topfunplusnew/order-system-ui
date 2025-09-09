<template>
	<div class="app-container">
		<!-- 搜索条件 -->
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="100px" class="form-container">
			<el-form-item label="保证金公司">
				<el-input v-model="queryParams.depositCompany" placeholder="请输入保证金公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="保证金类型">
				<el-select v-model="queryParams.type" placeholder="请选择保证金类型" clearable>
					<el-option v-for="option in depositOptions" :key="option.value" :label="option.label" :value="option.value" />
				</el-select>
			</el-form-item>
			<el-form-item label="对象类型">
				<el-select v-model="queryParams.targetType" placeholder="请选择对象类型" clearable>
					<el-option label="员工" value="员工" />
					<el-option label="客户" value="客户" />
					<el-option label="供应商" value="供应商" />
					<el-option label="其他" value="其他" />
				</el-select>
			</el-form-item>
			<el-form-item label="对象名称">
				<el-input v-model="queryParams.target" placeholder="请输入对象名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="收取时间">
				<el-date-picker
					v-model="queryParams.depositDate"
					type="daterange"
					range-separator="至"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
					value-format="yyyy-MM-dd"
					@change="handleDateChange"
				/>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<!-- 工具栏 -->
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">批量删除</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="success" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="tableColumns" @queryTable="getList" @column-change="handleColumnChange"></right-toolbar>
		</el-row>

		<!-- 表格 -->
		<el-table v-loading="loading" :data="depositMoneyList" border size="mini" :cell-style="cellStyle" @selection-change="handleSelectionChange" class="table-container">
			<CustomTableColumn type="selection" width="55" align="center" />
			<CustomTableColumn v-for="column in visibleColumns" :key="column.key" v-bind="getColumnProps(column)" />
			<CustomTableColumn label="操作" align="center" class-name="small-padding fixed-width" width="200">
				<template slot-scope="scope">
					<el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
					<el-button size="mini" type="text" icon="el-icon-money" @click="handleRefund(scope.row)">退款管理</el-button>
				</template>
			</CustomTableColumn>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 退款管理弹窗 -->
		<el-dialog v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" title="退款管理" :visible.sync="refundDialogVisible" width="80%" append-to-body>
			<div class="mb8">
				<el-button type="primary" size="mini" @click="handleAddRefund">新增退款</el-button>
			</div>
			<el-table v-loading="refundLoading" :data="refundList" border size="mini">
				<CustomTableColumn prop="refundDate" label="退款日期" width="120" />
				<CustomTableColumn prop="accountsName" label="收款账户" width="150" />
				<CustomTableColumn prop="bankNo" label="收款账号" width="180" />
				<CustomTableColumn prop="moneyAmount" label="退款金额" width="120" align="right" />
				<CustomTableColumn prop="comments" label="备注" />
				<CustomTableColumn prop="UserName" label="操作人员" width="100" />
				<CustomTableColumn label="操作" align="center" width="150">
					<template slot-scope="scope">
						<el-button size="mini" type="text" @click="handleUpdateRefund(scope.row)">修改</el-button>
						<el-button size="mini" type="text" @click="handleDeleteRefund(scope.row)">删除</el-button>
					</template>
				</CustomTableColumn>
			</el-table>
		</el-dialog>

		<!-- 退款表单弹窗 -->
		<el-dialog
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			:title="refundDialogTitle"
			:visible.sync="refundFormVisible"
			width="50%"
			append-to-body
		>
			<el-form ref="refundForm" :model="refundForm" :rules="refundRules" label-width="120px" size="mini">
				<el-form-item label="退款日期" prop="refundDate">
					<el-date-picker v-model="refundForm.refundDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择退款日期" style="width: 100%" />
				</el-form-item>
				<el-form-item label="收款账户" prop="accountsName">
					<el-input v-model="refundForm.accountsName" placeholder="请输入收款账户" />
				</el-form-item>
				<el-form-item label="收款账号" prop="bankNo">
					<el-input v-model="refundForm.bankNo" placeholder="请输入收款账号" />
				</el-form-item>
				<el-form-item label="退款金额" prop="moneyAmount">
					<el-input v-model="refundForm.moneyAmount" placeholder="请输入退款金额" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="refundForm.comments" type="textarea" placeholder="请输入备注" :rows="3" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button @click="cancelRefund">取 消</el-button>
				<el-button type="primary" @click="submitRefundForm">确 定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import {
	listDepositMoney,
	getDepositMoney,
	addDepositMoney,
	updateDepositMoney,
	delDepositMoney,
	exportDepositMoney,
	addDepositRefund,
	updateDepositRefund,
	delDepositRefund,
	getDepositRefund,
	getDepositRefundByMainId
} from '@/api/system/depositMoney';
import { listBankAccount } from '@/api/system/bankAccount';
import { DEPOSIT_OPTIONS } from '@/api/tool/enums';
import { validateAmount } from '@/api/tool';
import { createConfigManager } from '@/utils/configManager';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { tableColumnMixin } from '@/mixins/tableColumnMixin';
import columnConfig from './base/columns.js';
import DepositMoneyForm from './base/DepositMoneyForm.vue';

export default {
	name: 'DepositMoney',
	mixins: [common_dialog, tableColumnMixin],
	computed: {
		/** 可见列 */
		visibleColumns() {
			return this.tableColumns.filter(column => column.visible);
		}
	},
	data() {
		return {
			// 配置管理器
			configManager: null,
			// 表格列配置
			tableColumns: [],
			// 保证金类型选项
			depositOptions: DEPOSIT_OPTIONS,
			// 表格样式
			cellStyle: () => ({ padding: '1px' }),
			// 加载状态
			loading: true,
			refundLoading: false,
			// 显示搜索条件
			showSearch: true,
			// 选中数组
			ids: [],
			// 非单个禁用
			single: true,
			// 非多个禁用
			multiple: true,
			// 总条数
			total: 0,
			// 保证金收取信息表格数据
			depositMoneyList: [],
			// 弹出层标题
			dialogTitle: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				depositCompany: null,
				type: null,
				targetType: null,
				target: null,
				depositDate: null,
				reason: null,
				comments: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				depositCompany: [{ required: true, message: '保证金公司不能为空', trigger: 'blur' }],
				type: [{ required: true, message: '保证金类型不能为空', trigger: 'change' }],
				targetType: [{ required: true, message: '对象类型不能为空', trigger: 'change' }],
				target: [{ required: true, message: '对象名称不能为空', trigger: 'blur' }],
				moneyAmount: [
					{ required: true, message: '保证金金额不能为空', trigger: 'blur' },
					{ validator: validateAmount, trigger: 'blur' }
				],
				targetAccountsName: [{ required: true, message: '对方账户不能为空', trigger: 'blur' }],
				targetBankNo: [{ required: true, message: '对方账号不能为空', trigger: 'blur' }],
				selfAccountsName: [{ required: true, message: '我方收款账户不能为空', trigger: 'blur' }],
				selfBankNo: [{ required: true, message: '我方账号不能为空', trigger: 'blur' }],
				depositDate: [{ required: true, message: '收取时间不能为空', trigger: 'change' }],
				reason: [{ required: true, message: '事由不能为空', trigger: 'blur' }]
			},
			// 列显隐信息
			columns: [
				{ key: 0, label: '保证金公司', visible: true },
				{ key: 1, label: '保证金类型', visible: true },
				{ key: 2, label: '对象类型', visible: true },
				{ key: 3, label: '对象名称', visible: true },
				{ key: 4, label: '保证金金额', visible: true },
				{ key: 5, label: '未退款金额', visible: true },
				{ key: 6, label: '对方账户', visible: true },
				{ key: 7, label: '对方账号', visible: true },
				{ key: 8, label: '对方开户行', visible: true },
				{ key: 9, label: '我方收款账户', visible: true },
				{ key: 10, label: '我方账号', visible: true },
				{ key: 11, label: '我方开户行', visible: true },
				{ key: 12, label: '收取时间', visible: true },
				{ key: 13, label: '事由', visible: true },
				{ key: 14, label: '备注', visible: true },
				{ key: 15, label: '操作人员', visible: true }
			],
			// 退款相关
			refundDialogVisible: false,
			refundFormVisible: false,
			refundDialogTitle: '',
			currentRow: null,
			refundList: [],
			refundTotal: 0,
			refundQueryParams: {
				pageNum: 1,
				pageSize: 10
			},
			refundForm: {},
			refundRules: {
				refundDate: [{ required: true, message: '退款日期不能为空', trigger: 'change' }],
				moneyAmount: [
					{ required: true, message: '退款金额不能为空', trigger: 'blur' },
					{ validator: validateAmount, trigger: 'blur' }
				]
			},
			// 搜索控件本地变量
			queryBankOther: '',
			queryBankSelf: ''
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
			return 'depositMoney-columns';
		},

		// 处理列显隐变化
		handleColumnChange(changeInfo) {
			// 确保tableColumns数组中对应的列也被更新
			if (changeInfo.index >= 0 && changeInfo.index < this.tableColumns.length) {
				this.$set(this.tableColumns[changeInfo.index], 'visible', changeInfo.visible);
			}
		},

		// 获取默认表单数据
		getDefaultFormData() {
			return this.configManager ? this.configManager.getDefaultForm() : {};
		},

		/** 查询保证金收取信息列表 */
		getList() {
			this.loading = true;
			listDepositMoney(this.queryParams)
				.then(response => {
					this.depositMoneyList = response.rows;
					this.total = response.total;
					this.loading = false;
				})
				.catch(() => {
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
			this.queryParams = {
				pageNum: 1,
				pageSize: 10,
				depositCompany: null,
				type: null,
				targetType: null,
				target: null,
				depositDate: null,
				reason: null,
				comments: null
			};
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
			// 使用配置管理器获取默认表单数据
			const defaultForm = this.getDefaultFormData();

			this.openDialog(
				DepositMoneyForm,
				'添加保证金收取信息',
				'80%',
				{
					formData: defaultForm,
					isEdit: false,
					title: '添加保证金收取信息'
				},
				false
			);
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			const id = row.id || this.ids;
			getDepositMoney(id).then(response => {
				this.openDialog(
					DepositMoneyForm,
					'修改保证金收取信息',
					'80%',
					{
						formData: response.data,
						isEdit: true,
						title: '修改保证金收取信息'
					},
					false
				);
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateDepositMoney(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addDepositMoney(this.form).then(response => {
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
				.confirm('是否确认删除保证金收取信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delDepositMoney(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			exportDepositMoney(this.queryParams).then(response => {
				this.$download.excel(response, '保证金收取信息.xlsx');
			});
		},
		/** 表单重置 */
		reset() {
			this.form = {
				id: null,
				depositCompany: null,
				type: null,
				targetType: null,
				targetBankNoId: null,
				target: null,
				moneyAmount: null,
				unrefundedAmount: null,
				targetAccountsName: null,
				targetBankNo: null,
				targetBankName: null,
				selfAccountsName: null,
				selfBankNo: null,
				selfBankName: null,
				depositDate: null,
				reason: null,
				comments: null,
				depositRefundList: []
			};
			this.resetForm('form');
			this.queryBankOther = '';
			this.queryBankSelf = '';
		},
		/** 取消按钮 */
		cancel() {
			this.open = false;
			this.reset();
		},
		/** 日期范围选择处理 */
		handleDateChange(dates) {
			if (dates && dates.length === 2) {
				this.queryParams.beginDepositDate = dates[0];
				this.queryParams.endDepositDate = dates[1];
			} else {
				this.queryParams.beginDepositDate = null;
				this.queryParams.endDepositDate = null;
			}
		},
		/** 对象类型变化处理 */
		handleTargetTypeChange() {
			// 清空相关字段
			this.form.targetAccountsName = null;
			this.form.targetBankNo = null;
			this.form.targetBankName = null;
			this.queryBankOther = '';
		},
		/** 对方账户选择回调 */
		handleCommitBackOther(val) {
			this.form.targetBankNo = val.bankNo;
			this.form.targetBankName = val.bankName;
			this.form.targetAccountsName = val.acountsName;
		},
		/** 我方账户选择回调 */
		handleCommitBackSelf(val) {
			this.form.selfBankNo = val.bankNo;
			this.form.selfBankName = val.bankName;
			this.form.selfAccountsName = val.acountsName;
		},
		/** 退款管理 */
		handleRefund(row) {
			this.handleViewRefunds(row);
		},
		/** 查看退款记录 */
		handleViewRefunds(row) {
			this.currentRow = row;
			this.refundDialogVisible = true;
			this.getRefundList();
		},
		/** 获取退款列表 */
		getRefundList() {
			if (!this.currentRow) return;
			this.refundLoading = true;
			getDepositRefundByMainId(this.currentRow.id)
				.then(response => {
					this.refundList = response.rows || response.data || [];
					this.refundTotal = response.total || this.refundList.length;
					this.refundLoading = false;
				})
				.catch(() => {
					this.refundLoading = false;
				});
		},
		/** 新增退款 */
		handleAddRefund(row) {
			this.currentRow = row;
			this.resetRefundForm();
			this.refundForm.depositMoneyId = row.id;
			this.refundDialogTitle = '添加退款信息';
			this.refundFormVisible = true;
		},
		/** 修改退款 */
		handleUpdateRefund(row) {
			this.resetRefundForm();
			getDepositRefund(row.id).then(response => {
				this.refundForm = response.data;
				this.refundDialogTitle = '修改退款信息';
				this.refundFormVisible = true;
			});
		},
		/** 删除退款 */
		handleDeleteRefund(row) {
			this.$modal
				.confirm('是否确认删除该退款记录？')
				.then(function () {
					return delDepositRefund(row.id);
				})
				.then(() => {
					this.getRefundList();
					this.getList(); // 刷新主表以更新未退款金额
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 提交退款表单 */
		submitRefundForm() {
			this.$refs['refundForm'].validate(valid => {
				if (valid) {
					if (this.refundForm.id != null) {
						updateDepositRefund(this.refundForm).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.refundFormVisible = false;
							this.getRefundList();
							this.getList(); // 刷新主表以更新未退款金额
						});
					} else {
						addDepositRefund(this.refundForm).then(response => {
							this.$modal.msgSuccess('新增成功');
							this.refundFormVisible = false;
							this.getRefundList();
							this.getList(); // 刷新主表以更新未退款金额
						});
					}
				}
			});
		},
		/** 取消退款 */
		cancelRefund() {
			this.refundFormVisible = false;
			this.resetRefundForm();
		},
		/** 重置退款表单 */
		resetRefundForm() {
			this.refundForm = {
				id: null,
				depositMoneyId: null,
				refundDate: null,
				accountsName: null,
				bankNo: null,
				moneyAmount: null,
				comments: null,
				badDebtFlag: '否'
			};
			this.resetForm('refundForm');
		},
		/** 列显隐控制 */
		colVisible(index) {
			return this.columns[index] && this.columns[index].visible;
		},
		/** 获取表格列属性 */
		getColumnProps(column) {
			return {
				prop: column.prop,
				label: column.label,
				align: column.align || 'center',
				width: column.width,
				showOverflowTooltip: column.showOverflowTooltip
			};
		},
		/** 银行账户搜索方法 */
		listBankAccount
	}
};
</script>

<style scoped>
.mb8 {
	margin-bottom: 8px;
}
</style>
