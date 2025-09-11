<!--订单详情个体-->

<script>
import { listCompany } from '../../../../api/system/company';
import { listInventory } from '../../../../api/system/inventory';
import { listProductLevel } from '../../../../api/system/productLevel';
import SearchOption from '../../../../components/SearchOption.vue';
import { mixin_item_addItem } from '../../mixins/order/items/item_addItem';
import { mixin_item_compute } from '../../mixins/order/items/item_compute';

export default {
	name: 'OrderItem',
	components: { SearchOption },
	mixins: [mixin_item_addItem, mixin_item_compute],
	// 父组件传递的订单详情个体
	props: {
		tempOrderInfo: {
			type: Object,
			default() {
				return {};
			}
		},
		isSea: Boolean,
		isLand: Boolean,
		index: {
			type: Number,
			default: 0
		}
	},
	data() {
		return {
			disabled: false,
			loading: false,
			buttonText: null,
			// 仓库的查询
			queryStore: null,
			// 供应商的查询
			querySupplier: null,
			queryLevel: null
		};
	},
	computed: {
		computedValue() {
			return this.orderItemInfo.supplier === undefined || this.orderItemInfo.supplier === null ? this.orderItemInfo.storeName : this.orderItemInfo.supplier;
		}
	},
	watch: {
		tempOrderInfo: {
			handler(val) {
				console.log('watch:tempOrderInfo:', val);
				this.$nextTick(() => {
					Object.assign(this.orderItemInfo, val);
				});
			},
			deep: true,
			immediate: true // 立即执行一次
		},
		'orderItemInfo.pieces': {
			handler(val) {
				// 填充卸货片数为出厂片数，根据用户输入减少
				this.orderItemInfo.actualPieces = val;
			},
			deep: true
		},
		index: {
			handler(val) {
				console.log('watch:index:', val);
			}
		},
		// 陆运费和海运费 如果传入的是false那么就是不要钱
		isSea: {
			handler(val) {
				if (val === false) {
					this.orderItemInfo.seaFreight = 0;
				}
			}
		},
		isLand: {
			handler(val) {
				if (val === false) {
					this.orderItemInfo.landFreight = 0;
				}
			}
		}
	},
	created() {
		this.buttonText = '提交货物';
		this.resetOrderItemInfo();
	},
	methods: {
		listProductLevel,
		listInventory,
		listCompany
		// // 更新仓库的查询字段
		// handleUpdateQueryNameStore(value) {
		// 	this.queryStore = value;
		// },
		// // 更新供应商的查询字段
		// handleUpdateQuerySupplier(value) {
		// 	this.querySupplier = value;
		// },
		// handleUpdateQueryNameLevel(value) {
		// 	this.queryLevel = value;
		// },
		// // 筛选无剩余片数的库存
		// filterNoStockNumber(data) {
		// 	return new Promise(resolve => {
		// 		resolve(data.filter(item => item.stockNumber > 0));
		// 	});
		// }
	}
};
</script>

