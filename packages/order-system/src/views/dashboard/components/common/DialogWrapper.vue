<template>
	<el-dialog
		v-if="internalVisible"
		:modal="false"
		v-dialogDrag
		v-el-relen-dialog
		:title="dialogTitle"
		:visible.sync="internalVisible"
		:width="dialogWidth"
		append-to-body
		:close-on-click-modal="false"
		:close-on-press-escape="false"
		:destroy-on-close="false"
		@open="handleOpen"
		@opened="handleOpened"
		@close="handleClose"
	>
		<keep-alive>
			<component :is="currentComponent" :key="dialogKey" ref="dynamicComponent" v-bind="dialogProps" />
		</keep-alive>
		<!-- 底部操作按钮 -->
		<template #footer>
			<el-button @click="handleClose">关闭</el-button>
			<el-button type="primary" @click="handleConfirm" v-if="!closeConfirm">确认</el-button>
		</template>
	</el-dialog>
</template>

<script>
import { Message } from 'element-ui';
export default {
	props: {
		// 弹窗是否可见
		dialogVisible: {
			type: Boolean,
			required: true
		},
		// 弹窗标题
		dialogTitle: {
			type: String,
			default: ''
		},
		// 动态内容组件名称或对象
		currentComponent: {
			type: [String, Object], // 动态内容组件名称或对象
			required: true
		},
		// 传递给内容组件的属性
		dialogProps: {
			type: Object, // 传递给内容组件的属性
			default: () => ({})
		},
		// 弹窗的宽度
		dialogWidth: {
			type: String,
			default: '50%'
		},
		// 是否关闭确认键
		closeConfirm: {
			type: Boolean,
			default: false
		}
	},
	// 局部 directives 已移除，依赖 main.js 全局注册
	data() {
		return {
			// 用于强制重新创建动态组件
			dialogKey: 0,
			// 保存组件状态
			componentStates: {},
			// 内部可见状态
			internalVisible: this.dialogVisible
		};
	},
	watch: {
		dialogVisible(val) {
			this.internalVisible = val;
			if (val) {
				// 每次打开弹窗，更新 key（仅在首次打开时）
				if (!this.componentStates[this.currentComponent]) {
					this.dialogKey++;
				}
			}
		},
		internalVisible(val) {
			// 同步内部状态到外部
			if (val !== this.dialogVisible) {
				this.$emit('update:dialogVisible', val);
			}
		}
	},

	mounted() {
		// 确保弹窗加载后的拖拽优化
		this.$nextTick(() => {
			const dialogEl = this.$el.querySelector('.el-dialog');
			if (dialogEl) {
				// 防止弹窗内容区域的拖拽事件冒泡影响
				dialogEl.addEventListener('dragstart', e => {
					e.preventDefault();
				});

				// 优化选择体验
				dialogEl.style.cssText += ';-webkit-touch-callout: none;-webkit-tap-highlight-color: transparent;';
			}
		});
	},
	// 声明组件emit的事件
	emits: ['update:dialogVisible', 'confirm', 'close'],
	methods: {
		// 保存组件状态
		saveComponentState() {
			if (this.$refs.dynamicComponent && this.currentComponent) {
				// 保存组件的data状态
				const componentData = { ...this.$refs.dynamicComponent.$data };
				this.componentStates[this.currentComponent] = componentData;
			}
		},

		// 恢复组件状态
		restoreComponentState() {
			if (this.$refs.dynamicComponent && this.componentStates[this.currentComponent]) {
				const savedState = this.componentStates[this.currentComponent];
				// 恢复组件状态
				Object.assign(this.$refs.dynamicComponent.$data, savedState);
			}
		},

		// 隐藏弹窗（用于keep-alive场景）
		hideDialog() {
			this.saveComponentState();
			this.internalVisible = false;
		},

		// 显示弹窗（用于keep-alive场景）
		showDialog() {
			this.internalVisible = true;
			this.$nextTick(() => {
				this.restoreComponentState();
			});
		},

		// 关闭弹窗
		handleClose() {
			// 执行函数 这个函数 要求每一个业务组件都要实现
			const callback = this.$refs.dynamicComponent?.handleReject;
			if (callback) {
				this.$emit('update:dialogVisible', false);
				this.$emit('close', callback);
			} else {
				Message.warning('组件未实现handleReject方法');
			}
		},
		handleOpened() {
			this.$nextTick(() => {
				if (typeof window !== 'undefined') {
					window.dispatchEvent(new Event('resize'));
				}

				this.invokeDialogOpenedHooks(this.$refs.dynamicComponent);
			});
		},
		handleOpen() {
			this.$nextTick(() => {
				this.invokeDialogOpenedHooks(this.$refs.dynamicComponent);
			});
		},
		invokeDialogOpenedHooks(componentInstance) {
			if (!componentInstance) {
				return;
			}

			if (typeof componentInstance.handleDialogOpened === 'function') {
				componentInstance.handleDialogOpened();
			}

			if (Array.isArray(componentInstance.$children)) {
				componentInstance.$children.forEach(child => {
					this.invokeDialogOpenedHooks(child);
				});
			}
		},
		// 确认按钮 提醒父组件执行相关的逻辑
		handleConfirm() {
			// 执行函数 这个函数 要求每一个业务组件都要实现
			const callback = this.$refs.dynamicComponent?.handleProcess;
			if (callback) {
				this.$emit('confirm', callback);
			} else {
				Message.warning('组件未实现handleProcess方法');
			}
		}
	}
};
</script>

<style scoped>
/* 去除文字选中样式，优化拖拽体验 */
.el-dialog {
	user-select: none;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
}

/* 恢复弹窗内容区域的文字选中功能 */
.el-dialog__body {
	user-select: text;
	-webkit-user-select: text;
	-moz-user-select: text;
	-ms-user-select: text;
}

/* 输入框、文本域等表单元素恢复选中功能 */
.el-dialog__body input,
.el-dialog__body textarea,
.el-dialog__body .el-input__inner,
.el-dialog__body .el-textarea__inner {
	user-select: text;
	-webkit-user-select: text;
	-moz-user-select: text;
	-ms-user-select: text;
}

/* 标题栏拖拽优化 */
.el-dialog__header {
	cursor: move;
	user-select: none;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
}

/* 底部按钮区域 */
.el-dialog__footer {
	user-select: none;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
}

/* 防止在拖拽时选中文本 */
.el-dialog__wrapper {
	user-select: none;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
}
</style>
