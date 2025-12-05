<!-- src/components/FitTable.vue -->
<template>
	<el-table :data="tableData" v-bind="$attrs" class="fit-table" @header-click="handleHeaderClick">
		<!-- 组件内容 -->
		<slot />
	</el-table>
</template>

<script>
import { ref, watch } from 'vue';
import FitColumnPlugin from 'v-fit-columns';

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
	setup(props) {
		const tableRef = ref(null);

		// 监听数据变化，重新计算列宽
		watch(
			() => props.tableData,
			() => {
				if (props.fitColumns && tableRef.value) {
					FitColumnPlugin.resize(tableRef.value);
				}
			}
		);

		const handleHeaderClick = (column, event) => {
			$emit('header-click', column, event);
		};

		return {
			tableRef,
			handleHeaderClick
		};
	}
};
</script>

<style scoped>
.fit-table {
	width: 100%;
}
</style>
