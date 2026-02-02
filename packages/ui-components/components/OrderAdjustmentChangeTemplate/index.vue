<script>
import { format, subtract, add, abs } from 'mathjs';
import _ from 'lodash';

export default {
	name: 'OrderAdjustmentChangeTemplate',
	props: {
		// 对比数据：包含修改前和修改后的数据
		compareData: {
			type: Array,
			default: () => []
		},
		// 模块名称
		moduleName: {
			type: String,
			default: ''
		}
	},
	data() {
		return {
			tableData: []
		};
	},
	computed: {
		/**
		 * 计算客户变动差额汇总
		 * @returns {string} 格式化后的汇总金额
		 */
		totalCustomerDiff() {
			return this.tableData
				.filter(item => item.rowType === 'diff')
				.reduce((sum, item) => {
					const value = Number(item.customerDiff || 0);
					return format(add(sum, abs(value)), { notation: 'fixed', precision: 2 });
				}, 0);
		},

		/**
		 * 计算供应商变动差额汇总
		 * @returns {string} 格式化后的汇总金额
		 */
		totalSupplierDiff() {
			return this.tableData
				.filter(item => item.rowType === 'diff')
				.reduce((sum, item) => {
					const value = Number(item.supplierDiff || 0);
					return format(add(sum, abs(value)), { notation: 'fixed', precision: 2 });
				}, 0);
		},

		/**
		 * 计算库存变动差额汇总
		 * @returns {string} 格式化后的汇总金额
		 */
		totalInventoryDiff() {
			return this.tableData
				.filter(item => item.rowType === 'diff')
				.reduce((sum, item) => {
					const value = Number(item.inventoryDiff || 0);
					return format(add(sum, abs(value)), { notation: 'fixed', precision: 2 });
				}, 0);
		},

		/**
		 * 计算运费变动差额汇总
		 * @returns {string} 格式化后的汇总金额
		 */
		totalFreightDiff() {
			return this.tableData
				.filter(item => item.rowType === 'diff')
				.reduce((sum, item) => {
					const value = Number(item.freightDiff || 0);
					return format(add(sum, abs(value)), { notation: 'fixed', precision: 2 });
				}, 0);
		}
	},
	created() {
		this.processData();
	},
	methods: {
		/**
		 * 处理数据：将 compareData 转换为表格展示格式
		 * 每个修改记录包含三行：修改前、修改后、差额
		 */
		processData() {
			const grouped = _.groupBy(this.compareData, 'recordId');
			this.tableData = [];

			Object.keys(grouped).forEach((recordId, index) => {
				const records = grouped[recordId];
				const beforeData = records.find(r => r.changeType === 'before') || {};
				const afterData = records.find(r => r.changeType === 'after') || {};

				// 修改前
				this.tableData.push({
					...beforeData,
					rowType: 'before',
					label: `订单调整单(${index + 1})`,
					subLabel: '修改前'
				});

				// 修改后
				this.tableData.push({
					...afterData,
					rowType: 'after',
					label: '',
					subLabel: '修改后'
				});

				// 差额（使用 mathjs 计算）
				this.tableData.push({
					rowType: 'diff',
					label: '',
					subLabel: '差额',
					customerDiff: this.calculateFieldDiff(afterData.customerAmount, beforeData.customerAmount),
					supplierDiff: this.calculateFieldDiff(afterData.supplierAmount, beforeData.supplierAmount),
					inventoryDiff: this.calculateFieldDiff(afterData.inventoryAmount, beforeData.inventoryAmount),
					freightDiff: this.calculateFieldDiff(afterData.freightAmount, beforeData.freightAmount)
				});
			});
		},

		/**
		 * 计算字段差额（使用 mathjs 保证高精度）
		 * @param {number|string} afterValue - 修改后的值
		 * @param {number|string} beforeValue - 修改前的值
		 * @returns {string} 格式化后的差额
		 */
		calculateFieldDiff(afterValue, beforeValue) {
			const after = Number(afterValue || 0);
			const before = Number(beforeValue || 0);
			return format(subtract(after, before), { notation: 'fixed', precision: 2 });
		},

		/**
		 * 行样式设置
		 * @param {Object} params - 包含 row 和 rowIndex 的对象
		 * @returns {string} CSS 类名
		 */
		tableRowClassName({ row }) {
			if (row.rowType === 'before') return 'before-row';
			if (row.rowType === 'after') return 'after-row';
			if (row.rowType === 'diff') return 'diff-row';
			return '';
		},

		/**
		 * 单元格样式设置
		 * @param {Object} params - 包含 row, column, rowIndex, columnIndex 的对象
		 * @returns {Object} 样式对象
		 */
		cellStyle({ row, column }) {
			if (row.rowType === 'diff' && column.property.includes('Diff')) {
				return { fontWeight: 'bold', color: '#f56c6c' };
			}
			return {};
		},

		handleProcess() {
			return Promise.resolve();
		},

		handleReject() {
			return Promise.resolve();
		}
	}
};
</script>

