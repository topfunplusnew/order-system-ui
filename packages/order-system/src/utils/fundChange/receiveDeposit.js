import { add, format, subtract } from 'mathjs';
import { CHANGE_ROW_SCOPE, getScopedRowCount, getScopedRowTypes, normalizeFundChangeDate } from '@/utils/fundChange/dateScopedRows';

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
	return subtract(Number(info.moneyAmount || 0), sumRefundMoney(info.depositRefundList));
}

function getRefundDate(refund = {}) {
	return firstDefined(refund.refundDate, refund.payDate, refund.addtime, '');
}

function hasRecordData(info = {}) {
	return Object.keys(info || {}).length > 0;
}

function hasScopedRefundDate(info = {}, targetDate = '') {
	const normalizedTargetDate = normalizeFundChangeDate(targetDate);
	if (!normalizedTargetDate) return hasRecordData(info);
	return (info.depositRefundList || []).some(refund => normalizeFundChangeDate(getRefundDate(refund)) === normalizedTargetDate);
}

function hasScopedMainDate(info = {}, targetDate = '') {
	const normalizedTargetDate = normalizeFundChangeDate(targetDate);
	if (!normalizedTargetDate) return hasRecordData(info);
	return [info.depositDate].some(date => normalizeFundChangeDate(date) === normalizedTargetDate);
}

export function hasReceiveDepositScopedData(info = {}, targetDate = '') {
	if (!hasRecordData(info)) return false;
	if (!normalizeFundChangeDate(targetDate)) return true;
	return hasScopedMainDate(info, targetDate) || hasScopedRefundDate(info, targetDate);
}

export function resolveReceiveDepositScopedChange(original = {}, changed = {}, targetDate = '') {
	const normalizedTargetDate = normalizeFundChangeDate(targetDate);
	if (!normalizedTargetDate) return CHANGE_ROW_SCOPE.BOTH;
	const beforeMatches = hasReceiveDepositScopedData(original, targetDate);
	const afterMatches = hasReceiveDepositScopedData(changed, targetDate);
	if (beforeMatches && afterMatches) return CHANGE_ROW_SCOPE.BOTH;
	if (beforeMatches) return CHANGE_ROW_SCOPE.BEFORE;
	if (afterMatches) return CHANGE_ROW_SCOPE.AFTER;
	return CHANGE_ROW_SCOPE.NONE;
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

export function buildReceiveDepositRecordRows({ original = {}, changed = {}, targetDate = '', backupType = '', recordIndex, backupTime } = {}) {
	const scope = resolveReceiveDepositScopedChange(original, changed, targetDate);
	const rowTypes = getScopedRowTypes(scope, backupType);
	if (!rowTypes.length) return [];

	const recordRowCount = getScopedRowCount(scope, 1, backupType);
	const rows = [];
	if (rowTypes.includes('before')) rows.push({ ...mapReceiveDepositRecordToRow(original), recordIndex, backupTime, rowType: 'before', subLabel: '修改前', recordRowCount });
	if (rowTypes.includes('after')) rows.push({ ...mapReceiveDepositRecordToRow(changed), recordIndex, backupTime, rowType: 'after', subLabel: '修改后', recordRowCount });

	rows.push({ rowType: 'diff', subLabel: '差额', recordRowCount, ...buildReceiveDepositDiffFields(original, changed) });
	rows[0].isRecordFirst = true;
	return rows;
}

export function sumReceiveDepositDiffRows(rows = []) {
	return RECEIVE_DEPOSIT_SUMMARY_PROPS.reduce((sums, prop) => {
		const total = rows.reduce((acc, row) => add(acc, Number(row[prop]) || 0), 0);
		sums[prop] = format(total, { notation: 'fixed', precision: 2 });
		return sums;
	}, {});
}
