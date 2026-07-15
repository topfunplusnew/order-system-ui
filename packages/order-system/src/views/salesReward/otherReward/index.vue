<template>
	<div class="app-container">
		<div class="fixed-top-section">
			<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="100px" class="form-container">
				<el-form-item label="奖励接收人" prop="rewardReceiver">
					<el-input v-model="queryParams.rewardReceiver" placeholder="请输入奖励接收人" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
				<el-form-item label="审核状态" prop="auditState">
					<el-select v-model="queryParams.auditState" placeholder="请选择审核状态" clearable>
						<el-option label="未审核" value="未审核" />
						<el-option label="已审核" value="已审核" />
					</el-select>
				</el-form-item>
				<el-form-item label="支付状态" prop="paymentStatus">
					<el-select v-model="queryParams.paymentStatus" placeholder="请选择支付状态" clearable>
						<el-option label="已支付" value="PAID" />
						<el-option label="未支付" value="UNPAID" />
					</el-select>
				</el-form-item>
				<el-form-item label="奖励日期">
					<el-date-picker v-model="daterangeRewardDate" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" clearable />
				</el-form-item>
				<el-form-item label="添加时间">
					<el-date-picker v-model="daterangeCreateTime" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" clearable />
				</el-form-item>
				<el-form-item>
					<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
					<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
				</el-form-item>
			</el-form>
			<el-row :gutter="10" class="mb8">
				<el-col :span="1.5">
					<el-button v-hasPermi="['system:salesReward:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
				</el-col>
				<el-col :span="1.5">
					<el-button v-hasPermi="['system:salesReward:edit']" type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate">修改</el-button>
				</el-col>
				<el-col :span="1.5">
					<el-button v-hasPermi="['system:salesReward:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
				</el-col>
				<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" table-name="views-sales-reward-other-reward-index-columns">
					<template #print>
						<el-col :span="1.5">
							<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
						</el-col>
					</template>
					<template #export>
						<el-col :span="1.5">
							<el-button v-hasPermi="['system:salesReward:export']" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
						</el-col>
					</template>
				</right-toolbar>
			</el-row>
		</div>

		<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" :data="salesRewardList" show-summary :summary-method="getSummaries" border size="mini" :cell-style="() => ({ padding: '1px' })" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" width="80" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="奖励接收人" align="center" prop="rewardReceiver" min-width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="奖励原因" align="center" prop="rewardReason" min-width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="奖励金额" align="center" prop="rewardAmount" width="120" show-overflow-tooltip>
				<template #default="scope">{{ formatAmount(scope.row.rewardAmount) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[4].visible" label="实际支付金额" align="center" prop="paymentAmount" width="120" show-overflow-tooltip>
				<template #default="scope">{{ formatAmount(scope.row.paymentAmount) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[5].visible" label="奖励日期" align="center" prop="rewardDate" width="120" show-overflow-tooltip>
				<template #default="scope">{{ scope.row.rewardDate ? parseTime(scope.row.rewardDate, '{y}-{m}-{d}') : '-' }}</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="审核状态" align="center" prop="auditState" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tag :type="scope.row.auditState === '已审核' ? 'success' : 'warning'">{{ scope.row.auditState }}</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[7].visible" label="审核人" align="center" prop="auditUserName" width="100" show-overflow-tooltip>
				<template #default="scope">{{ scope.row.auditUserName || '-' }}</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="备注" align="center" prop="remark" min-width="160" show-overflow-tooltip>
				<template #default="scope">{{ scope.row.remark || '-' }}</template>
			</el-table-column>
			<el-table-column v-if="columns[9].visible" label="添加时间" align="center" prop="createTime" width="170" show-overflow-tooltip>
				<template #default="scope">{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="操作" align="center" class-name="small-padding fixed-width" width="340" fixed="right">
				<template #default="scope">
					<el-button v-hasPermi="['system:salesReward:edit']" size="mini" type="text" icon="el-icon-edit" :disabled="scope.row.auditState === '已审核'" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:salesReward:supplement']" size="mini" type="text" icon="el-icon-edit-outline" :disabled="isSupplementDisabled(scope.row)" @click="handleSupplement(scope.row)">补充信息</el-button>
					<el-button v-if="scope.row.auditState === '未审核'" v-hasPermi="['system:salesReward:audit']" size="mini" type="text" icon="el-icon-check" @click="handleAudit(scope.row, true)">审核</el-button>
					<el-button v-else v-hasPermi="['system:salesReward:audit']" size="mini" type="text" icon="el-icon-close" @click="handleAudit(scope.row, false)">取消审核</el-button>
					<el-button v-hasPermi="['system:salesReward:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="640px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="120px">
				<el-form-item label="奖励接收人" prop="rewardReceiver">
					<el-input v-model="form.rewardReceiver" placeholder="请输入奖励接收人" />
				</el-form-item>
				<el-form-item label="奖励原因" prop="rewardReason">
					<el-input v-model="form.rewardReason" placeholder="请输入奖励原因" />
				</el-form-item>
				<el-form-item label="奖励金额" prop="rewardAmount">
					<el-input v-model="form.rewardAmount" placeholder="请输入奖励金额" @blur="formatAmountField('rewardAmount')" />
				</el-form-item>
				<el-form-item label="审核状态" prop="auditState">
					<el-select v-model="form.auditState" placeholder="请选择审核状态" style="width: 100%">
						<el-option label="未审核" value="未审核" />
						<el-option label="已审核" value="已审核" />
					</el-select>
				</el-form-item>
				<el-form-item label="备注" prop="remark">
					<el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" />
				</el-form-item>
				<el-form-item label="添加时间" prop="createTime">
					<el-date-picker v-model="form.createTime" clearable type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择添加时间" style="width: 100%" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="补充信息" :visible.sync="supplementOpen" width="500px" append-to-body>
			<el-form ref="supplementForm" :model="supplementForm" :rules="supplementRules" label-width="150px">
				<el-form-item label="实际支付金额" prop="paymentAmount">
					<el-input v-model="supplementForm.paymentAmount" placeholder="请输入实际支付金额" @blur="formatSupplementAmountField('paymentAmount')" />
				</el-form-item>
				<el-form-item label="奖励日期" prop="rewardDate">
					<el-date-picker v-model="supplementForm.rewardDate" clearable type="date" value-format="yyyy-MM-dd" placeholder="请选择奖励日期" style="width: 100%" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitSupplementForm">确 定</el-button>
				<el-button @click="cancelSupplement">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listSalesReward, getSalesReward, delSalesReward, addSalesReward, updateSalesReward, auditSalesReward, supplementSalesReward } from '@/api/salesReward/salesReward';
