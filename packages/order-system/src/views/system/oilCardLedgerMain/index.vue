<!-- 用户需求：在 system/oilCardLedgerMain/index 创建主卡登记台账页面。实际改动：新增主卡页面入口并固定主卡类型、权限前缀和列配置存储名称。 -->
<template>
	<OilCardLedgerPage card-type="主卡" page-title="主卡登记台账" permission-prefix="system:oilcardledgermain" table-name="oil-card-ledger-main-columns" />
</template>

<script>
import OilCardLedgerPage from '../components/OilCardLedgerPage.vue';

export default {
	name: 'OilCardLedgerMain',
	components: { OilCardLedgerPage }
};
</script>
