import { describe, expect, test } from '@jest/globals';
import { buildChildSubjectNo, isValidParentId, shouldAutoGenerateSubjectNo } from './subjectNo';

describe('isValidParentId', () => {
	test('根节点 0 与空值都不是可继承编码的父级', () => {
		expect(isValidParentId(0)).toBe(false);
		expect(isValidParentId('0')).toBe(false);
		expect(isValidParentId(null)).toBe(false);
		expect(isValidParentId(undefined)).toBe(false);
		expect(isValidParentId('')).toBe(false);
	});

	test('真实父级 id 有效', () => {
		expect(isValidParentId(1)).toBe(true);
		expect(isValidParentId('12')).toBe(true);
	});
});

describe('shouldAutoGenerateSubjectNo', () => {
	test('新增（recordId 为空）且选了有效父级时才允许自动生成编码', () => {
		expect(shouldAutoGenerateSubjectNo({ recordId: null, parentId: 1 })).toBe(true);
		expect(shouldAutoGenerateSubjectNo({ recordId: undefined, parentId: 1 })).toBe(true);
		expect(shouldAutoGenerateSubjectNo({ recordId: '', parentId: '12' })).toBe(true);
	});

	test('新增在根节点下不自动生成（保持手动录入）', () => {
		expect(shouldAutoGenerateSubjectNo({ recordId: null, parentId: 0 })).toBe(false);
		expect(shouldAutoGenerateSubjectNo({ recordId: null, parentId: null })).toBe(false);
	});

	// 回归：后端反馈「修改科目时前端会把科目编码也改掉」
	test('修改（recordId 有值）一律不允许自动生成编码', () => {
		expect(shouldAutoGenerateSubjectNo({ recordId: 2, parentId: 1 })).toBe(false);
		expect(shouldAutoGenerateSubjectNo({ recordId: 2, parentId: 8 })).toBe(false);
		expect(shouldAutoGenerateSubjectNo({ recordId: '2', parentId: 1 })).toBe(false);
	});
});

describe('buildChildSubjectNo', () => {
	test('父级编码 + 3 位序号，且与原有 00N 拼接结果一致', () => {
		expect(buildChildSubjectNo('1001', [])).toBe('1001001');
		expect(buildChildSubjectNo('1001', ['1001001'])).toBe('1001002');
		expect(buildChildSubjectNo('1001', ['1001001', '1001002'])).toBe('1001003');
	});

	test('子科目超过 9 个时序号仍然保持 3 位（老实现会拼出 4 位）', () => {
		const siblings = Array.from({ length: 10 }, (_, index) => `1001${String(index + 1).padStart(3, '0')}`);
		expect(buildChildSubjectNo('1001', siblings)).toBe('1001011');
	});

	test('跳过已被占用的编码，不生成重复编码', () => {
		expect(buildChildSubjectNo('1001', ['1001001', '1001002', '1001004'])).toBe('1001005');
		expect(buildChildSubjectNo('1001', ['1001001', '1001001'])).toBe('1001003');
	});

	test('父级编码取不到时返回空串，交给用户手动录入', () => {
		expect(buildChildSubjectNo('')).toBe('');
		expect(buildChildSubjectNo(null)).toBe('');
		expect(buildChildSubjectNo(undefined)).toBe('');
		expect(buildChildSubjectNo('   ')).toBe('');
	});

	test('兼容父级编码为数字、同级编码为 null 的脏数据', () => {
		expect(buildChildSubjectNo(1001, [null, '1001001', undefined])).toBe('1001002');
	});
});