<template>
	<div class="order-adjustment-change-template">
		<el-table :data="tableData" border :row-class-name="tableRowClassName" :cell-style="cellStyle" style="width: 100%">
			<el-table-column label="" width="150" fixed>
				<template slot-scope="scope">
					<div v-if="scope.row.label">{{ scope.row.label }}</div>
					<div class="sub-label">{{ scope.row.subLabel }}</div>
				</template>
			</el-table-column>

			<el-table-column label="状态" prop="status" width="100" />
			<el-table-column label="订单日期" prop="orderDate" width="150" />
			<el-table-column label="客户" prop="customerName" width="150" />
			<el-table-column label="车牌" prop="truckPlate" width="120" />
			<el-table-column label="海运柜号" prop="containerNo" width="120" />
			<el-table-column label="海运公司" prop="shippingCompany" width="150" />
			<el-table-column label="供应商" prop="supplierName" width="150" />
			<el-table-column label="仓库名称" prop="warehouse" width="120" />
			<el-table-column label="级别名称" prop="gradeName" width="200" />
			<el-table-column label="计量单位" prop="unit" width="100" />
			<el-table-column label="厚度" prop="thickness" width="80" />
			<el-table-column label="长度" prop="length" width="80" />
			<el-table-column label="宽度" prop="width" width="80" />
			<el-table-column label="出厂片数" prop="factoryPieces" width="100" />
			<el-table-column label="每包片数" prop="piecesPerPack" width="100" />
			<el-table-column label="包数" prop="packCount" width="80" />
			<el-table-column label="出厂单价" prop="factoryPrice" width="100" />
			<el-table-column label="出厂是否含税" prop="includeTax" width="120" />
			<el-table-column label="杂费" prop="miscFee" width="100" />
			<el-table-column label="出厂货款" prop="factoryPayment" width="120" />
			<el-table-column label="卸货片数" prop="unloadPieces" width="100" />
			<el-table-column label="卸货价" prop="unloadPrice" width="100" />
			<el-table-column label="存货价" prop="stockPrice" width="100" />
			<el-table-column label="原出厂货款" prop="originalFactoryPayment" width="120" />
			<el-table-column label="原出厂货款(含税)" prop="originalFactoryPaymentTax" width="150" />
			<el-table-column label="原库存金额" prop="originalInventoryAmount" width="120" />
			<el-table-column label="原库存金额(含税)" prop="originalInventoryAmountTax" width="150" />
			<el-table-column label="原客户应收金额" prop="originalCustomerReceivable" width="140" />
			<el-table-column label="原客户应收金额(含税)" prop="originalCustomerReceivableTax" width="170" />
			<el-table-column label="原运费金额" prop="originalFreightAmount" width="120" />
			<el-table-column label="原运费金额(含税)" prop="originalFreightAmountTax" width="150" />
			<el-table-column label="客户变动差额" prop="customerDiff" width="120" />
			<el-table-column label="供应商变动差额" prop="supplierDiff" width="140" />
			<el-table-column label="库存变动差额" prop="inventoryDiff" width="120" />
			<el-table-column label="运费变动差额" prop="freightDiff" width="120" />
		</el-table>

		<div class="summary-section">
			<el-row :gutter="20">
				<el-col :span="6">
					<div class="summary-item">
						<span class="summary-label">客户变动差额汇总：</span>
						<span class="summary-value">{{ totalCustomerDiff }}</span>
					</div>
				</el-col>
				<el-col :span="6">
					<div class="summary-item">
						<span class="summary-label">供应商变动差额汇总：</span>
						<span class="summary-value">{{ totalSupplierDiff }}</span>
					</div>
				</el-col>
				<el-col :span="6">
					<div class="summary-item">
						<span class="summary-label">库存变动差额汇总：</span>
						<span class="summary-value">{{ totalInventoryDiff }}</span>
					</div>
				</el-col>
				<el-col :span="6">
					<div class="summary-item">
						<span class="summary-label">运费变动差额汇总：</span>
						<span class="summary-value">{{ totalFreightDiff }}</span>
					</div>
				</el-col>
			</el-row>
		</div>
	</div>
</template>

<style scoped lang="scss">
.order-adjustment-change-template {
	padding: 20px;
}

.sub-label {
	font-size: 12px;
	color: #666;
	margin-top: 4px;
}

// 修改前行样式
::v-deep .before-row {
	background-color: #f0f9ff;
}

// 修改后行样式
::v-deep .after-row {
	background-color: #fff7e6;
}

// 差额行样式
::v-deep .diff-row {
	background-color: #fff1f0;
	font-weight: bold;
}

.summary-section {
	margin-top: 20px;
	padding: 15px;
	background: #f5f5f5;
	border-radius: 4px;
}

.summary-item {
	text-align: center;

	.summary-label {
		font-size: 14px;
		color: #666;
	}

	.summary-value {
		font-size: 18px;
		font-weight: bold;
		color: #f56c6c;
		margin-left: 10px;
	}
}
</style>
