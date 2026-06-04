export const CHANGE_ROW_SCOPE = Object.freeze({
	BOTH: 'both',
	BEFORE: 'before',
	AFTER: 'after',
	NONE: 'none'
});

export function normalizeFundChangeDate(value) {
	if (value === undefined || value === null || value === '') return '';
	if (value instanceof Date) {
		const year = value.getFullYear();
		const month = String(value.getMonth() + 1).padStart(2, '0');
		const day = String(value.getDate()).padStart(2, '0');
		return `${year}-${month}-${day}`;
	}
	return String(value).slice(0, 10);
}

export function pickFundChangeDate(info = {}, dateFields = []) {
	for (const field of dateFields) {
		const value = info?.[field];
		const date = normalizeFundChangeDate(value);
		if (date) return date;
	}
	return '';
}

export function resolveDateScopedChange(original = {}, changed = {}, targetDate = '', dateFields = []) {
	const normalizedTargetDate = normalizeFundChangeDate(targetDate);
	if (!normalizedTargetDate) return CHANGE_ROW_SCOPE.BOTH;

	const beforeDate = pickFundChangeDate(original, dateFields);
	const afterDate = pickFundChangeDate(changed, dateFields);
	if (!beforeDate && !afterDate) return CHANGE_ROW_SCOPE.BOTH;

	const beforeMatches = beforeDate === normalizedTargetDate;
	const afterMatches = afterDate === normalizedTargetDate;
	if (beforeMatches && afterMatches) return CHANGE_ROW_SCOPE.BOTH;
	if (beforeMatches) return CHANGE_ROW_SCOPE.BEFORE;
	if (afterMatches) return CHANGE_ROW_SCOPE.AFTER;
	return CHANGE_ROW_SCOPE.NONE;
}

function isUpdateBackupType(backupType = '') {
	return String(backupType).toLowerCase() === 'update';
}

export function getScopedRowTypes(scope, backupType = '') {
	if (isUpdateBackupType(backupType) && scope !== CHANGE_ROW_SCOPE.NONE) return ['before', 'after'];
	if (scope === CHANGE_ROW_SCOPE.BEFORE) return ['before'];
	if (scope === CHANGE_ROW_SCOPE.AFTER) return ['after'];
	if (scope === CHANGE_ROW_SCOPE.NONE) return [];
	return ['before', 'after'];
}

export function getScopedRowCount(scope, detailCount = 1, backupType = '') {
	const rowTypeCount = getScopedRowTypes(scope, backupType).length;
	return rowTypeCount ? rowTypeCount * detailCount + 1 : 0;
}

export function buildDateScopedDiffFields(original = {}, changed = {}, scope = CHANGE_ROW_SCOPE.BOTH, buildDiffFields) {
	if (typeof buildDiffFields !== 'function') return {};
	if (scope === CHANGE_ROW_SCOPE.BEFORE) return buildDiffFields(original, {});
	if (scope === CHANGE_ROW_SCOPE.AFTER) return buildDiffFields({}, changed);
	if (scope === CHANGE_ROW_SCOPE.NONE) return {};
	return buildDiffFields(original, changed);
}

function hasDetailData(detail = {}) {
	return Object.keys(detail || {}).some(key => detail[key] !== undefined && detail[key] !== null && detail[key] !== '');
}

export function filterDetailPairsByScope(pairs = [], scope = CHANGE_ROW_SCOPE.BOTH, backupType = '') {
	if (scope === CHANGE_ROW_SCOPE.NONE) return [];
	if (isUpdateBackupType(backupType)) return pairs;
	if (scope === CHANGE_ROW_SCOPE.BOTH) return pairs;

	const visibleField = scope === CHANGE_ROW_SCOPE.BEFORE ? 'original' : 'changed';
	const filtered = (pairs || []).filter(pair => hasDetailData(pair?.[visibleField]));
	if (filtered.length) return filtered;

	return (pairs || []).filter(pair => pair?.key === 'empty:0');
}

export function buildDateScopedRecordRows({ original = {}, changed = {}, targetDate = '', dateFields = [], backupType = '', beforeRow = {}, afterRow = {}, buildDiffFields } = {}) {
	const scope = resolveDateScopedChange(original, changed, targetDate, dateFields);
	const rowTypes = getScopedRowTypes(scope, backupType);
	if (!rowTypes.length) return [];

	const recordRowCount = getScopedRowCount(scope, 1, backupType);
	const rows = [];
	if (rowTypes.includes('before')) rows.push({ ...beforeRow, rowType: 'before', subLabel: beforeRow.subLabel || '修改前', recordRowCount });
	if (rowTypes.includes('after')) rows.push({ ...afterRow, rowType: 'after', subLabel: afterRow.subLabel || '修改后', recordRowCount });

	const diffFields = buildDateScopedDiffFields(original, changed, scope, buildDiffFields);
	rows.push({ rowType: 'diff', subLabel: '差额', recordRowCount, ...diffFields });

	rows[0].isRecordFirst = true;
	return rows;
}
