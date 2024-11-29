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
					:invoice="item"
				/>
			</div>
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.bold-text {
	font-weight: bold;
}
</style>
