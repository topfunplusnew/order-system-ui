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
			selectedList: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20
			}
		};
	},
	computed: {
		// 选择的货物列表
		filterSelectedList() {
			return this.orderDetailList;
		}
	},
	methods: {
		handleSelectionChange(selection) {
			this.selectedList = selection;
		},
		submitSelectOrderDetail() {
			this.$emit('handleSelect', this.selectedList);
		},
		// 对货物进行查询和筛选
		handleQuery() {
			this.$emit('handleQuery', this.queryParams);
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
			:data="filterSelectedList"
			:cell-style="
				() => {
				return { padding: '.5px' };
			}
			"
			max-height="700"
			size="mini"
			@selection-change="handleSelectionChange"
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
				<template slot-scope="scope">
					<el-tag :type="scope.row.isIncludeTaxFactory === '否' ? 'danger' : 'success'" disable-transitions>
						{{ scope.row.isIncludeTaxFactory }}
					</el-tag>
				</template>
			</el-table-column>
			<!-- 其他列保持类似 -->
			<el-table-column label="佣金" align="center" prop="customerCommission" min-width="90" />
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
