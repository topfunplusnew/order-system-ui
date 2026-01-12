<!-- src/components/FitTable.vue -->
<template>
	<el-table :data="tableData" v-bind="$attrs" class="fit-table" @header-click="handleHeaderClick">
		<!-- 组件内容 -->
		<slot />
	</el-table>
</template>

<script>
export default {
	name: 'FitTable',
	inheritAttrs: false,
	props: {
		tableData: {
			type: Array,
			default: () => []
		},
		fitColumns: {
			type: Boolean,
			default: true
		}
	},
	methods: {
		handleHeaderClick(column, event) {
			this.$emit('header-click', column, event);
		}
	}
};
</script>

<style scoped>
.fit-table {
	width: 100%;
}
</style>
