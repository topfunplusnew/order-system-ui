/**
 * v-auto-table-width 表格内容宽度自适应指令
 * 自动根据表格内容调整列宽，使表格列宽适应内容
 * 
 * 使用方法：
 * <el-table v-auto-table-width>
 *   <el-table-column ... />
 * </el-table>
 * 
 * 或者带参数：
 * <el-table v-auto-table-width="{ minWidth: 80, maxWidth: 300, padding: 20 }">
 *   <el-table-column ... />
 * </el-table>
 */

export default {
	inserted(el, binding) {
		const options = binding.value || {};
		const {
			minWidth = 80,      // 最小列宽
			maxWidth = 500,     // 最大列宽
			padding = 20,       // 列宽额外padding
			excludeColumns = [], // 排除的列索引数组，这些列不参与自适应
			delay = 100         // 延迟执行时间（毫秒）
		} = options;

		// 防抖函数
		let adjustTimer = null;
		const adjustWidth = () => {
			if (adjustTimer) {
				clearTimeout(adjustTimer);
			}
			adjustTimer = setTimeout(() => {
				adjustTableWidth(el, { minWidth, maxWidth, padding, excludeColumns });
			}, delay);
		};

		// 等待DOM渲染完成
		adjustWidth();

		// 监听数据变化，重新计算宽度
		const observer = new MutationObserver(() => {
			adjustWidth();
		});

		observer.observe(el, {
			childList: true,
			subtree: true,
			attributes: true,
			attributeFilter: ['style', 'class']
		});

		// 保存observer到元素上，以便在unbind时清理
		el._autoTableWidthObserver = observer;
		el._autoTableWidthTimer = adjustTimer;

		// 监听窗口大小变化
		const resizeHandler = () => {
			adjustWidth();
		};

		window.addEventListener('resize', resizeHandler);
		el._autoTableWidthResizeHandler = resizeHandler;

		// 监听Vue组件数据更新
		const vueInstance = el.__vue__;
		if (vueInstance) {
			const originalUpdate = vueInstance.$forceUpdate || vueInstance.$nextTick;
			if (vueInstance.$forceUpdate) {
				const forceUpdate = vueInstance.$forceUpdate.bind(vueInstance);
				vueInstance.$forceUpdate = function() {
					forceUpdate();
					adjustWidth();
				};
			}
		}
	},

	update(el, binding) {
		// 当绑定值更新时，重新计算
		const options = binding.value || {};
		const {
			minWidth = 80,
			maxWidth = 500,
			padding = 20,
			excludeColumns = [],
			delay = 100
		} = options;

		if (el._autoTableWidthTimer) {
			clearTimeout(el._autoTableWidthTimer);
		}

		el._autoTableWidthTimer = setTimeout(() => {
			adjustTableWidth(el, { minWidth, maxWidth, padding, excludeColumns });
		}, delay);
	},

	unbind(el) {
		// 清理timer
		if (el._autoTableWidthTimer) {
			clearTimeout(el._autoTableWidthTimer);
			delete el._autoTableWidthTimer;
		}

		// 清理observer
		if (el._autoTableWidthObserver) {
			el._autoTableWidthObserver.disconnect();
			delete el._autoTableWidthObserver;
		}

		// 清理resize监听
		if (el._autoTableWidthResizeHandler) {
			window.removeEventListener('resize', el._autoTableWidthResizeHandler);
			delete el._autoTableWidthResizeHandler;
		}
	}
};

/**
 * 调整表格列宽
 * @param {HTMLElement} tableEl - 表格元素
 * @param {Object} options - 配置选项
 */
