<!--发货单组件-->
<script>
import { numToChineseUppercase } from '@/api/tool/format';
import { getCustomerSubjectDetailSomeDay } from '@/api/system/statement';
import { parseTime } from '@/utils/ruoyi';
import { listOrderDetailByOrderNos } from '@/api/system/orderDetail';
import { fix } from '../../../../api/tool/format';
import { formatTime } from 'jest-util';

export default {
	name: 'ChatForm',
	props: {
		orderInfo: {
			type: Object,
			default: function () {}
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
		// 货款合计
		totalPayments() {
			return Number(this.moneyAmount) - Number(this.orderInfo.allPayments);
		}
	},
	created() {
		// 查询该订单的货物
		const orderNos = this.currentOrderInfo?.smailOrderDetails.map(item => {
			return item.ordersNo;
		});
		// 根据ordersNo 批量查询订单货物
		listOrderDetailByOrderNos(orderNos).then(res => {
			this.itemList = res.rows;
		});
		// 查询客户余额 指定时间结转 日期为当前时间
		const query = {
			beginTime: parseTime(new Date()),
			companyId: this.currentOrderInfo.customerID
		};
		// 查询客户余额
		getCustomerSubjectDetailSomeDay(query).then(res => {
			this.moneyAmount = res.data.moneyAmount;
			console.log(res);
		});
	},
	mounted() {
		console.log(this.currentOrderInfo);
	},
	methods: {
		formatTime,
		fix,
		numToChineseUppercase,
		printHTML() {
			this.$print({
				printable: 'printBoxs',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		}
	}
};
</script>

<template>
	<div>
		<el-row>
			<el-button @click="printHTML">打印</el-button>
		</el-row>
		<div id="printBoxs" class="invoice-container">
			<div class="invoice-title">销货发货单</div>

			<div class="invoice-header">
				<div>客户：{{ orderInfo.customer }}</div>
				<div>日期：{{ formatTime(orderInfo.orderDate, 'yyyy-MM-dd') }}</div>
			</div>

			<table>
				<thead>
					<tr>
						<!--						<th>日期</th>-->
						<th>等级</th>
						<th>厚度(mm)</th>
						<th colspan="2">规格</th>
						<th>片数</th>
						<th>数量</th>
						<th>单价</th>
						<th>是否含税价</th>
						<th>其他费用</th>
						<th>金额</th>
						<th>车号</th>
					</tr>
				</thead>
				<tbody>
					<template v-if="orderInfo.smailOrderDetails.length > 0">
						<tr v-for="item in itemList" :key="item.ordersNo">
							<!--							<td>{{ item.orderDate }}</td>-->
							<td>{{ item.levelName }}</td>
							<td>{{ item.height }}</td>
							<td>{{ item.length }}</td>
							<td>{{ item.width }}</td>
							<td>{{ item.pieces }}</td>
							<td>{{ item.packs }}</td>
							<td>{{ item.price }}</td>
							<td>
								{{ item.isIncludeTaxFactory === 0 ? '否' : '是' }}
							</td>
							<td>{{ item.otherCost }}</td>
							<td>{{ item.payments }}</td>
							<td>{{ orderInfo.landCarNo }}</td>
						</tr>
					</template>
					<!--  这里是货物的列表 要根据订单货物的列表来渲染-->
					<tr>
						<td />
						<td style="text-align: left">货款</td>
						<td colspan="8" />
						<td>{{ fix(orderInfo.allPayments) }}</td>
						<td />
					</tr>
					<tr>
						<td />
						<td style="text-align: left">余额</td>
						<td colspan="8" />
						<td>{{ fix(moneyAmount) }}</td>
						<td />
					</tr>
					<tr>
						<td />
						<!-- 货款 + 余额-->
						<td style="text-align: left">货款合计</td>
						<td colspan="8" />
						<td>{{ fix(totalPayments) }}</td>
						<td />
					</tr>
					<tr>
						<td />
						<!--          合计只有一个大写-->
						<td style="text-align: left">合计</td>
						<td colspan="8">大写：{{ numToChineseUppercase(totalPayments) }}</td>
						<td />
						<td />
					</tr>
				</tbody>
			</table>

			<div class="footer-note">
				<p>注：</p>
				<p>1.玻璃为易碎品，请当面验货（若遇破损、淋雨、气泡、结石等一切质量问题均由司当面解决，收货后出现问题由客户自负，我公司概不负责）。</p>
				<p>2.此单据等同合同，收货方签字认可后具有法律效力。</p>
				<p>3.若发生纠纷，双方同意由供货方所在地法院处理。</p>
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
