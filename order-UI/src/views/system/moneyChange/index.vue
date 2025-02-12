<template>
	<div class="app-container">
		<!-- 搜索区域 -->
		<el-form
			:model="queryParams"
			ref="queryForm"
			:inline="true"
			class="search-form"
			size="small"
		>
			<el-form-item label="模块名称" prop="moduleName">
				<el-select
					v-model="queryParams.moduleNames"
					multiple
					collapse-tags
					placeholder="请选择模块"
					clearable
					style="width: 240px"
				>
					<el-option
						v-for="item in moduleOptions"
						:key="item.value"
						:label="item.label"
						:value="item.value"
					/>
				</el-select>
			</el-form-item>
			<el-form-item label="时间范围" prop="dateRange">
				<el-date-picker
					v-model="queryParams.dateRange"
					type="daterange"
					range-separator="至"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
					value-format="yyyy-MM-dd"
					:default-time="['00:00:00', '23:59:59']"
					style="width: 240px"
					size="small"
				/>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="small"
					@click="handleQuery"
				>
					搜索
				</el-button>
				<el-button icon="el-icon-refresh" size="small" @click="resetQuery">
					重置
				</el-button>
			</el-form-item>
		</el-form>

		<div class="card-container">
			<el-row :gutter="20">
				<el-col
					:span="6"
					v-for="(group, tableName) in groupedChangeList"
					:key="tableName"
					class="card-col"
				>
					<el-card class="change-card" shadow="hover">
						<div slot="header" class="card-header">
							<span class="card-title">{{ tableName || '未知表' }}</span>
							<div class="card-header-right">
								<span class="record-count">共 {{ group.length }} 条记录</span>
							</div>
						</div>
						<div class="card-content">
							<div class="content-wrapper">
								<div
									v-for="(item, index) in group"
									:key="index"
									class="change-record"
								>
									<div class="record-header">
										<span
											class="backup-type"
											:class="getBackupTypeClass(item.backupType)"
										>
											{{ transforTypes(item.backupType) }}
										</span>
										<span class="record-time">{{
											formatDateTime(item.backupTime)
										}}</span>
										<span class="record-operator">{{
											item.backupUserTruename
										}}</span>
									</div>
									<div class="record-content">
										<div class="info-section">
											<div class="section-title">变更信息：</div>
											<div class="changed-info">
												<template v-if="item.changedInfo">
													<div
														v-for="(value, key) in parseJSON(item.changedInfo)"
														:key="key"
														class="info-row"
													>
														<span class="info-label"
															>{{ translateField(key) }}：</span
														>
														<span class="info-value">{{ value }}</span>
													</div>
												</template>
											</div>
										</div>
										<div class="original-info">
											{{ item.originalInfoId ? '查看原始信息' : '无先前信息' }}
										</div>
									</div>
									<div
										class="record-divider"
										v-if="index !== group.length - 1"
									></div>
								</div>
							</div>
						</div>
					</el-card>
				</el-col>
			</el-row>
		</div>
	</div>
</template>

<script>
import { getFundChangeDetail } from '../../../api/system/sql';
export default {
	name: 'MoneyChange',
	data() {
		const end = new Date();
		const start = new Date();
		start.setMonth(start.getMonth() - 1);

		return {
			// 查询参数
			queryParams: {
				moduleNames: [], // 初始化为空数组
				dateRange: [this.parseTime(start), this.parseTime(end)]
			},
			changeList: [],
			// 添加模块选项
			moduleOptions: [
				{ value: 'company', label: '公司信息' },
				{ value: 'user', label: '用户信息' },
				{ value: 'role', label: '角色信息' },
				{ value: 'dept', label: '部门信息' },
				{ value: 'menu', label: '菜单信息' }
			],
			// 字段翻译映射
			fieldTranslations: {
				city: '城市',
				county: '区县',
				leader: '负责人',
				region: '地区',
				userId: '用户ID',
				address: '地址',
				addtime: '添加时间',
				delFlag: '删除标记',
				UserName: '用户名',
				comments: '备注',
				province: '省份',
				userName: '用户名',
				leaderTel: '负责人电话',
				companyName: '公司名称',
				companyType: '公司类型',
				relationTel: '关联电话',
				relationName: '关联人姓名',
				salesManager: '销售经理'
			}
		};
	},
	computed: {
		// 将changeList按tableName分组
		groupedChangeList() {
			const groups = {};
			this.changeList.forEach(item => {
				if (!groups[item.tableName]) {
					groups[item.tableName] = [];
				}
				groups[item.tableName].push(item);
			});
			// 对每个分组内的记录按时间倒序排序
			Object.keys(groups).forEach(tableName => {
				groups[tableName].sort(
					(a, b) => new Date(b.backupTime) - new Date(a.backupTime)
				);
			});
			return groups;
		}
	},
	created() {
		this.getList();
	},
	methods: {
		// 格式化JSON 因为后端传递过来的changedInfo是字符串，需要转换为JSON对象
		parseJSON(strings) {
			if (!strings) return {};
			return JSON.parse(JSON.parse(JSON.stringify(strings)));
		},
		// 格式化日期
		parseTime(date) {
			if (!date) return '';
			const year = date.getFullYear();
			const month = (date.getMonth() + 1).toString().padStart(2, '0');
			const day = date.getDate().toString().padStart(2, '0');
			return `${year}-${month}-${day}`;
		},
		transforTypes(type) {
			const typeMap = {
				insert: '新增',
				update: '修改',
				delete: '删除'
			};
			return typeMap[type] || type;
		},
		getList() {
			getFundChangeDetail().then(res => {
				if (!res.rows) {
					this.$message.warning('当前搜索条件下，无相关信息');
					return;
				}
				this.changeList = res.rows;
			});
		},
		// 处理查询
		handleQuery() {
			this.getList(this.queryParams);
		},
		// 重置查询
		resetQuery() {
			this.$refs.queryForm.resetFields();
			const end = new Date();
			const start = new Date();
			start.setMonth(start.getMonth() - 1);
			this.queryParams.dateRange = [this.parseTime(start), this.parseTime(end)];
			this.handleQuery();
		},
		// 新增方法
		formatDateTime(dateStr) {
			if (!dateStr) return '';
			const date = new Date(dateStr);
			return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(
				2,
				'0'
			)}-${String(date.getDate()).padStart(2, '0')} ${String(
				date.getHours()
			).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
		},

		getBackupTypeClass(type) {
			return {
				'type-insert': type === 'insert',
				'type-update': type === 'update',
				'type-delete': type === 'delete'
			};
		},

		translateField(field) {
			return this.fieldTranslations[field] || field;
		},

		showDetail(item) {
			// 实现详情查看逻辑
			console.log('查看详情', item);
		}
	}
};
</script>

