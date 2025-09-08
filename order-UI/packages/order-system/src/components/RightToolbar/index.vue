<template>
	<div class="top-right-btn" :style="style">
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
					<el-dropdown-menu slot="dropdown">
						<el-dropdown-item v-for="item in columns" :key="item.key || item.prop || item.label">
							<el-checkbox :checked="item.visible" :label="item.label" @change="checkboxChange($event, item.label)" />
						</el-dropdown-item>
					</el-dropdown-menu>
				</el-dropdown>
			</el-tooltip>
		</el-row>
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :title="title" :visible.sync="open" append-to-body>
			<el-transfer v-model="value" :titles="['显示', '隐藏']" :data="columns" @change="dataChange"></el-transfer>
		</el-dialog>
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
	},
	methods: {
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
::v-deep .el-transfer__button {
	border-radius: 50%;
	padding: 12px;
	display: block;
	margin-left: 0px;
}

::v-deep .el-transfer__button:first-child {
	margin-bottom: 10px;
}
</style>
