/**
 * Element-UI 表格固定列高度调整工具
 * 解决因横向滚动条高度变化导致的固定列与非固定列错行问题
 */

class TableFixedColumnAdjustment {
	constructor() {
		this.adjustedTables = new WeakSet();
		this.resizeObserver = null;
		this.mutationObserver = null;
		this.scrollbarHeight = 15; // 默认滚动条高度
		this.init();
	}

	/**
	 * 初始化监听器
	 */
	init() {
		// DOM加载完成后执行
		if (document.readyState === 'loading') {
			document.addEventListener('DOMContentLoaded', () => this.startObserving());
		} else {
			this.startObserving();
		}
	}

	/**
	 * 开始监听DOM变化
	 */
	startObserving() {
		// 监听DOM节点变化
		this.mutationObserver = new MutationObserver(mutations => {
			mutations.forEach(mutation => {
				if (mutation.type === 'childList') {
					mutation.addedNodes.forEach(node => {
						if (node.nodeType === Node.ELEMENT_NODE) {
							this.checkAndAdjustTables(node);
						}
					});
				}
			});
		});

		this.mutationObserver.observe(document.body, {
			childList: true,
			subtree: true
		});

		// 监听窗口大小变化
		if (window.ResizeObserver) {
			this.resizeObserver = new ResizeObserver(() => {
				this.adjustAllTables();
			});
			this.resizeObserver.observe(document.body);
		} else {
			window.addEventListener('resize', () => {
				this.adjustAllTables();
			});
		}

		// 初始调整所有表格
		this.adjustAllTables();
	}

	/**
	 * 检查并调整表格
	 * @param {Element} container - 容器元素
	 */
	checkAndAdjustTables(container = document) {
		const tables = container.querySelectorAll('.el-table');
		tables.forEach(table => this.adjustTable(table));
	}

	/**
	 * 调整所有表格
	 */
	adjustAllTables() {
		this.checkAndAdjustTables();
	}

	/**
	 * 调整单个表格的固定列
	 * @param {Element} table - 表格元素
	 */
	adjustTable(table) {
		if (!table || this.adjustedTables.has(table)) {
			return;
		}

		try {
			const bodyWrapper = table.querySelector('.el-table__body-wrapper');
			if (!bodyWrapper) return;

			// 检测实际滚动条高度
			const actualScrollbarHeight = this.getScrollbarHeight(bodyWrapper);

			// 调整左侧固定列
			const leftFixed = table.querySelector('.el-table__fixed');
			if (leftFixed) {
				this.adjustFixedColumn(leftFixed, actualScrollbarHeight);
			}

			// 调整右侧固定列
			const rightFixed = table.querySelector('.el-table__fixed-right');
			if (rightFixed) {
				this.adjustFixedColumn(rightFixed, actualScrollbarHeight);
			}

			// 添加滚动监听
			this.addScrollListener(table, bodyWrapper);

			// 标记已调整
			this.adjustedTables.add(table);
		} catch (error) {
			console.warn('表格固定列调整失败:', error);
		}
	}

	/**
	 * 获取滚动条实际高度
	 * @param {Element} element - 元素
	 * @returns {number} 滚动条高度
	 */
	getScrollbarHeight(element) {
		if (!element) return this.scrollbarHeight;

		const hasHorizontalScrollbar = element.scrollWidth > element.clientWidth;
		if (hasHorizontalScrollbar) {
			const computedStyle = window.getComputedStyle(element);
			// 尝试从CSS获取滚动条高度，默认使用设定值
			return this.scrollbarHeight;
		}
		return 0;
	}

	/**
	 * 调整固定列高度
	 * @param {Element} fixedColumn - 固定列元素
	 * @param {number} scrollbarHeight - 滚动条高度
	 */
	adjustFixedColumn(fixedColumn, scrollbarHeight) {
		if (!fixedColumn) return;

		const fixedBodyWrapper = fixedColumn.querySelector('.el-table__fixed-body-wrapper');
		const fixedFooterWrapper = fixedColumn.querySelector('.el-table__fixed-footer-wrapper');

		if (fixedBodyWrapper) {
			// 设置底部边距来补偿滚动条高度
			fixedBodyWrapper.style.paddingBottom = `${scrollbarHeight}px`;

			// 调整最大高度以保持对齐
			const parentTable = fixedColumn.closest('.el-table');
			const mainBodyWrapper = parentTable.querySelector('.el-table__body-wrapper');

			if (mainBodyWrapper) {
				const mainHeight = mainBodyWrapper.offsetHeight;
				fixedBodyWrapper.style.maxHeight = `${mainHeight}px`;
			}
		}

		if (fixedFooterWrapper) {
			fixedFooterWrapper.style.paddingBottom = `${scrollbarHeight}px`;
		}
	}

	/**
	 * 添加滚动监听
	 * @param {Element} table - 表格元素
	 * @param {Element} bodyWrapper - 主体包装器
	 */
	addScrollListener(table, bodyWrapper) {
		if (!bodyWrapper) return;

		const scrollHandler = () => {
			// 滚动时重新调整固定列
			setTimeout(() => {
				this.adjustTable(table);
			}, 0);
		};

		// 避免重复添加监听器
		if (!bodyWrapper._fixedColumnScrollListener) {
			bodyWrapper.addEventListener('scroll', scrollHandler);
			bodyWrapper._fixedColumnScrollListener = scrollHandler;
		}
	}

	/**
	 * 手动调整指定表格
	 * @param {string|Element} selector - 表格选择器或元素
	 * @param {number} offset - 偏移量（废弃参数，保持兼容性）
	 */
	elementFixedTableAdjustment(selector, offset = null) {
		let tables = [];

		if (typeof selector === 'string') {
			tables = Array.from(document.querySelectorAll(selector));
		} else if (selector instanceof Element) {
			tables = [selector];
		} else {
			// 如果没有指定选择器，调整所有表格
			tables = Array.from(document.querySelectorAll('.el-table'));
		}

		tables.forEach(table => {
			// 移除已调整标记，强制重新调整
			this.adjustedTables.delete(table);
			this.adjustTable(table);
		});
	}

	/**
	 * 销毁监听器
	 */
	destroy() {
		if (this.mutationObserver) {
			this.mutationObserver.disconnect();
			this.mutationObserver = null;
		}

		if (this.resizeObserver) {
			this.resizeObserver.disconnect();
			this.resizeObserver = null;
		}

		// 移除所有滚动监听器
		document.querySelectorAll('.el-table__body-wrapper').forEach(wrapper => {
			if (wrapper._fixedColumnScrollListener) {
				wrapper.removeEventListener('scroll', wrapper._fixedColumnScrollListener);
				delete wrapper._fixedColumnScrollListener;
			}
		});

		this.adjustedTables = new WeakSet();
	}
}

// 创建全局实例
const tableAdjustment = new TableFixedColumnAdjustment();

// 导出供外部使用的函数（保持原有接口兼容性）
window.elementFixedTableAdjustment = function (offset = 15) {
	// 更新滚动条高度设置
	tableAdjustment.scrollbarHeight = offset;
	// 调整所有表格
	tableAdjustment.elementFixedTableAdjustment();
};

// 导出类和实例
export { TableFixedColumnAdjustment, tableAdjustment };
export default tableAdjustment;
