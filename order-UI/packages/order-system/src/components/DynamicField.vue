<!--字段空值填充组件-->

<script>
export default {
	name: 'DynamicField',
	props: {
		row: {
			type: Object,
			default: () => ({}),
			required: true
		},
		field: {
			type: String,
			default: '',
			required: true
		}
	},
	computed: {
		value() {
			let value = this.row[this.field];
			return value ? this.row[value] : '';
		}
	}
};
</script>

<template>
	<div>
		<div>
			<span v-if="value !== '' && value !== null">
				{{ value }}
			</span>
			<span v-else>-</span>
		</div>
	</div>
</template>

<style scoped lang="scss"></style>
