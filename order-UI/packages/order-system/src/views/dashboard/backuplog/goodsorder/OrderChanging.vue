<script>
import { completeJsonData, JsonUtils } from '@/views/dashboard/backuplog';
import { excludeParams } from '@/api/tool/exclude';

export default {
	name: 'OrderChanging',
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
			translate: [
				'编号',
				'车队',
				'备注',
				'客户',
				'调整次数',
				'订单号',
				'海运车号',
				'陆运车辆ID',
				'陆运车号',
				'订单日期',
				'总吨位',
				'审核状态',
				'客户ID',
				'是否调整单',
				'陆运银行账号',
				'海运运费',
				'总付款',
				'陆运运费',
				'销售经理',
				'发票状态',
				'陆运银行名称',
				'海运司机电话',
				'调整订单ID',
				'陆运司机电话',
				'海运司机姓名',
				'陆运司机姓名',
				'总运费价格',
				'出厂货款',
				'客户是否开票',
				'供应商是否开票'
			]
		};
	},
	mounted() {
		this.render(0);
	},
	methods: {
		// 渲染函数
		render(index) {
			if (!this.compareData.length) {
				throw new Error('未找到对应数据');
			}

			let item1 = this.compareData[index].originalInfo;
			let item2 = this.compareData[index].changedInfo;
			const beforeJson = JsonUtils.getJson(item1);
			const afterJson = JsonUtils.getJson(item2);
			item2 = completeJsonData(beforeJson, afterJson);
			item1 = beforeJson;

			console.log('item:', item1, '\n', item2);

			// 渲染表格
			this.$nextTick(() => {
				this.renderTable(item1, 'beforeTable' + index, '修改前', this.translate);
				this.renderTable(item2, 'afterTable' + index, '修改后', this.translate);
			});
		},

		// 渲染表格
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
				thead.appendChild(th);
			});

			try {
				const tr = document.createElement('tr');
				tr.style.textAlign = 'center';

				// 状态列
				const statusTd = document.createElement('td');
				statusTd.textContent = status;
				statusTd.classList.add('status-cell');
				tr.appendChild(statusTd);

				// JSON 数据列
				dataKeys.forEach(key => {
					const td = document.createElement('td');
					td.textContent = json[key] !== undefined ? json[key] : 'null';
					td.classList.add('table-d');
					td.style.textAlign = 'center';
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
		</div>
	</div>
</template>

<style scoped>
.table-container {
	margin: 0 auto;
	display: flex;
	justify-content: center;
	flex-direction: column;
}

.container {
	border-radius: 8px;
	max-width: 1400px;
	max-height: 700px;
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
