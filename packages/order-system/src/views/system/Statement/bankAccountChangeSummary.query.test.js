/*
 * 用户需求：资金（银行）当日发生业务统计，选好搜索日期后切换界面回来要保留搜索时间，不能重置为默认当天。
 * 实际改动：搜索时把日期写入 sessionStorage，进入页面时优先恢复；无记录时才用默认当天。
 */
/* global describe, test, expect, beforeEach, jest */
import { BANK_ACCOUNT_CHANGE_SUMMARY_QUERY_KEY, readSavedEndTime, resolveInitialEndTime, saveEndTime } from './bankAccountChangeSummary.query';

/** 简易的 Storage 假实现，便于断言读写行为 */
function createFakeStorage() {
	const map = new Map();
	return {
		getItem: jest.fn(key => (map.has(key) ? map.get(key) : null)),
		setItem: jest.fn((key, value) => map.set(key, String(value))),
		removeItem: jest.fn(key => map.delete(key)),
		_map: map
	};
}

describe('资金当日发生业务统计：搜索日期保留', () => {
	let storage;

	beforeEach(() => {
		storage = createFakeStorage();
	});

	test('没有保存过时使用默认当天', () => {
		expect(resolveInitialEndTime(storage, '2026-09-30')).toBe('2026-09-30');
	});

	test('保存后再次进入使用上次搜索的日期（不回到当天）', () => {
		saveEndTime(storage, '2026-08-15');

		expect(readSavedEndTime(storage)).toBe('2026-08-15');
		expect(resolveInitialEndTime(storage, '2026-09-30')).toBe('2026-08-15');
	});

	test('再次搜索会覆盖上一次的日期', () => {
		saveEndTime(storage, '2026-08-15');
		saveEndTime(storage, '2026-08-20');

		expect(readSavedEndTime(storage)).toBe('2026-08-20');
	});

	test('保存的 key 与约定一致（便于和其它页面的本地缓存区分）', () => {
		saveEndTime(storage, '2026-08-15');

		expect(storage.setItem).toHaveBeenCalledWith(BANK_ACCOUNT_CHANGE_SUMMARY_QUERY_KEY, JSON.stringify({ endTime: '2026-08-15' }));
	});

	test('搜索时清空日期会清掉记录，下次进入回到默认当天', () => {
		saveEndTime(storage, '2026-08-15');
		saveEndTime(storage, '');

		expect(readSavedEndTime(storage)).toBeNull();
		expect(resolveInitialEndTime(storage, '2026-09-30')).toBe('2026-09-30');
	});

	test('脏数据不会导致报错，并会被清理', () => {
		storage.setItem(BANK_ACCOUNT_CHANGE_SUMMARY_QUERY_KEY, 'not-json{');

		expect(readSavedEndTime(storage)).toBeNull();
		expect(storage.removeItem).toHaveBeenCalledWith(BANK_ACCOUNT_CHANGE_SUMMARY_QUERY_KEY);
	});

	test('保存结构里缺少 endTime 时按没有记录处理', () => {
		storage.setItem(BANK_ACCOUNT_CHANGE_SUMMARY_QUERY_KEY, JSON.stringify({ other: 1 }));

		expect(readSavedEndTime(storage)).toBeNull();
		expect(resolveInitialEndTime(storage, '2026-09-30')).toBe('2026-09-30');
	});

	test('storage 不可用（被禁用/未注入）时安全降级为默认当天', () => {
		expect(readSavedEndTime(null)).toBeNull();
		expect(readSavedEndTime(undefined)).toBeNull();
		expect(saveEndTime(null, '2026-08-15')).toBe(false);
		expect(resolveInitialEndTime(null, '2026-09-30')).toBe('2026-09-30');
	});
});
