<template>
	<div class="app-container">
		<ElTableOrder :is-adjust-order="false" deleted-mode />
	</div>
</template>

<script>
import ElTableOrder from '@/views/dashboard/components/goodsOrder/ElTableOrder.vue';

export default {
	name: 'DeletedGoodsOrder',
	components: {
		ElTableOrder
	}
};
</script>
