<template>
	<div class="preview-container">
		<div class="preview-header">
			<span class="page-title">{{ pageInfo.name || '页面预览' }}</span>
			<el-button size="small" @click="handleBack">返回编辑</el-button>
		</div>
		<div class="preview-content">
			<el-form v-if="hasFormItems" ref="previewForm" :model="formData" label-width="100px">
				<template v-for="item in schema">
					<component-render :key="item._id" :config="item" :form-data="formData" :is-preview="true" />
				</template>
			</el-form>
			<template v-else>
				<component-render v-for="item in schema" :key="item._id" :config="item" :form-data="formData" :is-preview="true" />
			</template>
		</div>
	</div>
</template>

<script>
import { pageApi } from '../api';
import ComponentRender from '../components/ComponentRender.vue';

export default {
	name: 'CodelessPreview',
	components: { ComponentRender },
	data() {
		return {
			pageId: '',
			pageInfo: {},
			schema: [],
			formData: {}
		};
	},
	computed: {
		// 判断是否有表单项
		hasFormItems() {
			const formTypes = ['input', 'select', 'datepicker', 'textarea', 'radio', 'checkbox'];
			return this.schema.some(item => formTypes.includes(item.type));
		}
	},
	created() {
		this.pageId = this.$route.query.id;
		this.loadPage();
	},
	methods: {
		// 加载页面
		async loadPage() {
			if (!this.pageId) return;
			try {
				const res = await pageApi.getById(this.pageId);
				this.pageInfo = res.data || {};
				this.schema = this.pageInfo.schema || [];
				// 初始化表单数据
				this.initFormData();
			} catch (error) {
				this.$message.error('加载失败');
			}
		},

		// 初始化表单数据
		initFormData() {
			this.schema.forEach(item => {
				if (item.props?.field) {
					this.$set(this.formData, item.props.field, item.type === 'checkbox' ? [] : '');
				}
			});
		},

		// 返回编辑
		handleBack() {
			this.$router.push({ path: '/codeless/editor', query: { id: this.pageId } });
		}
	}
};
</script>

<style scoped>
.preview-container {
	min-height: 100vh;
	background: #f5f7fa;
}
.preview-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 15px 20px;
	background: #fff;
	border-bottom: 1px solid #e4e7ed;
}
.page-title {
	font-weight: 600;
	font-size: 16px;
}
.preview-content {
	padding: 30px;
	max-width: 900px;
	margin: 0 auto;
	background: #fff;
	min-height: calc(100vh - 60px);
}
</style>
