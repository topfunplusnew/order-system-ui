<template>
	<div class="inventory-day-info">
		<a-spin :spinning="loading" tip="加载库存信息中...">
			<div v-if="inventoryList.length === 0 && !loading" class="empty-state">
				<a-empty description="暂无库存数据" />
			</div>
			<div v-else>
				<el-table id="inventoryPrintBox" border :data="inventoryList" max-height="700" :cell-style="cellStyle" :span-method="spanMethod" :row-class-name="tableRowClassName" size="mini" show-summary :summary-method="getSummaries">
					<el-table-column label="日期" align="center" prop="storeDate" show-overflow-tooltip width="80">
						<template slot-scope="scope">
							<span v-if="scope.row.type === 'flag'" style="text-align: left; font-weight: bold">备注：{{ scope.row.comments }}</span>
							<span v-else>
								{{ scope.row.storeDate ? scope.row.storeDate.split(' ')[0] : '-' }}
							</span>
						</template>
					</el-table-column>
					<el-table-column label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip width="100" />
					<el-table-column label="供应商" align="center" prop="supplier" show-overflow-tooltip width="120" />
					<el-table-column label="级别名称" align="center" prop="levelName" min-width="150" />
					<el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip width="70" />
					<el-table-column label="厚度" align="center" prop="height" show-overflow-tooltip width="50" />
					<el-table-column label="长度" align="center" prop="length" show-overflow-tooltip width="50" />
					<el-table-column label="宽度" align="center" prop="width" show-overflow-tooltip width="50" />
					<el-table-column label="每包片数" align="center" prop="piecesPerPack" show-overflow-tooltip width="70" />
					<el-table-column label="包数" align="center" prop="packs" show-overflow-tooltip width="50" />
					<el-table-column label="出厂片数" align="center" prop="pieces" show-overflow-tooltip width="70" />
					<el-table-column label="入库量" align="center" prop="stockNumber" show-overflow-tooltip width="70" />
					<el-table-column label="出厂单价" align="center" prop="price" show-overflow-tooltip width="70" />
					<el-table-column label="是否含税" align="center" prop="isIncludeTaxFactory" show-overflow-tooltip width="80">
						<template slot-scope="scope">
							<el-tag disable-transitions>{{ scope.row.isIncludeTaxFactory == 0 ? '否' : '是' }}</el-tag>
						</template>
					</el-table-column>
					<el-table-column label="杂费" align="center" prop="sundryCost" show-overflow-tooltip width="60" />
					<el-table-column label="出厂货款" align="center" prop="paymentFactory" show-overflow-tooltip width="90" />
					<el-table-column label="存货价" align="center" prop="paymentUnload" show-overflow-tooltip width="70" />
					<el-table-column label="出库是否含税" align="center" prop="isIncludeTaxSale" show-overflow-tooltip width="80">
						<template slot-scope="scope">
							<el-tag disable-transitions>{{ scope.row.isIncludeTaxSale == 0 ? '否' : '是' }}</el-tag>
						</template>
					</el-table-column>
					<el-table-column label="总货款" align="center" prop="payments" show-overflow-tooltip width="90" />
					<el-table-column label="误差" align="center" prop="erro" show-overflow-tooltip width="50" />
					<el-table-column label="吨位" align="center" prop="tonnage" show-overflow-tooltip width="60" />
					<el-table-column label="陆运费" align="center" prop="landFreight" show-overflow-tooltip width="70" />
					<el-table-column label="海运费" align="center" prop="seaFreight" show-overflow-tooltip width="70" />
					<el-table-column label="总运费" align="center" prop="freight" show-overflow-tooltip width="80" />
					<el-table-column label="其他费用" align="center" prop="otherCost" show-overflow-tooltip width="70" />
					<el-table-column label="利润" align="center" prop="profit" show-overflow-tooltip width="70" />
					<el-table-column label="不含税利润" align="center" prop="profitNoTax" show-overflow-tooltip width="90" />
					<el-table-column label="备注" align="center" prop="comments" show-overflow-tooltip width="100" />
					<el-table-column label="车队" align="center" prop="fleet" show-overflow-tooltip width="80" />
					<el-table-column label="审核状态" align="center" prop="checkState" show-overflow-tooltip width="80">
						<template slot-scope="scope">
							<el-tag v-if="scope.row.checkState" :color="getStatusColor(scope.row.checkState)" disable-transitions>
								{{ scope.row.checkState }}
							</el-tag>
							<span v-else>-</span>
						</template>
					</el-table-column>
					<el-table-column label="操作员" align="center" prop="userName" show-overflow-tooltip width="80" />
				</el-table>
			</div>
		</a-spin>
	</div>
