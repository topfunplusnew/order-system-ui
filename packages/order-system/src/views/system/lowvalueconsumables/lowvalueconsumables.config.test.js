import { describe, expect, test } from '@jest/globals';
import { createLowvalueconsumablesColumns, createLowvalueconsumablesForm, createLowvalueconsumablesRules } from '@/views/system/lowvalueconsumables/lowvalueconsumables.config';

describe('lowvalueconsumables config', () => {
	test('adds optional usePerson and keeps department optional', () => {
		const columns = createLowvalueconsumablesColumns();
		const form = createLowvalueconsumablesForm();
		const rules = createLowvalueconsumablesRules();

		expect(columns.map(column => column.label)).toEqual(['购入日期', '资产编号', '资产名称', '规格型号', '数量', '计量单位', '含税金额', '不含税金额', '户名名称', '使用部门', '使用人', '低值易耗品台账清理时间', '清理/变卖价值', '备注']);
		expect(form.department).toBeNull();
		expect(form.usePerson).toBeNull();
		expect(rules.department).toBeUndefined();
		expect(rules.usePerson).toBeUndefined();
	});
});
