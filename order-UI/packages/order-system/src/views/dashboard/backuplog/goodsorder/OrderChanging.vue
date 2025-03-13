<script>
import { JsonUtils } from '@/views/dashboard/backuplog';

export default {
	name: 'OrderChanging',
	props: {
		compareData: {
			type: Array,
			default: () => []
		}
	},
	created() {
		console.log(this.compareData[0]);
		console.log(JsonUtils.getJson(this.compareData[0].changedInfo));
	},
	mounted() {
		const beforeJson = [
			{ name: '张三', age: 25, job: '前端开发' },
			{ name: '李四', age: 30, job: '后端开发' }
		];

		const afterJson = [
			{ name: '张三', age: 26, job: '全栈开发' },
			{ name: '李四', age: 31, job: '架构师' }
		];

		function renderTable(json, tableId, status) {
			const table = document.getElementById(tableId);
			const thead = table.querySelector('thead tr');
			const tbody = table.querySelector('tbody');

			// 清空内容
			thead.innerHTML = '';
			tbody.innerHTML = '';

			// 渲染表头
			const keys = Object.keys(json[0]);
			const headerRow = ['状态', ...keys];
			headerRow.forEach(key => {
				const th = document.createElement('th');
				th.textContent = key;
				thead.appendChild(th);
			});

			// 渲染数据行
			json.forEach((item, index) => {
				const tr = document.createElement('tr');
				if (index === 0) {
					const statusTd = document.createElement('td');
					statusTd.textContent = status;
					statusTd.rowSpan = json.length;
					statusTd.classList.add('status-cell');
					tr.appendChild(statusTd);
				}

				keys.forEach(key => {
					const td = document.createElement('td');
					td.textContent = item[key];
					tr.appendChild(td);
				});
				tbody.appendChild(tr);
			});
		}

		renderTable(beforeJson, 'beforeTable', '修改前');
		renderTable(afterJson, 'afterTable', '修改后');
	},
	methods: {
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<div v-for="(item, index) in compareData" :key="index">
			<div class="container">
				<table id="beforeTable">
					<thead>
						<tr></tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>

			<div class="container">
				<table id="afterTable">
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
.container {
	background: #fff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
	max-width: 600px;
	width: 100%;
}

h2 {
	text-align: center;
	margin-bottom: 20px;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th,
td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: left;
}

th {
	background-color: #0073e6;
	color: white;
}

.status-cell {
	font-weight: bold;
	text-align: center;
	background-color: #f0f0f0;
}
</style>
