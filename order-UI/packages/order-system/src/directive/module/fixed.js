/**
 * v-fixed 固定布局指令
 * 用于固定某个元素，使其在滚动时保持固定位置
 *
 * 使用方式：
 * v-fixed="'top'" - 固定在顶部（使用 fixed 定位）
 * v-fixed="'bottom'" - 固定在底部（使用 fixed 定位）
 * v-fixed="{ position: 'top', zIndex: 1000, offset: 0 }" - 自定义位置、层级和偏移（使用 fixed 定位）
 * v-fixed="{ mode: 'sticky', position: 'top', offset: 0 }" - 使用 sticky 定位模式（适合表头）
 *
 * 参数说明：
 * - mode: 'fixed' | 'sticky' - 定位模式，默认为 'fixed'
 * - position: 'top' | 'bottom' - 固定位置，默认为 'top'
 * - zIndex: number - 层级，默认 1000（sticky 模式默认 99）
 * - offset: number - 偏移量（px），默认 0
 * - backgroundColor: string - 背景色，默认 '#fff'（sticky 模式默认不设置）
 * - boxShadow: string - 阴影，默认 '0 2px 8px rgba(0, 0, 0, 0.1)'（sticky 模式默认 '0 2px 4px rgba(0, 0, 0, 0.05)'）
 */

// 默认配置
const DEFAULT_CONFIG = {
	mode: 'fixed',
	position: 'top',
	zIndex: {
		fixed: 1000,
		sticky: 99
	},
	offset: 10,
	backgroundColor: '#fff',
	boxShadow: {
		fixed: '0 2px 8px rgba(0, 0, 0, 0.1)',
		sticky: '0 2px 4px rgba(0, 0, 0, 0.05)'
	}
};

// 需要保存的样式属性
const STYLE_PROPS = ['position', 'zIndex', 'top', 'bottom', 'left', 'width', 'backgroundColor', 'boxShadow', 'right'];

/**
 * 解析绑定值，返回配置对象
 */
function parseBindingValue(value) {
	if (!value) {
		return { ...DEFAULT_CONFIG, mode: DEFAULT_CONFIG.mode };
	}

	if (typeof value === 'string') {
		return {
			...DEFAULT_CONFIG,
			mode: DEFAULT_CONFIG.mode,
			position: value
		};
	}

	return {
		mode: value.mode || DEFAULT_CONFIG.mode,
		position: value.position || DEFAULT_CONFIG.position,
		zIndex: value.zIndex !== undefined ? value.zIndex : DEFAULT_CONFIG.zIndex[value.mode || DEFAULT_CONFIG.mode],
		offset: value.offset !== undefined ? value.offset : DEFAULT_CONFIG.offset,
		backgroundColor: value.backgroundColor || DEFAULT_CONFIG.backgroundColor,
		boxShadow: value.boxShadow || DEFAULT_CONFIG.boxShadow[value.mode || DEFAULT_CONFIG.mode]
	};
}

/**
 * 保存元素的原始样式
 */
function saveOriginalStyles(el) {
	const styles = {};
	STYLE_PROPS.forEach(prop => {
		styles[prop] = el.style[prop] || '';
	});
	return styles;
}

/**
 * 恢复元素的原始样式
 */
function restoreOriginalStyles(el, originalStyles) {
	if (!originalStyles) return;

	STYLE_PROPS.forEach(prop => {
		if (originalStyles[prop]) {
			el.style[prop] = originalStyles[prop];
		} else {
			el.style[prop] = '';
		}
	});
}

/**
 * 检查背景色是否透明
 */
function isTransparentBackground(computedStyle) {
	const bgColor = computedStyle.backgroundColor;
	return !bgColor || bgColor === 'rgba(0, 0, 0, 0)' || bgColor === 'transparent';
}

/**
 * 设置元素的背景色和阴影
 */
function setBackgroundAndShadow(el, config) {
	const computedStyle = window.getComputedStyle(el);

	// 设置背景色
	if (isTransparentBackground(computedStyle)) {
		el.style.backgroundColor = config.backgroundColor;
	}

	// 设置阴影
	if (!el.style.boxShadow) {
		el.style.boxShadow = config.boxShadow;
	}
}

/**
 * 设置元素的位置（top 或 bottom）
 */
function setPosition(el, position, offset) {
	const offsetValue = offset ? `${offset}px` : '0px';

	if (position === 'bottom') {
		el.style.bottom = offsetValue;
		el.style.top = 'auto';
	} else {
		el.style.top = offsetValue;
		el.style.bottom = 'auto';
	}
}

/**
 * 创建占位元素
 */
