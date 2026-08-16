<!--
	变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
	- [2026-08-16] 修复：票点修改变动统计中「我方主体」与「开票单位名称」字段映射取反（ticketPoint.js：selfSubject 取 invoiceObject、incomeInvoiceUnit 取 invoiceCompanyName）；同步更新下方 AI 字段地图。
	历史：
	- [2026-08-16] 新增"AI 字段地图"注释（字段名/中文列名/数据来源/差额行说明），便于 AI 快速了解展示内容；仅注释，未改业务逻辑。
	- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：接入共享 FundChangeExportButton，导出当前模板的变更明细与差额汇总数据。
-->
<script>
/**
 * TicketPointTemplate - 票点资金变动详情模板
 * invoicein/invoiceout/invoiceother 表：customer、Supplier、invoiceAmount、customerPointAmount、supplierPointAmount 等
 * 范式：记录(x) 合并 3 行（修改前/修改后/差额），排除 customerDiff、supplierDiff 差额列，diff-summary-table 展示 2 行
 *
 * ================= AI FIELD MAP（AI 字段地图） =================
 * 本注释为 AI 阅读设计：锚点固定、字段为表格格式，可用 grep/正则定位。
 * 修改本组件时，若增删/重命名字段，必须同步更新下方字段表。
 *
 * ── DATA ENTRY（数据入口）─────────────────────────────
 * compareData: Array   /system/backuplog/v3/getByIds 返回 data
 *   item.originalInfo 修改前主表;  item.changedInfo 修改后主表（无明细数组，单条记录映射一行）
 * summaryData: Object  后端汇总（见 BOTTOM SUMMARY）
 * targetDate:  String  日期范围过滤（utils/fundChange/dateScopedRows，日期字段 invoiceDate）
 * moduleName:  String  表名 invoicein/invoiceout/invoiceother/allinvoice，决定汇总表名与记录列标题
 *
 * ── RENDER STRUCTURE（渲染结构）────────────────────────
 * 1. FundChangeExportButton   导出按钮（明细 + 差额汇总）
 * 2. el-table 主明细表（summaryOnly=false 时显示）
 *    固定列① 票点  组内首行合并（默认3行），显示「resolvedSummaryModuleLabel(N) + backupTime」
 *                 （moduleName 为票点表时统一'发票往来'，否则用 summaryModuleLabel 默认'票点'）
 *    固定列② 变更  修改前 / 修改后 / 差额（before-row / after-row / diff-row）
 *    数据列 20 列   = TICKET_POINT_COLUMNS 过滤 [customerDiff, supplierDiff]
 *    合计行          仅 incomePointAmount = sum(diff行.customerDiff)（sumTicketPointIncomeDiffRows）
 * 3. el-table 底部汇总表（diff-summary-table，diffRows 存在时显示）
 *    buildBackendSummaryRows(summaryData, moduleName, prefix, ['companyTotalBalance', 'supplierTotalBalance'])
 *    展示键: companyTotalBalance 客户变动差额 / supplierTotalBalance 供应商变动差额
 *
 * ── COLUMNS（数据列字段表）─────────────────────────────
 * 格式: prop | 中文列名 | source 来源 | note 备注
 * source 中 info=主表 originalInfo/changedInfo（mapTicketPointRecordToRow，候选字段取首个非空）
 *   status               | 状态           | CONST 固定'已开票'                        |
 *   invoiceDate          | 日期           | info.invoiceDate                          | 截取前10位
 *   selfSubject          | 我方主体       | info.selfSubject                          | ?? selfCompanyName ?? invoiceObject（我方收票/开票主体）
 *   invoiceAmount        | 发票金额       | info.invoiceAmount                        |
 *   incomeCompanyType    | 公司类型       | info.incomeCompanyType                     | 双主体按有无客户方推'客户'；单主体取 companyType
 *   incomeCompanyName    | 公司名称       | info.customer                             | ?? Customer ?? companyName
 *   incomeInvoiceUnit    | 开票单位名称   | info.invoiceCompanyName ?? info.invoiceUnitName | 单主体；双主体为 invoiceUnitName ?? invoiceCompanyName
 *   incomePoint          | 票点           | info.customerTicketPoint                   | ?? pointRate ?? ticketPoint（单主体另含 supplierTicketPoint/supplierPointRate）
 *   incomePointAmount    | 票点收入       | info.customerPointAmount                   | ?? ticketPointAmount（单主体另含 supplierPointAmount）
 *   isOrderTax           | 是否为订单税   | info.isOrderTax                            |
 *   costCompanyType      | 公司类型       | info.costCompanyType                       | 双主体有供应商方时推'供应商'
 *   costCompanyName      | 公司名称       | info.Supplier                             | ?? supplier
 *   costInvoiceUnit      | 开票单位名称   | info.costInvoiceUnitName                   |
 *   costPoint            | 票点           | info.supplierTicketPoint                   | ?? supplierPointRate
 *   costPointAmount      | 票点成本       | info.supplierPointAmount                   |
 *   pointDiff            | 票点差额       | info.pointAmountDifference                 |
 *   actualInvoiceAmount  | 实际开票金额   | info.actualInvoiceAmount                   | ?? extraInfo.actualInvoiceAmount
 *   actualInvoiceDate    | 实际开票日期   | info.actualInvoiceDate                     | ?? extraInfo.actualInvoiceTime，截取前10位
 *   monthlyDebt          | 当月欠票       | info.monthlyDebt                           | ?? currentMonthOweInvoiceAmount ?? extraInfo.currentMonthOweInvoiceAmount
 *   remark               | 备注           | info.comments                             | ?? remark ?? extraInfo.comment
 *
 * ── DIFF ROW（差额行 rowType='diff'，均为 修改后-修改前）────
 *   customerDiff 客户票点差额 = customerPointAmount 差；单主体按 companyType/tableName 归边（'供应商'/invoicein → supplierDiff）
 *   supplierDiff  供应商票点差额 = supplierPointAmount 差
 *   注: customerDiff/supplierDiff 不直接展示（已从 columns 过滤），差额行本身无回填列，
 *       仅合计行 incomePointAmount = sum(diff行.customerDiff)（sumTicketPointIncomeDiffRows）
 *
 * ── BOTTOM SUMMARY（底部汇总表展示键）─────────────────
 *   companyTotalBalance 客户变动差额 | supplierTotalBalance 供应商变动差额
 */
