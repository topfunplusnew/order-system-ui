<script>
import { completeJsonData, TypeUtils } from '@/views/dashboard/backuplog';
import { TableConfig } from '@/views/dashboard/backuplog/backup.config';
import { moduleNames, System_Option_Type, TableName } from '@/api/tool/enums';
import _ from 'lodash';

export default {
	name: 'FlexTable',
	computed: {
		moduleNames() {
			return moduleNames;
		},
		TableName() {
			return TableName;
		},
		compareData() {
			return this.body.main_info.data;
		}
	},
	watch: {
		idx: {
			handler() {
				this.$nextTick(() => {
					this.mountTable();
				});
			}
		}
	},
	props: {
		index: {
			type: Number,
			default: 0
		},
		body: {
			type: Object,
			default: () => {
				return {
					moduleName: null,
					// 是否是订单或库存 Object.keys(renderData[index]).length > 0 ? true : false
					isMulti: true,
					// 是否是调整单 isMulti ? (renderData[index].goodsOrder.length || renderData[index].inventory_main.length) > 0 ? true : false : false
					isAdjust: true,
					main_info: {
						// tableName !== TableName.GOODS_ORDER || tableName !== TableName.INVENTORY_MAIN
						data: {},
						items: []
					},
					// isMulti === true
					sub_info: {
						items: []
					},
					// 哪些字段需要算钱 仅仅高亮这些行 v-for row in rows  if row.key === 'payment'
					params: [],
					// 额外需要处理的字段
					extraParams: [],
					extraInfo: {
						_: ''
					}
				};
			}
		}
	},
	mounted() {
		this.mountTable();
	},
	methods: {
		mountTable() {
			const items = this.body.main_info.items ? _.cloneDeep(this.body.main_info.items) : [];
			const data = this.body.main_info.data ? _.cloneDeep(this.body.main_info.data) : [];
			const sub_items = this.body.sub_info ? _.cloneDeep(this.body.sub_info) : [];
			const renderTables = (items, isSubTable = false) => {
				items.forEach((item, index) => {
					const prefix = isSubTable ? 'sub-multi-' : 'multi-';
					const bTable = `${prefix}beforeTable${index}`;
					const aTable = `${prefix}afterTable${index}`;
					const dTable = `${prefix}diffTable${index}`; // 新增差异表格

					const before = item.originalInfo ? [item.originalInfo] : [];
					const after = item.changedInfo ? [item.changedInfo] : [];

					// 计算差异
					const diffs = this.calculateDifferences(item.originalInfo || {}, item.changedInfo || {});

					this.renderTable(before, bTable, '修改前', isSubTable, diffs);
					this.renderTable(after, aTable, '修改后', isSubTable, diffs);
					this.renderDiffTable(diffs, dTable, isSubTable); // 渲染差异表格
				});
			};
			// 处理订单或库存
			if ([TableName.GOODS_ORDER, TableName.INVENTORMAIN].includes(this.body.moduleName)) {
				// 渲染主表
				renderTables(items);
				// 渲染子表
				if (sub_items.length > 0) {
					renderTables(sub_items, true);
				}
			}
			// 处理其他表
			else {
				data.forEach((item, index) => {
					this.render(index, item);
				});
			}
		},
		/**
		 * 渲染表格
		 * @param {*[]} data 表格数据 一行 或者多行
		 * @param tableId 表格元素的id
		 * @param status  状态列的展示 是修改前还是修改后
		 * @param isDetail  是否是明细
		 */
		renderTable(data, tableId, status, isDetail = false, diffs) {
			// 获取dom元素
			const table = this.$refs[tableId][0];
			if (!table) {
				this.$log.error(`表格 ${tableId} 未找到`);
				return;
			}
			const thead = table.querySelector('thead tr');
			const tbody = table.querySelector('tbody');
			thead.innerHTML = '';
			tbody.innerHTML = '';
			// 渲染表头
			this.renderTableHeader(thead, isDetail);
			if (!data || !status) {
				// render一个空行
				this.renderNull(table);
			}
			if (TypeUtils.prototype.checkType(data) !== 'Array') {
				this.$log.error('渲染表格,renderTable函数出问题,传入数据有误');
				return;
			}
			if (data.length === 0) {
				this.renderNull(table);
				return;
			}
			// 渲染表格行数据
			data.forEach(item => {
				this.renderTableRows(tbody, item, status, isDetail, diffs);
			});
		},
		renderNull(tbody) {
			const tr = document.createElement('tr');
			const td = document.createElement('td'); // 使用td更合适
			td.textContent = '暂无记录';
			td.style.textAlign = 'center';
			td.className = 'no-data-cell'; // 使用CSS类代替内联样式
			// 计算或传递colSpan值
			tr.appendChild(td);
			tbody.appendChild(tr);
		},
		/**
		 * 渲染表头字段 修正表头长度 并且渲染顶部
		 * @param thead 表格的表头DOM元素
		 * @param isDetail 是否是明细
		 */
		renderTableHeader(thead, isDetail) {
			const config = isDetail ? TableConfig[this.body.multiModuleName] : TableConfig[this.body.moduleName];
			const mappers = config.mappers;
			const dataKeys = Object.keys(mappers);
			// 需要计算的字段
			const calcuKeys = Object.keys(config.params);
			const headerRow = ['状态', ...dataKeys.slice(0, dataKeys.length)];
			for (let key of headerRow) {
				if (typeof mappers[key] === 'object') {
					continue;
				}
				const th = document.createElement('th');
				th.textContent = mappers[key];
				th.style.textAlign = 'center';
				th.style.backgroundColor = '#e8e5e5';
				th.style.width = '250px';
				th.style.border = '1px solid black';
				thead.appendChild(th);
			}
		},
		// todo 渲染差异
		renderTableDiff(tbody, isDetail) {
			const config = isDetail ? TableConfig[this.body.multiModuleName] : TableConfig[this.body.moduleName];
			const mappers = config.mappers;
			const dataKeys = Object.keys(mappers);
			// 需要计算的字段
			const calcuKeys = config.params;
			const diffRow = null; //todo 差异列
			for (let key of diffRow) {
				if (typeof mappers[key] === 'object') {
					continue;
				}
				const tr = document.createElement('tr');
				dataKeys.forEach(key => {
					const td = document.createElement('td');
					td.textContent = calcuKeys.find(item => item.name === key).label;
					td.style.textAlign = 'center';
					td.style.backgroundColor = '#f10505';
					td.style.width = '250px';
					td.style.border = '1px solid black';
					tr.appendChild(td);
				});
				tbody.appendChild(tr);
			}
		},
		/**
		 * 渲染表格行数据
		 * @param tbody 表格行的body DOM元素
		 * @param json  需要渲染的json数据
		 * @param status  状态字段 修改前还是修改后
		 * @param isDetail 是否是明细
		 */
		renderTableRows(tbody, json, status = '修改前', isDetail, diffs) {
			if (!json || !status) {
				this.$log.error('缺少参数');
				return;
			}
			let config = isDetail ? TableConfig[this.body.multiModuleName] : TableConfig[this.body.moduleName];
			const dataKeys = Object.keys(config.mappers); //mappers是配置文件里配置的字段

			try {
				const tr = document.createElement('tr');
				tr.style.textAlign = 'center';
				const statusTd = document.createElement('td');
				statusTd.textContent = status;
				statusTd.style.textAlign = 'center';
				statusTd.style.border = '1px solid black';
				statusTd.style.width = '120px';
				statusTd.classList.add('status-cell');
				tr.appendChild(statusTd);
				dataKeys.forEach(key => {
					const td = document.createElement('td');
					td.textContent = json[key] !== undefined ? config.options(key, json[key]) : '';
					// 添加高亮逻辑
					if (diffs[key]) {
						td.style.backgroundColor = status === '修改前' ? '#ffeeba' : '#c3e6cb';
					}
					td.classList.add('table-d');
					td.style.textAlign = 'center';
					td.style.width = '250px';
					td.style.border = '1px solid black';
					tr.appendChild(td);
				});
				tbody.appendChild(tr);
			} catch (err) {
				this.$log.error(err);
			}
		},

		// 以下为非订单使用
		/**
		 * 渲染表格
		 * @param index 要渲染的数据的索引
		 * @param item 备份数据行
		 */
		render(index, item) {
			if (!this.compareData || !this.compareData.length) {
				throw new Error('未找到对应数据');
			}
			this.renderTable([item.originalInfo], 'beforeTable' + index, '修改前');
			this.renderTable([item.changedInfo], 'afterTable' + index, '修改后');
		},

		calculateProp(item) {
			const { backupType = '', backupTime = null } = item;
			// 映射操作类型
			const typeMap = {
				insert: '新增',
				delete: '删除',
				default: '修改'
			};
			const _type = typeMap[backupType] || typeMap.default;
			return {
				time: backupTime,
				type: _type
			};
		},
		typeStyle(type) {
			switch (type) {
				case System_Option_Type.INSERT:
					return {
						backgroundColor: '#f0f9eb',
						color: '#67c23a'
					};
				case System_Option_Type.UPDATE:
					return {
						backgroundColor: '#def6ef',
						color: '#0695a3'
					};
				case System_Option_Type.DELETE:
					return {
						backgroundColor: '#fde2e2',
						color: '#f35914'
					};
				default:
					return {
						backgroundColor: '#fde2e2'
					};
			}
		},
		// 计算两个对象差异的方法（支持嵌套对象）
		calculateDifferences(original = {}, changed = {}) {
			const diffs = {};

			// 合并所有可能的key
			const allKeys = new Set([...Object.keys(original), ...Object.keys(changed)]);

			allKeys.forEach(key => {
				// 处理嵌套对象（例如inventoryDetailList）
				if (key === 'inventoryDetailList') {
					const originalList = original[key] || [];
					const changedList = changed[key] || [];
					diffs[key] = this.calculateListDifferences(originalList, changedList);
					return;
				}

				// 处理普通字段
				const origVal = original[key];
				const changedVal = changed[key];

				if (typeof origVal === 'number' || typeof changedVal === 'number') {
					const numOrig = Number(origVal) || 0;
					const numChanged = Number(changedVal) || 0;

					if (numOrig !== numChanged) {
						diffs[key] = numChanged - numOrig;
					}
				} else if (origVal !== changedVal) {
					diffs[key] = '[changed]'; // 非数字类型标记为已修改
				}
			});

			return diffs;
		},

		renderDiffTable(diffs, tableId, isDetail) {
			const table = this.$refs[tableId]?.[0];
			if (!table) return;

			const thead = table.querySelector('thead tr');
			const tbody = table.querySelector('tbody');
			thead.innerHTML = '';
			tbody.innerHTML = '';

			this.renderTableHeader(thead, isDetail);

			const tr = document.createElement('tr');
			tr.classList.add('diff-row');

			// 状态列
			const statusTd = document.createElement('td');
			statusTd.textContent = '差异值';
			tr.appendChild(statusTd);

			const config = isDetail ? TableConfig[this.body.multiModuleName] : TableConfig[this.body.moduleName];
			Object.keys(config.mappers).forEach(key => {
				const td = document.createElement('td');
				const diffValue = diffs[key];

				// 格式化显示
				if (typeof diffValue === 'number') {
					td.textContent = diffValue > 0 ? `+${diffValue.toFixed(2)}` : diffValue.toFixed(2);
				} else if (diffValue === '[changed]') {
					td.textContent = '有修改';
				} else if (typeof diffValue === 'object') {
					td.textContent = '查看明细'; // 嵌套差异提示
				} else {
					td.textContent = '-';
				}

				tr.appendChild(td);
			});

			tbody.appendChild(tr);
		},
		// 计算数组差异的方法
		calculateListDifferences(originalList, changedList) {
			const maxLength = Math.max(originalList.length, changedList.length);
			const diffs = [];

			for (let i = 0; i < maxLength; i++) {
				const orig = originalList[i] || {};
				const changed = changedList[i] || {};
				diffs.push(this.calculateDifferences(orig, changed));
			}

			return diffs;
		}
	}
};
</script>

