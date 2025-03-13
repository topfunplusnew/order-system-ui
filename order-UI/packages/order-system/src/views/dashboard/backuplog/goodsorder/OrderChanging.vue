<script>
import { completeJsonData, JsonUtils } from '@/views/dashboard/backuplog';
import { getFunction } from '@/utils/order/mapper';
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
				'ID',
				'备注',
				'公司ID',
				'资金日期',
				'收款编号',
				'自方银行ID',
				'自方银行账号',
				'公司名称',
				'公司类型',
				'金额',
				'他方银行账号',
				'收款类型',
				'自方银行名称',
				'他方银行名称',
				'自方账户名称',
				'银行承兑ID',
				'他方账户名称',
				'交易历史',
				'备注',
				'自方银行卡类型',
				'他方银行卡类型',
				'表名',
				'表ID',
				'交易历史附件',
				'开始时间',
				'结束时间'
			]
		};
	},
	async mounted() {
		// 这里的json 是不完全的json  需要进行补齐 然后需要通过模块名称拿取对应的get方法 然后随便get一个实例 根据这个实例去补全json
		if (!this.compareData.length === 0) {
			throw new Error('未找到对应数据');
		}
		// 获取一个样例数据
		const example = this.compareData[0].originalInfo;
		if (!example) {
			throw new Error('未找到对应数据，数据为不完全数据!');
		}
		if (!JsonUtils.getJson(example).id) {
			throw new Error('未找到对应数据，数据为不完全数据!');
		}
		if (!this.moduleName) {
			throw new Error('内部错误，模块名称为空!');
		}
		// 获取一个样例数据 然后补全json
		const { data: tip } = await getFunction(this.moduleName)(JsonUtils.getJson(this.compareData[0].originalInfo).id);
		if (!tip) {
			throw new Error('获取id数据时有问题，未找到对应数据，数据为不完全数据!');
		}
		const beforeJson = this.compareData.map(item => {
			const previous1 = JsonUtils.getJson(item.originalInfo);
			return excludeParams(completeJsonData(tip, previous1), this.$exclude);
		});

		const afterJson = this.compareData.map(item => {
			const previous2 = JsonUtils.getJson(item.changedInfo);
			return excludeParams(excludeParams(completeJsonData(tip, previous2), this.$exclude));
		});

		// json就是需要比较的完整的对象数据 tableId是表格的id status是修改前的还是修改后的
		function renderTable(json, tableId, status, headerList) {
			console.log('参数', json, tableId, status, headerList);

			const table = document.getElementById(tableId);
			const thead = table.querySelector('thead tr');
			const tbody = table.querySelector('tbody');

			// 清空内容
			thead.innerHTML = '';
			tbody.innerHTML = '';

			// 如果传递的中文数组和json长度不一致
			if (headerList && headerList.length !== Object.keys(json[0]).length) {
				throw new Error('表头数据与json数据不一致');
			}
			// 渲染表头 这里是通过json获取的 所以 可不可以传递一个数组 来渲染表头数据 headerRow = []
			// 所以keys是需要传递的中文数组
			const headerRow = ['状态', ...headerList];
			headerRow.forEach(key => {
				const th = document.createElement('th');
				th.textContent = key;
				th.style.background = '#0073e6';
				th.style.color = 'white';
				th.style.textAlign = 'center';
				thead.appendChild(th);
			});

			const jsonKeys = Object.keys(json);
			// 渲染数据行
			json.forEach((item, index) => {
				const tr = document.createElement('tr');
				tr.style.textAlign = 'center';
				if (index === 0) {
					const statusTd = document.createElement('td');
					statusTd.textContent = status;
					statusTd.rowSpan = json.length;
					statusTd.classList.add('status-cell');
					tr.appendChild(statusTd);
				}

				jsonKeys.forEach(key => {
					const td = document.createElement('td');
					td.textContent = item[key];
					td.classList.add('table-d');
					td.style.textAlign = 'center';
					tr.appendChild(td);
				});
				tbody.appendChild(tr);
			});
		}

		renderTable(beforeJson, 'beforeTable', '修改前', this.translate);
		renderTable(afterJson, 'afterTable', '修改后', this.translate);
	},
	methods: {
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<div class="table-container" v-for="(item, index) in compareData" :key="index">
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
.table-container {
	margin: 0 auto;
	display: flex;
	justify-content: center;
	flex-direction: column;
}

.container {
	border-radius: 8px;
	max-width: 1100px;
	max-height: 700px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 10px;
}

.table-header,
.table-d {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: center;
}

.status-cell {
	font-weight: bold;
	text-align: center;
	background-color: #f0f0f0;
}
</style>
