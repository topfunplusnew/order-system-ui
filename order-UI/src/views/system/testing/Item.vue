<script>
export default {
	name: 'Item',
	filters: {},
	provide() {
		return {};
	},
	props: {
		title: {
			type: String
		}
	},
	data() {
		return {
			name: ''
		};
	},
	computed: {},
	watch: {},
	created() {
		console.log('Item::attrs', this.$attrs.name);
		console.log('created::Item::props', this.$props);
	},
	mounted() {
		console.log('mounted::Item::props', this.$props);
	},
	methods: {}
};
</script>

<template>
	<div>
		<h1>
			{{ title }}
		</h1>
	</div>
</template>

<style scoped lang="scss"></style>
