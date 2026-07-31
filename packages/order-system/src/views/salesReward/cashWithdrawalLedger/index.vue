<!-- 用户需求：基于对接文档、原始 Excel 和 Apifox 接口新增转 、支现金台账页面，日期精确到日、账户手填，附件与审核参考车辆派出管理。实际改动：实现查询、十列表格、CRUD、双附件分类、审核冻结、批量删除和筛选导出。 -->
<template>
	<div class="app-container cash-withdrawal-ledger">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="92px">
			<el-form-item label="取现日期">
				<el-date-picker v-model="dateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd" clearable />
			</el-form-item>
			<el-form-item label="取现账户" prop="accountInfo">
				<el-input v-model.trim="queryParams.accountInfo" placeholder="请输入账户名称或账号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="经办人" prop="handlerName">
				<el-input v-model.trim="queryParams.handlerName" placeholder="请输入经办人" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="取现用途" prop="purpose">
				<el-input v-model.trim="queryParams.purpose" placeholder="请输入取现用途" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="审核状态" prop="auditState">
				<el-select v-model="queryParams.auditState" placeholder="请选择" clearable>
					<el-option label="未审核" value="未审核" />
					<el-option label="已审核" value="已审核" />
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5"><el-button v-hasPermi="['system:cashwithdrawalledger:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button></el-col>
			<el-col :span="1.5"><el-button v-hasPermi="['system:cashwithdrawalledger:edit']" type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate()">修改</el-button></el-col>
			<el-col :span="1.5"><el-button v-hasPermi="['system:cashwithdrawalledger:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete()">删除</el-button></el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" tableName="cash-withdrawal-ledger-columns">
				<template #export>
					<el-col :span="1.5"><el-button v-hasPermi="['system:cashwithdrawalledger:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" /></el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table v-loading="loading" v-horizontal-scroll="'always'" border size="mini" :data="ledgerList" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="48" align="center" fixed="left" />
			<el-table-column v-if="columns[0].visible" label="取现日期" prop="withdrawalDate" align="center" width="110" />
			<el-table-column v-if="columns[1].visible" label="取现金额" prop="amount" align="right" min-width="120">
				<template slot-scope="scope">{{ formatAmount(scope.row.amount) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="取现账户名称+账号后5位数" prop="accountInfo" align="left" min-width="230" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="取现审批单、取现小票" align="center" width="170">
				<template slot-scope="scope">
					<CheckFiles :attachmentList="scope.row.attachmentList || []" flag="withdrawalProof" :is-upload="scope.row.auditState !== '已审核' && checkPermi(['system:cashwithdrawalledger:edit'])" @needToUpdate="files => handleRowAttachments(files, scope.row)" />
				</template>
			</el-table-column>
			<el-table-column v-if="columns[4].visible" label="取现经办人" prop="handlerName" align="center" min-width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="取现用途" prop="purpose" align="left" min-width="170" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="其他附件" align="center" width="100">
				<template slot-scope="scope">
					<CheckFiles :attachmentList="scope.row.attachmentList || []" flag="otherAttachment" :is-upload="scope.row.auditState !== '已审核' && checkPermi(['system:cashwithdrawalledger:edit'])" @needToUpdate="files => handleRowAttachments(files, scope.row)" />
				</template>
			</el-table-column>
			<el-table-column v-if="columns[7].visible" label="审核状态" prop="auditState" align="center" width="190">
				<template slot-scope="scope">
					<el-switch v-if="checkPermi(['system:cashwithdrawalledger:audit'])" :value="scope.row.auditState === '已审核'" active-text="已审核" inactive-text="未审核" @change="approved => handleAudit(scope.row, approved)" />
					<el-tag v-else :type="scope.row.auditState === '已审核' ? 'success' : 'warning'">{{ scope.row.auditState || '未审核' }}</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="审核人" prop="auditUserName" align="center" min-width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="备注" prop="remark" align="left" min-width="150" show-overflow-tooltip />
			<el-table-column label="操作" align="center" fixed="right" width="150">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:cashwithdrawalledger:edit']" type="text" size="mini" icon="el-icon-edit" :disabled="scope.row.auditState === '已审核'" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:cashwithdrawalledger:remove']" type="text" size="mini" icon="el-icon-delete" :disabled="scope.row.auditState === '已审核'" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog :title="title" :visible.sync="open" width="760px" append-to-body :close-on-click-modal="false" @closed="clearUploaders">
			<el-form ref="form" :model="form" :rules="rules" label-width="150px">
				<el-row :gutter="18">
					<el-col :span="12">
						<el-form-item label="取现日期" prop="withdrawalDate"><el-date-picker v-model="form.withdrawalDate" type="date" value-format="yyyy-MM-dd" placeholder="选择取现日期" style="width: 100%" /></el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="取现金额" prop="amount"><el-input v-model.trim="form.amount" placeholder="最多20位整数、8位小数" /></el-form-item>
					</el-col>
				</el-row>
				<el-form-item label="取现账户名称及账号" prop="accountInfo"><el-input v-model.trim="form.accountInfo" maxlength="255" show-word-limit placeholder="请手动输入账户名称及账号信息" /></el-form-item>
				<el-row :gutter="18">
					<el-col :span="12">
						<el-form-item label="取现经办人" prop="handlerName"><el-input v-model.trim="form.handlerName" maxlength="100" show-word-limit /></el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="审核状态"><el-input :value="form.auditState || '未审核'" disabled /></el-form-item>
					</el-col>
				</el-row>
				<el-form-item label="取现用途" prop="purpose"><el-input v-model.trim="form.purpose" type="textarea" :rows="3" maxlength="500" show-word-limit /></el-form-item>
				<el-form-item label="备注" prop="remark"><el-input v-model.trim="form.remark" type="textarea" :rows="2" maxlength="500" show-word-limit /></el-form-item>
				<el-form-item label="取现审批单、取现小票"><UploadFilesButton ref="withdrawalProofUpload" flag="withdrawalProof" :initial-attachments="attachmentGroups.withdrawalProof" @files-updated="handleAttachmentFilesUpdated" /></el-form-item>
				<el-form-item label="其他附件"><UploadFilesButton ref="otherAttachmentUpload" flag="otherAttachment" :initial-attachments="attachmentGroups.otherAttachment" @files-updated="handleAttachmentFilesUpdated" /></el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="open = false">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import CheckFiles from '@/components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import { checkPermi } from '@/utils/permission';
import { saveAs } from 'file-saver';
import { addCashWithdrawalLedger, auditCashWithdrawalLedger, delCashWithdrawalLedger, exportCashWithdrawalLedger, getCashWithdrawalLedger, listCashWithdrawalLedger, replaceCashWithdrawalLedgerAttachments, updateCashWithdrawalLedger } from '@/api/salesReward/cashWithdrawalLedger';
import { buildCashWithdrawalExportParams, buildCashWithdrawalPayload, buildCashWithdrawalQuery, groupCashWithdrawalAttachments, isValidCashWithdrawalAmount, mergeCashWithdrawalAttachmentIds, serializeCashWithdrawalIds } from './cashWithdrawalLedger.config';

export default {
	name: 'CashWithdrawalLedger',
	components: { CheckFiles, UploadFilesButton },
	data() {
		const validateAmount = (rule, value, callback) => (isValidCashWithdrawalAmount(value) ? callback() : callback(new Error('金额必须大于0，最多20位整数和8位小数')));
		return {
			loading: false,
			showSearch: true,
			open: false,
			title: '',
			total: 0,
			ledgerList: [],
			ids: [],
			selectedRows: [],
			single: true,
			multiple: true,
			dateRange: [],
			queryParams: { pageNum: 1, pageSize: 10, accountInfo: '', handlerName: '', purpose: '', auditState: '' },
			form: {},
			attachmentGroups: { withdrawalProof: [], otherAttachment: [] },
			columns: ['取现日期', '取现金额', '取现账户名称+账号后5位数', '取现审批单、取现小票', '取现经办人', '取现用途', '其他附件', '审核状态', '审核人', '备注'].map((label, index) => ({ key: index, label, visible: true })),
			rules: {
				withdrawalDate: [{ required: true, message: '请选择取现日期', trigger: 'change' }],
				amount: [{ required: true, validator: validateAmount, trigger: 'blur' }],
				accountInfo: [{ required: true, message: '请输入取现账户名称及账号', trigger: 'blur' }],
				handlerName: [{ required: true, message: '请输入取现经办人', trigger: 'blur' }],
				purpose: [{ required: true, message: '请输入取现用途', trigger: 'blur' }]
			}
		};
	},
	created() {
		this.getList();
	},
	methods: {
		checkPermi,
		getList() {
			this.loading = true;
			return listCashWithdrawalLedger(buildCashWithdrawalQuery(this.queryParams, this.dateRange))
				.then(response => {
					this.ledgerList = response.rows || [];
					this.total = response.total || 0;
				})
				.finally(() => (this.loading = false));
		},
		resetFormData() {
			this.form = { id: null, withdrawalDate: null, amount: '', accountInfo: '', handlerName: '', purpose: '', remark: '', auditState: '未审核', attachmentList: [], params: { attachmentIds: [] } };
			this.attachmentGroups = { withdrawalProof: [], otherAttachment: [] };
			this.resetForm('form');
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.dateRange = [];
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleSelectionChange(selection) {
			this.selectedRows = selection;
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1 || selection[0].auditState === '已审核';
			this.multiple = selection.length === 0;
		},
		handleAdd() {
			this.clearUploaders();
			this.resetFormData();
			this.title = '新增转 、支现金台账';
			this.open = true;
		},
		handleUpdate(row) {
			const target = row || this.selectedRows[0];
			if (!target || target.auditState === '已审核') return this.$modal.msgWarning('已审核记录需先取消审核');
			this.clearUploaders();
			return getCashWithdrawalLedger(target.id).then(response => {
				if (!response.data) return this.$modal.msgError('未查询到台账详情');
				this.form = { ...response.data, amount: String(response.data.amount), params: { attachmentIds: mergeCashWithdrawalAttachmentIds(response.data.attachmentList || []) } };
				this.attachmentGroups = groupCashWithdrawalAttachments(response.data.attachmentList || []);
				this.title = '修改转 、支现金台账';
				this.open = true;
			});
		},
		handleAttachmentFilesUpdated(payload) {
			this.$set(this.form, 'params', { attachmentIds: [...new Set((payload && payload.params && payload.params.attachmentIds) || [])] });
		},
		clearUploaders() {
			['withdrawalProofUpload', 'otherAttachmentUpload'].forEach(ref => this.$refs[ref] && this.$refs[ref].clearUploadedFiles());
		},
		submitForm() {
			this.$refs.form.validate(valid => {
				if (!valid) return;
				const isEdit = Boolean(this.form.id);
				const payload = buildCashWithdrawalPayload(this.form, isEdit);
				const request = isEdit ? updateCashWithdrawalLedger(payload) : addCashWithdrawalLedger(payload);
				request
					.then(() => {
						if (!isEdit) return null;
						return replaceCashWithdrawalLedgerAttachments({ cashWithdrawalLedgerId: this.form.id, attachmentIds: (this.form.params && this.form.params.attachmentIds) || [] });
					})
					.then(() => {
						this.$modal.msgSuccess(isEdit ? '修改成功' : '新增成功');
						this.open = false;
						this.getList();
					});
			});
		},
		handleRowAttachments(files, row) {
			if (row.auditState === '已审核') return Promise.reject(new Error('已审核记录不可修改附件'));
			const attachmentIds = mergeCashWithdrawalAttachmentIds(files);
			return replaceCashWithdrawalLedgerAttachments({ cashWithdrawalLedgerId: row.id, attachmentIds }).then(response => {
				this.$set(row, 'attachmentList', (response && response.data) || files);
				return response;
			});
		},
		handleAudit(row, approved) {
			const action = approved ? '审核' : '取消审核';
			return this.$modal
				.confirm(`是否确认${action}该转 、支现金台账？`)
				.then(() => auditCashWithdrawalLedger(row.id, approved))
				.then(response => {
					if (response.data) Object.assign(row, response.data);
					else this.getList();
					this.$modal.msgSuccess(`${action}成功`);
				})
				.catch(() => this.getList());
		},
		handleDelete(row) {
			const rows = row ? [row] : this.selectedRows;
			if (!rows.length) return;
			if (rows.some(item => item.auditState === '已审核')) return this.$modal.msgWarning('所选记录包含已审核数据，请先取消审核');
			const ids = serializeCashWithdrawalIds(rows.map(item => item.id));
			this.$modal
				.confirm(`是否确认删除编号为“${ids}”的转 、支现金台账？`)
				.then(() => delCashWithdrawalLedger(ids))
				.then(() => {
					this.$modal.msgSuccess('删除成功');
					this.getList();
				})
				.catch(() => {});
		},
		handleExport() {
			const exportParams = buildCashWithdrawalExportParams(this.queryParams, this.dateRange);
			return exportCashWithdrawalLedger(exportParams).then(blob => saveAs(blob, `支取现金登记表_${new Date().getTime()}.xlsx`));
		},
		formatAmount(value) {
			if (value === null || value === undefined || value === '') return '';
			return Number(value).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 8 });
		}
	}
};
</script>

<style scoped lang="scss">
.cash-withdrawal-ledger {
	::v-deep .el-date-editor--daterange {
		width: 250px;
	}
	::v-deep .el-table th {
		background: #f6f8fb;
		color: #303133;
	}
	::v-deep .el-dialog__body {
		padding-top: 18px;
	}
}
</style>