</template>

<script>
import { getBussinessInfoTodayList } from '@/api/system/goodsOrder';
import { BatchQueryTableName } from '@/api/tool/enums';
import _ from 'lodash';
import { PUBLIC_DICT_TYPE } from '@/utils/order';

export default {
	name: 'InventoryDayInfo',
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
	data() {
		return {
			loading: false,
			inventoryList: []
		};
	},
	computed: {
		computedTableName() {
			return this.isDetail ? BatchQueryTableName.INVENTORY_DETAIL : BatchQueryTableName.INVENTORY_MAIN;
		}
	},
	watch: {
		ids: {
			handler(newIds) {
				this.inventoryList = [];
				if (newIds && newIds.length > 0) {
					this.fetchInventoryData();
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
					return [1, 29]; // 29是表格的总列数
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
			// 需要求和的列 - 根据inventoryMain中的实际字段名调整
			const sumColumns = ['pieces', 'stockNumber', 'paymentFactory', 'payments', 'tonnage', 'landFreight', 'seaFreight', 'freight', 'profit', 'profitNoTax'];

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
		// 获取库存数据
		async fetchInventoryData() {
			if (!this.ids || this.ids.length === 0) {
				this.inventoryList = [];
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
					let inventoryInfoList = _.cloneDeep(response.data);
					let inventoryFlatList = [];
					// 如果公司类型是司机 需要把这个司机的订单筛选出来
					if (inventoryInfoList.length > 0 && this.companyType === PUBLIC_DICT_TYPE.DRIVER) {
						inventoryInfoList = inventoryInfoList.filter(item => item.landCarID === this.companyId);
					}
					inventoryInfoList.forEach(item => {
						let inventoryDetailList = item.inventoryDetailList;
						// 如果公司类型是供应商 并且是查看明细信息的话 就需要筛选出明细中供应商id是传入公司的ID
						if (inventoryDetailList.length > 0 && this.companyId && this.companyType === PUBLIC_DICT_TYPE.SUPPLIER) {
							inventoryDetailList = inventoryDetailList.filter(item => item.supplierId === this.companyId);
						}
						const inventoryInfoToAdd = _.omit(item, 'inventoryDetailList');
						// 添加所有的扁平的数据
						inventoryFlatList.push(
							..._.map(inventoryDetailList, detailItem => {
								return _.assign(
									{
										type: 'data'
									},
									detailItem,
									inventoryInfoToAdd
								);
							})
						);
						// 每两批库存之间添加一个分隔符
						inventoryFlatList.push({
							type: 'flag',
							comments: item.comments
						});
					});

					this.inventoryList = inventoryFlatList;
					console.log(`this.inventoryList->`, this.inventoryList);
				}
			} catch (error) {
				console.error('获取库存数据失败:', error);
				this.$message.error('获取库存数据失败');
				this.inventoryList = [];
			} finally {
				this.loading = false;
			}
		},

		// 获取状态颜色
		getStatusColor(status) {
			const statusColors = {
				待提交: 'blue',
				审核中: 'orange',
				通过: 'green',
				未通过: 'red',
				驳回: 'volcano',
				作废: 'purple'
			};
			return statusColors[status] || 'default';
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
.inventory-day-info {
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
