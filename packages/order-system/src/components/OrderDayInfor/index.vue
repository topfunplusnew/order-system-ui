<template>
	<div class="order-day-info">
		<a-spin :spinning="loading" tip="加载订单信息中...">
			<div v-if="orderList.length === 0 && !loading" class="empty-state">
				<a-empty description="暂无订单数据" />
			</div>
			<div v-else>
				<el-table id="printBox" border :data="orderList" max-height="700" :cell-style="cellStyle" :span-method="spanMethod" :row-class-name="tableRowClassName" size="mini" show-summary :summary-method="getSummaries">
					<el-table-column label="日期" align="center" prop="orderDate" show-overflow-tooltip width="50">
						<template slot-scope="scope">
							<span v-if="scope.row.type === 'flag'" style="text-align: left; font-weight: bold">备注：{{ scope.row.comments }}</span>
							<span v-else>
								{{ scope.row.orderDate || '-' }}
							</span>
						</template>
					</el-table-column>
					<el-table-column label="客户" align="center" prop="customer" show-overflow-tooltip width="50" />
					<el-table-column label="供应商" align="center" prop="supplier" show-overflow-tooltip width="50" />
					<el-table-column label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip>
						<template slot-scope="scope">
							{{ scope.row.storeHouseName ? scope.row.storeHouseName : '-' }}
						</template>
					</el-table-column>
					<el-table-column label="级别名称" align="center" prop="levelName" min-width="120" />
					<el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip width="70" />
					<el-table-column label="厚度" align="center" prop="height" show-overflow-tooltip width="50" />
					<el-table-column label="长度" align="center" prop="length" show-overflow-tooltip width="50" />
					<el-table-column label="宽度" align="center" prop="width" show-overflow-tooltip width="50" />
					<el-table-column label="每包片数" align="center" prop="piecesPerPack" show-overflow-tooltip width="70" />
					<el-table-column label="包数" align="center" prop="packs" show-overflow-tooltip width="50" />
					<el-table-column label="出厂片数" align="center" prop="pieces" show-overflow-tooltip width="70" />
					<el-table-column label="出厂单价" align="center" prop="price" show-overflow-tooltip width="70" />
					<el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" show-overflow-tooltip>
						<template slot-scope="scope">
							<el-tag disable-transitions>{{ scope.row.isIncludeTaxFactory == 0 ? '否' : '是' }}</el-tag>
						</template>
					</el-table-column>
					<el-table-column label="杂费" align="center" prop="sundryCost" show-overflow-tooltip />
					<el-table-column label="出厂货款" align="center" prop="paymentFactory" show-overflow-tooltip />
					<el-table-column label="卸货片数" align="center" prop="actualPieces" show-overflow-tooltip />
					<el-table-column label="卸货价" align="center" prop="paymentUnload" show-overflow-tooltip />
					<el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale" show-overflow-tooltip>
						<template slot-scope="scope">
							<el-tag disable-transitions>{{ scope.row.isIncludeTaxSale == 0 ? '否' : '是' }}</el-tag>
						</template>
					</el-table-column>
					<el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" show-overflow-tooltip />
					<el-table-column label="总货款" align="center" prop="payments" show-overflow-tooltip width="100px" />
					<el-table-column label="误差" align="center" prop="erro" show-overflow-tooltip width="50px" />
					<el-table-column label="吨位" align="center" prop="tonnage" show-overflow-tooltip width="50px" />
					<el-table-column label="陆运费单价" align="center" prop="landFreightPrice" show-overflow-tooltip width="50px" />
					<el-table-column label="加费" align="center" prop="additionalFees" show-overflow-tooltip width="50px" />
					<el-table-column label="陆运费" align="center" prop="landFreight" show-overflow-tooltip width="50px" />
					<el-table-column label="海运费" align="center" prop="seaFreight" show-overflow-tooltip width="50px" />
					<el-table-column label="总运费" align="center" prop="freight" show-overflow-tooltip width="100px" />
					<el-table-column label="其他费用" align="center" prop="otherCost" show-overflow-tooltip width="50px" />
					<el-table-column label="利润" align="center" prop="profit" show-overflow-tooltip width="90px" />
					<el-table-column label="不含税利润" align="center" prop="profitNoTax" show-overflow-tooltip width="90px" />
					<el-table-column label="备注" align="center" prop="comments" show-overflow-tooltip width="50px" />
					<el-table-column label="物流利润" align="center" prop="logisticsProfit" show-overflow-tooltip width="50px" />
					<el-table-column label="客户佣金" align="center" prop="customerCommission" show-overflow-tooltip width="50px" />
					<el-table-column label="厂家佣金" align="center" prop="factoryCommission" show-overflow-tooltip width="50px" />
					<el-table-column label="计提厂家返利金额" align="center" prop="factoryRebateAmount" show-overflow-tooltip width="50px" />
					<el-table-column label="计提厂家降价金额" align="center" prop="factoryDiscountAmount" show-overflow-tooltip width="50px" />
				</el-table>
			</div>
		</a-spin>
	</div>
