import fs from 'fs';
import path from 'path';
import { describe, expect, jest, test } from '@jest/globals';

jest.mock('../../../../../ui-components/components/FundChangeTemplates/OrderAdjustmentTemplate/index.vue', () => ({ name: 'OrderAdjustmentTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/InventoryChangeTemplate/index.vue', () => ({ name: 'InventoryChangeTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/ReceiveMoneyTemplate/index.vue', () => ({ name: 'ReceiveMoneyTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/PaymentTemplate/index.vue', () => ({ name: 'PaymentTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/SecondOutboundTemplate/index.vue', () => ({ name: 'SecondOutboundTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/TicketPointTemplate/index.vue', () => ({ name: 'TicketPointTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/OffsetPaymentTemplate/index.vue', () => ({ name: 'OffsetPaymentTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/BalanceAccountTemplate/index.vue', () => ({ name: 'BalanceAccountTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/BorrowInTemplate/index.vue', () => ({ name: 'BorrowInTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/BorrowFromCompanyTemplate/index.vue', () => ({ name: 'BorrowFromCompanyTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/ReceiveDepositTemplate/index.vue', () => ({ name: 'ReceiveDepositTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/FuturesDepositTemplate/index.vue', () => ({ name: 'FuturesDepositTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/SupplierDepositTemplate/index.vue', () => ({ name: 'SupplierDepositTemplate' }));
jest.mock('../../../../../ui-components/components/FundChangeTemplates/RebateTemplate/index.vue', () => ({ name: 'RebateTemplate' }), { virtual: true });

import { TOTAL_LOGIC_DETAIL_MAP, resolveFundChangeTemplateConfig } from './fundChangeConfig';

function collectSourceFiles(dir) {
	return fs.readdirSync(dir, { withFileTypes: true }).flatMap(entry => {
		const absolutePath = path.join(dir, entry.name);
		if (entry.isDirectory()) return collectSourceFiles(absolutePath);
		return /\.(js|vue)$/.test(entry.name) ? [absolutePath] : [];
	});
}

describe('fund change template config', () => {
	test('source code does not import or fall back to deprecated CommonChange', () => {
		const srcDir = path.resolve(__dirname, '../../..');
		const allowedFiles = new Set([path.resolve(srcDir, 'views/dashboard/backuplog/goodsorder/CommonChange.vue'), __filename]);
		const offenders = collectSourceFiles(srcDir)
			.filter(file => !allowedFiles.has(file))
			.filter(file => fs.readFileSync(file, 'utf8').includes('CommonChange'))
			.map(file => path.relative(srcDir, file));

		expect(offenders).toEqual([]);
	});

	test('covers every total-logic detail table/category with a dedicated template config', () => {
		const missing = [];

		Object.entries(TOTAL_LOGIC_DETAIL_MAP).forEach(([outputKey, parts]) => {
			parts.forEach(part => {
				const config = resolveFundChangeTemplateConfig({ outputKey, tableName: part.tableName, category: part.category });
				if (!config?.component) missing.push(`${outputKey}:${part.tableName}:${part.category}`);
			});
		});

		expect(missing).toEqual([]);
	});

	test('routes lendmoney business categories to their one-to-one templates', () => {
		expect(resolveFundChangeTemplateConfig({ outputKey: 'selfCompanyTotalFunds', tableName: 'lendmoney', category: 'personal_loan' }).component.name).toBe('BorrowFromCompanyTemplate');
		expect(resolveFundChangeTemplateConfig({ outputKey: 'selfCompanyTotalFunds', tableName: 'lendmoney', category: 'futures_margin' }).component.name).toBe('FuturesDepositTemplate');
		expect(resolveFundChangeTemplateConfig({ outputKey: 'selfCompanyTotalFunds', tableName: 'lendmoney', category: 'factory_deposit' }).component.name).toBe('SupplierDepositTemplate');
		expect(resolveFundChangeTemplateConfig({ outputKey: 'futuresMarginBalance', tableName: 'lendmoney', category: '*' }).component.name).toBe('FuturesDepositTemplate');
		expect(resolveFundChangeTemplateConfig({ outputKey: 'paymentMarginBalance', tableName: 'lendmoney', category: '*' }).component.name).toBe('SupplierDepositTemplate');
	});

	test('routes rebate supplier changes to RebateTemplate', () => {
		const config = resolveFundChangeTemplateConfig({ outputKey: 'supplierTotalBalance', tableName: 'rebate', category: '*' });

		expect(config.component.name).toBe('RebateTemplate');
		expect(config.title).toBe('返利变动详情');
	});
});
