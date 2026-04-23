const DEFAULT_PADDING = 8;
const DEFAULT_DELAY = 60;
const DEFAULT_EMPTY_CONTENT_MAX_WIDTH = 200;
const EXCLUDED_TYPES = new Set(['selection', 'index', 'expand']);
const INTERACTIVE_SELECTOR = ['button', 'a', 'input', 'select', 'textarea', '.el-button', '.el-link', '.el-switch', '.el-dropdown', '.el-select', '.el-input'].join(',');
const CONTENT_WIDTH_SELECTOR = ['.text-content', '.measure-element', '[data-text]', '.cell-text', '.ellipsis', '.slot-content-wrapper'].join(',');
const AUTO_WIDTH_MANAGED_KEY = '__autoWidthManaged';

function isAutoWidthDisabled(tableVm) {
	return tableVm && tableVm.$el && tableVm.$el.getAttribute('data-auto-width-disabled') === 'true';
}

function isElTableInstance(vm) {
	return Boolean(vm && vm.$options && (vm.$options.name === 'ElTable' || vm.$options._componentTag === 'el-table'));
}

function getElementScrollWidth(element) {
	if (!element) {
		return 0;
	}

	return Math.max(element.scrollWidth || 0, 0);
}

function getStableElementWidth(element) {
	const measuredTextWidth = measureTextWidth(element);
	if (measuredTextWidth > 0) {
		return measuredTextWidth;
	}

	return getElementScrollWidth(element);
}

function measureTextWidth(element) {
	if (!element || typeof document === 'undefined' || typeof window === 'undefined' || typeof window.getComputedStyle !== 'function') {
		return 0;
	}

	const text = (element.textContent || '').trim();
	if (!text) {
		return 0;
	}

	const style = window.getComputedStyle(element);
	const measureEl = document.createElement('span');
	measureEl.textContent = text;
	measureEl.style.position = 'absolute';
	measureEl.style.visibility = 'hidden';
	measureEl.style.left = '-9999px';
	measureEl.style.top = '-9999px';
	measureEl.style.whiteSpace = 'nowrap';
	measureEl.style.width = 'auto';
	measureEl.style.maxWidth = 'none';
	measureEl.style.minWidth = '0';
	measureEl.style.padding = '0';
	measureEl.style.margin = '0';
	measureEl.style.border = '0';
	measureEl.style.boxSizing = 'content-box';
	measureEl.style.fontSize = style.fontSize;
	measureEl.style.fontFamily = style.fontFamily;
	measureEl.style.fontWeight = style.fontWeight;
	measureEl.style.letterSpacing = style.letterSpacing;
	measureEl.style.wordSpacing = style.wordSpacing;
	measureEl.style.lineHeight = style.lineHeight;

	document.body.appendChild(measureEl);
	const width = Math.ceil(measureEl.getBoundingClientRect().width);
	document.body.removeChild(measureEl);

	return width;
}

function getDescendantContentWidth(content) {
	if (!content || typeof content.querySelectorAll !== 'function') {
		return 0;
	}

	const targets = new Set(
		Array.from(content.querySelectorAll('*')).filter(element => {
			if (element.matches(CONTENT_WIDTH_SELECTOR)) {
				return true;
			}

			return element.children.length === 0 && Boolean((element.textContent || '').trim());
		})
	);

	let maxWidth = 0;

	targets.forEach(element => {
		maxWidth = Math.max(maxWidth, getStableElementWidth(element));
	});

	return maxWidth;
}

function getCellContentWidth(cell) {
	const content = cell.querySelector('.cell') || cell;
	const directWidth = getStableElementWidth(content);
	const descendantWidth = getDescendantContentWidth(content);

	return descendantWidth > 0 ? descendantWidth : directWidth;
}

function hasBodyCells(tableEl) {
	return Boolean(tableEl && tableEl.querySelector('tbody td'));
}

function hasMeaningfulCellContent(cell) {
	if (!cell) {
		return false;
	}

	return Boolean((cell.textContent || '').trim());
}

function hasInteractiveContent(cells) {
	return cells.some(cell => {
		if (!cell || typeof cell.querySelector !== 'function') {
			return false;
		}

		return Boolean(cell.querySelector(INTERACTIVE_SELECTOR));
	});
}

function isLeaveAloneColumn(cells) {
	return cells.some(cell => {
		if (!cell) {
			return false;
		}

		return cell.classList.contains('leave-alone') || Boolean(cell.querySelector('.leave-alone'));
	});
}

export function isAutoWidthExcludedColumn(column, cells = []) {
	if (!column || !column.id) {
		return true;
	}

	if (EXCLUDED_TYPES.has(column.type)) {
		return true;
	}

	if (column.width !== undefined && column.width !== null && column.width !== '' && !column[AUTO_WIDTH_MANAGED_KEY]) {
		return true;
	}

	if (isLeaveAloneColumn(cells)) {
		return true;
	}

	return hasInteractiveContent(cells);
}

