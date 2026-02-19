<script>
/**
 * 收取保证金变动详情模板
 * deposit_money 表：moneyAmount、depositRefundList[].moneyAmount
 */
import { format, subtract } from 'mathjs';
import _ from 'lodash';
import { AGGREGATOR_MAP } from '@/utils/fundChangeAggregators';
import { DEPOSIT_MONEY_COLUMNS } from '@/utils/fundChangeExcelColumns';

export default {
	name: 'ReceiveDepositTemplate',
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			return DEPOSIT_MONEY_COLUMNS.map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		summaryMap() {
			const map = {};
			this.columns.forEach(col => {
				if (col.showSummary === false) return;
				const values = _.map(this.diffRows, col.prop).map(v => Number(v) || 0);
				const agg = _.isFunction(col.aggregator) ? col.aggregator : AGGREGATOR_MAP[col.aggregator] || AGGREGATOR_MAP.sum;
				map[col.prop] = agg(values, { diffRows: this.diffRows, precision: 2 });
			});
			return map;
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
		}
	},
	methods: {
		sumRefundNonBadDebt(list) {
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
				const beforeRow = { ...this.mapBeforeRow(original, record, index), rowType: 'before', label: `记录(${index + 1})`, subLabel: '修改前' };
				const afterRow = { ...this.mapAfterRow(changed, record, index), rowType: 'after', label: '', subLabel: '修改后' };
				const diffRow = { rowType: 'diff', label: '', subLabel: '差额', ...this.buildDiffFields(original, changed, record) };
				this.tableData.push(beforeRow, afterRow, diffRow);
			});
		},
		calcUnrefund(info) {
			const total = Number(info.moneyAmount || 0);
			const refunded = this.sumRefundNonBadDebt(info.depositRefundList);
			return format(subtract(total, refunded), { notation: 'fixed', precision: 2 });
		},
		mapBeforeRow(info) {
			return {
				depositCompany: info.depositType || info.depositCompany || '',
				objectType: info.companyType || info.objectType || '',
				objectName: info.companyName || info.objectName || '',
				depositAmount: info.moneyAmount,
				unrefundAmount: this.calcUnrefund(info),
				otherAccountName: info.otherAccountName || '',
				otherAccountNo: info.otherAccountNo || '',
				otherBankName: info.otherBankName || '',
				selfReceiveAccountName: info.selfAccountName || info.bankName || '',
				selfAccountNo: info.bankNo || '',
				selfBankName: info.selfBankName || info.bankFullName || '',
				receiveTime: info.addtime ? (info.addtime + '').slice(0, 10) : '',
				reason: info.reason || info.loanReason || '',
				remark: info.remark || '',
				operatorName: info.operatorName || info.createBy || ''
			};
		},
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
		},
		buildDiffFields(original, changed, _record) {
			const origReceive = Number(original.moneyAmount || 0);
			const chgReceive = Number(changed.moneyAmount || 0);
			const depositDiff = format(subtract(chgReceive, origReceive), { notation: 'fixed', precision: 2 });
			return { depositDiff };
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
		}
	}
};
</script>

<template>
	<div class="fund-change-template">
		<el-table :data="tableData" border :row-class-name="tableRowClassName" style="width: 100%">
			<el-table-column width="150" fixed>
				<template slot-scope="scope">
					<div v-if="scope.row.label">{{ scope.row.label }}</div>
					<div class="sub-label">{{ scope.row.subLabel }}</div>
				</template>
			</el-table-column>
			<el-table-column v-for="col in columns" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width" />
		</el-table>
		<div class="summary-section" v-if="diffRows.length">
			<div class="summary-item" v-for="col in columns.filter(c => c.showSummary !== false)" :key="col.prop">
				<span class="summary-label">{{ col.summaryLabel || col.label }}：</span>
				<span class="summary-value">{{ summaryMap[col.prop] }}</span>
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss">
.fund-change-template {
	padding: 20px;
}
.sub-label {
	font-size: 12px;
	color: #666;
	margin-top: 4px;
}
::v-deep .before-row {
	background-color: #f0f9ff;
}
::v-deep .after-row {
	background-color: #fff7e6;
}
::v-deep .diff-row {
	background-color: #fff1f0;
	font-weight: bold;
}
.summary-section {
	margin-top: 20px;
	padding: 10px;
	background: #f5f5f5;
	border-radius: 4px;
	display: flex;
	flex-wrap: wrap;
	gap: 16px 24px;
}
.summary-item {
	font-size: 14px;
}
.summary-label {
	color: #606266;
}
.summary-value {
	font-weight: bold;
	margin-left: 4px;
	color: #f56c6c;
}
</style>
