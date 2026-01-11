<template>
	<div class="codeless-system">
		<!-- 左侧菜单 -->
		<div class="codeless-sidebar">
			<div class="codeless-logo">
				<i class="el-icon-cpu"></i>
				<span>低代码平台</span>
			</div>
			<div class="codeless-menu">
				<div v-for="item in menuItems" :key="item.key" :class="['menu-item', { active: activeMenu === item.key }]" @click="activeMenu = item.key">
					<i :class="item.icon"></i>
					<span>{{ item.label }}</span>
				</div>
			</div>
		</div>

		<!-- 右侧主内容 -->
		<div class="codeless-main">
			<div class="codeless-header">
				<span class="codeless-title">{{ currentTitle }}</span>
			</div>
			<div class="codeless-content">
				<!-- API 接口管理 -->
				<div v-if="activeMenu === 'api-endpoint'" class="api-manager">
					<div class="api-toolbar">
						<el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增接口</el-button>
						<el-input v-model="searchKeyword" placeholder="搜索接口名称或路径" prefix-icon="el-icon-search" style="width: 280px; margin-left: 16px" clearable @clear="fetchList" @keyup.enter.native="fetchList" />
					</div>

					<el-table :data="tableData" v-loading="loading" border style="width: 100%">
						<el-table-column prop="name" label="接口名称" min-width="160" show-overflow-tooltip />
						<el-table-column prop="method" label="方法" width="90" align="center">
							<template slot-scope="scope">
								<el-tag :type="getMethodTagType(scope.row.method)" size="small">{{ scope.row.method }}</el-tag>
							</template>
						</el-table-column>
						<el-table-column prop="path" label="接口路径" min-width="200" show-overflow-tooltip />
						<el-table-column prop="description" label="描述" min-width="180" show-overflow-tooltip />
						<el-table-column prop="status" label="状态" width="100" align="center">
							<template slot-scope="scope">
								<el-tag :type="getStatusTagType(scope.row.status)" size="small">{{ getStatusLabel(scope.row.status) }}</el-tag>
							</template>
						</el-table-column>
						<el-table-column prop="updatedAt" label="更新时间" width="170" align="center">
							<template slot-scope="scope">{{ formatTime(scope.row.updatedAt) }}</template>
						</el-table-column>
						<el-table-column label="操作" width="150" align="center" fixed="right">
							<template slot-scope="scope">
								<el-button type="text" icon="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
								<el-button type="text" icon="el-icon-delete" style="color: #f56c6c" @click="handleDelete(scope.row)">删除</el-button>
							</template>
						</el-table-column>
					</el-table>

					<div class="api-pagination">
						<el-pagination background layout="total, sizes, prev, pager, next" :total="total" :page-size="pageSize" :current-page="currentPage" :page-sizes="[10, 20, 50]" @current-change="handlePageChange" @size-change="handleSizeChange" />
					</div>
				</div>
			</div>
		</div>

		<!-- 新增/编辑弹窗 -->
		<el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="700px" :close-on-click-modal="false">
			<el-form ref="formRef" :model="form" :rules="formRules" label-width="100px">
				<el-row :gutter="16">
					<el-col :span="12">
						<el-form-item label="接口名称" prop="name">
							<el-input v-model="form.name" placeholder="如：获取用户列表" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="HTTP 方法" prop="method">
							<el-select v-model="form.method" placeholder="请选择" style="width: 100%">
								<el-option v-for="m in httpMethods" :key="m" :label="m" :value="m" />
							</el-select>
						</el-form-item>
					</el-col>
				</el-row>
				<el-form-item label="接口路径" prop="path">
					<el-input v-model="form.path" placeholder="如：/api/users" />
				</el-form-item>
				<el-form-item label="接口描述" prop="description">
					<el-input v-model="form.description" type="textarea" :rows="2" placeholder="接口功能描述" />
				</el-form-item>
				<el-row :gutter="16">
					<el-col :span="12">
						<el-form-item label="状态" prop="status">
							<el-select v-model="form.status" placeholder="请选择" style="width: 100%">
								<el-option label="草稿" value="draft" />
								<el-option label="启用" value="active" />
								<el-option label="已废弃" value="deprecated" />
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="标签">
							<el-select v-model="form.tags" multiple filterable allow-create placeholder="输入后回车添加" style="width: 100%" />
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" :loading="submitLoading" @click="handleSubmit">确 定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { apiEndpointService, HTTP_METHODS } from '../services/apiEndpoint';

// 空表单模板
function createEmptyForm() {
	return {
		name: '',
		path: '',
		method: 'GET',
		description: '',
		headers: [],
		params: [],
		body: { type: 'json', schema: {} },
		response: { successCode: 200, schema: {} },
		tags: [],
		status: 'draft'
	};
}

