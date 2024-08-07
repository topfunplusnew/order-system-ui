package org.dzu.common.constant;

public class lendMoneyConstants {
//    "对象类型(员工、客户、供应商、其他)"
    public static enum targetType {
        EMPLOYEE("员工"),
        CUSTOMER("客户"),
        SUPPLIER("供应商"),
        OTHER("其他");
        private String value;
        targetType(String value) {
            this.value = value;
        }
        public String get() {
            return value;
        }
    }
}