export function applyAutoWidthToTable(tableVm, options = {}) {
	if (!tableVm || !tableVm.$el || !tableVm.store || !tableVm.store.states || isAutoWidthDisabled(tableVm)) {
		return;
	}

	const tableEl = tableVm.$el;
	const columns = tableVm.store.states.columns || [];
	const padding = options.padding ?? DEFAULT_PADDING;
	const emptyContentMaxWidth = options.emptyContentMaxWidth ?? DEFAULT_EMPTY_CONTENT_MAX_WIDTH;

	if (!hasBodyCells(tableEl)) {
		return;
	}

	tableEl.classList.add('r-table');

	columns.forEach(column => {
		const headerCell = tableEl.querySelector(`th.${column.id}`);
		const bodyCells = Array.from(tableEl.querySelectorAll(`tbody td.${column.id}`));
		const cells = [headerCell, ...bodyCells].filter(Boolean);

		if (isAutoWidthExcludedColumn(column, cells)) {
			return;
		}

		const headerWidth = headerCell ? getCellContentWidth(headerCell) : 0;
		const nonEmptyBodyCells = bodyCells.filter(cell => hasMeaningfulCellContent(cell));
		const bodyWidth = nonEmptyBodyCells.reduce((maxWidth, cell) => {
			return Math.max(maxWidth, getCellContentWidth(cell));
		}, 0);

		const contentWidth = Math.max(headerWidth, bodyWidth);

		if (!contentWidth) {
			return;
		}

		const computedWidth = contentWidth + padding;
		const hasMeaningfulBodyContent = nonEmptyBodyCells.length > 0;
		const finalWidth = hasMeaningfulBodyContent ? computedWidth : Math.min(computedWidth, emptyContentMaxWidth);
		const width = String(finalWidth);
		column[AUTO_WIDTH_MANAGED_KEY] = true;
		column.width = finalWidth;
		column.realWidth = finalWidth;

		tableEl.querySelectorAll(`col[name="${column.id}"]`).forEach(col => {
			col.setAttribute('width', width);
		});
	});
}

export function createTableAutoWidthMixin(defaultOptions = {}) {
	const delay = defaultOptions.delay ?? DEFAULT_DELAY;

	return {
		mounted() {
			if (!isElTableInstance(this)) {
				return;
			}

			this.__tableAutoWidthOptions = { ...defaultOptions };
			this.__bindTableAutoWidthResize();
			this.__scheduleTableAutoWidth();
		},
		updated() {
			if (!isElTableInstance(this)) {
				return;
			}

			this.__scheduleTableAutoWidth();
		},
		activated() {
			if (!isElTableInstance(this)) {
				return;
			}

			this.__scheduleTableAutoWidth();
		},
		beforeDestroy() {
			if (!isElTableInstance(this)) {
				return;
			}

			this.__cleanupTableAutoWidth();
		},
		methods: {
			__applyTableAutoWidth() {
				const execute = () => {
					if (typeof this.doLayout === 'function') {
						this.doLayout();
					}

					applyAutoWidthToTable(this, this.__tableAutoWidthOptions);
				};

				if (typeof this.$nextTick === 'function') {
					this.$nextTick(execute);
					return;
				}

				execute();
			},
			__scheduleTableAutoWidth() {
				clearTimeout(this.__tableAutoWidthTimer);
				this.__tableAutoWidthTimer = setTimeout(() => {
					this.__applyTableAutoWidth();
				}, delay);
			},
			__bindTableAutoWidthResize() {
				if (this.__tableAutoWidthResizeBound) {
					return;
				}

				const handleResize = () => {
					this.__scheduleTableAutoWidth();
				};

				this.__tableAutoWidthResizeHandler = handleResize;

				if (typeof ResizeObserver !== 'undefined' && this.$el) {
					this.__tableAutoWidthResizeObserver = new ResizeObserver(handleResize);
					this.__tableAutoWidthResizeObserver.observe(this.$el);
				} else if (typeof window !== 'undefined' && window.addEventListener) {
					window.addEventListener('resize', handleResize);
				}

				this.__tableAutoWidthResizeBound = true;
			},
			__cleanupTableAutoWidth() {
				clearTimeout(this.__tableAutoWidthTimer);

				if (this.__tableAutoWidthResizeObserver) {
					this.__tableAutoWidthResizeObserver.disconnect();
					this.__tableAutoWidthResizeObserver = null;
				}

				if (this.__tableAutoWidthResizeHandler && typeof window !== 'undefined' && window.removeEventListener) {
					window.removeEventListener('resize', this.__tableAutoWidthResizeHandler);
				}

				this.__tableAutoWidthResizeHandler = null;
				this.__tableAutoWidthResizeBound = false;
			}
		}
	};
}
