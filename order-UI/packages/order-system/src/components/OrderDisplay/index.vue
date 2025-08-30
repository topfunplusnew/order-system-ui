<script>
import OrderInfos from '@/views/dashboard/components/goodsOrder/OrderInfos.vue';
import OrderDetailInfo from '@/views/dashboard/components/goodsOrder/OrderDetailInfo.vue';

export default {
    name: 'OrderDisplay',
    components: { OrderInfos, OrderDetailInfo },
    props: {
        // 订单表头信息
        orderInfo: {
            type: Object,
            default: () => ({})
        },
        // 订单明细列表
        orderDetailInfoList: {
            type: Array,
            default: () => []
        },
        // 是否禁用明细里的操作列（查看场景默认禁用）
        ban: {
            type: Boolean,
            default: true
        },
        // 可选：卡片最大高度，便于在弹窗中使用
        maxBodyHeight: {
            type: [Number, String],
            default: '70vh'
        }
    },
    computed: {
        // 明细统计（轻量可选）
        detailStats() {
            const list = Array.isArray(this.orderDetailInfoList) ? this.orderDetailInfoList : [];
            const sum = (k) => list.reduce((acc, cur) => acc + (Number(cur[k]) || 0), 0);
            return {
                count: list.length,
                payments: sum('payments'),
                freight: sum('freight'),
                landFreight: sum('landFreight'),
                seaFreight: sum('seaFreight'),
                profit: sum('profit'),
                tonnage: sum('tonnage')
            };
        },
        checkStateTagType() {
            const cs = this.orderInfo && this.orderInfo.checkState;
            if (cs === '已审核' || cs === '审核通过') return 'success';
            if (cs === '驳回' || cs === '审核不通过') return 'danger';
            if (cs === '审核中' || cs === '待审核') return 'warning';
            return 'info';
        },
        customerInvoiceTag() {
            const v = this.orderInfo && this.orderInfo.customerIsInvoice;
            if (v === 1) return { type: 'success', text: '客户已开票' };
            if (v === 0) return { type: 'info', text: '客户未开票' };
            return null;
        },
        supplierInvoiceTag() {
            const v = this.orderInfo && this.orderInfo.isSupplierInvoice;
            if (v >= 1) return { type: 'success', text: '供应商已开票' };
            if (v === 0) return { type: 'info', text: '供应商未开票' };
            return null;
        },
        handleProcess() { },
        handleReject() { }
    }
};
</script>

<template>
    <div class="order-display-wrapper">
        <el-card class="order-display-card" shadow="never">
            <div slot="header" class="header">
                <div class="title">
                    <i class="el-icon-document"></i>
                    <span>订单详情</span>
                    <el-tag v-if="orderInfo && orderInfo.checkState" :type="checkStateTagType" size="mini"
                        class="gap-l">
                        {{ orderInfo.checkState }}
                    </el-tag>
                    <el-tag v-if="customerInvoiceTag" :type="customerInvoiceTag.type" size="mini" effect="plain"
                        class="gap-l">
                        {{ customerInvoiceTag.text }}
                    </el-tag>
                    <el-tag v-if="supplierInvoiceTag" :type="supplierInvoiceTag.type" size="mini" effect="plain"
                        class="gap-l">
                        {{ supplierInvoiceTag.text }}
                    </el-tag>
                </div>
                <div class="meta">
                    <span v-if="orderInfo && orderInfo.ordersNo">订单号：{{ orderInfo.ordersNo }}</span>
                    <span v-if="orderInfo && orderInfo.orderDate">下单日期：{{ orderInfo.orderDate }}</span>
                    <span v-if="orderInfo && orderInfo.userName">录入员：{{ orderInfo.userName }}</span>
                </div>
            </div>

            <div class="body"
                :style="{ maxHeight: typeof maxBodyHeight === 'number' ? maxBodyHeight + 'px' : maxBodyHeight }">
                <!-- 表头信息 -->
                <OrderInfos :orderInfo="orderInfo || {}" />

                <el-divider></el-divider>

                <!-- 轻量统计条 -->
                <div class="stats" v-if="detailStats && detailStats.count">
                    <el-alert type="info" :closable="false" show-icon>
                        <template #title>
                            共 {{ detailStats.count }} 条明细；
                            总货款：<b class="num">{{ detailStats.payments }}</b>
                            <span class="sep">|</span>
                            总运费：<b class="num">{{ detailStats.freight }}</b>
                            <span class="sep">|</span>
                            陆运费：<b class="num">{{ detailStats.landFreight }}</b>
                            <span class="sep">|</span>
                            海运费：<b class="num">{{ detailStats.seaFreight }}</b>
                            <span class="sep">|</span>
                            吨位：<b class="num">{{ detailStats.tonnage }}</b>
                            <span class="sep">|</span>
                            利润：<b class="num">{{ detailStats.profit }}</b>
                        </template>
                    </el-alert>
                </div>

                <!-- 明细表格（内部自带合计行） -->
                <OrderDetailInfo :orderDetailInfoList="orderDetailInfoList || []" :ban="ban" />
            </div>
        </el-card>
    </div>
</template>

<style scoped lang="scss">
.order-display-wrapper {
    height: 100%;
    display: flex;
    flex-direction: column;
}

.order-display-card {
    border: 1px solid #ebeef5;
    border-radius: 8px;

    ::v-deep .el-card__header {
        padding: 12px 16px;
        background: linear-gradient(135deg, #f8fbff 0%, #f0f7ff 100%);
        border-bottom: 1px solid #ebeef5;
    }
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;

    .title {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 600;
        color: #303133;

        i {
            color: #409eff;
        }
    }

    .meta {
        display: flex;
        gap: 12px;
        color: #909399;
        font-size: 12px;
    }
}

.gap-l {
    margin-left: 6px;
}

.body {
    overflow: auto;
    padding: 12px 12px 4px 12px;
}

.stats {
    margin-bottom: 8px;

    .num {
        color: #f56c6c;
    }

    .sep {
        margin: 0 8px;
        color: #dcdfe6;
    }
}

@media screen and (max-width: 768px) {
    .header {
        flex-direction: column;
        align-items: flex-start;
    }

    .meta {
        flex-wrap: wrap;
    }
}
</style>