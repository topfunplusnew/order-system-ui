<template>
	<div class="toolbar-container" :style="style">
		<!-- 左侧自定义内容插槽 可以放新增按钮等 -->
		<div class="left-content">
			<slot name="left"></slot>
		</div>

		<!-- 右侧工具栏 -->
		<div class="top-right-btn">
			<el-row>
				<!--      打印-->
				<el-tooltip class="item" effect="dark" content="打印" placement="top" style="margin-right: 10px">
					<slot name="print"></slot>
				</el-tooltip>

				<!--      导出-->
				<el-tooltip class="item" effect="dark" content="导出" placement="top">
					<slot name="export"></slot>
				</el-tooltip>
				<el-tooltip class="item" effect="dark" content="导出2" placement="top">
					<slot name="export2"></slot>
				</el-tooltip>
				<!-- 隐藏列的控制   -->
				<el-tooltip v-if="columns" class="item" style="margin-right: 10px" effect="dark" content="显隐列" placement="top">
					<el-button v-if="showColumnsType == 'transfer'" size="mini" circle icon="el-icon-s-open" @click="showColumn()" />
					<el-dropdown v-if="showColumnsType == 'checkbox'" trigger="click" :hide-on-click="false" style="padding-left: 12px">
						<el-button size="mini" icon="el-icon-s-open" />
						<el-dropdown-menu slot="dropdown" class="multi-column-dropdown" :style="{ width: columnGroups.length > 1 ? '800px' : 'auto' }">
							<div class="columns-container" :class="{ 'multi-columns': columnGroups.length > 1 }" :style="{ display: columnGroups.length > 1 ? 'flex' : 'block' }">
								<div v-for="(group, groupIndex) in columnGroups" :key="groupIndex" class="column-group" :style="{ flex: columnGroups.length > 1 ? '1' : 'none' }">
									<el-dropdown-item v-for="item in group" :key="item.key || item.prop || item.label">
										<el-checkbox :checked="item.visible" :label="item.label" @change="checkboxChange($event, item.label)" />
									</el-dropdown-item>
								</div>
							</div>
						</el-dropdown-menu>
					</el-dropdown>
				</el-tooltip>
			</el-row>
			<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :title="title" :visible.sync="open" append-to-body>
				<el-transfer v-model="value" :titles="['显示', '隐藏']" :data="columns" @change="dataChange"></el-transfer>
			</el-dialog>
		</div>
	</div>
</template>
<script>
export default {
	name: 'RightToolbar',
	props: {
		/* 是否显示检索条件 */
		showSearch: {
			type: Boolean,
			default: true
		},
		/* 显隐列信息 */
		columns: {
			type: Array
		},
		/* 是否显示检索图标 */
		search: {
			type: Boolean,
			default: true
		},
		/* 显隐列类型（transfer穿梭框、checkbox复选框） */
		showColumnsType: {
			type: String,
			default: 'checkbox'
		},
		/* 右外边距 */
		gutter: {
			type: Number,
			default: 10
		}
	},
	data() {
		return {
			// 显隐数据
			value: [],
			// 弹出层标题
			title: '显示/隐藏',
			// 是否显示弹出层
			open: false
		};
	},
	computed: {
		style() {
			const ret = {};
			if (this.gutter) {
				ret.marginRight = `${this.gutter / 2}px`;
			}
			return ret;
		},
		// 计算列分组，每组最多20个
		columnGroups() {
			if (!this.columns || !Array.isArray(this.columns)) {
				return [];
			}
			const groups = [];
			const chunkSize = 20;
			for (let i = 0; i < this.columns.length; i += chunkSize) {
				groups.push(this.columns.slice(i, i + chunkSize));
			}
			// 添加调试信息
			console.log('总列数:', this.columns.length, '分组数:', groups.length, '分组详情:', groups);
			return groups;
		}
	},
	created() {
		if (this.showColumnsType == 'transfer') {
			// 显隐列初始默认隐藏列
			for (const item in this.columns) {
				if (this.columns[item].visible === false) {
					this.value.push(parseInt(item));
				}
			}
		}

		// 确保所有列都有明确的 visible 属性
		this.initializeColumnVisibility();
	},
	watch: {
		// 监听 columns 变化，确保新传入的列配置正确初始化
		columns: {
			handler() {
				this.initializeColumnVisibility();
			},
			immediate: true,
			deep: true
		}
	},
	methods: {
		// 初始化列的可见性
		initializeColumnVisibility() {
			if (this.columns && Array.isArray(this.columns)) {
				this.columns.forEach((column, index) => {
					// 如果 visible 属性未定义，默认设置为 true
					if (typeof column.visible === 'undefined') {
						this.$set(column, 'visible', true);
					}
				});
			}
		},

		// 打印
		handlePrint() {},
		// 搜索
		toggleSearch() {
			this.$emit('update:showSearch', !this.showSearch);
		},
		// 刷新
		refresh() {
			this.$emit('queryTable');
		},
		// 右侧列表元素变化
		dataChange(data) {
			for (const item in this.columns) {
				const key = this.columns[item].key;
				this.columns[item].visible = !data.includes(key);
			}
		},
		// 打开显隐列dialog
		showColumn() {
			this.open = true;
		},
		// 勾选
		checkboxChange(event, label) {
			const columnIndex = this.columns.findIndex(item => item.label === label);
			if (columnIndex !== -1) {
				// 使用Vue.set确保响应式更新
				this.$set(this.columns[columnIndex], 'visible', event);
				// 通知父组件列配置已更改
				this.$emit('column-change', {
					index: columnIndex,
					column: this.columns[columnIndex],
					visible: event
				});
			}
		}
	}
};
</script>
<style lang="scss" scoped>
// 工具栏容器 - 弹性盒布局
.toolbar-container {
	display: flex;
	justify-content: space-between;
	align-items: center;
	width: 100%;
}

// 左侧内容区域
.left-content {
	flex: 1;
	display: flex;
	align-items: center;
}

// 右侧工具按钮区域
.top-right-btn {
	flex-shrink: 0;
	display: flex;
	align-items: center;
}

::v-deep .el-transfer__button {
	border-radius: 50%;
	padding: 12px;
	display: block;
	margin-left: 0px;
}

::v-deep .el-transfer__button:first-child {
	margin-bottom: 10px;
}

// 多列下拉菜单样式 - 增强权重
::v-deep .el-dropdown-menu.multi-column-dropdown {
	.columns-container {
		display: flex !important;
		flex-direction: row !important;

		&.multi-columns {
			max-width: 800px !important; // 增加最大宽度
			min-width: 400px !important;
		}

		.column-group {
			flex: 1 !important;
			min-width: 200px !important; // 增加每列最小宽度
			display: flex !important;
			flex-direction: column !important;

			&:not(:last-child) {
				border-right: 1px solid #ebeef5 !important;
				padding-right: 12px !important;
				margin-right: 12px !important;
			}

			.el-dropdown-item {
				padding: 6px 8px !important;
				margin: 0 !important;
				display: block !important;

				&:hover {
					background-color: #f5f7fa !important;
				}

				.el-checkbox {
					width: 100% !important;
					margin: 0 !important;

					.el-checkbox__label {
						font-size: 12px !important;
						line-height: 1.4 !important;
						word-break: break-all !important;
						white-space: normal !important;
						max-width: 160px !important;
						display: inline-block !important;
					}
				}
			}
		}
	}
}

// 额外的全局样式确保生效
::v-deep .el-dropdown-menu {
	&.multi-column-dropdown {
		max-height: none !important;
		overflow: visible !important;

		.el-dropdown-item {
			line-height: normal !important;
		}
	}
}
</style>
