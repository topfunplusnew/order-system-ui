/**
 * 资金变动模板列配置 - 与 Excel「系统修改变动统计表260210」各 sheet 结构 1:1 对应
 * 每项 { prop, label, width?, showSummary?, aggregator?, summaryLabel? }
 */

/** 入库管理：状态, 入库时间, 仓库, 陆运车牌, 海运柜号, 海运公司, 供应商, 级别名称, ... */
export const INVENTORY_MAIN_COLUMNS = [
	{ prop: 'status', label: '状态', width: 90 },
	{ prop: 'inboundTime', label: '入库时间', width: 120 },
	{ prop: 'warehouse', label: '仓库', width: 120 },
	{ prop: 'truckPlate', label: '陆运车牌', width: 100 },
	{ prop: 'seaCabinetNo', label: '海运柜号', width: 100 },
	{ prop: 'seaCompany', label: '海运公司', width: 120 },
	{ prop: 'supplierName', label: '供应商', width: 120 },
	{ prop: 'gradeName', label: '级别名称', width: 150 },
	{ prop: 'countingUnit', label: '计量单位', width: 90 },
	{ prop: 'thickness', label: '厚度', width: 80 },
	{ prop: 'length', label: '长度', width: 80 },
	{ prop: 'width', label: '宽度', width: 80 },
	{ prop: 'piecesPerPack', label: '每包片数', width: 90 },
	{ prop: 'packs', label: '包数', width: 80 },
	{ prop: 'factoryPieces', label: '出厂片数', width: 90 },
	{ prop: 'factoryUnitPrice', label: '出厂单价', width: 100 },
	{ prop: 'factoryTaxFlag', label: '出厂是否含税', width: 110 },
	{ prop: 'sundryCost', label: '杂费', width: 90 },
	{ prop: 'factoryPayment', label: '出厂货款', width: 100, showSummary: false },
	{ prop: 'stockQuantity', label: '库存量(片数)', width: 110 },
	{ prop: 'unloadPrice', label: '卸货价', width: 90 },
	{ prop: 'stockTaxFlag', label: '库存是否含税', width: 110 },
	{ prop: 'stockAmount', label: '库存金额', width: 100 },
	{ prop: 'erro', label: '误差', width: 80 },
	{ prop: 'tonnage', label: '吨位', width: 80 },
	{ prop: 'landFreightPrice', label: '陆运费单价', width: 110 },
	{ prop: 'additionalFees', label: '加费', width: 80 },
	{ prop: 'landFreight', label: '陆运费', width: 90 },
	{ prop: 'seaFreight', label: '海运费', width: 90 },
	{ prop: 'totalFreight', label: '总运费', width: 90 },
	{ prop: 'otherCost', label: '其他费用', width: 100 },
	{ prop: 'profit', label: '利润', width: 90 },
	{ prop: 'profitNoTax', label: '不含税利润', width: 110 },
	{ prop: 'inputUser', label: '录入员', width: 90 },
	{ prop: 'fleet', label: '车队', width: 90 },
	{ prop: 'remark', label: '备注', width: 120 },
	{ prop: 'otherInfo', label: '其他信息', width: 120 },
	{ prop: 'logisticsProfit', label: '物流利润', width: 100 },
	{ prop: 'customerCommission', label: '客户佣金', width: 100 },
	{ prop: 'factoryCommission', label: '厂家佣金', width: 100 },
	{ prop: 'factoryRebateAmount', label: '厂家返利金额', width: 120 },
	{ prop: 'factoryDiscountAmount', label: '厂家降价金额', width: 120 },
	{ prop: 'inventoryDiff', label: '库存变动差额', aggregator: 'absSum', summaryLabel: '库存变动差额汇总' },
	{ prop: 'supplierDiff', label: '供应商变动差额', aggregator: 'absSum', summaryLabel: '供应商变动差额汇总' },
	{ prop: 'freightDiff', label: '运费变动差额', aggregator: 'absSum', summaryLabel: '运费变动差额汇总' }
];

