export const TableName = Object.freeze({
  BANK_ACCOUNT_CHANGE: "bankaccountchange",
  BORROWED_MONEY: "borrowedmoney",
  BUSINESS_TRIP: "businesstrip",
  CAR_APPLY: "carapply",
  CARS: "cars",
  COMPANY: "company",
  CUSTOMER_VISIT: "customervisit",
  EX_WAREHOUSE: "exwarehouse",
  FIXED_ASSETS: "fixedassets",
  FLEET: "fleet",
  GEN_TABLE: "gen_table",
  GEN_TABLE_COLUMN: "gen_table_column",
  GOODS_ORDER: "goodsorder",
  GOODS_ORDER_BACK: "goodsorder_back",
  INVENTORY: "inventory",
  INVENTORY_BACK: "inventory_back",
  INVOICE_IN: "invoicein",
  INVOICE_OTHER: "invoiceother",
  INVOICE_OUT: "invoiceout",
  LEND_MONEY: "lendmoney",
  OFFSETTING: "offsetting",
  OIL_CARD: "oilcard",
  OIL_CARD_CONSUME: "oilcardconsume",
  OIL_CARD_FUND_TRANSFER: "oilcardfundtransfer",
  OIL_RECHARGE: "oilrecharge",
  ORDER_DETAIL: "orderdetail",
  ORDER_DETAIL_BACK: "orderdetail_back",
  ORDER_FREIGHT: "orderfreight",
  PAYMENT: "payment",
  PRODUCT_LEVEL: "productlevel",
  REBATE: "rebate",
  RECEIVE_MONEY: "receivemoney",
  RECOVER_MONEY: "recovermoney",
  REPAYMENT: "repayment",
  SOCIAL_INSURANCE: "socialinsurance",
  BALANCEACCOUNT: "balanceaccounts",
  STOREHOUSE: "storehouse",
});

// 收款类型
export const ReceiveType = {
  LEND_MONEY_GET_BACK: '借出资金回收'
}

// 单据生成类型
export const DocumentNumber = Object.freeze({
  GOODS_ORDER: '订单列表',
  INVENTORY: '库存列表',
  INVOICE_IN: '买入票点',
  INVOICE_OUT: '卖出票点',
  INVOICE_OTHER: '第三方开票',
  // PAYMENT: '收付款'
})


export const PaymentState = [
  {
    value: '未申请',
    label: '未申请'
  },
  {
    value: '审核中',
    label: '审核中'
  },
  {
    value: '未支付',
    label: '未支付'
  },
  {
    value: '已支付',
    label: '已支付'
  },

]
