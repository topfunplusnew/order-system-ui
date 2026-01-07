<!--选择订单后的已选择货物列表-->

<script>
export default {
	name: 'OrderDetailList',
	props: {
		orderDetailList: {
			type: Array,
			default: () => []
		},
		total: {
			type: Number,
			default: 0
		}
	},
	data() {
		return {
			loading: false,
			// 最终选中的“明细行”列表（与之前保持一致：emit 给父组件的是明细数组）
			selectedList: [],
			// 按 ordersNo 记录已选明细，用于 expand 展开后回显
			selectedByOrdersNo: {},
			queryParams: {
				pageNum: 1,
				pageSize: 20
			}
		};
	},
	computed: {
		/**
		 * 将接口返回的订单明细按 ordersNo 合并为“同车一行”，明细放在 details 中
		 * - ordersNo 相同：认为同一车/同一订单组
		 * - 保留首条记录的公共字段用于汇总展示
		 */
		groupedOrderList() {
			const list = this.orderDetailList || [];
			const map = {};
			const keyOrder = [];

			list.forEach(item => {
				const key = item && item.ordersNo ? String(item.ordersNo) : '未知订单';
				if (!map[key]) {
					map[key] = {
						ordersNo: key,
						orderDate: item?.orderDate,
						customer: item?.customer,
						supplier: item?.supplier,
						levelName: item?.levelName,
						countingUnit: item?.countingUnit,
						details: []
					};
					keyOrder.push(key);
				}
				map[key].details.push(item);
			});

			return keyOrder.map(key => {
				const group = map[key];
				return {
					...group,
					detailCount: (group.details || []).length
				};
			});
		}
	},
	watch: {
		// 数据源变化（重新查询/翻页）时，保持与旧行为一致：清空选择
		orderDetailList() {
			this.selectedList = [];
			this.selectedByOrdersNo = {};
		}
	},
	methods: {
		// 明细选择变化：按 ordersNo 维护，再汇总到 selectedList
		handleInnerSelectionChange(ordersNo, selection) {
			const key = ordersNo ? String(ordersNo) : '未知订单';
			this.$set(this.selectedByOrdersNo, key, selection || []);
			const all = Object.keys(this.selectedByOrdersNo).reduce((acc, k) => {
				return acc.concat(this.selectedByOrdersNo[k] || []);
			}, []);
			// 去重（同一明细不会重复，但防御性处理）
			const uniqMap = {};
			this.selectedList = all.filter(item => {
				const id = item && item.id;
				if (id === null || id === undefined) return false;
				if (uniqMap[id]) return false;
				uniqMap[id] = true;
				return true;
			});
		},
		submitSelectOrderDetail() {
			this.$emit('handleSelect', this.selectedList);
		},
		// 对货物进行查询和筛选
		handleQuery() {
			this.$emit('handleQuery', this.queryParams);
		},
		// 展开行变化后回显已选明细
		handleExpandChange(row, expandedRows) {
			const ordersNo = row?.ordersNo ? String(row.ordersNo) : '未知订单';
			this.$nextTick(() => {
				const ref = this.$refs[`innerTable_${ordersNo}`];
				const table = Array.isArray(ref) ? ref[0] : ref;
				if (!table) return;

				const selected = this.selectedByOrdersNo[ordersNo] || [];
				table.clearSelection();
				(selected || []).forEach(item => {
					table.toggleRowSelection(item, true);
				});
			});
		}
	}
};
</script>

