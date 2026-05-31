/**
 * 资金变动统计：tableName 与模板、outputKey 的映射配置
 * moduleName（如 companyTotalBalance）对应 calculateAmounts 的 outputKey
 */
import _ from 'lodash';
import OrderAdjustmentTemplate from '../../../../../ui-components/components/FundChangeTemplates/OrderAdjustmentTemplate/index.vue';
import InventoryChangeTemplate from '../../../../../ui-components/components/FundChangeTemplates/InventoryChangeTemplate/index.vue';
import ReceiveMoneyTemplate from '../../../../../ui-components/components/FundChangeTemplates/ReceiveMoneyTemplate/index.vue';
import PaymentTemplate from '../../../../../ui-components/components/FundChangeTemplates/PaymentTemplate/index.vue';
import SecondOutboundTemplate from '../../../../../ui-components/components/FundChangeTemplates/SecondOutboundTemplate/index.vue';
import TicketPointTemplate from '../../../../../ui-components/components/FundChangeTemplates/TicketPointTemplate/index.vue';
import OffsetPaymentTemplate from '../../../../../ui-components/components/FundChangeTemplates/OffsetPaymentTemplate/index.vue';
import BalanceAccountTemplate from '../../../../../ui-components/components/FundChangeTemplates/BalanceAccountTemplate/index.vue';
import BorrowInTemplate from '../../../../../ui-components/components/FundChangeTemplates/BorrowInTemplate/index.vue';
import BorrowFromCompanyTemplate from '../../../../../ui-components/components/FundChangeTemplates/BorrowFromCompanyTemplate/index.vue';
import ReceiveDepositTemplate from '../../../../../ui-components/components/FundChangeTemplates/ReceiveDepositTemplate/index.vue';
import FuturesDepositTemplate from '../../../../../ui-components/components/FundChangeTemplates/FuturesDepositTemplate/index.vue';
import SupplierDepositTemplate from '../../../../../ui-components/components/FundChangeTemplates/SupplierDepositTemplate/index.vue';
import RebateTemplate from '../../../../../ui-components/components/FundChangeTemplates/RebateTemplate/index.vue';

export const FUND_CHANGE_CONTEXT_WILDCARD = '*';
export const FUND_CHANGE_CONTEXT_SEPARATOR = '::';

export function createFundChangeModuleKey({ outputKey = FUND_CHANGE_CONTEXT_WILDCARD, tableName = '', category = FUND_CHANGE_CONTEXT_WILDCARD } = {}) {
	return [outputKey || FUND_CHANGE_CONTEXT_WILDCARD, tableName || '', category || FUND_CHANGE_CONTEXT_WILDCARD].join(FUND_CHANGE_CONTEXT_SEPARATOR);
}

export function parseFundChangeModuleKey(key = '') {
	const [outputKey, tableName, category] = String(key).split(FUND_CHANGE_CONTEXT_SEPARATOR);
	return {
		outputKey: outputKey === FUND_CHANGE_CONTEXT_WILDCARD ? '' : outputKey,
		tableName: tableName || '',
		category: category || FUND_CHANGE_CONTEXT_WILDCARD
	};
}

/** tableName -> { component, title, width } */
export const TABLE_TEMPLATE_MAP = {
	goodsorder: { component: OrderAdjustmentTemplate, title: '订单调整单变动详情', width: '1500px', moduleLabel: '订单调整单' },
	inventory_main: { component: InventoryChangeTemplate, title: '入库管理变动详情', width: '1500px', moduleLabel: '入库管理' },
	exwarehouse: { component: SecondOutboundTemplate, title: '二次出库变动详情', width: '1200px', moduleLabel: '二次出库' },
	allinvoice: { component: TicketPointTemplate, title: '票点变动详情', width: '1200px', moduleLabel: '发票往来' },
	invoicein: { component: TicketPointTemplate, title: '票点变动详情', width: '1200px', moduleLabel: '发票往来' },
	invoiceout: { component: TicketPointTemplate, title: '票点变动详情', width: '1200px', moduleLabel: '发票往来' },
	invoiceother: { component: TicketPointTemplate, title: '票点变动详情', width: '1200px', moduleLabel: '发票往来' },
	receivemoney: { component: ReceiveMoneyTemplate, title: '收款变动详情', width: '1500px', moduleLabel: '收款' },
	payment: { component: PaymentTemplate, title: '付款变动详情', width: '1500px', moduleLabel: '付款' },
	cash_record: { component: OffsetPaymentTemplate, title: '冲抵款变动详情', width: '1200px', moduleLabel: '冲抵款' },
	balanceaccounts: { component: BalanceAccountTemplate, title: '平账变动详情', width: '1200px', moduleLabel: '平账' },
	borrowedmoney: { component: BorrowInTemplate, title: '借入款管理变动详情', width: '1200px', moduleLabel: '借入款管理' },
	lendmoney: { component: BorrowFromCompanyTemplate, title: '从我司借款变动详情', width: '1200px', moduleLabel: '从我司借款' },
	deposit_money: { component: ReceiveDepositTemplate, title: '收取保证金变动详情', width: '1200px', moduleLabel: '收取保证金' },
	rebate: { component: RebateTemplate, title: '返利变动详情', width: '1200px', moduleLabel: '返利' }
};

