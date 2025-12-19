<template>
	<div class="app-container">
		<!-- 查询条件 -->
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="120px">
			<el-form-item label="物品名称">
				<el-input v-model="queryParams.itemName" placeholder="请输入物品名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="入库日期">
				<el-date-picker v-model="queryParams.inDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择入库日期" clearable />
			</el-form-item>

			<el-form-item label="存货地点">
				<el-input v-model="queryParams.inventoryLocation" placeholder="请输入存货地点" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<!-- 工具栏 -->
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>

			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>

				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:gift:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<!-- 表格 -->
		<el-table id="printBox" v-loading="loading" :data="giftStockList" border size="mini" v-horizontal-scroll="'always'" :cell-style="{ padding: '.5px' }">
			<el-table-column v-if="columns[0].visible" label="序号" type="index" width="60" align="center" />

			<el-table-column v-if="columns[1].visible" label="日期" prop="inDate" width="120" align="center">
				<template #default="scope">
					{{ scope.row.inDate ? parseTime(scope.row.inDate, '{y}-{m}-{d}') : '-' }}
				</template>
			</el-table-column>

			<el-table-column v-if="columns[2].visible" label="存货地点" prop="inventoryLocation" width="120" align="center" show-overflow-tooltip />

			<el-table-column v-if="columns[3].visible" label="物品名称" prop="itemName" min-width="150" show-overflow-tooltip />

			<el-table-column v-if="columns[4].visible" label="规格" prop="unit" width="80" align="center" />

			<el-table-column v-if="columns[5].visible" label="数量" prop="remainingQuantity" width="100" align="center">
				<template #default="scope">
					{{ formatInteger(scope.row.remainingQuantity) }}
				</template>
			</el-table-column>

			<el-table-column v-if="columns[6].visible" label="单价" prop="unitPrice" width="100" align="center">
				<template #default="scope">
					{{ formatCurrency(scope.row.unitPrice) }}
				</template>
			</el-table-column>

			<!-- 金额列：业务强制显示，不进 columns 控制 -->
			<el-table-column label="金额" prop="remainingValue" width="120" align="center">
				<template #default="scope">
					{{ formatCurrency(scope.row.remainingValue) }}
				</template>
			</el-table-column>
		</el-table>

		<!-- 空数据 -->
		<div v-if="!loading && giftStockList.length === 0" style="text-align: center; padding: 40px; color: #909399">
			<i class="el-icon-info" style="font-size: 48px" />
			<p>暂无库存数据</p>
		</div>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<script>
import { parseTime } from '@/utils/ruoyi';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';
import { listGift } from '@/api/system/giftStock';

export default {
	name: 'GiftInventory',
	mixins: [mixin_printHTML, common_excel],
	data() {
		return {
			loading: false,
			showSearch: true,
			total: 0,
			giftStockList: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				itemName: null,
				inDate: null,
				inventoryLocation: null
			},
			// 只控制可隐藏列
			columns: [
				{ label: '序号', visible: true },
				{ label: '日期', visible: true },
				{ label: '存货地点', visible: true },
				{ label: '物品名称', visible: true },
				{ label: '规格', visible: true },
				{ label: '数量', visible: true },
				{ label: '单价', visible: true }
			]
		};
	},
	created() {
		this.queryParams.inDate = this.getTodayDate();
		this.getList();
	},
	methods: {
		parseTime,
		getTodayDate() {
			const d = new Date();
			return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
		},
		formatCurrency(val) {
			const num = Number(val);
			return isNaN(num) ? '-' : num.toFixed(2);
		},
		formatInteger(val) {
			const num = Number(val);
			return isNaN(num) ? '-' : Math.floor(num);
		},
		buildQueryParams() {
			const params = { pageNum: this.queryParams.pageNum, pageSize: this.queryParams.pageSize };
			if (this.queryParams.itemName) params.itemName = this.queryParams.itemName.trim();
			if (this.queryParams.inDate) params.inDate = this.queryParams.inDate;
			if (this.queryParams.inventoryLocation) params.inventoryLocation = this.queryParams.inventoryLocation.trim();
			return params;
		},
		async getList() {
			this.loading = true;
			try {
				const res = await listGift(this.buildQueryParams());
				this.giftStockList = (res.rows || []).map(item => ({
					...item,
					remainingValue: Number(item.remainingQuantity || 0) * Number(item.unitPrice || 0)
				}));
				this.total = res.total || 0;
			} finally {
				this.loading = false;
			}
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.resetForm('queryForm');
			this.queryParams.inDate = this.getTodayDate();
			this.getList();
		},
		handleExport() {
			this.download('system/gift/export', this.buildQueryParams(), `礼品库存_${this.parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`);
		}
	}
};
</script>