<template>
	<div>
		<!--		需要对货物进行查询和筛选-->
		<el-form :model="queryParams" size="mini" :inline="true" label-width="100px">
			<el-row>
				<el-form-item label="日期" prop="orderDate">
					<el-date-picker v-model="queryParams.orderDate" type="date" placeholder="选择订单货物时间" value-format="yyyy-MM-dd"></el-date-picker>
				</el-form-item>
				<el-form-item label="供应商名称" prop="supplier">
					<!--          换成输入框-->
					<el-input v-model="queryParams.supplier" placeholder="请输入供应商名称"></el-input>
				</el-form-item>
				<el-form-item label="级别名称" prop="levelName">
					<el-input v-model="queryParams.levelName" placeholder="请输入级别名称"></el-input>
				</el-form-item>
			</el-row>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
			<el-form-item>
				<el-button :disabled="selectedList.length === 0" type="success" size="mini" @click="submitSelectOrderDetail">选择所选货物</el-button>
			</el-form-item>
		</el-form>
		<el-table
			id="printBox"
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="groupedOrderList"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			max-height="700"
			size="mini"
			row-key="ordersNo"
			@expand-change="handleExpandChange"
		>
			<el-table-column type="expand" width="55" fixed="left">
				<template slot-scope="scope">
					<el-table
						:ref="`innerTable_${scope.row.ordersNo}`"
						border
						:data="scope.row.details || []"
						row-key="id"
						size="mini"
						max-height="520"
						:cell-style="
							() => {
								return { padding: '.5px' };
							}
						"
						@selection-change="val => handleInnerSelectionChange(scope.row.ordersNo, val)"
					>
						<el-table-column type="selection" width="70" align="center" fixed="left" />
						<el-table-column label="id" align="center" prop="id" min-width="80" />
						<el-table-column label="订单日期" align="center" prop="orderDate" min-width="100" />
						<el-table-column label="客户" align="center" prop="customer" min-width="120" />
						<el-table-column label="供应商" align="center" prop="supplier" min-width="150" />
						<el-table-column label="级别编码" align="center" prop="levelID" min-width="100" />
						<el-table-column label="级别名称" align="center" prop="levelName" min-width="150" />
						<el-table-column label="计量单位" align="center" prop="countingUnit" min-width="100" />
						<el-table-column label="厚度" align="center" prop="height" min-width="80" />
						<el-table-column label="长度" align="center" prop="length" min-width="80" />
						<el-table-column label="宽度" align="center" prop="width" min-width="80" />
						<el-table-column label="出厂片数" align="center" prop="pieces" min-width="90" />
						<el-table-column label="每包片数" align="center" prop="piecesPerPack" min-width="90" />
						<el-table-column label="包数" align="center" prop="packs" min-width="70" />
						<el-table-column label="出厂单价" align="center" prop="price" min-width="90" />
						<el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory">
							<template slot-scope="detailScope">
								<el-tag disable-transitions>{{ detailScope.row.isIncludeTaxFactory === 0 ? '否' : '是' }}</el-tag>
							</template>
						</el-table-column>
						<el-table-column label="佣金" align="center" prop="customerCommission" min-width="90" />
					</el-table>
				</template>
			</el-table-column>

			<el-table-column label="订单编号" align="center" prop="ordersNo" min-width="160" fixed="left" />
			<el-table-column label="订单日期" align="center" prop="orderDate" min-width="110" />
			<el-table-column label="客户" align="center" prop="customer" min-width="140" />
			<el-table-column label="供应商" align="center" prop="supplier" min-width="160" />
			<el-table-column label="级别名称" align="center" prop="levelName" min-width="160" />
			<el-table-column label="计量单位" align="center" prop="countingUnit" min-width="90" />
			<el-table-column label="明细数" align="center" prop="detailCount" min-width="80" />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="handleQuery" />
	</div>
</template>

<style scoped lang="scss">
// 表格滚动条样式
::v-deep .el-table__body-wrapper {
	&::-webkit-scrollbar {
		width: 12px;
		height: 22px;
		background-color: #0068ff;
	}

	&::-webkit-scrollbar-thumb {
		background-color: #f80606;
		border-radius: 2px;
		border: 2px solid #f2f6fc;

		&:hover {
			background-color: #fff30c;
		}
	}

	&::-webkit-scrollbar-track {
		background-color: rgba(0, 255, 70, 0.59);
		border-radius: 6px;
	}
}
</style>
