<!-- 用户需求：付款报表页面的日期改为时间段搜索，/statistics/paymentReport 使用 startDate、endDate。实际改动：继续复用已支持 yyyy-MM-dd 起止日期查询的 FundReport 共享组件。 -->
<template>
	<FundReport report-type="payment" />
</template>

<script>
import FundReport from './components/FundReport.vue';

export default {
	name: 'PaymentReport',
	components: { FundReport }
};
</script>
