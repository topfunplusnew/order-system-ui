<!--
	变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
	- [2026-08-16] 新增"AI 字段地图"注释（字段名/中文列名/数据来源/差额行说明），便于 AI 快速了解展示内容；仅注释，未改业务逻辑。
	历史：
	- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：接入共享 FundChangeExportButton，导出当前模板的变更明细与差额汇总数据。
-->
<script>
/**
 * ReceiveMoneyTemplate - 收款(receivemoney)资金变动详情模板
 * receivemoney 表：moneyAmount、companyType、companyName 等
 * 范式：记录(x) 合并 3 行，排除 amountDiff，buildDiffFields 填 amount，diff-summary-table 展示
 *
 * ================= AI FIELD MAP（AI 字段地图） =================
 * 本注释为 AI 阅读设计：锚点固定、字段为表格格式，可用 grep/正则定位。
 * 修改本组件时，若增删/重命名字段，必须同步更新下方字段表。
 *
 * ── DATA ENTRY（数据入口）─────────────────────────────
 * compareData: Array   /system/backuplog/v3/getByIds 返回 data
 *   item.originalInfo 修改前主表;  item.changedInfo 修改后主表（receivemoney 单条记录）
 * summaryData: Object  后端汇总（见 BOTTOM SUMMARY）
 * targetDate:  String  日期范围过滤（utils/fundChange/dateScopedRows）
 *
 * ── RENDER STRUCTURE（渲染结构）────────────────────────
 * 1. FundChangeExportButton   导出按钮（明细 + 差额汇总）
 * 2. el-table 主明细表（summaryOnly=false 时显示）
 *    固定列① 收款  组内首行合并，显示「收款(N) + backupTime」
 *    固定列② 变更  修改前 / 修改后 / 差额（before-row / after-row / diff-row）
 *    数据列 13 列   = RECEIVEMONEY_COLUMNS 过滤 [amountDiff]
 *    合计行          仅差额行合计: amount（getTableSummary）
 * 3. el-table 底部汇总表（diff-summary-table）
 *    buildBackendSummaryRows(summaryData, 'receivemoney', prefix)
 *    展示键: 默认键顺序（有值才展示）→ 见 BOTTOM SUMMARY
 *
 * ── COLUMNS（数据列字段表）─────────────────────────────
 * 格式: prop | 中文列名 | source 来源 | note 备注
 * source 中 info=主表 originalInfo/changedInfo（pickFirstValue 依次取首个非空值）
 *   status               | 状态           | CONST 固定'已收款'                        |
 *   receiveDate          | 日期           | info.fundsDate/receiveTime/changedTargetTime/addtime | 截取前19位
 *   paymentType          | 支付类型       | info.receiveType/payType                  | 默认'-'
 *   companyName          | 对方公司       | info.companyName                          | 默认'-'
 *   companyType          | 对方公司类型   | info.companyType                          | 默认''
 *   amount               | 金额           | info.moneyAmount                          | 差额行回填差额
 *   selfAccountName      | 己方户名       | info.selfAcountsName/selfAccountName/bankName |
 *   selfAccountNo        | 己方账号       | info.selfBankNo/bankNo                    |
 *   selfBankName         | 己方开户行     | info.selfBankName/bankFullName            |
 *   otherAccountName     | 对方户名       | info.otherAcountsName/otherAccountName    |
 *   otherAccountNo       | 对方账号       | info.otherBankNo/otherAccountNo           |
 *   otherBankName        | 对方开户行     | info.otherBankName                        |
 *   remark               | 备注           | info.comments/remark                      |
 *
 * ── DIFF ROW（差额行 rowType='diff'）────────────────────
 *   amountDiff 不直接展示（已从 columns 过滤），仅体现于差额行回填 amount 与合计行
 *   buildDiffFields: amount = calculateFieldDiff(changed.moneyAmount, original.moneyAmount)
 *   calculateFieldDiff(after, before) = after - before ⇒ 差额 = 修改后 - 修改前（收款金额增加为正）
 *
 * ── BOTTOM SUMMARY（底部汇总表展示键）─────────────────
 *   默认输出键顺序 DEFAULT_OUTPUT_KEY_ORDER（有值才展示，label 前缀'收款'）:
 *   companyTotalBalance 客户变动差额 | supplierTotalBalance 供应商变动差额 | selfCompanyTotalFunds 银行卡资金变动差额
 *   remainingInventoryAmount 库存变动差额 | driverUnpaidAmount 运费变动差额 | loanFromCompany 银行卡资金变动差额
 *   futuresMarginBalance 期货保证金变动差额 | paymentMarginBalance 厂家保证金变动差额
 *   receiveMarginBalance 保证金变动差额 | loanBalance 借款变动差额
 */
