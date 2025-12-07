<template>
	<div class="editor-container">
		<!-- 头部工具栏 -->
		<div class="editor-header">
			<div class="left">
				<el-button icon="el-icon-arrow-left" size="small" @click="handleBack">返回</el-button>
				<span class="page-title">{{ pageInfo.name || '未命名页面' }}</span>
			</div>
			<div class="right">
				<el-button size="small" @click="handlePreview">预览</el-button>
				<el-button type="primary" size="small" @click="handleSave">保存</el-button>
			</div>
		</div>

		<div class="editor-main">
			<!-- 左侧组件面板 -->
			<div class="left-panel">
				<div class="panel-title">组件库</div>
				<div v-for="category in categories" :key="category.key" class="component-category">
					<div class="category-title">
						<i :class="category.icon"></i>
						{{ category.name }}
					</div>
					<div class="component-list">
						<div v-for="comp in getComponentsByCategory(category.key)" :key="comp.id" class="component-item" draggable="true" @dragstart="handleDragStart($event, comp)">
							<i :class="comp.icon"></i>
							<span>{{ comp.name }}</span>
						</div>
					</div>
				</div>
			</div>

			<!-- 中间画布 -->
			<div class="canvas-area" @drop="handleDrop" @dragover.prevent>
				<div class="canvas-wrapper">
					<div v-if="schema.length === 0" class="empty-canvas">
						<i class="el-icon-plus"></i>
						<p>拖拽组件到此处</p>
					</div>
					<div v-else class="canvas-content">
						<div v-for="(item, index) in schema" :key="item._id" class="canvas-item" :class="{ active: selectedId === item._id }" @click="handleSelectItem(item)">
							<!-- 渲染组件 -->
							<component-render :config="item" />
							<!-- 操作按钮 -->
							<div class="item-actions">
								<el-button type="text" size="mini" icon="el-icon-arrow-up" @click.stop="handleMoveUp(index)" :disabled="index === 0"></el-button>
								<el-button type="text" size="mini" icon="el-icon-arrow-down" @click.stop="handleMoveDown(index)" :disabled="index === schema.length - 1"></el-button>
								<el-button type="text" size="mini" icon="el-icon-document-copy" @click.stop="handleCopyItem(item)"></el-button>
								<el-button type="text" size="mini" icon="el-icon-delete" @click.stop="handleDeleteItem(index)"></el-button>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- 右侧属性面板 -->
			<div class="right-panel">
				<div class="panel-title">属性配置</div>
				<div v-if="!selectedItem" class="empty-props">请选择组件进行配置</div>
				<div v-else class="props-form">
					<el-form label-position="top" size="small">
						<el-form-item v-for="(propConfig, propKey) in selectedItem._propsSchema" :key="propKey" :label="propConfig.title">
							<!-- 字符串类型 -->
							<el-input v-if="propConfig.type === 'string'" v-model="selectedItem.props[propKey]" :placeholder="'请输入' + propConfig.title" @change="handlePropsChange"></el-input>
							<!-- 数字类型 -->
							<el-input-number v-else-if="propConfig.type === 'number'" v-model="selectedItem.props[propKey]" :min="0" @change="handlePropsChange"></el-input-number>
							<!-- 布尔类型 -->
							<el-switch v-else-if="propConfig.type === 'boolean'" v-model="selectedItem.props[propKey]" @change="handlePropsChange"></el-switch>
							<!-- 数组类型（选项） -->
							<div v-else-if="propConfig.type === 'array' && propKey === 'options'" class="options-editor">
								<div v-for="(opt, idx) in selectedItem.props[propKey]" :key="idx" class="option-item">
									<el-input v-model="opt.label" placeholder="标签" size="mini" style="width: 80px"></el-input>
									<el-input v-model="opt.value" placeholder="值" size="mini" style="width: 80px"></el-input>
									<el-button type="text" icon="el-icon-delete" @click="removeOption(idx)"></el-button>
								</div>
								<el-button type="text" icon="el-icon-plus" @click="addOption">添加选项</el-button>
							</div>
							<!-- 数组类型（表格列） -->
							<div v-else-if="propConfig.type === 'array' && propKey === 'columns'" class="columns-editor">
								<div v-for="(col, idx) in selectedItem.props[propKey]" :key="idx" class="column-item">
									<el-input v-model="col.prop" placeholder="字段" size="mini" style="width: 80px"></el-input>
									<el-input v-model="col.label" placeholder="标题" size="mini" style="width: 80px"></el-input>
									<el-button type="text" icon="el-icon-delete" @click="removeColumn(idx)"></el-button>
								</div>
								<el-button type="text" icon="el-icon-plus" @click="addColumn">添加列</el-button>
							</div>
						</el-form-item>
					</el-form>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
