<template>
	<span class="history-list-trigger" @click.stop="handleClick">查看历史</span>
</template>

<script>
export default {
	name: 'HistoryList',
	props: {
		row: {
			type: Object,
			required: true
		}
	},
	methods: {
		handleClick() {
			// 通过事件通知父组件查看历史记录
			this.$emit('check-history', this.row);

			// 同时尝试调用父组件的 checkOrderHistory 方法（如果存在）
			// 向上查找父组件，直到找到有 checkOrderHistory 方法的组件
			let parent = this.$parent;
			while (parent) {
				if (parent && typeof parent.checkOrderHistory === 'function') {
					parent.checkOrderHistory(this.row);
					break;
				}
				parent = parent.$parent;
			}
		}
	}
};
</script>

<style scoped lang="scss">
.history-list-trigger {
	cursor: pointer;
	color: #409eff;
	font-size: 12px;
	padding: 0 4px;
	display: inline-block;

	&:hover {
		color: #66b1ff;
		text-decoration: underline;
	}
}
</style>