export const FUTURES_DEPOSIT_TEMPLATE_CONFIG = {
	component: FuturesDepositTemplate,
	title: '期货保证金变动详情',
	width: '1200px',
	moduleLabel: '期货保证金'
};

export const SUPPLIER_DEPOSIT_TEMPLATE_CONFIG = {
	component: SupplierDepositTemplate,
	title: '厂家保证金变动详情',
	width: '1200px',
	moduleLabel: '厂家保证金'
};

export const FUND_CHANGE_BUSINESS_TEMPLATE_MAP = {
	[createFundChangeModuleKey({ outputKey: FUND_CHANGE_CONTEXT_WILDCARD, tableName: 'lendmoney', category: 'personal_loan' })]: TABLE_TEMPLATE_MAP.lendmoney,
	[createFundChangeModuleKey({ outputKey: FUND_CHANGE_CONTEXT_WILDCARD, tableName: 'lendmoney', category: 'futures_margin' })]: FUTURES_DEPOSIT_TEMPLATE_CONFIG,
	[createFundChangeModuleKey({ outputKey: FUND_CHANGE_CONTEXT_WILDCARD, tableName: 'lendmoney', category: 'factory_deposit' })]: SUPPLIER_DEPOSIT_TEMPLATE_CONFIG,
	[createFundChangeModuleKey({ outputKey: 'selfCompanyTotalFunds', tableName: 'lendmoney', category: 'personal_loan' })]: TABLE_TEMPLATE_MAP.lendmoney,
	[createFundChangeModuleKey({ outputKey: 'selfCompanyTotalFunds', tableName: 'lendmoney', category: 'futures_margin' })]: FUTURES_DEPOSIT_TEMPLATE_CONFIG,
	[createFundChangeModuleKey({ outputKey: 'selfCompanyTotalFunds', tableName: 'lendmoney', category: 'factory_deposit' })]: SUPPLIER_DEPOSIT_TEMPLATE_CONFIG,
	[createFundChangeModuleKey({ outputKey: 'loanFromCompany', tableName: 'lendmoney', category: FUND_CHANGE_CONTEXT_WILDCARD })]: TABLE_TEMPLATE_MAP.lendmoney,
	[createFundChangeModuleKey({ outputKey: 'futuresMarginBalance', tableName: 'lendmoney', category: FUND_CHANGE_CONTEXT_WILDCARD })]: FUTURES_DEPOSIT_TEMPLATE_CONFIG,
	[createFundChangeModuleKey({ outputKey: 'paymentMarginBalance', tableName: 'lendmoney', category: FUND_CHANGE_CONTEXT_WILDCARD })]: SUPPLIER_DEPOSIT_TEMPLATE_CONFIG
};

export function resolveFundChangeTemplateConfig({ outputKey = '', tableName = '', category = FUND_CHANGE_CONTEXT_WILDCARD } = {}) {
	if (!tableName) return null;
	const normalizedCategory = category || FUND_CHANGE_CONTEXT_WILDCARD;
	const candidates = [
		createFundChangeModuleKey({ outputKey, tableName, category: normalizedCategory }),
		createFundChangeModuleKey({ outputKey, tableName, category: FUND_CHANGE_CONTEXT_WILDCARD }),
		createFundChangeModuleKey({ outputKey: FUND_CHANGE_CONTEXT_WILDCARD, tableName, category: normalizedCategory }),
		createFundChangeModuleKey({ outputKey: FUND_CHANGE_CONTEXT_WILDCARD, tableName, category: FUND_CHANGE_CONTEXT_WILDCARD })
	];
	for (const key of candidates) {
		if (FUND_CHANGE_BUSINESS_TEMPLATE_MAP[key]) return FUND_CHANGE_BUSINESS_TEMPLATE_MAP[key];
	}
	return TABLE_TEMPLATE_MAP[tableName] || null;
}

/** outputKey 与资金变动模块名一致 */
export const OUTPUT_KEY_TO_MODULE = {
	companyTotalBalance: '①客户欠款合计数',
	supplierTotalBalance: '③欠厂家货款',
	selfCompanyTotalFunds: '②所有银行卡资金合计',
	remainingInventoryAmount: '⓪库存金额',
	driverUnpaidAmount: '④未支付运费合计',
	loanFromCompany: '⑤其他应收',
	futuresMarginBalance: '⑥期货保证金',
	paymentMarginBalance: '⑦厂家保证金',
	receiveMarginBalance: '⑧收取保证金',
	loanBalance: '⑨公司从外面借款合计'
};

/**
 * 总逻辑表格：outputKey 对应的明细展示配置
 * 每个 outputKey 对应公式中各组件的 (tableName, category, label, operator)
 * category 为 '*' 表示匹配该 tableName 下所有 category 并求和
 */
