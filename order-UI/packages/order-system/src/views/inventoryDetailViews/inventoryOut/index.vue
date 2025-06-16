<script>
import { listOutStatistics, exportOutStatistics } from '../../../api/inventory/index';

export default {
	name: 'InventoryOut',
	data() {
		return {
			loading: true,
			showSearch: true,
			total: 0,
			inventoryList: [],
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				startDate: '',
				endDate: '',
				storeHouseName: '',
				levelName: '',
				customer: '',
				customerOrWarehouse: '',
				outType: ''
			},
			columns: [
				{ label: '出库日期', prop: 'outDate', visible: true },
				{ label: '车号', prop: 'carNo', visible: true },
				{ label: '客户/库房', prop: 'customerOrWarehouse', visible: true },
				{ label: '产品级别', prop: 'levelName', visible: true },
				{ label: '厚度', prop: 'height', visible: true },
				{ label: '长度', prop: 'length', visible: true },
				{ label: '宽度', prop: 'width', visible: true },
				{ label: '总片数', prop: 'totalPieces', visible: true },
				{ label: '包数', prop: 'packs', visible: true },
				{ label: '出库金额', prop: 'outAmount', visible: true },
				{ label: '出库类型', prop: 'outType', visible: true }
			]
		};
	},
	watch: {
		columns: {
			handler(newVal) {
				localStorage.setItem('detail-inventory-out-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		this.storeDisplayColumns();
	},
	methods: {
		storeDisplayColumns() {
			if (localStorage.getItem('detail-inventory-out-columns') === 'null' || !localStorage.getItem('detail-inventory-out-columns')) {
				localStorage.setItem('detail-inventory-out-columns', JSON.stringify(this.columns));
			} else {
				this.columns = JSON.parse(localStorage.getItem('detail-inventory-out-columns'));
			}
		},
		getList() {
			this.loading = true;
			const params = {
				pageNum: this.queryParams.pageNum,
				pageSize: this.queryParams.pageSize,
				startDate: this.queryParams.startDate ? this.queryParams.startDate + ' 00:00:00' : undefined,
				endDate: this.queryParams.endDate ? this.queryParams.endDate + ' 23:59:59' : undefined,
				storeHouseName: this.queryParams.storeHouseName,
				levelName: this.queryParams.levelName,
				customer: this.queryParams.customer,
				customerOrWarehouse: this.queryParams.customerOrWarehouse,
				outType: this.queryParams.outType
			};
			listOutStatistics(params).then(response => {
				this.inventoryList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleExport() {
			exportOutStatistics({
				...this.queryParams
			});
		}
	}
};
</script>

<template>
	<div class="app-container">
		<el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
			<el-form-item label="开始日期" prop="startDate">
				<el-date-picker v-model="queryParams.startDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="选择开始日期" clearable />
			</el-form-item>
			<el-form-item label="结束日期" prop="endDate">
				<el-date-picker v-model="queryParams.endDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="选择结束日期" clearable />
			</el-form-item>
			<el-form-item label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入仓库名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="产品级别" prop="levelName">
				<el-input v-model="queryParams.levelName" placeholder="请输入产品级别" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="客户/库房" prop="customerOrWarehouse">
				<el-input v-model="queryParams.customerOrWarehouse" placeholder="请输入客户/库房" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['system:inventoryMain:export']">导出</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList"></right-toolbar>
		</el-row>

		<el-table v-loading="loading" :data="inventoryList" size="mini" border>
			<el-table-column v-for="col in columns" v-if="col.visible" :key="col.prop" :label="col.label" :prop="col.prop" align="center" show-overflow-tooltip />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<style scoped lang="scss"></style>
