export function toFiniteNumber(value) {
	const num = Number(value);
	return Number.isFinite(num) ? num : 0;
}

export function formatAmount(value, precision = 2) {
	const factor = 10 ** precision;
	const rounded = Math.round((toFiniteNumber(value) + Number.EPSILON) * factor) / factor;
	return rounded.toFixed(precision);
}

export function formatDebitCreditAmount(value, precision = 2) {
	const num = toFiniteNumber(value);
	if (num > 0) {
		return `[借] ${formatAmount(Math.abs(num), precision)}`;
	}
	if (num < 0) {
		return `[贷] ${formatAmount(Math.abs(num), precision)}`;
	}
	return formatAmount(0, precision);
}

export function sumBy(data = [], getter) {
	return (data || []).reduce((total, row) => total + toFiniteNumber(getter(row)), 0);
}

export function buildAmountSummaries({ columns = [], data = [], amountProps = [], firstLabel = '合计', precision = 2, getColumnValue } = {}) {
	return (columns || []).map((column, index) => {
		if (index === 0 || column.type === 'index' || column.label === '序号') {
			return firstLabel;
		}

		const shouldSumProp = column.property && amountProps.includes(column.property);
		const hasCalculatedValue = typeof getColumnValue === 'function' && (data || []).some(row => getColumnValue(row, column) !== undefined);
		if (!shouldSumProp && !hasCalculatedValue) {
			return '';
		}

		const total = sumBy(data, row => {
			const calculatedValue = typeof getColumnValue === 'function' ? getColumnValue(row, column) : undefined;
			return calculatedValue !== undefined ? calculatedValue : row[column.property];
		});
		return formatAmount(total, precision);
	});
}
