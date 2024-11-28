<script>
export default {
	name: 'InvoiceItem',
	props: {
		invoice: {
			type: Object,
			default: () => {
				return {};
			}
		}
	}
};
</script>

<template>
	<div>
		<div class="invoice"></div>
	</div>
</template>

<style scoped lang="scss">
.invoice {
	width: 100%;
	margin: 10px;
	height: 70px;
	background-color: red;
}
</style>
