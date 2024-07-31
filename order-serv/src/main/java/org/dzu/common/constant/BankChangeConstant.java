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

        public String getDescription() {
            return description;
        }

        // 根据描述获取对应的枚举类型
        public static PaymentType fromDescription(String description) {
            for (PaymentType type : PaymentType.values()) {
                if (type.description.equals(description)) {
                    return type;
                }
            }
            throw new IllegalArgumentException("Unknown description: " + description);
        }
    }
}
