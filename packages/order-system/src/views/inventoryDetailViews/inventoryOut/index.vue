<!-- 用户需求：出库记录页面的日期搜索改为时间范围搜索。实际改动：将开始、结束日期两个输入框合并为时分秒范围控件，并直接同步到原 startDate、endDate 查询和导出参数。 -->
<template>
	<div class="app-container">
		<el-form id="top-search-form-item" :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="150">
			<el-form-item label="时间范围">
				<el-date-picker v-model="dateRange" type="datetimerange" value-format="yyyy-MM-dd HH:mm:ss" range-separator="至" start-placeholder="开始时间" end-placeholder="结束时间" :default-time="['00:00:00', '23:59:59']" clearable style="width: 360px" />
			</el-form-item>
			<!-- 因为没用，后端要求删除 -->
			<!-- <el-form-item label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入仓库名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item> -->
			<el-form-item label="产品级别" prop="levelName">
				<el-input v-model="queryParams.levelName" placeholder="请输入产品级别" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="客户/库房" prop="customerOrWarehouse">
				<el-input v-model="queryParams.customerOrWarehouse" placeholder="请输入客户/库房" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="出库库房" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入出库库房" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['system:inventoryStatistics:outStatistics']">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" tableName="detail-inventory-out-columns">
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['system:inventoryStatistics:exportOut']"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table v-loading="loading" :data="inventoryList" size="mini" border>
			<el-table-column v-for="col in columns" v-if="col.visible" :key="col.prop" :label="col.label" :prop="col.prop" align="center" show-overflow-tooltip />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<style scoped lang="scss"></style>
<script>
import _ from 'lodash';
import { listOutStatistics } from '../../../api/inventory/index';
import { fix_2 } from '../../../api/tool/format';
import { applyInventoryRecordDateRange } from '../inventoryRecordDateRange';

export default {
	name: 'InventoryOut',
	data() {
		return {
			loading: true,
			showSearch: true,
			total: 0,
			inventoryList: [],
			dateRange: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
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
				{ label: '客户/库房', prop: 'customerOrWarehouse', visible: true },
				{ label: '车号', prop: 'carNo', visible: true },
				{ label: '出库库房', prop: 'storeHouseName', visible: true },
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
		dateRange(value) {
			applyInventoryRecordDateRange(this.queryParams, value, 'startDate', 'endDate');
		}
	},
	created() {
		this.getList();
	},
	methods: {
		getList() {
			this.loading = true;
			const params = {
				pageNum: this.queryParams.pageNum,
				pageSize: this.queryParams.pageSize,
				startDate: this.queryParams.startDate || undefined,
				endDate: this.queryParams.endDate || undefined,
				storeHouseName: this.queryParams.storeHouseName,
				levelName: this.queryParams.levelName,
				customer: this.queryParams.customer,
				customerOrWarehouse: this.queryParams.customerOrWarehouse,
				outType: this.queryParams.outType
			};
			listOutStatistics(params).then(response => {
				this.inventoryList = _.cloneDeep(response.rows).map(item => {
					return {
						...item,
						outAmount: fix_2(item.outAmount)
					};
				});
				this.total = response.total;
				this.loading = false;
			});
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.dateRange = [];
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleExport() {
			this.download(
				'system/inventoryStatistics/exportOutStatistics',
				{
					...this.queryParams
				},
				`出库统计_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
