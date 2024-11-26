<script>
export default {
	name: 'index.vue',
	// checkInfo=>需要检查的变量
	// checkValue=>判断值为假的值
	props: {
		checkInfo: {},
		checkValue: ''
	}
};
</script>

<template>
	<div>
		<el-tag v-if="checkInfo === checkValue" size="small" type="danger"
			>{{ checkInfo }}
		</el-tag>
		<el-tag v-else size="small">{{ checkInfo }} </el-tag>
	</div>
</template>

<style scoped lang="scss"></style>
