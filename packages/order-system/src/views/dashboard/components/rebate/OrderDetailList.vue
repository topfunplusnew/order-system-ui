<!--
浏览器实测补充：重新搜索后表格自动清选不能覆盖本单选择；仅通过用户勾选/全选事件更新集合，忽略换数据触发的 selection-change。
用户需求：供应商返利只选一行时不能带出其他返利单的历史货物，当前返利单仍可跨查询追加。
实际改动：仅从 selectedOrderDetails 初始化选择，移除全局缓存读写；临时勾选只保留在本次选单组件内。
需求：订单选择支持产品级别、厚度、长度、宽度筛选，并允许多次调整条件追加选择；已选明细在再次搜索时保持勾选，可一键清空。
改动：维护跨查询的已选明细集合，按明细 id 去重并回显当前结果；新增筛选字段和“清空已选”操作。
-->

<script>
import SearchOption from '@/components/SearchOption.vue';
import { listProductLevel } from '@/api/system/productLevel';
import { listCompany } from '@/api/system/company';

export default {
	name: 'OrderDetailList',
	components: { SearchOption },
	props: {
		orderDetailList: {
			type: Array,
			default: () => []
		},
		total: {
			type: Number,
			default: 0
		},
		selectedOrderDetails: {
			type: Array,
			default: () => []
		},
		initialQuery: {
			type: Object,
			default: () => ({})
		}
	},
	data() {
		return {
			loading: false,
			selectedList: [],
			selectedMap: Object.create(null),
			restoringSelection: false,
			queryLevel: '',
			queryCompany: '',
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				params: {
					// 订单日期排序：asc / desc
					orderDateSort: null
				}
			}
		};
	},
	computed: {
		// 选择的货物列表
		filterSelectedList() {
			return this.orderDetailList;
		}
	},
	watch: {
		selectedOrderDetails: {
			immediate: true,
			handler(list) {
				this.selectedList = [...(list || [])];
				this.selectedMap = Object.create(null);
				this.selectedList.forEach(item => {
					if (item && item.id != null) this.selectedMap[String(item.id)] = item;
				});
				this.$nextTick(this.restoreVisibleSelection);
			}
		},
		orderDetailList() {
			this.$nextTick(() => {
				this.restoreVisibleSelection();
				setTimeout(this.restoreVisibleSelection, 80);
			});
		},
		initialQuery: {
			immediate: true,
			deep: true,
			handler(query) {
				this.queryParams = {
					...this.queryParams,
					...(query || {}),
					params: { ...this.queryParams.params, ...((query && query.params) || {}) }
				};
			}
		}
	},
	methods: {
		boolTag(val) {
			if (val === 0 || val === '0' || val === false) return '否';
			if (val === 1 || val === '1' || val === true) return '是';
			if (val === '否' || val === '是') return val;
			return '未知';
		},
		boolTagType(val) {
			const text = this.boolTag(val);
			return text === '否' ? 'danger' : text === '是' ? 'success' : 'info';
		},
		listProductLevel,
		listCompany,
		handleCompanySelect(value) {
			if (value) this.queryParams.supplier = value.companyName;
		},
		handleProductLevelQuery(value) {
			this.queryLevel = value;
		},
		handleProductLevelSelect(value) {
			if (!value) return;
			this.queryParams.levelName = value.levelName;
			this.queryParams.levelID = value.id;
			this.queryParams.height = value.height;
			this.queryParams.length = value.length;
			this.queryParams.width = value.width;
		},
		handleSelectionChange(selection) {
			if (this.restoringSelection) return;
			const visibleIds = new Set(this.orderDetailList.filter(item => item && item.id != null).map(item => String(item.id)));
			visibleIds.forEach(id => delete this.selectedMap[id]);
			(selection || []).forEach(item => {
				if (item && item.id != null) this.selectedMap[String(item.id)] = item;
			});
			this.selectedList = Object.values(this.selectedMap);
		},
		submitSelectOrderDetail() {
			this.$emit('handleSelect', this.selectedList);
		},
		clearSelectedOrderDetails() {
			this.selectedMap = Object.create(null);
			this.selectedList = [];
			this.$emit('handleClearSelected');
			this.$nextTick(this.restoreVisibleSelection);
			setTimeout(this.restoreVisibleSelection, 80);
		},
		restoreVisibleSelection() {
			const table = this.$refs.orderDetailTable;
			if (!table) return;
			this.restoringSelection = true;
			try {
				table.clearSelection();
				this.orderDetailList.forEach(row => {
					if (row && row.id != null && this.selectedMap[String(row.id)]) table.toggleRowSelection(row, true);
				});
			} finally {
				this.$nextTick(() => {
					this.restoringSelection = false;
				});
			}
		},
		// 对货物进行查询和筛选
		handleQuery(pagination) {
			// pagination 组件会先触发 @pagination({page, limit})，再通过 .sync 更新 queryParams；
			// 这里优先使用事件入参同步一次，避免 pageSize 仍是旧值（如 20）导致请求参数错误。
			const pageNum = pagination?.page || this.queryParams.pageNum;
			const pageSize = pagination?.limit || this.queryParams.pageSize;
			this.queryParams.pageNum = pageNum;
			this.queryParams.pageSize = pageSize;
			this.$emit('handleQuery', this.queryParams);
		},
		/** 表格排序触发事件（服务端排序） */
		handleSortChange({ prop, order }) {
			// 只处理订单日期列排序
			if (prop !== 'orderDate') return;

			// ascending / descending / null
			const sortVal = order === 'ascending' ? 'asc' : order === 'descending' ? 'desc' : null;
			this.queryParams.params.orderDateSort = sortVal;
			this.queryParams.pageNum = 1;
			this.handleQuery();
		}
	}
};
</script>

