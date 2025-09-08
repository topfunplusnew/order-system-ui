<template>
	<!-- 外层就是 el-table-column，所有属性和事件透传 -->
	<el-table-column v-bind="$attrs" v-on="$listeners">
		<!-- 只有非特殊类型才渲染自定义插槽内容 -->
		<template v-if="!isSpecialType" v-slot="scope">
			<!-- 如果有插槽内容，直接渲染插槽，支持 slot-scope 语法 -->
			<slot v-if="$slots.default || $scopedSlots.default" v-bind="scope" :row="scope.row" :column="scope.column" :$index="scope.$index"></slot>
			<!-- 否则处理文本内容的渲染逻辑 -->
			<template v-else>
				<cell-content
					:scope="scope"
					:prop="currentColumnProp"
					:should-show-popover="shouldShowPopoverByWidth(scope)"
					:cell-text="getCellText(scope)"
					:key="`${scope.$index}_${currentColumnProp}`"
				/>
			</template>
		</template>
		<!-- 特殊类型（selection、index、expand）不渲染插槽，保持 Element UI 原生行为 -->
	</el-table-column>
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

		if (shouldShowPopover) {
			return h('div', { class: 'cell-with-popover' }, [
				h(
					'el-popover',
					{
						props: {
							placement: 'top',
							trigger: 'hover',
							popperClass: 'table-cell-popover',
							content: cellText,
							disabled: !cellText
						}
					},
					[
						h(
							'div',
							{
								slot: 'reference',
								class: 'ellipsis',
								ref: `cellText_${scope.$index}_${prop}`,
								attrs: {
									'data-text': cellText
								}
							},
							cellText
						)
					]
				)
			]);
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

export default {
	name: 'CustomTableColumn',
	inheritAttrs: false, // 避免属性污染根节点
	components: {
		CellContent
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
			resizeObserver: null,
			// 添加防抖控制
			resizeTimer: null,
			isResizing: false
		};
	},

	computed: {
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
				console.warn('Error getting actual text width:', error);
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
}

.cell-with-popover {
	width: 100%;
}
</style>

<style>
/* 全局样式，用于 Popover */
.table-cell-popover {
	max-width: 400px !important;
}

.table-cell-popover .el-popover__content {
	word-break: break-all;
	white-space: pre-wrap;
	max-height: 300px;
	overflow-y: auto;
}
</style>
