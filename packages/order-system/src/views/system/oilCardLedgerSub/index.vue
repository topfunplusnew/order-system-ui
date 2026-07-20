<!-- 用户需求：在 system/oilCardLedgerSub/index 创建副卡登记台账页面。实际改动：新增副卡页面入口并固定副卡类型、权限前缀和列配置存储名称。 -->
<template>
	<OilCardLedgerPage card-type="副卡" page-title="副卡登记台账" permission-prefix="system:oilcardledgersub" table-name="oil-card-ledger-sub-columns" />
</template>

<script>
import OilCardLedgerPage from '../components/OilCardLedgerPage.vue';

export default {
	name: 'OilCardLedgerSub',
	components: { OilCardLedgerPage }
};
</script>
