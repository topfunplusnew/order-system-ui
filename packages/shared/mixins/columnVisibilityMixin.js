/**
 * 列显隐控制混入
 * 提供统一的表格列显隐逻辑
 * 基于 Vue 2 设计模式，遵循单一职责原则
 */
export const columnVisibilityMixin = {
	computed: {
		/**
		 * 获取可见的表格列
		 * @returns {Array} 可见列配置数组
		 */
		visibleColumns() {
			if (!this.tableColumns || !Array.isArray(this.tableColumns)) {
				return [];
			}
			return this.tableColumns.filter(column => column.visible !== false);
		}
	},

	methods: {
		/**
		 * 处理列显隐变化
		 * @param {Object} changeInfo 变化信息
		 */
		handleColumnChange(changeInfo) {
			if (changeInfo.index >= 0 && changeInfo.index < this.tableColumns.length) {
				this.$set(this.tableColumns[changeInfo.index], 'visible', changeInfo.visible);
			}
			this.saveColumnVisibility();
		},

		/**
		 * 保存列显隐状态到本地存储
		 */
		saveColumnVisibility() {
			if (typeof this.getStorageKey === 'function') {
				const storageKey = this.getStorageKey();
				const columnVisibility = this.tableColumns.map(col => ({
					key: col.key || col.prop,
					visible: col.visible !== false
				}));
				localStorage.setItem(storageKey, JSON.stringify(columnVisibility));
			}
		},

		/**
		 * 从本地存储恢复列显隐状态
		 */
		restoreColumnVisibility() {
			if (typeof this.getStorageKey === 'function' && this.tableColumns) {
				const storageKey = this.getStorageKey();
				const saved = localStorage.getItem(storageKey);

				if (saved) {
					try {
						const columnVisibility = JSON.parse(saved);
						const visibilityMap = new Map(columnVisibility.map(item => [item.key, item.visible]));

						this.tableColumns.forEach((col, index) => {
							const key = col.key || col.prop;
							if (visibilityMap.has(key)) {
								this.$set(this.tableColumns[index], 'visible', visibilityMap.get(key));
							}
						});
					} catch (error) {
						console.warn('Failed to restore column visibility:', error);
					}
				}
			}
		},

		/**
		 * 重置列显隐状态到默认值
		 */
		resetColumnVisibility() {
			if (this.tableColumns) {
				this.tableColumns.forEach((col, index) => {
					this.$set(this.tableColumns[index], 'visible', col.defaultVisible !== false);
				});

				if (typeof this.getStorageKey === 'function') {
					const storageKey = this.getStorageKey();
					localStorage.removeItem(storageKey);
				}
			}
		},

		/**
		 * 获取列属性配置
		 * @param {Object} column 列配置对象
		 * @returns {Object} 处理后的列属性
		 */
		getColumnProps(column) {
			if (this.configManager && typeof this.configManager.getColumnProps === 'function') {
				return this.configManager.getColumnProps(column);
			}

			const props = { ...column };

			delete props.key;
			delete props.visible;
			delete props.defaultVisible;
			delete props.includeInForm;
			delete props.includeInTable;
			delete props.formConfig;
			delete props.virtualColumn;
			delete props.formItems;

			return props;
		},

		/**
		 * 切换列的显示状态
		 * @param {string|number} columnKey 列的key或索引
		 */
		toggleColumnVisibility(columnKey) {
			const index = typeof columnKey === 'number' ? columnKey : this.tableColumns.findIndex(col => (col.key || col.prop) === columnKey);

			if (index >= 0 && index < this.tableColumns.length) {
				const newVisible = !this.tableColumns[index].visible;
				this.$set(this.tableColumns[index], 'visible', newVisible);
				this.saveColumnVisibility();
			}
		},

		/**
		 * 获取列的显示状态
		 * @param {string|number} columnKey 列的key或索引
		 * @returns {boolean} 是否可见
		 */
		getColumnVisibility(columnKey) {
			const index = typeof columnKey === 'number' ? columnKey : this.tableColumns.findIndex(col => (col.key || col.prop) === columnKey);

			return index >= 0 ? this.tableColumns[index].visible !== false : false;
		}
	},

	mounted() {
		this.$nextTick(() => {
			this.restoreColumnVisibility();
		});
	}
};

export default columnVisibilityMixin;