/** 二次出库：二次入库状态, 仓库名称, 出库方向, 变动日期(出库), 产品级别, 厚度, 长度, 宽度, 出库量, 存货价, 原库存金额 */
export const EXWAREHOUSE_COLUMNS = [
	{ prop: 'secondaryStatus', label: '二次入库状态', width: 120 },
	{ prop: 'warehouse', label: '仓库名称', width: 120 },
	{ prop: 'outboundDirection', label: '出库方向', width: 120 },
	{ prop: 'outboundDate', label: '变动日期(出库)', width: 120 },
	{ prop: 'gradeName', label: '产品级别', width: 150 },
	{ prop: 'thickness', label: '厚度', width: 80 },
	{ prop: 'length', label: '长度', width: 80 },
	{ prop: 'width', label: '宽度', width: 80 },
	{ prop: 'outboundQuantity', label: '出库量', width: 100 },
	{ prop: 'stockPrice', label: '存货价', width: 100 },
	{ prop: 'originalInventoryAmount', label: '原库存金额', width: 120 },
	{ prop: 'inventoryDiff', label: '库存变动差额', aggregator: 'absSum', summaryLabel: '库存变动差额汇总' }
];

/** 收款：状态, 日期, 支付类型, 对方公司, 对方公司类型, 金额, 己方户名, 己方账号, 己方开户行, 对方户名, 对方账号, 对方开户行, 备注 */
export const RECEIVEMONEY_COLUMNS = [
	{ prop: 'status', label: '状态', width: 90 },
	{ prop: 'receiveDate', label: '日期', width: 150 },
	{ prop: 'paymentType', label: '支付类型', width: 180 },
	{ prop: 'companyName', label: '对方公司', width: 150 },
	{ prop: 'companyType', label: '对方公司类型', width: 110 },
	{ prop: 'amount', label: '金额', width: 110, showSummary: false },
	{ prop: 'selfAccountName', label: '己方户名', width: 150 },
	{ prop: 'selfAccountNo', label: '己方账号', width: 180 },
	{ prop: 'selfBankName', label: '己方开户行', width: 180 },
	{ prop: 'otherAccountName', label: '对方户名', width: 150 },
	{ prop: 'otherAccountNo', label: '对方账号', width: 180 },
	{ prop: 'otherBankName', label: '对方开户行', width: 180 },
	{ prop: 'remark', label: '备注', width: 150 },
	{ prop: 'amountDiff', label: '金额变动差额', aggregator: 'absSum', summaryLabel: '金额变动差额汇总' }
];

/** 付款：状态, 日期, 支付类型, 对方公司, 对方公司类型, 金额, 己方户名, 己方账号, 己方开户行, 对方户名, 对方账号, 对方开户行, 备注 */
export const PAYMENT_COLUMNS = [
	{ prop: 'status', label: '状态', width: 90 },
	{ prop: 'paymentDate', label: '日期', width: 150 },
	{ prop: 'paymentType', label: '支付类型', width: 180 },
	{ prop: 'companyName', label: '对方公司', width: 150 },
	{ prop: 'companyType', label: '对方公司类型', width: 110 },
	{ prop: 'amount', label: '金额', width: 110, showSummary: false },
	{ prop: 'selfAccountName', label: '己方户名', width: 150 },
	{ prop: 'selfAccountNo', label: '己方账号', width: 180 },
	{ prop: 'selfBankName', label: '己方开户行', width: 180 },
	{ prop: 'otherAccountName', label: '对方户名', width: 150 },
	{ prop: 'otherAccountNo', label: '对方账号', width: 180 },
	{ prop: 'otherBankName', label: '对方开户行', width: 180 },
	{ prop: 'remark', label: '备注', width: 150 },
	{ prop: 'amountDiff', label: '金额变动差额', aggregator: 'absSum', summaryLabel: '金额变动差额汇总' }
];

/** 冲抵款：状态, 交易时间, 金额, 支出方, 收入方, 支付户名, 支付账号, 支出方开户行, 收款户名, 收款账号, 收入方开户行, 支出方支付类型, 支出方公司类型, 收入方支付类型, 收入方公司类型, 冲抵类型, 备注, 账户类型, 操作人员姓名 */
export const CASH_RECORD_COLUMNS = [
	{ prop: 'status', label: '状态', width: 90 },
	{ prop: 'tradeTime', label: '交易时间', width: 150 },
	{ prop: 'amount', label: '金额', width: 110, showSummary: false },
	{ prop: 'payerName', label: '支出方', width: 200 },
	{ prop: 'receiverName', label: '收入方', width: 200 },
	{ prop: 'payAccountName', label: '支付户名', width: 180 },
	{ prop: 'payAccountNo', label: '支付账号', width: 180 },
	{ prop: 'payerBank', label: '支出方开户行', width: 200 },
	{ prop: 'receiveAccountName', label: '收款户名', width: 180 },
	{ prop: 'receiveAccountNo', label: '收款账号', width: 180 },
	{ prop: 'receiverBank', label: '收入方开户行', width: 200 },
	{ prop: 'payerPayType', label: '支出方支付类型', width: 180 },
	{ prop: 'payerCompanyType', label: '支出方公司类型', width: 120 },
	{ prop: 'receiverPayType', label: '收入方支付类型', width: 180 },
	{ prop: 'receiverCompanyType', label: '收入方公司类型', width: 120 },
	{ prop: 'offsetType', label: '冲抵类型', width: 120 },
	{ prop: 'remark', label: '备注', width: 150 },
	{ prop: 'accountType', label: '账户类型', width: 120 },
	{ prop: 'operatorName', label: '操作人员姓名', width: 120 },
	{ prop: 'amountDiff', label: '金额变动差额', aggregator: 'absSum', summaryLabel: '金额变动差额汇总' }
];

