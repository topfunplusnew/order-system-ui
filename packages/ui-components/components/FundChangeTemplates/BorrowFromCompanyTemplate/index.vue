<!--
	变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
	- [2026-08-16] 新增"AI 字段地图"注释（字段名/中文列名/数据来源/差额行说明），便于 AI 快速了解展示内容；仅注释，未改业务逻辑。
	历史：
	- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：接入共享 FundChangeExportButton，导出当前模板的变更明细与差额汇总数据。
-->
<script>
/**
 * BorrowFromCompanyTemplate - 从我司借款（个人借款）(lendmoney)资金变动详情模板
 * lendmoney 表 type 为空/个人借款：moneyAmount、recoverMoneyList[].moneyAmount
 * 范式：记录(x) 合并 3 行（修改前/修改后/差额），排除 bankCardDiff，buildDiffFields 填 lendAmount，diff-summary-table 展示
 *
 * ================= AI FIELD MAP（AI 字段地图） =================
 * 本注释为 AI 阅读设计：锚点固定、字段为表格格式，可用 grep/正则定位。
 * 修改本组件时，若增删/重命名字段，必须同步更新下方字段表。
 *
 * ── DATA ENTRY（数据入口）─────────────────────────────
 * compareData: Array   /system/backuplog/v3/getByIds 返回 data
 *   item.originalInfo 修改前主表;  item.changedInfo 修改后主表
 *   info.recoverMoneyList[] 收回明细数组（badDebtFlag 区分收回/坏账，用于求和）
 * summaryData: Object  后端汇总（见 BOTTOM SUMMARY）
 * targetDate:  String  日期范围过滤（utils/fundChange/dateScopedRows，日期字段 addtime）
 * summaryModuleLabel: String  默认'从我司借款'，用于记录列标题与汇总 label 前缀
 *
 * ── RENDER STRUCTURE（渲染结构）────────────────────────
 * 1. FundChangeExportButton   导出按钮（明细 + 差额汇总）
 * 2. el-table 主明细表（summaryOnly=false 时显示）
 *    固定列① 从我司借款  组内首行合并（默认3行），显示「从我司借款(N) + backupTime」
 *    固定列② 变更  修改前 / 修改后 / 差额（before-row / after-row / diff-row）
 *    数据列 14 列   = LENDMONEY_COLUMNS 过滤 [bankCardDiff]
 *    合计行          仅差额行合计: lendAmount（getTableSummary）
 * 3. el-table 底部汇总表（diff-summary-table，diffRows 存在时显示）
 *    buildBackendSummaryRows(summaryData, 'lendmoney', prefix)
 *    展示键: 默认键顺序（有值才展示）→ 见 BOTTOM SUMMARY
 *
 * ── COLUMNS（数据列字段表）─────────────────────────────
 * 格式: prop | 中文列名 | source 来源 | note 备注
 * source 中 info=主表 originalInfo/changedInfo（mapBeforeRow 映射，候选字段取首个非空）
 *   borrowerName         | 借款人         | info.borrowerName                         | ?? companyName
 *   objectType           | 对象类型       | info.objectType                           | ?? companyType
 *   lendAmount           | 借出金额       | info.moneyAmount                          | 差额行回填差额
 *   recoverAmount        | 收回金额       | sum(recoverMoneyList 中 badDebtFlag!==1 的 moneyAmount) |
 *   badDebtTotal         | 累计坏账       | sum(recoverMoneyList 中 badDebtFlag===1 的 moneyAmount) |
 *   unrecoverAmount      | 未收回金额     | 计算: moneyAmount - recoverAmount - badDebtTotal |
 *   otherAccountNo       | 对方收借款账号 | info.otherAccountNo                        | ?? otherBankNo
 *   otherAccountName     | 对方户名       | info.otherAccountName                      | ?? otherBankName
 *   otherBankName        | 对方开户行     | info.otherBankName                         |
 *   selfPayAccountName   | 我方支付借款账户名称 | info.selfPayAccountName             | ?? bankName
 *   selfPayBankName      | 我方支付借款开户行 | info.selfPayBankName                   | ?? bankFullName
 *   selfPayAccountNo     | 我方付款账号   | info.bankNo                               |
 *   payTime              | 支付员工/外面公司在我公司借款时间 | info.addtime             | 截取前10位
 *   loanReason           | 借款事由       | info.loanReason                            | ?? remark
 *
 * ── DIFF ROW（差额行 rowType='diff'）────────────────────
 *   bankCardDiff 不直接展示（已从 columns 过滤），仅体现于差额行回填 lendAmount 与合计行
 *   buildDiffFields: lendAmount = (原借出 - 新借出) - (新收回 - 原收回)
 *                   = (orig.moneyAmount - chg.moneyAmount) - (chgRecover - origRecover)
 *                    其中 recover = sum(recoverMoneyList 中 badDebtFlag!==1 的 moneyAmount)
 *
 * ── BOTTOM SUMMARY（底部汇总表展示键）─────────────────
 *   默认输出键顺序 DEFAULT_OUTPUT_KEY_ORDER（有值才展示，label 前缀'从我司借款'）:
 *   companyTotalBalance 客户变动差额 | supplierTotalBalance 供应商变动差额 | selfCompanyTotalFunds 银行卡资金变动差额
 *   remainingInventoryAmount 库存变动差额 | driverUnpaidAmount 运费变动差额 | loanFromCompany 银行卡资金变动差额
 *   futuresMarginBalance 期货保证金变动差额 | paymentMarginBalance 厂家保证金变动差额
 *   receiveMarginBalance 保证金变动差额 | loanBalance 借款变动差额
 */