function createPlaceholder(el) {
	const height = el.getBoundingClientRect().height;
	const placeholder = document.createElement('div');

	placeholder.style.cssText = `
    height: ${height}px;
    width: 100%;
    visibility: hidden;
  `;
	placeholder.className = 'fixed-placeholder';

	if (el.parentNode) {
		el.parentNode.insertBefore(placeholder, el);
	}

	return placeholder;
}

/**
 * 获取容器信息（用于 fixed 模式）
 */
function getContainerInfo(el) {
	const container = el.parentElement;

	if (!container) {
		return {
			left: 0,
			width: window.innerWidth
		};
	}

	const containerRect = container.getBoundingClientRect();
	return {
		left: containerRect.left,
		width: container.clientWidth || containerRect.width
	};
}

/**
 * 防抖函数
 */
function debounce(func, wait = 100) {
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

/**
 * 应用 Sticky 模式
 */
function applyStickyMode(el, config) {
	el.style.position = 'sticky';
	el.style.zIndex = config.zIndex;

	setPosition(el, config.position, config.offset);
	setBackgroundAndShadow(el, config);
}

/**
 * 应用 Fixed 模式
 */
function applyFixedMode(el, config) {
	// 创建占位元素
	const placeholder = createPlaceholder(el);
	el._fixedPlaceholder = placeholder;

	// 初始化位置和尺寸
	const containerInfo = getContainerInfo(el);

	el.style.position = 'fixed';
	el.style.zIndex = config.zIndex;
	el.style.left = `${containerInfo.left}px`;
	el.style.right = 'auto';
	el.style.width = `${containerInfo.width}px`;

	setPosition(el, config.position, config.offset);
	setBackgroundAndShadow(el, config);

	// 创建布局更新函数（使用防抖优化 resize 事件）
	const updateLayout = () => {
		const containerInfo = getContainerInfo(el);

		// 更新位置和尺寸
		el.style.left = `${containerInfo.left}px`;
		el.style.width = `${containerInfo.width}px`;

		// 确保位置正确
		setPosition(el, config.position, config.offset);

		// 更新占位元素高度
		if (el._fixedPlaceholder) {
			const currentHeight = el.getBoundingClientRect().height;
			el._fixedPlaceholder.style.height = `${currentHeight}px`;
		}
	};

	// resize 事件使用防抖优化
	const debouncedUpdateLayout = debounce(updateLayout, 100);

	// 绑定事件监听
	window.addEventListener('scroll', updateLayout, { passive: true });
	window.addEventListener('resize', debouncedUpdateLayout, { passive: true });

	// 监听父元素滚动
	if (el.parentElement) {
		el.parentElement.addEventListener('scroll', updateLayout, { passive: true });
		el._fixedParentScrollHandler = updateLayout;
	}

	// 保存引用以便清理
	el._fixedUpdateLayout = updateLayout;
	el._fixedDebouncedUpdateLayout = debouncedUpdateLayout;

	// 初始更新
	updateLayout();
}

/**
 * 清理 Fixed 模式的事件监听
 */
function cleanupFixedMode(el) {
	// 移除窗口事件监听
	if (el._fixedUpdateLayout) {
		window.removeEventListener('scroll', el._fixedUpdateLayout);
	}
	if (el._fixedDebouncedUpdateLayout) {
		window.removeEventListener('resize', el._fixedDebouncedUpdateLayout);
	}

	// 移除父元素滚动监听
	if (el._fixedParentScrollHandler && el.parentElement) {
		el.parentElement.removeEventListener('scroll', el._fixedParentScrollHandler);
	}

	// 移除占位元素
	if (el._fixedPlaceholder?.parentNode) {
		el._fixedPlaceholder.parentNode.removeChild(el._fixedPlaceholder);
	}

	// 清理引用
	delete el._fixedUpdateLayout;
	delete el._fixedDebouncedUpdateLayout;
	delete el._fixedParentScrollHandler;
	delete el._fixedPlaceholder;
}

export default {
	inserted(el, binding) {
		const config = parseBindingValue(binding.value);

		// 保存原始样式
		el._fixedOriginalStyles = saveOriginalStyles(el);
		el._fixedMode = config.mode;

		// 根据模式应用不同的定位方式
		if (config.mode === 'sticky') {
			applyStickyMode(el, config);
		} else {
			applyFixedMode(el, config);
		}
	},

	update(el, binding) {
		// 如果值改变，重新应用
		if (binding.value !== binding.oldValue) {
			this.unbind(el);
			this.inserted(el, binding);
		}
	},

	unbind(el) {
		// 恢复原始样式
		restoreOriginalStyles(el, el._fixedOriginalStyles);

		// 清理事件监听（仅 fixed 模式需要）
		if (el._fixedMode === 'fixed') {
			cleanupFixedMode(el);
		}

		// 清理所有引用
		delete el._fixedOriginalStyles;
		delete el._fixedMode;
	}
};
