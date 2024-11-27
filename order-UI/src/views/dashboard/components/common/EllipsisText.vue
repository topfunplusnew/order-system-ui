<template>
	<div>
		<!-- 使用 Tooltip 来实现更灵活的悬停效果 -->
		<el-tooltip class="item" effect="dark" :content="title" placement="top">
			<div class="ellipsis-container">
				{{ title }}
			</div>
		</el-tooltip>
	</div>
</template>

<script>
export default {
	name: 'EllipsisText',
	props: {
		title: {
			type: String,
			required: true
		}
	}
};
</script>

<style scoped lang="scss">
.ellipsis-container {
	white-space: nowrap; /* 强制单行显示 */
	overflow: hidden; /* 超出内容隐藏 */
	text-overflow: ellipsis; /* 超出内容显示省略号 */
	max-width: 60px; /* 设定最大宽度，按需调整 */
	display: inline-block;
}
</style>
