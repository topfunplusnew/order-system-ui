<template>
	<div class="app-container">
		<!-- 搜索区域 -->
		<el-form
			:model="queryParams"
			ref="queryForm"
			:inline="true"
			class="search-form"
			size="mini"
		>
			<el-form-item label="模块名称">
				<el-select
					v-model="tables"
					multiple
					collapse-tags
					placeholder="请选择模块"
					clearable
					style="width: 240px"
					size="mini"
				>
					<el-option
						v-for="item in moduleOptions"
						:key="item.value"
						:label="item.label"
						:value="item.value"
					/>
				</el-select>
			</el-form-item>
			<el-form-item label="时间范围">
				<el-date-picker
					v-model="queryParams.dateRange"
					type="daterange"
					range-separator="至"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
					value-format="yyyy-MM-dd"
					:default-time="['00:00:00', '23:59:59']"
					style="width: 240px"
					size="mini"
				/>
			</el-form-item>
			<el-form-item label="目标查询日期">
				<el-date-picker
					v-model="queryParams.params.targetDate"
					type="date"
					placeholder="选择日期"
					value-format="yyyy-MM-dd"
					style="width: 240px"
					size="mini"
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
			<el-row>
				<el-alert
					title="复杂信息请前往对应的模块查看对应的信息!"
					type="warning"
				>
				</el-alert>
			</el-row>
			<br />
			<el-row :gutter="20" v-if="groupedChangeList && changeList.length">
				<el-col
					:span="12"
					v-for="(group, tableName) in groupedChangeList"
					:key="tableName"
					class="card-col"
				>
					<el-card class="change-card" shadow="hover">
						<div slot="header" class="card-header">
							<span class="card-title">{{
								getModuleName(tableName) || '未知表'
							}}</span>
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
														<span class="info-label">{{
															translateField(key, tableName)
														}}</span>
														<span class="info-value">{{
															translateValue(key, value, tableName)
														}}</span>
													</div>
												</template>
											</div>
										</div>
										<div class="original-info">
											<div class="section-title">先前信息:</div>
											<div class="changed-info" v-if="item.originalInfoId">
												<template v-if="item.originalInfo">
													<div
														v-for="(value, key) in parseJSON(item.originalInfo)"
														:key="key"
														class="info-row"
													>
														<span class="info-label">{{
															translateField(key, tableName)
														}}</span>
														<span class="info-value">{{
															translateValue(key, value, tableName)
														}}</span>
													</div>
												</template>
											</div>
											<div v-else>无先前信息</div>
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
			<el-row v-else>
				<el-empty description="暂无数据"></el-empty>
			</el-row>
		</div>
	</div>
</template>

<script>
import { getFundChangeDetail } from '../../../api/system/sql';

import { moduleNames } from '../../../api/tool/enums';
import { PARAMS_TRANSFORM } from './index.js';
export default {
	name: 'MoneyChange',
	data() {
		// 需要的模块
		const filtersModule = [
			'virtualbankaccountchange',
			'payment',
			'receivemoney',
			'invoiceother',
			'invoicein',
			'invoiceout',
			'bankacceptance',
			'orderDetail',
			'goodsorder',
			'orderfreight',
			'inventory_detail',
			'inventory_main',
			'bankaccountchange',
			'borrowedmoney',
			'repayment',
			'lendmoney',
			'recovermoney'
		];
		const filterTables = Object.keys(moduleNames)
			.map(key => {
				if (filtersModule.includes(key)) {
					return {
						value: key,
						label: moduleNames[key]
					};
				}
			})
			.filter(item => {
				if (item) {
					return item;
				}
			});

		return {
			tables: filterTables,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				// 时间范围
				dateRange: [],
				originalInfoId: null,
				tableName: null,
				backupTime: null,
				backupType: null,
				backupUserTruenames: null,
				backupUserIds: null,
				params: {
					startTime: null,
					endTime: null,
					tableNames: filtersModule,
					targetDate: null
				}
			},
			changeList: [],
			// 添加模块选项
			moduleOptions: filterTables,
			// 字段翻译映射
			fieldTranslations: PARAMS_TRANSFORM
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
		getModuleName(moduleName) {
			return moduleNames[moduleName] || moduleName;
		},
		getList() {
			this.queryParams.params.tableNames = this.tables.map(item => item.value);
			getFundChangeDetail(this.queryParams).then(res => {
				if (!res.rows) {
					this.$message.warning('当前搜索条件下，无相关信息');
					return;
				}
				this.changeList = res.rows;
			});
		},
		// 处理查询
		handleQuery() {
			const startTime = this.queryParams.dateRange[0];
			const endTime = this.queryParams.dateRange[1];

			this.queryParams.params.startTime = startTime;
			this.queryParams.params.endTime = endTime;

			this.getList();
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

		translateField(field, tableName) {
			if (field === 'userName' || field === 'userId') {
				return null;
			}
			if (field === 'params') {
				return null;
			}
			if (field === 'updateTime') {
				return '更新时间';
			}
			if (field === 'createTime') {
				return '创建时间';
			}
			if (field === 'extraInfo') {
				return null;
			}
			return this.fieldTranslations[tableName][field] || field + ':';
		},

		translateValue(key, value, tableName) {
			if (key === 'userName' || key === 'userId') {
				return null;
			}
			if (key === 'extraInfo') {
				return null;
			}
			if (typeof value === 'object') {
				return '复杂信息';
			}

			return value;
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

/* 修改响应式布局 */
@media screen and (max-width: 1200px) {
	.el-col {
		width: 100% !important; /* 直接改为100%，小屏幕时一行一个 */
	}
}
</style>
