<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="120px">
			<el-form-item label="物品名称" prop="itemName">
				<el-input v-model="queryParams.itemName" placeholder="请输入物品名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="入库日期" prop="inDate">
				<el-date-picker v-model="queryParams.inDate" type="date" placeholder="请选择入库日期" value-format="yyyy-MM-dd" clearable />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:gift:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" :data="giftStockList" border size="mini" :cell-style="{ padding: '.5px' }">
			<el-table-column v-if="columns[0] && columns[0].visible" label="序号" type="index" width="60" align="center" />
			<el-table-column v-if="columns[1] && columns[1].visible" label="物品名称" prop="itemName" min-width="150" show-overflow-tooltip />
			<el-table-column v-if="columns[2] && columns[2].visible" label="入库日期" prop="inDate" width="120" align="center">
				<template #default="scope">
					<span>{{ parseTime(scope.row.inDate, '{y}-{m}-{d}') }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3] && columns[3].visible" label="入库方式" prop="inMethod" width="120" align="center">
				<template #default="scope">
					<dict-tag :options="dict.type.order_gift_in_method" :value="scope.row.inMethod" />
				</template>
			</el-table-column>
			<el-table-column v-if="columns[4] && columns[4].visible" label="单位" prop="unit" width="80" align="center" />
			<el-table-column v-if="columns[5] && columns[5].visible" label="入库数量" prop="quantity" width="100" align="center" />
			<el-table-column v-if="columns[6] && columns[6].visible" label="预估价值" prop="estimatedValue" width="120" align="center" />
			<el-table-column v-if="columns[7] && columns[7].visible" label="剩余数量" prop="remainingQuantity" width="100" align="center" />
			<el-table-column v-if="columns[8] && columns[8].visible" label="剩余价值" prop="remainingValue" width="120" align="center" />
			<el-table-column v-if="columns[9] && columns[9].visible" label="经办人" prop="handler" width="100" align="center" />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<script>
import { listGiftIn } from '@/api/system/giftIn';
import { listGiftOut } from '@/api/system/giftOut';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { common_excel } from '../../dashboard/mixins/common/common_excel';
import { subtract, multiply, divide, round, add } from 'mathjs';

export default {
	name: 'GiftInventory',
	dicts: ['order_gift_in_method'],
	mixins: [mixin_printHTML, common_excel],
	data() {
		return {
			loading: true,
			showSearch: true,
			total: 0,
			giftStockList: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				itemName: null,
				inDate: null
			},
			columns: [
				{ key: 0, label: '序号', visible: true },
				{ key: 1, label: '物品名称', visible: true },
				{ key: 2, label: '入库日期', visible: true },
				{ key: 3, label: '入库方式', visible: true },
				{ key: 4, label: '单位', visible: true },
				{ key: 5, label: '入库数量', visible: true },
				{ key: 6, label: '预估价值', visible: true },
				{ key: 7, label: '剩余数量', visible: true },
				{ key: 8, label: '剩余价值', visible: true },
				{ key: 9, label: '经办人', visible: true }
			]
		};
	},
	created() {
		this.initColumns();
		this.getList();
	},
	watch: {
		columns: {
			handler(newVal, oldVal) {
				if (oldVal && JSON.stringify(newVal) !== JSON.stringify(oldVal)) {
					localStorage.setItem('giftInventory-columns', JSON.stringify(newVal));
				}
			},
			deep: true
		}
	},
	methods: {
		parseTime,
		initColumns() {
			const savedColumns = localStorage.getItem('giftInventory-columns');
			if (!savedColumns || savedColumns === 'null') {
				localStorage.setItem('giftInventory-columns', JSON.stringify(this.columns));
				return;
			}
			try {
				const parsed = JSON.parse(savedColumns);
				this.columns = Array.isArray(parsed) && parsed.length > 0 ? parsed : this.columns;
			} catch (e) {
				console.error('解析列配置失败:', e);
				localStorage.setItem('giftInventory-columns', JSON.stringify(this.columns));
			}
		},
		buildQueryParams() {
			const baseParams = { pageNum: 1, pageSize: 10000 };
			const itemName = this.queryParams.itemName;
			const inDate = this.queryParams.inDate;
			const params = { ...baseParams };
			if (itemName) params.itemName = itemName;
			if (inDate) {
				params.params = {
					beginInDate: `${inDate} 00:00:00`,
					endInDate: `${inDate} 23:59:59`
				};
			}
			return params;
		},
		getList() {
			this.loading = true;
			const queryParams = this.buildQueryParams();
			Promise.all([listGiftIn(queryParams), listGiftOut(queryParams)])
				.then(([inResponse, outResponse]) => {
					const giftInList = (inResponse?.rows || []).filter(item => item && item.id !== null && item.id !== undefined);
					const giftOutList = outResponse?.rows || [];
					this.calculateStock(giftInList, giftOutList);
				})
				.catch(error => {
					this.giftStockList = [];
					this.total = 0;
					this.$message.error('获取库存数据失败');
					console.error('获取库存数据失败:', error);
				})
				.finally(() => {
					this.loading = false;
				});
		},
		calculateStock(giftInList, giftOutList) {
			const stockMap = new Map();
			giftInList.forEach(item => {
				if (!item || item.id === null || item.id === undefined) {
					return;
				}
				const inQty = Number(item.quantity) || 0;
				stockMap.set(String(item.id), {
					id: item.id,
					itemName: item.itemName || '',
					inDate: item.inDate || '',
					inMethod: item.inMethod || '',
					unit: item.unit || '',
					quantity: inQty,
					estimatedValue: Number(item.estimatedValue) || 0,
					handler: item.handler || '',
					outQuantity: 0
				});
			});
			giftOutList.forEach(outItem => {
				if (!outItem || !outItem.giftSource) {
					return;
				}
				const giftInId = String(outItem.giftSource);
				const stockItem = stockMap.get(giftInId);
				if (stockItem) {
					const outQty = Number(outItem.quantity) || 0;
					stockItem.outQuantity = add(stockItem.outQuantity, outQty);
				}
			});
			const stockList = Array.from(stockMap.values()).map(item => {
				const inQty = item.quantity;
				const outQty = item.outQuantity;
				const estimatedVal = item.estimatedValue;
				const remainingQty = subtract(inQty, outQty);
				const remainingQtyNum = remainingQty > 0 ? remainingQty : 0;
				const unitValue = inQty > 0 ? divide(estimatedVal, inQty) : 0;
				const remainingVal = multiply(remainingQtyNum, unitValue);
				return {
					...item,
					remainingQuantity: round(remainingQtyNum, 2),
					remainingValue: round(remainingVal, 2)
				};
			});
			const { pageNum, pageSize } = this.queryParams;
			const start = (pageNum - 1) * pageSize;
			this.giftStockList = stockList.slice(start, start + pageSize);
			this.total = stockList.length;
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.queryParams.itemName = null;
			this.queryParams.inDate = null;
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleExport() {
			this.excelExport([], `礼品库存_${this.parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}`);
		}
	}
};
</script>