<template>
	<div>
		<div>
			<div v-if="body.moduleName === TableName.GOODS_ORDER || body.moduleName === TableName.INVENTORMAIN">
				<h3>{{ moduleNames[this.body.moduleName] }}信息[{{ index + 1 }}]</h3>
				<el-divider />
				<div v-for="(item, index) in body.main_info.items" :key="index" style="padding-bottom: 40px">
					<header>
						<span style="font-weight: bold; font-size: 14px; color: #555353">
							操作类型:
							<span :style="typeStyle(calculateProp(item).type)">[{{ calculateProp(item).type }}]</span>
						</span>
						<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #4a4949">
							操作时间:
							<span>{{ calculateProp(item).time }}</span>
						</span>
					</header>
					<section>
						<div id="table-gen">
							<div class="container" id="table-before">
								<table :ref="'multi-beforeTable' + index">
									<!--    这里是表头 -->
									<thead>
										<tr></tr>
									</thead>
									<tbody>
										<!--                这里面渲染数据-->
									</tbody>
								</table>
							</div>
							<div class="container" id="table-after">
								<table :ref="'multi-afterTable' + index">
									<thead>
										<tr></tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
							<div class="container">
								<table :ref="'multi-diffTable' + index">
									<thead>
										<tr></tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
						</div>
					</section>
					<footer></footer>
				</div>
				<div v-if="body.sub_info" style="margin-bottom: 40px">
					<h4>[{{ moduleNames[body.multiModuleName] }}]</h4>
					<el-divider />
					<div v-for="(item, index) in body.sub_info" :key="index">
						<header>
							<span style="font-weight: bold; font-size: 14px; color: #555353">
								操作类型:
								<span :style="typeStyle(calculateProp(item).type)">[{{ calculateProp(item).type }}]</span>
							</span>
							<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #4a4949">
								操作时间:
								<span>{{ calculateProp(item).time }}</span>
							</span>
						</header>
						<section>
							<div id="table-gen">
								<div class="container" id="table-before">
									<table :ref="'sub-multi-beforeTable' + index">
										<thead>
											<tr></tr>
										</thead>
										<tbody></tbody>
									</table>
								</div>
								<div class="container" id="table-after">
									<table :ref="'sub-multi-afterTable' + index">
										<thead>
											<tr></tr>
										</thead>
										<tbody></tbody>
									</table>
								</div>
								<!--                差异-->
								<div class="container">
									<table :ref="'sub-multi-diffTable' + index">
										<thead>
											<tr></tr>
										</thead>
										<tbody></tbody>
									</table>
								</div>
							</div>
						</section>
					</div>
				</div>
			</div>
			<div v-else>
				<h3>{{ moduleNames[this.body.moduleName] }}[信息{{ index + 1 }}]</h3>
				<div class="else-table-container" v-for="(item, index) in body.main_info.data" :key="index" style="margin-bottom: 40px">
					<header>
						<span style="font-weight: bold; font-size: 14px; color: #555353">
							操作类型:
							<span :style="typeStyle(calculateProp(item).type)">[{{ calculateProp(item).type }}]</span>
						</span>
						<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #4a4949">
							操作时间:
							<span>{{ calculateProp(item).time }}</span>
						</span>
					</header>
					<div id="table-gen">
						<div class="container" id="table-before">
							<table :ref="'beforeTable' + index">
								<thead>
									<tr></tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
						<div class="container" id="table-after">
							<table :ref="'afterTable' + index">
								<thead>
									<tr></tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
						<div class="container">
							<table :ref="'diffTable' + index">
								<thead>
									<tr></tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss">