<template>
	<div>
		<el-card class="box-card">
			<div slot="header" class="clearfix">
				<span style="font-weight: bold; color: #1ab394">货物信息({{ index + 1 }})</span>
				<slot name="action" />
			</div>
			<div class="order font-size-12">
				<div class="order-item">
					<span class="text-bold">供应商/仓库</span>
					<hr />
					<el-input v-model="computedValue" placeholder="请输入供应商/仓库" disabled />
					<el-row>
						<el-col :span="12">
							<!--              供应商的查找-->
							<SearchOption
								:get-data="listCompany"
								icon="el-icon-user"
								query-label="供应商名称"
								query-info="companyName"
								:query-name="querySupplier"
								:limit-info="{ companyType: '供应商' }"
								@commitBack="handleCommitBackCompany"
								@update:queryName="handleUpdateQuerySupplier"
							>
								<template #table-columns>
									<el-table-column label="供应商名称" align="center" prop="companyName" />
									<el-table-column label="联系人" align="center" prop="relationName" />
									<el-table-column label="电话" align="center" prop="relationTel" />
								</template>
							</SearchOption>
						</el-col>
						<el-col :span="12">
							<!--              仓库的查找  -->
							<SearchOption
								:get-data="listInventory"
								icon="el-icon-s-home"
								:limit-info="{}"
								query-label="仓库名称"
								query-info="storeHouseName"
								:query-name="queryStore"
								:additional-limit-info="tableData => filterNoStockNumber(tableData)"
								@commitBack="handleCommitBackInventory"
								@update:queryName="handleUpdateQueryNameStore"
							>
								<template #table-columns="{}">
									<el-table-column label="仓库名称" align="center" prop="storeHouseName" />
									<el-table-column label="入库日期" align="center" prop="storeDate" />
									<el-table-column label="剩余量" align="center" prop="stockNumber">
										<template #default="scope">
											{{ scope.row.stockNumber }}
										</template>
									</el-table-column>
									<el-table-column label="供应商" align="center" prop="supplier" />
									<el-table-column label="级别编码" align="center" prop="levelID" />
                  <el-table-column label="级别名称" align="center" prop="levelName" width="150"/>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</div>
				<div class="order-item">
					<span class="text-bold">产品级别</span>
					<hr />
					<el-input v-model="orderItemInfo.levelName" type="text" placeholder="请输入产品级别" />
					<SearchOption
						:get-data="listProductLevel"
						icon="el-icon-search"
						:limit-info="{}"
						query-label="级别名称"
						query-info="levelName"
						:query-name="queryLevel"
						@update:queryName="handleUpdateQueryNameLevel"
						@commitBack="handleCommitBackProductLevel"
					>
						<template #table-columns>
							<el-table-column label="级别编码" align="center" prop="levelNo" />
							<el-table-column label="级别名称" align="center" prop="levelName" min-width="150" />
							<el-table-column label="分类编号" align="center" prop="categoryNo" />
							<el-table-column label="分类名称" align="center" prop="categoryName" />
							<el-table-column label="厚度" align="center" prop="height" />
							<el-table-column label="长度" align="center" prop="length" />
							<el-table-column label="宽度" align="center" prop="width" />
							<el-table-column label="吨位" align="center" prop="tonnage" />
						</template>
					</SearchOption>
				</div>
				<div v-if="orderItemInfo.storeName" class="order-item">
					<span class="text-bold">出库日期</span>
					<hr />
					<el-date-picker v-model="orderItemInfo.exWarehouseDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" />
				</div>
				<div class="order-item">
					<span class="text-bold">计量单位</span>
					<hr />
					<el-radio v-model="orderItemInfo.countingUnit" label="片">片数</el-radio>
					<el-radio v-model="orderItemInfo.countingUnit" label="其他">其他</el-radio>
				</div>
				<div class="order-item">
					<span class="text-bold">厚度</span>
					<hr />
					<el-input disabled v-model="orderItemInfo.height" type="text" placeholder="请输入厚度" />
				</div>
				<div class="order-item">
					<span class="text-bold">长度</span>
					<hr />
					<el-input disabled v-model="orderItemInfo.length" type="text" placeholder="请输入长度" />
				</div>
				<div class="order-item">
					<span class="text-bold">宽度</span>
					<hr />
					<el-input disabled v-model="orderItemInfo.width" type="text" placeholder="请输入宽度" />
				</div>
				<div class="order-item">
					<span class="text-bold">每包片数</span>
					<hr />
					<el-input v-model="orderItemInfo.piecesPerPack" type="text" placeholder="请输入每包片数" />
				</div>
				<div class="order-item">
					<span class="text-bold">包数</span>
					<hr />
					<el-input v-model="orderItemInfo.packs" type="text" placeholder="请输入包数" />
				</div>
				<div class="order-item">
					<span class="text-bold">出厂片数</span>
					<hr />
					<el-input v-model="orderItemInfo.pieces" type="text" placeholder="请输入出厂片数" />
				</div>
				<div class="order-item">
					<span class="text-bold">出厂单价</span>
					<hr />
					<el-input v-model="orderItemInfo.price" type="text" placeholder="请输入出厂单价" />
				</div>
				<div class="order-item">
					<span class="text-bold">出厂是否含税</span>
					<hr />
					<el-radio v-model="orderItemInfo.isIncludeTaxFactory" :label="1">是</el-radio>
					<el-radio v-model="orderItemInfo.isIncludeTaxFactory" :label="0">否</el-radio>
				</div>
				<div class="order-item">
					<span class="text-bold">杂费</span>
					<hr />
					<el-input v-model="orderItemInfo.sundryCost" type="text" placeholder="请输入杂费" />
				</div>
				<div class="order-item">
					<span class="text-bold">出厂货款</span>
					<hr />
					<el-input v-model="orderItemInfo.paymentFactory" type="text" placeholder="请输入出厂贷款" />
				</div>
				<div class="order-item">
					<span class="text-bold">卸货片数</span>
					<hr />
					<el-input v-model="orderItemInfo.actualPieces" type="text" placeholder="请输入卸货片数" />
				</div>
				<div class="order-item">
					<span class="text-bold">卸货价</span>
					<hr />
					<el-input v-model="orderItemInfo.paymentUnload" type="text" placeholder="请输入卸货价" />
				</div>
				<div class="order-item">
					<span class="text-bold">销售是否含税</span>
					<hr />
					<el-radio v-model="orderItemInfo.isIncludeTaxSale" :label="1">是</el-radio>
					<el-radio v-model="orderItemInfo.isIncludeTaxSale" :label="0">否</el-radio>
				</div>
				<div class="order-item">
					<span class="text-bold">总货款杂费</span>
					<hr />
					<el-input v-model="orderItemInfo.paymentsWithSundry" type="text" placeholder="总货款杂费" />
				</div>
				<div class="order-item">
					<span class="text-bold">总货款</span>
					<hr />
					<el-input v-model="orderItemInfo.payments" type="text" placeholder="请输入总货款" />
				</div>

				<div class="order-item">
					<span class="text-bold">误差</span>
					<hr />
					<el-input v-model="orderItemInfo.erro" type="text" placeholder="请输入误差" disabled />
				</div>
				<div class="order-item">
					<span class="text-bold">吨位</span>
					<hr />
					<el-input v-model="orderItemInfo.tonnage" type="text" placeholder="请输入吨位" />
				</div>
				<div class="order-item">
					<span class="text-bold">陆运费单价</span>
					<hr />
					<el-input v-model="orderItemInfo.landFreightPrice" type="text" placeholder="请输入陆运费单价" />
				</div>
				<div class="order-item">
					<span class="text-bold">加费</span>
					<hr />
					<el-input v-model="orderItemInfo.additionalFees" type="text" placeholder="加费" />
				</div>
				<div class="order-item">
					<span class="text-bold">陆运费</span>
					<hr />
					<el-input v-model="orderItemInfo.landFreight" type="text" placeholder="陆运费" />
				</div>
				<div v-if="isSea" class="order-item">
					<span class="text-bold">海运费</span>
					<hr />
					<el-input v-model="orderItemInfo.seaFreight" type="text" placeholder="海运费" />
				</div>
				<div class="order-item">
					<span class="text-bold">总运费</span>
					<hr />
					<el-input v-model="orderItemInfo.freight" type="text" placeholder="总运费" />
				</div>
				<div class="order-item">
					<span class="text-bold">其他费用</span>
					<hr />
					<el-input v-model="orderItemInfo.otherCost" type="text" placeholder="其他费用" />
				</div>
				<div class="order-item">
					<span class="text-bold">利润</span>
					<hr />
					<el-input v-model="orderItemInfo.profit" type="text" placeholder="利润" />
				</div>
				<div class="order-item">
					<span class="text-bold">不含税利润</span>
					<hr />
					<el-input v-model="orderItemInfo.profitNoTax" type="text" placeholder="不含税利润" />
				</div>
				<!-- <div class="order-item">
          <span class="text-bold">实际片数</span>
          <hr>
          <el-input v-model="orderItemInfo.actualPieces" type="text" placeholder="实际片数" />
        </div> -->
				<div class="order-item">
					<span class="text-bold">备注</span>
					<hr />
					<el-input v-model="orderItemInfo.comments" type="text" placeholder="备注" />
				</div>
				<div class="order-item">
					<span class="text-bold">物流利润</span>
					<hr />
					<el-input v-model="orderItemInfo.logisticsProfit" type="text" placeholder="物流利润" />
				</div>
				<div class="order-item">
					<span class="text-bold">佣金</span>
					<hr />
					<el-input v-model="orderItemInfo.customerCommission" type="text" placeholder="佣金" />
				</div>
			</div>
			<el-row>
				<el-col :span="6" :offset="11">
					<el-button type="success" icon="el-icon-plus" size="mini" :disabled="disabled" :loading="loading" @click="addOrderItem">
						{{ buttonText }}
					</el-button>
				</el-col>
			</el-row>
		</el-card>
		<br />
	</div>
</template>

<style scoped lang="scss">
/*订单信息*/
.order {
	overflow-x: scroll;
	display: flex;
	width: 100%;
	justify-content: flex-start;
	align-items: center;
	margin: 12px auto;
}

.order-item {
	height: 120px;
	flex: 0 0 100px;
	flex-direction: column;
	flex-wrap: nowrap;
	border: 1px solid #dddddd;
	background-color: #f9f9f9;

	span {
		font-weight: bolder;
	}
}

.option {
	line-height: 100px;
	width: 60%;
	height: 120px;
	flex: 0 0 200px;
}

.font-size-12 {
	font-size: 12px;
}

.width-50px {
	width: 50px;
}
</style>
