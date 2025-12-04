<script>
import OrderInfos from '../goodsOrder/OrderInfos.vue';
import { getGoodsOrder } from '../../../../api/system/goodsOrder';
import InfoDialog from '../../../../components/InfoDialog.vue';
import OrderDetailInfo from '../goodsOrder/OrderDetailInfo.vue';
import { FREIGHT_TYPE } from '../../mixins/freight/freight_payment';
import { getInventoryMain } from '../../../../api/system/inventoryMain';
import { common_dialog } from '../../mixins/common/common_dialog';
import INVENTORYVue from '../../../../components/NeedToShow/INVENTORY.vue';

export default {
	name: 'CheckOrderInfo',
	components: { OrderDetailInfo, InfoDialog, OrderInfos },
	mixins: [common_dialog],
	props: {
		row: {
			type: Object,
			default: () => {}
		}
	},
	data() {
		return {
			// 订单信息 可能为 调整单
			orderInfo: {},
			// 如果订单为 调整单的原订单信息
			adjustedOrderInfo: {},
			visible: false,
			// tab页
			activeName: 'first'
		};
	},
	computed: {
		title() {
			return this.row.source === FREIGHT_TYPE.GOODS_ORDER ? '查看订单信息' : '查看库存信息';
		}
	},
	methods: {
		// 查看运费对应的订单单据信息
		handleCheck(row) {
			// 根据获取到的订单id获取订单详情
			if (row.source === FREIGHT_TYPE.GOODS_ORDER) {
				getGoodsOrder(row.sourceId).then(res => {
					this.orderInfo = res.data;
					this.orderInfo.orderDetailList = res.data.orderDetailList;
					this.visible = true;
				});
			} else {
				getInventoryMain(row.sourceId).then(res => {
					this.openDialog(
						INVENTORYVue,
						'库存信息',
						'900px',
						{
							needToShowInfo: res.data
						},
						false
					);
				});
			}
		},
		// 切换tab时候 要查询
		handleClick(tab, event) {
			// 如果点击第二个标签 那么就要去查询原订单的信息
			if (event.target.innerHTML === '原订单信息') {
				getGoodsOrder(this.orderInfo.adjustOrderid).then(res => {
					this.adjustedOrderInfo = res.data;
				});
			}
		}
	}
};
</script>

<template>
	<div>
		<el-button v-hasPermi="['system:goodsorder:query', 'system:inventoryMain:query']" size="mini" type="text" @click="handleCheck(row)">{{ title }}</el-button>

		<!--    弹窗-->
		<InfoDialog :visible="visible" title="订单单据信息" :width="'980px'" @close="visible = false">
			<template #info>
				<el-tabs v-model="activeName" type="card" @tab-click="handleClick">
					<!-- 查看订单(有可能为调整单)的信息 如果该订单是调整单 那么还要查看原订单的信息-->
					<el-tab-pane :label="orderInfo.adjustOrderid ? '订单信息(该订单为调整单)' : '该订单信息'" name="first">
						<OrderInfos :order-info="orderInfo" />
						<OrderDetailInfo :ban="true" :order-detail-info-list="orderInfo.orderDetailList" />
					</el-tab-pane>

					<!-- 如果订单为调整单 则要查看其的原订单信息-->
					<el-tab-pane v-if="orderInfo.adjustOrderid" label="原订单信息" name="second">
						<OrderInfos :order-info="adjustedOrderInfo" />
						<OrderDetailInfo :ban="true" :order-detail-info-list="adjustedOrderInfo.orderDetailList" />
					</el-tab-pane>
				</el-tabs>
			</template>
		</InfoDialog>
	</div>
</template>

<style scoped lang="scss"></style>
