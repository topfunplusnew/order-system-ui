<script>
export default {
	name: 'INVENTORYDETAIL',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => {}
		}
	}
};
</script>

<template>
	<div>
		<el-card>
			<el-descriptions title="库存详细信息">
				<el-descriptions-item label="供应商">
					{{ needToShowInfo.supplier }}
				</el-descriptions-item>
				<el-descriptions-item label="添加时间">
					{{ needToShowInfo.addtime }}
				</el-descriptions-item>
				<el-descriptions-item label="总运费单价">
					{{ needToShowInfo.allFreightPrice }} 元
				</el-descriptions-item>
				<el-descriptions-item label="子项陆运费之和">
					{{ needToShowInfo.allLandFreight }} 元
				</el-descriptions-item>
				<el-descriptions-item label="子项海运费之和">
					{{ needToShowInfo.allSeaFreight }} 元
				</el-descriptions-item>
				<el-descriptions-item label="子项吨位之和">
					{{ needToShowInfo.allTonnage }} 吨
				</el-descriptions-item>
				<el-descriptions-item label="审核状态">
					{{ needToShowInfo.checkState }}
				</el-descriptions-item>
				<el-descriptions-item label="车队">
					{{ needToShowInfo.fleet }}
				</el-descriptions-item>
				<el-descriptions-item label="货物来源公司">
					{{ needToShowInfo.goodsCompany }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运银行账号">
					{{ needToShowInfo.landBankNo }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运车牌">
					{{ needToShowInfo.landCarNo }}
				</el-descriptions-item>
				<el-descriptions-item label="陆地司机姓名">
					{{ needToShowInfo.landDriverName }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运司机电话">
					{{ needToShowInfo.landDriverTel }}
				</el-descriptions-item>
				<el-descriptions-item label="收到条附件路径">
					{{ needToShowInfo.receiveProof }}
				</el-descriptions-item>
				<el-descriptions-item label="海运银行户名">
					{{ needToShowInfo.seaBankNo }}
				</el-descriptions-item>
				<el-descriptions-item label="海运车牌">
					{{ needToShowInfo.seaCarNo }}
				</el-descriptions-item>
				<el-descriptions-item label="海运司机姓名">
					{{ needToShowInfo.seaDriverName }}
				</el-descriptions-item>
				<el-descriptions-item label="海运司机电话">
					{{ needToShowInfo.seaDriverTel }}
				</el-descriptions-item>
				<el-descriptions-item label="入库日期">
					{{ new Date(needToShowInfo.storeDate).toLocaleDateString() }}
				</el-descriptions-item>
				<el-descriptions-item label="仓库名称">
					{{ needToShowInfo.storeHouseName }}
				</el-descriptions-item>
				<el-descriptions-item label="操作人员姓名">
					{{ needToShowInfo.UserName }}
				</el-descriptions-item>
				<el-descriptions-item label="库存数量">
					{{ needToShowInfo.stockNumber }} 片
				</el-descriptions-item>
				<el-descriptions-item label="产品规格">
					{{ needToShowInfo.levelName }} - {{ needToShowInfo.countingUnit }}
				</el-descriptions-item>
				<el-descriptions-item label="单片尺寸">
					{{ needToShowInfo.height }} × {{ needToShowInfo.length }} ×
					{{ needToShowInfo.width }} cm
				</el-descriptions-item>
				<el-descriptions-item label="每包数量">
					{{ needToShowInfo.piecesPerPack }}
				</el-descriptions-item>
				<el-descriptions-item label="包数">
					{{ needToShowInfo.packs }}
				</el-descriptions-item>
				<el-descriptions-item label="单价">
					{{ needToShowInfo.price }} 元
				</el-descriptions-item>
				<el-descriptions-item label="含税出厂价">
					{{
						needToShowInfo.isIncludeTaxFactory
							? needToShowInfo.paymentFactory
							: '不含税'
					}}
				</el-descriptions-item>
				<el-descriptions-item label="含税销售价">
					{{
						needToShowInfo.isIncludeTaxSale ? needToShowInfo.payments : '不含税'
					}}
				</el-descriptions-item>
				<el-descriptions-item label="其他费用">
					{{ needToShowInfo.sundryCost }} 元
				</el-descriptions-item>
				<el-descriptions-item label="运费">
					{{ needToShowInfo.freight }} 元
				</el-descriptions-item>
				<el-descriptions-item label="实际数量">
					{{ needToShowInfo.actualPieces }} 片
				</el-descriptions-item>
				<el-descriptions-item label="附加费用">
					{{ needToShowInfo.additionalFees }} 元
				</el-descriptions-item>
				<el-descriptions-item label="利润">
					{{ needToShowInfo.profit }} 元
				</el-descriptions-item>
				<el-descriptions-item label="利润（不含税）">
					{{ needToShowInfo.profitNoTax }} 元
				</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">
						{{ needToShowInfo.comments || '无' }}
					</el-tag>
				</el-descriptions-item>
				<el-descriptions-item label="运输车辆信息">
					<div>陆运车牌号: {{ needToShowInfo.landCarNo }}</div>
					<div>司机姓名: {{ needToShowInfo.landDriverName }}</div>
					<div>司机电话: {{ needToShowInfo.landDriverTel }}</div>
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<style scoped lang="scss"></style>
