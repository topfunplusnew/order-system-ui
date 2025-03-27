<script>
export default {
	name: 'FlexTable',
	props: {
		body: {
			type: Object,
			default: () => {}
		}
	},
	created() {
		console.log(this.body);
	}
};
</script>

<template>
	<div></div>
</template>

<style scoped lang="scss"></style>