.table-container {
	width: 100%;
	margin: 40px auto;
	display: flex;
	justify-content: center;
	flex-direction: column;
	overflow-y: scroll;
}

.else-table-container {
	width: 100%;
	margin: 40px auto;
	display: flex;
	justify-content: center;
	flex-direction: column;
	overflow-y: scroll;
}

#table-gen {
	overflow-x: scroll;
}

.container {
	border-radius: 8px;
	max-width: 1400px;
}

table {
	width: 3200px; /* 让表格整体缩小一些 */
	max-width: 3200px; /* 限制最大宽度 */
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

/* 调整状态列宽度 */
th:first-child,
td:first-child {
	width: 150px; /* 设置状态列的宽度 */
}

h3 {
	font-weight: bold;
	font-size: 19px;
	color: red;
}

h4 {
	font-weight: bold;
	font-size: 16px;
}

/* 在style标签内添加 */
.diff-row td {
	background-color: #fff3cd !important;
	font-weight: bold;
	color: #856404;
}

/* 差异表格样式 */
table[id*='diffTable'] td {
	background-color: #fff3cd;
	font-weight: bold;
}

/* 修改前高亮 */
#table-before td[style*='background-color: rgb(255, 238, 186)'] {
	background-color: #ffeeba !important;
}

/* 修改后高亮 */
#table-after td[style*='background-color: rgb(195, 230, 203)'] {
	background-color: #c3e6cb !important;
}
</style>
