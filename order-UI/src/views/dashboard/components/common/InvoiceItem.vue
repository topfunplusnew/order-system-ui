<script>
import InvoiceIcon from '@/views/dashboard/components/common/InvoiceIcon.vue';
import EllipsisText from '@/views/dashboard/components/common/EllipsisText.vue';

export default {
	name: 'InvoiceItem',
	components: { EllipsisText, InvoiceIcon },
	props: {
		invoice: {
			type: Object,
			default: () => {
				return {};
			}
		}
	},
	data() {
		return {
			visible: false
		};
	},
	methods: {
		handleCheckInvoice() {
			this.visible = true;
		}
	}
};
</script>

<template>
	<div>
		<div class="invoice">
			<div>
				<h4 class="invoice-title">
					<InvoiceIcon />
					<span>张明测试数据</span>
				</h4>
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

		<!--		查看开票信息的弹窗-->
		<el-dialog
			title="开票信息"
			:visible.sync="visible"
			width="400px"
			append-to-body
		>
			<el-descriptions title="开票信息" size="mini">
				<el-descriptions-item label="公司名称">
					<EllipsisText :title="invoice.companyName" />
				</el-descriptions-item>
				<el-descriptions-item label="我方开票实体">
					<EllipsisText :title="invoice.invoiceObject" />
				</el-descriptions-item>
				<el-descriptions-item label="发票日期">
					<EllipsisText :title="invoice.invoiceDate" />
				</el-descriptions-item>
				<el-descriptions-item label="发票金额">
					<EllipsisText :title="invoice.invoiceAmount" />
				</el-descriptions-item>
				<el-descriptions-item label="公司类型">
					<EllipsisText :title="invoice.companyType" />
				</el-descriptions-item>
				<el-descriptions-item label="开票公司名称">
					<EllipsisText :title="invoice.invoiceCompanyName" />
				</el-descriptions-item>
				<el-descriptions-item label="票点">
					<EllipsisText :title="invoice.ticketPoint" />
				</el-descriptions-item>
				<el-descriptions-item label="票点金额">
					<EllipsisText :title="invoice.ticketPointAmount" />
				</el-descriptions-item>
				<el-descriptions-item label="备注">
					<EllipsisText :title="invoice.comments" />
				</el-descriptions-item>
			</el-descriptions>
			<span slot="footer" class="dialog-footer">
				<el-button @click="visible = false">取 消</el-button>
				<el-button type="primary" @click="visible = false">确 定</el-button>
			</span>
		</el-dialog>
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
	display: flex;
	flex-direction: row;
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
