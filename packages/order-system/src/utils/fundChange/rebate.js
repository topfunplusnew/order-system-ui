import { add, format, subtract } from 'mathjs';
import { CHANGE_ROW_SCOPE, getScopedRowCount, getScopedRowTypes, normalizeFundChangeDate } from '@/utils/fundChange/dateScopedRows';

export const REBATE_SUMMARY_PROPS = Object.freeze(['receivedAmount']);

function firstDefined(...values) {
	const value = values.find(item => item !== undefined && item !== null && item !== '');
	return value === undefined ? '' : value;
}

function formatAmount(value) {
	return format(Number(value || 0), { notation: 'fixed', precision: 2 });
}

function formatRebateMethod(value) {
	if (value === 2 || value === '2' || value === '面积') return '面积';
	if (value === 1 || value === '1' || value === '重箱') return '重箱';
	return value || '';
}

function getDetailList(info = {}) {
	return info.detailList || info.rebateDetailList || [];
}

function getDetailDate(detail = {}) {
	return firstDefined(detail.actualReceivedDate, detail.receivedDate, detail.rebateDate, '');
}

function hasRecordData(info = {}) {
	return Object.keys(info || {}).length > 0;
}

function getScopedDetailList(info = {}, targetDate = '') {
	const normalizedTargetDate = normalizeFundChangeDate(targetDate);
	const detailList = getDetailList(info);
	if (!normalizedTargetDate) return detailList;
	return detailList.filter(detail => normalizeFundChangeDate(getDetailDate(detail)) === normalizedTargetDate);
}

function hasScopedMainDate(info = {}, targetDate = '') {
	const normalizedTargetDate = normalizeFundChangeDate(targetDate);
	if (!normalizedTargetDate) return hasRecordData(info);
	return [info.rebateDate, info.receivedRebateDate].some(date => normalizeFundChangeDate(date) === normalizedTargetDate);
}

export function hasRebateScopedData(info = {}, targetDate = '') {
	if (!hasRecordData(info)) return false;
	if (!normalizeFundChangeDate(targetDate)) return true;
	return getScopedDetailList(info, targetDate).length > 0 || hasScopedMainDate(info, targetDate);
}

export function resolveRebateScopedChange(original = {}, changed = {}, targetDate = '') {
	const normalizedTargetDate = normalizeFundChangeDate(targetDate);
	if (!normalizedTargetDate) return CHANGE_ROW_SCOPE.BOTH;
	const beforeMatches = hasRebateScopedData(original, targetDate);
	const afterMatches = hasRebateScopedData(changed, targetDate);
	if (beforeMatches && afterMatches) return CHANGE_ROW_SCOPE.BOTH;
	if (beforeMatches) return CHANGE_ROW_SCOPE.BEFORE;
	if (afterMatches) return CHANGE_ROW_SCOPE.AFTER;
	return CHANGE_ROW_SCOPE.NONE;
}

function getReceivedAmount(detailList = []) {
	return (detailList || []).reduce((total, item) => add(total, Number(item.actualReceived ?? item.moneyAmount ?? 0) || 0), 0);
}

function getFirstReceivedDate(detailList = []) {
	const dates = detailList.map(getDetailDate).filter(Boolean).sort();
	return dates[0] || '';
}

export function mapRebateRecordToRow(info = {}, targetDate = '', includeRow = true) {
	if (!includeRow || !hasRecordData(info)) return {};
	const detailList = getScopedDetailList(info, targetDate);
	const receivedAmount = getReceivedAmount(detailList);
	const receivedDate = getFirstReceivedDate(detailList);
	const hasReceivedAmount = detailList.length > 0;
	return {
		rebateDate: firstDefined(info.rebateDate, ''),
		rebateType: firstDefined(info.rebateType, ''),
		supplierName: firstDefined(info.supplier, info.supplierName, info.companyName, ''),
		rebateMethod: formatRebateMethod(info.rebateMethod),
		unitPrice: info.unitPrice,
		rebateAmount: info.rebate,
		rebateReason: firstDefined(info.rebateReason, ''),
		receivedDate: receivedDate || firstDefined(info.receivedRebateDate, ''),
		receivedAmount: hasReceivedAmount ? formatAmount(receivedAmount) : '未收到',
		actualReceivedTime: receivedDate,
		actualReceivedAmount: hasReceivedAmount ? formatAmount(receivedAmount) : '',
		remark: firstDefined(info.comments, info.remark, '')
	};
}

export function buildRebateDiffFields(original = {}, changed = {}, targetDate = '') {
	const beforeRow = mapRebateRecordToRow(original, targetDate, hasRecordData(original));
	const afterRow = mapRebateRecordToRow(changed, targetDate, hasRecordData(changed));
	const receivedAmount = format(subtract(Number(afterRow.receivedAmount || 0), Number(beforeRow.receivedAmount || 0)), { notation: 'fixed', precision: 2 });
	return {
		receivedAmount,
		supplierDiff: receivedAmount
	};
}

export function buildRebateRecordRows({ original = {}, changed = {}, targetDate = '', backupType = '', recordIndex, backupTime } = {}) {
	const scope = resolveRebateScopedChange(original, changed, targetDate);
	const rowTypes = getScopedRowTypes(scope, backupType);
	if (!rowTypes.length) return [];

	const beforeMatches = scope === CHANGE_ROW_SCOPE.BOTH || scope === CHANGE_ROW_SCOPE.BEFORE || !normalizeFundChangeDate(targetDate);
	const afterMatches = scope === CHANGE_ROW_SCOPE.BOTH || scope === CHANGE_ROW_SCOPE.AFTER || !normalizeFundChangeDate(targetDate);
	const recordRowCount = getScopedRowCount(scope, 1, backupType);
	const rows = [];
	if (rowTypes.includes('before')) rows.push({ ...mapRebateRecordToRow(original, targetDate, beforeMatches), recordIndex, backupTime, rowType: 'before', subLabel: '修改前', recordRowCount });
	if (rowTypes.includes('after')) rows.push({ ...mapRebateRecordToRow(changed, targetDate, afterMatches), recordIndex, backupTime, rowType: 'after', subLabel: '修改后', recordRowCount });

	const diffOriginal = beforeMatches ? original : {};
	const diffChanged = afterMatches ? changed : {};
	rows.push({ rowType: 'diff', subLabel: '差额', recordRowCount, ...buildRebateDiffFields(diffOriginal, diffChanged, targetDate) });
	rows[0].isRecordFirst = true;
	return rows;
}

export function sumRebateDiffRows(rows = []) {
	return REBATE_SUMMARY_PROPS.reduce((sums, prop) => {
		const total = rows.reduce((acc, row) => add(acc, Number(row[prop]) || 0), 0);
		sums[prop] = format(total, { notation: 'fixed', precision: 2 });
		return sums;
	}, {});
}
