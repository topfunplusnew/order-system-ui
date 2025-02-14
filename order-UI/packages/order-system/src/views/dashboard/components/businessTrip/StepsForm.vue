<!-- 分步表单-->
<script>
export default {
	name: 'StepsForm',
	props: {
		active: {
			type: Number,
			default: 0
		},
		// 第一步骤标题
		titleOne: {
			type: String,
			default: '填写信息'
		},
		// 第二步骤标题
		titleTwo: {
			type: String,
			default: '确认信息'
		},
		// 头部的提示
		titleInfo: {
			type: String,
			default: '请按照提示填写信息'
		}
	},
	data() {
		return {};
	},
	methods: {}
};
</script>

<template>
	<div>
		<!--      头部流程信息  -->
		<el-row>
			<div>
				<el-steps :active="active" finish-status="success">
					<el-step :title="titleOne"> </el-step>
					<el-step :title="titleTwo"> </el-step>
				</el-steps>
			</div>
		</el-row>
		<!--      提示信息-->
		<br />
		<el-row>
			<el-alert :title="titleInfo" type="info"> </el-alert>
		</el-row>
		<br />
		<el-row justify="center">
			<el-col :span="24">
				<!--        第一步骤-->
				<el-row v-if="active === 0">
					<slot name="step-one" />
				</el-row>
				<!--        第二步骤-->
				<el-row v-if="active === 1">
					<slot name="step-two" />
				</el-row>
				<!--        第三步骤  完成提交的页面-->
				<el-row v-if="active === 2">
					<slot name="step-three" />
				</el-row>
			</el-col>
		</el-row>
	</div>
</template>

<style scoped lang="scss"></style>
