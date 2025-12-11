<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="120px">
			<el-form-item label="物品名称" prop="itemName">
				<el-input v-model="queryParams.itemName" placeholder="请输入物品名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="入库日期" prop="inDate">
				<el-date-picker v-model="queryParams.inDate" type="date" placeholder="请选择入库日期" value-format="yyyy-MM-dd" clearable />
			</el-form-item>
			<el-form-item label="存货地点" prop="inventoryLocation">
				<el-input v-model="queryParams.inventoryLocation" placeholder="请输入存货地点" clearable @keyup.enter.native="handleQuery" />
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
			<el-table-column v-if="columns[1] && columns[1].visible" label="日期" prop="inDate" width="120" align="center">
				<template #default="scope">
					<span>{{ scope.row.inDate ? parseTime(scope.row.inDate, '{y}-{m}-{d}') : '-' }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2] && columns[2].visible" label="存货地点" prop="inventoryLocation" width="120" align="center" show-overflow-tooltip />
			<el-table-column v-if="columns[3] && columns[3].visible" label="物品名称" prop="itemName" min-width="150" show-overflow-tooltip />
			<el-table-column v-if="columns[4] && columns[4].visible" label="规格" prop="unit" width="80" align="center" show-overflow-tooltip />
			<!-- 剩余数量 (remainingQuantity)：当前批次礼品的可用库存数量，计算公式 = 入库数量 - 已出库数量 -->
			<el-table-column v-if="columns[5] && columns[5].visible" label="剩余数量" prop="remainingQuantity" width="100" align="center">
				<template #default="scope">
					<span>{{ formatInteger(scope.row.remainingQuantity) }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[6] && columns[6].visible" label="单价" prop="unitPrice" width="100" align="center">
				<template #default="scope">
					<span>{{ formatCurrency(scope.row.unitPrice) }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[7] && columns[7].visible" label="金额" prop="remainingValue" width="120" align="center">
				<template #default="scope">
					<span>{{ formatCurrency(scope.row.remainingValue) }}</span>
				</template>
			</el-table-column>
		</el-table>
		
		<!-- 空数据提示 -->
		<div v-if="!loading && giftStockList.length === 0" style="text-align: center; padding: 40px; color: #909399;">
			<i class="el-icon-info" style="font-size: 48px; margin-bottom: 16px;"></i>
			<p>暂无库存数据</p>
			<p style="font-size: 12px; margin-top: 8px;">请检查查询条件或联系管理员</p>
		</div>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<script>
import { parseTime } from '../../../utils/ruoyi';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { common_excel } from '../../dashboard/mixins/common/common_excel';
import { listGiftIn, getGiftInOutDetail } from '@/api/system/giftIn';
import { subtract, multiply, max } from 'mathjs';

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
				id: null,
				itemName: null,
				inDate: null,
				inventoryLocation: null,
				unit: null
			},
			columns: [
				{ key: 0, label: '序号', visible: true },
				{ key: 1, label: '日期', visible: true },
				{ key: 2, label: '存货地点', visible: true },
				{ key: 3, label: '物品名称', visible: true },
				{ key: 4, label: '规格', visible: true },
				{ key: 5, label: '剩余数量', visible: true },
				{ key: 6, label: '单价', visible: true },
				{ key: 7, label: '金额', visible: true }
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
		formatCurrency(value) {
			if (value === null || value === undefined || value === '') {
				return '-';
			}
			const num = Number(value);
			return isNaN(num) ? '-' : num.toFixed(2);
		},
		formatInteger(value) {
			if (value === null || value === undefined || value === '') {
				return '-';
			}
			const num = Number(value);
			return isNaN(num) ? '-' : Math.floor(num);
		},
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
			const params = {
				pageNum: this.queryParams.pageNum,
				pageSize: this.queryParams.pageSize
			};
			// 只传递有值的参数，避免传递 null/undefined/空字符串
			if (this.queryParams.id !== null && this.queryParams.id !== undefined && this.queryParams.id !== '') {
				params.id = this.queryParams.id;
			}
			if (this.queryParams.itemName && this.queryParams.itemName.trim() !== '') {
				params.itemName = this.queryParams.itemName.trim();
			}
			if (this.queryParams.inDate && this.queryParams.inDate.trim() !== '') {
				params.inDate = this.queryParams.inDate.trim();
			}
			if (this.queryParams.inventoryLocation && this.queryParams.inventoryLocation.trim() !== '') {
				params.inventoryLocation = this.queryParams.inventoryLocation.trim();
			}
			if (this.queryParams.unit && this.queryParams.unit.trim() !== '') {
				params.unit = this.queryParams.unit.trim();
			}
			return params;
		},
		// 获取所有出库记录（通过入库ID查询每个入库记录对应的出库记录）
		async getAllOutList(inList) {
			const promises = inList.map(async (inItem) => {
				try {
					const response = await getGiftInOutDetail(inItem.id);
					let data = [];
					if (response) {
						if (Array.isArray(response)) {
							data = response;
						} else if (Array.isArray(response.data)) {
							data = response.data;
						} else if (Array.isArray(response.rows)) {
							data = response.rows;
						} else if (response.data && Array.isArray(response.data.rows)) {
							data = response.data.rows;
						} else if (response.data && Array.isArray(response.data.data)) {
							data = response.data.data;
						} else if (response.data) {
							data = Array.isArray(response.data) ? response.data : [response.data];
						}
					}
					return data.map(item => ({
						...item,
						inId: inItem.id
					}));
				} catch (error) {
					if (error && error.response && error.response.status === 404) {
						console.warn(`入库记录 ${inItem.id} 的出库详情接口不存在，跳过出库数据获取`);
					}
					return [];
				}
			});
			const results = await Promise.all(promises);
			return results.flat();
		},
		// 计算剩余数量：剩余数量 = 入库数量 - 出库数量
		calculateRemaining(inList, outList) {
			return inList.map(inItem => {
				const id = inItem.id;
				const idStr = String(id);

				// 计算总出库数量（匹配出库记录中 inId 等于当前入库记录 id 的所有记录）
				const matchedOutList = outList.filter(o => {
					const sourceId = o && o.inId;
					const sourceIdStr = sourceId ? String(sourceId) : null;
					return sourceId && sourceIdStr === idStr;
				});
				
				const outQty = matchedOutList.reduce((sum, o) => {
					const qty = Number(o.quantity || o.outQuantity || 0);
					return sum + qty;
				}, 0);

				// 入库数量
				const inQty = Number(inItem.quantity || 0);

				// 计算剩余数量 = 入库数量 - 出库数量
				const remainingQty = max(0, subtract(inQty, outQty));

				// 计算剩余金额 = 剩余数量 * 单价
				const unitPrice = Number(inItem.unitPrice || 0);
				const remainingValue = multiply(remainingQty, unitPrice);

				return {
					...inItem,
					remainingQuantity: remainingQty,
					remainingValue: remainingValue
				};
			});
		},
		async getList() {
			this.loading = true;
			try {
				const queryParams = this.buildQueryParams();
				// 1. 获取入库列表
				const inResponse = await listGiftIn(queryParams);
				let inList = (inResponse && inResponse.rows) || [];

				if (inList.length === 0) {
					this.giftStockList = [];
					this.total = 0;
					this.loading = false;
					return;
				}

				// 2. 获取所有出库记录（通过入库ID查询每个入库记录对应的出库记录）
				let outList = [];
				try {
					outList = await this.getAllOutList(inList);
				} catch (error) {
					console.warn('获取出库列表失败，将跳过出库数量计算:', error);
				}

				// 3. 计算剩余数量：剩余数量 = 入库数量 - 出库数量
				this.giftStockList = this.calculateRemaining(inList, outList);
				this.total = (inResponse && inResponse.total) || 0;
			} catch (error) {
				console.error('获取库存数据异常:', error);
				this.giftStockList = [];
				this.total = 0;
				const errorMsg = error?.response?.data?.msg || error?.response?.data?.message || error?.message || '获取库存数据失败';
				this.$message.error(errorMsg);
			} finally {
				this.loading = false;
			}
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.queryParams.id = null;
			this.queryParams.itemName = null;
			this.queryParams.inDate = null;
			this.queryParams.inventoryLocation = null;
			this.queryParams.unit = null;
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleExport() {
			const queryParams = this.buildQueryParams();
			this.download(
				'system/giftIn/export',
				queryParams,
				`礼品库存_${this.parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`
			);
		}
	}
};
</script>
