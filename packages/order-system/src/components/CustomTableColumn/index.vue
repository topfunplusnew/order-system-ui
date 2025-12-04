<template>
	<!-- 外层就是 u-table-column，所有属性和事件透传 -->
	<u-table-column v-bind="filteredAttrs" v-on="$listeners">
		<!-- 如果有默认插槽内容，在作用域插槽内渲染（支持嵌套 CustomTableColumn 和传递 scope） -->
		<template v-if="hasSlotContent" v-slot="scope">
			<slot-content-wrapper :scope="scope">
				<slot v-bind="scope" :row="scope.row" :column="scope.column" :$index="scope.$index"></slot>
			</slot-content-wrapper>
		</template>
		<!-- 如果没有插槽内容，根据类型决定是否渲染自定义内容 -->
		<template v-else-if="!isSpecialType" v-slot="scope">
			<cell-content :scope="scope" :prop="currentColumnProp" :should-show-popover="true" :cell-text="getCellText(scope)" :key="`${scope.$index}_${currentColumnProp}`" />
		</template>
		<!-- 特殊类型（selection、index、expand）不渲染插槽，保持 Element UI 原生行为 -->
	</u-table-column>
</template>

<script>
// 子组件用于渲染单元格内容，减少主组件的重渲染
const CellContent = {
	name: 'CellContent',
	props: {
		scope: Object,
		prop: String,
		shouldShowPopover: Boolean,
		cellText: String
	},
	render(h) {
		const { scope, prop, shouldShowPopover, cellText } = this;

		// 如果 shouldShowPopover 为 true，或者没有设置判断条件，都显示 tooltip
		// 这里为了保持兼容性，保留 shouldShowPopover 的判断
		// 但如果要所有都显示，可以将条件改为 true
		const shouldShowTooltip = shouldShowPopover !== false; // 默认都显示

		if (shouldShowTooltip) {
			return h(
				'el-tooltip',
				{
					props: {
						content: cellText || '',
						placement: 'top',
						effect: 'dark',
						disabled: false, // 始终启用 tooltip
						openDelay: 1000, // 延迟1秒显示
						hideAfter: 3000, // 延迟3秒关闭
						popperClass: 'table-cell-tooltip'
					}
				},
				[
					h(
						'div',
						{
							slot: 'default',
							class: 'ellipsis',
							ref: `cellText_${scope.$index}_${prop}`,
							attrs: {
								'data-text': cellText
							}
						},
						cellText
					)
				]
			);
		}

		return h(
			'span',
			{
				class: 'cell-text',
				ref: `cellText_${scope.$index}_${prop}`,
				attrs: {
					'data-text': cellText
				}
			},
			cellText
		);
	}
};