/** 平账：状态, 操作时间, 金额, 对方公司, 对方公司类型, 备注 */
export const BALANCEACCOUNTS_COLUMNS = [
	{ prop: 'status', label: '状态', width: 90 },
	{ prop: 'operateTime', label: '操作时间', width: 150 },
	{ prop: 'amount', label: '金额', width: 110, showSummary: false },
	{ prop: 'companyName', label: '对方公司', width: 150 },
	{ prop: 'companyType', label: '对方公司类型', width: 110 },
	{ prop: 'remark', label: '备注', width: 200 },
	{ prop: 'amountDiff', label: '金额变动差额', aggregator: 'absSum', summaryLabel: '金额变动差额汇总' }
];

/** 借入款管理：id, 贷款来源, 借入金额, 贷款利率, 贷款发放日期, 贷款年限, 抵押担保, 打入账户, 打入账号, 已还款金额, 未还款金额, 已还款利息, 备注 */
export const BORROWEDMONEY_COLUMNS = [
	{ prop: 'id', label: 'id', width: 80 },
	{ prop: 'lenderSource', label: '贷款来源', width: 120 },
	{ prop: 'borrowAmount', label: '借入金额', width: 120, showSummary: false },
	{ prop: 'interestRate', label: '贷款利率', width: 100 },
	{ prop: 'grantDate', label: '贷款发放日期', width: 120 },
	{ prop: 'loanYears', label: '贷款年限', width: 90 },
	{ prop: 'mortgage', label: '抵押担保', width: 120 },
	{ prop: 'intoAccount', label: '打入账户', width: 150 },
	{ prop: 'intoAccountNo', label: '打入账号', width: 180 },
	{ prop: 'repaidAmount', label: '已还款金额', width: 120 },
	{ prop: 'unrepaidAmount', label: '未还款金额', width: 120 },
	{ prop: 'repaidInterest', label: '已还款利息', width: 120 },
	{ prop: 'remark', label: '备注', width: 150 },
	{ prop: 'bankCardDiff', label: '银行卡资金变动', aggregator: 'absSum', summaryLabel: '银行卡资金变动汇总' }
];

/** 员工或公司从我司借款：借款人, 对象类型, 借出金额, 收回金额, 累计坏账, 未收回金额, 对方收借款账号, 对方户名, 对方开户行, 我方支付借款账户名称, 我方支付借款开户行, 我方付款账号, 支付时间, 借款事由 */
export const LENDMONEY_COLUMNS = [
	{ prop: 'borrowerName', label: '借款人', width: 150 },
	{ prop: 'objectType', label: '对象类型', width: 100 },
	{ prop: 'lendAmount', label: '借出金额', width: 120, showSummary: false },
	{ prop: 'recoverAmount', label: '收回金额', width: 120 },
	{ prop: 'badDebtTotal', label: '累计坏账', width: 120 },
	{ prop: 'unrecoverAmount', label: '未收回金额', width: 120 },
	{ prop: 'otherAccountNo', label: '对方收借款账号', width: 180 },
	{ prop: 'otherAccountName', label: '对方户名', width: 150 },
	{ prop: 'otherBankName', label: '对方开户行', width: 180 },
	{ prop: 'selfPayAccountName', label: '我方支付借款账户名称', width: 180 },
	{ prop: 'selfPayBankName', label: '我方支付借款开户行', width: 200 },
	{ prop: 'selfPayAccountNo', label: '我方付款账号', width: 180 },
	{ prop: 'payTime', label: '支付员工/外面公司在我公司借款时间', width: 120 },
	{ prop: 'loanReason', label: '借款事由', width: 120 },
	{ prop: 'bankCardDiff', label: '银行卡资金变动', aggregator: 'absSum', summaryLabel: '银行卡资金变动汇总' }
];

