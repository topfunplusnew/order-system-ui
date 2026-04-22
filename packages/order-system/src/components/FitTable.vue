<!-- src/components/FitTable.vue -->
<template>
	<el-table ref="table" :data="tableData" v-bind="$attrs" class="fit-table" :data-auto-width-disabled="fitColumns ? null : 'true'" @header-click="handleHeaderClick">
		<slot />
	</el-table>
</template>

<script>
import { applyAutoWidthToTable } from '@/utils/tableAutoWidth';

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
	data() {
		return {
			autoWidthTimer: null
		};
	},
	watch: {
		tableData() {
			this.scheduleAutoWidth();
		},
		fitColumns() {
			this.scheduleAutoWidth();
		}
	},
	mounted() {
		this.scheduleAutoWidth();
	},
	updated() {
		this.scheduleAutoWidth();
	},
	beforeDestroy() {
		clearTimeout(this.autoWidthTimer);
	},
	methods: {
		scheduleAutoWidth() {
			clearTimeout(this.autoWidthTimer);
			this.autoWidthTimer = setTimeout(() => {
				if (!this.fitColumns || !this.$refs.table) {
					return;
				}

				this.$nextTick(() => {
					applyAutoWidthToTable(this.$refs.table, {
						padding: 8,
						emptyContentMaxWidth: 200
					});
				});
			}, 60);
		},
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
