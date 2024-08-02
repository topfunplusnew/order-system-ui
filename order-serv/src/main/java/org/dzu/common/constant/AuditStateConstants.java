package org.dzu.common.constant;

public class AuditStateConstants {
    // 审核状态（审核中、通过、未通过）
    public static final String CHECK_STATE_ING = "审核中";
    public static final String CHECK_STATE_PASS = "通过";
    public static final String CHECK_STATE_NOT_PASS = "未通过";

    // 审核的状态  1L= 结束， 0L = 进行中
    public static final Long SUBMIT_STATE_END = 1L;
    public static final Long SUBMIT_STATE_ING = 0L;
}