import _ from 'lodash';
import { TICKET_POINT_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildTicketPointDiffFields, mapTicketPointRecordToRow, resolveTicketPointSummaryLabel, sumTicketPointIncomeDiffRows } from '@/utils/fundChange/ticketPoint';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildDateScopedRecordRows } from '@/utils/fundChange/dateScopedRows';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

import FundChangeExportButton from '../export/FundChangeExportButton.vue';

export default {
	name: 'TicketPointTemplate',
	components: { FundChangeExportButton },
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '票点' },
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		resolvedSummaryModuleLabel() {
			return resolveTicketPointSummaryLabel(this.moduleName, this.summaryModuleLabel);
		},
		columns() {
			const excludeProps = ['customerDiff', 'supplierDiff'];
			return TICKET_POINT_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.resolvedSummaryModuleLabel;
			return buildBackendSummaryRows(this.summaryData, this.moduleName, prefix, ['companyTotalBalance', 'supplierTotalBalance']);
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
				const tname = record.tableName || this.moduleName;
				const backupTime = _.toString(record.backupTime || '').slice(0, 10);
				const rows = buildDateScopedRecordRows({
					original,
					changed,
					targetDate: this.targetDate,
					backupType: record.backupType,
					dateFields: getFundChangeTemplateDateFields(this.$options.name),
					beforeRow: { ...this.mapBeforeRow(original, record, index, tname), recordIndex: index + 1, backupTime },
					afterRow: { ...this.mapAfterRow(changed, record, index, tname), recordIndex: index + 1, backupTime },
					buildDiffFields: (scopedOriginal, scopedChanged) => this.buildDiffFields(scopedOriginal, scopedChanged, record, tname)
				});
				this.tableData.push(...rows);
			});
		},
		mapBeforeRow(info, _record, _index, _tableName) {
			return mapTicketPointRecordToRow(info);
		},
		mapAfterRow(info, record, index, tableName) {
			return this.mapBeforeRow(info, record, index, tableName);
		},
		buildDiffFields(original, changed, record, tableName) {
			return buildTicketPointDiffFields(original, changed, tableName || record.tableName || this.moduleName);
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
			const incomePointAmountSum = sumTicketPointIncomeDiffRows(this.diffRows);
			return columns.map((col, index) => {
				if (index === 0 || index === 1) return '';
				if (col.property === 'incomePointAmount') return incomePointAmountSum;
				return '';
			});
		}
	}
};
</script>

<template>
	<div class="fund-change-template">
		<FundChangeExportButton :columns="columns" :rows="tableData" :summary-rows="diffSummaryTableData" :module-label="summaryModuleLabel" :summary-only="summaryOnly" />
		<el-table v-if="!summaryOnly" :data="tableData" border :row-class-name="tableRowClassName" :span-method="recordSpanMethod" show-summary :summary-method="getTableSummary" style="width: 100%">
			<el-table-column :label="resolvedSummaryModuleLabel" width="100" fixed class-name="record-col">
				<template slot-scope="scope">
					<template v-if="scope.row.isRecordFirst">
						<div>{{ resolvedSummaryModuleLabel }}（{{ scope.row.recordIndex }}）</div>
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