import { parseTime } from '@/utils/ruoyi';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { add, bignumber, format } from 'mathjs';

const INCENTIVE_TYPE = '其他奖励';

export default {
	name: 'OtherReward',
	mixins: [mixin_printHTML],
	data() {
		const amountValidator =
			(message, required = false) =>
			(rule, value, callback) => {
				if (value === null || value === undefined || value === '') {
					required ? callback(new Error(message)) : callback();
					return;
				}
				const numStr = String(value).trim();
				if (!/^-?(\d+\.?\d{0,2}|\.\d{1,2})$/.test(numStr)) {
					callback(new Error('只能输入数字，可以输入负数，小数点最多保留两位'));
					return;
				}
				callback();
			};

		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			salesRewardList: [],
			title: '',
			open: false,
			supplementOpen: false,
			supplementForm: {},
			daterangeRewardDate: [],
			daterangeCreateTime: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				incentiveType: INCENTIVE_TYPE,
				rewardReceiver: null,
				auditState: null,
				paymentStatus: null,
				rewardDateBegin: null,
				rewardDateEnd: null,
				createTimeBegin: null,
				createTimeEnd: null
			},
			form: {},
			rules: {
				rewardReceiver: [{ required: true, message: '请输入奖励接收人', trigger: 'blur' }],
				rewardReason: [{ required: true, message: '请输入奖励原因', trigger: 'blur' }],
				rewardAmount: [{ validator: amountValidator('请输入奖励金额', true), trigger: 'blur' }],
				auditState: [{ required: true, message: '请选择审核状态', trigger: 'change' }]
			},
			supplementRules: {
				paymentAmount: [{ validator: amountValidator('请输入实际支付金额'), trigger: 'blur' }],
				rewardDate: [
					{
						validator: (rule, value, callback) => {
							if (!value && !this.supplementForm.paymentAmount) {
								callback(new Error('请至少填写支付金额或奖励日期其中一个'));
								return;
							}
							callback();
						},
						trigger: 'change'
					}
				]
			},
			columns: [
				{ key: 0, label: 'ID', visible: true },
				{ key: 1, label: '奖励接收人', visible: true },
				{ key: 2, label: '奖励原因', visible: true },
				{ key: 3, label: '奖励金额', visible: true },
				{ key: 4, label: '实际支付金额', visible: true },
				{ key: 5, label: '奖励日期', visible: true },
				{ key: 6, label: '审核状态', visible: true },
				{ key: 7, label: '审核人', visible: true },
				{ key: 8, label: '备注', visible: true },
				{ key: 9, label: '添加时间', visible: true },
				{ key: 10, label: '操作', visible: true }
			]
		};
	},
	created() {
		this.getList();
	},
	methods: {
		parseTime,
		formatAmount(value) {
			if (value === null || value === undefined || value === '') {
				return '-';
			}
			const num = parseFloat(value);
			return isNaN(num) ? value : num.toFixed(2);
		},
		formatAmountValue(value) {
			if (value === null || value === undefined || value === '') {
				return '';
			}
			const num = parseFloat(value);
			return isNaN(num) ? value : parseFloat(num.toFixed(2));
		},
		formatAmountField(fieldName) {
			if (this.form[fieldName] !== null && this.form[fieldName] !== undefined && this.form[fieldName] !== '') {
				this.$set(this.form, fieldName, this.formatAmountValue(this.form[fieldName]));
			}
		},
		formatSupplementAmountField(fieldName) {
			if (this.supplementForm[fieldName] !== null && this.supplementForm[fieldName] !== undefined && this.supplementForm[fieldName] !== '') {
				this.$set(this.supplementForm, fieldName, this.formatAmountValue(this.supplementForm[fieldName]));
			}
		},
		getSummaries({ columns = [], data = [] }) {
			const sums = (columns || []).map(() => '');
			const firstDataColumnIndex = columns.findIndex(col => col.property);
			sums[firstDataColumnIndex > -1 ? firstDataColumnIndex : 0] = '合计';
			const sumByProp = prop =>
				(data || []).reduce((acc, row) => {
					const num = Number(row?.[prop]);
					return add(acc, bignumber(isNaN(num) ? 0 : num));
				}, bignumber(0));
			const rewardIdx = columns.findIndex(col => col.property === 'rewardAmount');
			if (rewardIdx > -1) sums[rewardIdx] = format(sumByProp('rewardAmount'), { notation: 'fixed', precision: 2 });
			const paymentIdx = columns.findIndex(col => col.property === 'paymentAmount');
			if (paymentIdx > -1) sums[paymentIdx] = format(sumByProp('paymentAmount'), { notation: 'fixed', precision: 2 });
			return sums;
		},
		isSupplementDisabled(row) {
			if (row.auditState !== '已审核') {
				return false;
			}
			const hasPaymentAmount = row.paymentAmount != null && row.paymentAmount !== '';
			const hasRewardDate = row.rewardDate != null && row.rewardDate !== '';
			return hasPaymentAmount || hasRewardDate;
		},
		applyDateRangeParams(target) {
			if (this.daterangeRewardDate && this.daterangeRewardDate.length === 2) {
				target.rewardDateBegin = this.daterangeRewardDate[0];
				target.rewardDateEnd = this.daterangeRewardDate[1];
			} else {
				target.rewardDateBegin = null;
				target.rewardDateEnd = null;
			}
			if (this.daterangeCreateTime && this.daterangeCreateTime.length === 2) {
				target.createTimeBegin = this.daterangeCreateTime[0];
				target.createTimeEnd = this.daterangeCreateTime[1];
			} else {
				target.createTimeBegin = null;
				target.createTimeEnd = null;
			}
			return target;
		},
		getList() {
			this.loading = true;
			listSalesReward(this.applyDateRangeParams(this.queryParams))
				.then(response => {
					this.salesRewardList = response.rows || [];
					this.total = response.total || 0;
				})
				.finally(() => {
					this.loading = false;
				});
		},
		reset() {
			this.form = {
				id: null,
				incentiveType: INCENTIVE_TYPE,
				rewardReceiver: null,
				rewardReason: null,
				rewardAmount: null,
				auditState: '未审核',
				remark: null,
				createTime: null
			};
			this.resetForm('form');
		},
		cancel() {
			this.open = false;
			this.reset();
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.daterangeRewardDate = [];
			this.daterangeCreateTime = [];
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加其他奖励';
		},
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids[0];
			getSalesReward(id).then(response => {
				this.form = {
					...response.data,
					incentiveType: INCENTIVE_TYPE
				};
				this.open = true;
				this.title = '修改其他奖励';
			});
		},
		handleSupplement(row) {
			this.supplementForm = {
				id: row.id,
				paymentAmount: row.paymentAmount || null,
				rewardDate: row.rewardDate || null
			};
			this.supplementOpen = true;
		},
		cancelSupplement() {
			this.supplementOpen = false;
			this.supplementForm = {};
			this.resetForm('supplementForm');
		},
		submitSupplementForm() {
			this.$refs['supplementForm'].validate(valid => {
				if (!valid) return;
				if (!this.supplementForm.paymentAmount && !this.supplementForm.rewardDate) {
					this.$message.error('请至少填写支付金额或奖励日期其中一个');
					return;
				}
				supplementSalesReward(this.supplementForm).then(() => {
					this.$modal.msgSuccess('补充信息成功');
					this.supplementOpen = false;
					this.getList();
				});
			});
		},
		handleAudit(row, approved) {
			const action = approved ? '审核通过' : '取消审核';
			this.$modal
				.confirm(`是否确认${action}该奖励？`)
				.then(() => auditSalesReward(row.id, approved))
				.then(() => {
					this.getList();
					this.$modal.msgSuccess(`${action}成功`);
				})
				.catch(() => {});
		},
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (!valid) return;
				const submitData = {
					...this.form,
					incentiveType: INCENTIVE_TYPE
				};
				const request = submitData.id != null ? updateSalesReward(submitData) : addSalesReward(submitData);
				request.then(() => {
					this.$modal.msgSuccess(submitData.id != null ? '修改成功' : '新增成功');
					this.open = false;
					this.getList();
				});
			});
		},
		handleDelete(row) {
			const ids = row.id || this.ids.join(',');
			this.$modal
				.confirm('是否确认删除奖励编号为"' + ids + '"的数据项？')
				.then(() => delSalesReward(ids))
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		handleExport() {
			const exportParams = this.applyDateRangeParams({ ...this.queryParams });
			this.download('system/salesReward/export', exportParams, `其他奖励_${new Date().getTime()}.xlsx`);
		}
	}
};
</script>
