<template>
	<div class="app-container">
		<el-form
			:model="queryParams"
			ref="queryForm"
			size="small"
			:inline="true"
			label-width="100px"
			class="search-form"
		>
			<el-form-item label="仓库名称" prop="storeHouseName">
				<el-input
					v-model="queryParams.storeHouseName"
					placeholder="请输入仓库名称"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="入库日期" prop="storeDate">
				<el-date-picker
					v-model="queryParams.storeDate"
					type="date"
					placeholder="选择入库日期"
					clearable
					@change="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="供应商" prop="supplier">
				<el-input
					v-model="queryParams.supplier"
					placeholder="请输入供应商"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
					>搜索
				</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery"
					>重置
				</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="20">
			<el-col
				:span="8"
				v-for="(items, category) in categorizedInventory"
				:key="category"
			>
				<el-card
					:body-style="{ padding: '10px' }"
					shadow="hover"
					class="category-card"
				>
					<div class="card-header">
						<strong>{{ category }}</strong>
						<el-button
							type="text"
							size="mini"
							class="change-log-button"
							@click="openChangeLog(category)"
							>查看变动记录</el-button
						>
					</div>
					<div class="card-content">
						<el-table :data="items" size="mini" border stripe>
							<el-table-column
								label="剩余量"
								prop="total_remaining"
								align="center"
							/>
							<el-table-column
								label="总出库量"
								prop="total_stock_out"
								align="center"
							/>
							<el-table-column
								label="总入库量"
								prop="total_stock_in"
								align="center"
							/>
							<el-table-column label="价格" prop="price" align="center" />
							<el-table-column
								label="类别编号"
								prop="categoryNo"
								align="center"
							/>
							<el-table-column label="长度" prop="length" align="center" />
							<el-table-column label="宽度" prop="width" align="center" />
							<el-table-column
								label="级别名称"
								prop="levelName"
								align="center"
							/>
							<el-table-column label="吨位" prop="tonnage" align="center" />
							<el-table-column label="级别编码" prop="levelNo" align="center" />
							<el-table-column
								label="类别名称"
								prop="categoryName"
								align="center"
							/>
							<el-table-column label="高度" prop="height" align="center" />
						</el-table>
					</div>
				</el-card>
			</el-col>
		</el-row>
		<el-dialog
			title="变动记录"
			:visible.sync="changeLogVisible"
			width="50%"
			class="change-log-dialog"
		>
			<el-table :data="changeLogData" size="mini" border stripe>
				<el-table-column label="日期" prop="date" align="center" />
				<el-table-column label="变动类型" prop="type" align="center" />
				<el-table-column label="数量" prop="quantity" align="center" />
				<el-table-column label="备注" prop="remark" align="center" />
			</el-table>
		</el-dialog>
	</div>
</template>

<script>
import { listInventoryMain } from '@/api/system/inventoryMain';
import { inventorySummary } from '../../../api/system/statement';

export default {
	name: 'InventoryTotal',
	data() {
		return {
			queryParams: {
				storeHouseName: '',
				storeDate: '',
				supplier: ''
			},
			inventoryMainList: [],
			categorizedInventory: {},
			changeLogVisible: false,
			changeLogData: []
		};
	},
	created() {
		// this.getInventoryData();
		this.getSummary();
	},
	methods: {
		getInventoryData() {
			listInventoryMain({
				pageNum: 1,
				pageSize: 1000,
				...this.queryParams
			}).then(response => {
				this.inventoryMainList = response.rows;
				this.categorizeInventory();
			});
		},
		getSummary() {
			inventorySummary().then(response => {
				this.inventoryMainList = response.data;
				this.categorizeInventory();
			});
		},
		categorizeInventory() {
			this.categorizedInventory = this.inventoryMainList.reduce((acc, item) => {
				const category = item.levelNo || '未分类';
				if (!acc[category]) {
					acc[category] = [];
				}
				acc[category].push(item);
				return acc;
			}, {});
		},
		handleQuery() {
			this.getInventoryData();
		},
		resetQuery() {
			this.queryParams = {
				storeHouseName: '',
				storeDate: '',
				supplier: ''
			};
			this.handleQuery();
		},
		openChangeLog(category) {
			this.changeLogData = [
				{ date: '2023-10-01', type: '入库', quantity: 100, remark: '初始入库' },
				{ date: '2023-10-05', type: '出库', quantity: 20, remark: '销售出库' }
			];
			this.changeLogVisible = true;
		}
	}
};
</script>

<style scoped>
.app-container {
	padding: 20px;
	background-color: #f5f5f5;
}
.search-form {
	margin-bottom: 20px;
	background-color: #fff;
	padding: 15px;
	border-radius: 8px;
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
.category-card {
	margin-bottom: 20px;
	border-radius: 10px;
	transition: transform 0.3s, box-shadow 0.3s;
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
.category-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.15);
}
.card-header {
	font-size: 18px;
	font-weight: bold;
	margin-bottom: 10px;
	text-align: center;
	color: #409eff;
	display: flex;
	justify-content: space-between;
	align-items: center;
}
.card-content {
	font-size: 14px;
	line-height: 1.5;
	margin-bottom: 10px;
}
.change-log-button {
	color: #409eff;
	font-size: 12px;
}
.change-log-dialog .el-dialog__header {
	background-color: #409eff;
	color: #fff;
}
.change-log-dialog .el-dialog__body {
	padding: 20px;
}
.el-table th,
.el-table td {
	padding: 8px 10px;
}
</style>
