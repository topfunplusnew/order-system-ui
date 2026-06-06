export const FUND_CHANGE_TEMPLATE_DATE_FIELDS = Object.freeze({
	OrderAdjustmentTemplate: ['orderDate'],
	InventoryChangeTemplate: ['storeDate'],
	SecondOutboundTemplate: ['outDate'],
	TicketPointTemplate: ['invoiceDate'],
	ReceiveMoneyTemplate: ['fundsDate'],
	PaymentTemplate: ['fundsDate'],
	OffsetPaymentTemplate: ['transactionTime'],
	BalanceAccountTemplate: ['addtime'],
	BorrowInTemplate: ['loanDate'],
	BorrowFromCompanyTemplate: ['addtime'],
	ReceiveDepositTemplate: ['depositDate'],
	FuturesDepositTemplate: ['futuresDate'],
	SupplierDepositTemplate: ['futuresDate'],
	RebateTemplate: ['rebateDate']
});

export function getFundChangeTemplateDateFields(templateName = '') {
	return FUND_CHANGE_TEMPLATE_DATE_FIELDS[templateName] || [];
}
