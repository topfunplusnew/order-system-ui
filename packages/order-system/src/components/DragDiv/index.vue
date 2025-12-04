<template>
	<div class="drag-container" ref="dragContainer">
		<!-- 左侧插槽 -->
		<div class="left-panel" :style="{ width: leftWidth + 'px' }" ref="leftPanel">
			<slot name="left"></slot>
		</div>

		<!-- 拖拽分割线 -->
		<div class="drag-divider" @mousedown="handleMouseDown" :class="{ dragging: isDragging }">
			<div class="drag-handle">
				<div class="drag-line"></div>
				<div class="drag-line"></div>
				<div class="drag-line"></div>
			</div>
		</div>

		<!-- 右侧插槽 -->
		<div class="right-panel" :style="{ width: rightWidth + 'px' }" ref="rightPanel">
			<slot name="right"></slot>
		</div>
	</div>
</template>

<script>
export default {
	name: 'DragDiv',
	props: {
		// 初始左侧宽度
		initialLeftWidth: {
			type: Number,
			default: 300
		},
		// 最小左侧宽度
		minLeftWidth: {
			type: Number,
			default: 100
		},
		// 最小右侧宽度
		minRightWidth: {
			type: Number,
			default: 100
		},
		// 分割线宽度
		dividerWidth: {
			type: Number,
			default: 6
		}
	},
	data() {
		return {
			leftWidth: this.initialLeftWidth,
			rightWidth: 0,
			isDragging: false,
			startX: 0,
			startLeftWidth: 0,
			containerWidth: 0
		};
	},
	mounted() {
		this.calculateSizes();
		window.addEventListener('resize', this.handleResize);
	},
	beforeDestroy() {
		window.removeEventListener('resize', this.handleResize);
		this.removeGlobalListeners();
	},
	methods: {
		/**
		 * 计算初始尺寸
		 */
		calculateSizes() {
			this.$nextTick(() => {
				if (this.$refs.dragContainer) {
					this.containerWidth = this.$refs.dragContainer.clientWidth;
					this.rightWidth = this.containerWidth - this.leftWidth - this.dividerWidth;

					// 确保右侧宽度不小于最小值
					if (this.rightWidth < this.minRightWidth) {
						this.rightWidth = this.minRightWidth;
						this.leftWidth = this.containerWidth - this.rightWidth - this.dividerWidth;
					}
				}
			});
		},

		/**
		 * 处理鼠标按下事件
		 */
		handleMouseDown(event) {
			event.preventDefault();

			this.isDragging = true;
			this.startX = event.clientX;
			this.startLeftWidth = this.leftWidth;
			this.containerWidth = this.$refs.dragContainer.clientWidth;

			// 添加全局事件监听器
			document.addEventListener('mousemove', this.handleMouseMove);
			document.addEventListener('mouseup', this.handleMouseUp);

			// 禁用文本选择
			document.body.style.userSelect = 'none';
			document.body.style.cursor = 'col-resize';

			this.$emit('drag-start', {
				leftWidth: this.leftWidth,
				rightWidth: this.rightWidth
			});
		},

		/**
		 * 处理鼠标移动事件
		 */
		handleMouseMove(event) {
			if (!this.isDragging) return;

			const deltaX = event.clientX - this.startX;
			let newLeftWidth = this.startLeftWidth + deltaX;

			// 限制左侧最小宽度
			newLeftWidth = Math.max(newLeftWidth, this.minLeftWidth);

			// 计算右侧宽度
			let newRightWidth = this.containerWidth - newLeftWidth - this.dividerWidth;

			// 限制右侧最小宽度
			if (newRightWidth < this.minRightWidth) {
				newRightWidth = this.minRightWidth;
				newLeftWidth = this.containerWidth - newRightWidth - this.dividerWidth;
			}

			this.leftWidth = newLeftWidth;
			this.rightWidth = newRightWidth;

			this.$emit('dragging', {
				leftWidth: this.leftWidth,
				rightWidth: this.rightWidth
			});
		},

		/**
		 * 处理鼠标松开事件
		 */
		handleMouseUp() {
			if (!this.isDragging) return;

			this.isDragging = false;
			this.removeGlobalListeners();

			// 恢复默认样式
			document.body.style.userSelect = '';
			document.body.style.cursor = '';

			this.$emit('drag-end', {
				leftWidth: this.leftWidth,
				rightWidth: this.rightWidth
			});
		},

		/**
		 * 移除全局事件监听器
		 */
		removeGlobalListeners() {
			document.removeEventListener('mousemove', this.handleMouseMove);
			document.removeEventListener('mouseup', this.handleMouseUp);
		},

		/**
		 * 处理窗口大小变化
		 */
		handleResize() {
			this.$nextTick(() => {
				if (this.$refs.dragContainer) {
					const newContainerWidth = this.$refs.dragContainer.clientWidth;
					const ratio = this.leftWidth / this.containerWidth;

					this.containerWidth = newContainerWidth;
					this.leftWidth = Math.max(this.minLeftWidth, Math.min(newContainerWidth - this.minRightWidth - this.dividerWidth, newContainerWidth * ratio));
					this.rightWidth = newContainerWidth - this.leftWidth - this.dividerWidth;
				}
			});
		},

		/**
		 * 重置为初始宽度
		 */
		resetWidth() {
			this.leftWidth = this.initialLeftWidth;
			this.calculateSizes();
		},

		/**
		 * 设置左侧宽度
		 */
		setLeftWidth(width) {
			const maxWidth = this.containerWidth - this.minRightWidth - this.dividerWidth;
			this.leftWidth = Math.max(this.minLeftWidth, Math.min(maxWidth, width));
			this.rightWidth = this.containerWidth - this.leftWidth - this.dividerWidth;
		}
	}
};
</script>

<style scoped>
.drag-container {
	display: flex;
	width: 100%;
	height: 100%;
	overflow: hidden;
}

.left-panel,
.right-panel {
	height: 100%;
	overflow: auto;
	flex-shrink: 0;
}

.drag-divider {
	width: 6px;
	height: 100%;
	background-color: #e6e6e6;
	cursor: col-resize;
	display: flex;
	align-items: center;
	justify-content: center;
	position: relative;
	flex-shrink: 0;
	transition: background-color 0.2s ease;
}

.drag-divider:hover {
	background-color: #d0d0d0;
}

.drag-divider.dragging {
	background-color: #409eff;
}

.drag-handle {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	height: 30px;
	gap: 2px;
}

.drag-line {
	width: 2px;
	height: 4px;
	background-color: #999;
	border-radius: 1px;
	transition: background-color 0.2s ease;
}

.drag-divider:hover .drag-line {
	background-color: #666;
}

.drag-divider.dragging .drag-line {
	background-color: #fff;
}

/* 拖拽时的全局样式 */
.drag-divider.dragging ~ * {
	pointer-events: none;
}

/* 防止内容被选中 */
.drag-container * {
	box-sizing: border-box;
}

/* 响应式支持 */
@media (max-width: 768px) {
	.drag-divider {
		width: 8px;
	}

	.drag-handle {
		height: 40px;
	}

	.drag-line {
		width: 3px;
		height: 5px;
	}
}
</style>