/** 期货保证金：期货保证金公司, 公司名称, 对方类型, 保证金金额, 收回金额, 累计坏账, 未收回金额, 对方账户, 对方账号, 对方开户行, 我方支付账户, 我方账号, 我方开户行, 支付期货保证金时间, 事由, 备注, 操作 */
export const FUTURES_MARGIN_COLUMNS = [
	{ prop: 'futuresCompany', label: '期货保证金公司', width: 180 },
	{ prop: 'companyName', label: '公司名称', width: 180 },
	{ prop: 'objectType', label: '对方类型', width: 100 },
	{ prop: 'marginAmount', label: '保证金金额', width: 120, showSummary: false },
	{ prop: 'recoverAmount', label: '收回金额', width: 120 },
	{ prop: 'badDebtTotal', label: '累计坏账', width: 120 },
	{ prop: 'unrecoverAmount', label: '未收回金额', width: 120 },
	{ prop: 'otherAccountName', label: '对方账户', width: 180 },
	{ prop: 'otherAccountNo', label: '对方账号', width: 180 },
	{ prop: 'otherBankName', label: '对方开户行', width: 180 },
	{ prop: 'selfPayAccountName', label: '我方支付账户', width: 150 },
	{ prop: 'selfAccountNo', label: '我方账号', width: 180 },
	{ prop: 'selfBankName', label: '我方开户行', width: 200 },
	{ prop: 'payTime', label: '支付期货保证金时间', width: 120 },
	{ prop: 'reason', label: '事由', width: 100 },
	{ prop: 'remark', label: '备注', width: 150 },
	{ prop: 'operation', label: '操作', width: 80 },
	{ prop: 'marginDiff', label: '保证金变动差额', aggregator: 'absSum', summaryLabel: '保证金变动差额汇总' }
];

/** 厂家保证金：类型, 公司名称, 对方类型, 公司名称, 金额, 收回金额, 累计坏账, 未收回金额, 对方账户, 对方账号, 对方开户行, 我方支付账户, 我方账号, 我方开户行, 支付时间, 事由, 备注 */
export const FACTORY_MARGIN_COLUMNS = [
	{ prop: 'marginType', label: '类型', width: 120 },
	{ prop: 'companyName', label: '公司名称', width: 150 },
	{ prop: 'objectType', label: '对方类型', width: 100 },
	{ prop: 'targetCompanyName', label: '公司名称', width: 150 },
	{ prop: 'amount', label: '金额', width: 120, showSummary: false },
	{ prop: 'recoverAmount', label: '收回金额', width: 120 },
	{ prop: 'badDebtTotal', label: '累计坏账', width: 120 },
	{ prop: 'unrecoverAmount', label: '未收回金额', width: 120 },
	{ prop: 'otherAccountName', label: '对方账户', width: 180 },
	{ prop: 'otherAccountNo', label: '对方账号', width: 180 },
	{ prop: 'otherBankName', label: '对方开户行', width: 180 },
	{ prop: 'selfPayAccountName', label: '我方支付账户', width: 150 },
	{ prop: 'selfAccountNo', label: '我方账号', width: 180 },
	{ prop: 'selfBankName', label: '我方开户行', width: 200 },
	{ prop: 'payTime', label: '支付时间', width: 120 },
	{ prop: 'reason', label: '事由', width: 100 },
	{ prop: 'remark', label: '备注', width: 150 },
	{ prop: 'amountDiff', label: '金额变动差额', aggregator: 'absSum', summaryLabel: '金额变动差额汇总' }
];