import { format, subtract, add } from 'mathjs';
import _ from 'lodash';
import { RECEIVEMONEY_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildDateScopedRecordRows } from '@/utils/fundChange/dateScopedRows';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

import FundChangeExportButton from '../export/FundChangeExportButton.vue';

export default {
	name: 'ReceiveMoneyTemplate',
	components: { FundChangeExportButton },
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '收款' },
		/** 仅展示差额汇总表 */
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			const excludeProps = ['amountDiff'];
			return RECEIVEMONEY_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '收款';
			return buildBackendSummaryRows(this.summaryData, 'receivemoney', prefix);
		}
	},
	created() {
		this.processData();
	},
	watch: {
		compareData: {
			handler() {
				this.processData();
			},
			deep: true
		},
		targetDate() {
			this.processData();
		}
	},
	methods: {
		pickFirstValue(info, keys = [], defaultValue = '') {
			for (const key of keys) {
				const value = info?.[key];
				if (value !== undefined && value !== null && value !== '') {
					return value;
				}
			}
			return defaultValue;
		},
		formatDateTime(value) {
			return value ? String(value).slice(0, 19) : '-';
		},
		processData() {
			this.tableData = [];
			(this.compareData || []).forEach((record, index) => {
				const original = record.originalInfo || {};
				const changed = record.changedInfo || {};
				const backupTime = _.toString(record.backupTime || '').slice(0, 10);
				const rows = buildDateScopedRecordRows({
					original,
					changed,
					targetDate: this.targetDate,
					backupType: record.backupType,
					dateFields: getFundChangeTemplateDateFields(this.$options.name),
					beforeRow: { ...this.mapBeforeRow(original, record, index), recordIndex: index + 1, backupTime },
					afterRow: { ...this.mapAfterRow(changed, record, index), recordIndex: index + 1, backupTime },
					buildDiffFields: (scopedOriginal, scopedChanged) => this.buildDiffFields(scopedOriginal, scopedChanged, record)
				});
				this.tableData.push(...rows);
			});
		},
		mapBeforeRow(info) {
			const dt = this.pickFirstValue(info, ['fundsDate', 'receiveTime', 'changedTargetTime', 'addtime']);
			return {
				status: '已收款',
				receiveDate: this.formatDateTime(dt),
				paymentType: this.pickFirstValue(info, ['receiveType', 'payType'], '-'),
				companyName: info.companyName || '-',
				companyType: info.companyType || '',
				amount: info.moneyAmount,
				selfAccountName: this.pickFirstValue(info, ['selfAcountsName', 'selfAccountName', 'bankName'], ''),
				selfAccountNo: this.pickFirstValue(info, ['selfBankNo', 'bankNo'], ''),
				selfBankName: this.pickFirstValue(info, ['selfBankName', 'bankFullName'], ''),
				otherAccountName: this.pickFirstValue(info, ['otherAcountsName', 'otherAccountName'], ''),
				otherAccountNo: this.pickFirstValue(info, ['otherBankNo', 'otherAccountNo'], ''),
				otherBankName: this.pickFirstValue(info, ['otherBankName'], ''),
				remark: this.pickFirstValue(info, ['comments', 'remark'], '')
			};
		},
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
		},
		buildDiffFields(original, changed, _record) {
			const amountDiff = this.calculateFieldDiff(changed.moneyAmount, original.moneyAmount);
			return { amount: amountDiff };
		},
		calculateFieldDiff(afterVal, beforeVal) {
			const after = Number(afterVal || 0);
			const before = Number(beforeVal || 0);
			return format(subtract(after, before), { notation: 'fixed', precision: 2 });
		},
		tableRowClassName({ row }) {
			if (row.rowType === 'before') return 'before-row';
			if (row.rowType === 'after') return 'after-row';
			if (row.rowType === 'diff') return 'diff-row';
			return '';
		},
		handleProcess() {
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		},
		recordSpanMethod({ row, columnIndex }) {
			if (columnIndex !== 0) return [1, 1];
			if (row.isRecordFirst) return [row.recordRowCount || 3, 1];
			return [0, 0];
		},
		getTableSummary(param) {
			const { columns } = param;
			const sums = [];
			const diffRows = this.diffRows;
			const amountSum = format(
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.amount) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			columns.forEach((col, index) => {
				if (index === 0 || index === 1) sums.push('');
				else if (col.property === 'amount') sums.push(amountSum);
				else sums.push('');
			});
			return sums;
		}
	}
};
</script>

