<template>
	<div>
		<div v-if="body.moduleName === TableName.GOODS_ORDER || body.moduleName === TableName.INVENTORMAIN">
			<h3>{{ moduleNames[body.moduleName] }}信息[{{ index + 1 }}]</h3>
			<el-divider />

			<!--      循环主信息-->
			<div v-for="(item, idx) in body.main_info.items" :key="idx" style="padding-bottom: 40px">
				<header>
					<span style="font-weight: bold; font-size: 14px; color: #555353">
						操作类型:
						<span :style="typeStyle(calculateProp(item).type)">[{{ calculateProp(item).type }}]</span>
					</span>
					<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #4a4949">
						操作时间:
						<span>{{ calculateProp(item).time }}</span>
					</span>
					<el-button type="primary" size="mini" @click="saveAsJson(item, 'main')">保存为JSON</el-button>
				</header>
				<section>
					<el-table :data="getCombinedData(item)" :cell-style="getCellStyleHandler(item, false)" style="width: 100%" border>
						<el-table-column label="状态" width="120" align="center">
							<template slot-scope="scope">
								<span>{{ scope.row.status }}</span>
							</template>
						</el-table-column>
						<el-table-column v-for="col in getTableColumns()" :key="col.prop" :prop="col.prop" :label="col.label" :formatter="col.formatter" align="center" />
					</el-table>
				</section>
			</div>
			<div v-if="body.sub_info && body.sub_info.length > 0" style="margin-bottom: 40px">
				<h4>[{{ moduleNames[body.multiModuleName] }}]</h4>
				<el-divider />
				<header>
					<span style="font-weight: bold; font-size: 14px; color: #555353">
						操作类型:
						<span :style="typeStyle(calculateProp(body.sub_info[0]).type)">[{{ calculateProp(body.sub_info[0]).type }}]</span>
					</span>
					<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #4a4949">
						操作时间:
						<span>{{ calculateProp(body.sub_info[0]).time }}</span>
					</span>
					<el-button type="primary" size="mini" @click="saveAsJson(body.sub_info, 'sub')">保存为JSON</el-button>
				</header>
				<section>
					<el-table :data="getCombinedSubData(body.sub_info)" :cell-style="getCellStyleHandler(body.sub_info, true)" style="width: 100%" border>
						<el-table-column label="状态" width="120" align="center">
							<template slot-scope="scope">
								<span>{{ scope.row.status }}</span>
							</template>
						</el-table-column>
						<el-table-column v-for="col in getTableColumns(true)" :key="col.prop" :prop="col.prop" :label="col.label" :formatter="col.formatter" align="center" />
					</el-table>
				</section>
			</div>
		</div>
		<div v-else>
			<h3>{{ moduleNames[body.moduleName] }}[信息{{ index + 1 }}]</h3>
			<div v-for="(item, idx) in body.main_info.data" :key="idx" style="margin-bottom: 40px">
				<header>
					<span style="font-weight: bold; font-size: 14px; color: #555353">
						操作类型:
						<span :style="typeStyle(calculateProp(item).type)">[{{ calculateProp(item).type }}]</span>
					</span>
					<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #4a4949">
						操作时间:
						<span>{{ calculateProp(item).time }}</span>
					</span>
					<el-button type="primary" size="mini" @click="saveAsJson(item, 'main')">保存为JSON</el-button>
				</header>
				<section>
					<el-table :data="getCombinedData(item)" :cell-style="getCellStyleHandler(item, false)" style="width: 100%" border>
						<el-table-column label="状态" width="120" align="center">
							<template slot-scope="scope">
								<span>{{ scope.row.status }}</span>
							</template>
						</el-table-column>
						<el-table-column v-for="col in getTableColumns()" :key="col.prop" :prop="col.prop" :label="col.label" :formatter="col.formatter" align="center" />
					</el-table>
				</section>
			</div>
		</div>
	</div>
</template>

<script>
import { TableConfig } from '@/views/dashboard/backuplog/backup.config';
import { moduleNames, System_Option_Type, TableName } from '@/api/tool/enums';
import _ from 'lodash';

// 定义高亮背景色
const HIGHLIGHT_COLOR = '#fff3cd'; // 一个淡黄色，类似 Bootstrap 的 warning 背景色