<template>
	<div>
		<!--		需要对货物进行查询和筛选-->
		<el-form :model="queryParams" size="mini" :inline="true" label-width="100px">
			<el-row>
				<el-form-item label="时间范围" prop="orderDateRange">
					<el-date-picker v-model="queryParams.orderDateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd" />
				</el-form-item>
				<el-form-item label="供应商名称" prop="supplier">
					<el-row type="flex" align="middle">
						<el-input v-model="queryParams.supplier" placeholder="请选择供应商" />
						<SearchOption :limit-info="{ companyType: '供应商' }" :get-data="listCompany" query-info="companyName" query-label="供应商查找" :query-name="queryCompany" @update:queryName="value => (queryCompany = value)" @commitBack="handleCompanySelect">
							<template #table-columns><el-table-column label="供应商" align="center" prop="companyName" /></template>
						</SearchOption>
					</el-row>
				</el-form-item>
				<el-form-item label="产品级别" prop="levelName">
					<el-row type="flex" align="middle">
						<el-input v-model="queryParams.levelName" placeholder="请选择产品级别"></el-input>
						<SearchOption :limit-info="{}" :get-data="listProductLevel" query-info="levelName" query-label="产品级别查找" :query-name="queryLevel" @update:queryName="handleProductLevelQuery" @commitBack="handleProductLevelSelect">
							<template #table-columns>
								<el-table-column label="级别编码" align="center" prop="levelNo" />
								<el-table-column label="产品级别" align="center" prop="levelName" />
							</template>
						</SearchOption>
					</el-row>
				</el-form-item>
				<el-form-item label="厚度" prop="height"><el-input v-model="queryParams.height" placeholder="请输入厚度"></el-input></el-form-item>
				<el-form-item label="长度" prop="length"><el-input v-model="queryParams.length" placeholder="请输入长度"></el-input></el-form-item>
				<el-form-item label="宽度" prop="width"><el-input v-model="queryParams.width" placeholder="请输入宽度"></el-input></el-form-item>
			</el-row>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
			<el-form-item>
				<el-button :disabled="selectedList.length === 0" type="success" size="mini" @click="submitSelectOrderDetail">选择所选货物</el-button>
			</el-form-item>
			<el-form-item>
				<el-button type="danger" size="mini" :disabled="selectedList.length === 0" @click="clearSelectedOrderDetails">清空已选</el-button>
			</el-form-item>
		</el-form>
		<el-table
			id="printBox"
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="filterSelectedList"
			ref="orderDetailTable"
			:row-key="row => String(row.id)"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			max-height="700"
			size="mini"
			@select="handleSelectionChange"
			@select-all="handleSelectionChange"
			@sort-change="handleSortChange"
		>
			<el-table-column type="selection" width="70" align="center" fixed="left" />
			<el-table-column label="id" align="center" prop="id" min-width="80" />
			<el-table-column label="订单日期" align="center" prop="orderDate" min-width="100" sortable="custom" :sort-orders="['descending', 'ascending']" />
			<el-table-column label="客户" align="center" prop="customer" min-width="120" />
			<el-table-column label="供应商" align="center" prop="supplier" min-width="150" />
			<el-table-column label="级别编码" align="center" prop="levelID" min-width="100" />
			<el-table-column label="级别名称" align="center" prop="levelName" min-width="150" />
			<el-table-column label="计量单位" align="center" prop="countingUnit" min-width="100" />
			<el-table-column label="厚度" align="center" prop="height" min-width="80" />
			<el-table-column label="长度" align="center" prop="length" min-width="80" />
			<el-table-column label="宽度" align="center" prop="width" min-width="80" />
			<el-table-column label="出厂片数" align="center" prop="pieces" min-width="90" />
			<el-table-column label="每包片数" align="center" prop="piecesPerPack" min-width="90" />
			<el-table-column label="包数" align="center" prop="packs" min-width="70" />
			<el-table-column label="出厂单价" align="center" prop="price" min-width="90" />
			<el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory">
				<template slot-scope="scope">
					<el-tag :type="boolTagType(scope.row.isIncludeTaxFactory)" disable-transitions>
						{{ boolTag(scope.row.isIncludeTaxFactory) }}
					</el-tag>
				</template>
			</el-table-column>
			<!-- 其他列保持类似 -->
			<el-table-column label="佣金" align="center" prop="customerCommission" min-width="90" />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="handleQuery" />
	</div>
</template>

<style scoped lang="scss">
// 表格滚动条样式
::v-deep .el-table__body-wrapper {
	&::-webkit-scrollbar {
		width: 12px;
		height: 22px;
		background-color: #0068ff;
	}

	&::-webkit-scrollbar-thumb {
		background-color: #f80606;
		border-radius: 2px;
		border: 2px solid #f2f6fc;

		&:hover {
			background-color: #fff30c;
		}
	}

	&::-webkit-scrollbar-track {
		background-color: rgba(0, 255, 70, 0.59);
		border-radius: 6px;
	}
}
</style>
