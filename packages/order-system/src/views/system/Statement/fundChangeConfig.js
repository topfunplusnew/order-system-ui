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

/** tableName -> { component, title, width } */
export const TABLE_TEMPLATE_MAP = {
	goodsorder: { component: OrderAdjustmentTemplate, title: '订单调整单变动详情', width: '1500px' },
	inventory_main: { component: InventoryChangeTemplate, title: '入库管理变动详情', width: '1500px' },
	exwarehouse: { component: SecondOutboundTemplate, title: '二次出库变动详情', width: '1200px' },
	invoicein: { component: TicketPointTemplate, title: '票点变动详情', width: '1200px' },
	invoiceout: { component: TicketPointTemplate, title: '票点变动详情', width: '1200px' },
	invoiceother: { component: TicketPointTemplate, title: '票点变动详情', width: '1200px' },
	receivemoney: { component: ReceiveMoneyTemplate, title: '收款变动详情', width: '1500px' },
	payment: { component: PaymentTemplate, title: '付款变动详情', width: '1500px' },
	cash_record: { component: OffsetPaymentTemplate, title: '冲抵款变动详情', width: '1200px' },
	balanceaccounts: { component: BalanceAccountTemplate, title: '平账变动详情', width: '1200px' },
	borrowedmoney: { component: BorrowInTemplate, title: '借入款管理变动详情', width: '1200px' },
	lendmoney: { component: BorrowFromCompanyTemplate, title: '从我司借款变动详情', width: '1200px' },
	deposit_money: { component: ReceiveDepositTemplate, title: '收取保证金变动详情', width: '1200px' }
};

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
