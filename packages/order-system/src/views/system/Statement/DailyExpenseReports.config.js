export function createDailyExpenseReportColumns() {
	return [
		{ key: 0, label: '申请时间', visible: true },
		{ key: 1, label: '对象', visible: true },
		{ key: 2, label: '付款金额', visible: true },
		{ key: 3, label: '付款户名', visible: true },
		{ key: 4, label: '付款账号', visible: true },
		{ key: 5, label: '收款户名', visible: true },
		{ key: 6, label: '收款账号', visible: true },
		{ key: 7, label: '付款时间', visible: true },
		{ key: 8, label: '附件', visible: true },
		{ key: 9, label: '备注', visible: true }
	];
}

export function resolveDailyExpenseReportTime(row, type) {
	if (type === 'apply') {
		return row?.applyDate || row?.expenseDate || '';
	}
	if (type === 'payment') {
		return row?.paymentDate || row?.expenseDate || '';
	}
	return '';
}
