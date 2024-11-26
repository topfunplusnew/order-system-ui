<!--字段空值填充组件-->

<script>
export default {
	name: 'DynamicField',
	props: {
		row: {
			type: Object,
			required: true
		},
		field: {
			type: String,
			required: true
		}
	},
	computed: {
		value() {
			return this.row[this.field];
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
