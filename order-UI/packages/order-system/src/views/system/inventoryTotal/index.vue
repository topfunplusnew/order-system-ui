<template>
	<div class="app-container">
		<el-form id="top-search-form-item" :model="queryParams" ref="queryForm" size="mini" :inline="true" label-width="150" class="search-form">
			<el-form-item label="级别名" prop="levelName">
				<el-input v-model="queryParams.levelName" placeholder="请输入级别名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="级别编码" prop="levelNo">
				<el-input v-model="queryParams.levelNo" placeholder="请输入级别编码" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="分类编码" prop="categoryNo">
				<el-input v-model="queryParams.categoryNo" placeholder="请输入分类编码" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="分类名称" prop="categoryName">
				<el-input v-model="queryParams.categoryName" placeholder="请输入分类名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="长度" prop="height">
				<el-input v-model="queryParams.height" placeholder="请输入长度" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="宽度" prop="width">
				<el-input v-model="queryParams.width" placeholder="请输入宽度" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="厚度" prop="length">
				<el-input v-model="queryParams.length" placeholder="请输入厚度" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入仓库名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>
		<el-row>
			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:invoiceother:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>
		<div class="inventory-table-container">
			<el-table v-if="inventoryMainList.length > 0" :data="inventoryMainList" size="mini" border stripe>
				<el-table-column label="仓库名称" prop="storeHouseName" align="center" show-overflow-tooltip />
				<el-table-column label="级别名称" prop="levelName" align="center" width="150" show-overflow-tooltip />
				<el-table-column label="级别编码" prop="levelNo" align="center" />
				<el-table-column label="厚度" prop="height" align="center" />
				<el-table-column label="长度" prop="length" align="center" />
				<el-table-column label="宽度" prop="width" align="center" />
				<el-table-column label="价格" prop="price" align="center" />
				<el-table-column label="初始入库日期" prop="firstStoreDate" align="center" show-overflow-tooltip />
				<el-table-column label="剩余库存金额" prop="remainingAmount" align="center">
					<template #default="scope">
						<div v-if="scope.row.remainingAmount">
							{{ scope.row.remainingAmount.toFixed(3) }}
						</div>
						<div v-else>
							{{ 0 }}
						</div>
					</template>
				</el-table-column>
				<el-table-column label="吨位" prop="tonnage" align="center" />
				<el-table-column label="总入库量" prop="totalStockIn" align="center" />
				<el-table-column label="总出库量" prop="totalStockOut" align="center" />
				<el-table-column label="剩余量" prop="totalRemaining" align="center" />
				<el-table-column label="类别名称" prop="categoryName" align="center" />
				<el-table-column label="类别编号" prop="categoryNo" align="center" />
				<el-table-column label="操作" width="120" align="center">
					<template slot-scope="scope">
						<el-button type="text" size="mini" @click="openChangeLog(scope.row)">查看变动记录</el-button>
					</template>
				</el-table-column>
			</el-table>
			<el-empty v-else description="暂无数据" />

			<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getSummary" />
		</div>

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="变动记录" :visible.sync="changeLogVisible" width="1000px" class="change-log-dialog">
			<!-- 新增明细标题行 -->
			<div style="margin-bottom: 10px; font-weight: bold">
				<span style="margin-right: 100px">库存明细</span>
				<span>{{ currentItem && currentItem.storeHouseName ? currentItem.storeHouseName : '' }}</span>
			</div>
			<el-table :data="changeLogData" size="mini" border stripe v-loading="changeLogLoading">
				<el-table-column label="类别" align="center">
					<template slot-scope="scope">
						{{ scope.row.change_amount > 0 ? '入库' : '出库' }}
					</template>
				</el-table-column>
				<el-table-column label="来源方向" prop="source" align="center" />
				<el-table-column label="级别名称" prop="levelName" align="center" width="150" />
				<el-table-column label="厚度" prop="height" align="center" />
				<el-table-column label="长度" prop="length" align="center" />
				<el-table-column label="宽度" prop="width" align="center" />
				<el-table-column label="每包片数" prop="piecesPerPack" align="center" />
				<el-table-column label="包数" prop="packs" align="center" />
				<el-table-column label="变动片数" align="center">
					<template slot-scope="scope">
						{{ Math.abs(scope.row.change_amount) }}
					</template>
				</el-table-column>
				<el-table-column label="剩余库存" prop="remaining_stock" align="center" />
				<el-table-column label="库存金额" align="center">
					<template slot-scope="scope">
						{{ (Math.abs(scope.row.change_amount) * (currentItem && currentItem.price ? currentItem.price : 0)).toFixed(2) }}
					</template>
				</el-table-column>
			</el-table>
			<pagination
				v-show="changeLogTotal > 0"
				:total="changeLogTotal"
				:page.sync="changeLogQueryParams.pageNum"
				:limit.sync="changeLogQueryParams.pageSize"
				@pagination="getChangeLogData"
				class="change-log-pagination"
			/>
		</el-dialog>
	</div>