export default {
	name: 'FlexTable',
	props: {
		index: {
			type: Number,
			default: 0
		},
		body: {
			type: Object,
			default: () => ({
				/* ... 默认值 ... */
			})
		}
	},
	// --- 新增：使用 data 存储 WeakMap 缓存 ---
	data() {
		return {
			// 使用 WeakMap 来缓存差异属性，键是 item 或 sub_info 对象，值是 Set<string>
			// WeakMap 的好处是当 item/sub_info 对象不再被引用时，缓存会自动清理，避免内存泄漏
			diffPropsCache: new WeakMap()
		};
	},
	computed: {
		moduleNames() {
			return moduleNames;
		},
		TableName() {
			return TableName;
		}
	},
	methods: {
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
			if (!this.diffPropsCache.has(context)) {
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
			}
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

		// --- 其他方法 (calculateProp, typeStyle, calculateDifferences, etc.) 保持不变 ---
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
		typeStyle(type) {
			switch (type) {
				case '新增':
					return { backgroundColor: '#f0f9eb', color: '#67c23a' };
				case '修改':
					return { backgroundColor: '#ecf5ff', color: '#409eff' };
				case '删除':
					return { backgroundColor: '#fef0f0', color: '#f56c6c' };
				default:
					return { backgroundColor: '#f4f4f5', color: '#909399' };
			}
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
				} else if (String(normalizedOrigVal) !== String(normalizedChangedVal)) {
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
		getTableColumns(isDetail = false) {
			const moduleKey = isDetail ? this.body.multiModuleName : this.body.moduleName;
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
					if (typeof config.options === 'function') {
						try {
							const formattedValue = config.options(key, value);
							return formattedValue === null || typeof formattedValue === 'undefined' ? '-' : formattedValue;
						} catch (error) {
							console.error(`格式化字段 ${key} 的值 ${value} 时出错:`, error);
							return value === null || typeof value === 'undefined' ? '-' : String(value);
						}
					} else {
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
			} else if (value === '[changed]') {
				return '有修改';
			} else if (value === '列表有变更') {
				return '列表有变更';
			} else if (Array.isArray(value)) {
				return value.length > 0 ? '列表有变更' : '-';
			} else if (typeof value === 'object' && value !== null) {
				return Object.keys(value).length > 0 ? '对象有修改' : '-';
			} else if (value === null || typeof value === 'undefined' || value === '') {
				return '-';
			} else {
				return '-';
			}
		},
		isRowEmpty(row, columns) {
			return columns.every(col => {
				const value = row[col.prop];
				return value === null || value === undefined || value === '';
			});
		},
		getCombinedData(item) {
			const original = item?.originalInfo || {};
			const changed = item?.changedInfo || {};
			const operationType = this.calculateProp(item).type;
			const diff = this.calculateDifferences(original, changed);
			const columns = this.getTableColumns();

			const result = [];
			if (operationType !== '新增') {
				const originalRow = { status: '修改前', ...original };
				if (!this.isRowEmpty(originalRow, columns)) {
					result.push(originalRow);
				}
			}
			const changedRow = { status: '修改后', ...changed };
			if (!this.isRowEmpty(changedRow, columns)) {
				result.push(changedRow);
			}
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
		getCombinedSubData(subItems) {
			if (!Array.isArray(subItems) || subItems.length === 0) {
				return [];
			}
			const operationType = this.calculateProp(subItems[0]).type;
			const columns = this.getTableColumns(true);
			const allRows = [];

			if (operationType !== '新增') {
				subItems.forEach(sub => {
					const originalRow = { status: '修改前', ...(sub?.originalInfo || {}) };
					if (!this.isRowEmpty(originalRow, columns)) {
						allRows.push(originalRow);
					}
				});
			}
			subItems.forEach(sub => {
				const changedRow = { status: '修改后', ...(sub?.changedInfo || {}) };
				if (!this.isRowEmpty(changedRow, columns)) {
					allRows.push(changedRow);
				}
			});

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
		saveAsJson(data, type) {
			try {
				if (data === null || typeof data === 'undefined' || (Array.isArray(data) && data.length === 0) || (typeof data === 'object' && !Array.isArray(data) && Object.keys(data).length === 0)) {
					console.warn('尝试保存的数据为空或无效');
					this.$message?.warning('没有可保存的数据。');
					return;
				}
				const jsonData = JSON.stringify(data, null, 2);
				const blob = new Blob([jsonData], { type: 'application/json;charset=utf-8' });
				const url = URL.createObjectURL(blob);
				const a = document.createElement('a');
				a.href = url;
				const moduleNameStr = String(this.body.moduleName || 'unknown_module').replace(/[^a-z0-9]/gi, '_');
				const typeStr = String(type).replace(/[^a-z0-9]/gi, '_');
				const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
				a.download = `${moduleNameStr}_${typeStr}_${timestamp}.json`;
				document.body.appendChild(a);
				a.click();
				document.body.removeChild(a);
				URL.revokeObjectURL(url);
			} catch (error) {
				console.error('保存为 JSON 时出错:', error);
				this.$message?.error('保存文件失败，请检查数据或联系管理员。');
			}
		}
	}
};
</script>

<style scoped lang="scss">
/* ... (样式基本不变, 可以按需调整高亮颜色) ... */
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
</style>