<template>
	<div class="fund-change-template">
		<FundChangeExportButton :columns="columns" :rows="tableData" :summary-rows="diffSummaryTableData" :module-label="summaryModuleLabel" :summary-only="summaryOnly" />
		<el-table v-if="!summaryOnly" :data="tableData" border :row-class-name="tableRowClassName" :span-method="recordSpanMethod" show-summary :summary-method="getTableSummary" style="width: 100%">
			<el-table-column :label="summaryModuleLabel" width="100" fixed class-name="record-col">
				<template slot-scope="scope">
					<template v-if="scope.row.isRecordFirst">
						<div>{{ summaryModuleLabel }}（{{ scope.row.recordIndex }}）</div>
						<div v-if="scope.row.backupTime" class="backup-time">{{ scope.row.backupTime }}</div>
					</template>
				</template>
			</el-table-column>
			<el-table-column label="变更" width="80" fixed>
				<template slot-scope="scope">{{ scope.row.subLabel }}</template>
			</el-table-column>
			<el-table-column v-for="col in columns" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width" />
		</el-table>
		<el-table v-if="diffRows.length" :data="diffSummaryTableData" border class="diff-summary-table" :show-header="false" :class="{ 'summary-only': summaryOnly }">
			<el-table-column prop="label" width="280">
				<template slot-scope="scope">
					<span class="diff-summary-label">{{ scope.row.label }}</span>
				</template>
			</el-table-column>
			<el-table-column prop="value" width="120" align="right">
				<template slot-scope="scope">
					<span class="diff-summary-value">{{ scope.row.value }}</span>
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<style scoped lang="scss">
.fund-change-template {
	padding: 20px;
}
::v-deep .record-col {
	vertical-align: middle;
	text-align: center;
}
.backup-time {
	margin-top: 4px;
	font-size: 12px;
	color: #909399;
}
::v-deep .before-row {
	background-color: #f0f9ff;
}
::v-deep .after-row td {
	background-color: #fff3ca !important;
}
::v-deep .diff-row {
	background-color: #fff1f0;
	font-weight: bold;
}
::v-deep .el-table__footer td {
	background-color: #fff8e6 !important;
	font-weight: bold;
}
::v-deep .el-table__footer tr td {
	padding: 8px 10px;
	line-height: 1.5;
	vertical-align: middle;
	height: 38px !important;
}
.diff-summary-table.summary-only {
	margin-top: 0;
}
.diff-summary-table {
	margin-top: 16px;
	width: auto !important;
	.diff-summary-label {
		text-align: left;
	}
	.diff-summary-value {
		text-align: right;
	}
	::v-deep .el-table__body td {
		background: #fff !important;
		padding: 8px 12px;
	}
}
</style>
