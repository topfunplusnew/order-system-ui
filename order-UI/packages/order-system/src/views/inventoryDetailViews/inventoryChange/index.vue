<template>
	<div class="inventory-change">
		<!-- 查询区域 -->
		<div class="search-area">
			<el-form :inline="true" :model="searchForm" ref="form" size="mini" class="demo-form-inline">
				<el-form-item label="开始日期" prop="startDate">
					<el-date-picker v-model="searchForm.startDate" type="date" placeholder="请选择开始日期" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
				<el-form-item label="结束日期" prop="endDate">
					<el-date-picker v-model="searchForm.endDate" type="date" placeholder="请选择结束日期" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
				<el-form-item label="仓库名称" prop="warehouseName">
					<el-input v-model="searchForm.warehouseName" placeholder="请输入仓库名称" clearable size="mini"></el-input>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="getList" size="mini">查询</el-button>
					<el-button @click="reset" size="mini">重置</el-button>
				</el-form-item>
			</el-form>
		</div>
		<el-row>
			<right-toolbar @queryTable="getList">
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:goodsorder:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>
		<!-- 表格区域 -->
		<el-table :data="tableData" border style="width: 100%" v-loading="loading" size="mini">
			<el-table-column prop="changeDate" label="日期" align="center"></el-table-column>
			<el-table-column prop="warehouseName" label="库房名称" align="center"></el-table-column>
			<el-table-column label="入库明细" align="center">
				<template slot-scope="scope">
					<div v-if="scope.row.inDetailsList && scope.row.inDetailsList.length">
						<div v-for="item in scope.row.inDetailsList" :key="item.detailId" style="margin-right: 10px">
							<span style="color: #67c23a; margin-right: 2px">{{ Number(item.amount).toFixed(2) }}</span>
							<i class="el-icon-s-order" style="cursor: pointer; color: #409eff" @click="showDetail(item, 'IN', scope.row)"></i>
						</div>
					</div>
					<div v-else>0.00</div>
				</template>
			</el-table-column>
			<el-table-column prop="totalInAmount" label="入库金额" align="center">
				<template slot-scope="scope">
					<span v-if="scope.row.totalInAmount !== undefined">{{ scope.row.totalInAmount.toFixed(2) }}</span>
					<span v-else>0.00</span>
				</template>
			</el-table-column>
			<el-table-column label="出库明细" align="center">
				<template slot-scope="scope">
					<div v-if="scope.row.outDetailsList && scope.row.outDetailsList.length">
						<div v-for="item in scope.row.outDetailsList" :key="item.detailId" style="margin-right: 10px">
							<span style="color: #f56c6c; margin-right: 2px">{{ Number(item.amount).toFixed(2) }}</span>
							<i class="el-icon-s-order" style="cursor: pointer; color: #409eff" @click="showDetail(item, 'OUT', scope.row)"></i>
						</div>
					</div>
					<div v-else>0.00</div>
				</template>
			</el-table-column>
			<el-table-column prop="totalOutAmount" label="出库金额" align="center">
				<template slot-scope="scope">
					<span v-if="scope.row.totalOutAmount !== undefined">{{ scope.row.totalOutAmount.toFixed(2) }}</span>
					<span v-else>0.00</span>
				</template>
			</el-table-column>
			<el-table-column prop="warehouseStockAmount" label="库房存货金额" align="center">
				<template slot-scope="scope">
					<span v-if="scope.row.warehouseStockAmount !== undefined">{{ scope.row.warehouseStockAmount.toFixed(2) }}</span>
					<span v-else>0.00</span>
				</template>
			</el-table-column>
		</el-table>

		<!-- 分页 -->
		<div class="pagination-container">
			<pagination v-show="total > 0" :total="total" :current-page.sync="searchForm.pageNum" :page-size.sync="searchForm.pageSize" @pagination="getList" />
		</div>

		<!-- 明细弹窗 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="明细信息" :visible.sync="detailVisible" width="500px" append-to-body>
			<el-table v-if="currentDetail" :data="[currentDetail]" border style="width: 100%" size="mini">
				<el-table-column prop="detailId" label="明细ID" align="center"></el-table-column>
				<el-table-column prop="detail" label="明细" align="center"></el-table-column>
				<el-table-column label="类型" align="center">
					<template>
						<span v-if="currentDetailType === 'IN'" style="color: #67c23a">入库</span>
						<span v-else-if="currentDetailType === 'OUT'" style="color: #f56c6c">出库</span>
					</template>
				</el-table-column>
				<el-table-column prop="amount" label="金额" align="center">
					<template slot-scope="scope">
						{{ Number(scope.row.amount).toFixed(2) }}
					</template>
				</el-table-column>
			</el-table>
		</el-dialog>

		<div v-if="currentComponent">
			<DialogWrapper
				:current-component="currentComponent"
				:dialog-visible="dialogVisible"
				:dialog-props="dialogProps"
				:dialog-title="dialogTitle"
				:dialog-width="dialogWidth"
				@update:dialogVisible="args => (dialogVisible = false)"
				@close="handleCloseDialog"
				@confirm="handleDialogConfirm"
			/>
		</div>
	</div>
