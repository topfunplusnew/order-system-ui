<template>
	<div class="app-container">
		<ElTableOrder :is-adjust-order="true" deleted-mode />
	</div>
</template>

<script>
import ElTableOrder from '@/views/dashboard/components/goodsOrder/ElTableOrder.vue';

export default {
	name: 'DeletedAdjustOrders',
	components: {
		ElTableOrder
	}
};
</script>
