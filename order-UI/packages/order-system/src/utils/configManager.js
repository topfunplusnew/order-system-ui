/**
 * 配置管理器
 * 统一管理表格列配置和表单配置
 */
class ConfigManager {
	constructor(config) {
		this.config = config;
		this.tableColumns = config.tableColumns || [];
		this.defaultForm = config.defaultForm || {};
	}

	/**
	 * 获取表格列配置
	 * @returns {Array} 表格列配置数组
	 */
	getTableColumns() {
		return this.tableColumns
			.filter(col => {
				// 默认包含在表格中，除非明确设置为false
				const includeInTable = col.includeInTable !== false;
				return includeInTable;
			})
			.map((col, index) => {
				// 确保每个配置项都有唯一的 key 和默认的 visible 属性
				return {
					...col,
					key: col.key || col.prop || `column-${index}`,
					// 默认所有列都可见，除非明确设置为false
					visible: col.visible !== false
				};
			});
	}

	/**
	 * 获取适用于 Element UI 的列属性配置
	 * 自动处理自适应宽度逻辑，移除非 el-table-column 属性
	 * @param {Object} column 原始列配置
	 * @returns {Object} 处理后的列属性
	 */
	getColumnProps(column) {
		const props = { ...column };

		// 处理自适应宽度逻辑
		if (props.autoWidth) {
			// 如果开启自适应宽度，移除固定宽度
			delete props.width;
			// minWidth 和 maxWidth 保持原值（Element UI 原生支持）
		}

		// 移除非 el-table-column 属性，但保留formatter
		delete props.key;
		delete props.visible;
		delete props.slot;
		delete props.autoWidth; // 移除自定义属性
		delete props.includeInForm;
		delete props.includeInTable;
		delete props.formConfig;
		delete props.virtualColumn;
		delete props.formItems;

		return props;
	}

	/**
	 * 获取处理后的表格列配置（包含自适应宽度处理）
	 * @returns {Array} 处理后的表格列配置数组
	 */
	getProcessedTableColumns() {
		return this.getTableColumns().map(col => this.getColumnProps(col));
	}

	/**
	 * 获取表单配置
	 * @returns {Array} 表单字段配置数组
	 */
	getFormConfig() {
		return this.tableColumns
			.filter(col => {
				// 检查是否包含在表单中和是否显示
				const includeInForm = col.includeInForm !== false; // 默认为true
				const showInForm = col.formConfig && col.formConfig.show;
				return includeInForm && showInForm;
			})
			.map((col, index) => {
				// 确保每个配置项都有唯一的 key
				return {
					...col,
					key: col.key || col.prop || `field-${index}`
				};
			})
			.sort((a, b) => (a.formConfig.order || 999) - (b.formConfig.order || 999));
	}

	/**
	 * 获取表单验证规则
	 * @returns {Object} 验证规则对象
	 */
	getFormRules() {
		const rules = {};
		this.getFormConfig().forEach(col => {
			if (col.formConfig && col.formConfig.rules) {
				rules[col.prop] = col.formConfig.rules;
			}
		});
		return rules;
	}

	/**
	 * 获取默认表单数据
	 * 动态根据tableColumns生成，支持includeInForm属性控制
	 * @returns {Object} 默认表单数据对象
	 */
	getDefaultForm() {
		// 动态生成表单结构
		const dynamicForm = this.generateDefaultFormFromColumns();

		// 如果配置中有静态defaultForm，则合并它（静态配置优先）
		const baseForm = this.defaultForm || {};

		// 合并动态生成的配置和静态配置
		return { ...dynamicForm, ...baseForm };
	}

	/**
	 * 根据tableColumns动态生成默认表单数据
	 * @returns {Object} 动态生成的表单数据对象
	 */
	generateDefaultFormFromColumns() {
		const formData = {};

		this.tableColumns.forEach(column => {
			// 检查是否需要包含在表单中
			const includeInForm = column.includeInForm !== false; // 默认为true

			if (includeInForm && column.prop) {
				// 根据字段类型设置默认值
				formData[column.prop] = this.getDefaultValueByType(column);
			}
		});

		return formData;
	}

	/**
	 * 根据字段类型获取默认值
	 * @param {Object} column 列配置对象
	 * @returns {*} 默认值
	 */
	getDefaultValueByType(column) {
		const formConfig = column.formConfig;

		// 如果配置中指定了默认值，使用指定的值
		if (formConfig && Object.prototype.hasOwnProperty.call(formConfig, 'defaultValue')) {
			return formConfig.defaultValue;
		}

		// 根据字段类型返回合适的默认值
		if (formConfig) {
			switch (formConfig.type) {
				case 'number':
					return null;
				case 'switch':
					return false;
				case 'checkbox':
					return [];
				case 'date':
				case 'time':
				case 'datetime':
					return null;
				case 'select':
					return formConfig.multiple ? [] : null;
				default:
					return null;
			}
		}

		return null;
	}

