<script>
export default {
	name: 'InvoiceItem',
	props: {
		invoice: {
			type: Object,
			default: () => {
				return {};
			}
		}
	},
	data() {
		return {};
	},
	methods: {
		handleCheckInvoice() {}
	}
};
</script>

<template>
	<div>
		<div class="invoice">
			<div>
				<h4 class="invoice-title">张明测试数据</h4>
				<p class="invoice-pra">
					开票金额：<span style="color: #72d511">500</span>
				</p>
			</div>
			<div class="invoice-option">
				<el-button type="primary" size="mini" @click="handleCheckInvoice">
					查看开票信息
				</el-button>
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss">
.invoice {
	width: 100%;
	margin: 10px;
	height: 70px;
	border-radius: 15px;
	background-color: #f8f8f9;
	display: flex;
	justify-content: space-around;
	border: 2px solid #409eff;
	align-items: center;
}

.invoice-title {
	font-weight: bolder;
	margin-top: 10px;
	text-align: left;
	font-size: 16px;
}

.invoice-pra {
	font-weight: bold;
}

.invoice-option {
	display: flex;
	justify-content: center;
	align-items: center;
}
</style>
