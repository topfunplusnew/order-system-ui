<script>
import { completeJsonData, JsonUtils } from '@/views/dashboard/backuplog';
import { excludeParams } from '@/api/tool/exclude';
import { keyOptioner, paramFieldFilter, typeFilter } from '@/views/dashboard/backuplog/goodsorder/index';
import { TableName } from '@/api/tool/enums';

export default {
	name: 'OrderChanging',
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
			translate: [
				'路径',
				'船队',
				'备注',
				'客户',
				'是否调整',
				'海运柜号',
				'陆运车牌',
				'订单日期',
				'海运银行账号',
				'调整日期',
				'总吨数',
				'审核状态',
				'是否已调整',
				'陆运银行账号',
				'海运运费',
				'总付款',
				'陆运运费',
				'销售经理',
				'海运银行名称',
				'付款状态',
				'发票状态',
				'陆运银行名称',
				'收款凭证',
				'海运司机电话',
				'陆运司机电话',
				'海运司机姓名',
				'供应商名称',
				'陆运司机姓名',
				'总运费',
				'工厂总付款',
				'客户是否开发票',
				'供应商是否开发票'
			]
		};
	},
	mounted() {
		console.log(this.compareData);
		this.compareData.forEach((item, index) => {
			this.render(index);
		});
	},
	// 这里的逻辑需要层层筛选 需要加一些过滤器 对json的操作
	// 现在的逻辑 是 根据模块分组了 订单需要筛选掉调整单生成的负数单和调整单，然后库存也是 所以需要一个过滤器
	// 另外 新增 insert的备份记录 原信息给null  新信息给新增的信息
	// 还需要参数过滤器，需要筛选掉不必要的参数 例如编号 订单编号 各种后端用来绑定用的id
	// 还需要一个函数指针数组，以防甲方加新功能
	methods: {
		/**
		 * 渲染表格
		 * @param index 要渲染的数据的索引
		 */
		render(index) {
			if (!this.compareData || !this.compareData.length) {
				throw new Error('未找到对应数据');
			}
			// 处理一下type
			let current = this.compareData[index];
			current = typeFilter(current);
			// 转为json数据
			let pre = JsonUtils.getJson(current.originalInfo);
			let aft = JsonUtils.getJson(current.changedInfo);
			// 键值对处理
			pre = keyOptioner(pre);
			aft = keyOptioner(aft);
			// 对id等的参数进行过滤
			const orderParamFilter = this.moduleName === TableName.GOODS_ORDER ? key => key === 'ORDERSNO' || key.indexOf('ORDERSNO') !== -1 : undefined;
			let [item1, item2] = paramFieldFilter([pre, completeJsonData(pre, aft)], [orderParamFilter], this.$exclude);
			// 渲染表格
			this.$nextTick(() => {
				this.renderTable(item1, 'beforeTable' + index, '修改前', this.translate);
				this.renderTable(item2, 'afterTable' + index, '修改后', this.translate);
			});
		},

		/**
		 * 渲染表格
		 * @param json 需要渲染的一条备份信息
		 * @param tableId 表格元素的id
		 * @param status  状态列的展示
		 * @param headerList  表头数组
		 */
		renderTable(json, tableId, status, headerList) {
			if (!json || !status) {
				throw new Error('缺少参数');
			}

			const table = document.getElementById(tableId);
			if (!table) {
				console.error(`表格 ${tableId} 未找到`);
				return;
			}

			const thead = table.querySelector('thead tr');
			const tbody = table.querySelector('tbody');
			thead.innerHTML = '';
			tbody.innerHTML = '';

			const dataKeys = Object.keys(excludeParams(json));
			if (dataKeys.length === 0) {
				throw new Error('渲染表格时出问题,json数据为空');
			}

			// 修正表头长度
			const headerRow = ['状态', ...headerList.slice(0, dataKeys.length)];
			headerRow.forEach(key => {
				const th = document.createElement('th');
				th.textContent = key;
				th.style.textAlign = 'center';
				th.style.backgroundColor = '#e8e5e5';
				th.style.border = '1px solid black';
				thead.appendChild(th);
			});

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
					td.textContent = json[key] !== undefined ? json[key] : 'null';
					td.classList.add('table-d');
					td.style.textAlign = 'center';
					td.style.border = '1px solid black';
					tr.appendChild(td);
				});

				tbody.appendChild(tr);
			} catch (err) {
				console.log(err);
			}
		},

		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
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
			<br />
			<br />
			<br />
		</div>
	</div>
</template>

<style scoped>
.table-container {
	margin: 0 auto;
	display: flex;
	justify-content: center;
	flex-direction: column;
	max-height: 500px;
}

.container {
	border-radius: 8px;
	max-width: 1400px;
	max-height: 500px;
}

table {
	width: 100%; /* 让表格整体缩小一些 */
	max-width: 1400px; /* 限制最大宽度 */
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
	background-color: #989494 !important;
}

/* 调整状态列宽度 */
th:first-child,
td:first-child {
	width: 150px; /* 设置状态列的宽度 */
}
</style>
