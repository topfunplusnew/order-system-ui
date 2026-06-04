export const FUND_CHANGE_TEMPLATE_DATE_FIELDS = Object.freeze({
	OrderAdjustmentTemplate: ['orderDate'],
	InventoryChangeTemplate: ['storeDate'],
	SecondOutboundTemplate: ['outDate'],
	TicketPointTemplate: ['invoiceDate'],
	ReceiveMoneyTemplate: ['fundsDate'],
	PaymentTemplate: ['fundsDate'],
	OffsetPaymentTemplate: ['addtime'],
	BalanceAccountTemplate: ['addtime'],
	BorrowInTemplate: ['grantDate'],
	BorrowFromCompanyTemplate: ['addtime'],
	ReceiveDepositTemplate: ['addtime'],
	FuturesDepositTemplate: ['addtime'],
	SupplierDepositTemplate: ['addtime'],
	RebateTemplate: ['rebateDate']
});

export function getFundChangeTemplateDateFields(templateName = '') {
	return FUND_CHANGE_TEMPLATE_DATE_FIELDS[templateName] || [];
}
