<script>
import { fix_2 } from '../../api/tool/format';

export default {
	name: 'INVENTORY',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => ({})
		}
	},
	methods: {
		handleProcess() {
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		},
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}
				const includes = [14, 19, 21, 24, 26, 28];
				if (!data || data.length === 0) return;
				const values = data.map(item => Number(item[column.property]));
				if (!values.every(value => isNaN(value))) {
					// 包含的计算
					if (includes.includes(index)) {
						sums[index] = values.reduce((prev, curr) => {
							const value = Number(curr);
							if (!isNaN(value)) {
								return prev + curr;
							} else {
								return prev;
							}
						}, 0);
						sums[index] = fix_2(sums[index]);
						sums[index] += '';
					}
				}
			});

			return sums;
		}
	}
};
</script>

<template>
	<div class="inventory-container">
		<el-card class="inventory-card" shadow="hover" size="mini">
			<el-descriptions title="库存信息" size="mini" border :column="5">
				<el-descriptions-item label="入库日期">
					{{ needToShowInfo.storeDate ? new Date(needToShowInfo.storeDate).toLocaleDateString() : '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="仓库名称">{{ needToShowInfo.storeHouseName || '-' }}</el-descriptions-item>
				<el-descriptions-item label="审核状态">{{ needToShowInfo.checkState || '-' }}</el-descriptions-item>
				<el-descriptions-item label="车队">{{ needToShowInfo.fleet || '-' }}</el-descriptions-item>
				<el-descriptions-item label="陆运银行账号">{{ needToShowInfo.landBankNo || '-' }}</el-descriptions-item>
				<el-descriptions-item label="陆运车牌">{{ needToShowInfo.landCarNo || '-' }}</el-descriptions-item>
				<el-descriptions-item label="陆地司机姓名">{{ needToShowInfo.landDriverName || '-' }}</el-descriptions-item>
				<el-descriptions-item label="陆运司机电话">{{ needToShowInfo.landDriverTel || '-' }}</el-descriptions-item>
				<el-descriptions-item label="海运银行账号">{{ needToShowInfo.seaBankNo || '-' }}</el-descriptions-item>
				<el-descriptions-item label="柜号">{{ needToShowInfo.seaCarNo || '-' }}</el-descriptions-item>
				<el-descriptions-item label="海运公司">{{ needToShowInfo.seaDriverName || '-' }}</el-descriptions-item>
				<el-descriptions-item label="海运公司电话">{{ needToShowInfo.seaDriverTel || '-' }}</el-descriptions-item>
				<el-descriptions-item label="操作人员">
					{{ needToShowInfo.userName || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">{{ needToShowInfo.comments || '无' }}</el-tag>
				</el-descriptions-item>
			</el-descriptions>

			<el-row>
				<el-col :span="8">
					<span style="font-weight: bolder">库存货物详情列表</span>
				</el-col>
			</el-row>
			<!--      库存个体信息-->
			<el-table
				:data="needToShowInfo.inventoryDetailList"
				:cell-style="
					() => {
						return { padding: '.5px' };
					}
				"
				size="mini"
				show-summary
				:summary-method="getSummaries"
				stripe
				style="width: 100%"
				border
			>
				<el-table-column prop="supplier" label="供应商" width="150" />
				<el-table-column label="级别名称" align="center" prop="levelName" show-overflow-tooltip />
				<el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip />
				<el-table-column label="厚度" align="center" prop="height" show-overflow-tooltip />
				<el-table-column label="长度" align="center" prop="length" show-overflow-tooltip />
				<el-table-column label="宽度" align="center" prop="width" show-overflow-tooltip />
				<el-table-column label="每包片数" align="center" prop="piecesPerPack" show-overflow-tooltip />
				<el-table-column label="包数" align="center" prop="packs" show-overflow-tooltip />
				<el-table-column label="出厂片数" align="center" prop="pieces" show-overflow-tooltip />
				<el-table-column label="出厂单价" align="center" prop="price" show-overflow-tooltip />
				<el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" show-overflow-tooltip>
					<template slot-scope="scope">
						<el-tag disable-transitions>{{ scope.row.isIncludeTaxFactory === 0 ? '否' : '是' }}</el-tag>
					</template>
				</el-table-column>
				<el-table-column label="杂费" align="center" prop="sundryCost" show-overflow-tooltip />
				<el-table-column label="出厂货款" align="center" prop="paymentFactory" show-overflow-tooltip />
				<el-table-column label="存货价" align="center" prop="paymentUnload" show-overflow-tooltip />
				<el-table-column label="入库片数" align="center" prop="stockNumber" show-overflow-tooltip />
				<el-table-column label="库存是否含税" align="center" prop="isIncludeTaxSale" show-overflow-tooltip>
					<template slot-scope="scope">
						<el-tag disable-transitions>{{ scope.row.isIncludeTaxSale === 0 ? '否' : '是' }}</el-tag>
					</template>
				</el-table-column>
				<el-table-column label="库存金额" align="center" prop="payments" show-overflow-tooltip />
				<el-table-column label="误差" align="center" prop="erro" show-overflow-tooltip />
				<el-table-column label="吨位" align="center" prop="tonnage" show-overflow-tooltip />
				<el-table-column label="陆运费单价" align="center" prop="landFreightPrice" show-overflow-tooltip />
				<el-table-column label="加费" align="center" prop="additionalFees" show-overflow-tooltip />
				<el-table-column label="陆运费" align="center" prop="landFreight" show-overflow-tooltip />
				<el-table-column label="海运费" align="center" prop="seaFreight" show-overflow-tooltip />
				<el-table-column label="总运费" align="center" prop="freight" show-overflow-tooltip />
				<el-table-column label="其他费用" align="center" prop="otherCost" show-overflow-tooltip />
				<el-table-column label="利润" align="center" prop="profit" show-overflow-tooltip />
				<el-table-column label="不含税利润" align="center" prop="profitNoTax" show-overflow-tooltip />
				<el-table-column label="备注" align="center" prop="comments" show-overflow-tooltip />
				<el-table-column label="物流利润" align="center" prop="logisticsProfit" show-overflow-tooltip />
				<el-table-column label="客户佣金" align="center" prop="customerCommission" show-overflow-tooltip />
				<el-table-column label="厂家佣金" align="center" prop="factoryCommission" show-overflow-tooltip />
				<el-table-column label="计提厂家返利金额" align="center" prop="factoryRebateAmount" show-overflow-tooltip />
				<el-table-column label="计提厂家降价金额" align="center" prop="factoryDiscountAmount" show-overflow-tooltip />
			</el-table>
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.inventory-container {
	padding: 20px;
}

.inventory-card {
	border-radius: 8px;
}

.el-descriptions-item__label {
	font-weight: bold;
	color: #606266;
}
</style>
