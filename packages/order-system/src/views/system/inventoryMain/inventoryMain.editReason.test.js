// 用户需求：入库每次修改必须填写修改原因，并可按入库主表查看修改记录。
// 实际改动：新增入库修改原因、整单/明细更新载荷和修改记录查询入口的契约测试。
import fs from 'fs';
import path from 'path';
import { describe, expect, test } from '@jest/globals';

const componentPath = path.resolve(__dirname, 'index.vue');

describe('InventoryMain edit reason and history contract', () => {
	const source = fs.readFileSync(componentPath, 'utf8');

	test('adds the trimmed edit reason to both inventory update paths', () => {
		expect(source).toContain('payload.editReason = this.editReason.trim();');
		expect(source).toContain('submitPayload.editReason = this.editReason.trim();');
	});

	test('clears the edit reason when an edit session is cancelled or reset', () => {
		expect(source).toContain('this.editReason = null;');
		expect(source).toContain('this.clearEditReason();');
	});

	test('queries inventory edit history by the main table id with the required permission', () => {
		expect(source).toContain("import { listTableEditMessage } from '@/api/system/tableEditMessage';");
		expect(source).toContain("tableName: 'inventory_main'");
		expect(source).toContain('command="viewEditReason"');
		expect(source).toContain('v-hasPermi="[\'system:tableeditmessage:list\']"');
		expect(source).toContain('prop="modifyTime"');
		expect(source).toContain('prop="reason"');
		expect(source).toContain('prop="userName"');
	});

	test('validates reason length and whitespace before allowing updates', () => {
		expect(source).toContain('修改原因不能为空');
		expect(source).toContain('修改原因不能超过500个字符');
		expect(source).toContain('value.trim()');
	});
});
