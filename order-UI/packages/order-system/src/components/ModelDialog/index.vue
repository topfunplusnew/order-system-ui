<template>
	<el-dialog :visible.sync="visible" :title="title" width="600px" :close-on-click-modal="false">
		<div v-if="type === 'object'">
			<div v-for="(value, key) in data" :key="key" class="data-row">
				<strong>{{ labels[key] || key }}</strong>
				：{{ value }}
			</div>
		</div>

		<div v-else-if="type === 'array'">
			<el-table :data="items" style="width: 100%">
				<el-table-column v-for="(item, index) in array" :prop="item.prop" :label="item.label" :key="index"></el-table-column>
			</el-table>
		</div>

		<div v-else>
			<h4>待添加</h4>
		</div>
		<template #footer>
			<el-button @click="close">关闭</el-button>
		</template>
	</el-dialog>
</template>

<script>
export default {
	props: {
		visible: {
			type: Boolean,
			required: true
		},
		type: {
			type: String,
			default: 'object'
		},
		data: {
			type: Object,
			default: () => ({})
		},
		array: {
			type: Array,
			default: () => []
		},
		items: {
			type: Array,
			default: () => []
		},
		labels: {
			type: Object,
			default: () => ({})
		},
		title: {
			type: String,
			default: '信息展示'
		}
	},
	emits: ['update:visible'],
	methods: {
		close() {
			this.$emit('update:visible', false); // 触发 sync 事件，更新 visible
		}
	}
};
</script>

<style scoped>
.data-row {
	margin-bottom: 10px;
}
</style>
