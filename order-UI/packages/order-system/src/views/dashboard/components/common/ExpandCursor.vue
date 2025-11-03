<template>
	<div class="expand-cursor-wrapper" :class="{ 'has-overflow': showExpandButton, 'input-style': inputStyle }">
		<div ref="textContainer" class="text-container" :style="containerStyle">
			<span ref="textContent" class="text-content">{{ displayText }}</span>
		</div>
		<el-popover
			v-if="showExpandButton"
			ref="popover"
			placement="top"
			width="auto"
			trigger="click"
			:popper-class="popoverClass"
			:open-delay="0"
		>
			<div class="popover-content">{{ text }}</div>
			<span slot="reference" class="expand-button" :class="{ 'input-style-button': inputStyle }">
				<i class="el-icon-arrow-down"></i>
			</span>
		</el-popover>
	</div>
</template>

<script>
export default {
	name: 'ExpandCursor',
	props: {
		// 显示的文本内容
		text: {
			type: [String, Number],
			default: ''
		},
		// 文本容器的最大宽度（如果未设置，则使用父容器宽度）
		maxWidth: {
			type: [String, Number],
			default: null
		},
		// Popover 的类名
		popoverClass: {
			type: String,
			default: 'expand-cursor-popover'
		},
		// 是否禁用溢出检测
		disabled: {
			type: Boolean,
			default: false
		},
		// 文本对齐方式
		textAlign: {
			type: String, 
			default: 'left',
			validator: value => ['left', 'center', 'right'].includes(value)
		},
		// 是否使用输入框样式（带边框）
		inputStyle: {
			type: Boolean,
			default: false
		},
		// 输入框尺寸 (mini, small, medium)
		size: {
			type: String,
			default: 'mini',
			validator: value => ['mini', 'small', 'medium'].includes(value)
		}
	},
	data() {
		return {
			isOverflowing: false,
			resizeObserver: null
		};
	},
	computed: {
		// 计算显示的文本内容
		displayText() {
			return this.text != null ? String(this.text) : '';
		},
		// 计算是否需要显示扩展按钮
		showExpandButton() {
			if (this.disabled || !this.displayText) {
				return false;
			}
			return this.isOverflowing;
		},
		// 计算容器的样式
		containerStyle() {
			const styles = {
				textAlign: this.textAlign
			};
			if (this.maxWidth !== null) {
				const maxWidth = typeof this.maxWidth === 'number' ? `${this.maxWidth}px` : this.maxWidth;
				styles.maxWidth = maxWidth;
			}
			return styles;
		}
	},
	mounted() {
		this.checkOverflow();
		this.initResizeObserver();
	},
	beforeDestroy() {
		this.destroyResizeObserver();
	},
	watch: {
		// 监听文本变化，使用防抖优化性能
		displayText: {
			handler() {
				this.$nextTick(() => {
					this.checkOverflow();
				});
			},
			immediate: false
		},
		maxWidth() {
			this.$nextTick(() => {
				this.checkOverflow();
			});
		},
		disabled(newVal) {
			if (!newVal) {
				this.$nextTick(() => {
					this.checkOverflow();
				});
			} else {
				this.isOverflowing = false;
			}
		},
		inputStyle() {
			this.$nextTick(() => {
				this.checkOverflow();
			});
		}
	},
	methods: {
		/**
		 * 检查文本是否溢出
		 */
		checkOverflow() {
			if (this.disabled || !this.displayText) {
				this.isOverflowing = false;
				return;
			}

			this.$nextTick(() => {
				const container = this.$refs.textContainer;
				const content = this.$refs.textContent;

				if (!container || !content) {
					this.isOverflowing = false;
					return;
				}

				// 检查是否溢出：内容宽度 > 容器宽度
				const containerWidth = container.clientWidth;
				const contentWidth = content.scrollWidth;

				// 考虑扩展按钮的宽度（如果有的话），避免误判
				const buttonWidth = this.inputStyle ? 28 : 24; // 输入框样式时按钮更宽
				this.isOverflowing = contentWidth > containerWidth - buttonWidth;
			});
		},
		/**
		 * 初始化 ResizeObserver 监听容器大小变化
		 */
		initResizeObserver() {
			if (typeof ResizeObserver === 'undefined') {
				// 不支持 ResizeObserver 时，使用 window resize 事件
				this.resizeHandler = this.debounce(this.checkOverflow, 200);
				window.addEventListener('resize', this.resizeHandler);
				return;
			}

			if (!this.$refs.textContainer) {
				return;
			}

			this.resizeObserver = new ResizeObserver(() => {
				this.checkOverflow();
			});

			this.resizeObserver.observe(this.$refs.textContainer);
		},
		/**
		 * 销毁 ResizeObserver
		 */
		destroyResizeObserver() {
			if (this.resizeObserver) {
				this.resizeObserver.disconnect();
				this.resizeObserver = null;
			}
			if (this.resizeHandler) {
				window.removeEventListener('resize', this.resizeHandler);
				this.resizeHandler = null;
			}
		},
		/**
		 * 防抖函数
		 */
		debounce(func, wait) {
			let timeout;
			return function executedFunction(...args) {
				const later = () => {
					clearTimeout(timeout);
					func(...args);
				};
				clearTimeout(timeout);
				timeout = setTimeout(later, wait);
			};
		}
	}
};
</script>

