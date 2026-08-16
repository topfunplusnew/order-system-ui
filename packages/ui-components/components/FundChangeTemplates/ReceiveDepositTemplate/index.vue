<!--
	变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
	- [2026-08-16] 新增"AI 字段地图"注释（字段名/中文列名/数据来源/差额行说明），便于 AI 快速了解展示内容；仅注释，未改业务逻辑。
	历史：
	- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：接入共享 FundChangeExportButton，导出当前模板的变更明细与差额汇总数据。
-->
<script>
/**
 * ReceiveDepositTemplate - 收取保证金(deposit_money)资金变动详情模板
 * deposit_money 表：moneyAmount、depositRefundList[].moneyAmount
 * 范式：记录(x) 合并 3 行，排除 depositDiff，diff-summary-table 展示
 *
 * ================= AI FIELD MAP（AI 字段地图） =================
 * 本注释为 AI 阅读设计：锚点固定、字段为表格格式，可用 grep/正则定位。
 * 修改本组件时，若增删/重命名字段，必须同步更新下方字段表。
 *
 * ── DATA ENTRY（数据入口）─────────────────────────────
 * compareData: Array   /system/backuplog/v3/getByIds 返回 data
 *   item.originalInfo 修改前主表;  item.changedInfo 修改后主表
 *   item.originalInfo.depositRefundList / item.changedInfo.depositRefundList 退款明细数组
 * summaryData: Object  后端汇总（见 BOTTOM SUMMARY）
 * targetDate:  String  日期范围过滤（主表 depositDate + 退款明细日期）
 *
 * ── RENDER STRUCTURE（渲染结构）────────────────────────
 * 1. FundChangeExportButton   导出按钮（明细 + 差额汇总）
 * 2. el-table 主明细表（summaryOnly=false 时显示）
 *    固定列① 收取保证金  组内首行合并，显示「收取保证金(N) + backupTime」
 *    固定列② 变更     subLabel: 修改前 / 修改后 / 差额（before-row / after-row / diff-row）
 *    数据列 15 列    = DEPOSIT_MONEY_COLUMNS 过滤 [depositDiff]
 *    合计行          仅差额行合计: depositAmount / unrefundAmount
 * 3. el-table 底部汇总表（diff-summary-table，diffRows.length>0 时显示）
 *    buildBackendSummaryRows(summaryData, 'deposit_money', prefix)（未指定键列表）
 *    展示键: 默认键序中 summaryData 实际存在的键（通常 receiveMarginBalance 保证金变动差额）
 *
 * ── COLUMNS（数据列字段表）─────────────────────────────
 * 格式: prop | 中文列名 | source 来源 | note 备注
 * source 中 info=主表 originalInfo/changedInfo; refund=depositRefundList 单条明细
 *   depositCompany        | 保证金公司     | info.depositCompany ?? info.depositType  |
 *   objectType            | 对象类型       | info.targetType ?? info.companyType ?? info.objectType |
 *   objectName            | 对象名称       | info.target ?? info.companyName ?? info.objectName |
 *   depositAmount         | 保证金金额     | info.moneyAmount                         |
 *   unrefundAmount        | 未退款金额     | 计算: moneyAmount - sum(refund.moneyAmount 排除 badDebtFlag=1) |
 *   otherAccountName      | 对方账户       | info.targetAccountsName ?? info.otherAccountName |
 *   otherAccountNo        | 对方账号       | info.targetBankNo ?? info.otherAccountNo |
 *   otherBankName         | 对方开户行     | info.targetBankName ?? info.otherBankName |
 *   selfReceiveAccountName | 我方收款账户   | info.selfAccountsName ?? info.selfAccountName ?? info.bankName |
 *   selfAccountNo         | 我方账号       | info.selfBankNo ?? info.bankNo           |
 *   selfBankName          | 我方开户行     | info.selfBankName ?? info.bankFullName   |
 *   receiveTime           | 收取时间       | info.depositDate ?? info.addtime         | 截取前10位
 *   reason                | 事由           | info.reason ?? info.loanReason           |
 *   remark                | 备注           | info.comments ?? info.remark             |
 *   operatorName          | 操作人员       | info.userName ?? info.operatorName ?? info.createBy |
 *
 * ── DIFF ROW（差额行 rowType='diff'，均为 修改后-修改前）────
 *   depositAmount / unrefundAmount = 对应列 修改后-修改前（回填同名列）
 *
 * ── BOTTOM SUMMARY（底部汇总表展示键）─────────────────
 *   默认键序（通常 receiveMarginBalance）
 */
import _ from 'lodash';
import { DEPOSIT_MONEY_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildReceiveDepositRecordRows, RECEIVE_DEPOSIT_SUMMARY_PROPS, sumReceiveDepositDiffRows } from '@/utils/fundChange/receiveDeposit';

import FundChangeExportButton from '../export/FundChangeExportButton.vue';

export default {
	name: 'ReceiveDepositTemplate',
	components: { FundChangeExportButton },
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '收取保证金' },
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			const excludeProps = ['depositDiff'];
			return DEPOSIT_MONEY_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (RECEIVE_DEPOSIT_SUMMARY_PROPS.includes(c.prop) ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '收取保证金';
			return buildBackendSummaryRows(this.summaryData, 'deposit_money', prefix);
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
				const rows = buildReceiveDepositRecordRows({
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
			const sums = [];
			const diffRows = this.diffRows;
			const amountSums = sumReceiveDepositDiffRows(diffRows);
			columns.forEach((col, index) => {
				if (index === 0 || index === 1) sums.push('');
				else if (RECEIVE_DEPOSIT_SUMMARY_PROPS.includes(col.property)) sums.push(amountSums[col.property]);
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
