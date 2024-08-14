package org.dzu.common.enums;

public enum TableName {
    BANK_ACCOUNT("bankAccount"),
    BANK_ACCOUNT_CHANGE("bankaccountchange"),
    BORROWED_MONEY("borrowedmoney"),
    BUSINESS_TRIP("businesstrip"),
    CAR_APPLY("carapply"),
    CARS("cars"),
    COMPANY("company"),
    CUSTOMER_VISIT("customervisit"),
    EX_WAREHOUSE("exwarehouse"),
    FIXED_ASSETS("fixedassets"),
    FLEET("fleet"),
    GEN_TABLE("gen_table"),
    GEN_TABLE_COLUMN("gen_table_column"),
    GOODS_ORDER("goodsorder"),
    GOODS_ORDER_BACK("goodsorder_back"),
    INVENTORY("inventory"),
    INVENTORY_BACK("inventory_back"),
    INVOICE_IN("invoicein"),
    INVOICE_OTHER("invoiceother"),
    INVOICE_OUT("invoiceout"),
    LEND_MONEY("lendmoney"),
    OFFSETTING("offsetting"),
    OIL_CARD("oilcard"),
    OIL_CARD_CONSUME("oilcardconsume"),
    OIL_CARD_FUND_TRANSFER("oilcardfundtransfer"),
    OIL_RECHARGE("oilrecharge"),
    ORDER_DETAIL("orderdetail"),
    ORDER_DETAIL_BACK("orderdetail_back"),
    ORDER_FREIGHT("orderfreight"),
    PAYMENT("payment"),
    PRODUCT_LEVEL("productlevel"),
    REBATE("rebate"),
    RECEIVE_MONEY("receivemoney"),
    RECOVER_MONEY("recovermoney"),
    REPAYMENT("repayment"),
    SOCIAL_INSURANCE("socialinsurance"),
    BALANCEACCOUNT("balanceaccounts"),
    STOREHOUSE("storehouse");
    private final String tableName;

    TableName(String tableName) {
        this.tableName = tableName;
    }

    public String get() {
        return tableName;
    }
}