</template>

<script>
import { inventoryChangeDetails } from '@/api/inventory';
import { getInventoryMain } from '@/api/system/inventoryMain';
import { getExWarehouse } from '@/api/system/exWarehouse';
import Pagination from '@/components/Pagination';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';
import WAREHOUSE from '../../../components/NeedToShow/WAREHOUSE.vue';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
export default {
	name: 'DetailInventoryChange',
	components: { Pagination, DialogWrapper },
	mixins: [common_dialog],
	data() {
		return {
			loading: false,
			total: 0,
			searchForm: {
				startDate: '',
				endDate: '',
				warehouseName: '',
				pageNum: 1,
				pageSize: 10
			},
			tableData: [],
			detailVisible: false,
			detailRow: null,
			currentDetail: null,
			currentDetailType: ''
		};
	},
	created() {
		this.getList();
	},
	methods: {
		handleExport() {
			this.download(
				'/system/inventoryStatistics/exportWarehouseFundChange',
				{
					...this.queryParams
				},
				`库存明细变动_${new Date().getTime()}.xlsx`
			);
		},
		getList() {
			this.loading = true;
			inventoryChangeDetails(this.searchForm)
				.then(res => {
					this.tableData = res.rows || [];
					this.total = res.total || this.tableData.length;
					this.loading = false;
				})
				.catch(() => {
					this.loading = false;
				});
		},
		reset() {
			this.searchForm = {
				startDate: '',
				endDate: '',
				warehouseName: '',
				pageNum: 1,
				pageSize: 10
			};
			this.getList();
		},
		async showDetail(item, type, row) {
			this.currentDetail = item;
			this.currentDetailType = type;
			if (type === 'IN') {
				// 入库明细，调用 getInventoryMain
				const res = await getInventoryMain(item.detailId);
				if (!res.data) {
					this.$message.warning('未找到入库明细信息');
					return;
				}
				this.openDialog(
					INVENTORY,
					'入库详情信息',
					'1500px',
					{
						needToShowInfo: res.data
					},
					false
				);
			} else if (type === 'OUT') {
				// 出库明细，调用 getExWarehouse
				const res = await getExWarehouse(item.detailId);
				if (!res.data) {
					this.$message.warning('未找到出库明细信息');
					return;
				}
				this.openDialog(
					WAREHOUSE,
					'出库详情信息',
					'1500px',
					{
						warehouseData: res.data
					},
					false
				);
			} else {
				this.detailVisible = true;
			}
		}
	}
};
</script>

<style scoped>
.inventory-change {
	padding: 15px;
}
.search-area {
	margin-bottom: 15px;
	padding: 15px;
	background-color: #fff;
	border-radius: 4px;
}
.pagination-container {
	margin-top: 15px;
	display: flex;
	justify-content: flex-end;
}
</style>
