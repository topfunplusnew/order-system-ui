<template>
	<div class="fund-change-test-page">
		<el-card class="fund-change-test-card">
			<div slot="header" class="clearfix">
				<span class="card-title">资金变动模板组件测试</span>
			</div>
			<el-collapse v-model="fundChangeActiveNames">
				<el-collapse-item name="inventory" title="入库管理 InventoryChangeTemplate">
					<InventoryChangeTemplate :compare-data="inventoryMainMock" module-name="inventory_main" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="exwarehouse" title="二次出库 SecondOutboundTemplate">
					<SecondOutboundTemplate :compare-data="exwarehouseMock" module-name="exwarehouse" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="order" title="订单调整单 OrderAdjustmentTemplate">
					<OrderAdjustmentTemplate :compare-data="orderAdjustmentMock" module-name="goodsorder" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="ticket" title="票点 TicketPointTemplate">
					<TicketPointTemplate :compare-data="ticketPointMock" module-name="invoicein" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="receive" title="收款 ReceiveMoneyTemplate">
					<ReceiveMoneyTemplate :compare-data="receiveMoneyMock" module-name="receivemoney" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="payment" title="付款 PaymentTemplate">
					<PaymentTemplate :compare-data="paymentMock" module-name="payment" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="offset" title="冲抵款 OffsetPaymentTemplate">
					<OffsetPaymentTemplate :compare-data="offsetPaymentMock" module-name="cash_record" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="balance" title="平账 BalanceAccountTemplate">
					<BalanceAccountTemplate :compare-data="balanceAccountsMock" module-name="balanceaccounts" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="borrowIn" title="借入款管理 BorrowInTemplate">
					<BorrowInTemplate :compare-data="borrowedMoneyMock" module-name="borrowedmoney" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="lend" title="从我司借款 BorrowFromCompanyTemplate">
					<BorrowFromCompanyTemplate :compare-data="lendMoneyMock" module-name="lendmoney" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="deposit" title="收取保证金 ReceiveDepositTemplate">
					<ReceiveDepositTemplate :compare-data="depositMoneyMock" module-name="deposit_money" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="futures" title="期货保证金 FuturesDepositTemplate">
					<FuturesDepositTemplate :compare-data="futuresDepositMock" module-name="lendmoney" :summary-data="{}" />
				</el-collapse-item>
				<el-collapse-item name="supplierDeposit" title="厂家保证金 SupplierDepositTemplate">
					<SupplierDepositTemplate :compare-data="supplierDepositMock" module-name="lendmoney" :summary-data="{}" />
				</el-collapse-item>
			</el-collapse>
		</el-card>
	</div>
</template>

<script>
import OrderAdjustmentTemplate from '../../../../../ui-components/components/FundChangeTemplates/OrderAdjustmentTemplate/index.vue';
import InventoryChangeTemplate from '../../../../../ui-components/components/FundChangeTemplates/InventoryChangeTemplate/index.vue';
import SecondOutboundTemplate from '../../../../../ui-components/components/FundChangeTemplates/SecondOutboundTemplate/index.vue';
import TicketPointTemplate from '../../../../../ui-components/components/FundChangeTemplates/TicketPointTemplate/index.vue';
import ReceiveMoneyTemplate from '../../../../../ui-components/components/FundChangeTemplates/ReceiveMoneyTemplate/index.vue';
import PaymentTemplate from '../../../../../ui-components/components/FundChangeTemplates/PaymentTemplate/index.vue';
import OffsetPaymentTemplate from '../../../../../ui-components/components/FundChangeTemplates/OffsetPaymentTemplate/index.vue';
import BalanceAccountTemplate from '../../../../../ui-components/components/FundChangeTemplates/BalanceAccountTemplate/index.vue';
import BorrowInTemplate from '../../../../../ui-components/components/FundChangeTemplates/BorrowInTemplate/index.vue';
import BorrowFromCompanyTemplate from '../../../../../ui-components/components/FundChangeTemplates/BorrowFromCompanyTemplate/index.vue';
import ReceiveDepositTemplate from '../../../../../ui-components/components/FundChangeTemplates/ReceiveDepositTemplate/index.vue';
import FuturesDepositTemplate from '../../../../../ui-components/components/FundChangeTemplates/FuturesDepositTemplate/index.vue';
import SupplierDepositTemplate from '../../../../../ui-components/components/FundChangeTemplates/SupplierDepositTemplate/index.vue';
import { inventoryMainMock, exwarehouseMock, orderAdjustmentMock, ticketPointMock, receiveMoneyMock, paymentMock, offsetPaymentMock, balanceAccountsMock, borrowedMoneyMock, lendMoneyMock, depositMoneyMock, futuresDepositMock, supplierDepositMock } from './fundChangeTemplateMockData.js';

export default {
	name: 'FundChangeTemplateTest',
	components: {
		OrderAdjustmentTemplate,
		InventoryChangeTemplate,
		SecondOutboundTemplate,
		TicketPointTemplate,
		ReceiveMoneyTemplate,
		PaymentTemplate,
		OffsetPaymentTemplate,
		BalanceAccountTemplate,
		BorrowInTemplate,
		BorrowFromCompanyTemplate,
		ReceiveDepositTemplate,
		FuturesDepositTemplate,
		SupplierDepositTemplate
	},
	data() {
		return {
			fundChangeActiveNames: ['inventory'],
			inventoryMainMock,
			exwarehouseMock,
			orderAdjustmentMock,
			ticketPointMock,
			receiveMoneyMock,
			paymentMock,
			offsetPaymentMock,
			balanceAccountsMock,
			borrowedMoneyMock,
			lendMoneyMock,
			depositMoneyMock,
			futuresDepositMock,
			supplierDepositMock
		};
	}
};
</script>

<style scoped lang="scss">
.fund-change-test-page {
	margin: 20px;
}

.fund-change-test-card {
	.card-title {
		font-weight: bold;
		font-size: 16px;
	}
	::v-deep .el-collapse-item__content {
		padding: 10px 0;
	}
}
</style>