import { pageApi, componentApi } from '../api';
import ComponentRender from '../components/ComponentRender.vue';

export default {
	name: 'CodelessEditor',
	components: { ComponentRender },
	data() {
		return {
			pageId: '',
			pageInfo: {},
			schema: [],
			components: [],
			categories: [],
			selectedId: '',
			selectedItem: null,
			dragComponent: null
		};
	},
	created() {
		this.pageId = this.$route.query.id;
		this.loadData();
	},
	methods: {
		// 加载数据
		async loadData() {
			try {
				const [pageRes, compRes, catRes] = await Promise.all([this.pageId ? pageApi.getById(this.pageId) : Promise.resolve({ data: {} }), componentApi.getList(), componentApi.getCategories()]);

				this.pageInfo = pageRes.data || {};
				this.schema = this.pageInfo.schema || [];
				this.components = compRes.data || [];
				this.categories = catRes.data || [];
			} catch (error) {
				this.$message.error('加载失败');
			}
		},

		// 获取分类下的组件
		getComponentsByCategory(category) {
			return this.components.filter(c => c.category === category);
		},

		// 开始拖拽
		handleDragStart(e, comp) {
			this.dragComponent = comp;
			e.dataTransfer.effectAllowed = 'copy';
		},

		// 放置组件
		handleDrop(e) {
			if (!this.dragComponent) return;
			const newItem = {
				_id: `${this.dragComponent.type}_${Date.now()}`,
				type: this.dragComponent.type,
				props: { ...this.dragComponent.default_props },
				_propsSchema: this.dragComponent.props_schema
			};
			this.schema.push(newItem);
			this.selectedId = newItem._id;
			this.selectedItem = newItem;
			this.dragComponent = null;
		},

		// 选中组件
		handleSelectItem(item) {
			this.selectedId = item._id;
			this.selectedItem = item;
		},

		// 上移
		handleMoveUp(index) {
			if (index === 0) return;
			const temp = this.schema[index];
			this.$set(this.schema, index, this.schema[index - 1]);
			this.$set(this.schema, index - 1, temp);
		},

		// 下移
		handleMoveDown(index) {
			if (index === this.schema.length - 1) return;
			const temp = this.schema[index];
			this.$set(this.schema, index, this.schema[index + 1]);
			this.$set(this.schema, index + 1, temp);
		},

		// 复制组件
		handleCopyItem(item) {
			const newItem = JSON.parse(JSON.stringify(item));
			newItem._id = `${item.type}_${Date.now()}`;
			this.schema.push(newItem);
		},

		// 删除组件
		handleDeleteItem(index) {
			const item = this.schema[index];
			if (this.selectedId === item._id) {
				this.selectedId = '';
				this.selectedItem = null;
			}
			this.schema.splice(index, 1);
		},

		// 属性变更
		handlePropsChange() {
			this.$forceUpdate();
		},

		// 添加选项
		addOption() {
			if (!this.selectedItem.props.options) {
				this.$set(this.selectedItem.props, 'options', []);
			}
			this.selectedItem.props.options.push({ label: '', value: '' });
		},

		// 移除选项
		removeOption(idx) {
			this.selectedItem.props.options.splice(idx, 1);
		},

		// 添加列
		addColumn() {
			if (!this.selectedItem.props.columns) {
				this.$set(this.selectedItem.props, 'columns', []);
			}
			this.selectedItem.props.columns.push({ prop: '', label: '' });
		},

		// 移除列
		removeColumn(idx) {
			this.selectedItem.props.columns.splice(idx, 1);
		},

		// 返回
		handleBack() {
			this.$router.push('/codeless');
		},

		// 预览
		handlePreview() {
			window.open(this.$router.resolve({ path: '/codeless/preview', query: { id: this.pageId } }).href, '_blank');
		},

		// 保存
		async handleSave() {
			try {
				// 清理 schema 中的 _propsSchema
				const cleanSchema = this.schema.map(item => ({
					_id: item._id,
					type: item.type,
					props: item.props
				}));

				await pageApi.update(this.pageId, { schema: cleanSchema });
				this.$message.success('保存成功');
			} catch (error) {
				this.$message.error('保存失败');
			}
		}
	}
};
</script>

