import { format, subtract, add } from 'mathjs';

export const FUTURES_DEPOSIT_SUMMARY_PROPS = Object.freeze(['marginAmount', 'recoverAmount', 'badDebtTotal', 'unrecoverAmount']);

function firstDefined(...values) {
	const value = values.find(item => item !== undefined && item !== null && item !== '');
	return value === undefined ? '' : value;
}

function sumRecoverMoney(list = [], badDebtFlag) {
	return (list || []).reduce((total, item) => {
		const isBadDebt = Number(item?.badDebtFlag || 0) === 1;
		if (badDebtFlag === 1 && !isBadDebt) return total;
		if (badDebtFlag !== 1 && isBadDebt) return total;
		return add(total, Number(item?.moneyAmount || 0));
	}, 0);
}

export function mapFuturesDepositRecordToRow(info = {}) {
	const payTime = firstDefined(info.futuresDate, info.addtime, '');
	const recoverAmount = sumRecoverMoney(info.recoverMoneyList, 0);
	const badDebtTotal = sumRecoverMoney(info.recoverMoneyList, 1);
	const hasUnrecoverAmount = info.unrecoveredAmount !== undefined && info.unrecoveredAmount !== null && info.unrecoveredAmount !== '';
	const unrecoverAmount = hasUnrecoverAmount ? Number(info.unrecoveredAmount || 0) : subtract(subtract(Number(info.moneyAmount || 0), recoverAmount), badDebtTotal);
	return {
		futuresCompany: firstDefined(info.futuresMarginCompany, info.target, info.targetAcountsName, info.companyName, info.borrowerName, ''),
		companyName: firstDefined(info.target, info.companyName, info.targetAcountsName, info.borrowerName, ''),
		objectType: firstDefined(info.targetType, info.objectType, ''),
		marginAmount: info.moneyAmount,
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
		reason: firstDefined(info.reason, ''),
		remark: firstDefined(info.comments, info.remark, '')
	};
}

export function buildFuturesDepositDiffFields(original = {}, changed = {}) {
	const beforeRow = mapFuturesDepositRecordToRow(original);
	const afterRow = mapFuturesDepositRecordToRow(changed);
	return FUTURES_DEPOSIT_SUMMARY_PROPS.reduce((diffFields, prop) => {
		diffFields[prop] = format(subtract(Number(afterRow[prop] || 0), Number(beforeRow[prop] || 0)), { notation: 'fixed', precision: 2 });
		return diffFields;
	}, {});
}

export function sumFuturesDepositDiffRows(rows = []) {
	return FUTURES_DEPOSIT_SUMMARY_PROPS.reduce((sums, prop) => {
		const total = rows.reduce((acc, row) => add(acc, Number(row[prop]) || 0), 0);
		sums[prop] = format(total, { notation: 'fixed', precision: 2 });
		return sums;
	}, {});
}
