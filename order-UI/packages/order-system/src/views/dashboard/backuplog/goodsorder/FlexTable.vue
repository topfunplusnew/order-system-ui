<template>
	<div>
		<!-- 根据模块名称 (GOODS_ORDER 或 INVENTORMAIN) 区分渲染逻辑 -->
		<div v-if="body.moduleName === TableName.GOODS_ORDER || body.moduleName === TableName.INVENTORMAIN">
			<h3>{{ moduleNames[body.moduleName] }}信息[{{ index + 1 }}]</h3>
			<el-divider />
			<!-- 遍历主信息中的项目 -->
			<div v-for="(item, idx) in body.main_info.items" :key="idx" style="padding-bottom: 40px">
				<header>
					<!-- 显示操作类型和对应样式 -->
					<span style="font-weight: bold; font-size: 14px; color: #555353">
						操作类型:
						<span :style="typeStyle(calculateProp(item).type)">[{{ calculateProp(item).type }}]</span>
					</span>
					<!-- 显示操作时间 -->
					<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #4a4949">
						操作时间:
						<span>{{ calculateProp(item).time }}</span>
					</span>
					<!-- 保存为 JSON 按钮 -->
					<el-button type="primary" size="mini" @click="saveAsJson(item, 'main')">保存为JSON</el-button>
				</header>
				<section>
					<!-- 主信息表格: 移除了 :cell-style="getDifferenceCellStyle" 以去掉差额高亮 -->
					<el-table :data="getCombinedData(item)" style="width: 100%" border>
						<!-- 状态列 -->
						<el-table-column label="状态" width="120" align="center">
							<template slot-scope="scope">
								<span>{{ scope.row.status }}</span>
							</template>
						</el-table-column>
						<!-- 动态生成的列 -->
						<el-table-column v-for="col in getTableColumns()" :key="col.prop" :prop="col.prop" :label="col.label" :formatter="col.formatter" align="center" />
					</el-table>
				</section>
			</div>
			<!-- 如果存在子表信息 -->
			<div v-if="body.sub_info" style="margin-bottom: 40px">
				<h4>[{{ moduleNames[body.multiModuleName] }}]</h4>
				<el-divider />
				<header>
					<!-- 显示子表操作类型和样式 -->
					<span style="font-weight: bold; font-size: 14px; color: #555353">
						操作类型:
						<span :style="typeStyle(calculateProp(body.sub_info[0]).type)">[{{ calculateProp(body.sub_info[0]).type }}]</span>
					</span>
					<!-- 显示子表操作时间 -->
					<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #4a4949">
						操作时间:
						<span>{{ calculateProp(body.sub_info[0]).time }}</span>
					</span>
					<!-- 子表数据保存为 JSON 按钮 -->
					<el-button type="primary" size="mini" @click="saveAsJson(body.sub_info, 'sub')">保存为JSON</el-button>
				</header>
				<section>
					<!-- 子信息表格: 移除了 :cell-style="getDifferenceCellStyle" 以去掉差额高亮 -->
					<el-table :data="getCombinedSubData(body.sub_info)" style="width: 100%" border>
						<!-- 状态列 -->
						<el-table-column label="状态" width="120" align="center">
							<template slot-scope="scope">
								<span>{{ scope.row.status }}</span>
							</template>
						</el-table-column>
						<!-- 动态生成的子表列 -->
						<el-table-column v-for="col in getTableColumns(true)" :key="col.prop" :prop="col.prop" :label="col.label" :formatter="col.formatter" align="center" />
					</el-table>
				</section>
			</div>
		</div>
		<!-- 处理其他模块 (非 GOODS_ORDER 或 INVENTORMAIN) -->
		<div v-else>
			<h3>{{ moduleNames[body.moduleName] }}[信息{{ index + 1 }}]</h3>
			<!-- 遍历其他模块的主信息数据 -->
			<div v-for="(item, idx) in body.main_info.data" :key="idx" style="margin-bottom: 40px">
				<header>
					<!-- 显示操作类型和对应样式 -->
					<span style="font-weight: bold; font-size: 14px; color: #555353">
						操作类型:
						<span :style="typeStyle(calculateProp(item).type)">[{{ calculateProp(item).type }}]</span>
					</span>
					<!-- 显示操作时间 -->
					<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #4a4949">
						操作时间:
						<span>{{ calculateProp(item).time }}</span>
					</span>
					<!-- 保存为 JSON 按钮 -->
					<el-button type="primary" size="mini" @click="saveAsJson(item, 'main')">保存为JSON</el-button>
				</header>
				<section>
					<!-- 其他模块表格: 移除了 :cell-style="getDifferenceCellStyle" 以去掉差额高亮 -->
					<el-table :data="getCombinedData(item)" style="width: 100%" border>
						<!-- 状态列 -->
						<el-table-column label="状态" width="120" align="center">
							<template slot-scope="scope">
								<span>{{ scope.row.status }}</span>
							</template>
						</el-table-column>
						<!-- 动态生成的列 -->
						<el-table-column v-for="col in getTableColumns()" :key="col.prop" :prop="col.prop" :label="col.label" :formatter="col.formatter" align="center" />
					</el-table>
				</section>
			</div>
		</div>
	</div>
