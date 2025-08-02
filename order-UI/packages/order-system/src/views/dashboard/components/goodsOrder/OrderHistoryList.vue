<script>
import { getGoodsOrder } from '@/api/system/goodsOrder';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';

export default {
	name: 'OrderHistoryList',
	components: { DialogWrapper },
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
	methods: {
		handleProcess() {},
		handleReject() {},
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
			:data="goodsOrderList"
			max-height="462px"
			size="mini"
			:cell-style="
				() => {
					return { padding: '2px' };
				}
			"
		>
			<el-table-column show-overflow-tooltip label="修改时间" align="center" prop="updateTime">
				<template #default="scope">
					{{ scope.row.tableEditMessage.modifyTime }}
				</template>
			</el-table-column>

			<el-table-column show-overflow-tooltip label="修改原因" align="center">
				<template #default="scope">
					{{ scope.row.tableEditMessage.reason }}
				</template>
			</el-table-column>

			<el-table-column show-overflow-tooltip label="修改人" align="center">
				<template #default="scope">
					{{ scope.row.tableEditMessage.userName }}
				</template>
			</el-table-column>

			<el-table-column label="操作" align="center" width="120">
				<template #default="scope">
					<el-button size="mini" type="text" @click="handleViewOrder(scope.row)">查看订单</el-button>
				</template>
			</el-table-column>
		</el-table>

		<!-- 通用弹窗组件 -->
		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
		</div>
	</div>
</template>

<style scoped lang="scss"></style>
