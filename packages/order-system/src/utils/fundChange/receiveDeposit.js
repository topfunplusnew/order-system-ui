import { add, format, subtract } from 'mathjs';

export const RECEIVE_DEPOSIT_SUMMARY_PROPS = Object.freeze(['depositAmount', 'unrefundAmount']);

function normalizeValue(value) {
	return typeof value === 'string' ? value.trim() : value;
}

function firstDefined(...values) {
	const value = values.find(item => item !== undefined && item !== null && item !== '');
	return value === undefined ? '' : normalizeValue(value);
}

function sumRefundMoney(list = []) {
	return (list || []).reduce((total, item) => {
		if (Number(item?.badDebtFlag || 0) === 1) return total;
		return add(total, Number(item?.moneyAmount || 0));
	}, 0);
}

function resolveUnrefundAmount(info = {}) {
	const hasUnrefundedAmount = info.unrefundedAmount !== undefined && info.unrefundedAmount !== null && info.unrefundedAmount !== '';
	if (hasUnrefundedAmount) return Number(info.unrefundedAmount || 0);
	return subtract(Number(info.moneyAmount || 0), sumRefundMoney(info.depositRefundList));
}

export function mapReceiveDepositRecordToRow(info = {}) {
	const receiveTime = firstDefined(info.depositDate, info.addtime, '');
	return {
		depositCompany: firstDefined(info.depositCompany, info.depositType, ''),
		objectType: firstDefined(info.targetType, info.companyType, info.objectType, ''),
		objectName: firstDefined(info.target, info.companyName, info.objectName, ''),
		depositAmount: info.moneyAmount,
		unrefundAmount: format(resolveUnrefundAmount(info), { notation: 'fixed', precision: 2 }),
		otherAccountName: firstDefined(info.targetAccountsName, info.otherAccountName, ''),
		otherAccountNo: firstDefined(info.targetBankNo, info.otherAccountNo, ''),
		otherBankName: firstDefined(info.targetBankName, info.otherBankName, ''),
		selfReceiveAccountName: firstDefined(info.selfAccountsName, info.selfAccountName, info.bankName, ''),
		selfAccountNo: firstDefined(info.selfBankNo, info.bankNo, ''),
		selfBankName: firstDefined(info.selfBankName, info.bankFullName, ''),
		receiveTime: receiveTime ? (receiveTime + '').slice(0, 10) : '',
		reason: firstDefined(info.reason, info.loanReason, ''),
		remark: firstDefined(info.comments, info.remark, ''),
		operatorName: firstDefined(info.userName, info.operatorName, info.createBy, '')
	};
}

export function buildReceiveDepositDiffFields(original = {}, changed = {}) {
	const beforeRow = mapReceiveDepositRecordToRow(original);
	const afterRow = mapReceiveDepositRecordToRow(changed);
	return RECEIVE_DEPOSIT_SUMMARY_PROPS.reduce((diffFields, prop) => {
		diffFields[prop] = format(subtract(Number(afterRow[prop] || 0), Number(beforeRow[prop] || 0)), { notation: 'fixed', precision: 2 });
		return diffFields;
	}, {});
}

export function sumReceiveDepositDiffRows(rows = []) {
	return RECEIVE_DEPOSIT_SUMMARY_PROPS.reduce((sums, prop) => {
		const total = rows.reduce((acc, row) => add(acc, Number(row[prop]) || 0), 0);
		sums[prop] = format(total, { notation: 'fixed', precision: 2 });
		return sums;
	}, {});
}
