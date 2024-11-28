<script>
import EllipsisText from '@/views/dashboard/components/common/EllipsisText.vue';
import InvoiceItem from '@/views/dashboard/components/common/InvoiceItem.vue';
import { mapGetters } from 'vuex';

export default {
	name: 'InvoiceBody',
	components: { InvoiceItem, EllipsisText },
	props: {},
	data() {
		return {
			visible: false
		};
	},
	computed: {
		...mapGetters(['selectedInvoiceList'])
	}
};
</script>

<template>
	<div>
		<el-card class="box-card">
			<div slot="header" class="clearfix">
				<span class="bold-text">开票信息</span>
			</div>
			<div>
				<InvoiceItem
					v-for="(item, index) in selectedInvoiceList"
					:key="index"
				/>
			</div>
		</el-card>

		<!--    查看开票信息的弹窗-->
		<!--		<el-dialog title="开票信息" :visible.sync="visible" width="30%">-->
		<!--			<el-descriptions title="开票信息" size="mini">-->
		<!--				<el-descriptions-item label="公司名称">-->
		<!--					<EllipsisText :title="invoiceIn.companyName" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="老板">-->
		<!--					<EllipsisText :title="invoiceIn.leader" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="区域">-->
		<!--					<EllipsisText :title="invoiceIn.region" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="联系电话">-->
		<!--					<EllipsisText :title="invoiceIn.leaderTel" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="备注">-->
		<!--					<EllipsisText :title="invoiceIn.comments" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="发票日期">-->
		<!--					<EllipsisText :title="invoiceIn.invoiceDate" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="发票对象">-->
		<!--					<EllipsisText :title="invoiceIn.invoiceObject" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="发票金额">-->
		<!--					<EllipsisText :title="invoiceIn.invoiceAmount" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="公司类型">-->
		<!--					<EllipsisText :title="invoiceIn.companyType" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="开票公司名称">-->
		<!--					<EllipsisText :title="invoiceIn.invoiceCompanyName" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="票点">-->
		<!--					<EllipsisText :title="invoiceIn.ticketPoint" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="票点金额">-->
		<!--					<EllipsisText :title="invoiceIn.ticketPointAmount" />-->
		<!--				</el-descriptions-item>-->
		<!--				<el-descriptions-item label="是否开票税">-->
		<!--					<EllipsisText :title="invoiceIn.isOrderTax ? '是' : '否'" />-->
		<!--				</el-descriptions-item>-->
		<!--				<span slot="footer" class="dialog-footer">-->
		<!--					<el-button @click="visible = false">取 消</el-button>-->
		<!--					<el-button type="primary" @click="visible = false">确 定</el-button>-->
		<!--				</span>-->
		<!--			</el-descriptions>-->
		<!--		</el-dialog>-->
	</div>
</template>

<style scoped lang="scss">
.bold-text {
	font-weight: bold;
}
</style>
