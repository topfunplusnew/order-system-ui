/**
 * 表格列处理混入
 * 提供统一的表格列配置处理能力
 * 基于 Vue 2 设计模式，遵循单一职责原则
 * 注意：列显隐控制已迁移到 columnVisibilityMixin
 */
export const tableColumnMixin = {
	computed: {
		/**
		 * 获取可见的表格列
		 * @returns {Array} 可见列配置数组
		 * @deprecated 此计算属性已迁移到 columnVisibilityMixin
		 */
		visibleColumns() {
			if (process.env.NODE_ENV === 'development') {
				console.warn('visibleColumns 计算属性已迁移到 columnVisibilityMixin，此方法将在未来版本中移除');
			}

			if (!this.configManager) {
				console.warn('ConfigManager 未初始化，请在组件中正确设置 configManager');
				return [];
			}

			if (this.tableColumns && Array.isArray(this.tableColumns)) {
				return this.tableColumns.filter(col => col.visible !== false);
			}

			return this.configManager.getTableColumns();
		}
	},

	methods: {
		/**
		 * 获取表格存储键名
		 * @returns {String} 存储键名
		 */
		getStorageKey() {
			return 'default-table-columns';
		},

		/**
		 * 获取默认列配置
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
		 * @returns {Object} 验证规则对象
		 */
		getFormRules() {
			if (!this.configManager) {
				return {};
			}
			return this.configManager.getFormRules();
		}
	},

	created() {
		if (!this.configManager && this.$options.name !== 'TableColumnMixin') {
			console.warn(`组件 ${this.$options.name} 使用了 tableColumnMixin 但未初始化 configManager`);
		}
	}
};

export default tableColumnMixin;