<style scoped>
.editor-container {
	display: flex;
	flex-direction: column;
	height: 100vh;
	background: #f5f7fa;
}
.editor-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px 20px;
	background: #fff;
	border-bottom: 1px solid #e4e7ed;
}
.editor-header .left {
	display: flex;
	align-items: center;
	gap: 15px;
}
.page-title {
	font-weight: 600;
	font-size: 16px;
}
.editor-main {
	display: flex;
	flex: 1;
	overflow: hidden;
}
.left-panel,
.right-panel {
	width: 260px;
	background: #fff;
	border-right: 1px solid #e4e7ed;
	overflow-y: auto;
}
.right-panel {
	border-right: none;
	border-left: 1px solid #e4e7ed;
}
.panel-title {
	padding: 15px;
	font-weight: 600;
	border-bottom: 1px solid #e4e7ed;
}
.component-category {
	padding: 10px 15px;
}
.category-title {
	font-size: 13px;
	color: #909399;
	margin-bottom: 10px;
}
.category-title i {
	margin-right: 5px;
}
.component-list {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}
.component-item {
	display: flex;
	flex-direction: column;
	align-items: center;
	padding: 10px;
	border: 1px solid #e4e7ed;
	border-radius: 4px;
	cursor: grab;
	width: 70px;
	font-size: 12px;
	transition: all 0.2s;
}
.component-item:hover {
	border-color: #409eff;
	background: #ecf5ff;
}
.component-item i {
	font-size: 20px;
	margin-bottom: 5px;
	color: #409eff;
}
.canvas-area {
	flex: 1;
	padding: 20px;
	overflow: auto;
}
.canvas-wrapper {
	min-height: 100%;
	background: #fff;
	border: 1px dashed #dcdfe6;
	border-radius: 4px;
	padding: 20px;
}
.empty-canvas {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	height: 400px;
	color: #c0c4cc;
}
.empty-canvas i {
	font-size: 48px;
	margin-bottom: 15px;
}
.canvas-content {
	min-height: 400px;
}
.canvas-item {
	position: relative;
	padding: 10px;
	margin-bottom: 10px;
	border: 1px dashed transparent;
	border-radius: 4px;
	transition: all 0.2s;
}
.canvas-item:hover {
	border-color: #409eff;
}
.canvas-item.active {
	border-color: #409eff;
	background: #ecf5ff;
}
.item-actions {
	position: absolute;
	right: 5px;
	top: 5px;
	display: none;
}
.canvas-item:hover .item-actions,
.canvas-item.active .item-actions {
	display: block;
}
.empty-props {
	padding: 40px 20px;
	text-align: center;
	color: #909399;
}
.props-form {
	padding: 15px;
}
.options-editor,
.columns-editor {
	display: flex;
	flex-direction: column;
	gap: 8px;
}
.option-item,
.column-item {
	display: flex;
	align-items: center;
	gap: 5px;
}
</style>
