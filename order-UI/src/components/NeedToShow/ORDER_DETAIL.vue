<script>
export default {
	name: 'ORDERDETAIL',
	props: {
		needToShowInfo: {
			type: Object
		}
	}
};
</script>

<template>
	<div>
		<el-card>
			<el-descriptions title="订单详情" column="3">
				<el-descriptions-item label="订单号">{{
					needToShowInfo.ordersNo
				}}</el-descriptions-item>
				<el-descriptions-item label="订单日期">{{
					needToShowInfo.orderDate
				}}</el-descriptions-item>
				<el-descriptions-item label="供应商">{{
					needToShowInfo.supplier
				}}</el-descriptions-item>
				<el-descriptions-item label="客户">{{
					needToShowInfo.customer
				}}</el-descriptions-item>
				<el-descriptions-item label="级别名称">{{
					needToShowInfo.levelName
				}}</el-descriptions-item>
				<el-descriptions-item label="计量单位">{{
					needToShowInfo.countingUnit
				}}</el-descriptions-item>
				<el-descriptions-item label="高度">{{
					needToShowInfo.height
				}}</el-descriptions-item>
				<el-descriptions-item label="长度">{{
					needToShowInfo.length
				}}</el-descriptions-item>
				<el-descriptions-item label="宽度">{{
					needToShowInfo.width
				}}</el-descriptions-item>
				<el-descriptions-item label="总片数">{{
					needToShowInfo.pieces
				}}</el-descriptions-item>
				<el-descriptions-item label="每包片数">{{
					needToShowInfo.piecesPerPack
				}}</el-descriptions-item>
				<el-descriptions-item label="总包数">{{
					needToShowInfo.packs
				}}</el-descriptions-item>
				<el-descriptions-item label="单价"
					>{{ needToShowInfo.price }} 元</el-descriptions-item
				>
				<el-descriptions-item label="工厂含税"
					>{{ needToShowInfo.isIncludeTaxFactory ? '是' : '否' }}
				</el-descriptions-item>
				<el-descriptions-item label="杂费"
					>{{ needToShowInfo.sundryCost }} 元</el-descriptions-item
				>
				<el-descriptions-item label="出厂货款"
					>{{ needToShowInfo.paymentFactory }} 元</el-descriptions-item
				>
				<el-descriptions-item label="卸货费"
					>{{ needToShowInfo.paymentUnload }} 元</el-descriptions-item
				>
				<el-descriptions-item label="销售含税"
					>{{ needToShowInfo.isIncludeTaxSale ? '是' : '否' }}
				</el-descriptions-item>
				<el-descriptions-item label="总付款"
					>{{ needToShowInfo.payments }} 元</el-descriptions-item
				>
				<el-descriptions-item label="误差">{{
					needToShowInfo.erro
				}}</el-descriptions-item>
				<el-descriptions-item label="吨数">{{
					needToShowInfo.tonnage
				}}</el-descriptions-item>
				<el-descriptions-item label="陆运价"
					>{{ needToShowInfo.landFreightPrice }} 元</el-descriptions-item
				>
				<el-descriptions-item label="陆运费"
					>{{ needToShowInfo.landFreight }} 元</el-descriptions-item
				>
				<el-descriptions-item label="海运费"
					>{{ needToShowInfo.seaFreight || '无' }} 元</el-descriptions-item
				>
				<el-descriptions-item label="运费总计"
					>{{ needToShowInfo.freight }} 元</el-descriptions-item
				>
				<el-descriptions-item label="其他费用"
					>{{ needToShowInfo.otherCost }} 元</el-descriptions-item
				>
				<el-descriptions-item label="利润"
					>{{ needToShowInfo.profit }} 元</el-descriptions-item
				>
				<el-descriptions-item label="未税利润"
					>{{ needToShowInfo.profitNoTax }} 元</el-descriptions-item
				>
				<el-descriptions-item label="实际片数">{{
					needToShowInfo.actualPieces
				}}</el-descriptions-item>
				<el-descriptions-item label="支付含杂费"
					>{{ needToShowInfo.paymentsWithSundry }} 元</el-descriptions-item
				>
				<el-descriptions-item label="附加费用"
					>{{ needToShowInfo.additionalFees }} 元</el-descriptions-item
				>
				<el-descriptions-item label="仓库名称">{{
					needToShowInfo.storeHouseName || '无'
				}}</el-descriptions-item>
				<el-descriptions-item label="物流利润"
					>{{ needToShowInfo.logisticsProfit }} 元</el-descriptions-item
				>
				<el-descriptions-item label="佣金"
					>{{ needToShowInfo.customerCommission }} 元</el-descriptions-item
				>
				<el-descriptions-item label="调整订单号">{{
					needToShowInfo.adjustOrderNo || '无'
				}}</el-descriptions-item>
				<el-descriptions-item label="调整日期">{{
					needToShowInfo.adjustDate || '无'
				}}</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">{{ needToShowInfo.comments || '无' }}</el-tag>
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<style scoped lang="scss"></style>
