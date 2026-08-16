<!--
	变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
	- [2026-08-16] 新增"AI 字段地图"注释（字段名/中文列名/数据来源/差额行说明），便于 AI 快速了解展示内容；仅注释，未改业务逻辑。
	历史：
	- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：接入共享 FundChangeExportButton，导出当前模板的变更明细与差额汇总数据。
-->
<script>
/**
 * BorrowInTemplate - 借入款管理(borrowedmoney)资金变动详情模板
 * borrowedmoney 表：moneyAmount、repayments[].moneyAmount、repayments[].ratio
 * 范式：记录(x) 合并 3 行，排除 bankCardDiff，buildDiffFields 填 moneyAmount，diff-summary-table 展示
 *
 * ================= AI FIELD MAP（AI 字段地图） =================
 * 本注释为 AI 阅读设计：锚点固定、字段为表格格式，可用 grep/正则定位。
 * 修改本组件时，若增删/重命名字段，必须同步更新下方字段表。
 *
 * ── DATA ENTRY（数据入口）─────────────────────────────
 * compareData: Array   /system/backuplog/v3/getByIds 返回 data
 *   item.originalInfo 修改前主表;  item.changedInfo 修改后主表
 *   item.originalInfo.repayments / item.changedInfo.repayments 还款明细数组（moneyAmount 本金 / ratio 利息）
 * summaryData: Object  后端汇总（见 BOTTOM SUMMARY）
 * targetDate:  String  日期范围过滤（主表 loanDate，utils/fundChange/dateScopedRows）
 *
 * ── RENDER STRUCTURE（渲染结构）────────────────────────
 * 1. FundChangeExportButton   导出按钮（明细 + 差额汇总）
 * 2. el-table 主明细表（summaryOnly=false 时显示）
 *    固定列① 借入款管理  组内首行合并，显示「借入款管理(N) + backupTime」
 *    固定列② 变更     subLabel: 修改前 / 修改后 / 差额（before-row / after-row / diff-row）
 *    数据列 13 列    = BORROWEDMONEY_COLUMNS 过滤 [bankCardDiff]
 *    合计行          仅差额行合计: moneyAmount（自定义 summary-method）
 * 3. el-table 底部汇总表（diff-summary-table，diffRows.length>0 时显示）
 *    buildBackendSummaryRows(summaryData, 'borrowedmoney', prefix)（未指定键列表）
 *    展示键: 默认键序中 summaryData 实际存在的键（通常 loanBalance 借款变动差额）
 *
 * ── COLUMNS（数据列字段表）─────────────────────────────
 * 格式: prop | 中文列名 | source 来源 | note 备注
 * source 中 info=主表 originalInfo/changedInfo; repay=repayments 单条明细
 *   id                    | id             | info.id                                  |
 *   origin                | 贷款来源       | info.origin ?? info.lenderName ?? info.companyName |
 *   moneyAmount           | 借入金额       | info.moneyAmount                         |
 *   ratio                 | 贷款利率       | info.ratio ?? info.interestRate          |
 *   loanDate              | 贷款发放日期   | info.loanDate ?? info.grantDate          | 截取前10位
 *   loanDuring            | 贷款年限       | info.loanDuring ?? info.loanYears        |
 *   mortgageGuarantee     | 抵押担保       | info.mortgageGuarantee ?? info.mortgage  |
 *   acountsName           | 打入账户       | info.acountsName ?? info.intoAccountName ?? info.bankName |
 *   bankNo                | 打入账号       | info.bankNo ?? info.intoAccountNo        |
 *   repaidAmount          | 已还款金额     | 计算: 有 unrepaidAmount 时 moneyAmount-unrepaidAmount；否则 sum(repay.moneyAmount) |
 *   unrepaidAmount        | 未还款金额     | info.unrepaidAmount ?? 计算: moneyAmount - sum(repay.moneyAmount) |
 *   repaidInterest        | 已还款利息     | sum(repay.ratio)                         |
 *   comments              | 备注           | info.comments ?? info.remark             |
 *
 * ── DIFF ROW（差额行 rowType='diff'，均为 修改后-修改前）────
 *   moneyAmount = (借入本金差) + (已还本金差取反) + (已还利息差取反)
 *   即 (chgMoneyAmount-origMoneyAmount) + (orig已还本金-chg已还本金) + (orig已还利息-chg已还利息)；仅回填 moneyAmount 列
 *
 * ── BOTTOM SUMMARY（底部汇总表展示键）─────────────────
 *   默认键序（通常 loanBalance）
 */
import _ from 'lodash';
import { BORROWEDMONEY_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildDateScopedRecordRows } from '@/utils/fundChange/dateScopedRows';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';
import { buildBorrowInDiffFields, mapBorrowInRecordToRow, sumBorrowInDiffRows } from '@/utils/fundChange/borrowIn';

import FundChangeExportButton from '../export/FundChangeExportButton.vue';

export default {
	name: 'BorrowInTemplate',
	components: { FundChangeExportButton },
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '借入款管理' },
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			const excludeProps = ['bankCardDiff'];
			return BORROWEDMONEY_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '借入款管理';
			return buildBackendSummaryRows(this.summaryData, 'borrowedmoney', prefix);
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
			return mapBorrowInRecordToRow(info);
		},
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
		},
		buildDiffFields(original, changed, _record) {
			return buildBorrowInDiffFields(original, changed);
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
			const amountSum = sumBorrowInDiffRows(diffRows);
			columns.forEach((col, index) => {
				if (index === 0 || index === 1) sums.push('');
				else if (col.property === 'moneyAmount') sums.push(amountSum);
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