<style scoped lang="scss">
.expand-cursor-wrapper {
	display: inline-flex;
	align-items: center;
	width: 100%;
	max-width: 100%;
	position: relative;

	.text-container {
		flex: 1;
		min-width: 0; // 允许 flex 子元素收缩
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;

		.text-content {
			display: inline-block;
			width: 100%;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
	}

	&.has-overflow {
		.text-container {
			padding-right: 24px; // 为扩展按钮留出空间
		}

		&.input-style {
			.text-container {
				padding-right: 28px; // 输入框样式时按钮更宽
			}
		}
	}

	// 输入框样式
	&.input-style {
		border: 1px solid #dcdfe6;
		border-radius: 4px;
		background-color: #fff;
		transition: border-color 0.2s cubic-bezier(0.645, 0.045, 0.355, 1);

		&:hover {
			border-color: #c0c4cc;
		}

		.text-container {
			height: 24px; // 与 Element UI mini 尺寸一致
			line-height: 24px;
			padding: 0 8px;
			font-size: 11px;
			color: #181818;
			font-weight: bold;
		}

		.text-content {
			height: 100%;
			line-height: 24px;
		}
	}

	.expand-button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 20px;
		height: 20px;
		flex-shrink: 0;
		cursor: pointer;
		color: #409eff;
		font-size: 12px;
		margin-left: 4px;
		border-radius: 2px;
		transition: all 0.3s;
		position: absolute;
		right: 0;
		top: 50%;
		transform: translateY(-50%);

		&:hover {
			background-color: #ecf5ff;
			color: #66b1ff;
		}

		&:active {
			background-color: #b3d8ff;
			color: #409eff;
		}

		i {
			font-size: 12px;
			transition: transform 0.3s;
		}

		// 输入框样式按钮
		&.input-style-button {
			width: 24px;
			height: 24px;
			margin-left: 0;
			border-left: 1px solid #dcdfe6;
			border-radius: 0 4px 4px 0;
			right: 0;

			&:hover {
				background-color: #f5f7fa;
				color: #409eff;
				border-left-color: #c0c4cc;
			}

			&:active {
				background-color: #e4e7ed;
			}

			i {
				font-size: 11px;
			}
		}
	}
}

// Popover 内容样式
::v-deep .expand-cursor-popover {
	.el-popover__inner {
		max-width: 400px;
		max-height: 300px;
		overflow-y: auto;
		word-break: break-all;
		white-space: pre-wrap;
		line-height: 1.5;
		padding: 12px;
	}
}
</style>

