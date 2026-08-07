// 需求：厂家佣金的库存来源记录使用 type=2，订单来源记录使用 type=1。
// 实际改动：回归校验 SupplierCommission 按 source 选择佣金类型。
/* eslint-env jest */
const fs = require('fs');
const path = require('path');

const source = fs.readFileSync(path.join(__dirname, '..', 'SupplierCommission.vue'), 'utf8');

test('厂家佣金应按库存来源切换为库存佣金类型', () => {
	expect(source).toMatch(/getCommissionType\(row\)[\s\S]*?source === TableName\.INVENTORDETAIL/);
	expect(source).toMatch(/type: this\.getCommissionType\(row\)/);
	expect(source).toMatch(/type: this\.getCommissionType\(\{ source \}\)/);
});
