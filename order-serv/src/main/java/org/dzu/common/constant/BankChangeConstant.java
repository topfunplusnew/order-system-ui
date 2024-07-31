package org.dzu.common.constant;

public class BankChangeConstant {
    // 支付类型的枚举
    public enum PaymentType {
        RECEIPT("收入"),
        PAYMENT("支出");

        private final String description;

        PaymentType(String description) {
            this.description = description;
        }

        public String get() {
            return description;
        }

    }
    public enum TableName {
        BORROWED_MONEY("borrowedmoney");
        private final String tableName;

        TableName(String tableName) {
            this.tableName = tableName;
        }

        public String get() {
            return tableName;
        }
    }

}
