<template>
	<div class="triple-drag-container" ref="container">
		<!-- 左侧面板 -->
		<div class="panel left" :style="{ width: leftWidth + 'px' }" ref="leftPanel">
			<slot name="left"></slot>
		</div>

		<!-- 左中分割线 -->
		<div class="drag-divider" :class="{ dragging: isDraggingLeft }" @mousedown="onMouseDown('left', $event)">
			<div class="drag-handle">
				<div class="drag-line"></div>
				<div class="drag-line"></div>
				<div class="drag-line"></div>
			</div>
		</div>

		<!-- 中间面板 -->
		<div class="panel middle" :style="{ width: middleWidth + 'px' }" ref="middlePanel">
			<slot name="middle"></slot>
		</div>

		<!-- 右中分割线 -->
		<div class="drag-divider" :class="{ dragging: isDraggingRight }" @mousedown="onMouseDown('right', $event)">
			<div class="drag-handle">
				<div class="drag-line"></div>
				<div class="drag-line"></div>
				<div class="drag-line"></div>
			</div>
		</div>

		<!-- 右侧面板 -->
		<div class="panel right" :style="{ width: rightWidth + 'px' }" ref="rightPanel">
			<slot name="right"></slot>
		</div>
	</div>
</template>

<script>
export default {
	name: 'TripleDragDiv',
	props: {
		// 初始宽度（像素）
		initialLeftWidth: { type: Number, default: 320 },
		initialMiddleWidth: { type: Number, default: 520 },
		// 最小宽度（像素）
		minLeftWidth: { type: Number, default: 160 },
		minMiddleWidth: { type: Number, default: 240 },
		minRightWidth: { type: Number, default: 240 },
		// 分割线宽度
		dividerWidth: { type: Number, default: 6 }
	},
	data() {
		return {
			containerWidth: 0,
			leftWidth: this.initialLeftWidth,
			middleWidth: this.initialMiddleWidth,
			rightWidth: 0,
			// 拖拽状态
			isDraggingLeft: false,
			isDraggingRight: false,
			startX: 0,
			startLeftWidth: 0,
			startMiddleWidth: 0,
			startRightWidth: 0
		};
	},
	mounted() {
		this.calculateInitialWidths();
		window.addEventListener('resize', this.onResize);
	},
	beforeDestroy() {
		window.removeEventListener('resize', this.onResize);
		this.removeGlobalListeners();
	},
	methods: {
		calculateInitialWidths() {
			this.$nextTick(() => {
				if (!this.$refs.container) return;
				this.containerWidth = this.$refs.container.clientWidth;
				const twoDividers = this.dividerWidth * 2;
				let remaining = this.containerWidth - this.leftWidth - this.middleWidth - twoDividers;
				// 保证右侧最小宽
				if (remaining < this.minRightWidth) {
					remaining = this.minRightWidth;
					// 压缩中间面板
					this.middleWidth = Math.max(this.minMiddleWidth, this.containerWidth - this.leftWidth - remaining - twoDividers);
				}
				this.rightWidth = remaining;
			});
		},

		onMouseDown(which, event) {
			event.preventDefault();
			this.startX = event.clientX;
			this.startLeftWidth = this.leftWidth;
			this.startMiddleWidth = this.middleWidth;
			this.startRightWidth = this.rightWidth;
			if (which === 'left') this.isDraggingLeft = true;
			if (which === 'right') this.isDraggingRight = true;
			document.addEventListener('mousemove', this.onMouseMove);
			document.addEventListener('mouseup', this.onMouseUp);
			document.body.style.userSelect = 'none';
			document.body.style.cursor = 'col-resize';
			this.$emit('drag-start', this.snapshot());
		},

		onMouseMove(event) {
			if (!this.isDraggingLeft && !this.isDraggingRight) return;
			const deltaX = event.clientX - this.startX;
			const twoDividers = this.dividerWidth * 2;

			if (this.isDraggingLeft) {
				// 调整左、中两栏
				let newLeft = this.startLeftWidth + deltaX;
				newLeft = Math.max(this.minLeftWidth, newLeft);
				let newMiddle = this.containerWidth - newLeft - this.rightWidth - twoDividers;
				if (newMiddle < this.minMiddleWidth) {
					newMiddle = this.minMiddleWidth;
					newLeft = this.containerWidth - newMiddle - this.rightWidth - twoDividers;
				}
				this.leftWidth = newLeft;
				this.middleWidth = newMiddle;
			}

			if (this.isDraggingRight) {
				// 调整中、右两栏
				let newMiddle = this.startMiddleWidth + deltaX;
				newMiddle = Math.max(this.minMiddleWidth, newMiddle);
				let newRight = this.containerWidth - this.leftWidth - newMiddle - twoDividers;
				if (newRight < this.minRightWidth) {
					newRight = this.minRightWidth;
					newMiddle = this.containerWidth - this.leftWidth - newRight - twoDividers;
				}
				this.middleWidth = newMiddle;
				this.rightWidth = newRight;
			}

			this.$emit('dragging', this.snapshot());
		},

		onMouseUp() {
			if (!this.isDraggingLeft && !this.isDraggingRight) return;
			this.isDraggingLeft = false;
			this.isDraggingRight = false;
			this.removeGlobalListeners();
			document.body.style.userSelect = '';
			document.body.style.cursor = '';
			this.$emit('drag-end', this.snapshot());
		},

		removeGlobalListeners() {
			document.removeEventListener('mousemove', this.onMouseMove);
			document.removeEventListener('mouseup', this.onMouseUp);
		},

		onResize() {
			this.$nextTick(() => {
				if (!this.$refs.container) return;
				const oldWidth = this.containerWidth || 1;
				const newWidth = (this.containerWidth = this.$refs.container.clientWidth);
				const contentWidth = newWidth - this.dividerWidth * 2;
				// 按比例调整三栏宽度
				const totalPanels = Math.max(1, oldWidth - this.dividerWidth * 2);
				const ratioLeft = this.leftWidth / totalPanels;
				const ratioMiddle = this.middleWidth / totalPanels;
				let newLeft = Math.max(this.minLeftWidth, Math.round(contentWidth * ratioLeft));
				let newMiddle = Math.max(this.minMiddleWidth, Math.round(contentWidth * ratioMiddle));
				let newRight = contentWidth - newLeft - newMiddle;
				if (newRight < this.minRightWidth) {
					newRight = this.minRightWidth;
					// 压缩 middle 优先
					newMiddle = Math.max(this.minMiddleWidth, contentWidth - newLeft - newRight);
					if (newLeft + newMiddle + newRight > contentWidth) {
						newLeft = Math.max(this.minLeftWidth, contentWidth - newMiddle - newRight);
					}
				}
				this.leftWidth = newLeft;
				this.middleWidth = newMiddle;
				this.rightWidth = newRight;
			});
		},

		snapshot() {
			return {
				leftWidth: this.leftWidth,
				middleWidth: this.middleWidth,
				rightWidth: this.rightWidth
			};
		},

		// 外部可调用的设置方法
		setWidths({ left, middle, right }) {
			const twoDividers = this.dividerWidth * 2;
			const total = this.$refs.container?.clientWidth || this.containerWidth;
			if (!total) return;
			let l = typeof left === 'number' ? left : this.leftWidth;
			let m = typeof middle === 'number' ? middle : this.middleWidth;
			let r = typeof right === 'number' ? right : total - l - m - twoDividers;
			// 约束
			l = Math.max(this.minLeftWidth, l);
			m = Math.max(this.minMiddleWidth, m);
			r = Math.max(this.minRightWidth, r);
			if (l + m + r + twoDividers > total) {
				// 优先压缩 middle，再压缩 left
				const over = l + m + r + twoDividers - total;
				const reduceMiddle = Math.min(over, m - this.minMiddleWidth);
				m -= reduceMiddle;
				const remain = over - reduceMiddle;
				if (remain > 0) l = Math.max(this.minLeftWidth, l - remain);
			}
			this.leftWidth = l;
			this.middleWidth = m;
			this.rightWidth = total - l - m - twoDividers;
		}
	}
};
</script>

<style scoped>
.triple-drag-container {
	display: flex;
	width: 100%;
	height: 100%;
	overflow: hidden;
}

.panel {
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

.drag-divider:hover .drag-line { background-color: #666; }
.drag-divider.dragging .drag-line { background-color: #fff; }

/* 避免内容被选中 */
.triple-drag-container * { box-sizing: border-box; }

/* 响应式 */
@media (max-width: 768px) {
	.drag-divider { width: 8px; }
	.drag-handle { height: 40px; }
	.drag-line { width: 3px; height: 5px; }
}
</style>


