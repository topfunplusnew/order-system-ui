<template>
	<div>
		<div class="body">
			<div id="scrollContainer" class="scroll-area">
				<el-table v-if="allMergedTableData.length > 0" :data="allMergedTableData" :span-method="getAllSpanMethod" :cell-style="getAllMergedCellStyle" :row-class-name="getRowClassName" border style="width: 100%" row-key="rowKey" show-summary :summary-method="getSummaryMethod">
					<el-table-column label="记录" width="180" align="center">
						<template slot-scope="scope">
							<span>{{ scope.row.recordLabel }}</span>
						</template>
					</el-table-column>
					<!-- 展开列：用于显示订单明细，放在记录列之后 -->
					<el-table-column v-if="hasOrderDetailList" type="expand" width="50" align="center">
						<template slot-scope="scope">
							<div v-if="shouldShowOrderDetail(scope.row)" class="order-detail-expand-wrapper">
								<div v-if="getOrderDetailList(scope.row).length > 0" class="order-detail-expand">
									<el-table :data="getOrderDetailList(scope.row)" border size="mini" style="width: 100%" show-summary :summary-method="getOrderDetailSummaryMethod" :cell-style="getOrderDetailCellStyle">
										<el-table-column label="状态" width="100" align="center">
											<template slot-scope="scope">
												<span>{{ scope.row.status }}</span>
											</template>
										</el-table-column>
										<el-table-column v-for="col in orderDetailColumns" :key="col.prop" :prop="col.prop" :label="col.label" :formatter="col.formatter" align="center" show-overflow-tooltip />
									</el-table>
								</div>
								<div v-else class="no-detail-data">暂无明细数据</div>
							</div>
						</template>
					</el-table-column>
					<el-table-column label="状态" width="120" align="center">
						<template slot-scope="scope">
							<span>{{ scope.row.status }}</span>
						</template>
					</el-table-column>
					<el-table-column v-for="col in allMergedTableColumns" :key="col.prop" :prop="col.prop" :label="col.label" :formatter="col.formatter" align="center" />
				</el-table>
				<div v-if="allMergedTableData.length === 0" class="no-data">暂无数据</div>
			</div>
			<!-- 底部重复分页控制 -->
			<div class="pagination-controls bottom-controls">
				<el-button @click="prevPage" :disabled="currentPage === 1" size="small">上一页</el-button>
				<span class="page-info">第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
				<el-button @click="nextPage" :disabled="currentPage >= totalPages" size="small">下一页</el-button>
				<el-button type="primary" @click="handleExport" size="small" :disabled="bodyData.length === 0" style="margin-left: 20px">
					<i class="el-icon-download"></i>
					导出Excel
				</el-button>
			</div>
		</div>
	</div>
</template>

<script>
import { TypeUtils } from '@/views/dashboard/backuplog';
import { moduleNames, System_Option_Type, TableName } from '@/api/tool/enums';
import _ from 'lodash';
import { MultiList, TableConfig } from '../backup.config';
import { getUuid } from '@/utils/trash/utils';
import * as XLSX from 'xlsx';

// 定义高亮背景色
const HIGHLIGHT_COLOR = '#fff3cd'; // 一个淡黄色，类似 Bootstrap 的 warning 背景色