import { format, subtract, add } from 'mathjs';
import _ from 'lodash';
import { LENDMONEY_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildDateScopedRecordRows } from '@/utils/fundChange/dateScopedRows';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

import FundChangeExportButton from '../export/FundChangeExportButton.vue';

export default {
	name: 'BorrowFromCompanyTemplate',
	components: { FundChangeExportButton },
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '从我司借款' },
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			const excludeProps = ['bankCardDiff'];
			return LENDMONEY_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '从我司借款';
			return buildBackendSummaryRows(this.summaryData, 'lendmoney', prefix);
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
		sumRecoverNonBadDebt(list) {
			return _.sumBy(
				_.filter(list || [], r => r.badDebtFlag !== 1),
				r => Number(r.moneyAmount || 0)
			);
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
			const recover = this.sumRecoverNonBadDebt(info.recoverMoneyList);
			const badDebt = _.sumBy(
				_.filter(info.recoverMoneyList || [], r => r.badDebtFlag === 1),
				r => Number(r.moneyAmount || 0)
			);
			const unrecover = subtract(Number(info.moneyAmount || 0), add(recover, badDebt));
			return {
				borrowerName: info.borrowerName || info.companyName || '',
				objectType: info.objectType || info.companyType || '',
				lendAmount: info.moneyAmount,
				recoverAmount: format(recover, { notation: 'fixed', precision: 2 }),
				badDebtTotal: format(badDebt, { notation: 'fixed', precision: 2 }),
				unrecoverAmount: format(unrecover, { notation: 'fixed', precision: 2 }),
				otherAccountNo: info.otherAccountNo || info.otherBankNo || '',
				otherAccountName: info.otherAccountName || info.otherBankName || '',
				otherBankName: info.otherBankName || '',
				selfPayAccountName: info.selfPayAccountName || info.bankName || '',
				selfPayBankName: info.selfPayBankName || info.bankFullName || '',
				selfPayAccountNo: info.bankNo || '',
				payTime: info.addtime ? (info.addtime + '').slice(0, 10) : '',
				loanReason: info.loanReason || info.remark || ''
			};
		},
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
		},
		buildDiffFields(original, changed, _record) {
			const origLoan = Number(original.moneyAmount || 0);
			const chgLoan = Number(changed.moneyAmount || 0);
			const origRecover = this.sumRecoverNonBadDebt(original.recoverMoneyList);
			const chgRecover = this.sumRecoverNonBadDebt(changed.recoverMoneyList);
			const bankCardDiff = format(subtract(subtract(origLoan, chgLoan), subtract(chgRecover, origRecover)), { notation: 'fixed', precision: 2 });
			return { lendAmount: bankCardDiff };
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
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.lendAmount) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			columns.forEach((col, index) => {
				if (index === 0 || index === 1) sums.push('');
				else if (col.property === 'lendAmount') sums.push(amountSum);
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
