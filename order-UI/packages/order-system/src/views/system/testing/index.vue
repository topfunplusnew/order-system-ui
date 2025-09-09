<template>
	<div style="padding: 20px">
		<h2>RECEIVE_MONEY组件测试</h2>

		<!-- 测试组件1 -->
		<RECEIVE_MONEY :needToShowInfo="mockData1" />

		<!-- 测试组件2 -->
		<RECEIVE_MONEY :needToShowInfo="mockData2" />

		<!-- 测试组件3 -->
		<RECEIVE_MONEY :needToShowInfo="mockData3" />

		<h2 style="margin-top: 40px">PAYMENT组件测试</h2>

		<!-- 付款测试组件1 -->
		<PAYMENT :needToShowInfo="paymentMockData1" />

		<!-- 付款测试组件2 -->
		<PAYMENT :needToShowInfo="paymentMockData2" />

		<!-- 付款测试组件3 -->
		<PAYMENT :needToShowInfo="paymentMockData3" />
	</div>
</template>
<script>
import SockJS from 'sockjs-client';
import Stomp from 'webstomp-client';
import RECEIVE_MONEY from '@/components/NeedToShow/RECEIVE_MONEY.vue';
import PAYMENT from '@/components/NeedToShow/PAYMENT.vue';
import { TableName } from '@/api/tool/enums';

export default {
	components: {
		RECEIVE_MONEY,
		PAYMENT
	},
	data() {
		const ip = `http://223.254.129.240:60036/ws`;
		// 连接到后端 WebSocket
		const socket = new SockJS(ip);
		const stompClient = Stomp.over(socket);

		return {
			socket,
			stompClient,
			// 模拟数据1 - 普通收款信息
			mockData1: {
				id: 1,
				companyType: '货主公司',
				fundsDate: '2024-12-20',
				moneyAmount: 15000,
				otherAcountsName: '深圳市华润物流有限公司',
				comments: '货款结算',
				tableName: TableName.GOODS_ORDER,
				tID: 123
			},
			// 模拟数据2 - 司机收款信息
			mockData2: {
				id: 2,
				companyType: '司机',
				fundsDate: '2024-12-21',
				moneyAmount: 3500.5,
				otherAcountsName: '张师傅',
				comments: '运费支付',
				tableName: TableName.ORDER_FREIGHT,
				tID: 456
			},
			// 模拟数据3 - 无备注的收款信息
			mockData3: {
				id: 3,
				companyType: '供应商公司',
				fundsDate: '2024-12-22',
				moneyAmount: 28000.88,
				otherAcountsName: null,
				comments: null,
				tableName: TableName.INVOICE_IN,
				tID: 789
			},
			// 付款模拟数据1 - 已支付已审核
			paymentMockData1: {
				id: 101,
				companyType: '供应商公司',
				fundsDate: '2024-12-18',
				moneyAmount: 25000,
				paymentState: '已支付',
				auditState: '已审核',
				otherAcountsName: '广州物流科技有限公司',
				otherBankNo: '6214830123456789',
				otherBankName: '中国建设银行广州分行',
				userName: '李经理',
				comments: '采购款项结算',
				tableName: TableName.GOODS_ORDER,
				tID: 201
			},
			// 付款模拟数据2 - 未支付待审核
			paymentMockData2: {
				id: 102,
				companyType: '司机',
				fundsDate: '2024-12-19',
				moneyAmount: 4500,
				paymentState: '未支付',
				auditState: '待审核',
				otherAcountsName: '王师傅',
				otherBankNo: '6228480123456789',
				otherBankName: '中国农业银行深圳分行',
				userName: '张主管',
				comments: '运费支付',
				tableName: TableName.ORDER_FREIGHT,
				tID: 202
			},
			// 付款模拟数据3 - 部分信息为空
			paymentMockData3: {
				id: 103,
				companyType: '货主公司',
				fundsDate: '2024-12-20',
				moneyAmount: 18000,
				paymentState: '已支付',
				auditState: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				userName: '陈会计',
				comments: null,
				tableName: TableName.INVOICE_OUT,
				tID: 203
			}
		};
	},
	mounted() {
		this.stompClient.connect({}, () => {
			// 订阅消息
			this.stompClient.subscribe('/topic/exportevent', message => {
				console.log('收到消息:', message.body);
			});

			this.stompClient.subscribe('/topic/messages', message => {
				console.log('收到消息:', message.body);
			});
		});
	},
	methods: {}
};
</script>
<style lang="scss" scoped></style>
