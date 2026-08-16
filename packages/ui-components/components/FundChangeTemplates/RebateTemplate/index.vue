<!--
	变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
	- [2026-08-16] 新增"AI 字段地图"注释（字段名/中文列名/数据来源/差额行说明），便于 AI 快速了解展示内容；仅注释，未改业务逻辑。
	历史：
	- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：接入共享 FundChangeExportButton，导出当前模板的变更明细与差额汇总数据。
-->
<script>
/**
 * RebateTemplate - 返利(rebate)资金变动详情模板
 * rebate 表：rebate、supplier、rebateDate、detailList[].actualReceived 等
 * 范式：记录(x) 合并 3 行，差额行展示返利金额变化，底部小表使用后端 supplierTotalBalance/rebate 汇总。
 *
 * ================= AI FIELD MAP（AI 字段地图） =================
 * 本注释为 AI 阅读设计：锚点固定、字段为表格格式，可用 grep/正则定位。
 * 修改本组件时，若增删/重命名字段，必须同步更新下方字段表。
 *
 * ── DATA ENTRY（数据入口）─────────────────────────────
 * compareData: Array   /system/backuplog/v3/getByIds 返回 data
 *   item.originalInfo 修改前主表;  item.changedInfo 修改后主表
 *   item.originalInfo.detailList / item.changedInfo.detailList 返利明细数组（actualReceived 等）
 * summaryData: Object  后端汇总（见 BOTTOM SUMMARY）
 * targetDate:  String  日期范围过滤（主表 rebateDate/receivedRebateDate + 明细日期）
 *
 * ── RENDER STRUCTURE（渲染结构）────────────────────────
 * 1. FundChangeExportButton   导出按钮（明细 + 差额汇总）
 * 2. el-table 主明细表（summaryOnly=false 时显示）
 *    固定列① 返利    组内首行合并，显示「返利(N) + backupTime」
 *    固定列② 状态    subLabel: 修改前 / 修改后 / 差额（before-row / after-row / diff-row）
 *    数据列 12 列    = REBATE_COLUMNS 过滤 [supplierDiff]
 *    合计行          仅差额行合计: receivedAmount
 * 3. el-table 底部汇总表（diff-summary-table，diffRows.length>0 时显示）
 *    buildBackendSummaryRows(summaryData, 'rebate', prefix, ['supplierTotalBalance'])
 *    展示键: supplierTotalBalance 供应商变动差额
 *
 * ── COLUMNS（数据列字段表）─────────────────────────────
 * 格式: prop | 中文列名 | source 来源 | note 备注
 * source 中 info=主表 originalInfo/changedInfo; detail=detailList 单条明细
 *   rebateDate            | 计提返利日期   | info.rebateDate                          |
 *   rebateType            | 类型           | info.rebateType                          |
 *   supplierName          | 供应商         | info.supplier ?? info.supplierName ?? info.companyName |
 *   rebateMethod          | 返利方式       | info.rebateMethod                        | 2='面积', 1='重箱'
 *   unitPrice             | （返利/降价）单价 | info.unitPrice                           |
 *   rebateAmount          | 金额           | info.rebate                              |
 *   rebateReason          | 返利原因       | info.rebateReason                        |
 *   receivedDate          | 收到返利日期   | detail 日期(actualReceivedDate/receivedDate/rebateDate) ?? info.receivedRebateDate | 明细日期排序取最早
 *   receivedAmount        | 收到返利金额   | sum(detail.actualReceived ?? detail.moneyAmount) | 无明细显示'未收到'
 *   actualReceivedTime    | 实收返利时间   | 同 receivedDate（明细首条日期）          |
 *   actualReceivedAmount  | 实收金额       | sum(detail.actualReceived ?? detail.moneyAmount) |
 *   remark                | 备注           | info.comments ?? info.remark             |
 *
 * ── DIFF ROW（差额行 rowType='diff'，均为 修改后-修改前）────
 *   receivedAmount = receivedAmount 差（回填 receivedAmount 列）
 *   supplierDiff   = 与 receivedAmount 相同（已从 columns 过滤，不展示）
 *
 * ── BOTTOM SUMMARY（底部汇总表展示键）─────────────────
 *   supplierTotalBalance
 */
import _ from 'lodash';
import { REBATE_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildRebateRecordRows, REBATE_SUMMARY_PROPS, sumRebateDiffRows } from '@/utils/fundChange/rebate';

import FundChangeExportButton from '../export/FundChangeExportButton.vue';

export default {
	name: 'RebateTemplate',
	components: { FundChangeExportButton },
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '返利' },
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			const excludeProps = ['supplierDiff'];
			return REBATE_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (REBATE_SUMMARY_PROPS.includes(c.prop) ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '返利';
			return buildBackendSummaryRows(this.summaryData, 'rebate', prefix, ['supplierTotalBalance']);
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
				const rows = buildRebateRecordRows({
					original,
					changed,
					targetDate: this.targetDate,
					backupType: record.backupType,
					recordIndex: index + 1,
					backupTime
				});
				this.tableData.push(...rows);
			});
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
			const amountSums = sumRebateDiffRows(this.diffRows);
			return columns.map((col, index) => {
				if (index === 0 || index === 1) return '';
				if (REBATE_SUMMARY_PROPS.includes(col.property)) return amountSums[col.property];
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
			<el-table-column :label="summaryModuleLabel" width="100" fixed class-name="record-col">
				<template slot-scope="scope">
					<template v-if="scope.row.isRecordFirst">
						<div>{{ summaryModuleLabel }}（{{ scope.row.recordIndex }}）</div>
						<div v-if="scope.row.backupTime" class="backup-time">{{ scope.row.backupTime }}</div>
					</template>
				</template>
			</el-table-column>
			<el-table-column label="状态" width="80" fixed>
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
