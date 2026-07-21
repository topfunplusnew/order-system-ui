/* 用户需求：主卡和副卡登记表单参考 OilCardConsume 自动计算加油金额。实际改动：测试共享页面在加油量、单价变化时调用统一计算方法，并保留提交成功回调测试。 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

const readView = relativePath => fs.readFileSync(path.resolve(__dirname, relativePath), 'utf8');

describe('oil card ledger pages', () => {
	test('main-card entry fixes the card type and permission namespace', () => {
		const source = readView('./oilCardLedgerMain/index.vue');

		expect(source).toContain('card-type="主卡"');
		expect(source).toContain('permission-prefix="system:oilcardledgermain"');
		expect(source).toContain('table-name="oil-card-ledger-main-columns"');
	});

	test('sub-card entry fixes the card type and permission namespace', () => {
		const source = readView('./oilCardLedgerSub/index.vue');

		expect(source).toContain('card-type="副卡"');
		expect(source).toContain('permission-prefix="system:oilcardledgersub"');
		expect(source).toContain('table-name="oil-card-ledger-sub-columns"');
	});

	test('shared page implements the approved API data flow', () => {
		const source = readView('./components/OilCardLedgerPage.vue');

		expect(source).toContain('listOilCardLedger(buildLedgerQuery(this.queryParams, this.cardType, this.dateRange))');
		expect(source).toContain('listOilCard({ oilType: this.cardType, pageNum: 1, pageSize: 1000 })');
		expect(source).toContain('listVehicles({ pageNum: 1, pageSize: 1000 })');
		expect(source).toContain('getOilCardLedger(id)');
		expect(source).toContain('buildLedgerPayload(this.form, this.cardType, Boolean(this.form.id))');
		expect(source).toContain('delOilCardLedger(serializeLedgerIds(ids))');
		expect(source).toContain("this.download('/system/oilCardLedger/export', exportParams");
		expect(source).toContain('v-if="cardType === \'主卡\'"');
		expect(source).toContain("this.$modal.msgSuccess(this.form.id ? '修改成功' : '新增成功');");
		expect(source).toContain('this.open = false;');
		expect(source).toContain('this.getList();');
		expect(source).not.toContain('this.msgSuccess(');
		expect(source).toContain('@change="calculateRefuelingAmount"');
		expect(source).toContain('this.form.refuelingAmount = calculateLedgerRefuelingAmount(this.form.refuelingVolume, this.form.unitPrice);');
	});
});
