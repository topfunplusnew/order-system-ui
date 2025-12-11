<template>
	<div class="app-container">
		<!-- 时间选择对话框 -->
		<el-dialog title="选择查询时间" :visible.sync="dateDialogVisible" width="500px" :close-on-click-modal="false" :close-on-press-escape="false" :show-close="false">
			<el-form ref="dateForm" :model="dateForm" label-width="100px">
				<el-form-item label="入库日期" prop="inDate" :rules="[{ required: true, message: '请选择入库日期', trigger: 'change' }]">
					<el-date-picker v-model="dateForm.inDate" type="date" placeholder="请选择入库日期" value-format="yyyy-MM-dd" style="width: 100%" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="handleDateConfirm">确定</el-button>
			</div>
		</el-dialog>

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
			<right-toolbar :showSearch.sync="showSearch" :columns="toolbarColumns" @queryTable="getList">
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
			<el-table-column v-if="columns[5] && columns[5].visible" label="数量" prop="remainingQuantity" width="100" align="center">
				<template #default="scope">
					<span>{{ formatInteger(scope.row.remainingQuantity) }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[6] && columns[6].visible" label="单价" prop="unitPrice" width="100" align="center">
				<template #default="scope">
					<span>{{ formatCurrency(scope.row.unitPrice) }}</span>
				</template>
			</el-table-column>
			<el-table-column label="金额" prop="remainingValue" width="120" align="center">
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
import { listGift } from '@/api/system/giftStock';

export default {
	name: 'GiftInventory',
	dicts: ['order_gift_in_method'],
	mixins: [mixin_printHTML, common_excel],
	data() {
		return {
			loading: false,
			showSearch: true,
			total: 0,
			giftStockList: [],
			dateDialogVisible: false,
			dateForm: {
				inDate: null
			},
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
				{ key: 5, label: '数量', visible: true },
				{ key: 6, label: '单价', visible: true },
				{ key: 7, label: '金额', visible: true }
			]
		};
	},
	created() {
		this.initColumns();
		this.dateDialogVisible = true;
	},
	mounted() {
		// 确保金额列始终显示
		this.$nextTick(() => {
			if (this.columns[7]) {
				this.$set(this.columns, 7, { ...this.columns[7], visible: true });
			} else if (this.columns.length < 8) {
				this.columns.push({ key: 7, label: '金额', visible: true });
			}
		});
	},
	computed: {
		// 只传递前7列给 right-toolbar，金额列（索引7）不在工具栏控制范围内
		toolbarColumns() {
			return this.columns.slice(0, 7);
		}
	},
	watch: {
		columns: {
			handler(newVal, oldVal) {
				// 确保金额列（索引7）始终显示
				if (newVal && newVal[7] && newVal[7].visible === false) {
					this.$set(newVal, 7, { ...newVal[7], visible: true });
				}
				if (oldVal && JSON.stringify(newVal) !== JSON.stringify(oldVal)) {
					localStorage.setItem('giftInventory-columns', JSON.stringify(newVal));
				}
			},
			deep: true,
			immediate: true
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
				if (Array.isArray(parsed) && parsed.length >= 8) {
					// 确保金额列（索引7）始终显示
					this.$set(parsed, 7, { ...parsed[7], visible: true });
					this.columns = parsed;
				} else {
					// 如果配置不完整，重置为默认配置
					this.columns = [
						{ key: 0, label: '序号', visible: true },
						{ key: 1, label: '日期', visible: true },
						{ key: 2, label: '存货地点', visible: true },
						{ key: 3, label: '物品名称', visible: true },
						{ key: 4, label: '规格', visible: true },
						{ key: 5, label: '数量', visible: true },
						{ key: 6, label: '单价', visible: true },
						{ key: 7, label: '金额', visible: true }
					];
					localStorage.setItem('giftInventory-columns', JSON.stringify(this.columns));
				}
			} catch (e) {
				console.error('解析列配置失败:', e);
				// 重置为默认配置
				this.columns = [
					{ key: 0, label: '序号', visible: true },
					{ key: 1, label: '日期', visible: true },
					{ key: 2, label: '存货地点', visible: true },
					{ key: 3, label: '物品名称', visible: true },
					{ key: 4, label: '规格', visible: true },
					{ key: 5, label: '数量', visible: true },
					{ key: 6, label: '单价', visible: true },
					{ key: 7, label: '金额', visible: true }
				];
				localStorage.setItem('giftInventory-columns', JSON.stringify(this.columns));
			}
			// 确保金额列始终显示
			this.$nextTick(() => {
				if (this.columns[7]) {
					this.$set(this.columns, 7, { ...this.columns[7], visible: true });
				}
			});
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
		async getList() {
			this.loading = true;
			try {
				const queryParams = this.buildQueryParams();
				const response = await listGift(queryParams);
				const list = (response && response.rows) || [];
				// 计算剩余金额：剩余数量 × 单价
				this.giftStockList = list.map(item => {
					const remainingQty = Number(item.remainingQuantity || 0);
					const unitPrice = Number(item.unitPrice || 0);
					const remainingValue = remainingQty * unitPrice;
					return {
						...item,
						remainingValue: remainingValue || null
					};
				});
				this.total = (response && response.total) || 0;
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
			if (!this.queryParams.inDate) {
				this.$message.warning('请先选择入库日期');
				this.dateDialogVisible = true;
				return;
			}
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.queryParams.id = null;
			this.queryParams.itemName = null;
			this.queryParams.inDate = null;
			this.queryParams.inventoryLocation = null;
			this.queryParams.unit = null;
			this.dateForm.inDate = null;
			this.resetForm('queryForm');
			this.dateDialogVisible = true;
		},
		handleDateConfirm() {
			this.$refs.dateForm.validate((valid) => {
				if (valid) {
					this.queryParams.inDate = this.dateForm.inDate;
					this.dateDialogVisible = false;
					this.getList();
				}
			});
		},
		handleExport() {
			if (!this.queryParams.inDate) {
				this.$message.warning('请先选择入库日期');
				this.dateDialogVisible = true;
				return;
			}
			const queryParams = this.buildQueryParams();
			this.download(
				'system/gift/export',
				queryParams,
				`礼品库存_${this.parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`
			);
		}
	}
};
</script>