// 子组件用于包装 slot 内容，使用 tooltip 显示完整内容
const SlotContentWrapper = {
	name: 'SlotContentWrapper',
	props: {
		scope: Object
	},
	data() {
		return {
			textContent: '' // 缓存文本内容
		};
	},
	computed: {
		// 从父组件获取 mode，如果是 normal 则不显示 tooltip，否则都显示
		shouldShowTooltip() {
			const parent = this.$parent;
			// 只有当 mode 明确设置为 'normal' 时才不显示 tooltip
			// 其他所有情况都显示 tooltip，不需要判断是否超出内容
			if (parent && parent.mode === 'normal') {
				return false;
			}
			// 默认都显示 tooltip
			return true;
		}
	},
	mounted() {
		// 获取 slot 的文本内容
		this.$nextTick(() => {
			this.updateTextContent();
		});
	},
	updated() {
		// 当插槽内容更新时，更新文本内容
		this.$nextTick(() => {
			this.updateTextContent();
		});
	},
	render(h) {
		const slotContent = this.$slots.default;

		// 只要 shouldShowTooltip 为 true，就显示 tooltip，不判断是否超出内容
		if (this.shouldShowTooltip) {
			return h(
				'el-tooltip',
				{
					props: {
						content: this.textContent || '', // 即使没有文本内容也显示 tooltip
						placement: 'top',
						effect: 'dark',
						openDelay: 1000, // 延迟1秒显示
						hideAfter: 3000, // 延迟3秒关闭
						popperClass: 'table-cell-tooltip table-cell-tooltip-slot',
						disabled: false // 始终启用 tooltip
					}
				},
				[
					h(
						'div',
						{
							slot: 'default',
							class: 'ellipsis slot-content-wrapper',
							ref: 'slotWrapper'
						},
						slotContent
					)
				]
			);
		}

		return h(
			'div',
			{
				class: 'slot-content-wrapper',
				ref: 'slotWrapper'
			},
			slotContent
		);
	},
	methods: {
		// 检测 VNode 中是否包含交互式元素
		hasInteractiveElements(vnodes) {
			if (!vnodes || !Array.isArray(vnodes)) {
				return false;
			}

			const interactiveComponents = ['el-button', 'el-dropdown', 'el-select', 'el-input', 'el-switch', 'el-checkbox', 'el-radio', 'el-date-picker', 'el-time-picker', 'el-cascader', 'el-upload', 'el-link', 'el-tag', 'button', 'input', 'select', 'a'];

			const checkVNode = vnode => {
				if (!vnode) return false;

				// 检查组件标签
				if (vnode.tag) {
					// 检查是否是交互式组件
					if (
						interactiveComponents.some(comp => {
							// 处理组件标签，可能是 'el-button' 或 'ElButton'
							const tagLower = vnode.tag.toLowerCase();
							const compLower = comp.toLowerCase();
							return tagLower === compLower || tagLower.includes(compLower);
						})
					) {
						return true;
					}

					// 检查组件名（对于 Vue 组件）
					if (vnode.componentOptions) {
						const componentName = vnode.componentOptions.tag || (vnode.componentOptions.Ctor && vnode.componentOptions.Ctor.options && vnode.componentOptions.Ctor.options.name);
						if (componentName) {
							if (
								interactiveComponents.some(comp => {
									const nameLower = componentName.toLowerCase();
									const compLower = comp.toLowerCase();
									return nameLower === compLower || nameLower.includes(compLower);
								})
							) {
								return true;
							}
						}
					}
				}

				// 递归检查子节点
				if (vnode.children && Array.isArray(vnode.children)) {
					for (let i = 0; i < vnode.children.length; i++) {
						if (checkVNode(vnode.children[i])) {
							return true;
						}
					}
				}

				// 检查组件选项的子节点
				if (vnode.componentOptions && vnode.componentOptions.children) {
					for (let i = 0; i < vnode.componentOptions.children.length; i++) {
						if (checkVNode(vnode.componentOptions.children[i])) {
							return true;
						}
					}
				}

				return false;
			};

			for (let i = 0; i < vnodes.length; i++) {
				if (checkVNode(vnodes[i])) {
					return true;
				}
			}

			return false;
		},
		updateTextContent() {
			// 尝试从 DOM 获取文本内容
			if (this.$refs.slotWrapper) {
				this.textContent = this.$refs.slotWrapper.textContent || this.$refs.slotWrapper.innerText || '';
			} else {
				this.textContent = '';
			}
		},
		getSlotTextContent() {
			// 兼容方法，返回缓存的文本内容
			return this.textContent || '';
		}
	}
};

