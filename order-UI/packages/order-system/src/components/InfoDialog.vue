<!--弹窗通用组件 可以传入自定义的函数来进行使用 -->

<script>
export default {
	name: 'InfoDialog',
	inheritAttrs: false,
	props: {
		title: String,
		width: {
			type: String,
			default: '1350px'
		}
	},
	data() {
		return {};
	},
	watch: {},
	created() {},
	mounted() {},
	methods: {
		onOpen() {},
		close() {
			this.$emit('update:visible', false);
		},
		confirm() {}
	}
};
</script>

<template>
	<div>
		<keep-alive>
			<el-dialog :close-on-click-modal="false" v-bind="$attrs" :title="title" :width="width" append-to-body v-on="$listeners" @open="onOpen">
				<!--      slot只是一个占位符 实际上还是在index.vue中作为子组件 所以可以直接在slot代表的组件中定义回调-->
				<slot name="info"></slot>
			</el-dialog>
		</keep-alive>
	</div>
</template>

<style scoped lang="scss"></style>