export default {
	name: 'CommonChange',
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
			currentPage: 1, // 当前页码
			pageSize: 20, // 每页显示数量
			totalPages: 1, // 总页数
			// 使用 WeakMap 来缓存差异属性，键是 item 或 sub_info 对象，值是 Set<string>
			// WeakMap 的好处是当 item/sub_info 对象不再被引用时，缓存会自动清理，避免内存泄漏
			diffPropsCache: new WeakMap()
		};
	},
	computed: {
		TableName() {
			return TableName;
		},
		moduleNames() {
			return moduleNames;
		},
		renderData() {
			const data = _.cloneDeep(this.compareData);
			// 存放展平后的数据
			const extra = [];
			const extraIds = [];

			// 后端已返回对象类型，直接使用，无需 JSON 解析
			// 开始进行解压缩的逻辑 逻辑就是 先根据原来的备份信息 生成新的，这些新的给一个新的id 推入数组
			const finalResult = data.map(backlog => {
				// 处理 null 值：如果 originalInfo 或 changedInfo 为 null，则设为 null
				const ori = backlog.originalInfo === null ? null : _.cloneDeep(backlog.originalInfo);
				const chag = backlog.changedInfo === null ? null : _.cloneDeep(backlog.changedInfo);
				const originDataType = ori === null ? 'Null' : TypeUtils.prototype.checkType(ori);
				const changedDataType = chag === null ? 'Null' : TypeUtils.prototype.checkType(chag);
				// 创建新元素的创建函数
				const createNewBack = (element, isOri) => {
					let newBacklog = _.cloneDeep(backlog);
					newBacklog.originalInfo = isOri ? element : null;
					newBacklog.changedInfo = isOri ? null : element;
					newBacklog.id = backlog.id + getUuid();
					newBacklog.tableName = backlog.tableName;
					return newBacklog;
				};
				// 如果修改前和修改后的数据都是数组
				if (originDataType === 'Array' && changedDataType === 'Array') {
					if (ori.length > 0 && chag.length > 0) {
						// 分别将原信息和修改后信息推入
						ori.forEach(element => {
							const newBacklog = createNewBack(element, true);
							element && extra.push(newBacklog);
						});
						chag.forEach(element => {
							const newBacklog = createNewBack(element, false);
							element && extra.push(newBacklog);
						});
						extraIds.push(backlog.id);
					}
					return backlog;
				} else if (originDataType === 'Array' && changedDataType !== 'Array') {
					if (ori.length === 0) return backlog;
					ori.forEach(element => {
						const newBacklog = createNewBack(element, true);
						element && extra.push(newBacklog);
					});
					extraIds.push(backlog.id);
				} else if (originDataType !== 'Array' && changedDataType === 'Array') {
					if (chag.length === 0) return backlog;
					chag.forEach(element => {
						const newBacklog = createNewBack(element, false);
						element && extra.push(newBacklog);
					});
					extraIds.push(backlog.id);
				} else {
					return backlog;
				}
				return backlog;
			});
			// 推入新元素
			extra.forEach(newBacklog => {
				finalResult.push(newBacklog);
			});
			const totalResult = _.cloneDeep(finalResult);
			// 对数据进行筛选排序操作
			const actualResult = totalResult
				// 因为会无故根据老的带有数组属性的数据推入新的数据 所以需要把老信息删除
				.filter(backlog => !extraIds.includes(backlog.id))
				// 根据时间进行排序
				.sort((a, b) => {
					// 将 backupTime 转换为日期对象进行比较
					return new Date(a.backupTime) - new Date(b.backupTime);
				})
				.reverse();
			// 按 id + backupType + tableName 进行分组
			const groupKey = item => {
				const id = item.id;
				const backupType = item.backupType;
				const tableName = item.tableName;
				if (!id || !backupType || !tableName) {
					throw new Error(`分组字段缺失: id=${id}, backupType=${backupType}, tableName=${tableName}`);
				}
				return `${id}_${backupType}_${tableName}`;
			};
			return Object.entries(_.groupBy(actualResult, groupKey)).map(entries => _.groupBy(entries[1], item => item.tableName));
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
		},
		// 合并所有表格数据
		allMergedTableData() {
			if (!this.paginatedData || this.paginatedData.length === 0) {
				return [];
			}

			const allData = [];
			this.paginatedData.forEach((body, bodyIdx) => {
				const recordIndex = bodyIdx + (this.currentPage - 1) * this.pageSize + 1;
				const recordLabel = `${this.moduleNames[body.moduleName]}信息[${recordIndex}]`;
				const bodyData = this.getMergedTableData(body);

				bodyData.forEach((row, rowIdx) => {
					allData.push({
						...row,
						recordLabel: rowIdx === 0 ? recordLabel : '',
						recordIndex: bodyIdx,
						bodyRef: body,
						rowKey: `row-${bodyIdx}-${rowIdx}` // 添加唯一标识用于展开
					});
				});
			});

			return allData;
		},
		// 合并所有表格列配置
		allMergedTableColumns() {
			if (!this.paginatedData || this.paginatedData.length === 0) {
				return [];
			}

			const columnMap = new Map();
			this.paginatedData.forEach(body => {
				const columns = this.getMergedTableColumns(body);
				columns.forEach(col => {
					if (!columnMap.has(col.prop)) {
						columnMap.set(col.prop, col);
					}
				});
			});

			return Array.from(columnMap.values());
		},
		// 判断是否有订单明细数据需要展开
		hasOrderDetailList() {
			return this.moduleName === TableName.GOODS_ORDER && TableConfig[TableName.GOODS_ORDER]?.subTableField;
		},
		// 获取订单明细的列配置
		orderDetailColumns() {
			if (!this.hasOrderDetailList) return [];
			const subTableConfig = TableConfig[TableName.ORDER_DETAIL];
			if (!subTableConfig || !subTableConfig.mappers) return [];

			const mappers = subTableConfig.mappers || {};
			return Object.keys(mappers).map(key => ({
				prop: key,
				label: mappers[key],
				formatter: (row, column, cellValue) => {
					// 如果是差额行，使用 getDiffValue 方法格式化
					if (row.status === '差额') {
						return this.getDiffValue(row, key);
					}

					const value = cellValue;
					if (typeof subTableConfig.options !== 'function') {
						return value === null || typeof value === 'undefined' ? '-' : String(value);
					}
					try {
						const formattedValue = subTableConfig.options(key, value);
						return formattedValue === null || typeof formattedValue === 'undefined' ? '-' : formattedValue;
					} catch (error) {
						console.error(`格式化字段 ${key} 的值 ${value} 时出错:`, error);
						return value === null || typeof value === 'undefined' ? '-' : String(value);
					}
				}
			}));
		},
		// 获取数字列字段集合（用于合计计算）
		numericColumns() {
			if (!this.paginatedData || this.paginatedData.length === 0) return new Set();
			
			const numericFields = new Set();
			this.paginatedData.forEach(body => {
				// 从配置中获取需要计算的数字字段（params 中的字段）
				const config = TableConfig[body.moduleName];
				if (config && config.params) {
					config.params.forEach(param => {
						numericFields.add(param.name);
					});
				}
				// 如果有子表配置，也添加子表的数字字段
				if (body.multiModuleName) {
					const subConfig = TableConfig[body.multiModuleName];
					if (subConfig && subConfig.params) {
						subConfig.params.forEach(param => {
							numericFields.add(param.name);
						});
					}
				}
			});
			return numericFields;
		},
		// 获取订单明细的数字列字段集合（用于合计计算）
		orderDetailNumericColumns() {
			if (!this.hasOrderDetailList) return new Set();
			
			const subTableConfig = TableConfig[TableName.ORDER_DETAIL];
			if (!subTableConfig || !subTableConfig.params) return new Set();
			
			const numericFields = new Set();
			subTableConfig.params.forEach(param => {
				numericFields.add(param.name);
			});
			return numericFields;
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
		handleProcess() {
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		},
		// 判断是否应该显示订单明细（只在差额行显示）
		shouldShowOrderDetail(row) {
			return row && row.groupType === 'main' && row.status === '差额';
		},
		// 获取订单明细列表（包含修改前、修改后、差额）
		getOrderDetailList(row) {
			if (!this.hasOrderDetailList || !row || !row.itemRef || !this.shouldShowOrderDetail(row)) {
				return [];
			}

			// 只在差额行展开时显示明细差异
			if (row.status !== '差额') {
				return [];
			}

			const item = row.itemRef;
			const subTableField = TableConfig[TableName.GOODS_ORDER]?.subTableField || 'orderDetailList';
			const originalList = item.originalInfo?.[subTableField] || [];
			const changedList = item.changedInfo?.[subTableField] || [];
			const columns = this.orderDetailColumns;

			// 显示修改前、修改后和差额
			const result = [];
			const maxLength = Math.max(originalList.length, changedList.length);

			for (let i = 0; i < maxLength; i++) {
				const originalDetail = originalList[i] || {};
				const changedDetail = changedList[i] || {};
				const diff = this.calculateDifferences(originalDetail, changedDetail);

				// 显示修改前
				if (originalDetail && Object.keys(originalDetail).length > 0) {
					const originalRow = {
						status: '修改前',
						...originalDetail,
						itemRef: { originalInfo: originalDetail, changedInfo: null }
					};
					if (!this.isRowEmpty(originalRow, columns)) {
						result.push(originalRow);
					}
				}

				// 显示修改后
				if (changedDetail && Object.keys(changedDetail).length > 0) {
					const changedRow = {
						status: '修改后',
						...changedDetail,
						itemRef: { originalInfo: originalDetail, changedInfo: changedDetail }
					};
					if (!this.isRowEmpty(changedRow, columns)) {
						result.push(changedRow);
					}
				}

				// 显示差额（如果有差异）
				if (Object.keys(diff).length > 0) {
					const diffRow = {
						status: '差额',
						...diff,
						itemRef: { originalInfo: originalDetail, changedInfo: changedDetail }
					};
					const hasMeaningfulDiff = columns.some(col => {
						if (col.prop !== 'status') {
							return this.isMeaningfulDifference(diffRow[col.prop]);
						}
						return false;
					});
					if (hasMeaningfulDiff && !this.isRowEmpty(diffRow, columns)) {
						result.push(diffRow);
					}
				}
			}

			return result;
		},
		// --- 判断差异是否有意义 (用于决定是否高亮) ---
		isMeaningfulDifference(diffValue) {
			if (diffValue === null || diffValue === undefined) return false;
			if (typeof diffValue === 'number') return diffValue !== 0; // 数字差异不为0
			if (Array.isArray(diffValue)) return diffValue.length > 0; // 列表差异数组不为空 (calculateDifferences 已保证)
			// totalDiff 中可能标记为 '列表有变更'
			if (diffValue === '列表有变更') return true;
			if (diffValue === '[changed]') return true; // 明确标记为变更
			// 如果 diffValue 是对象（理论上不该直接出现在 diff 结果里，除非 calculateDifferences 改变），也视为有差异
			if (typeof diffValue === 'object' && Object.keys(diffValue).length > 0) return true;
			return false; // 其他情况（如空字符串等）视为无意义差异
		},
		// --- 获取并缓存差异属性集合 ---
		getAndCacheDiffProps(context, isSubInfo) {
			if (this.diffPropsCache.has(context)) {
				return this.diffPropsCache.get(context);
			}

			let diffData = {};
			if (isSubInfo) {
				// 计算子表的汇总差异 (totalDiff)
				if (!context || !Array.isArray(context)) {
					diffData = {}; // 无效 subInfo
				} else {
					const allDiffs = context.map(sub => {
						const original = sub?.originalInfo || {};
						const changed = sub?.changedInfo || {};
						// 确保 calculateDifferences 返回的是对象
						return this.calculateDifferences(original, changed) || {};
					});
					console.log('子表 allDiffs', allDiffs);
					// 使用之前的 totalDiff 计算逻辑
					diffData = allDiffs.reduce((acc, diff) => {
						Object.entries(diff).forEach(([key, diffValue]) => {
							const existingValue = acc[key];
							if (key === 'inventoryDetailList' && Array.isArray(diffValue) && diffValue.length > 0) {
								acc[key] = '列表有变更';
							} else if (typeof diffValue === 'number' && isFinite(diffValue)) {
								if (typeof existingValue === 'number' || existingValue === undefined) {
									acc[key] = (existingValue || 0) + diffValue;
								} // else 保持标记
							} else if (diffValue === '[changed]' || (typeof diffValue === 'object' && diffValue !== null && !Array.isArray(diffValue))) {
								// 标记为 changed 或列表有变更 优先
								if (existingValue !== '列表有变更') {
									acc[key] = '[changed]';
								}
							}
						});
						return acc;
					}, {});
				}
			} else {
				// 计算主表的差异 (diff)
				const original = context?.originalInfo || {};
				const changed = context?.changedInfo || {};
				diffData = this.calculateDifferences(original, changed) || {};
			}

			// 筛选出有意义差异的属性名
			const meaningfulDiffProps = Object.keys(diffData).filter(key => this.isMeaningfulDifference(diffData[key]));
			this.diffPropsCache.set(context, new Set(meaningfulDiffProps));
			return this.diffPropsCache.get(context);
		},
		// --- :cell-style 的包装处理函数 ---
		// 检查每行的数据的每一个单元格，并返回一个样式对象
		getCellStyleHandler(context, isSubInfo) {
			// 获取当前 context (item 或 sub_info) 的有差异的属性集合
			const diffProps = this.getAndCacheDiffProps(context, isSubInfo);

			// 返回 Element UI :cell-style 所期望的函数
			return ({ row, column, rowIndex, columnIndex }) => {
				// 检查当前列的属性名是否存在于差异集合中
				if (column.property && diffProps.has(column.property)) {
					// 如果是差异列，应用高亮背景色
					return { backgroundColor: HIGHLIGHT_COLOR };
				}
				// 否则，返回空对象或 null，表示使用默认样式
				return null;
			};
		},
		calculateProp(item) {
			const { backupType = '', backupTime = null } = item || {};
			const typeEnumMap = {
				[System_Option_Type.INSERT]: '新增',
				[System_Option_Type.DELETE]: '删除',
				[System_Option_Type.UPDATE]: '修改',
				default: '修改'
			};
			const _type = typeEnumMap[backupType] || typeEnumMap.default;
			return { time: backupTime, type: _type };
		},
		calculateDifferences(original = {}, changed = {}) {
			const diffs = {};
			const allKeys = new Set([...Object.keys(original), ...Object.keys(changed)]);
			allKeys.forEach(key => {
				if (key === 'inventoryDetailList') {
					const originalList = original[key] || [];
					const changedList = changed[key] || [];
					const listDiffs = this.calculateListDifferences(originalList, changedList);
					if (listDiffs.length > 0) {
						// calculateListDifferences 已保证非空
						diffs[key] = listDiffs;
					}
					return;
				}

				const origVal = original[key];
				const changedVal = changed[key];
				const normalizedOrigVal = origVal === null || typeof origVal === 'undefined' ? '' : origVal;
				const normalizedChangedVal = changedVal === null || typeof changedVal === 'undefined' ? '' : changedVal;

				if (typeof normalizedOrigVal === 'number' || typeof normalizedChangedVal === 'number') {
					const numOrig = Number(normalizedOrigVal) || 0;
					const numChanged = Number(normalizedChangedVal) || 0;
					if (numOrig !== numChanged) {
						diffs[key] = numChanged - numOrig;
					}
					return;
				}

				if (String(normalizedOrigVal) !== String(normalizedChangedVal)) {
					diffs[key] = '[changed]';
				}
			});
			return diffs;
		},
		calculateListDifferences(originalList = [], changedList = []) {
			const maxLength = Math.max(originalList.length, changedList.length);
			const diffs = [];
			for (let i = 0; i < maxLength; i++) {
				const orig = originalList[i] || {};
				const changed = changedList[i] || {};
				const itemDiff = this.calculateDifferences(orig, changed);
				if (Object.keys(itemDiff).length > 0) {
					diffs.push(itemDiff);
				}
			}
			return diffs.filter(d => Object.keys(d).length > 0);
		},
		getTableColumns(body, isDetail = false) {
			const moduleKey = isDetail ? body.multiModuleName : body.moduleName;
			if (!moduleKey || !TableConfig[moduleKey]) {
				console.warn(`未找到模块 ${moduleKey} 的表格配置。`);
				return [];
			}

			const config = TableConfig[moduleKey];
			const mappers = config.mappers || {};
			return Object.keys(mappers).map(key => ({
				prop: key,
				label: mappers[key],
				formatter: (row, column, cellValue, index) => {
					if (row.status === '差额') {
						return this.getDiffValue(row, key);
					}

					const value = cellValue;
					if (typeof config.options !== 'function') {
						return value === null || typeof value === 'undefined' ? '-' : String(value);
					}

					try {
						const formattedValue = config.options(key, value);
						return formattedValue === null || typeof formattedValue === 'undefined' ? '-' : formattedValue;
					} catch (error) {
						console.error(`格式化字段 ${key} 的值 ${value} 时出错:`, error);
						return value === null || typeof value === 'undefined' ? '-' : String(value);
					}
				}
			}));
		},
		getDiffValue(row, key) {
			const value = row ? row[key] : undefined;

			if (typeof value === 'number') {
				if (!isFinite(value)) return '-';
				return value > 0 ? `+${value.toFixed(2)}` : value.toFixed(2);
			}

			if (value === '[changed]') {
				return '有修改';
			}

			if (value === '列表有变更') {
				return '列表有变更';
			}

			if (Array.isArray(value)) {
				return value.length > 0 ? '列表有变更' : '-';
			}

			if (typeof value === 'object' && value !== null) {
				return Object.keys(value).length > 0 ? '对象有修改' : '-';
			}

			return '-';
		},
		isRowEmpty(row, columns) {
			return columns.every(col => {
				const value = row[col.prop];
				return value === null || value === undefined || value === '';
			});
		},
		getCombinedData(item, body) {
			const original = item?.originalInfo || {};
			const changed = item?.changedInfo || {};
			const operationType = this.calculateProp(item).type;
			const diff = this.calculateDifferences(original, changed);
			const columns = this.getTableColumns(body);

			const result = [];
			// 如果是新增操作，只显示新增行，不显示修改前和差额
			if (operationType === '新增') {
				const newRow = { status: '新增', ...changed };
				if (!this.isRowEmpty(newRow, columns)) {
					result.push(newRow);
				}
				return result;
			}
			// 如果是删除操作，只显示删除行，不显示修改前和差额
			if (operationType === '删除') {
				const deleteRow = { status: '删除', ...original };
				if (!this.isRowEmpty(deleteRow, columns)) {
					result.push(deleteRow);
				}
				return result;
			}
			// 非新增操作：显示修改前
			if (operationType !== '新增') {
				const originalRow = { status: '修改前', ...original };
				if (!this.isRowEmpty(originalRow, columns)) {
					result.push(originalRow);
				}
			}
			// 显示修改后
			const changedRow = { status: '修改后', ...changed };
			if (!this.isRowEmpty(changedRow, columns)) {
				result.push(changedRow);
			}
			// 显示差额（仅非新增操作）
			if (Object.keys(diff).length > 0) {
				const diffRow = { status: '差额', ...diff };
				// Check if the diff row (excluding status) has any meaningful difference
				const hasMeaningfulDiff = columns.some(col => {
					if (col.prop !== 'status') {
						return this.isMeaningfulDifference(diffRow[col.prop]);
					}
					return false;
				});
				if (hasMeaningfulDiff) {
					result.push(diffRow);
				}
			}
			return result;
		},
		getCombinedSubData(subItems, body) {
			if (!Array.isArray(subItems) || subItems.length === 0) {
				return [];
			}
			const operationType = this.calculateProp(subItems[0]).type;
			const columns = this.getTableColumns(body, true);
			const allRows = [];

			// 如果是新增操作，只显示新增行，不显示修改前和差额
			if (operationType === '新增') {
				subItems.forEach(sub => {
					const newRow = { status: '新增', ...(sub?.changedInfo || {}) };
					if (!this.isRowEmpty(newRow, columns)) {
						allRows.push(newRow);
					}
				});
				return allRows;
			}

			// 非新增操作：显示修改前
			if (operationType !== '新增') {
				subItems.forEach(sub => {
					const originalRow = { status: '修改前', ...(sub?.originalInfo || {}) };
					if (!this.isRowEmpty(originalRow, columns)) {
						allRows.push(originalRow);
					}
				});
			}
			// 显示修改后
			subItems.forEach(sub => {
				const changedRow = { status: '修改后', ...(sub?.changedInfo || {}) };
				if (!this.isRowEmpty(changedRow, columns)) {
					allRows.push(changedRow);
				}
			});

			// 显示差额（仅非新增操作）
			const allDiffs = subItems.map(sub => this.calculateDifferences(sub?.originalInfo || {}, sub?.changedInfo || {}));
			const totalDiff = allDiffs.reduce((acc, diff) => {
				Object.entries(diff).forEach(([key, diffValue]) => {
					const existingValue = acc[key];
					if (key === 'inventoryDetailList' && Array.isArray(diffValue) && diffValue.length > 0) {
						acc[key] = '列表有变更';
					} else if (typeof diffValue === 'number' && isFinite(diffValue)) {
						if (typeof existingValue === 'number' || existingValue === undefined) {
							acc[key] = (existingValue || 0) + diffValue;
						}
					} else if (diffValue === '[changed]' || (typeof diffValue === 'object' && diffValue !== null && !Array.isArray(diffValue))) {
						if (existingValue !== '列表有变更') {
							acc[key] = '[changed]';
						}
					}
				});
				return acc;
			}, {});

			const diffRow = { status: '差额', ...totalDiff };
			const hasMeaningfulDiff = columns.some(col => {
				if (col.prop !== 'status') {
					return this.isMeaningfulDifference(diffRow[col.prop]);
				}
				return false;
			});
			if (Object.keys(totalDiff).length > 0 && hasMeaningfulDiff) {
				if (!this.isRowEmpty(diffRow, columns)) {
					allRows.push(diffRow);
				}
			}

			return allRows;
		},
		// 获取合并后的表格数据
		getMergedTableData(body) {
			if (!body) {
				return [];
			}

			const mergedData = [];

			// 处理主信息
			const mainItems = body.main_info?.items || body.main_info?.data || [];
			if (Array.isArray(mainItems)) {
				mainItems.forEach((item, itemIdx) => {
					if (!item) return;

					const mainRows = this.getCombinedData(item, body) || [];
					mainRows.forEach((row, rowIdx) => {
						if (!row) return;

						mergedData.push({
							...row,
							groupLabel: rowIdx === 0 ? this.moduleNames[body.moduleName] || '' : '',
							groupType: 'main',
							groupIndex: itemIdx,
							itemRef: item,
							rowIndexInGroup: rowIdx
						});
					});
				});
			}

			// 处理子信息
			if (body.sub_info && Array.isArray(body.sub_info) && body.sub_info.length > 0) {
				const subRows = this.getCombinedSubData(body.sub_info, body) || [];
				subRows.forEach((row, rowIdx) => {
					if (!row) return;

					mergedData.push({
						...row,
						groupLabel: rowIdx === 0 ? this.moduleNames[body.multiModuleName] || '' : '',
						groupType: 'sub',
						groupIndex: 0,
						itemRef: body.sub_info,
						rowIndexInGroup: rowIdx
					});
				});
			}

			return mergedData;
		},
		// 获取合并后的表格列配置
		getMergedTableColumns(body) {
			const mainColumns = this.getTableColumns(body, false);
			const subColumns = body.sub_info && body.sub_info.length > 0 ? this.getTableColumns(body, true) : [];

			// 合并列，去重
			const columnMap = new Map();
			mainColumns.forEach(col => {
				columnMap.set(col.prop, col);
			});
			subColumns.forEach(col => {
				if (!columnMap.has(col.prop)) {
					columnMap.set(col.prop, col);
				}
			});

			return Array.from(columnMap.values());
		},
		// 单元格合并方法
		getSpanMethod(row, column, rowIndex, columnIndex, body) {
			// 如果 row 不存在，返回默认值
			if (!row) {
				return {
					rowspan: 1,
					colspan: 1
				};
			}

			// 第一列（组别列）需要合并相同组的数据
			if (columnIndex !== 0) {
				return {
					rowspan: 1,
					colspan: 1
				};
			}

			// 只在每个组的第一行显示组标签
			if (row.rowIndexInGroup !== 0) {
				return {
					rowspan: 0,
					colspan: 0
				};
			}

			const mergedData = this.getMergedTableData(body);
			let rowspan = 1;

			// 向后查找相同组的行数
			for (let i = rowIndex + 1; i < mergedData.length; i++) {
				const nextRow = mergedData[i];
				if (nextRow && nextRow.groupType === row.groupType && nextRow.groupIndex === row.groupIndex) {
					rowspan++;
				} else {
					break;
				}
			}

			return {
				rowspan: rowspan,
				colspan: 1
			};
		},
		// 获取合并表格的单元格样式
		getMergedCellStyle({ row, column, rowIndex, columnIndex }) {
			// 如果 row 不存在，返回 null
			if (!row) {
				return null;
			}

			// 如果是组别列，不需要高亮
			if (columnIndex === 0) {
				return null;
			}

			// 根据 row 中的 itemRef 来判断是否需要高亮
			if (row.groupType === 'main' && row.itemRef) {
				const handler = this.getCellStyleHandler(row.itemRef, false);
				return handler ? handler({ row, column, rowIndex, columnIndex }) : null;
			}

			if (row.groupType === 'sub' && row.itemRef) {
				const handler = this.getCellStyleHandler(row.itemRef, true);
				return handler ? handler({ row, column, rowIndex, columnIndex }) : null;
			}

			return null;
		},
		// 所有数据的单元格合并方法
		getAllSpanMethod({ row, column, rowIndex, columnIndex }) {
			if (!row) {
				return { rowspan: 1, colspan: 1 };
			}

			// 第一列（记录列）需要合并相同记录的数据
			if (columnIndex !== 0) {
				return {
					rowspan: 1,
					colspan: 1
				};
			}

			if (row.rowIndexInGroup !== 0 || row.groupIndex !== 0) {
				return {
					rowspan: 0,
					colspan: 0
				};
			}

			const allData = this.allMergedTableData;
			let rowspan = 1;

			// 向后查找相同记录的所有行数
			for (let i = rowIndex + 1; i < allData.length; i++) {
				const nextRow = allData[i];
				if (nextRow && nextRow.recordIndex === row.recordIndex) {
					rowspan++;
				} else {
					break;
				}
			}

			return {
				rowspan: rowspan,
				colspan: 1
			};
		},
		// 所有数据的单元格样式
		getAllMergedCellStyle({ row, column, rowIndex, columnIndex }) {
			// 如果 row 不存在，返回 null
			if (!row) {
				return null;
			}

			// 如果是记录列，不需要高亮
			if (columnIndex === 0) {
				return null;
			}

			// 根据 row 中的 itemRef 来判断是否需要高亮
			if (row.groupType === 'main' && row.itemRef) {
				const handler = this.getCellStyleHandler(row.itemRef, false);
				return handler ? handler({ row, column, rowIndex, columnIndex }) : null;
			}

			if (row.groupType === 'sub' && row.itemRef) {
				const handler = this.getCellStyleHandler(row.itemRef, true);
				return handler ? handler({ row, column, rowIndex, columnIndex }) : null;
			}

			return null;
		},
		// 合计行计算方法
		getSummaryMethod({ columns, data }) {
			const sums = [];
			const numericFields = this.numericColumns;
			
			columns.forEach((column, index) => {
				// 第一列（记录列）显示"合计"
				if (index === 0) {
					sums[index] = '合计';
					return;
				}
				
				// 展开列、状态列不计算合计
				if (column.type === 'expand' || column.property === 'status') {
					sums[index] = '';
					return;
				}

				const property = column.property;
				if (!property) {
					sums[index] = '';
					return;
				}

				// 判断是否为数字列
				const isNumeric = numericFields.has(property);
				
				if (!isNumeric) {
					sums[index] = '';
					return;
				}

				// 计算数字列的合计
				const values = data
					.map(item => {
						// 只对"修改后"和"新增"状态的数据进行合计，跳过"修改前"、"删除"、"差额"
						if (item.status === '修改前' || item.status === '删除' || item.status === '差额') {
							return null;
						}
						const value = item[property];
						// 转换为数字
						if (value === null || value === undefined || value === '') {
							return null;
						}
						const numValue = Number(value);
						return isFinite(numValue) ? numValue : null;
					})
					.filter(val => val !== null);

				if (values.length === 0) {
					sums[index] = '';
				} else {
					const sum = values.reduce((prev, curr) => {
						return prev + curr;
					}, 0);
					// 保留2位小数
					sums[index] = sum.toFixed(2);
				}
			});

			// 第一列显示"合计"
			sums[0] = '合计';
			return sums;
		},
		// 订单明细表格合计行计算方法
		getOrderDetailSummaryMethod({ columns, data }) {
			const sums = [];
			const numericFields = this.orderDetailNumericColumns;
			
			columns.forEach((column, index) => {
				// 第一列显示"合计"
				if (index === 0) {
					sums[index] = '合计';
					return;
				}

				const property = column.property;
				if (!property) {
					sums[index] = '';
					return;
				}

				// 判断是否为数字列
				const isNumeric = numericFields.has(property);
				
				if (!isNumeric) {
					sums[index] = '';
					return;
				}

				// 计算数字列的合计
				const values = data
					.map(item => {
						// 只对"修改后"和"新增"状态的数据进行合计，跳过"修改前"、"删除"、"差额"
						if (item.status === '修改前' || item.status === '删除' || item.status === '差额') {
							return null;
						}
						const value = item[property];
						// 转换为数字
						if (value === null || value === undefined || value === '') {
							return null;
						}
						const numValue = Number(value);
						return isFinite(numValue) ? numValue : null;
					})
					.filter(val => val !== null);

				if (values.length === 0) {
					sums[index] = '';
				} else {
					const sum = values.reduce((prev, curr) => {
						return prev + curr;
					}, 0);
					// 保留2位小数
					sums[index] = sum.toFixed(2);
				}
			});

			return sums;
		},
		// 订单明细表格单元格样式（用于高亮差异）
		getOrderDetailCellStyle({ row, column, rowIndex, columnIndex }) {
			if (!row || !row.itemRef) {
				return null;
			}

			// 如果是差额行，不需要高亮
			if (row.status === '差额') {
				return null;
			}

			// 获取差异属性集合
			const diffProps = this.getAndCacheDiffProps(row.itemRef, false);

			// 检查当前列的属性名是否存在于差异集合中
			if (column.property && diffProps.has(column.property)) {
				// 如果是差异列，应用高亮背景色
				return { backgroundColor: HIGHLIGHT_COLOR };
			}

			return null;
		},
		// 获取行的 class 名称（用于控制展开图标的显示）
		getRowClassName({ row, rowIndex }) {
			// 只有差额行才显示展开图标
			if (row && row.status === '差额' && this.hasOrderDetailList && row.groupType === 'main') {
				return 'expandable-row';
			}
			return 'non-expandable-row';
		},
		// 获取所有数据的合并表格数据（用于导出）
		getAllMergedTableDataForExport() {
			if (!this.bodyData || this.bodyData.length === 0) {
				return [];
			}

			const allData = [];
			this.bodyData.forEach((body, bodyIdx) => {
				const recordIndex = bodyIdx + 1;
				const recordLabel = `${this.moduleNames[body.moduleName]}信息[${recordIndex}]`;
				const bodyData = this.getMergedTableData(body);

				bodyData.forEach((row, rowIdx) => {
					if (!row) return;

					allData.push({
						...row,
						recordLabel: rowIdx === 0 ? recordLabel : '',
						recordIndex: bodyIdx,
						bodyRef: body
					});
				});
			});

			return allData;
		},
		// 获取所有数据的合并表格列配置（用于导出）
		getAllMergedTableColumnsForExport() {
			if (!this.bodyData || this.bodyData.length === 0) {
				return [];
			}

			const columnMap = new Map();
			this.bodyData.forEach(body => {
				const columns = this.getMergedTableColumns(body);
				columns.forEach(col => {
					if (!columnMap.has(col.prop)) {
						columnMap.set(col.prop, col);
					}
				});
			});

			return Array.from(columnMap.values());
		},
		// 导出Excel
		handleExport() {
			try {
				// 获取所有数据（不仅仅是当前页）
				const allData = this.getAllMergedTableDataForExport();
				const allColumns = this.getAllMergedTableColumnsForExport();

				if (allData.length === 0) {
					this.$message.warning('暂无数据可导出');
					return;
				}

				// 构建表头：记录、状态 + 动态列
				const headers = ['记录', '状态'];
				allColumns.forEach(col => {
					headers.push(col.label);
				});

				// 构建数据行
				const rows = allData.map(row => {
					const rowData = [row.recordLabel || '', row.status || ''];
					allColumns.forEach(col => {
						// 使用 formatter 格式化数据
						let cellValue = row[col.prop];
						if (col.formatter) {
							try {
								cellValue = col.formatter(row, { property: col.prop }, cellValue, 0);
							} catch (error) {
								console.error(`格式化字段 ${col.prop} 时出错:`, error);
								cellValue = cellValue === null || typeof cellValue === 'undefined' ? '-' : String(cellValue);
							}
						} else {
							cellValue = cellValue === null || typeof cellValue === 'undefined' ? '-' : String(cellValue);
						}
						rowData.push(cellValue);
					});
					return rowData;
				});

				// 创建工作表数据
				const worksheetData = [headers, ...rows];

				// 创建工作表
				const worksheet = XLSX.utils.aoa_to_sheet(worksheetData);

				// 设置列宽
				const colWidths = headers.map((header, index) => {
					// 记录列和状态列设置固定宽度
					if (index === 0) return { wch: 25 }; // 记录列
					if (index === 1) return { wch: 12 }; // 状态列
					return { wch: 15 }; // 其他列
				});
				worksheet['!cols'] = colWidths;

				// 创建工作簿
				const workbook = XLSX.utils.book_new();
				const sheetName = this.moduleNames[this.moduleName] || '模块修改记录';
				XLSX.utils.book_append_sheet(workbook, worksheet, sheetName);

				// 生成文件名
				const now = new Date();
				const dateStr = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(now.getDate()).padStart(2, '0')}_${String(now.getHours()).padStart(2, '0')}${String(now.getMinutes()).padStart(2, '0')}${String(now.getSeconds()).padStart(2, '0')}`;
				const fileName = `${sheetName}_${dateStr}.xlsx`;

				// 下载文件
				XLSX.writeFile(workbook, fileName);
				this.$message.success('导出成功');
			} catch (error) {
				console.error('导出Excel失败:', error);
				this.$message.error('导出失败，请重试');
			}
		}
	}
};
</script>

<style scoped lang="scss">
/* 保持原有的样式，或者根据需要添加新的样式 */
.pagination-controls {
	display: flex;
	align-items: center;
	margin-bottom: 10px;
}

.pagination-controls .el-button,
.pagination-controls .el-input {
	margin-right: 5px;
}

.page-info {
	margin: 0 10px;
}

.scroll-area {
	max-height: 600px; /* 可以根据需要调整最大高度 */
	overflow-y: auto;
	border: 1px solid #e0e0e0;
	padding: 10px;
}

.no-data {
	text-align: center;
	color: #999;
	padding: 20px;
}

.bottom-controls {
	margin-top: 10px;
	justify-content: center; /* 底部控制栏居中 */
}

.bottom-controls .page-info {
	margin: 0 20px; /* 底部页码信息增加左右间距 */
}

.el-table {
	margin-bottom: 10px;
}

.el-table th,
.el-table td {
	text-align: center;
}

.el-table th {
	background-color: #e8e5e5;
}

header > span > span {
	padding: 2px 4px;
	border-radius: 3px;
	margin-left: 4px;
}

// 订单明细展开区域样式
.order-detail-expand-wrapper {
	padding: 0;
	margin: 0;
}

.order-detail-expand {
	padding: 10px 20px;
	background-color: #f5f7fa;
}

.detail-title {
	font-size: 14px;
	font-weight: bold;
	color: #303133;
	margin-bottom: 10px;
	padding: 8px 0;
	border-bottom: 1px solid #e4e7ed;
}

.order-detail-expand .el-table {
	background-color: #fff;
}

.no-detail-data {
	padding: 20px;
	text-align: center;
	color: #909399;
	font-size: 14px;
}

// 调整展开行的显示
::v-deep .el-table__expanded-cell {
	padding: 0 !important;
}

// 展开行中，第一列（记录列）保持正常显示，其他列隐藏
::v-deep .el-table__body-wrapper .el-table__body tr.el-table__expanded-row {
	td:first-child {
		display: table-cell;
		padding: 8px;
		text-align: center;
		border: 1px solid #dfe6ec;
	}
	// 展开列（第二列）显示展开内容
	td:nth-child(2) {
		display: table-cell;
		padding: 0;
	}
	// 其他列隐藏
	td:not(:first-child):not(:nth-child(2)) {
		display: none;
	}
}

// 隐藏非差额行的展开图标
::v-deep .non-expandable-row {
	.el-table__expand-column .el-table__expand-icon {
		display: none !important;
	}
}

// 显示差额行的展开图标并居中
::v-deep .expandable-row {
	.el-table__expand-column {
		text-align: center;
		.el-table__expand-icon {
			display: inline-block;
		}
	}
}

// 确保展开列内容居中
::v-deep .el-table__expand-column {
	text-align: center;
	.cell {
		text-align: center;
		display: flex;
		justify-content: center;
		align-items: center;
	}
}
</style>
