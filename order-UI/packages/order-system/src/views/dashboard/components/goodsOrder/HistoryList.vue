<script>
import { getHistoryGoodsOrder } from '@/api/system/goodsOrder';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import OrderHistoryList from '@/views/dashboard/components/goodsOrder/OrderHistoryList.vue';

export default {
	name: 'HistoryList',
	components: { DialogWrapper },
	mixins: [common_dialog],
	props: {
		row: {
			type: Object,
			default() {
				return {};
			}
		}
	},
	data() {
		return {
			orderHistoryInfoList: []
		};
	},
	methods: {
		checkHistoryList() {
			const id = this.row.id;
			// 获取订单历史记录信息
			getHistoryGoodsOrder({ goodsOrderID: id }).then(res => {
				if (res.total === 0) {
					this.$message.warning('无订单历史信息');
					return;
				}
				this.orderHistoryInfoList = res.rows;
				this.openDialog(
					OrderHistoryList,
					'订单历史记录',
					'50%',
					{
						goodsOrderList: this.orderHistoryInfoList
					},
					true
				);
			});
		}
	}
};
</script>

<template>
	<div>
		<el-button style="margin-left: 5px" size="mini" type="text" @click="checkHistoryList(row)">记录查看</el-button>

		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
		</div>
	</div>
</template>

<style scoped lang="scss"></style>
