<!--申请审核需要展示的对应的表信息-->
<script>
import { TableComponentsTools } from '@/utils/order/mapper';

export default {
	name: 'NeedToShowInfo',
	props: {
		needToShowInfo: {},
		tableNameToProp: {
			type: String,
			default: ''
		}
	},
	data() {
		return {
			info: {}
		};
	},
	computed: {
		show: {
			get() {
				return this.getComponents(this.tableNameToProp);
			},
			set(value) {
				this.show = value;
			}
		}
	},
	watch: {
		needToShowInfo(val) {
			this.info = val;
		},
		tableNameToProp(val) {
			this.show = this.getComponents(val);
		}
	},
	methods: {
		getComponents(tableName) {
			const tableComponentsTools = new TableComponentsTools();
			return tableComponentsTools.getComponentsByTableName(tableName);
		}
	}
};
</script>

<template>
	<div v-if="needToShowInfo">
		<component :is="show" :needToShowInfo="info" />
	</div>
</template>

<style scoped lang="scss"></style>
