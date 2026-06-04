import { describe, expect, test } from '@jest/globals';
import { CHANGE_ROW_SCOPE, buildDateScopedDiffFields, buildDateScopedRecordRows, filterDetailPairsByScope, resolveDateScopedChange } from '@/utils/fundChange/dateScopedRows';

describe('date scoped fund change rows', () => {
	test('shows only the before row when the original date matches the selected date', () => {
		expect(resolveDateScopedChange({ fundsDate: '2026-04-04 09:00:00' }, { fundsDate: '2026-04-06 09:00:00' }, '2026-04-04', ['fundsDate'])).toBe(CHANGE_ROW_SCOPE.BEFORE);
	});

	test('shows only the after row when the changed date matches the selected date', () => {
		expect(resolveDateScopedChange({ fundsDate: '2026-04-04' }, { fundsDate: '2026-04-06' }, '2026-04-06', ['fundsDate'])).toBe(CHANGE_ROW_SCOPE.AFTER);
	});

	test('keeps the original pair when both sides are on the selected date', () => {
		expect(resolveDateScopedChange({ fundsDate: '2026-04-04' }, { fundsDate: '2026-04-04' }, '2026-04-04', ['fundsDate'])).toBe(CHANGE_ROW_SCOPE.BOTH);
	});

	test('drops records whose business dates do not match the selected date', () => {
		expect(resolveDateScopedChange({ fundsDate: '2026-04-05' }, { fundsDate: '2026-04-06' }, '2026-04-04', ['fundsDate'])).toBe(CHANGE_ROW_SCOPE.NONE);
	});

	test('uses delete-style and add-style diffs for single-sided rows', () => {
		const diffBuilder = (original = {}, changed = {}) => ({ amount: Number(changed.amount || 0) - Number(original.amount || 0) });

		expect(buildDateScopedDiffFields({ amount: 100 }, { amount: 150 }, CHANGE_ROW_SCOPE.BEFORE, diffBuilder)).toEqual({ amount: -100 });
		expect(buildDateScopedDiffFields({ amount: 100 }, { amount: 150 }, CHANGE_ROW_SCOPE.AFTER, diffBuilder)).toEqual({ amount: 150 });
		expect(buildDateScopedDiffFields({ amount: 100 }, { amount: 150 }, CHANGE_ROW_SCOPE.BOTH, diffBuilder)).toEqual({ amount: 50 });
	});

	test('filters detail pairs to the visible side while preserving empty main rows', () => {
		const pairs = [
			{ key: 'a', original: { id: 1 }, changed: { id: 1 } },
			{ key: 'b', original: {}, changed: { id: 2 } }
		];

		expect(filterDetailPairsByScope(pairs, CHANGE_ROW_SCOPE.BEFORE)).toEqual([{ key: 'a', original: { id: 1 }, changed: { id: 1 } }]);
		expect(filterDetailPairsByScope([{ key: 'empty:0', original: {}, changed: {} }], CHANGE_ROW_SCOPE.AFTER)).toEqual([{ key: 'empty:0', original: {}, changed: {} }]);
	});

	test('builds rows with the visible row marked as the merged record row', () => {
		const rows = buildDateScopedRecordRows({
			original: { fundsDate: '2026-04-04', amount: 100 },
			changed: { fundsDate: '2026-04-06', amount: 150 },
			targetDate: '2026-04-06',
			dateFields: ['fundsDate'],
			beforeRow: { amount: 100 },
			afterRow: { amount: 150 },
			buildDiffFields: (original = {}, changed = {}) => ({ amount: Number(changed.amount || 0) - Number(original.amount || 0) })
		});

		expect(rows).toEqual([
			{ amount: 150, rowType: 'after', subLabel: '修改后', isRecordFirst: true, recordRowCount: 2 },
			{ rowType: 'diff', subLabel: '差额', recordRowCount: 2, amount: 150 }
		]);
	});

	test('shows both rows for update records while keeping date-scoped diff semantics', () => {
		const rows = buildDateScopedRecordRows({
			original: { fundsDate: '2026-05-17 10:08:48', amount: 15 },
			changed: { fundsDate: '2026-05-16 22:08:48', amount: 15 },
			targetDate: '2026-05-17',
			dateFields: ['fundsDate'],
			backupType: 'update',
			beforeRow: { amount: 15 },
			afterRow: { amount: 15 },
			buildDiffFields: (original = {}, changed = {}) => ({ amount: Number(changed.amount || 0) - Number(original.amount || 0) })
		});

		expect(rows).toEqual([
			{ amount: 15, rowType: 'before', subLabel: '修改前', isRecordFirst: true, recordRowCount: 3 },
			{ amount: 15, rowType: 'after', subLabel: '修改后', recordRowCount: 3 },
			{ rowType: 'diff', subLabel: '差额', recordRowCount: 3, amount: -15 }
		]);
	});
});
