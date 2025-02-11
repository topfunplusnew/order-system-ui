<script>
import { getGoodsOrder } from '../../../../api/system/goodsOrder';
import InfoDialog from '../../../../components/InfoDialog.vue';
import IncentOrders from './IncentOrders.vue';

export default {
	name: 'Incent',
	components: { IncentOrders, InfoDialog },
	data() {
		return {
			orderItemVisible: false,
			orderTitle: '引用订单'
		};
	},
	methods: {
		// 查看订单 选择后自动填充相关信息
		handleCheck() {
			this.orderItemVisible = true;
		},
		handleIndexOrder(value) {
			console.log(value);
			getGoodsOrder(value.id).then(res => {
				this.$emit('update:orderInfo', res.data);
			});
		}
	}
};
</script>

<template>
	<div>
		<el-button size="mini" type="text" @click="handleCheck">查看订单</el-button>

		<InfoDialog :title="orderTitle" :visible.sync="orderItemVisible">
			<template #info>
				<IncentOrders
					@indexOrder="handleIndexOrder"
					@close="orderItemVisible = false"
				/>
			</template>
		</InfoDialog>
	</div>
</template>

<style scoped lang="scss"></style>
