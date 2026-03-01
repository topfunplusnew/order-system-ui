<!--发货单组件-->
<script>
import { numToChineseUppercase } from '@/api/tool/format';
import { getCustomerSubjectDetailSomeDay } from '@/api/system/statement';
import { parseTime } from '@/utils/ruoyi';
import { listOrderDetailByOrderNos } from '@/api/system/orderDetail';
// 任务13：发货单1/2/3 单价不再取整，改为保留两位小数展示
import { fix, fix_2 } from '../../../../api/tool/format';
import { round, number, sum, subtract } from 'mathjs';

export default {
	name: 'ChatForm',
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
		/** 所有明细的货款之和（基于每行四舍五入取整后的值求和） */
		detailPaymentsSum() {
			if (!this.itemList || this.itemList.length === 0) return 0;
			const roundedValues = this.itemList.map(item => round(number(item.payments) || 0));
			return sum(roundedValues);
		},
		/** 余款 = 货款合计 - 本次货款（均基于四舍五入后的值） */
		totalPayments() {
			return subtract(round(number(this.moneyAmount) || 0), this.detailPaymentsSum);
		},
		// 任务14：发货单1/2/3 车号/柜号、海运公司等明细字段，统一从每条明细中取值（不取主表字段）
		hasSeaCarNo() {
			return Array.isArray(this.itemList) && this.itemList.some(item => !!item?.seaCarNo);
		},
		hasLandCarNo() {
			return Array.isArray(this.itemList) && this.itemList.some(item => !!item?.landCarNo);
		},
		carNoColumnLabel() {
			if (this.hasLandCarNo && this.hasSeaCarNo) return '车号/柜号';
			if (this.hasSeaCarNo) return '柜号';
			return '车号';
		}
	},
	created() {
		if (this.mergedOrderDetails && this.mergedOrderDetails.length > 0) {
			this.itemList = this.mergedOrderDetails;
			this.loadCustomerMoney();
		} else {
			this.loadOrderDetails();
		}
	},
	methods: {
		fix,
		fix_2,
		loadOrderDetails() {
			const orderNos = this.currentOrderInfo?.smailOrderDetails.map(item => {
				return item.ordersNo;
			});
			listOrderDetailByOrderNos(orderNos).then(res => {
				this.itemList = res.rows;
			});
			this.loadCustomerMoney();
		},
		loadCustomerMoney() {
			const query = {
				beginTime: parseTime(new Date()),
				companyId: this.currentOrderInfo.customerID
			};
			getCustomerSubjectDetailSomeDay(query).then(res => {
				this.moneyAmount = res.data.moneyAmount;
			});
		},
		numToChineseUppercase,
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

				// 获取title、header、表格、底部注
				const titleEl = container.querySelector('.invoice-title');
				const headerEl = container.querySelector('.invoice-header');
				const tableEl = container.querySelector('#copyTable');
				const footerNoteEl = container.querySelector('.footer-note');

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
				// 默认12列（ChatForm的列数）
				if (colCount === 0) colCount = 12;

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

				// 创建完整复制内容（表格 + 底部注）
				const footerNoteHtml = footerNoteEl ? footerNoteEl.cloneNode(true).outerHTML : '';
				const fullCloneHtml = tableClone.outerHTML + (footerNoteHtml ? footerNoteHtml : '');

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
								.footer-note {
									font-size: 12px;
									margin-top: 20px;
									line-height: 1.5;
								}
								.footer-note p {
									margin: 5px 0;
								}
							</style>
						</head>
						<body>
							${fullCloneHtml}
						</body>
					</html>
				`;

				// 创建纯文本版本（含底部注）
				const textWrapper = document.createElement('div');
				textWrapper.appendChild(tableClone.cloneNode(true));
				if (footerNoteEl) textWrapper.appendChild(footerNoteEl.cloneNode(true));
				const textContent = textWrapper.innerText || textWrapper.textContent;

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
					const footerNoteEl = container.querySelector('.footer-note');

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
					if (colCount === 0) colCount = 12;

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

					// 任务11：修复发货单复制内容按钮在降级方案下复制失败（execCommand 需要选中 DOM 内节点）
					const hiddenWrapper = document.createElement('div');
					hiddenWrapper.style.position = 'fixed';
					hiddenWrapper.style.pointerEvents = 'none';
					hiddenWrapper.style.opacity = '0';
					hiddenWrapper.style.left = '-9999px';
					hiddenWrapper.style.top = '0';
					hiddenWrapper.appendChild(tableClone);
					if (footerNoteEl) hiddenWrapper.appendChild(footerNoteEl.cloneNode(true));
					document.body.appendChild(hiddenWrapper);

					try {
						const range = document.createRange();
						range.selectNodeContents(hiddenWrapper);
						const selection = window.getSelection();
						selection.removeAllRanges();
						selection.addRange(range);
						document.execCommand('copy');
						selection.removeAllRanges();
						this.$message.success('内容已复制到剪贴板');
					} finally {
						document.body.removeChild(hiddenWrapper);
					}
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
			<div class="invoice-title">销货发货单</div>
			<div class="invoice-header">
				<div>客户：{{ currentOrderInfo.customer }}</div>
				<div>日期：{{ parseTime(currentOrderInfo.orderDate, '{y}-{m}-{d}') }}</div>
			</div>

			<table id="copyTable">
				<thead>
					<tr>
						<th>等级</th>
						<th>厚度(mm)</th>
						<th colspan="2">规格</th>
						<th>片数</th>
						<th>数量</th>
						<th>单价</th>
						<th>是否含税价</th>
						<th>其他费用</th>
						<th>金额</th>
						<th>{{ carNoColumnLabel }}</th>
						<th v-if="hasSeaCarNo">{{ `海运公司` }}</th>
					</tr>
				</thead>
				<tbody>
					<template v-if="currentOrderInfo.smailOrderDetails.length > 0">
						<tr v-for="item in itemList" :key="item.code">
							<!--							<td>{{ item.orderDate }}</td>-->
							<td>{{ item.levelName }}</td>
							<td>{{ item.height }}</td>
							<td>{{ item.length }}</td>
							<td>{{ item.width }}</td>
							<td>{{ item.actualPieces }}</td>
							<td>{{ item.packs }}</td>
							<td>{{ fix_2(item.paymentUnload || 0) }}</td>
							<td>
								{{ item.isIncludeTaxSale === 0 ? '否' : '是' }}
							</td>
							<td>{{ Math.round(item.paymentsWithSundry) }}</td>
							<td>{{ Math.round(item.payments) }}</td>
							<td>{{ item.landCarNo || item.seaCarNo }}</td>
							<td v-if="item.seaCarNo">{{ item.seaDriverName }}</td>
						</tr>
					</template>
					<!--  这里是货物的列表 要根据订单货物的列表来渲染-->
					<tr>
						<td style="text-align: center">货款</td>
						<td colspan="8" />
						<td>{{ detailPaymentsSum || 0 }}</td>
						<td />
					</tr>
					<tr>
						<td style="text-align: center">余款</td>
						<td colspan="8" />
						<td>{{ totalPayments || 0 }}</td>
						<td />
					</tr>
					<tr>
						<!-- 货款 + 余额-->
						<td style="text-align: center">货款合计</td>
						<td colspan="8" />
						<td>{{ Math.round(moneyAmount) || 0 }}</td>
						<td />
					</tr>
					<tr>
						<!--          合计只有一个大写-->
						<td style="text-align: center">合计</td>
						<td colspan="8">大写：{{ numToChineseUppercase(Math.round(moneyAmount)) }}</td>
						<td />
						<td />
					</tr>
				</tbody>
			</table>

			<div class="footer-note" style="margin-top: 40px; padding: 20px 0; font-size: 16px; line-height: 2.5">
				<p style="margin: 5px 0">注：</p>
				<p style="margin: 5px 0">1.玻璃为易碎品，请当面验货（若遇破损、淋雨、气泡、结石等一切质量问题均由司当面解决，收货后出现问题由客户自负，我公司概不负责）。</p>
				<p style="margin: 5px 0">2.此单据等同合同，收货方签字认可后具有法律效力。</p>
				<p style="margin: 5px 0">3.若发生纠纷，双方同意由供货方所在地法院处理。</p>
			</div>
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
	margin-bottom: 20px;
}

.invoice-header div {
	display: inline-block;
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
}

th,
td {
	text-align: center;
	padding: 4px;
	font-size: 14px;
}

.footer-note {
	font-size: 12px;
	margin-top: 20px;
	line-height: 1.5;
}

.btn-print {
	display: inline-block;
	padding: 5px 10px;
	margin-bottom: 10px;
	background-color: #007bff;
	color: white;
	text-decoration: none;
	border-radius: 5px;
}

.btn-print:hover {
	background-color: #0056b3;
}
</style>
