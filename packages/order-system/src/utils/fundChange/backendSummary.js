import { format, add } from 'mathjs';
import _ from 'lodash';

const DEFAULT_OUTPUT_KEY_ORDER = ['companyTotalBalance', 'supplierTotalBalance', 'selfCompanyTotalFunds', 'remainingInventoryAmount', 'driverUnpaidAmount', 'loanFromCompany', 'futuresMarginBalance', 'paymentMarginBalance', 'receiveMarginBalance', 'loanBalance'];

const OUTPUT_KEY_LABEL_MAP = {
	companyTotalBalance: '客户变动差额',
	supplierTotalBalance: '供应商变动差额',
	selfCompanyTotalFunds: '银行卡资金变动差额',
	remainingInventoryAmount: '库存变动差额',
	driverUnpaidAmount: '运费变动差额',
	loanFromCompany: '银行卡资金变动差额',
	futuresMarginBalance: '期货保证金变动差额',
	paymentMarginBalance: '厂家保证金变动差额',
	receiveMarginBalance: '保证金变动差额',
	loanBalance: '借款变动差额'
};

export function getBackendSummaryValue(summaryData, outputKey, tableName, category = '*') {
	const categoryMap = summaryData?.[outputKey]?.[tableName];
	if (!categoryMap || typeof categoryMap !== 'object') return undefined;
	if (category !== '*') {
		const value = categoryMap[category];
		return value === undefined || value === null || value === '' ? undefined : Number(value) || 0;
	}
	const values = Object.values(categoryMap).filter(value => value !== undefined && value !== null && value !== '');
	if (_.isEmpty(values)) return undefined;
	return _.reduce(values, (acc, value) => add(acc, Number(value) || 0), 0);
}

export function buildBackendSummaryRows(summaryData, tableName, prefix, outputKeyOrder = DEFAULT_OUTPUT_KEY_ORDER) {
	if (!summaryData || !tableName) return [];
	return outputKeyOrder.reduce((rows, outputKey) => {
		const value = getBackendSummaryValue(summaryData, outputKey, tableName, '*');
		if (value === undefined) return rows;
		const label = OUTPUT_KEY_LABEL_MAP[outputKey] || '变动差额';
		rows.push({
			label: `${prefix}${label}`,
			value: format(Number(value) || 0, { notation: 'fixed', precision: 2 })
		});
		return rows;
	}, []);
}
