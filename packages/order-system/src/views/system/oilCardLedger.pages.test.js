/* 用户需求：主卡和副卡登记台账新增成功后必须关闭弹窗并刷新页面。实际改动：测试共享页面使用有效的成功提示方法，并在提交成功后关闭弹窗、刷新列表。 */
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
	});
});
