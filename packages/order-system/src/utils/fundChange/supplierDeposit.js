import { format, subtract, add } from 'mathjs';

export const SUPPLIER_DEPOSIT_SUMMARY_PROPS = Object.freeze(['amount', 'recoverAmount', 'badDebtTotal', 'unrecoverAmount']);

function normalizeValue(value) {
	return typeof value === 'string' ? value.trim() : value;
}

function firstDefined(...values) {
	const value = values.find(item => item !== undefined && item !== null && item !== '');
	return value === undefined ? '' : normalizeValue(value);
}

function sumRecoverMoney(list = [], badDebtFlag) {
	return (list || []).reduce((total, item) => {
		const isBadDebt = Number(item?.badDebtFlag || 0) === 1;
		if (badDebtFlag === 1 && !isBadDebt) return total;
		if (badDebtFlag !== 1 && isBadDebt) return total;
		return add(total, Number(item?.moneyAmount || 0));
	}, 0);
}

export function mapSupplierDepositRecordToRow(info = {}) {
	const payTime = firstDefined(info.futuresDate, info.addtime, '');
	const recoverAmount = sumRecoverMoney(info.recoverMoneyList, 0);
	const badDebtTotal = sumRecoverMoney(info.recoverMoneyList, 1);
	const hasUnrecoverAmount = info.unrecoveredAmount !== undefined && info.unrecoveredAmount !== null && info.unrecoveredAmount !== '';
	const unrecoverAmount = hasUnrecoverAmount ? Number(info.unrecoveredAmount || 0) : subtract(subtract(Number(info.moneyAmount || 0), recoverAmount), badDebtTotal);
	return {
		marginType: firstDefined(info.type, '厂家保证金'),
		companyName: firstDefined(info.futuresMarginCompany, info.companyName, info.target, ''),
		objectType: firstDefined(info.targetType, info.objectType, ''),
		targetCompanyName: firstDefined(info.target, info.borrowerName, info.targetAcountsName, ''),
		amount: info.moneyAmount,
		recoverAmount: format(recoverAmount, { notation: 'fixed', precision: 2 }),
		badDebtTotal: format(badDebtTotal, { notation: 'fixed', precision: 2 }),
		unrecoverAmount: format(unrecoverAmount, { notation: 'fixed', precision: 2 }),
		otherAccountName: firstDefined(info.targetAcountsName, info.otherAccountName, ''),
		otherAccountNo: firstDefined(info.targetBankNo, info.otherAccountNo, ''),
		otherBankName: firstDefined(info.targetBankName, info.otherBankName, ''),
		selfPayAccountName: firstDefined(info.selfAcountsName, info.selfPayAccountName, ''),
		selfAccountNo: firstDefined(info.selfBankNo, info.selfAccountNo, info.bankNo, ''),
		selfBankName: firstDefined(info.selfBankName, ''),
		payTime: payTime ? (payTime + '').slice(0, 10) : '',
		reason: firstDefined(info.reason, '')
	};
}

export function buildSupplierDepositDiffFields(original = {}, changed = {}) {
	const beforeRow = mapSupplierDepositRecordToRow(original);
	const afterRow = mapSupplierDepositRecordToRow(changed);
	return SUPPLIER_DEPOSIT_SUMMARY_PROPS.reduce((diffFields, prop) => {
		diffFields[prop] = format(subtract(Number(afterRow[prop] || 0), Number(beforeRow[prop] || 0)), { notation: 'fixed', precision: 2 });
		return diffFields;
	}, {});
}

export function sumSupplierDepositDiffRows(rows = []) {
	return SUPPLIER_DEPOSIT_SUMMARY_PROPS.reduce((sums, prop) => {
		const total = rows.reduce((acc, row) => add(acc, Number(row[prop]) || 0), 0);
		sums[prop] = format(total, { notation: 'fixed', precision: 2 });
		return sums;
	}, {});
}
