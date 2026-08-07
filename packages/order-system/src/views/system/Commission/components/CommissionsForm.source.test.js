// 需求：修复客户佣金新增时 source 未传入请求体导致“来源表名不能为空”。
// 实际改动：回归校验佣金表单声明并保留 source 字段。
/* eslint-env jest */
const fs = require('fs');
const path = require('path');

const componentPath = path.join(__dirname, 'CommissionsForm.vue');
const componentSource = fs.readFileSync(componentPath, 'utf8');

test('佣金表单应将 source 保留在新增请求表单中', () => {
	expect(componentSource).toMatch(/source:\s*\{[\s\S]*?default:\s*null/);
	expect(componentSource).toMatch(/form:\s*\{[\s\S]*?source:\s*this\.source/);
});
