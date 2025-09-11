<script>
import { getGoodsOrder } from '@/api/system/goodsOrder';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';

export default {
	name: 'OrderHistoryList',
	mixins: [common_dialog],
	props: {
		goodsOrderList: {
			type: Array,
			default() {
				return [];
			}
		}
	},

	data() {
		return {};
	},
	computed: {
		// 过滤掉 tableEditMessage 为 null 的数据
		filteredGoodsOrderList() {
			return this.goodsOrderList.filter(item => item.tableEditMessage !== null);
		}
	},
	methods: {
		handleProcess() {
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		},
		// 查看订单详情
		handleViewOrder(row) {
			if (!row.goodsOrderID) {
				this.$message.error('订单ID不存在');
				return;
			}

			getGoodsOrder(row.goodsOrderID)
				.then(res => {
					if (!res.data) {
						this.$message.error('暂无该条订单数据');
						return;
					}

					this.openDialog(
						GOODS_ORDER,
						'订单信息',
						'900px',
						{
							needToShowInfo: res.data
						},
						false
					);
				})
				.catch(error => {
					this.$message.error('获取订单信息失败: ' + error.message);
				});
		}
	}
};
</script>

<template>
	<div>
		<el-table
			id="printBox"
			v-horizontal-scroll="'always'"
			fit
			border
			:data="filteredGoodsOrderList"
			max-height="462px"
			empty-text="暂无修改记录（一天内修改订单不会记录修改原因）"
			size="mini"
			:cell-style="
				() => {
					return { padding: '2px' };
				}
			"
		>
			<el-table-column show-overflow-tooltip label="修改时间" align="center" prop="updateTime">
				<template #default="scope">
					{{ scope.row.tableEditMessage ? scope.row.tableEditMessage.modifyTime : '-' }}
				</template>
			</el-table-column>

			<el-table-column show-overflow-tooltip label="修改原因" align="center">
				<template #default="scope">
					{{ scope.row.tableEditMessage ? scope.row.tableEditMessage.reason : '-' }}
				</template>
			</el-table-column>

			<el-table-column show-overflow-tooltip label="修改人" align="center">
				<template #default="scope">
					{{ scope.row.tableEditMessage ? scope.row.tableEditMessage.userName : '-' }}
				</template>
			</el-table-column>

			<el-table-column label="操作" align="center" width="120">
				<template #default="scope">
					<el-button size="mini" type="text" @click="handleViewOrder(scope.row)">查看订单</el-button>
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<style scoped lang="scss"></style>
