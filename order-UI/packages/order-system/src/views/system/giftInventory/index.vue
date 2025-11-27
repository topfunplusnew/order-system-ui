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

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			:data="giftStockList"
			border
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
		>
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
		if (localStorage.getItem('giftInventory-columns') === 'null' || !localStorage.getItem('giftInventory-columns')) {
			localStorage.setItem('giftInventory-columns', JSON.stringify(this.columns));
		} else {
			try {
				const savedColumns = JSON.parse(localStorage.getItem('giftInventory-columns'));
				if (Array.isArray(savedColumns) && savedColumns.length > 0) {
					this.columns = savedColumns;
				}
			} catch (e) {
				console.error('解析列配置失败:', e);
				localStorage.setItem('giftInventory-columns', JSON.stringify(this.columns));
			}
		}
		this.getList();
	},
	watch: {
		columns: {
			handler: function (newVal, oldVal) {
				// 避免初始化时触发保存
				if (oldVal && JSON.stringify(newVal) !== JSON.stringify(oldVal)) {
					localStorage.setItem('giftInventory-columns', JSON.stringify(newVal));
				}
			},
			deep: true,
			immediate: false
		}
	},
	methods: {
		parseTime,
		/** 查询礼品库存列表 */
		getList() {
			this.loading = true;
			const inParams = {
				pageNum: 1,
				pageSize: 10000
			};
			if (this.queryParams.itemName) {
				inParams.itemName = this.queryParams.itemName;
			}
			if (this.queryParams.inDate) {
				inParams.params = {};
				inParams.params['beginInDate'] = this.queryParams.inDate + ' 00:00:00';
				inParams.params['endInDate'] = this.queryParams.inDate + ' 23:59:59';
			}
			const outParams = {
				pageNum: 1,
				pageSize: 10000
			};
			if (this.queryParams.itemName) {
				outParams.itemName = this.queryParams.itemName;
			}
			Promise.all([listGiftIn(inParams), listGiftOut(outParams)])
				.then(([inResponse, outResponse]) => {
					const giftInList = inResponse?.rows || [];
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
		/** 计算库存数据 */
		calculateStock(giftInList, giftOutList) {
			const stockMap = new Map();
			giftInList.forEach(item => {
				const key = item.id;
				if (!stockMap.has(key)) {
					stockMap.set(key, {
						id: item.id,
						itemName: item.itemName || '',
						inDate: item.inDate || '',
						inMethod: item.inMethod || '',
						unit: item.unit || '',
						quantity: Number(item.quantity) || 0,
						estimatedValue: Number(item.estimatedValue) || 0,
						handler: item.handler || '',
						outQuantity: 0,
						remainingQuantity: 0,
						remainingValue: 0
					});
				}
			});
			giftOutList.forEach(outItem => {
				if (outItem.giftSource) {
					const giftInId = String(outItem.giftSource);
					if (stockMap.has(giftInId)) {
						const stockItem = stockMap.get(giftInId);
						const outQty = Number(outItem.quantity) || 0;
						const currentOutQty = Number(stockItem.outQuantity) || 0;
						stockItem.outQuantity = add(currentOutQty, outQty);
					}
				}
			});
			const stockList = Array.from(stockMap.values()).map(item => {
				const inQty = Number(item.quantity) || 0;
				const outQty = Number(item.outQuantity) || 0;
				const estimatedVal = Number(item.estimatedValue) || 0;
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
			const total = stockList.length;
			const start = (this.queryParams.pageNum - 1) * this.queryParams.pageSize;
			const end = start + this.queryParams.pageSize;
			this.giftStockList = stockList.slice(start, end);
			this.total = total;
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.queryParams.itemName = null;
			this.queryParams.inDate = null;
			this.resetForm('queryForm');
			this.handleQuery();
		},
		/** 导出按钮操作 */
		handleExport() {
			this.excelExport([], `礼品库存_${this.parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}`);
		}
	}
};
</script>