</template>

<script>
import { listInventoryMain } from '@/api/system/inventoryMain';
import { inventorySummary } from '../../../api/system/statement';
import { listInventoryDetails } from '../../../api/system/inventoryMain';
import Pagination from '@/components/Pagination';

export default {
	name: 'InventoryTotal',
	components: { Pagination },
	data() {
		return {
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				storeHouseName: '',
				storeDate: '',
				supplier: '',
				levelName: '',
				levelNo: '',
				categoryNo: '',
				categoryName: '',
				height: '',
				width: '',
				length: ''
			},
			// 变动记录查询参数
			changeLogQueryParams: {
				pageNum: 1,
				pageSize: 20,
				startDate: '',
				endDate: '',
				levelID: ''
			},
			inventoryMainList: [],
			changeLogVisible: false,
			changeLogData: [],
			changeLogLoading: false,
			changeLogTotal: 0,
			total: 0,
			loading: false,
			currentItem: null
		};
	},
	created() {
		this.getSummary();
	},
	methods: {
		handleExport() {
			this.download(
				'/system/inventoryMain/totalStock/export',
				{
					...this.queryParams
				},
				`库存台账-${new Date().getTime()}.xlsx`
			);
		},
		getSummary() {
			this.loading = true;
			inventorySummary(this.queryParams).then(response => {
				this.inventoryMainList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getSummary();
		},
		resetQuery() {
			this.queryParams = {
				pageNum: 1,
				pageSize: 20,
				storeHouseName: '',
				storeDate: '',
				supplier: '',
				levelName: '',
				levelNo: '',
				categoryNo: '',
				categoryName: '',
				height: '',
				width: '',
				length: ''
			};
			this.handleQuery();
		},
		openChangeLog(row) {
			this.currentItem = row;
			this.$datePicker().then(({ beginTime, endTime }) => {
				this.changeLogQueryParams = {
					pageNum: 1,
					pageSize: 20,
					startDate: beginTime,
					endDate: endTime,
					levelID: row.levelID
				};
				this.getChangeLogData();
				this.changeLogVisible = true;
			});
		},
		getChangeLogData() {
			this.changeLogLoading = true;
			listInventoryDetails(this.changeLogQueryParams).then(response => {
				this.changeLogData = response.data;
				this.changeLogTotal = response.total || this.changeLogData.length;
				this.changeLogLoading = false;
			});
		}
	}
};
</script>

<style scoped>
.app-container {
	padding: 20px;
}

.search-form {
	margin-bottom: 20px;
	background-color: #fff;
	padding: 15px;
	border-radius: 8px;
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.inventory-table-container {
	background-color: #fff;
	padding: 15px;
	border-radius: 8px;
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.pagination {
	margin-top: 15px;
	text-align: right;
}

.change-log-dialog .el-dialog__header {
	background-color: #409eff;
	color: #fff;
}

.change-log-dialog .el-dialog__body {
	padding: 20px;
}

.change-log-pagination {
	margin-top: 15px;
	text-align: right;
}

.el-table th,
.el-table td {
	padding: 8px 10px;
}
</style>
