/**
 * 表格列处理混入
 * 提供统一的表格列配置处理能力
 * 基于 Vue 2 设计模式，遵循单一职责原则
 */
export const tableColumnMixin = {
	computed: {
		/**
		 * 获取可见的表格列
		 * @returns {Array} 可见列配置数组
		 */
		visibleColumns() {
			if (!this.configManager) {
				console.warn('ConfigManager 未初始化，请在组件中正确设置 configManager');
				return [];
			}

			// 如果存在tableColumns数组，使用它来过滤可见列
			if (this.tableColumns && Array.isArray(this.tableColumns)) {
				return this.tableColumns.filter(col => col.visible !== false);
			}

			// 否则使用configManager的默认方法
			return this.configManager.getTableColumns();
		}
	},

	methods: {
		/**
		 * 获取列属性配置
		 * 统一处理自适应宽度、属性清理等逻辑
		 * @param {Object} column 列配置对象
		 * @returns {Object} 处理后的列属性
		 */
		getColumnProps(column) {
			if (!this.configManager) {
				console.error('ConfigManager 未初始化，无法处理列属性');
				return column;
			}
			return this.configManager.getColumnProps(column);
		},

		/**
		 * 获取表格存储键名
		 * 子组件需要重写此方法提供唯一的存储键
		 * @returns {String} 存储键名
		 */
		getStorageKey() {
			return 'default-table-columns';
		},

		/**
		 * 获取默认列配置
		 * 为兼容性保留的方法
		 * @returns {Array} 默认列配置
		 */
		getDefaultColumns() {
			if (!this.configManager) {
				return [];
			}
			return this.configManager.getTableColumns();
		},

		/**
		 * 获取默认表单数据
		 * 基于列配置动态生成表单结构
		 * @returns {Object} 默认表单数据
		 */
		getDefaultFormData() {
			if (!this.configManager) {
				return {};
			}
			return this.configManager.getDefaultForm();
		},

		/**
		 * 获取表单配置
		 * 提供表单字段配置信息
		 * @returns {Array} 表单配置数组
		 */
		getFormConfig() {
			if (!this.configManager) {
				return [];
			}
			return this.configManager.getFormConfig();
		},

		/**
		 * 获取表单验证规则
		 * 基于列配置生成验证规则
		 * @returns {Object} 验证规则对象
		 */
		getFormRules() {
			if (!this.configManager) {
				return {};
			}
			return this.configManager.getFormRules();
		}
	},

	/**
	 * 组件创建时的配置检查
	 * 确保 ConfigManager 正确初始化
	 */
	created() {
		if (!this.configManager && this.$options.name !== 'TableColumnMixin') {
			console.warn(`组件 ${this.$options.name} 使用了 tableColumnMixin 但未初始化 configManager`);
		}
	}
};

export default tableColumnMixin;
