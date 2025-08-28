<template>
    <div class="payment-flag">
        <el-tag :type="tagType" :color="tagColor" effect="dark" size="small" class="payment-status-tag">
            {{ statusText }}
        </el-tag>

        <!-- 可选的扩展插槽 -->
        <slot name="extra" :status="currentStatus" :type="statusType"></slot>
    </div>
</template>

<script>
import { PAYMENT_STATE, PAYMENT_APPLY_STATE } from '@/api/tool/enums';

export default {
    name: 'PaymentFlag',
    props: {
        // 业务对象，包含payment或paymentApply属性
        businessObject: {
            type: Object,
            required: true,
            default: () => ({})
        },
        // 是否显示详细信息
        showDetail: {
            type: Boolean,
            default: false
        },
        // 自定义尺寸
        size: {
            type: String,
            default: 'small',
            validator: (value) => ['mini', 'small', 'medium'].includes(value)
        },
        // 自定义状态判断函数
        customStatusFn: {
            type: Function,
            default: null
        },
        // 自定义状态样式映射
        customStatusStyles: {
            type: Object,
            default: () => ({})
        }
    },
    computed: {
        /**
         * 计算当前状态信息
         * @returns {Object} 包含状态文本、类型等信息
         */
        statusInfo() {
            // 如果传入了自定义状态判断函数，优先使用
            if (this.customStatusFn && typeof this.customStatusFn === 'function') {
                const customResult = this.customStatusFn(this.businessObject);
                // 合并自定义样式
                return {
                    ...customResult,
                    ...this.getCustomStyles(customResult.status)
                };
            }

            // 优先判断payment对象
            if (this.hasValidPayment) {
                return this.getPaymentStatus();
            }

            // 其次判断paymentApply对象
            if (this.hasValidPaymentApply) {
                return this.getPaymentApplyStatus();
            }

            // 都不存在时的默认状态（未申请）
            return this.getDefaultStatus();
        },

        /**
         * 检查是否存在有效的payment对象
         * @returns {Boolean}
         */
        hasValidPayment() {
            return this.businessObject &&
                this.businessObject.payment &&
                this.businessObject.payment !== null &&
                typeof this.businessObject.payment === 'object';
        },

        /**
         * 检查是否存在有效的paymentApply对象  
         * @returns {Boolean}
         */
        hasValidPaymentApply() {
            return this.businessObject &&
                this.businessObject.paymentApply &&
                this.businessObject.paymentApply !== null &&
                typeof this.businessObject.paymentApply === 'object';
        },

        /**
         * 当前状态文本
         * @returns {String}
         */
        statusText() {
            return this.statusInfo.text;
        },

        /**
         * 标签类型
         * @returns {String}
         */
        tagType() {
            return this.statusInfo.type;
        },

        /**
         * 标签颜色
         * @returns {String}
         */
        tagColor() {
            return this.statusInfo.color;
        },

        /**
         * 当前状态
         * @returns {String}
         */
        currentStatus() {
            return this.statusInfo.status;
        },

        /**
         * 状态类型（payment/paymentApply/unknown）
         * @returns {String}
         */
        statusType() {
            return this.statusInfo.statusType;
        }
    },
    methods: {
        /**
         * 获取付款状态信息
         * @returns {Object} 状态信息对象
         */
        getPaymentStatus() {
            const paymentState = this.businessObject.payment.paymentState;

            if (paymentState === PAYMENT_STATE.PAID) {
                return {
                    text: '已支付',
                    type: 'success',
                    color: '#67C23A',
                    status: PAYMENT_STATE.PAID,
                    statusType: 'payment'
                };
            } else if (paymentState === PAYMENT_STATE.UNPAID) {
                return {
                    text: '未支付',
                    type: 'danger',
                    color: '#F56C6C',
                    status: PAYMENT_STATE.UNPAID,
                    statusType: 'payment'
                };
            }

            // 未知付款状态
            return {
                text: paymentState || '状态未知',
                type: 'warning',
                color: '#E6A23C',
                status: paymentState,
                statusType: 'payment'
            };
        },

        /**
         * 获取付款申请状态信息
         * @returns {Object} 状态信息对象
         */
        getPaymentApplyStatus() {
            const checkState = this.businessObject.paymentApply.checkState;
            const v2States = PAYMENT_APPLY_STATE.V2;

            switch (checkState) {
                case v2States.PENDING:
                    return {
                        text: '待提交',
                        type: 'info',
                        color: '#909399',
                        status: v2States.PENDING,
                        statusType: 'paymentApply'
                    };
                case v2States.ING:
                    return {
                        text: '审核中',
                        type: 'warning',
                        color: '#E6A23C',
                        status: v2States.ING,
                        statusType: 'paymentApply'
                    };
                case v2States.PASS:
                    return {
                        text: '审核通过',
                        type: 'success',
                        color: '#67C23A',
                        status: v2States.PASS,
                        statusType: 'paymentApply'
                    };
                case v2States.NOT_PASS:
                    return {
                        text: '审核未通过',
                        type: 'danger',
                        color: '#F56C6C',
                        status: v2States.NOT_PASS,
                        statusType: 'paymentApply'
                    };
                case v2States.REJECT:
                    return {
                        text: '已驳回',
                        type: 'danger',
                        color: '#F56C6C',
                        status: v2States.REJECT,
                        statusType: 'paymentApply'
                    };
                case v2States.VOID:
                    return {
                        text: '已作废',
                        type: 'info',
                        color: '#909399',
                        status: v2States.VOID,
                        statusType: 'paymentApply'
                    };
                case v2States.UN_APPLIED:
                    return {
                        text: '未申请',
                        type: 'info',
                        color: '#C0C4CC',
                        status: v2States.UN_APPLIED,
                        statusType: 'paymentApply'
                    };
                default:
                    return {
                        text: checkState || '状态未知',
                        type: 'warning',
                        color: '#E6A23C',
                        status: checkState,
                        statusType: 'paymentApply'
                    };
            }
        },

        /**
         * 获取默认状态信息
         * @returns {Object} 默认状态信息对象
         */
        getDefaultStatus() {
            const v2States = PAYMENT_APPLY_STATE.V2;
            return {
                text: '未申请',
                type: 'info',
                color: '#C0C4CC',
                status: v2States.UN_APPLIED,
                statusType: 'paymentApply'
            };
        },

        /**
         * 获取自定义样式
         * @param {String} status 状态值
         * @returns {Object} 样式对象
         */
        getCustomStyles(status) {
            if (this.customStatusStyles && this.customStatusStyles[status]) {
                return this.customStatusStyles[status];
            }
            return {};
        }
    }
};
</script>

<style lang="scss" scoped>
.payment-flag {
    display: inline-flex;
    align-items: center;
    gap: 8px;

    .payment-status-tag {
        font-weight: 500;
        border-radius: 4px;

        &.el-tag--mini {
            height: 20px;
            line-height: 18px;
            font-size: 11px;
        }

        &.el-tag--small {
            height: 24px;
            line-height: 22px;
            font-size: 12px;
        }

        &.el-tag--medium {
            height: 28px;
            line-height: 26px;
            font-size: 13px;
        }
    }
}

// 深色模式适配（如果需要）
@media (prefers-color-scheme: dark) {
    .payment-flag {
        .payment-status-tag {
            border-color: rgba(255, 255, 255, 0.1);
        }
    }
}
</style>