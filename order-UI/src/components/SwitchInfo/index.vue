<script>
export default {
	name: 'index.vue',
	props: {
		value1: Boolean,
		value2: Boolean
	}
};
</script>

<template>
	<div>
		<el-switch v-model="value1" disabled> </el-switch>
		<el-switch v-model="value2" disabled> </el-switch>
	</div>
</template>

<style scoped lang="scss"></style>