function adjustTableWidth(tableEl, options) {
	const { minWidth, maxWidth, padding, excludeColumns } = options;

	// 获取表格的Vue实例
	const table = tableEl.__vue__;
	if (!table) {
		return;
	}

	// 获取表格的thead和tbody
	const thead = tableEl.querySelector('.el-table__header-wrapper thead');
	const tbody = tableEl.querySelector('.el-table__body-wrapper tbody');

	if (!thead) {
		return;
	}

	const headerCells = Array.from(thead.querySelectorAll('th'));
	
	// 如果没有数据行，只根据表头计算
	const bodyRows = tbody ? Array.from(tbody.querySelectorAll('tr')) : [];

	if (headerCells.length === 0) {
		return;
	}

	// 计算每一列的最大宽度
	const columnWidths = [];

	headerCells.forEach((headerCell, colIndex) => {
		// 跳过排除的列
		if (excludeColumns.includes(colIndex)) {
			return;
		}

		// 检查列是否已经设置了固定宽度（在计算宽度时检查）
		const column = getColumnByIndex(table, colIndex);
		if (column) {
			const columnProps = column.$options.propsData || {};
			if (columnProps.width) {
				// 如果列已经设置了固定宽度，跳过自适应
				return;
			}
		}

		// 获取表头宽度
		let maxColWidth = getElementContentWidth(headerCell);

		// 遍历所有数据行，获取该列的最大宽度
		bodyRows.forEach(row => {
			const cells = row.querySelectorAll('td');
			if (cells[colIndex]) {
				const cellWidth = getElementContentWidth(cells[colIndex]);
				maxColWidth = Math.max(maxColWidth, cellWidth);
			}
		});

		// 应用最小和最大宽度限制，并添加padding
		const finalWidth = Math.max(minWidth, Math.min(maxWidth, maxColWidth + padding));
		columnWidths[colIndex] = finalWidth;
	});

	// 应用宽度到列组件
	columnWidths.forEach((width, colIndex) => {
		if (excludeColumns.includes(colIndex) || !width) {
			return;
		}

		const column = getColumnByIndex(table, colIndex);
		if (column) {
			// 检查列是否已经设置了固定宽度
			const columnProps = column.$options.propsData || {};
			if (columnProps.width) {
				// 如果列已经设置了固定宽度，跳过自适应
				return;
			}

			// 更新column组件的width属性
			if (column.$options.propsData) {
				column.$options.propsData.width = width;
			}
			// 更新column实例的width属性
			if (column.width !== undefined) {
				column.width = width;
			}
			// 触发列更新
			if (column.$forceUpdate) {
				column.$forceUpdate();
			}
		}
	});

	// 直接更新DOM元素的宽度
	headerCells.forEach((cell, index) => {
		if (excludeColumns.includes(index)) {
			return;
		}

		const width = columnWidths[index];
		if (width) {
			cell.style.width = width + 'px';
			cell.style.minWidth = width + 'px';
		}
	});

	if (tbody) {
		bodyRows.forEach(row => {
			const cells = row.querySelectorAll('td');
			cells.forEach((cell, index) => {
				if (excludeColumns.includes(index)) {
					return;
				}

				const width = columnWidths[index];
				if (width) {
					cell.style.width = width + 'px';
					cell.style.minWidth = width + 'px';
				}
			});
		});
	}
}

/**
 * 根据索引获取列组件
 * @param {VueComponent} table - 表格Vue实例
 * @param {number} index - 列索引
 * @returns {VueComponent|null} 列组件实例
 */
function getColumnByIndex(table, index) {
	const columns = [];
	findTableColumns(table, columns);
	return columns[index] || null;
}

/**
 * 递归查找所有el-table-column组件
 * @param {VueComponent} component - Vue组件实例
 * @param {Array} columns - 存储列的数组
 */
function findTableColumns(component, columns) {
	if (component.$options.name === 'ElTableColumn') {
		columns.push(component);
	}

	if (component.$children && component.$children.length > 0) {
		component.$children.forEach(child => {
			findTableColumns(child, columns);
		});
	}
}

/**
 * 获取元素的实际内容宽度
 * @param {HTMLElement} element - DOM元素
 * @returns {number} 元素内容宽度
 */
function getElementContentWidth(element) {
	if (!element) {
		return 0;
	}

	// 获取计算后的样式
	const computedStyle = window.getComputedStyle(element);
	
	// 创建一个临时元素来测量内容宽度
	const tempEl = document.createElement('div');
	tempEl.style.cssText = `
		position: absolute;
		visibility: hidden;
		white-space: nowrap;
		top: -9999px;
		left: -9999px;
		font-size: ${computedStyle.fontSize};
		font-family: ${computedStyle.fontFamily};
		font-weight: ${computedStyle.fontWeight};
		letter-spacing: ${computedStyle.letterSpacing};
		text-transform: ${computedStyle.textTransform};
		box-sizing: ${computedStyle.boxSizing};
	`;

	// 获取元素的文本内容
	let textContent = '';
	
	// 如果是表头或单元格，获取其文本内容
	if (element.textContent) {
		textContent = element.textContent.trim();
	} else if (element.innerText) {
		textContent = element.innerText.trim();
	}

	// 如果元素包含其他元素（如按钮、图标等），需要计算这些元素的宽度
	let additionalWidth = 0;
	if (element.children.length > 0) {
		Array.from(element.children).forEach(child => {
			const childStyle = window.getComputedStyle(child);
			const childWidth = child.offsetWidth || 
				(parseFloat(childStyle.width) || 0) + 
				(parseFloat(childStyle.marginLeft) || 0) + 
				(parseFloat(childStyle.marginRight) || 0);
			additionalWidth += childWidth;
		});
	}

	tempEl.textContent = textContent || ' ';
	document.body.appendChild(tempEl);
	
	const textWidth = tempEl.offsetWidth;
	document.body.removeChild(tempEl);

	// 返回文本宽度加上额外元素宽度
	return Math.max(textWidth, additionalWidth);
}
