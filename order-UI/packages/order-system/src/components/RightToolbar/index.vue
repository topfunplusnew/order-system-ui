<template>
	<div class="toolbar-container" :style="style">
		<!-- 左侧自定义内容插槽 -->
		<div class="left-content">
			<slot name="left"></slot>
		</div>

		<!-- 右侧工具栏 -->
		<div class="top-right-btn">
			<el-row>
				<!-- 打印 -->
				<el-tooltip class="item" effect="dark" content="打印" placement="top" style="margin-right: 10px">
					<slot name="print"></slot>
				</el-tooltip>

				<!-- 导出 -->
				<el-tooltip class="item" effect="dark" content="导出" placement="top" style="margin-right: 0px">
					<slot name="export"></slot>
				</el-tooltip>

				<!-- 显隐列 -->
				<el-tooltip v-if="columns && columns.length > 0" class="item" style="margin-right: 10px" effect="dark" content="显隐列" placement="top">
					<!-- 穿梭框模式 -->
					<el-button v-if="showColumnsType === 'transfer'" size="mini" circle icon="el-icon-s-open" @click="showColumn" />
					<!-- 多选框模式 -->
					<el-dropdown v-if="showColumnsType === 'checkbox'" trigger="click" :hide-on-click="false" style="padding-left: 12px">
						<el-button size="mini" icon="el-icon-s-open" />
						<el-dropdown-menu slot="dropdown" class="multi-column-dropdown" :style="{ width: columnGroups.length > 1 ? '800px' : 'auto' }">
							<div class="select-all-container">
								<el-button size="mini" @click="toggleSelectAll" style="margin-bottom: 8px; margin-left: 8px">
									{{ isAllSelected ? '取消全选' : '全选' }}
								</el-button>
							</div>
							<div class="columns-container" :class="{ 'multi-columns': columnGroups.length > 1 }" :style="{ display: columnGroups.length > 1 ? 'flex' : 'block' }">
								<div v-for="(group, groupIndex) in columnGroups" :key="groupIndex" class="column-group" :style="{ flex: columnGroups.length > 1 ? '1' : 'none' }">
									<el-dropdown-item v-for="item in group" :key="item.key || item.prop || item.label">
										<!-- v-model 绑定 visible，保证全选/取消全选有效 -->
										<el-checkbox v-model="item.visible" @change="checkboxChange(item.visible, item.label)">
											{{ item.label }}
										</el-checkbox>
									</el-dropdown-item>
								</div>
							</div>
						</el-dropdown-menu>
					</el-dropdown>
				</el-tooltip>
			</el-row>

			<!-- 穿梭框弹窗 -->
			<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :title="title" :visible.sync="open" append-to-body>
				<el-transfer v-model="value" :titles="['显示', '隐藏']" :data="columns" @change="dataChange"></el-transfer>
			</el-dialog>
		</div>
	</div>
</template>

<script>
import { getUserConfig, saveUserConfig } from '@/api/user-config/index.js';
import { ShowColumnsType } from '@/api/tool/user-config.js';