export default {
	name: 'CustomTableColumn',
	inheritAttrs: false, // 避免属性污染根节点
	components: {
		CellContent,
		SlotContentWrapper
	},
	props: {
		prop: {
			type: String,
			required: false,
			default: ''
		},
		mode: {
			type: String,
			default: null, // normal | tooltip | popover | null(自动判断)
			validator: v => !v || ['normal', 'tooltip', 'popover'].includes(v)
		},
		autoThreshold: {
			type: Number,
			default: 10 // 自动模式下的长度阈值（降低阈值，让更多内容显示 popover）
		}
	},

	data() {
		return {
			textWidthCache: {}, // 缓存文本宽度计算结果
			columnWidthCache: {}, // 缓存列宽度
			slotWidthCache: {}, // 缓存 slot 元素宽度
			resizeObserver: null,
			// 添加防抖控制
			resizeTimer: null,
			isResizing: false,
			columnIndex: null, // 列索引缓存
			popoverDecisionCache: {}, // Popover 显示决策缓存
			measureElement: null // 用于测量文本宽度的临时元素
		};
	},

	computed: {
		// 判断是否有插槽内容（支持嵌套）
		hasSlotContent() {
			return !!(this.$slots.default || this.$scopedSlots.default);
		},

		// 判断是否是特殊类型列（selection、index、expand）
		isSpecialType() {
			const type = this.$attrs.type;
			return ['selection', 'index', 'expand'].includes(type);
		},

		// 缓存当前列的属性，避免重复计算
		currentColumnProp() {
			return this.prop;
		},

		// 缓存表格实例引用
		tableInstance() {
			return this.$parent;
		},

		// 过滤后的属性，移除 show-overflow-tooltip 避免 Element UI 默认提示
		// 同时显式包含 prop，因为它被声明为 props，不会出现在 $attrs 中
		filteredAttrs() {
			const { 'show-overflow-tooltip': showOverflowTooltip, ...otherAttrs } = this.$attrs;
			return {
				...otherAttrs,
				prop: this.prop // 显式添加 prop，确保传递给 u-table-column
			};
		},

		// 检查是否传递了 show-overflow-tooltip 属性
		hasOverflowTooltip() {
			return Object.prototype.hasOwnProperty.call(this.$attrs, 'show-overflow-tooltip');
		},

		// 获取传入的列宽度（从 props 或 attrs）
		columnWidth() {
			// 优先使用 width prop，如果没有则从 $attrs 获取
			const width = this.$attrs.width;
			if (!width) return null;

			// 如果 width 是数字，直接返回
			if (typeof width === 'number') {
				return width;
			}

			// 如果 width 是字符串（如 "100px"），提取数字部分
			if (typeof width === 'string') {
				const match = width.match(/(\d+)/);
				if (match) {
					return parseInt(match[1], 10);
				}
			}

			return null;
		}
	},

	watch: {
		// 监听 prop 变化，清理相关缓存
		currentColumnProp(newProp, oldProp) {
			if (newProp !== oldProp) {
				// 清理旧的缓存
				if (oldProp) {
					delete this.columnWidthCache[oldProp];
				}
				this.columnIndex = null;
				this.popoverDecisionCache = {};
			}
		},

		// 监听模式变化
		mode() {
			this.popoverDecisionCache = {};
		}
	},
	mounted() {
		this.initResizeObserver();
	},

	beforeDestroy() {
		// 清理 ResizeObserver
		if (this.resizeObserver) {
			this.resizeObserver.disconnect();
			this.resizeObserver = null;
		}

		// 清理定时器
		if (this.resizeTimer) {
			clearTimeout(this.resizeTimer);
			this.resizeTimer = null;
		}

		// 清理缓存
		this.clearCaches();

		// 清理测量元素
		if (this.measureElement && this.measureElement.parentNode) {
			this.measureElement.parentNode.removeChild(this.measureElement);
			this.measureElement = null;
		}
	},

	methods: {
		// 获取单元格文本内容
		getCellText(scope) {
			if (!this.prop) {
				return '';
			}
			const text = scope.row[this.prop] || '';
			// 确保返回的是字符串类型
			return String(text);
		},

		// 计算文本宽度 - 使用DOM元素测量
		getTextWidth(text, scope) {
			// 快速返回空文本
			if (!text || text.length === 0) return 0;

			const cacheKey = `${this.currentColumnProp}_${scope.$index}_${text}`;
			if (this.textWidthCache[cacheKey]) {
				return this.textWidthCache[cacheKey];
			}

			try {
				// 方法1: 直接从DOM获取实际文本宽度（最准确）
				const actualWidth = this.getActualTextWidth(scope);
				if (actualWidth !== null) {
					this.textWidthCache[cacheKey] = actualWidth;
					return actualWidth;
				}

				// 方法2: 使用临时元素测量（次优选择）
				const width = this.measureTextWithElement(text);

				// 限制缓存大小，避免内存泄漏
				if (Object.keys(this.textWidthCache).length > 1000) {
					// 清理一半的缓存
					const keys = Object.keys(this.textWidthCache);
					const half = Math.floor(keys.length / 2);
					for (let i = 0; i < half; i++) {
						delete this.textWidthCache[keys[i]];
					}
				}

				this.textWidthCache[cacheKey] = width;
				return width;
			} catch (error) {
				console.warn('Failed to measure text width:', error);
				// 回退到简单的字符长度估算
				return text.length * 8; // 大约每个字符8px
			}
		},

		// 使用DOM元素测量文本宽度
		measureTextWithElement(text) {
			try {
				// 优先从表格中找到样式参考
				const tableElement = this.tableInstance.$el;
				let referenceStyles = {
					fontSize: '14px',
					fontFamily: 'Arial, sans-serif',
					fontWeight: 'normal'
				};

				if (tableElement) {
					const cellElement = tableElement.querySelector('.el-table__body td');
					if (cellElement) {
						const computedStyle = window.getComputedStyle(cellElement);
						referenceStyles = {
							fontSize: computedStyle.fontSize || '14px',
							fontFamily: computedStyle.fontFamily || 'Arial, sans-serif',
							fontWeight: computedStyle.fontWeight || 'normal'
						};
					}
				}

				// 创建测量用的临时元素
				if (!this.measureElement) {
					this.measureElement = document.createElement('span');
					this.measureElement.style.cssText = `
						position: absolute;
						top: -9999px;
						left: -9999px;
						visibility: hidden;
						white-space: nowrap;
						padding: 0;
						margin: 0;
						border: none;
					`;
					document.body.appendChild(this.measureElement);
				}

				// 应用样式并测量
				this.measureElement.style.fontSize = referenceStyles.fontSize;
				this.measureElement.style.fontFamily = referenceStyles.fontFamily;
				this.measureElement.style.fontWeight = referenceStyles.fontWeight;
				this.measureElement.textContent = text;

				const width = this.measureElement.offsetWidth;
				return width;
			} catch (error) {
				console.warn('Error measuring text width:', error);
				return text.length * 8; // 回退估算
			}
		},

		// 直接从DOM获取单元格文本宽度
		getActualTextWidth(scope) {
			try {
				const table = this.tableInstance.$el;
				if (!table) return null;

				// 查找当前行和列的单元格
				const rows = table.querySelectorAll('.el-table__body tr');
				const row = rows[scope.$index];
				if (!row) return null;

				// 获取列索引
				if (this.columnIndex === null || this.columnIndex === undefined) {
					const columns = this.tableInstance.columns || [];
					for (let i = 0; i < columns.length; i++) {
						if (columns[i].property === this.currentColumnProp) {
							this.columnIndex = i;
							break;
						}
					}
				}

				if (this.columnIndex >= 0) {
					const cell = row.children[this.columnIndex];
					if (cell) {
						// 获取单元格内容的实际宽度
						const cellContent = cell.querySelector('.cell-text, .ellipsis') || cell;
						const scrollWidth = cellContent.scrollWidth;
						const offsetWidth = cellContent.offsetWidth;

						// 返回内容的实际宽度
						return Math.max(scrollWidth, offsetWidth);
					}
				}

				return null;
			} catch (error) {
				return null;
			}
		}, // 获取列的实际宽度 - 优化版本
		getColumnWidth(scope) {
			// 如果正在调整大小，使用缓存值避免频繁计算
			if (this.isResizing && this.columnWidthCache[this.currentColumnProp]) {
				return this.columnWidthCache[this.currentColumnProp];
			}

			// 检查缓存
			if (this.columnWidthCache[this.currentColumnProp]) {
				return this.columnWidthCache[this.currentColumnProp];
			}

			try {
				// 使用缓存的表格实例
				const table = this.tableInstance.$el;
				if (!table) return null;

				// 优化：直接查找当前列的 header cell
				const headerRow = table.querySelector('.el-table__header tr');
				if (!headerRow) return null;

				const headerCells = headerRow.children;

				// 缓存列索引查找结果
				if (!this.columnIndex) {
					const columns = this.tableInstance.columns || [];
					for (let i = 0; i < columns.length; i++) {
						if (columns[i].property === this.currentColumnProp) {
							this.columnIndex = i;
							break;
						}
					}
				}

				if (this.columnIndex >= 0 && headerCells[this.columnIndex]) {
					const cellRect = headerCells[this.columnIndex].getBoundingClientRect();
					// 减去内边距（大约 20px）
					const cellWidth = cellRect.width - 20;

					// 缓存结果
					this.columnWidthCache[this.currentColumnProp] = cellWidth;
					return cellWidth;
				}

				return null;
			} catch (error) {
				return null;
			}
		},

		// 基于实际宽度判断是否显示 popover - 优化版本
		shouldShowPopoverByWidth(scope) {
			const text = this.getCellText(scope);

			// 如果没有文本，不显示 popover
			if (!text) return false;

			// 如果强制指定了 mode
			if (this.mode === 'tooltip' || this.mode === 'popover') {
				return true;
			}

			// 如果父组件传递了 show-overflow-tooltip，也启用我们的自定义 popover
			if (this.hasOverflowTooltip) {
				// 使用实际宽度计算，而不是简单的字符长度
				const columnWidth = this.getColumnWidth(scope);
				if (columnWidth !== null) {
					const textWidth = this.getTextWidth(text, scope);
					return textWidth > columnWidth;
				} else {
					// 如果获取不到列宽，回退到字符长度判断
					const textStr = String(text);
					return textStr.length > this.autoThreshold;
				}
			}

			// 创建缓存键
			const cacheKey = `${this.currentColumnProp}_${scope.$index}_${text}`;
			if (this.popoverDecisionCache && this.popoverDecisionCache[cacheKey] !== undefined) {
				return this.popoverDecisionCache[cacheKey];
			}

			// 初始化缓存
			if (!this.popoverDecisionCache) {
				this.popoverDecisionCache = {};
			}

			try {
				// 获取列宽度
				const columnWidth = this.getColumnWidth(scope);
				if (columnWidth === null) {
					// 如果获取不到列宽，回退到字符长度判断
					const textStr = String(text);
					const shouldShowByLength = textStr.length > this.autoThreshold;
					this.popoverDecisionCache[cacheKey] = shouldShowByLength;
					return shouldShowByLength;
				}

				// 计算文本宽度
				const textWidth = this.getTextWidth(text, scope);
				const shouldShow = textWidth > columnWidth;

				// 缓存决策结果
				this.popoverDecisionCache[cacheKey] = shouldShow;
				return shouldShow;
			} catch (error) {
				const textStr = String(text);
				const fallbackResult = textStr.length > this.autoThreshold;
				this.popoverDecisionCache[cacheKey] = fallbackResult;
				return fallbackResult;
			}
		},

		// 测量 slot 元素的宽度
		measureSlotWidth(scope, slotElement) {
			if (!slotElement) return 0;

			const cacheKey = `slot_${scope.$index}`;

			try {
				// 获取元素的 scrollWidth（内容实际宽度）和 offsetWidth（可见宽度）
				const scrollWidth = slotElement.scrollWidth || 0;
				const offsetWidth = slotElement.offsetWidth || 0;
				const actualWidth = Math.max(scrollWidth, offsetWidth);

				// 缓存结果
				this.slotWidthCache[cacheKey] = actualWidth;
				return actualWidth;
			} catch (error) {
				console.warn('Failed to measure slot width:', error);
				return 0;
			}
		},

		// 初始化ResizeObserver监听列宽变化 - 优化版本
		initResizeObserver() {
			if (typeof ResizeObserver !== 'undefined') {
				this.resizeObserver = new ResizeObserver(this.handleResize);

				// 监听表格元素
				this.$nextTick(() => {
					const table = this.tableInstance.$el;
					if (table) {
						this.resizeObserver.observe(table);
					}
				});
			}
		},

		// 防抖处理的 resize 回调
		handleResize(entries) {
			// 设置调整大小状态
			this.isResizing = true;

			// 清除之前的定时器
			if (this.resizeTimer) {
				clearTimeout(this.resizeTimer);
			}

			// 立即清空缓存
			this.columnWidthCache = {};
			this.slotWidthCache = {};
			this.popoverDecisionCache = {};
			this.columnIndex = null; // 重置列索引缓存

			// 防抖更新，避免频繁重渲染
			this.resizeTimer = setTimeout(() => {
				this.isResizing = false;
				this.$forceUpdate();
			}, 100); // 100ms 防抖
		},

		// 清理缓存的方法
		clearCaches() {
			this.textWidthCache = {};
			this.columnWidthCache = {};
			this.slotWidthCache = {};
			this.popoverDecisionCache = {};
			this.columnIndex = null;
		},

		// 兼容旧的方法名（保持向后兼容）
		shouldShowPopover(scope) {
			return this.shouldShowPopoverByWidth(scope);
		}
	}
};
</script>