export default {
	name: 'CodeLessEditor',
	data() {
		return {
			activeMenu: 'api-endpoint',
			menuItems: [{ key: 'api-endpoint', label: 'API 接口管理', icon: 'el-icon-connection' }],
			loading: false,
			tableData: [],
			total: 0,
			currentPage: 1,
			pageSize: 10,
			searchKeyword: '',
			dialogVisible: false,
			submitLoading: false,
			isEdit: false,
			editId: null,
			httpMethods: HTTP_METHODS,
			form: createEmptyForm(),
			formRules: {
				name: [{ required: true, message: '请输入接口名称', trigger: 'blur' }],
				path: [
					{ required: true, message: '请输入接口路径', trigger: 'blur' },
					{ pattern: /^\//, message: '路径必须以 / 开头', trigger: 'blur' }
				],
				method: [{ required: true, message: '请选择 HTTP 方法', trigger: 'change' }]
			}
		};
	},
	computed: {
		currentTitle() {
			const item = this.menuItems.find(m => m.key === this.activeMenu);
			return item ? item.label : '低代码平台';
		},
		dialogTitle() {
			return this.isEdit ? '编辑接口' : '新增接口';
		}
	},
	created() {
		this.fetchList();
	},
	methods: {
		// 获取列表
		async fetchList() {
			this.loading = true;
			try {
				const query = this.searchKeyword ? { keyword: this.searchKeyword } : {};
				const result = await apiEndpointService.getEndpointList(query, this.currentPage, this.pageSize);
				this.tableData = result.rows || [];
				this.total = result.total || 0;
			} catch (e) {
				console.error('[CodeLess] 获取列表失败:', e);
				this.tableData = [];
				this.total = 0;
			} finally {
				this.loading = false;
			}
		},
		handlePageChange(page) {
			this.currentPage = page;
			this.fetchList();
		},
		handleSizeChange(size) {
			this.pageSize = size;
			this.currentPage = 1;
			this.fetchList();
		},
		// 新增
		handleAdd() {
			this.isEdit = false;
			this.editId = null;
			this.form = createEmptyForm();
			this.dialogVisible = true;
			this.$nextTick(() => {
				if (this.$refs.formRef) {
					this.$refs.formRef.clearValidate();
				}
			});
		},
		// 编辑
		handleEdit(row) {
			this.isEdit = true;
			this.editId = row.id;
			this.form = {
				name: row.name || '',
				path: row.path || '',
				method: row.method || 'GET',
				description: row.description || '',
				headers: row.headers || [],
				params: row.params || [],
				body: row.body || { type: 'json', schema: {} },
				response: row.response || { successCode: 200, schema: {} },
				tags: row.tags || [],
				status: row.status || 'draft'
			};
			this.dialogVisible = true;
			this.$nextTick(() => {
				if (this.$refs.formRef) {
					this.$refs.formRef.clearValidate();
				}
			});
		},
		// 删除
		handleDelete(row) {
			this.$confirm('确定删除接口「' + row.name + '」吗？', '提示', { type: 'warning' })
				.then(() => {
					return apiEndpointService.deleteEndpoint(row.id);
				})
				.then(() => {
					this.fetchList();
				})
				.catch(() => {});
		},
		// 提交
		handleSubmit() {
			this.$refs.formRef.validate(valid => {
				if (!valid) return;

				this.submitLoading = true;
				const promise = this.isEdit ? apiEndpointService.updateEndpoint(this.editId, this.form) : apiEndpointService.createEndpoint(this.form);

				promise
					.then(success => {
						if (success) {
							this.dialogVisible = false;
							this.fetchList();
						}
					})
					.finally(() => {
						this.submitLoading = false;
					});
			});
		},
		// 工具方法
		getMethodTagType(method) {
			const map = { GET: '', POST: 'success', PUT: 'warning', DELETE: 'danger', PATCH: 'info' };
			return map[method] || 'info';
		},
		getStatusTagType(status) {
			const map = { active: 'success', deprecated: 'info', draft: 'warning' };
			return map[status] || '';
		},
		getStatusLabel(status) {
			const map = { active: '启用', deprecated: '已废弃', draft: '草稿' };
			return map[status] || status;
		},
		formatTime(isoStr) {
			if (!isoStr) return '-';
			return isoStr.replace('T', ' ').slice(0, 19);
		}
	}
};
</script>

<style scoped>
.codeless-system {
	display: flex;
	height: 100vh;
	background: #f0f2f5;
}

.codeless-sidebar {
	width: 220px;
	background: linear-gradient(180deg, #1e3a5f 0%, #0d2137 100%);
	display: flex;
	flex-direction: column;
	flex-shrink: 0;
}

.codeless-logo {
	height: 60px;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #fff;
	font-size: 18px;
	font-weight: 600;
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.codeless-logo i {
	font-size: 24px;
	margin-right: 8px;
}

.codeless-menu {
	flex: 1;
	padding: 12px 0;
}

.menu-item {
	display: flex;
	align-items: center;
	height: 48px;
	padding: 0 24px;
	color: rgba(255, 255, 255, 0.7);
	cursor: pointer;
	transition: all 0.2s;
}

.menu-item:hover {
	background: rgba(255, 255, 255, 0.08);
	color: #fff;
}

.menu-item.active {
	background: rgba(64, 158, 255, 0.3);
	color: #fff;
	border-right: 3px solid #409eff;
}

.menu-item i {
	font-size: 18px;
	margin-right: 12px;
}

.menu-item span {
	font-size: 14px;
}

.codeless-main {
	flex: 1;
	display: flex;
	flex-direction: column;
	overflow: hidden;
}

.codeless-header {
	height: 60px;
	background: #fff;
	display: flex;
	align-items: center;
	padding: 0 24px;
	box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
}

.codeless-title {
	font-size: 18px;
	font-weight: 600;
	color: #1e3a5f;
}

.codeless-content {
	flex: 1;
	padding: 16px;
	overflow: auto;
}

.api-manager {
	background: #fff;
	border-radius: 4px;
	padding: 20px;
	min-height: calc(100vh - 140px);
}

.api-toolbar {
	display: flex;
	align-items: center;
	margin-bottom: 16px;
}

.api-pagination {
	display: flex;
	justify-content: flex-end;
	margin-top: 16px;
}
</style>
