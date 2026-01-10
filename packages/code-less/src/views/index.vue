<template>
	<div class="codeless-container">
		<div class="codeless-header">
			<h2>低代码开发平台</h2>
			<el-button type="primary" icon="el-icon-plus" @click="handleCreate">新建页面</el-button>
		</div>

		<!-- 搜索区域 -->
		<div class="search-area">
			<el-input v-model="queryParams.keyword" placeholder="搜索页面名称" clearable style="width: 200px" @clear="handleSearch" @keyup.enter.native="handleSearch">
				<el-button slot="append" icon="el-icon-search" @click="handleSearch"></el-button>
			</el-input>
			<el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 120px; margin-left: 10px" @change="handleSearch">
				<el-option label="草稿" :value="0"></el-option>
				<el-option label="已发布" :value="1"></el-option>
			</el-select>
		</div>

		<!-- 页面列表 -->
		<div class="page-list">
			<el-row :gutter="20">
				<el-col v-for="page in pageList" :key="page.id" :span="6">
					<el-card class="page-card" shadow="hover">
						<div class="page-card-header">
							<span class="page-name">{{ page.name }}</span>
							<el-tag :type="page.status === 1 ? 'success' : 'info'" size="mini">
								{{ page.status === 1 ? '已发布' : '草稿' }}
							</el-tag>
						</div>
						<div class="page-card-desc">{{ page.description || '暂无描述' }}</div>
						<div class="page-card-footer">
							<span class="update-time">{{ formatTime(page.updated_at) }}</span>
							<div class="actions">
								<el-button type="text" size="mini" @click="handleEdit(page)">编辑</el-button>
								<el-button type="text" size="mini" @click="handlePreview(page)">预览</el-button>
								<el-dropdown trigger="click" @command="cmd => handleCommand(cmd, page)">
									<el-button type="text" size="mini">
										更多
										<i class="el-icon-arrow-down"></i>
									</el-button>
									<el-dropdown-menu slot="dropdown">
										<el-dropdown-item command="copy">复制</el-dropdown-item>
										<el-dropdown-item command="publish">{{ page.status === 1 ? '下线' : '发布' }}</el-dropdown-item>
										<el-dropdown-item command="delete" divided>删除</el-dropdown-item>
									</el-dropdown-menu>
								</el-dropdown>
							</div>
						</div>
					</el-card>
				</el-col>
			</el-row>

			<el-empty v-if="pageList.length === 0" description="暂无页面，点击上方按钮创建"></el-empty>
		</div>

		<!-- 新建/编辑弹窗 -->
		<el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="500px">
			<el-form ref="pageForm" :model="pageForm" :rules="rules" label-width="80px">
				<el-form-item label="页面名称" prop="name">
					<el-input v-model="pageForm.name" placeholder="请输入页面名称"></el-input>
				</el-form-item>
				<el-form-item label="页面路径" prop="path">
					<el-input v-model="pageForm.path" placeholder="请输入页面路径，如 /my-page"></el-input>
				</el-form-item>
				<el-form-item label="页面描述">
					<el-input v-model="pageForm.description" type="textarea" :rows="3" placeholder="请输入页面描述"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer">
				<el-button @click="dialogVisible = false">取消</el-button>
				<el-button type="primary" @click="handleSubmit">确定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { pageApi } from '../api';

export default {
	name: 'CodelessIndex',
	data() {
		return {
			pageList: [],
			loading: false,
			queryParams: {
				keyword: '',
				status: ''
			},
			dialogVisible: false,
			dialogTitle: '新建页面',
			pageForm: {
				id: '',
				name: '',
				path: '',
				description: ''
			},
			rules: {
				name: [{ required: true, message: '请输入页面名称', trigger: 'blur' }]
			}
		};
	},
	created() {
		this.loadPageList();
	},
	methods: {
		// 加载页面列表
		async loadPageList() {
			this.loading = true;
			try {
				const res = await pageApi.getList(this.queryParams);
				this.pageList = res.data || [];
			} catch (error) {
				this.$message.error('加载失败: ' + (error.message || '未知错误'));
			} finally {
				this.loading = false;
			}
		},

		// 搜索
		handleSearch() {
			this.loadPageList();
		},

		// 新建页面
		handleCreate() {
			this.dialogTitle = '新建页面';
			this.pageForm = { id: '', name: '', path: '', description: '' };
			this.dialogVisible = true;
		},

		// 编辑页面设计
		handleEdit(page) {
			this.$router.push({ path: '/codeless/editor', query: { id: page.id } });
		},

		// 预览页面
		handlePreview(page) {
			this.$router.push({ path: '/codeless/preview', query: { id: page.id } });
		},

		// 下拉菜单命令
		handleCommand(command, page) {
			switch (command) {
				case 'copy':
					this.handleCopy(page);
					break;
				case 'publish':
					this.handlePublish(page);
					break;
				case 'delete':
					this.handleDelete(page);
					break;
			}
		},

		// 复制页面
		async handleCopy(page) {
			try {
				await pageApi.copy(page.id);
				this.$message.success('复制成功');
				this.loadPageList();
			} catch (error) {
				this.$message.error('复制失败');
			}
		},

		// 发布/下线
		async handlePublish(page) {
			try {
				await pageApi.update(page.id, { status: page.status === 1 ? 0 : 1 });
				this.$message.success(page.status === 1 ? '下线成功' : '发布成功');
				this.loadPageList();
			} catch (error) {
				this.$message.error('操作失败');
			}
		},

		// 删除页面
		handleDelete(page) {
			this.$confirm('确定要删除该页面吗？', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			})
				.then(async () => {
					await pageApi.delete(page.id);
					this.$message.success('删除成功');
					this.loadPageList();
				})
				.catch(() => {});
		},

		// 提交表单
		handleSubmit() {
			this.$refs.pageForm.validate(async valid => {
				if (!valid) return;
				try {
					if (this.pageForm.id) {
						await pageApi.update(this.pageForm.id, this.pageForm);
					} else {
						const res = await pageApi.create(this.pageForm);
						// 创建成功后跳转到编辑器
						this.$router.push({ path: '/codeless/editor', query: { id: res.data.id } });
					}
					this.dialogVisible = false;
					this.loadPageList();
				} catch (error) {
					this.$message.error('操作失败: ' + (error.message || '未知错误'));
				}
			});
		},

		// 格式化时间
		formatTime(time) {
			if (!time) return '';
			return new Date(time).toLocaleString('zh-CN');
		}
	}
};
</script>

<style scoped>
.codeless-container {
	padding: 20px;
	background: #f5f7fa;
	min-height: calc(100vh - 84px);
}
.codeless-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}
.codeless-header h2 {
	margin: 0;
	font-size: 20px;
	color: #303133;
}
.search-area {
	margin-bottom: 20px;
	display: flex;
	align-items: center;
}
.page-card {
	margin-bottom: 20px;
	cursor: pointer;
	transition: transform 0.2s;
}
.page-card:hover {
	transform: translateY(-2px);
}
.page-card-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 10px;
}
.page-name {
	font-weight: 600;
	font-size: 16px;
	color: #303133;
}
.page-card-desc {
	color: #909399;
	font-size: 13px;
	height: 40px;
	overflow: hidden;
	text-overflow: ellipsis;
}
.page-card-footer {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 15px;
	padding-top: 10px;
	border-top: 1px solid #ebeef5;
}
.update-time {
	font-size: 12px;
	color: #c0c4cc;
}
.actions {
	display: flex;
	gap: 5px;
}
</style>
