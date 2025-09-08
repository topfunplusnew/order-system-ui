/**
 * 列配置管理工具类
 * 提供通用的列配置管理功能
 */
class ColumnManager {
	constructor(storageKey) {
		this.storageKey = storageKey;
		this.columns = [];
	}

	/**
	 * 设置列配置
	 * @param {Array} columns 列配置数组
	 */
	setColumns(columns) {
		this.columns = columns;
		this.saveToStorage();
	}

	/**
	 * 获取列配置
	 * @returns {Array} 列配置数组
	 */
	getColumns() {
		return this.columns;
	}

	/**
	 * 获取可见的列
	 * @returns {Array} 可见列配置数组
	 */
	getVisibleColumns() {
		return this.columns.filter(col => col.visible !== false);
	}

	/**
	 * 切换列的可见性
	 * @param {string} prop 列属性名
	 * @param {boolean} visible 是否可见
	 */
	toggleColumn(prop, visible) {
		const column = this.columns.find(col => col.prop === prop);
		if (column) {
			column.visible = visible;
			this.saveToStorage();
		}
	}

	/**
	 * 重置列配置到默认状态
	 * @param {Array} defaultColumns 默认列配置
	 */
	resetColumns(defaultColumns) {
		this.columns = JSON.parse(JSON.stringify(defaultColumns));
		this.saveToStorage();
	}

	/**
	 * 保存配置到本地存储
	 */
	saveToStorage() {
		if (this.storageKey) {
			localStorage.setItem(this.storageKey, JSON.stringify(this.columns));
		}
	}

	/**
	 * 从本地存储加载配置
	 * @param {Array} defaultColumns 默认列配置
	 */
	loadFromStorage(defaultColumns = []) {
		if (this.storageKey) {
			const stored = localStorage.getItem(this.storageKey);
			if (stored) {
				try {
					this.columns = JSON.parse(stored);
				} catch (error) {
					console.warn('Failed to parse stored columns:', error);
					this.columns = defaultColumns;
				}
			} else {
				this.columns = defaultColumns;
			}
		} else {
			this.columns = defaultColumns;
		}
	}
}

/**
 * 列宽度调整工具
 */
export const ColumnWidthUtils = {
	/**
	 * 根据内容自动计算列宽度
	 * @param {string} content 内容
	 * @param {number} minWidth 最小宽度
	 * @param {number} maxWidth 最大宽度
	 * @returns {number} 计算出的宽度
	 */
	calculateWidth(content, minWidth = 80, maxWidth = 300) {
		const charWidth = 8; // 假设每个字符约8px
		const padding = 32; // 内边距
		const calculated = content.length * charWidth + padding;
		return Math.min(Math.max(calculated, minWidth), maxWidth);
	},

	/**
	 * 批量设置列宽度
	 * @param {Array} columns 列配置数组
	 * @param {Object} widthMap 宽度映射 {prop: width}
	 */
	setColumnWidths(columns, widthMap) {
		columns.forEach(column => {
			if (widthMap[column.prop]) {
				column.width = widthMap[column.prop];
			}
		});
	}
};

/**
 * 列排序工具
 */
export const ColumnSortUtils = {
	/**
	 * 根据order字段排序列
	 * @param {Array} columns 列配置数组
	 * @returns {Array} 排序后的列配置数组
	 */
	sortByOrder(columns) {
		return [...columns].sort((a, b) => {
			const orderA = a.order || 999;
			const orderB = b.order || 999;
			return orderA - orderB;
		});
	},

	/**
	 * 移动列位置
	 * @param {Array} columns 列配置数组
	 * @param {number} fromIndex 源索引
	 * @param {number} toIndex 目标索引
	 * @returns {Array} 移动后的列配置数组
	 */
	moveColumn(columns, fromIndex, toIndex) {
		const result = [...columns];
		const [removed] = result.splice(fromIndex, 1);
		result.splice(toIndex, 0, removed);
		return result;
	}
};

/**
 * 创建列管理器实例
 * @param {string} storageKey 存储键名
 * @returns {ColumnManager} 列管理器实例
 */
export function createColumnManager(storageKey) {
	return new ColumnManager(storageKey);
}

export default ColumnManager;