<style scoped>
.search-form {
	margin-bottom: 15px;
	background: #fff;
	padding: 12px 15px;
	border-radius: 4px;
	box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.search-form :deep(.el-form-item) {
	margin-bottom: 0;
	margin-right: 15px;
}

.search-form :deep(.el-form-item__label) {
	font-size: 13px;
	padding-right: 8px;
}

.search-form :deep(.el-input__inner) {
	height: 32px;
	line-height: 32px;
}

.search-form :deep(.el-range-editor.el-input__inner) {
	padding: 0 5px;
}

.search-form :deep(.el-range-separator) {
	padding: 0 3px;
}

.search-form :deep(.el-button) {
	padding: 8px 15px;
}

.card-container {
	padding: 10px;
}

.card-col {
	margin-bottom: 15px;
}

.change-card {
	transition: all 0.3s;
	background: #fff;
	display: flex;
	flex-direction: column;
}

.change-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.card-header {
	flex-shrink: 0;
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px;
	border-bottom: 1px solid #ebeef5;
}

.card-title {
	font-size: 14px;
	font-weight: bold;
	color: #303133;
}

.card-header-right {
	display: flex;
	align-items: center;
	gap: 10px;
}

.record-count {
	font-size: 12px;
	color: #909399;
}

.change-record {
	padding: 8px 0;
}

.record-header {
	display: flex;
	align-items: center;
	margin-bottom: 8px;
	gap: 8px;
}

.record-time {
	font-size: 12px;
	color: #909399;
}

.record-operator {
	font-size: 12px;
	color: #606266;
}

.record-content {
	padding-left: 8px;
	border-left: 2px solid #ebeef5;
}

.record-divider {
	height: 1px;
	background-color: #ebeef5;
	margin: 12px 0;
}

.card-content {
	flex: 1;
	padding: 8px;
	overflow-y: auto;
	max-height: 400px;
}

.backup-type {
	padding: 2px 6px;
	border-radius: 3px;
	font-size: 12px;
}

.type-insert {
	background-color: #f0f9eb;
	color: #67c23a;
}

.type-update {
	background-color: #ecf5ff;
	color: #409eff;
}

.type-delete {
	background-color: #fef0f0;
	color: #f56c6c;
}

.info-section {
	margin-top: 8px;
	padding: 8px;
	background: #f8f9fa;
	border-radius: 4px;
}

.section-title {
	font-weight: bold;
	color: #303133;
	margin-bottom: 5px;
	font-size: 12px;
}

.changed-info {
	overflow-y: visible;
}

.info-row {
	display: flex;
	margin-bottom: 3px;
	font-size: 12px;
}

.info-label {
	color: #909399;
	width: 80px;
	flex-shrink: 0;
}

.info-value {
	color: #606266;
	flex: 1;
	word-break: break-all;
}

.original-info {
	flex-shrink: 0;
	color: #909399;
	font-size: 12px;
	padding: 3px 0;
	border-top: 1px solid #ebeef5;
	margin-top: 8px;
}

/* 响应式布局 */
@media screen and (max-width: 1600px) {
	.el-col {
		width: 33.33% !important;
	}
}

@media screen and (max-width: 1200px) {
	.el-col {
		width: 50% !important;
	}
}

@media screen and (max-width: 768px) {
	.el-col {
		width: 100% !important;
	}
}
</style>