	/**
	 * 根据配置生成表单数据结构
	 * @param {Object} data 现有数据
	 * @returns {Object} 表单数据对象
	 */
	generateFormData(data = {}) {
		const formData = this.getDefaultForm();

		// 合并传入的数据 - 包括所有传入的字段，不仅仅是已存在的字段
		Object.keys(data).forEach(key => {
			formData[key] = data[key];
		});

		return formData;
	}

	/**
	 * 获取字段的表单配置
	 * @param {string} prop 字段名
	 * @returns {Object} 字段的表单配置
	 */
	getFieldConfig(prop) {
		const column = this.tableColumns.find(col => col.prop === prop);
		return column ? column.formConfig : null;
	}

	/**
	 * 获取字段标签
	 * @param {string} prop 字段名
	 * @returns {string} 字段标签
	 */
	getFieldLabel(prop) {
		const column = this.tableColumns.find(col => col.prop === prop);
		return column ? column.label : prop;
	}

	/**
	 * 检查字段是否必填
	 * @param {string} prop 字段名
	 * @returns {boolean} 是否必填
	 */
	isFieldRequired(prop) {
		const config = this.getFieldConfig(prop);
		return config ? config.required : false;
	}

	/**
	 * 获取分组的表单配置（按col.span分组）
	 * @returns {Array} 分组的表单配置
	 */
	getGroupedFormConfig() {
		const formConfig = this.getFormConfig();
		const groups = [];
		let currentGroup = [];
		let currentSpan = 0;

		formConfig.forEach(config => {
			const span = config.formConfig.col ? config.formConfig.col.span : 24;

			if (currentSpan + span > 24) {
				// 当前行放不下，开始新行
				if (currentGroup.length > 0) {
					groups.push(currentGroup);
				}
				currentGroup = [config];
				currentSpan = span;
			} else {
				// 当前行可以放下
				currentGroup.push(config);
				currentSpan += span;
			}
		});

		if (currentGroup.length > 0) {
			groups.push(currentGroup);
		}

		return groups;
	}

	/**
	 * 获取多列布局的表单配置
	 * 按照 sortIndex 排序后，垂直优先填充多列布局
	 * @param {number} maxItemsPerColumn 每列最大表单项数量，默认9
	 * @returns {Array} 多列布局配置
	 */
	getMultiColumnFormConfig(maxItemsPerColumn = 9) {
		// 获取排序后的表单配置
		const formConfig = this.getFormConfig().sort((a, b) => {
			const aSort = a.formConfig.sortIndex || 999;
			const bSort = b.formConfig.sortIndex || 999;
			return aSort - bSort;
		});

		if (formConfig.length === 0) {
			return [];
		}

		// 计算需要的列数
		const totalItems = formConfig.length;
		const columnsNeeded = Math.ceil(totalItems / maxItemsPerColumn);

		// 创建列数组
		const columns = Array.from({ length: columnsNeeded }, () => []);

		// 按垂直优先的方式分配表单项到各列
		formConfig.forEach((config, index) => {
			const columnIndex = Math.floor(index / maxItemsPerColumn);
			if (columnIndex < columnsNeeded) {
				columns[columnIndex].push(config);
			}
		});

		// 计算每列的span值，确保总和为24
		const columnSpan = Math.floor(24 / columnsNeeded);
		const remainderSpan = 24 % columnsNeeded;

		// 为每列添加布局信息
		return columns.map((column, index) => ({
			items: column,
			span: columnSpan + (index < remainderSpan ? 1 : 0), // 将余数分配给前几列
			columnIndex: index
		}));
	}
}

/**
 * 加载配置文件并创建配置管理器
 * @param {string} configPath 配置文件路径
 * @returns {Promise<ConfigManager>} 配置管理器实例
 */
export async function loadConfig(configPath) {
	try {
		const response = await fetch(configPath);
		const config = await response.json();
		return new ConfigManager(config);
	} catch (error) {
		console.error('Failed to load config:', error);
		throw error;
	}
}

/**
 * 从模块导入配置并创建配置管理器
 * @param {Object} config 配置对象
 * @returns {ConfigManager} 配置管理器实例
 */
export function createConfigManager(config) {
	return new ConfigManager(config);
}

export default ConfigManager;
