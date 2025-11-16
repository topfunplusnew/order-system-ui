<template>
	<div class="app-container">
		<!-- 搜索区域 -->
		<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<!-- TODO: 时间范围搜索字段待定，需要根据实际需求确定字段名 -->
			<el-form-item label="日期" prop="balanceDate">
				<el-date-picker v-model="queryParams.balanceDate" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" clearable size="mini"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" size="mini" @click="handleQuery" v-hasPermi="['system:inventoryStatistics:warehouseBalance']">查询</el-button>
				<el-button size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<!-- 表格工具栏 -->
		<right-toolbar :columns="columns" @queryTable="getList">
			<template #export>
				<el-col :span="1.5">
					<el-button v-hasPermi="['system:inventoryStatistics:exportWarehouseBalance']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport">导出</el-button>
				</el-col>
			</template>
		</right-toolbar>

		<!-- 表格区域 -->
		<el-table
			id="printBox"
			v-loading="loading"
			:data="tableData"
			border
			size="mini"
			style="width: 100%"
			:cell-style="() => { return { padding: '2px' }; }"
			show-summary
			:summary-method="getSummaries"
		>
			<el-table-column v-if="columns[0].visible" prop="balanceDate" label="日期" align="center" show-overflow-tooltip width="150"></el-table-column>
			<el-table-column v-if="columns[1].visible" prop="warehouseName" label="库房名称" align="center" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[2].visible" prop="warehouseStockAmount" label="库房存货金额" align="center" show-overflow-tooltip width="200">
				<template slot-scope="scope">
					{{ formatAmount(scope.row.warehouseStockAmount) }}
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<script>
import { getWarehouseBalance, exportWarehouseBalance } from '@/api/system/StoreHouse';
import { download } from '@/utils/request';
import RightToolbar from '@/components/RightToolbar';

export default {
	name: 'InventoryBalance',
	components: {
		RightToolbar
	},
	data() {
		// 获取今天的日期字符串（格式：yyyy-MM-dd）
		const getTodayDate = () => {
			const today = new Date();
			const year = today.getFullYear();
			const month = String(today.getMonth() + 1).padStart(2, '0');
			const day = String(today.getDate()).padStart(2, '0');
			return `${year}-${month}-${day}`;
		};

		return {
			loading: false,
			tableData: [],
			total: 0,
			// 查询参数
			queryParams: {
				// TODO: 时间范围搜索字段待定，需要根据实际需求确定字段名
				balanceDate: getTodayDate(),
				warehouseName: ''
			},
			// 表格列配置
			columns: [
				{ key: 0, label: '日期', visible: true },
				{ key: 1, label: '库房名称', visible: true },
				{ key: 2, label: '库房存货金额', visible: true }
			]
		};
	},
	created() {
		// 从localStorage恢复列配置
		const savedColumns = localStorage.getItem('inventoryBalance-columns');
		if (savedColumns) {
			try {
				this.columns = JSON.parse(savedColumns);
			} catch (e) {
				console.error('恢复列配置失败', e);
			}
		}
		// 默认查询今天的数据
		this.getList();
	},
	methods: {
		// 获取今天的日期字符串（格式：yyyy-MM-dd）
		getTodayDate() {
			const today = new Date();
			const year = today.getFullYear();
			const month = String(today.getMonth() + 1).padStart(2, '0');
			const day = String(today.getDate()).padStart(2, '0');
			return `${year}-${month}-${day}`;
		},
		// 查询数据
		getList() {
			this.loading = true;
			getWarehouseBalance(this.queryParams)
				.then(res => {
					this.tableData = res.rows || [];
					this.total = res.total || this.tableData.length;
					this.loading = false;
				})
				.catch(() => {
					this.loading = false;
				});
		},
		// 查询按钮
		handleQuery() {
			this.getList();
		},
		// 重置查询
		resetQuery() {
			this.queryParams = {
				balanceDate: this.getTodayDate(),
				warehouseName: ''
			};
			this.getList();
		},
		// 导出
		handleExport() {
			download(
				'/system/inventoryStatistics/exportWarehouseBalance',
				{
					...this.queryParams
				},
				`仓库余额表_${new Date().getTime()}.xlsx`
			);
		},
		// 格式化金额
		formatAmount(amount) {
			if (amount === null || amount === undefined) {
				return '0.00';
			}
			return Number(amount).toFixed(2);
		},
		// 表格合计
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}
				if (index === 2) {
					// 库房存货金额列合计
					const values = data.map(item => Number(item[column.property]));
					if (!values.every(value => isNaN(value))) {
						const sum = values.reduce((prev, curr) => {
							const value = Number(curr);
							if (!isNaN(value)) {
								return prev + curr;
							} else {
								return prev;
							}
						}, 0);
						sums[index] = this.formatAmount(sum);
					} else {
						sums[index] = '0.00';
					}
				} else {
					sums[index] = '';
				}
			});
			return sums;
		}
	},
	watch: {
		columns: {
			handler(newVal) {
				localStorage.setItem('inventoryBalance-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	}
};
</script>

<style scoped lang="scss">
.app-container {
	padding: 20px;
}
</style>