/** 票点：状态, 开票日期, 我方主体, 发票金额, 公司类型, 公司名称, 开票单位名称, 票点, 票点收入, 是否为订单税, 公司类型, 公司名称, 开票单位名称, 票点, 票点成本, 票点差额, 实际开票金额, 实际开票日期, 当月欠票, 备注 */
export const TICKET_POINT_COLUMNS = [
	{ prop: 'status', label: '状态', width: 90 },
	{ prop: 'invoiceDate', label: '开票日期', width: 120 },
	{ prop: 'selfSubject', label: '我方主体', width: 120 },
	{ prop: 'invoiceAmount', label: '发票金额', width: 120, showSummary: false },
	{ prop: 'incomeCompanyType', label: '公司类型', width: 100 },
	{ prop: 'incomeCompanyName', label: '公司名称', width: 150 },
	{ prop: 'incomeInvoiceUnit', label: '开票单位名称', width: 150 },
	{ prop: 'incomePoint', label: '票点', width: 80 },
	{ prop: 'incomePointAmount', label: '票点收入', width: 100 },
	{ prop: 'isOrderTax', label: '是否为订单税', width: 110 },
	{ prop: 'costCompanyType', label: '公司类型', width: 100 },
	{ prop: 'costCompanyName', label: '公司名称', width: 150 },
	{ prop: 'costInvoiceUnit', label: '开票单位名称', width: 150 },
	{ prop: 'costPoint', label: '票点', width: 80 },
	{ prop: 'costPointAmount', label: '票点成本', width: 100 },
	{ prop: 'pointDiff', label: '票点差额', width: 100 },
	{ prop: 'actualInvoiceAmount', label: '实际开票金额', width: 120 },
	{ prop: 'actualInvoiceDate', label: '实际开票日期', width: 120 },
	{ prop: 'monthlyDebt', label: '当月欠票', width: 100 },
	{ prop: 'remark', label: '备注', width: 150 },
	{ prop: 'customerDiff', label: '客户变动差额', aggregator: 'absSum', summaryLabel: '客户变动差额汇总' },
	{ prop: 'supplierDiff', label: '供应商变动差额', aggregator: 'absSum', summaryLabel: '供应商变动差额汇总' }
];

/** 订单调整单：状态, 订单日期, 客户, 车牌, 海运柜号, 海运公司, 供应商, 仓库名称, 级别名称, ...(同入库明细), 总货款, 陆运费, 海运费, 总运费, ... */
export const ORDER_ADJUSTMENT_COLUMNS = [
	{ prop: 'status', label: '状态', width: 100 },
	{ prop: 'orderDate', label: '订单日期', width: 120 },
	{ prop: 'customerName', label: '客户', width: 150 },
	{ prop: 'truckPlate', label: '车牌', width: 100 },
	{ prop: 'seaCabinetNo', label: '海运柜号', width: 100 },
	{ prop: 'seaCompany', label: '海运公司', width: 120 },
	{ prop: 'supplierName', label: '供应商', width: 150 },
	{ prop: 'warehouse', label: '仓库名称', width: 120 },
	{ prop: 'gradeName', label: '级别名称', width: 150 },
	{ prop: 'allPayments', label: '总货款', width: 110, showSummary: false },
	{ prop: 'landFreight', label: '陆运费', width: 100 },
	{ prop: 'seaFreight', label: '海运费', width: 100 },
	{ prop: 'totalFreight', label: '总运费', width: 100 },
	{ prop: 'customerDiff', label: '客户变动差额', aggregator: 'absSum', summaryLabel: '客户变动差额汇总' },
	{ prop: 'supplierDiff', label: '供应商变动差额', aggregator: 'absSum', summaryLabel: '供应商变动差额汇总' },
	{ prop: 'inventoryDiff', label: '库存变动差额', aggregator: 'absSum', summaryLabel: '库存变动差额汇总' },
	{ prop: 'freightDiff', label: '运费变动差额', aggregator: 'absSum', summaryLabel: '运费变动差额汇总' }
];

/** 收取保证金：保证金公司, 对象类型, 对象名称, 保证金金额, 未退款金额, 对方账户, 对方账号, 对方开户行, 我方收款账户, 我方账号, 我方开户行, 收取时间, 事由, 备注, 操作人员 */
export const DEPOSIT_MONEY_COLUMNS = [
	{ prop: 'depositCompany', label: '保证金公司', width: 120 },
	{ prop: 'objectType', label: '对象类型', width: 100 },
	{ prop: 'objectName', label: '对象名称', width: 150 },
	{ prop: 'depositAmount', label: '保证金金额', width: 120, showSummary: false },
	{ prop: 'unrefundAmount', label: '未退款金额', width: 120 },
	{ prop: 'otherAccountName', label: '对方账户', width: 150 },
	{ prop: 'otherAccountNo', label: '对方账号', width: 180 },
	{ prop: 'otherBankName', label: '对方开户行', width: 180 },
	{ prop: 'selfReceiveAccountName', label: '我方收款账户', width: 150 },
	{ prop: 'selfAccountNo', label: '我方账号', width: 180 },
	{ prop: 'selfBankName', label: '我方开户行', width: 200 },
	{ prop: 'receiveTime', label: '收取时间', width: 120 },
	{ prop: 'reason', label: '事由', width: 100 },
	{ prop: 'remark', label: '备注', width: 150 },
	{ prop: 'operatorName', label: '操作人员', width: 100 },
	{ prop: 'depositDiff', label: '保证金变动差额', aggregator: 'absSum', summaryLabel: '保证金变动差额汇总' }
];