export const TOTAL_LOGIC_DETAIL_MAP = {
	remainingInventoryAmount: [
		{ tableName: 'inventory_main', category: '*', label: '入库管理库存变动差额', operator: '' },
		{ tableName: 'exwarehouse', category: 'secondary_process', label: '二次出库库存变动金额', operator: '-' },
		{ tableName: 'exwarehouse', category: 'normal', label: '订单库存变动差额', operator: '-' },
		{ tableName: 'exwarehouse', category: 'damage', label: '存货毁损变动差额', operator: '-' },
		{ tableName: 'goodsorder', category: '*', label: '订单库存变动差额', operator: '-' }
	],
	companyTotalBalance: [
		{ tableName: 'goodsorder', category: '*', label: '订单调整单客户变动差额', operator: '' },
		{ tableName: 'allinvoice', category: '*', label: '票点客户变动差额', operator: '+' },
		{ tableName: 'receivemoney', category: '*', label: '收款客户变动差额', operator: '-' },
		{ tableName: 'payment', category: '*', label: '付款客户变动差额', operator: '+' },
		{ tableName: 'cash_record', category: '*', label: '冲抵款客户变动差额', operator: '-' },
		{ tableName: 'balanceaccounts', category: '*', label: '平账客户变动差额', operator: '-' }
	],
	selfCompanyTotalFunds: [
		{ tableName: 'receivemoney', category: '*', label: '收款银行卡资金变动差额', operator: '' },
		{ tableName: 'payment', category: '*', label: '付款银行卡资金变动差额', operator: '-' },
		{ tableName: 'borrowedmoney', category: '*', label: '借入款银行卡资金变动', operator: '+' },
		{ tableName: 'lendmoney', category: 'personal_loan', label: '从我司借款银行卡资金变动', operator: '-' },
		{ tableName: 'lendmoney', category: 'futures_margin', label: '期货保证金银行卡资金变动', operator: '-' },
		{ tableName: 'lendmoney', category: 'factory_deposit', label: '厂家保证金银行卡资金变动', operator: '-' },
		{ tableName: 'deposit_money', category: '*', label: '收取保证金银行卡资金变动', operator: '+' }
	],
	supplierTotalBalance: [
		{ tableName: 'inventory_main', category: '*', label: '入库管理供应商变动差额', operator: '' },
		{ tableName: 'goodsorder', category: '*', label: '订单调整单供应商变动差额', operator: '+' },
		{ tableName: 'allinvoice', category: '*', label: '票点供应商变动差额', operator: '+' },
		{ tableName: 'receivemoney', category: '*', label: '收款供应商变动差额', operator: '+' },
		{ tableName: 'payment', category: '*', label: '付款供应商变动差额', operator: '-' },
		{ tableName: 'cash_record', category: '*', label: '冲抵款供应商变动差额', operator: '-' },
		{ tableName: 'balanceaccounts', category: '*', label: '平账供应商变动差额', operator: '-' },
		{ tableName: 'rebate', category: '*', label: '返利供应商变动差额', operator: '-' }
	],
	driverUnpaidAmount: [
		{ tableName: 'inventory_main', category: '*', label: '入库运费变动差额', operator: '' },
		{ tableName: 'goodsorder', category: '*', label: '订单运费变动差额', operator: '+' },
		{ tableName: 'payment', category: '*', label: '付款运费变动差额', operator: '-' },
		{ tableName: 'cash_record', category: '*', label: '冲抵款运费变动差额', operator: '-' }
	],
	loanFromCompany: [{ tableName: 'lendmoney', category: '*', label: '从我司借款银行卡资金变动', operator: '' }],
	futuresMarginBalance: [{ tableName: 'lendmoney', category: '*', label: '期货保证金变动', operator: '' }],
	paymentMarginBalance: [{ tableName: 'lendmoney', category: '*', label: '厂家保证金变动', operator: '' }],
	receiveMarginBalance: [{ tableName: 'deposit_money', category: '*', label: '收取保证金变动', operator: '' }],
	loanBalance: [{ tableName: 'borrowedmoney', category: '*', label: '公司从外面借款变动', operator: '' }]
};

/**
 * 从 calculateAmounts 三层结构中提取指定 outputKey 的 (tableName, category) 组合
 * @param {Object} data - calculateAmounts 返回的 data
 * @param {string} outputKey - 一级分类
 * @returns {Array<{outputKey: string, tableName: string, category: string}>}
 */
export function extractCategoryTriplesByOutputKey(data, outputKey) {
	if (!data || typeof data !== 'object' || !outputKey) return [];
	const tableMap = data[outputKey];
	if (!tableMap || typeof tableMap !== 'object') return [];
	const triples = [];
	_.forEach(tableMap, (categoryMap, tableName) => {
		if (!categoryMap || typeof categoryMap !== 'object') return;
		_.forEach(categoryMap, (_, category) => {
			triples.push({ outputKey, tableName, category });
		});
	});
	return triples;
}
