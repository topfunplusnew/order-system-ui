<template>
	<div class="expand-cursor-wrapper" :class="{ 'has-overflow': showExpandButton, 'input-style': inputStyle }">
		<div ref="textContainer" class="text-container" :style="containerStyle">
			<!-- 如果有插槽，使用插槽；否则使用文本 -->
			<span v-if="!hasSlot" ref="textContent" class="text-content">{{ displayText }}</span>
			<span v-else ref="textContent" class="text-content">
				<slot></slot>
			</span>
		</div>
		<!-- 测量元素：用于测量内容的实际宽度 -->
		<span v-if="!hasSlot" ref="measureElement" class="measure-element">{{ displayText }}</span>
		<span v-else ref="measureElement" class="measure-element"></span>
		<el-popover v-if="showExpandButton" ref="popover" placement="top" width="auto" trigger="click" :popper-class="popoverClass" :open-delay="0">
			<div class="popover-content">
				<!-- Popover 中显示插槽或文本 -->
				<slot v-if="hasSlot"></slot>
				<span v-else>{{ text }}</span>
			</div>
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
		// 检查是否有插槽内容
		hasSlot() {
			return !!this.$slots.default && this.$slots.default.length > 0;
		},
		// 计算显示的文本内容
		displayText() {
			return this.text != null ? String(this.text) : '';
		},
		// 计算是否有内容（插槽或文本）
		hasContent() {
			return this.hasSlot || this.displayText;
		},
		// 计算是否需要显示扩展按钮
		showExpandButton() {
			if (this.disabled || !this.hasContent) {
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
		// 监听插槽变化
		hasSlot: {
			handler() {
				this.$nextTick(() => {
					this.checkOverflow();
				});
			},
			immediate: false
		},
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
		 * 检查内容是否溢出
		 * 使用测量元素来测量内容（文本或插槽）的实际宽度，并与 maxWidth 进行比较
		 */
		checkOverflow() {
			if (this.disabled || !this.hasContent) {
				this.isOverflowing = false;
				return;
			}

			this.$nextTick(() => {
				const measureElement = this.$refs.measureElement;
				const container = this.$refs.textContainer;

				if (!measureElement || !container) {
					this.isOverflowing = false;
					return;
				}

				// 复制实际内容元素的样式到测量元素
				const textContent = this.$refs.textContent;
				if (textContent) {
					const computedStyle = window.getComputedStyle(textContent);
					// 设置影响宽度的关键样式
					measureElement.style.fontSize = computedStyle.fontSize;
					measureElement.style.fontWeight = computedStyle.fontWeight;
					measureElement.style.fontFamily = computedStyle.fontFamily;
					measureElement.style.fontStyle = computedStyle.fontStyle;
					measureElement.style.fontVariant = computedStyle.fontVariant;
					measureElement.style.letterSpacing = computedStyle.letterSpacing;
					measureElement.style.wordSpacing = computedStyle.wordSpacing;
					measureElement.style.padding = computedStyle.padding;
					measureElement.style.border = computedStyle.border;
					measureElement.style.boxSizing = computedStyle.boxSizing;
					measureElement.style.lineHeight = computedStyle.lineHeight;
					// 复制其他可能影响宽度的样式
					measureElement.style.margin = computedStyle.margin;
					measureElement.style.display = computedStyle.display;
					// 确保测量元素不受宽度限制
					measureElement.style.maxWidth = 'none';
					measureElement.style.width = 'auto';

					// 如果有插槽内容，需要克隆显示区域的内容到测量元素
					if (this.hasSlot) {
						// 等待插槽内容渲染完成
						this.$nextTick(() => {
							if (textContent.children.length > 0) {
								// 清空测量元素
								measureElement.innerHTML = '';
								// 克隆所有子节点
								Array.from(textContent.children).forEach(child => {
									const clonedChild = child.cloneNode(true);
									// 复制样式
									if (child.style && child.style.cssText) {
										clonedChild.style.cssText = child.style.cssText;
									}
									// 复制计算样式中的关键属性
									const childComputedStyle = window.getComputedStyle(child);
									clonedChild.style.fontSize = childComputedStyle.fontSize;
									clonedChild.style.fontWeight = childComputedStyle.fontWeight;
									clonedChild.style.fontFamily = childComputedStyle.fontFamily;
									clonedChild.style.margin = childComputedStyle.margin;
									clonedChild.style.padding = childComputedStyle.padding;
									measureElement.appendChild(clonedChild);
								});
							}
							// 继续执行测量
							this.performMeasurement(measureElement, container);
						});
						return;
					}
				}

				// 等待内容渲染完成（文本内容）
				this.$nextTick(() => {
					this.performMeasurement(measureElement, container);
				});
			});
		},
		/**
		 * 执行实际的宽度测量和溢出判断
		 */
		performMeasurement(measureElement, container) {
			// 获取测量元素的实际宽度（内容自然展开的宽度）
			let contentWidth = measureElement.offsetWidth;

			// 如果测量元素内部有子元素（插槽内容），尝试获取子元素的实际宽度
			if (measureElement.children.length > 0) {
				// 遍历所有子元素，找到最宽的那个
				let maxChildWidth = 0;
				Array.from(measureElement.children).forEach(child => {
					const childWidth = child.offsetWidth || child.scrollWidth;
					maxChildWidth = Math.max(maxChildWidth, childWidth);
				});
				// 如果有子元素宽度，使用子元素的宽度加上可能的边距
				if (maxChildWidth > 0) {
					const computedStyle = window.getComputedStyle(measureElement);
					const paddingLeft = parseFloat(computedStyle.paddingLeft) || 0;
					const paddingRight = parseFloat(computedStyle.paddingRight) || 0;
					contentWidth = maxChildWidth + paddingLeft + paddingRight;
				}
			}

			// 确定比较基准宽度
			let compareWidth;
			if (this.maxWidth !== null) {
				// 如果有设置 maxWidth，直接使用它
				if (typeof this.maxWidth === 'number') {
					compareWidth = this.maxWidth;
				} else {
					// 如果是字符串（如 '100px', '50%'），需要转换为像素值
					// 使用容器的实际宽度作为参考
					const containerWidth = container.clientWidth;
					if (this.maxWidth.endsWith('%')) {
						const percent = parseFloat(this.maxWidth) / 100;
						compareWidth = containerWidth * percent;
					} else if (this.maxWidth.endsWith('px')) {
						compareWidth = parseFloat(this.maxWidth);
					} else {
						// 其他情况，尝试转换为数字
						compareWidth = parseFloat(this.maxWidth) || containerWidth;
					}
				}
			} else {
				// 如果没有设置 maxWidth，使用容器的实际宽度
				compareWidth = container.clientWidth;
			}

			// 考虑扩展按钮的宽度（如果有的话），避免误判
			const buttonWidth = this.inputStyle ? 28 : 24; // 输入框样式时按钮更宽
			this.isOverflowing = contentWidth > compareWidth - buttonWidth;
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
			text-align: center;
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

	// 测量元素：用于测量内容（文本或插槽）实际宽度，不可见
	.measure-element {
		position: absolute;
		visibility: hidden;
		white-space: nowrap;
		top: -9999px;
		left: -9999px;
		height: auto;
		width: auto;
		// 确保测量元素不受任何宽度限制，让内容自然展开
		max-width: none;
		// 复制内容的样式
		display: inline-block;

		// 确保插槽内容也能正常测量
		::v-deep > * {
			display: inline-block;
			white-space: nowrap;
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