<style scoped>
.ellipsis {
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
	cursor: pointer;
	max-width: 100%;
	display: inline-block;
}

.cell-text {
	white-space: nowrap;
	display: inline-block;
	max-width: 100%;
	overflow: hidden;
	text-overflow: ellipsis;
}

.cell-with-popover {
	width: 100%;
}
</style>

<style>
/* 全局样式，用于 Tooltip */
.table-cell-tooltip {
	max-width: 500px !important;
	pointer-events: auto !important; /* 允许 tooltip 接收鼠标事件 */
}

.table-cell-tooltip .el-tooltip__popper__inner {
	word-break: break-all;
	white-space: pre-wrap;
	max-height: 300px;
	overflow-y: auto;
	user-select: text !important; /* 允许选中文本进行复制 */
	cursor: text !important;
	padding: 8px 12px !important;
	line-height: 1.5 !important;
}

/* 确保使用 CustomTableColumn 的列始终显示省略样式，而不是 Element UI 的默认 tooltip */
.el-table .cell {
	overflow: hidden !important;
	text-overflow: ellipsis !important;
	white-space: nowrap !important;
}

/* 强制覆盖 Element UI 的默认样式 */
.el-table td .cell,
.el-table th .cell {
	overflow: hidden !important;
	text-overflow: ellipsis !important;
	white-space: nowrap !important;
	max-width: 100% !important;
}

/* 确保我们的自定义单元格内容也有省略样式 */
.el-table td .cell .cell-text,
.el-table td .cell .ellipsis {
	overflow: hidden !important;
	text-overflow: ellipsis !important;
	white-space: nowrap !important;
	max-width: 100% !important;
	display: block !important;
}
</style>
