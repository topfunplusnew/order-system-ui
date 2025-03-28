// 系统常用枚举类

export const TableName = Object.freeze({
	BANK_ACCEPTANCE: 'bankacceptance',
	BANK_ACCOUNT_CHANGE: 'bankaccountchange',
	BORROWED_MONEY: 'borrowedmoney',
	BUSINESS_TRIP: 'businesstrip',
	CAR_APPLY: 'carapply',
	CARS: 'cars',
	COMPANY: 'company',
	CUSTOMER_VISIT: 'customervisit',
	EX_WAREHOUSE: 'exwarehouse',
	FIXED_ASSETS: 'fixedassets',
	FLEET: 'fleet',
	GEN_TABLE: 'gen_table',
	GEN_TABLE_COLUMN: 'gen_table_column',
	GOODS_ORDER: 'goodsorder',
	GOODS_ORDER_BACK: 'goodsorder_back',
	INVENTORY: 'inventory',
	INVENTORY_BACK: 'inventory_back',
	INVOICE_IN: 'invoicein',
	INVOICE_OTHER: 'invoiceother',
	INVOICE_OUT: 'invoiceout',
	LEND_MONEY: 'lendmoney',
	OFFSETTING: 'offsetting',
	OIL_CARD: 'oilcard',
	OIL_CARD_CONSUME: 'oilcardconsume',
	OIL_CARD_FUND_TRANSFER: 'oilcardfundtransfer',
	OIL_RECHARGE: 'oilrecharge',
	ORDER_DETAIL: 'orderdetail',
	ORDER_DETAIL_BACK: 'orderdetail_back',
	ORDER_FREIGHT: 'orderfreight',
	PAYMENT: 'payment',
	PRODUCT_LEVEL: 'productlevel',
	REBATE: 'rebate',
	RECEIVE_MONEY: 'receivemoney',
	RECOVER_MONEY: 'recovermoney',
	REPAYMENT: 'repayment',
	SOCIAL_INSURANCE: 'socialinsurance',
	BALANCEACCOUNT: 'balanceaccounts',
	STOREHOUSE: 'storehouse',
	INVENTORMAIN: 'inventory_main',
	INVENTORDETAIL: 'inventory_detail',
	DAILY: 'daily',
	CASH_RECORD: 'cash_record',
	ORDERCOMMISION: 'ordercommission'
});

export const moduleNames = Object.freeze({
	goodsorder: '订单',
	inventory: '库存',
	payment: '付款',
	receivemoney: '收款',
	borrowedmoney: '借出款',
	lendmoney: '借入款',
	recovermoney: '借出资金回收',
	repayment: '贷款还款',
	bankaccountchange: '银行账户变动',
	bankaccount: '银行卡',
	businesstrip: '出差',
	carapply: '车辆申请',
	cars: '车辆',
	company: '公司/客户',
	supplier: '公司/供应商',
	customervisit: '客户拜访',
	exwarehouse: '出库',
	fixedassets: '固定资产',
	fleet: '车队',
	invoicein: '发票购入',
	invoiceout: '发票售出',
	invoiceother: '第三方发票',
	offsetting: '冲抵货款',
	oilcard: '油卡',
	oilcardconsume: '油卡消费',
	oilcardfundtransfer: '油卡资金转移',
	oilrecharge: '油卡充值',
	orderdetail: '订单详情',
	orderfreight: '订单运费',
	productlevel: '产品级别',
	rebate: '返利',
	socialinsurance: '社保',
	balanceaccounts: '平账',
	storehouse: '仓库',
	inventory_main: '库存',
	inventory_detail: '库存明细',
	bankacceptance: '商业票据',
	ordercommission: '订单佣金'
});

// 报表所用类型
export const ReportType = Object.freeze({
	// 客户
	CUSTOMER: {
		invoicein: '发票购入',
		invoiceout: '发票售出',
		// 第三方开票 客户为发票买入
		invoiceother: '发票购入',
		goodsorder: '客户提货',
		offsetting: '冲抵货款',
		balanceaccounts: '平账',
		bankacceptance: '商业票据'
	},
	// 供应商
	SUPPLIER: {
		invoicein: '发票购入',
		invoiceout: '发票售出',
		goodsorder: '从厂家进货',
		orderdetail: '从厂家进货',
		// 第三方开票 客户为发票卖出
		invoiceother: '发票售出',
		offsetting: '冲抵货款',
		inventory_detail: '商品入库',
		rebate: '供应商返利',
		balanceaccounts: '平账'
	},
	// 运费
	FREIGHT: {
		goodsorder: '付运费',
		offsetting: '冲抵货款',
		inventory_main: '付运费',
		orderfreight: '司机运费'
	}
});

// 收款类型
export const ReceiveType = {
	LEND_MONEY_GET_BACK: '借出资金回收'
};

// 单据生成类型
export const DocumentNumber = Object.freeze({
	GOODS_ORDER: '订单列表',
	INVENTORY: '库存列表',
	INVOICE_IN: '买入票点',
	INVOICE_OUT: '卖出票点',
	INVOICE_OTHER: '第三方开票'
	// PAYMENT: '收付款'
});

// 支付状态
export const PaymentState = [
	{
		value: '未支付',
		label: '未支付'
	},
	{
		value: '已支付',
		label: '已支付'
	}
];

// 审核状态
export const CheckState = [
	{
		value: '未申请',
		label: '未申请'
	},
	{
		value: '审核中',
		label: '审核中'
	}
];

// 运费来源
export const FreightSource = Object.freeze({
	GOODS_ORDER: 'goodsorder',
	INVENTORY_MAIN: 'inventory_main'
});

// 主副卡操作的分别
export const OilCardType = Object.freeze({
	MAIN: '主卡',
	SUB: '副卡'
});
export const OilCardOptionType = Object.freeze({
	MAIN_TO_SUB: 0,
	SUB_TO_SUB: 1
});

export const PaymentOptions = Object.freeze([
	{
		value: '客户',
		label: '客户'
	},
	{
		value: '供应商',
		label: '供应商'
	},
	{
		value: '司机',
		label: '司机'
	},
	{
		value: '对外付款',
		label: '对外付款'
	}
]);

export const BankAcceptanceType = Object.freeze({
	BANK_CASH: '银行活期存款',
	ACCEPTANCE: '承兑',

	PAY_TYPE: {
		PAYMENT: '支出',
		RECEIVE: '收入'
	}
});

// 佣金相关的枚举
export const CommissionType = Object.freeze({
	CUSTOMER: 0,
	SUPPLIER: 1,
	INVENTORY: 2
});

export const MoneyChangeModuleName = Object.freeze({
	companyTotalBalance: 'companyTotalBalance',
	supplierTotalBalance: 'supplierTotalBalance',
	driverUnpaidAmount: 'driverUnpaidAmount',
	selfCompanyTotalFunds: 'selfCompanyTotalFunds',
	loanBalance: 'loanBalance',
	futuresMarginBalance: 'futuresMarginBalance',
	loanFromCompany: 'loanFromCompany',
	remainingInventoryAmount: 'remainingInventoryAmount'
});

export const RebateType = {
	Weight: '重箱',
	Square: '面积'
};

export const System_Option_Type = {
	INSERT: '新增',
	UPDATE: '修改',
	DELETE: '删除'
};
