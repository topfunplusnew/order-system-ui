<script>
import { completeJsonData, JsonUtils, TypeUtils } from '@/views/dashboard/backuplog';
import { filtersFunc, keyOptioner, paramFieldFilter, transFuc, typeFilter } from '@/views/dashboard/backuplog/goodsorder/index';
import { moduleNames, TableName } from '@/api/tool/enums';
import _ from 'lodash';
import { TableConfig } from '../backup.config';
import OrderInfos from '@/views/dashboard/components/goodsOrder/OrderInfos.vue';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';
// 这里的逻辑需要层层筛选 需要加一些过滤器 对json的操作
// 现在的逻辑 是 根据模块分组了 订单需要筛选掉调整单生成的负数单和调整单，然后库存也是 所以需要一个过滤器
// 另外 新增 insert的备份记录 原信息给null  新信息给新增的信息
// 还需要参数过滤器，需要筛选掉不必要的参数 例如编号 订单编号 各种后端用来绑定用的id
// 还需要一个函数指针数组，以防甲方加新功能
export default {
	name: 'OrderChanging',
	components: { INVENTORY, OrderInfos },
	props: {
		// 要进行比较的数据列表
		compareData: {
			type: Array,
			default: () => []
		},
		// 模块名称
		moduleName: {
			type: String,
			default: ''
		}
	},
	data() {
		return {
			activeNames: ['1']
		};
	},
	created() {
		console.log('OrderChanging', this.compareData, this.moduleName);
	},
	// 主要针对订单和库存这两个模块 进行分组
	computed: {
		moduleNames() {
			return moduleNames;
		},
		TableName() {
			return TableName;
		},
		// 对数据进行处理 根据模块名称
		renderData() {
			return Object.entries(_.groupBy(this.compareData, item => item.uuid)).map(entries => {
				return _.groupBy(entries[1], item => item.tableName);
			});
		}
	},
	mounted() {
		console.log('renderData:', this.renderData);
		// 如果是订单和库存
		if (this.moduleName === TableName.GOODS_ORDER) {
			this.getTable(TableName.ORDER_DETAIL);
		} else if (this.moduleName === TableName.INVENTORMAIN) {
			this.getTable(TableName.INVENTORDETAIL);
			// 对于其他的情况 用render函数去渲染表格
		} else {
			this.compareData.forEach((item, index) => {
				this.render(index);
			});
		}
	},

	methods: {
		/**
		 * 针对库存和订单模块
		 * @param prop
		 */
		getTable(prop) {
			for (let index = 0; index < this.renderData.length; index++) {
				const item = this.renderData[index];
				const _getData = (prop, type) => {
					const key = type === 1 ? 'originalInfo' : 'changedInfo';
					return item[prop]
						? _.cloneDeep(
								item[prop].map(item => {
									const _item = typeFilter(item);
									return JsonUtils.getJson(_item[key]);
								})
						  )
						: [];
				};
				const before = _getData(prop, 1);
				const after = _getData(prop, 2);
				this.renderTable(before, 'multi-beforeTable' + index, '修改前');
				this.renderTable(after, 'multi-afterTable' + index, '修改后');
			}
		},
		/**
		 * 渲染表格
		 * @param index 要渲染的数据的索引
		 */
		render(index) {
			if (!this.compareData || !this.compareData.length) {
				throw new Error('未找到对应数据');
			}
			// 渲染非订单的数据
			this.processData(index, undefined);
		},
		/**
		 * 处理数据的函数
		 * @param index 要处理的数据的索引 也就是备份数据的索引
		 * @param processData 备份数据数组 默认为传入组件的数据 也就是后端直接返回的备份数据数组
		 */
		processData(index, processData) {
			// 处理一下type
			let current = processData || this.compareData[index];
			current = typeFilter(current);
			// 转为json数据
			let pre = JsonUtils.getJson(current.originalInfo);
			let aft = JsonUtils.getJson(current.changedInfo);
			// 键值对处理
			// pre = keyOptioner(pre);
			// aft = keyOptioner(aft);
			// 对id等的参数进行过滤
			const orderParamFilter = this.moduleName === TableName.GOODS_ORDER ? key => key === 'ORDERSNO' || key.indexOf('ORDERSNO') !== -1 : undefined;
			// 需要根据表名判断是否需要传递函数数组
			const callbackList = this.moduleName === TableName.GOODS_ORDER || this.moduleName === TableName.INVENTORMAIN ? [orderParamFilter] : [];
			let [item1, item2] = paramFieldFilter([pre, completeJsonData(pre, aft)], callbackList, this.$exclude);

			// 渲染表格
			this.$nextTick(() => {
				this.renderTable(item1, 'beforeTable' + index, '修改前');
				this.renderTable(item2, 'afterTable' + index, '修改后');
			});
		},
		/**
		 * 渲染表格
		 * @param {*[]} data 表格数据 一行 或者多行
		 * @param tableId 表格元素的id
		 * @param status  状态列的展示 是修改前还是修改后
		 */
		renderTable(data, tableId, status) {
			if (!data || !status) {
				console.error('缺少参数');
				return;
			}
			let processData = null;
			if (TypeUtils.prototype.checkType(data) === 'Object') {
				processData = [data];
			}
			if (TypeUtils.prototype.checkType(data) === 'Array') {
				if (data.length === 0) {
					console.error('渲染表格,renderTable函数出问题,数据为空');
					return;
				}
				processData = data;
			}
			// 获取dom元素
			const table = document.getElementById(tableId);
			if (!table) {
				console.error(`表格 ${tableId} 未找到`);
				return;
			}
			const thead = table.querySelector('thead tr');
			const tbody = table.querySelector('tbody');
			if (processData === null) {
				console.error('processData 为空');
				this.renderNull(tbody);
				return;
			}
			thead.innerHTML = '';
			tbody.innerHTML = '';
			// 渲染表头
			this.renderTableHeader(thead);
			// 渲染表格行数据
			processData.forEach(item => {
				this.renderTableRows(tbody, item, status);
			});
		},
		/**
		 * 渲染表头字段 修正表头长度 并且渲染顶部
		 * @param thead 表格的表头DOM元素
		 */
		renderTableHeader(thead) {
			const config = TableConfig[transFuc(this.moduleName)];
			const mappers = config.mappers;
			const dataKeys = Object.keys(mappers);
			// 渲染表头字段 修正表头长度 并且渲染顶部
			const headerRow = ['状态', ...dataKeys.slice(0, dataKeys.length)];
			for (let key of headerRow) {
				if (typeof mappers[key] === 'object') {
					continue;
				}
				const th = document.createElement('th');
				// 这里对数据可以进行处理 判断当前字段对应的值是不是object
				th.textContent = mappers[key];
				th.style.textAlign = 'center';
				th.style.backgroundColor = '#e8e5e5';
				th.style.border = '1px solid black';
				thead.appendChild(th);
			}
		},
		renderNull(tbody) {
			const tr = document.createElement('tr');
			const td = document.createElement('td'); // 使用td更合适
			td.textContent = '暂无货物修改记录';
			td.className = 'no-data-cell'; // 使用CSS类代替内联样式
			// 计算或传递colSpan值
			td.colSpan = tbody.parentElement.rows[0]?.cells?.length || 1;
			tr.appendChild(td);
			tbody.appendChild(tr);
		},
		/**
		 * 渲染表格行数据
		 * @param tbody 表格行的body DOM元素
		 * @param json  需要渲染的json数据
		 * @param status  状态字段 修改前还是修改后
		 */
		renderTableRows(tbody, json, status = '修改前') {
			if (!json || !status) {
				console.error('缺少参数');
				return;
			}
			const config = TableConfig[transFuc(this.moduleName)];
			const mappers = config.mappers;
			const dataKeys = Object.keys(mappers);
			try {
				const tr = document.createElement('tr');
				tr.style.textAlign = 'center';
				// 状态列
				const statusTd = document.createElement('td');
				statusTd.textContent = status;
				statusTd.style.textAlign = 'center';
				statusTd.style.border = '1px solid black';
				statusTd.style.width = '120px';
				statusTd.classList.add('status-cell');
				tr.appendChild(statusTd);
				// JSON 数据列
				dataKeys.forEach(key => {
					const td = document.createElement('td');
					td.textContent = json[key] !== undefined ? json[key] : '';
					td.classList.add('table-d');
					td.style.textAlign = 'center';
					td.style.border = '1px solid black';
					tr.appendChild(td);
				});
				tbody.appendChild(tr);
			} catch (err) {
				console.error(err);
			}
		},
		/**
		 * 对订单主表信息进行数据处理
		 * @param item  备份信息主表
		 * @param type  类型
		 * @param moduleName  模块名
		 * @returns {any}
		 */
		getProcessedOrder(item, type, moduleName) {
			let row = null;
			switch (moduleName) {
				case TableName.GOODS_ORDER:
					row = typeFilter(_.cloneDeep(item).goodsorder[0]);
					break;
				case TableName.INVENTORMAIN:
					row = typeFilter(_.cloneDeep(item).inventory_main[0]);
					break;
				default:
					row = typeFilter(_.cloneDeep(item).goodsorder[0]);
			}
			if (type === 'before') {
				return JSON.parse(row.originalInfo);
			}
			if (type === 'after') {
				return JSON.parse(row.changedInfo);
			}
		},
		calculateProp(item, moduleName) {
			let _type = null;
			let _oriType = item[moduleName].slice(0, 1)[0].backupType;
			let _oriTime = item[moduleName].slice(0, 1)[0].backupTime;
			if (_oriType === 'insert') {
				_type = '新增';
			} else if (_oriType === 'delete') {
				_type = '删除';
			} else {
				_type = '修改';
			}
			return {
				time: _oriTime,
				type: _type
			};
		},
		handleChange() {},
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<!--    订单或者库存的数据渲染使用-->
		<div v-if="moduleName === TableName.GOODS_ORDER || moduleName === TableName.INVENTORMAIN">
			<div class="body">
				<div class="table-container" v-for="(item, index) in renderData" :key="index">
					<el-card class="box-card">
						<div slot="header" class="clearfix">
							<span style="font-size: 18px; font-weight: bold; color: red; letter-spacing: 3px">{{ moduleNames[moduleName] }}修改记录[{{ index + 1 }}]</span>
							<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #555353">操作类型:{{ calculateProp(item, moduleName).type }}</span>
							<span style="margin-left: 40px; font-weight: bold; font-size: 14px; color: #4a4949">操作时间:{{ calculateProp(item, moduleName).time }}</span>
							<!--              后续可以添加操作按钮-->
							<!--							<el-button style="float: right; padding: 3px 0" type="text">操作类型:{{ item.logicBackupType }} 时间:{{ item.changed_targetTime }}</el-button>-->
						</div>

						<!--            对于订单-->
						<div v-if="item.goodsorder">
							<el-collapse v-model="activeNames" @change="handleChange">
								<el-collapse-item :title="moduleNames[moduleName] + `主信息修改前`" :name="item.id">
									<div>
										<div v-if="item.goodsorder[0].originalInfo !== 'null'">
											<OrderInfos :order-info="getProcessedOrder(item, 'before', moduleName)" />
										</div>
										<div v-else>{{ moduleNames[moduleName] }}无修改前记录</div>
									</div>
								</el-collapse-item>
								<el-collapse-item :title="moduleNames[moduleName] + `主信息修改后`" :name="item.id">
									<div>
										<div v-if="item.goodsorder[0].changedInfo !== 'null'">
											<OrderInfos :order-info="getProcessedOrder(item, 'after', moduleName)" />
										</div>
										<div v-else>{{ moduleNames[moduleName] }}无修改后记录</div>
									</div>
								</el-collapse-item>
							</el-collapse>
							<el-divider>{{ moduleNames[moduleName] }}货物修改记录</el-divider>
						</div>
						<!--            对于库存 todo 需要调试-->
						<div v-if="item.inventory_main">
							<el-collapse v-model="activeNames" @change="handleChange">
								<el-collapse-item :title="moduleNames[moduleName] + `主信息修改前`" :name="item.id">
									<div>
										<div v-if="item.inventory_main[0].originalInfo !== 'null'">
											<INVENTORY :need-to-show-info="getProcessedOrder(item, 'before', moduleName)" />
										</div>
										<div v-else>{{ moduleNames[moduleName] }}无修改前记录</div>
									</div>
								</el-collapse-item>
								<el-collapse-item title="订单主信息修改后" :name="item.id">
									<div>
										<div v-if="item.inventory_main[0].changedInfo !== 'null'">
											<INVENTORY :need-to-show-info="getProcessedOrder(item, 'after', moduleName)" />
										</div>
										<div v-else>{{ moduleNames[moduleName] }}无修改后记录</div>
									</div>
								</el-collapse-item>
							</el-collapse>
							<el-divider>{{ moduleNames[moduleName] }}货物修改记录</el-divider>
						</div>
						<div id="table-gen">
							<div class="container">
								<table :id="'multi-beforeTable' + index">
									<thead>
										<tr></tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
							<div class="container">
								<table :id="'multi-afterTable' + index">
									<thead>
										<tr></tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
						</div>
					</el-card>
				</div>
			</div>
		</div>
		<!--    非订单的数据渲染使用-->
		<div v-else>
			<div>
				<div class="table-container" v-for="(item, index) in compareData" :key="index">
					<div class="container">
						<table :id="'beforeTable' + index">
							<thead>
								<tr></tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
					<div class="container">
						<table :id="'afterTable' + index">
							<thead>
								<tr></tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
				<br />
				<br />
				<br />
			</div>
		</div>
	</div>
</template>

<style scoped>
.body {
}

.table-container {
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

.no-data-cell {
	text-align: center;
	background-color: #e8e5e5;
	border: 1px solid black;
}
</style>
