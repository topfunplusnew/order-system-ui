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
				const includeInTable = col.includeInTable !== false;
				return includeInTable;
			})
			.map((col, index) => {
				return {
					...col,
					key: col.key || col.prop || `column-${index}`,
					visible: col.visible !== false
				};
			});
	}

	/**
	 * 获取适用于 Element UI 的列属性配置
	 * @param {Object} column 原始列配置
	 * @returns {Object} 处理后的列属性
	 */
	getColumnProps(column) {
		const props = { ...column };

		if (props.autoWidth) {
			delete props.width;
		}

		delete props.key;
		delete props.visible;
		delete props.slot;
		delete props.autoWidth;
		delete props.includeInForm;
		delete props.includeInTable;
		delete props.formConfig;
		delete props.virtualColumn;
		delete props.formItems;

		return props;
	}

	/**
	 * 获取处理后的表格列配置
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
				const includeInForm = col.includeInForm !== false;
				const showInForm = col.formConfig && col.formConfig.show;
				return includeInForm && showInForm;
			})
			.map((col, index) => {
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
	 * @returns {Object} 默认表单数据对象
	 */
	getDefaultForm() {
		const dynamicForm = this.generateDefaultFormFromColumns();
		const baseForm = this.defaultForm || {};
		return { ...dynamicForm, ...baseForm };
	}

	/**
	 * 根据 tableColumns 动态生成默认表单数据
	 * @returns {Object} 动态生成的表单数据对象
	 */
	generateDefaultFormFromColumns() {
		const formData = {};

		this.tableColumns.forEach(column => {
			const includeInForm = column.includeInForm !== false;

			if (includeInForm && column.prop) {
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

		if (formConfig && Object.prototype.hasOwnProperty.call(formConfig, 'defaultValue')) {
			return formConfig.defaultValue;
		}

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
	 * 获取分组的表单配置
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
				if (currentGroup.length > 0) {
					groups.push(currentGroup);
				}
				currentGroup = [config];
				currentSpan = span;
			} else {
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
	 * @param {number} maxItemsPerColumn 每列最大表单项数量
	 * @returns {Array} 多列布局配置
	 */
	getMultiColumnFormConfig(maxItemsPerColumn = 9) {
		const formConfig = this.getFormConfig().sort((a, b) => {
			const aSort = a.formConfig.sortIndex || 999;
			const bSort = b.formConfig.sortIndex || 999;
			return aSort - bSort;
		});

		if (formConfig.length === 0) {
			return [];
		}

		const totalItems = formConfig.length;
		const columnsNeeded = Math.ceil(totalItems / maxItemsPerColumn);

		const columns = Array.from({ length: columnsNeeded }, () => []);

		formConfig.forEach((config, index) => {
			const columnIndex = Math.floor(index / maxItemsPerColumn);
			if (columnIndex < columnsNeeded) {
				columns[columnIndex].push(config);
			}
		});

		const columnSpan = Math.floor(24 / columnsNeeded);
		const remainderSpan = 24 % columnsNeeded;

		return columns.map((column, index) => ({
			items: column,
			span: columnSpan + (index < remainderSpan ? 1 : 0),
			columnIndex: index
		}));
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