</template>

<script>
import { getBussinessInfoTodayList } from '@/api/system/goodsOrder';
import { BatchQueryTableName, PUBLIC_DICT_TYPE } from '@/api/tool/enums';
import _ from 'lodash';
import { CAR_TYPE } from '../../api/tool/enums';

export default {
	name: 'OrderDayInfo',
	props: {
		ids: {
			type: Array,
			required: true,
			default: () => []
		},
		isDetail: {
			type: Boolean,
			default: false
		},
		companyId: {
			type: Number,
			required: true
		},
		companyType: {
			type: String,
			required: true
		}
	},
	computed: {
		computedTableName() {
			return this.isDetail ? BatchQueryTableName.ORDER_DETAIL : BatchQueryTableName.GOODS_ORDER;
		}
	},
	data() {
		return {
			loading: false,
			orderList: []
		};
	},
	watch: {
		ids: {
			handler(newIds) {
				this.orderList = [];
				if (newIds && newIds.length > 0) {
					this.fetchOrderData();
				}
			},
			immediate: true
		}
	},
	methods: {
		// 单元格样式
		cellStyle(row) {
			if (row.row.type === 'flag') {
				return {
					padding: '.5px',
					backgroundColor: '#f5f5f5',
					textAlign: 'left',
					fontWeight: 'bold'
				};
			}
			return { padding: '.5px' };
		},
		// 单元格合并方法
		spanMethod({ row, column, rowIndex, columnIndex }) {
			if (row.type === 'flag') {
				if (columnIndex === 0) {
					// 第一列显示所有内容，合并所有列
					return [1, 32]; // 32是表格的总列数
				} else {
					// 其他列不显示
					return [0, 0];
				}
			}
		},
		// 表格行样式类名
		tableRowClassName({ row, rowIndex }) {
			if (row.type === 'flag') {
				return 'flag-row';
			}
			return '';
		},
		// 获取汇总数据
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			// 需要求和的列
			const sumColumns = ['paymentFactory', 'payments', 'tonnage', 'landFreight', 'freight', 'profit', 'profitNoTax'];

			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}

				// 只对指定的列进行汇总，排除分隔符行
				if (sumColumns.includes(column.property)) {
					const values = data.filter(item => item.type !== 'flag').map(item => Number(item[column.property]));
					if (!values.every(value => isNaN(value))) {
						sums[index] = values.reduce((prev, curr) => {
							const value = Number(curr);
							if (!isNaN(value)) {
								return prev + curr;
							} else {
								return prev;
							}
						}, 0);
						// 保留两位小数
						sums[index] = Number(sums[index]).toFixed(2);
					} else {
						sums[index] = '';
					}
				} else {
					sums[index] = '';
				}
			});
			return sums;
		},
		// 获取订单数据
		async fetchOrderData() {
			if (!this.ids || this.ids.length === 0) {
				this.orderList = [];
				return;
			}
			this.loading = true;
			try {
				const params = {
					tableName: this.computedTableName,
					ids: this.ids
				};
				const response = await getBussinessInfoTodayList(params);
				if (response.data && response.data.length > 0) {
					let orderInfoList = _.cloneDeep(response.data);
					let orderFlatList = [];
					// orderInfoList是主子表信息 orderDetailList是明细
					orderInfoList.forEach(item => {
						let orderDetailList = item.orderDetailList;
						// 如果公司类型是供应商 并且是查看明细信息的话 就需要筛选出明细中供应商id是传入公司的ID
						if (orderDetailList.length > 0 && this.companyId && this.companyType === PUBLIC_DICT_TYPE.SUPPLIER) {
							orderDetailList = orderDetailList.filter(item => item.supplierID === this.companyId);
						}
						const orderInfoToAdd = _.omit(item, 'orderDetailList');
						// 添加所有的扁平的数据
						orderFlatList.push(
							..._.map(orderDetailList, item => {
								return _.assign(
									{
										type: 'data'
									},
									item,
									{
										...orderInfoToAdd,
										comments: item.comments
									}
								);
							})
						);
						// 每两批订单之间添加一个分隔符
						orderFlatList.push({
							type: 'flag',
							comments: item.comments
						});
					});
					this.orderList = orderFlatList;
					console.log(`this.orderList->`, this.orderList);
				}
			} catch (error) {
				console.error('获取订单数据失败:', error);
				this.$message.error('获取订单数据失败');
				this.orderList = [];
			} finally {
				this.loading = false;
			}
		},
		handleReject() {
			return Promise.resolve();
		},
		handleProcess() {
			return Promise.resolve();
		}
	}
};
</script>

<style scoped lang="scss">
.order-day-info {
	.empty-state {
		padding: 20px;
		text-align: center;
	}
}

// 分隔符行样式
::v-deep .el-table__row {
	&.flag-row {
		background-color: #f5f5f5 !important;

		.cell {
			font-weight: bold;
			color: #666;
		}
	}
}
</style>