</template>

<script>
import { TableConfig } from '@/views/dashboard/backuplog/backup.config'; // 表格列配置
import { moduleNames, System_Option_Type, TableName } from '@/api/tool/enums'; // 枚举值，如模块名、操作类型等
import _ from 'lodash';

export default {
	name: 'FlexTable',
	// 组件属性定义
	props: {
		// 当前信息项的索引
		index: {
			type: Number,
			default: 0
		},
		// 主要数据对象，包含模块名、主信息、子信息等
		body: {
			type: Object,
			// 提供一个默认的空结构，防止访问 undefined 属性出错
			default: () => {
				return {
					moduleName: null,
					isMulti: true,
					isAdjust: true,
					main_info: {
						data: {}, // 其他模块使用
						items: [] //特定模块 GOODS_ORDER 或 INVENTORMAIN 使用
					},
					sub_info: null, // 子表信息，可能不存在
					multiModuleName: null, // 子表对应的模块名
					params: [],
					extraParams: [],
					extraInfo: {
						_: ''
					}
				};
			}
		}
	},
	// 计算属性
	computed: {
		// 获取模块名枚举，方便模板中使用
		moduleNames() {
			return moduleNames;
		},
		// 获取表名枚举
		TableName() {
			return TableName;
		}
	},
	// 组件方法
	methods: {
		/**
		 * @description 计算并格式化操作类型和操作时间
		 * @param {Object} item - 数据项，包含 backupType 和 backupTime
		 * @returns {Object} 包含格式化后的 time 和 type 的对象
		 */
		calculateProp(item) {
			// 提供默认值，防止 item 为 null 或 undefined 时出错
			const { backupType = '', backupTime = null } = item || {};
			// 定义操作类型的中文映射 (备用)
			const typeMap = {
				insert: '新增',
				delete: '删除',
				default: '修改'
			};
			// 使用 System_Option_Type 枚举进行映射，更健壮
			const typeEnumMap = {
				[System_Option_Type.INSERT]: '新增',
				[System_Option_Type.DELETE]: '删除',
				[System_Option_Type.UPDATE]: '修改',
				default: '修改' // 为未知类型提供默认值
			};
			// 优先使用枚举映射，其次尝试字符串映射，最后使用默认值
			const _type = typeEnumMap[backupType] || typeMap[backupType] || typeEnumMap.default;
			return {
				time: backupTime, // 操作时间
				type: _type // 操作类型 (新增/修改/删除)
			};
		},

		/**
		 * @description 根据操作类型返回不同的背景和文字颜色样式
		 * @param {String} type - 操作类型 (中文，如 '新增', '修改', '删除')
		 * @returns {Object} CSS 样式对象
		 */
		typeStyle(type) {
			// 根据中文类型名判断
			switch (type) {
				case '新增':
					return { backgroundColor: '#f0f9eb', color: '#67c23a' }; // Element UI success 颜色
				case '修改':
					return { backgroundColor: '#ecf5ff', color: '#409eff' }; // Element UI info 颜色
				case '删除':
					return { backgroundColor: '#fef0f0', color: '#f56c6c' }; // Element UI danger 颜色
				default:
					// 为未知类型提供一个默认样式
					return { backgroundColor: '#f4f4f5', color: '#909399' }; // Element UI 灰色
			}
		},

		/**
		 * @description 比较原始对象和变更后对象的差异
		 * @param {Object} original - 原始数据对象，默认为空对象
		 * @param {Object} changed - 变更后的数据对象，默认为空对象
		 * @returns {Object} 包含差异字段的对象，数字字段记录差值，其他变更字段标记为 '[changed]'
		 */
		calculateDifferences(original = {}, changed = {}) {
			const diffs = {}; // 存储差异的对象
			// 获取两个对象的所有键名，并去重
			const allKeys = new Set([...Object.keys(original), ...Object.keys(changed)]);

			allKeys.forEach(key => {
				// 特殊处理列表字段 'inventoryDetailList'，进行递归比较
				if (key === 'inventoryDetailList') {
					const originalList = original[key] || [];
					const changedList = changed[key] || [];
					// 计算列表差异
					const listDiffs = this.calculateListDifferences(originalList, changedList);
					// 如果列表存在差异，则记录
					if (listDiffs.some(diffItem => Object.keys(diffItem).length > 0)) {
						diffs[key] = listDiffs; // 存储列表差异详情（目前可能在 getDiffValue 中只显示“列表有变更”）
					}
					return; // 处理完列表后跳过后续普通字段比较
				}

				// 获取原始值和变更值
				const origVal = original[key];
				const changedVal = changed[key];
				// 标准化处理：将 null 和 undefined 转换为空字符串，便于比较
				const normalizedOrigVal = origVal === null || typeof origVal === 'undefined' ? '' : origVal;
				const normalizedChangedVal = changedVal === null || typeof changedVal === 'undefined' ? '' : changedVal;

				// 如果任一值为数字类型，按数字比较
				if (typeof normalizedOrigVal === 'number' || typeof normalizedChangedVal === 'number') {
					const numOrig = Number(normalizedOrigVal) || 0; // 尝试转为数字，失败则为 0
					const numChanged = Number(normalizedChangedVal) || 0;
					if (numOrig !== numChanged) {
						// 如果数字不相等，记录差值 (变更值 - 原始值)
						diffs[key] = numChanged - numOrig;
					}
				}
				// 其他类型（字符串、布尔值等）转换为字符串进行比较
				else if (String(normalizedOrigVal) !== String(normalizedChangedVal)) {
					// 如果字符串表示不相等，标记为已更改
					diffs[key] = '[changed]';
				}
			});
			return diffs; // 返回包含差异信息的对象
		},

		/**
		 * @description 递归比较两个列表（通常是对象数组）的差异
		 * @param {Array} originalList - 原始列表，默认为空数组
		 * @param {Array} changedList - 变更后的列表，默认为空数组
		 * @returns {Array} 包含每个对应位置项差异的对象数组
		 */
		calculateListDifferences(originalList = [], changedList = []) {
			const maxLength = Math.max(originalList.length, changedList.length);
			const diffs = [];
			for (let i = 0; i < maxLength; i++) {
				// 获取对应位置的对象，如果列表长度不足则视为空对象
				const orig = originalList[i] || {};
				const changed = changedList[i] || {};
				// 递归调用 calculateDifferences 计算单个对象的差异
				const itemDiff = this.calculateDifferences(orig, changed);
				// 如果当前项存在差异，则添加到结果数组中
				if (Object.keys(itemDiff).length > 0) {
					diffs.push(itemDiff);
				}
			}
			// 返回实际存在差异的项的差异对象数组
			return diffs.filter(d => Object.keys(d).length > 0);
		},

		/**
		 * @description 根据模块名称动态获取表格列配置
		 * @param {Boolean} isDetail - 是否获取子表 (detail) 的列配置，默认为 false (获取主表)
		 * @returns {Array} 表格列配置对象数组 (el-table-column 的 props)
		 */
		getTableColumns(isDetail = false) {
			// 根据 isDetail 标志确定使用主模块名还是子模块名
			const moduleKey = isDetail ? this.body.multiModuleName : this.body.moduleName;
			// 检查模块名是否存在且有对应的配置
			if (!moduleKey || !TableConfig[moduleKey]) {
				console.warn(`未找到模块 ${moduleKey} 的表格配置。`);
				return []; // 没有配置则返回空数组
			}
			const config = TableConfig[moduleKey]; // 获取该模块的配置
			const mappers = config.mappers || {}; // 获取字段名到列名的映射

			// 将 mappers 转换为 el-table-column 需要的格式
			return Object.keys(mappers).map(key => ({
				prop: key, // 对应数据的字段名
				label: mappers[key], // 列头显示的文本
				// 列内容格式化函数
				formatter: (row, column, cellValue, index) => {
					// 如果当前行是 '差额' 行
					if (row.status === '差额') {
						// 使用 getDiffValue 方法格式化差额显示
						return this.getDiffValue(row, key); // 传入整行数据和当前列的 key
					}
					// 对于非 '差额' 行 (修改前/修改后/新增)
					const value = cellValue; // cellValue 就是 row[column.property]
					// 检查是否有特定的格式化选项函数 (可能用于枚举值转换等)
					if (typeof config.options === 'function') {
						try {
							// 尝试使用配置中的 options 函数格式化
							return config.options(key, value);
						} catch (error) {
							console.error(`格式化字段 ${key} 的值 ${value} 时出错:`, error);
							// 格式化出错时，返回原始值的字符串形式，或对 null/undefined 显示 '-'
							return value === null || typeof value === 'undefined' ? '-' : String(value);
						}
					} else {
						// 没有特定格式化函数，直接返回原始值的字符串形式，或对 null/undefined 显示 '-'
						return value === null || typeof value === 'undefined' ? '-' : String(value);
					}
				}
			}));
		},

		/**
		 * @description 格式化差额行中单元格的显示内容
		 * @param {Object} row - 当前行数据 (差额行)
		 * @param {String} key - 当前列对应的字段名
		 * @returns {String} 格式化后的差额显示文本
		 */
		getDiffValue(row, key) {
			// 安全地获取差额行中对应 key 的值
			const value = row ? row[key] : undefined;

			// 根据值的类型进行格式化
			if (typeof value === 'number') {
				if (!isFinite(value)) return '-'; // 处理 NaN 或 Infinity
				// 对数字差额，显示 +/- 符号，并保留两位小数
				return value > 0 ? `+${value.toFixed(2)}` : value.toFixed(2);
			} else if (value === '[changed]') {
				// 标记为 '[changed]' 的非数字、非列表字段
				return '有修改';
			} else if (Array.isArray(value)) {
				// 如果是数组（代表列表差异），判断是否有内容
				return value.length > 0 ? '列表有变更' : '-'; // 如果数组不为空，则显示列表有变更
			} else if (typeof value === 'object' && value !== null) {
				// 其他非空对象类型（理论上不应直接出现，可能来自 calculateDifferences 的扩展）
				return '有修改'; // 也可以标记为 '对象有修改'
			} else if (value === null || typeof value === 'undefined' || value === '') {
				// 对于 null, undefined, 或空字符串，显示 '-'
				return '-';
			} else {
				// 其他情况（理论上主要是原始值未变，diff 中无此 key，值为 undefined），也显示 '-' 或转为字符串
				return '-'; // 或者 String(value) 如果需要显示非预期类型的值
			}
		},

		/**
		 * @description 组合主信息数据，生成包含 '修改前'、'修改后'、'差额' 的表格数据
		 * @param {Object} item - 单个主信息项，包含 originalInfo 和 changedInfo
		 * @returns {Array} 用于 el-table 的数据数组
		 */
		getCombinedData(item) {
			// 安全获取原始信息和变更后信息，默认为空对象
			const original = item?.originalInfo || {};
			const changed = item?.changedInfo || {};
			// 计算差异
			const diff = this.calculateDifferences(original, changed);
			// 获取操作类型
			const operationType = this.calculateProp(item).type;

			// fixme 这里 如果是空 那么就渲染一个空行 全部都是 -
			const result = [];
			// 如果不是 '新增' 操作，添加 '修改前' 行
			if (operationType !== '新增') {
				result.push({ status: '修改前', ...original });
			}
			// 添加 '修改后' 行 (对于 '新增' 操作，这行就是新增的数据)
			result.push({ status: '修改后', ...changed });

			// 只有当计算出的差异对象不为空时，才添加 '差额' 行
			if (Object.keys(diff).length > 0) {
				result.push({ status: '差额', ...diff });
			}
			return result;
		},

		/**
		 * @description 组合子信息数据，生成包含 '修改前'、'修改后'、'差额' 的表格数据 (汇总差异)
		 * @param {Array} subItems - 子信息项数组，每个元素包含 originalInfo 和 changedInfo
		 * @returns {Array} 用于 el-table 的数据数组
		 */
		getCombinedSubData(subItems) {
			// 检查子信息是否有效
			if (!Array.isArray(subItems) || subItems.length === 0) {
				return []; // 无效或空数组则返回空
			}
			// 获取第一个子项的操作类型（假设所有子项操作类型一致）
			const operationType = this.calculateProp(subItems[0]).type;
			const allRows = []; // 存储所有行的数组

			// 如果不是 '新增' 操作，添加所有子项的 '修改前' 行
			if (operationType !== '新增') {
				subItems.forEach(sub => {
					const original = sub?.originalInfo || {};
					allRows.push({ status: '修改前', ...original });
				});
			}
			// 添加所有子项的 '修改后' 行
			subItems.forEach(sub => {
				const changed = sub?.changedInfo || {};
				allRows.push({ status: '修改后', ...changed });
			});

			// 计算每个子项的差异
			const allDiffs = subItems.map(sub => {
				const original = sub?.originalInfo || {};
				const changed = sub?.changedInfo || {};
				return this.calculateDifferences(original, changed);
			});

			// --- 汇总所有子项的差异 ---
			const totalDiff = allDiffs.reduce((acc, diff) => {
				// 遍历当前子项的差异
				Object.entries(diff).forEach(([key, diffValue]) => {
					const existingValue = acc[key]; // 获取累加器中已有的值

					// 特殊处理列表差异：只要有一个子项列表有变更，总差异就标记为“列表有变更”
					if (key === 'inventoryDetailList' && Array.isArray(diffValue) && diffValue.length > 0) {
						acc[key] = '列表有变更'; // 直接标记
					}
					// 处理数字差异：进行累加
					else if (typeof diffValue === 'number' && isFinite(diffValue)) {
						// 仅当累加器中值也是数字或不存在时才累加，避免覆盖 '[changed]' 等标记
						if (typeof existingValue === 'number' || existingValue === undefined) {
							acc[key] = (existingValue || 0) + diffValue;
						}
						// 如果累加器中已经是 '[changed]' 等非数字标记，则保持不变
					}
					// 处理非数字、非列表的变更标记 '[changed]' 或对象差异
					else if (diffValue === '[changed]' || (typeof diffValue === 'object' && diffValue !== null && !Array.isArray(diffValue))) {
						// '[changed]' 标记具有较高优先级，会覆盖之前的数字累加值
						acc[key] = '[changed]';
					}
					// 其他情况 (如 diffValue 为 null, undefined, '', 0 (对于非累加数字), 空数组等) 不改变累加器
				});
				return acc; // 返回更新后的累加器
			}, {}); // 初始累加器为空对象

			// --- 添加汇总后的差额行 ---
			// 只有当汇总差异对象不为空时才添加 '差额' 行
			// 注意：这里不过滤值为 0 的数字差额，如果需要过滤可以在此添加逻辑
			if (Object.keys(totalDiff).length > 0) {
				allRows.push({ status: '差额', ...totalDiff });
			}

			return allRows; // 返回组合好的所有行数据
		},

		/**
		 * @description 将数据保存为 JSON 文件并触发下载
		 * @param {Object|Array} data - 需要保存的数据
		 * @param {String} type - 类型标识 ('main' 或 'sub')，用于文件名
		 */
		saveAsJson(data, type) {
			try {
				// 检查数据是否有效
				if (data === null || typeof data === 'undefined') {
					console.warn('尝试保存的数据为空');
					// 可以添加用户提示，例如：
					// this.$message.warning('没有可保存的数据。');
					return; // 数据无效则不执行保存
				}
				// 将数据转换为格式化的 JSON 字符串
				const jsonData = JSON.stringify(data, null, 2); // null, 2 用于美化输出
				// 创建 Blob 对象
				const blob = new Blob([jsonData], { type: 'application/json;charset=utf-8' });
				// 创建 موقت URL
				const url = URL.createObjectURL(blob);
				// 创建下载链接
				const a = document.createElement('a');
				a.href = url;
				// 生成文件名：模块名_类型_时间戳.json
				const moduleNameStr = String(this.body.moduleName || 'unknown_module').replace(/[^a-z0-9]/gi, '_'); // 清理模块名作文件名
				const typeStr = String(type).replace(/[^a-z0-9]/gi, '_'); // 清理类型名作文件名
				const timestamp = new Date().toISOString().replace(/[:.]/g, '-'); // ISO 格式时间戳，替换特殊字符
				a.download = `${moduleNameStr}_${typeStr}_${timestamp}.json`;
				// 将链接添加到 DOM 并模拟点击
				document.body.appendChild(a);
				a.click();
				// 清理：移除链接并释放 URL 对象
				document.body.removeChild(a);
				URL.revokeObjectURL(url);
			} catch (error) {
				console.error('保存为 JSON 时出错:', error);
				// 可以在这里添加用户错误提示，例如：
				// this.$message.error('保存文件失败，请检查数据或联系管理员。');
			}
		}
	}
};
</script>

<style scoped lang="scss">
.el-table {
	margin-bottom: 10px; /* 表格下边距 */
}

/* 保留基本的居中和表头样式 */
.el-table th,
.el-table td {
	text-align: center; /* 单元格内容居中 */
}

.el-table th {
	background-color: #e8e5e5; /* 表头背景色 */
}

/*
  之前的 .el-table .cell 样式可能不是必需的，因为 align="center" 属性通常可以处理居中。
  如果确实需要更复杂的对齐或换行控制，可以取消注释并调整。
*/
/* .el-table .cell {
  display: flex;
  justify-content: center;
  align-items: center;
  word-break: break-word; // 单词内换行
} */

/* header 中操作类型右侧 span 的样式 */
header > span > span {
	padding: 2px 4px; /* 内边距 */
	border-radius: 3px; /* 圆角 */
	margin-left: 4px; /* 左边距 */
}
</style>
