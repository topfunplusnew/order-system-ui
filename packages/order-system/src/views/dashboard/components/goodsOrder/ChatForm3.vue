<script>
import { fix, numToChineseUppercase } from '../../../../api/tool/format';
import { listOrderDetailByOrderNos } from '@/api/system/orderDetail';
import { parseTime } from '../../../../utils/ruoyi';
import { getCustomerSubjectDetailSomeDay } from '@/api/system/statement';

export default {
	name: 'ChatForm3',
	props: {
		orderInfo: {
			type: Object,
			default: function () {}
		},
		mergedOrderDetails: {
			type: Array,
			default: () => null
		}
	},
	data() {
		return {
			currentOrderInfo: this.orderInfo,
			itemList: [],
			moneyAmount: null
		};
	},
	computed: {
		// 所有明细的货款之和
		detailPaymentsSum() {
			if (!this.itemList || this.itemList.length === 0) return 0;
			return Math.floor(this.itemList.reduce((sum, item) => sum + (Number(item.payments) || 0), 0));
		},
		// 合计欠款
		totalPayments() {
			return Math.floor(Number(this.moneyAmount) - this.detailPaymentsSum);
		}
	},
	created() {
		if (this.mergedOrderDetails && this.mergedOrderDetails.length > 0) {
			this.itemList = this.mergedOrderDetails;
			this.loadCustomerMoneyNextDay();
		} else {
			this.loadOrderDetails();
		}
	},
	mounted() {
		console.log(this.currentOrderInfo);
	},
	methods: {
		fix,
		loadOrderDetails() {
			const orderNos = this.currentOrderInfo?.smailOrderDetails.map(item => {
				return item.ordersNo;
			});
			listOrderDetailByOrderNos(orderNos).then(res => {
				this.itemList = res.rows;
			});
			this.loadCustomerMoneyNextDay();
		},
		loadCustomerMoneyNextDay() {
			const currentDateTime = new Date(this.currentOrderInfo.orderDate);
			const nextDayMidnight = new Date(currentDateTime);
			nextDayMidnight.setDate(currentDateTime.getDate() + 1);
			nextDayMidnight.setHours(0, 0, 0, 0);
			const query = {
				beginTime: parseTime(nextDayMidnight),
				companyId: this.currentOrderInfo.customerID
			};
			getCustomerSubjectDetailSomeDay(query).then(res => {
				this.moneyAmount = res.data.moneyAmount;
			});
		},
		printHTML() {
			this.$print({
				printable: 'printBoxs',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		async copyTable() {
			try {
				// 获取整个打印容器元素
				const container = document.getElementById('printBoxs');
				if (!container) {
					this.$message.error('未找到内容');
					return;
				}

				// 获取title和header内容
				const titleEl = container.querySelector('.invoice-title');
				const headerEl = container.querySelector('.invoice-header');
				const tableEl = container.querySelector('#copyTable');

				if (!tableEl) {
					this.$message.error('未找到表格');
					return;
				}

				const titleText = titleEl ? titleEl.textContent.trim() : '';
				const headerTexts = headerEl ? Array.from(headerEl.querySelectorAll('div')).map(div => div.textContent.trim()) : [];

				// 计算表格列数（从thead的第一行计算）
				const firstRow = tableEl.querySelector('thead tr');
				let colCount = 0;
				if (firstRow) {
					Array.from(firstRow.querySelectorAll('th')).forEach(th => {
						const colspan = parseInt(th.getAttribute('colspan') || '1');
						colCount += colspan;
					});
				}
				// 如果没有thead，从tbody第一行计算
				if (colCount === 0) {
					const firstBodyRow = tableEl.querySelector('tbody tr');
					if (firstBodyRow) {
						colCount = firstBodyRow.querySelectorAll('td').length;
					}
				}
				// 默认7列（ChatForm3的列数）
				if (colCount === 0) colCount = 7;

				// 克隆表格
				const tableClone = tableEl.cloneNode(true);
				const thead = tableClone.querySelector('thead');
				const tbody = tableClone.querySelector('tbody') || tableClone;

				// 创建新的thead（如果不存在）
				let newThead = thead;
				if (!newThead) {
					newThead = document.createElement('thead');
					tableClone.insertBefore(newThead, tbody);
				}

				// 在thead最前面添加title行
				if (titleText) {
					const titleRow = document.createElement('tr');
					const titleCell = document.createElement('td');
					titleCell.setAttribute('colspan', colCount);
					titleCell.style.textAlign = 'center';
					titleCell.style.fontSize = '20px';
					titleCell.style.fontWeight = 'bold';
					titleCell.style.padding = '8px';
					titleCell.textContent = titleText;
					titleRow.appendChild(titleCell);
					newThead.insertBefore(titleRow, newThead.firstChild);
				}

				// 在title行后面添加header行
				if (headerTexts.length > 0) {
					const headerRow = document.createElement('tr');
					const colSpanPerHeader = Math.floor(colCount / headerTexts.length);
					const remainder = colCount % headerTexts.length;

					headerTexts.forEach((text, index) => {
						const headerCell = document.createElement('td');
						// 最后一个单元格包含余数
						const colspan = index === headerTexts.length - 1 ? colSpanPerHeader + remainder : colSpanPerHeader;
						headerCell.setAttribute('colspan', colspan);
						headerCell.style.textAlign = 'left';
						headerCell.style.padding = '4px';
						headerCell.textContent = text;
						headerRow.appendChild(headerCell);
					});

					// 插入到title行之后
					if (newThead.querySelector('tr')) {
						newThead.insertBefore(headerRow, newThead.querySelector('tr').nextSibling);
					} else {
						newThead.appendChild(headerRow);
					}
				}

				// 创建一个包含样式的 HTML 字符串
				const htmlContent = `
					<html>
						<head>
							<meta charset="utf-8">
							<style>
								table {
									width: 100%;
									border-collapse: collapse;
									margin-bottom: 10px;
								}
								table, th, td {
									border: 1px solid #000;
								}
								th, td {
									text-align: center;
									padding: 4px;
									font-size: 14px;
								}
								td[style*="text-align: center"] {
									text-align: center !important;
								}
								td[style*="text-align: left"] {
									text-align: left !important;
								}
								table p {
									padding: 2px;
								}
							</style>
						</head>
						<body>
							${tableClone.outerHTML}
						</body>
					</html>
				`;

				// 创建纯文本版本（备用）
				const textContent = tableClone.innerText || tableClone.textContent;

				// 使用 Clipboard API 复制
				const clipboardItem = new ClipboardItem({
					'text/html': new Blob([htmlContent], { type: 'text/html' }),
					'text/plain': new Blob([textContent], { type: 'text/plain' })
				});

				await navigator.clipboard.write([clipboardItem]);
				this.$message.success('内容已复制到剪贴板');
			} catch (error) {
				console.error('复制失败:', error);
				// 降级方案：使用传统的 execCommand
				try {
					const container = document.getElementById('printBoxs');
					if (!container) {
						this.$message.error('未找到内容');
						return;
					}

					// 使用相同的逻辑构建表格
					const titleEl = container.querySelector('.invoice-title');
					const headerEl = container.querySelector('.invoice-header');
					const tableEl = container.querySelector('#copyTable');

					if (!tableEl) {
						this.$message.error('未找到表格');
						return;
					}

					const titleText = titleEl ? titleEl.textContent.trim() : '';
					const headerTexts = headerEl ? Array.from(headerEl.querySelectorAll('div')).map(div => div.textContent.trim()) : [];

					const firstRow = tableEl.querySelector('thead tr');
					let colCount = 0;
					if (firstRow) {
						Array.from(firstRow.querySelectorAll('th')).forEach(th => {
							const colspan = parseInt(th.getAttribute('colspan') || '1');
							colCount += colspan;
						});
					}
					if (colCount === 0) {
						const firstBodyRow = tableEl.querySelector('tbody tr');
						if (firstBodyRow) {
							colCount = firstBodyRow.querySelectorAll('td').length;
						}
					}
					if (colCount === 0) colCount = 7;

					const tableClone = tableEl.cloneNode(true);
					const thead = tableClone.querySelector('thead');
					const tbody = tableClone.querySelector('tbody') || tableClone;

					let newThead = thead;
					if (!newThead) {
						newThead = document.createElement('thead');
						tableClone.insertBefore(newThead, tbody);
					}

					if (titleText) {
						const titleRow = document.createElement('tr');
						const titleCell = document.createElement('td');
						titleCell.setAttribute('colspan', colCount);
						titleCell.style.textAlign = 'center';
						titleCell.style.fontSize = '20px';
						titleCell.style.fontWeight = 'bold';
						titleCell.style.padding = '8px';
						titleCell.textContent = titleText;
						titleRow.appendChild(titleCell);
						newThead.insertBefore(titleRow, newThead.firstChild);
					}

					if (headerTexts.length > 0) {
						const headerRow = document.createElement('tr');
						const colSpanPerHeader = Math.floor(colCount / headerTexts.length);
						const remainder = colCount % headerTexts.length;

						headerTexts.forEach((text, index) => {
							const headerCell = document.createElement('td');
							const colspan = index === headerTexts.length - 1 ? colSpanPerHeader + remainder : colSpanPerHeader;
							headerCell.setAttribute('colspan', colspan);
							headerCell.style.textAlign = 'left';
							headerCell.style.padding = '4px';
							headerCell.textContent = text;
							headerRow.appendChild(headerCell);
						});

						if (newThead.querySelector('tr')) {
							newThead.insertBefore(headerRow, newThead.querySelector('tr').nextSibling);
						} else {
							newThead.appendChild(headerRow);
						}
					}

					const range = document.createRange();
					range.selectNodeContents(tableClone);
					const selection = window.getSelection();
					selection.removeAllRanges();
					selection.addRange(range);
					document.execCommand('copy');
					selection.removeAllRanges();
					this.$message.success('内容已复制到剪贴板');
				} catch (fallbackError) {
					console.error('降级复制方案也失败:', fallbackError);
					this.$message.error('复制失败，请手动选择内容复制');
				}
			}
		}
	}
};
</script>

<template>
	<div>
		<el-row>
			<el-button @click="printHTML">打印</el-button>
			<el-button type="primary" @click="copyTable">复制内容</el-button>
		</el-row>
		<div id="printBoxs" class="invoice-container">
			<div class="invoice-title">发货单</div>

			<div class="invoice-header">
				<div>客户：{{ orderInfo.customer }}</div>
				<div>日期：{{ orderInfo.orderDate }}</div>
				<div>车号：{{ orderInfo.landCarNo }}</div>
				<div>单据编号：{{ orderInfo.code }}</div>
			</div>

			<table id="copyTable">
				<thead>
					<tr>
						<th>商品名称</th>
						<th>片数</th>
						<th>包数</th>
						<th>单价</th>
						<th>发票</th>
						<th>费用</th>
						<th>金额</th>
					</tr>
				</thead>
				<tbody>
					<template v-if="orderInfo.smailOrderDetails.length > 0">
						<tr v-for="item in itemList" :key="item.ordersNo">
							<td>
								{{ item.levelName }} - {{ item.height }} x {{ item.length }} x
								{{ item.width }}
							</td>
							<td>{{ item.pieces }}</td>
							<td>{{ item.packs }}</td>
							<td>{{ Math.floor(item.paymentUnload) }}</td>
							<td>
								{{ item.isIncludeTaxFactory === 0 ? '否' : '是' }}
							</td>
							<td>{{ Math.floor(item.paymentsWithSundry) }}</td>
							<td>{{ Math.floor(item.payments) }}</td>
						</tr>
					</template>
					<tr>
						<td style="text-align: left">本次货款</td>
						<td colspan="5" style="text-align: left">大写:{{ numToChineseUppercase(detailPaymentsSum) }}</td>
						<td>{{ detailPaymentsSum || 0 }}</td>
					</tr>
					<tr>
						<td style="text-align: left">欠款</td>
						<td colspan="5" style="text-align: left">大写:{{ numToChineseUppercase(Math.floor(moneyAmount) || 0) }}</td>
						<td>{{ totalPayments || 0 }}</td>
					</tr>
					<tr>
						<td style="text-align: left">合计欠款</td>
						<td colspan="5" style="text-align: left">大写:{{ numToChineseUppercase(Math.floor(moneyAmount)) }}</td>
						<td>{{ Math.floor(moneyAmount) || 0 }}</td>
					</tr>
					<tr>
						<td colspan="7" style="text-align: left">
							<p>注：</p>
							<p>1. 玻璃为易碎品，请当面验货，出现问题由司当面解决，收货后出现一切质量问题，由客户自负，我公司概不负责。</p>
							<p>2. 此单据等同合同，客户收货后具有法律效力，若发生经济纠纷，由供货方所在地法庭处理。</p>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</template>

<style scoped lang="scss">
.invoice-container {
	width: 950px;
	margin: 0 auto;
	padding: 20px;
	background: #fff;
}

.invoice-title {
	text-align: center;
	font-size: 20px;
	font-weight: bold;
	margin-bottom: 10px;
}

.invoice-header {
	display: flex;
	justify-content: space-between;
	margin-bottom: 20px;
	font-size: 14px;
}

.invoice-header div {
	margin-right: 20px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 10px;
}

table,
th,
td {
	border: 1px solid #000;

	p {
		padding: 2px;
	}
}

th,
td {
	text-align: center;
	padding: 4px;
	font-size: 14px;
}
</style>