export default {
	name: 'RightToolbar',
	props: {
		showColumnsType: {
			type: String,
			default: ShowColumnsType.CHECKBOX
		},
		beforeUnmount() {
			this.open = false;
		},
		showSearch: {
			type: Boolean,
			default: true
		},
		columns: {
			type: Array,
			default: () => []
		},
		gutter: {
			type: Number,
			default: 10
		},
		tableName: {
			type: String,
			default: 'goodsorder-columns'
		}
	},
	data() {
		return {
			value: [],
			title: '显示/隐藏列',
			open: false,
			configLoaded: false
		};
	},
	computed: {
		isAllSelected() {
			// 强制布尔判断，避免 undefined 或非布尔值导致计算错误
			return this.columns.length > 0 && this.columns.every(col => !!col.visible);
		},
		style() {
			return this.gutter ? { marginRight: `${this.gutter / 2}px` } : {};
		},
		columnGroups() {
			if (!Array.isArray(this.columns) || this.columns.length === 0) return [];
			const sortedColumns = [...this.columns].sort((a, b) => {
				const keyA = a.key ?? Number.MAX_SAFE_INTEGER;
				const keyB = b.key ?? Number.MAX_SAFE_INTEGER;
				return keyA - keyB;
			});
			const chunkSize = 9;
			const groups = [];
			for (let i = 0; i < sortedColumns.length; i += chunkSize) {
				groups.push(sortedColumns.slice(i, i + chunkSize));
			}
			return groups;
		}
	},
	mounted() {
		this.tryLoadConfig();
	},
	watch: {
		columns: {
			immediate: true,
			handler(newCols) {
				if (newCols.length > 0 && !this.configLoaded) {
					this.tryLoadConfig();
				}
			}
		}
	},
	methods: {
		async tryLoadConfig() {
			this.initializeColumnVisibility();
			await this.loadUserConfig();
		},

		initializeColumnVisibility() {
			if (!Array.isArray(this.columns) || this.configLoaded) return;
			this.columns.forEach((column, index) => {
				if (column.visible === undefined) {
					this.$set(this.columns, index, { ...column, visible: true });
				}
			});
		},

		async loadUserConfig() {
			if (!this.tableName || this.columns.length === 0) return;
			try {
				const configKey = `column_config_${this.tableName}`;
				const response = await getUserConfig(configKey);
				if (!response?.data) return;

				const savedConfig = typeof response.data === 'string' ? JSON.parse(response.data) : response.data;

				this.columns.forEach((column, index) => {
					if (column.label && Object.prototype.hasOwnProperty.call(savedConfig, column.label)) {
						this.$set(this.columns[index], 'visible', !!savedConfig[column.label]);
					}
				});

				this.configLoaded = true;
				this.$forceUpdate();
			} catch (error) {
				console.warn('加载列配置失败:', error);
			}
		},

		async saveUserConfig() {
			if (!this.tableName || this.columns.length === 0) return;
			try {
				const config = this.columns.reduce((obj, col) => {
					if (col.label) obj[col.label] = !!col.visible;
					return obj;
				}, {});
				const configKey = `column_config_${this.tableName}`;
				await saveUserConfig(configKey, config);
			} catch (error) {
				console.warn('保存列配置失败:', error);
			}
		},

		toggleSelectAll() {
			const shouldSelectAll = !this.isAllSelected;
			this.columns.forEach((col, index) => {
				this.$set(col, 'visible', shouldSelectAll);
				this.$emit('column-change', { index, column: col, visible: shouldSelectAll });
			});
			this.saveUserConfig();
		},

		handleRefresh() {
			this.$emit('refresh-table');
		},

		showColumn() {
			this.open = true;
		},

		checkboxChange(visible, label) {
			const index = this.columns.findIndex(col => col.label === label);
			if (index === -1) return;
			this.$set(this.columns[index], 'visible', visible);
			this.$emit('column-change', { index, column: this.columns[index], visible });
			this.saveUserConfig();
		},

		dataChange(hiddenIndices) {
			this.columns.forEach((col, index) => {
				const isVisible = !hiddenIndices.includes(index);
				if (col.visible !== isVisible) {
					this.$set(col, 'visible', isVisible);
					this.$emit('column-change', { index, column: col, visible: isVisible });
				}
			});
			this.saveUserConfig();
		},

		async refreshColumns() {
			await this.loadUserConfig();
			this.$message.success('列配置已刷新');
			this.$emit('column-refresh', this.columns);
		}
	}
};
</script>

<style lang="scss" scoped>
/* 样式保持不变，和原版相同 */
.toolbar-container {
	display: flex;
	justify-content: space-between;
	align-items: center;
	width: 100%;
	padding: 8px 0;
}

.left-content {
	flex: 1;
	display: flex;
	align-items: center;
	gap: 10px;
}

.top-right-btn {
	flex-shrink: 0;
	display: flex;
	align-items: center;

	.item {
		margin-right: 8px;
	}

	.el-button {
		transition: all 0.2s;
		&:hover {
			transform: scale(1.05);
		}
	}
}

::v-deep .el-transfer {
	width: 100%;
	min-width: 500px;

	.el-transfer__button {
		border-radius: 50%;
		padding: 12px;
		margin-left: 0;
	}

	.el-transfer__button:first-child {
		margin-bottom: 10px;
	}
}

::v-deep .el-dropdown-menu.multi-column-dropdown {
	padding: 8px 0;
	max-height: 400px;
	overflow-y: auto;

	.select-all-container {
		border-bottom: 1px solid #ebeef5;
		padding: 0 8px 8px;
	}

	.columns-container {
		display: flex;
		flex-direction: row;

		&.multi-columns {
			max-width: 800px;
			min-width: 400px;
		}

		.column-group {
			flex: 1;
			min-width: 200px;
			padding: 0 8px;

			&:not(:last-child) {
				border-right: 1px solid #ebeef5;
			}

			.el-dropdown-item {
				padding: 6px 8px;
				margin: 0;
				white-space: normal;

				.el-checkbox {
					width: 100%;
					.el-checkbox__label {
						font-size: 12px;
						line-height: 1.4;
						word-break: break-all;
					}
				}
			}
		}
	}
}
</style>
