<script>
import { completeJsonData, JsonUtils, TypeUtils } from '@/views/dashboard/backuplog';
import { moduleNames, TableName } from '@/api/tool/enums';
import _ from 'lodash';
import { MultiList, TableConfig } from '../backup.config';
import FlexTable from '@/views/dashboard/backuplog/goodsorder/FlexTable.vue';

export default {
	name: 'CommonChange',
	components: { FlexTable },
	props: {
		compareData: {
			type: Array,
			default: () => []
		},
		moduleName: {
			type: String,
			default: ''
		}
	},
	data() {
		return {
			activeNames: ['1'],
			currentPage: 1, // 当前页码
			pageSize: 20, // 每页显示数量
			totalPages: 1 // 总页数
		};
	},
	computed: {
		TableName() {
			return TableName;
		},
		renderData() {
			let data = _.cloneDeep(this.compareData);
			const result = data.map(backlog => {
				let processed = { ...backlog };
				if (processed.logicBackupType === 'insert' && processed.originalInfo === 'null' && processed.changedInfo !== 'null') {
					processed.changedInfo = JsonUtils.getJson(processed.changedInfo);
					processed.originalInfo = null;
				}
				if (processed.logicBackupType === 'delete' && processed.changedInfo === 'null' && processed.originalInfo !== 'null') {
					processed.originalInfo = JsonUtils.getJson(processed.originalInfo);
					processed.changedInfo = null;
				}
				if (processed.logicBackupType === 'update' && processed.originalInfo !== 'null' && processed.changedInfo !== 'null') {
					const origin = JsonUtils.getJson(processed.originalInfo);
					const changed = JsonUtils.getJson(processed.changedInfo);
					processed.originalInfo = origin;
					processed.changedInfo = completeJsonData(origin, changed);
				}
				return processed;
			});
			const extra = [];
			const extraIds = [];
			const finalResult = result
				.map(backlog => {
					const ori = _.cloneDeep(backlog.originalInfo);
					const chag = _.cloneDeep(backlog.changedInfo);
					const originDataType = TypeUtils.prototype.checkType(ori);
					const changedDataType = TypeUtils.prototype.checkType(chag);
					if (originDataType === 'Array' && changedDataType === 'Array') {
						if (ori.length > 0 && chag.length > 0) {
							ori.forEach(element => {
								if (element) {
									extra.push({
										...backlog,
										tableName: backlog.tableName,
										originalInfo: backlog,
										changedInfo: null
									});
									if (element.id) extraIds.push(backlog.id);
								}
							});
							chag.forEach(element => {
								if (element) {
									extra.push({
										...backlog,
										tableName: backlog.tableName,
										originalInfo: null,
										changedInfo: backlog
									});
									if (element.id) extraIds.push(backlog.id);
								}
							});
						}
						return backlog;
					} else if (originDataType === 'Array' && changedDataType !== 'Array') {
						if (ori.length === 0) return backlog;
						ori.forEach(element => {
							if (element) {
								extra.push({
									...backlog,
									tableName: backlog.tableName,
									originalInfo: backlog,
									changedInfo: null
								});
								if (element.id) extraIds.push(backlog.id);
							}
						});
					} else if (originDataType !== 'Array' && changedDataType === 'Array') {
						if (chag.length === 0) return backlog;
						chag.forEach(element => {
							if (element) {
								extra.push({
									...backlog,
									tableName: backlog.tableName,
									originalInfo: null,
									changedInfo: backlog
								});
								if (element.id) extraIds.push(backlog.id);
							}
						});
					} else {
						return backlog;
					}
					return backlog;
				})
				.filter(backlog => !extraIds.includes(backlog.id))
				.sort((a, b) => {
					// 将 backupTime 转换为日期对象进行比较
					return new Date(a.backupTime) - new Date(b.backupTime);
				})
				.reverse();
			return Object.entries(_.groupBy(finalResult, item => item.uuid)).map(entries => _.groupBy(entries[1], item => item.tableName));
		},
		bodyData() {
			return this.renderData.map(backlog => {
				const moduleName = this.moduleName;
				let multiModuleName = null;
				// 如果分组出来的备份信息的key不止一个 那么就是复合数据
				const multiList = MultiList;
				const isMulti = Object.keys(backlog).some(key => multiList.includes(key));
				let items = null;
				let sub_info = null;

				if (moduleName === TableName.GOODS_ORDER) {
					items = backlog.goodsorder;
					sub_info = backlog.orderdetail;
					isMulti && (multiModuleName = TableName.ORDER_DETAIL);
				} else if (moduleName === TableName.INVENTORMAIN) {
					items = backlog.inventory_main;
					sub_info = backlog.inventory_detail;
					isMulti && (multiModuleName = TableName.INVENTORDETAIL);
				}
				// 需要计算的列 和 明细 需要计算的列
				const params = TableConfig[moduleName]?.params || [];
				const extraParams = TableConfig[multiModuleName]?.params || [];
				return {
					moduleName,
					multiModuleName,
					isMulti,
					isAdjust: isMulti && (moduleName === TableName.GOODS_ORDER || moduleName === TableName.INVENTORY_MAIN) && (backlog.goodsorder?.length > 1 || false),
					main_info: {
						data: backlog[moduleName],
						items: items
					},
					sub_info,
					params,
					extraParams,
					extraInfo: {}
				};
			});
		},
		paginatedData() {
			// 确保数据已准备好
			if (!this.bodyData || this.bodyData.length === 0) return [];

			const start = (this.currentPage - 1) * this.pageSize;
			const end = start + this.pageSize;

			// 确保分页范围有效
			return this.bodyData.slice(Math.max(0, start), Math.min(end, this.bodyData.length));
		},
		totalItems() {
			return this.bodyData.length;
		}
	},
	watch: {
		bodyData: {
			immediate: true,
			handler(newVal) {
				this.totalPages = Math.ceil(newVal.length / this.pageSize);
			}
		}
	},
	methods: {
		prevPage() {
			if (this.currentPage > 1) {
				this.currentPage--;
				this.scrollToTop();
			}
		},
		nextPage() {
			if (this.currentPage < this.totalPages) {
				this.currentPage++;
				this.scrollToTop();
			}
		},
		goToPage(page) {
			// 确保页码是数字
			page = Number(page);

			// 验证页码范围
			if (isNaN(page)) page = 1;
			if (page < 1) page = 1;
			if (page > this.totalPages) page = this.totalPages;

			this.currentPage = page;
			this.scrollToTop();
		},
		scrollToTop() {
			this.$nextTick(() => {
				const container = document.getElementById('scrollContainer');
				if (container) {
					container.scrollTo({ top: 0, behavior: 'smooth' });
				}
			});
		},
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<div class="body">
			<el-card class="box-card">
				<!-- 分页控制器 -->
				<div class="pagination-controls">
					<el-button @click="prevPage" :disabled="currentPage === 1" size="small">上一页</el-button>

					<span class="page-info">第 {{ currentPage }} 页 / 共 {{ totalPages }} 页 (共 {{ totalItems }} 条记录)</span>

					<el-button @click="nextPage" :disabled="currentPage >= totalPages" size="small">下一页</el-button>

					<!-- 快速跳转 -->
					<el-input type="number" v-model="currentPage" :min="1" :max="totalPages" size="small" @change="goToPage(currentPage)" style="width: 80px; margin-left: 10px" />
				</div>

				<div id="scrollContainer" class="scroll-area">
					<div v-for="(item, idx) in paginatedData" :key="idx">
						<FlexTable :body="item" :index="idx + (currentPage - 1) * pageSize" :key="`${currentPage}-${idx}`" />
					</div>

					<div v-if="paginatedData.length === 0" class="no-data">暂无数据</div>
				</div>

				<!-- 底部重复分页控制 -->
				<div class="pagination-controls bottom-controls">
					<el-button @click="prevPage" :disabled="currentPage === 1" size="small">上一页</el-button>

					<span class="page-info">第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>

					<el-button @click="nextPage" :disabled="currentPage >= totalPages" size="small">下一页</el-button>
				</div>
			</el-card>
		</div>
	</div>
</template>

<style scoped>
.scroll-area {
	height: 500px;
	overflow-y: auto;
	padding: 10px;
	margin: 10px 0;
}

.pagination-controls {
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 10px 0;
	border-bottom: 1px solid #eee;
}

.bottom-controls {
	border-top: 1px solid #eee;
	border-bottom: none;
}

.page-info {
	margin: 0 15px;
	font-size: 14px;
	color: #666;
}

.no-data {
	text-align: center;
	padding: 50px;
	color: #999;
	font-size: 16px;
}

/* 保持原有的表格样式 */
table {
	width: 3200px;
	max-width: 3200px;
	border-collapse: collapse;
	margin-bottom: 10px;
	border: 1px solid #ddd;
}

th,
td {
	border: 1px solid #ddd !important;
	padding: 8px;
	text-align: center;
}

th {
	background-color: #817e7e !important;
}

th:first-child,
td:first-child {
	width: 150px;
}
</style>
