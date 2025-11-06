<template>
	<div class="virtual-list-item table-row-simulate">
		<table class="table-row">
			<thead v-if="shouldShowHeader" class="table-header">
				<tr>
					<th class="fixed-left col-actions text-center resizable" :data-col="'col-actions'">
						操作
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-actions')"></span>
					</th>
					<th class="col-id text-center resizable" :data-col="'col-id'">
						ID
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-id')"></span>
					</th>
					<th class="col-date text-center resizable" :data-col="'col-date'">
						日期
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-date')"></span>
					</th>
					<th class="col-customer text-center resizable" :data-col="'col-customer'">
						客户
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-customer')"></span>
					</th>
					<th class="col-supplier-warehouse text-center resizable" :data-col="'col-supplier-warehouse'">
						供应商/仓库
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-supplier-warehouse')"></span>
					</th>
					<th class="col-check-state text-center resizable" :data-col="'col-check-state'">
						审核状态
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-check-state')"></span>
					</th>
					<th class="col-fleet text-center resizable" :data-col="'col-fleet'">
						车队
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-fleet')"></span>
					</th>
					<th class="col-car-no text-center resizable" :data-col="'col-car-no'">
						陆运车牌
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-car-no')"></span>
					</th>
					<th class="col-payment text-center resizable" :data-col="'col-payment'">
						总货款
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-payment')"></span>
					</th>
					<th class="col-tonnage text-center resizable" :data-col="'col-tonnage'">
						总吨位
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-tonnage')"></span>
					</th>
					<th class="col-profit text-center resizable" :data-col="'col-profit'">
						总利润(含税)
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-profit')"></span>
					</th>
					<th class="col-sale-manager text-center resizable" :data-col="'col-sale-manager'">
						销售经理
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-sale-manager')"></span>
					</th>
					<th class="col-user text-center resizable" :data-col="'col-user'">
						录入员
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-user')"></span>
					</th>
					<th class="col-remark text-center resizable" :data-col="'col-remark'">
						备注
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-remark')"></span>
					</th>
					<th class="col-edit text-center resizable" :data-col="'col-edit'">
						是否可编辑
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-edit')"></span>
					</th>
					<th class="col-customer-tax text-center resizable" :data-col="'col-customer-tax'">
						客户是否含税
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-customer-tax')"></span>
					</th>
					<th class="col-supplier-tax text-center resizable" :data-col="'col-supplier-tax'">
						供应商是否开票
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-supplier-tax')"></span>
					</th>
					<th class="fixed-right col-order-actions text-center resizable" :data-col="'col-order-actions'">
						订单操作
						<span class="resize-handle" @mousedown.prevent="startResize($event, 'col-order-actions')"></span>
					</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<!-- 行操作列 -->
					<td class="fixed-left col-actions">
						<div class="row-actions">
							<el-button size="mini" type="text" @click="handleView">
								<span v-once>查看</span>
							</el-button>
							<el-dropdown size="mini" @command="command => handleCommand(command)">
								<el-button size="mini" type="text">
									<span v-once>操作</span>
								</el-button>
								<el-dropdown-menu slot="dropdown">
									<el-dropdown-item command="handleUpdate">
										<el-button size="mini" type="primary">修 改</el-button>
									</el-dropdown-item>
									<el-dropdown-item command="handleDelete">
										<el-button size="mini" type="danger">删 除</el-button>
									</el-dropdown-item>
								</el-dropdown-menu>
							</el-dropdown>
							<el-dropdown size="mini">
								<el-button size="mini" type="text">
									<span v-once>修改记录</span>
								</el-button>
								<el-dropdown-menu slot="dropdown">
									<el-dropdown-item>
										<span v-once>查看历史</span>
									</el-dropdown-item>
								</el-dropdown-menu>
							</el-dropdown>
						</div>
					</td>

					<!-- ID -->
					<td class="text-center col-id">
						<div class="cell-content">{{ source.id || index + 1 }}</div>
					</td>

					<!-- 日期 -->
					<td class="text-center col-date">
						<div class="cell-content">{{ source.orderDate || formatDate() }}</div>
					</td>

					<!-- 客户 -->
					<td class="text-center col-customer">
						<div class="cell-content">{{ source.customer || '客户' + (index + 1) }}</div>
					</td>

					<!-- 供应商/仓库 -->
					<td class="text-center col-supplier-warehouse">
						<div class="supplier-warehouse-container">
							<span v-for="(supplier, idx) in source.suppliers" :key="`supplier-${idx}`" class="supplier-name" @click="handleSupplierClick(supplier)">
								{{ supplier }}
							</span>
							<span v-for="(warehouse, idx) in source.warehouses" :key="`warehouse-${idx}`" class="warehouse-name">
								{{ warehouse }}
							</span>
							<span v-if="(!source.suppliers || source.suppliers.length === 0) && (!source.warehouses || source.warehouses.length === 0)" class="empty-item">-</span>
						</div>
					</td>

					<!-- 审核状态 -->
					<td class="text-center col-check-state">
						<div class="cell-content">
							<StateTag v-if="source.checkState === '已审核'" :state-title="source.checkState" :state-mapper="{ 2: '已审核' }" />
							<el-button v-else type="text" size="mini" @click="handleCheck">审核</el-button>
						</div>
					</td>

					<!-- 车队 -->
					<td class="text-center col-fleet">
						<div class="cell-content">{{ source.fleet || '车队' + ((index % 5) + 1) }}</div>
					</td>

					<!-- 陆运车牌 -->
					<td class="text-center col-car-no">
						<div class="cell-content">{{ source.landCarNo || 'A' + String(index + 1000).slice(-4) }}</div>
					</td>

					<!-- 总货款 -->
					<td class="text-center col-payment">
						<div class="cell-content amount">{{ formatAmount(source.allPayments || (index + 1) * 10000) }}</div>
					</td>

					<!-- 总吨位 -->
					<td class="text-center col-tonnage">
						<div class="cell-content amount">{{ formatAmount(source.allTonnage || (index + 1) * 10.5) }}</div>
					</td>

					<!-- 总利润(含税) -->
					<td class="text-center col-profit">
						<div class="cell-content amount profit">{{ formatAmount(source.allProfit || (index + 1) * 2000) }}</div>
					</td>

					<!-- 销售经理 -->
					<td class="text-center col-sale-manager">
						<div class="cell-content">{{ source.saleManager || '经理' + ((index % 3) + 1) }}</div>
					</td>

					<!-- 录入员 -->
					<td class="text-center col-user">
						<div class="cell-content">{{ source.userName || '用户' + ((index % 2) + 1) }}</div>
					</td>

					<!-- 备注 -->
					<td class="text-center col-remark">
						<div class="cell-content remark">{{ source.comments || '测试备注信息' }}</div>
					</td>

					<!-- 是否可编辑 -->
					<td class="text-center col-edit">
						<div class="cell-content">
							<StateTag :state-title="source.isedit === 0 ? '否' : '是'" :state-mapper="{ 0: '否', 2: '是' }" />
						</div>
					</td>

					<!-- 客户是否含税 -->
					<td class="text-center col-customer-tax">
						<div class="cell-content">
							<el-button v-if="source.customerTaxIncluded" type="text" size="mini" @click="handleCustomerInvoice">是</el-button>
							<StateTag v-else :state-title="'否'" :state-mapper="{ 3: '否' }" />
						</div>
					</td>

					<!-- 供应商是否开票 -->
					<td class="text-center col-supplier-tax">
						<div class="cell-content">
							<el-button v-if="source.supplierInvoice" type="text" size="mini" @click="handleSupplierInvoice">是</el-button>
							<StateTag v-else :state-title="'否'" :state-mapper="{ 3: '否' }" />
						</div>
					</td>

					<!-- 订单操作 -->
					<td class="fixed-right col-order-actions">
						<div class="order-actions">
							<el-button size="mini" type="text" @click="handleAdjustOrder">调整单</el-button>
							<el-button size="mini" type="text" @click="handleOrder1">发货单1</el-button>
							<el-dropdown size="mini" type="text" trigger="click">
								<el-button type="text" size="mini">
									<span v-once>发货单</span>
									<i class="el-icon-arrow-down el-icon--right" />
								</el-button>
								<el-dropdown-menu slot="dropdown">
									<el-dropdown-item>
										<el-button size="mini" type="text" @click="handleOrder2">发货单2</el-button>
									</el-dropdown-item>
									<el-dropdown-item>
										<el-button size="mini" type="text" @click="handleOrder3">发货单3</el-button>
									</el-dropdown-item>
								</el-dropdown-menu>
							</el-dropdown>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</template>

<script>
import StateTag from '@/views/dashboard/components/common/StateTag.vue';

export default {
	name: 'item-component',
	components: {
		StateTag
	},
	props: {
		index: {
			type: Number
		},
		source: {
			type: Object,
			default() {
				return {};
			}
		},
		showHeader: {
			type: Boolean,
			default: false
		}
	},
	data() {
		return {
			// 列宽配置
			columnWidths: {},
			// 拖拽状态
			isResizing: false,
			resizingColumn: null,
			startX: 0,
			startWidth: 0
		};
	},
	computed: {
		shouldShowHeader() {
			// 如果显式指定了 showHeader，使用它；否则第一个项显示表头
			return this.showHeader || this.index === 0;
		}
	},
	watch: {
		// 监听列宽配置变化（从父组件或 localStorage 更新）
		columnWidths: {
			handler() {
				this.$nextTick(() => {
					this.applyColumnWidths();
				});
			},
			deep: true
		}
	},
	created() {
		// 从 localStorage 加载列宽配置
		this.loadColumnWidths();
	},
	mounted() {
		// 应用列宽配置
		this.$nextTick(() => {
			this.applyColumnWidths();
		});
		// 绑定全局事件
		document.addEventListener('mousemove', this.handleMouseMove);
		document.addEventListener('mouseup', this.handleMouseUp);
	},
	beforeDestroy() {
		// 移除全局事件
		document.removeEventListener('mousemove', this.handleMouseMove);
		document.removeEventListener('mouseup', this.handleMouseUp);
	},
	methods: {
		// 加载列宽配置
		loadColumnWidths() {
			try {
				const saved = localStorage.getItem('testing-table-column-widths');
				if (saved) {
					this.columnWidths = JSON.parse(saved);
				}
			} catch (error) {
				console.warn('加载列宽配置失败:', error);
			}
		},
		// 保存列宽配置
		saveColumnWidths() {
			try {
				localStorage.setItem('testing-table-column-widths', JSON.stringify(this.columnWidths));
			} catch (error) {
				console.warn('保存列宽配置失败:', error);
			}
		},
		// 应用列宽配置
		applyColumnWidths() {
			const table = this.$el.querySelector('.table-row');
			if (!table) return;

			// 确保表格使用固定布局
			table.style.tableLayout = 'fixed';

			// 应用所有已保存的列宽配置
			Object.keys(this.columnWidths).forEach(columnClass => {
				const width = this.columnWidths[columnClass];
				this.updateAllColumnsWidth(columnClass, width);
			});
		},
		// 开始拖拽
		startResize(event, columnClass) {
			if (!this.shouldShowHeader) return;

			this.isResizing = true;
			this.resizingColumn = columnClass;
			this.startX = event.clientX;

			const table = this.$el.querySelector('.table-row');
			if (!table) return;

			const th = table.querySelector(`th[data-col="${columnClass}"]`);
			if (th) {
				this.startWidth = th.offsetWidth;
			}

			// 添加全局样式
			document.body.style.cursor = 'col-resize';
			document.body.style.userSelect = 'none';
		},
		// 处理鼠标移动
		handleMouseMove(event) {
			if (!this.isResizing || !this.resizingColumn) return;

			const diff = event.clientX - this.startX;
			const newWidth = Math.max(50, this.startWidth + diff); // 最小宽度50px

			// 更新页面上所有表格的相同列（包括所有 Item 组件实例）
			this.updateAllColumnsWidth(this.resizingColumn, newWidth);

			// 更新配置
			this.columnWidths[this.resizingColumn] = newWidth;
		},
		// 更新所有表格中指定列的宽度
		updateAllColumnsWidth(columnClass, width) {
			// 查找页面上所有的表格（包括虚拟列表中的其他 Item 组件）
			const allTables = document.querySelectorAll('.table-row');

			allTables.forEach(table => {
				// 更新表头 th
				const th = table.querySelector(`th[data-col="${columnClass}"]`);
				if (th) {
					th.style.width = `${width}px`;
					th.style.minWidth = `${width}px`;
					th.style.maxWidth = `${width}px`;
				}

				// 更新数据行 td
				const tbody = table.querySelector('tbody');
				if (tbody) {
					// 先尝试通过表头找到列索引（最可靠的方法）
					const headerRow = table.querySelector('thead tr');
					let columnIndex = -1;

					if (headerRow) {
						const headers = Array.from(headerRow.querySelectorAll('th[data-col]'));
						columnIndex = headers.findIndex(th => th.getAttribute('data-col') === columnClass);
					}

					// 如果找到了列索引，使用索引更新（最准确）
					if (columnIndex >= 0) {
						const rows = tbody.querySelectorAll('tr');
						rows.forEach(row => {
							const cells = row.querySelectorAll('td');
							if (cells[columnIndex]) {
								cells[columnIndex].style.width = `${width}px`;
								cells[columnIndex].style.minWidth = `${width}px`;
								cells[columnIndex].style.maxWidth = `${width}px`;
							}
						});
					} else {
						// 如果没有表头，通过 class 选择器更新（适用于没有表头的 Item）
						const cellsByClass = tbody.querySelectorAll(`td.${columnClass}`);
						cellsByClass.forEach(td => {
							td.style.width = `${width}px`;
							td.style.minWidth = `${width}px`;
							td.style.maxWidth = `${width}px`;
						});
					}
				}
			});
		},
		// 处理鼠标抬起
		handleMouseUp() {
			if (this.isResizing) {
				this.isResizing = false;
				// 保存配置
				this.saveColumnWidths();
				// 通知父组件更新（如果第一个 Item 调整了列宽，需要同步到其他 Item）
				this.$emit('column-width-changed', this.columnWidths);
				this.resizingColumn = null;

				// 恢复全局样式
				document.body.style.cursor = '';
				document.body.style.userSelect = '';
			}
		},
		formatDate() {
			const date = new Date();
			date.setDate(date.getDate() - this.index);
			const year = date.getFullYear();
			const month = String(date.getMonth() + 1).padStart(2, '0');
			const day = String(date.getDate()).padStart(2, '0');
			return `${year}-${month}-${day}`;
		},
		formatAmount(value) {
			if (typeof value === 'number') {
				return value.toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
			}
			return value;
		},
		handleView() {
			console.log('查看', this.source.uid || this.source.id);
		},
		handleCommand(command) {
			if (command === 'handleUpdate') {
				this.handleEdit();
			} else if (command === 'handleDelete') {
				this.handleDelete();
			}
		},
		handleEdit() {
			console.log('编辑', this.source.uid || this.source.id);
		},
		handleDelete() {
			console.log('删除', this.source.uid || this.source.id);
		},
		handleCheck() {
			console.log('审核', this.source.uid || this.source.id);
		},
		handleSupplierClick(supplier) {
			console.log('供应商点击', supplier);
		},
		handleCustomerInvoice() {
			console.log('客户开票', this.source.uid || this.source.id);
		},
		handleSupplierInvoice() {
			console.log('供应商开票', this.source.uid || this.source.id);
		},
		handleAdjustOrder() {
			console.log('调整单', this.source.uid || this.source.id);
		},
		handleOrder1() {
			console.log('发货单1', this.source.uid || this.source.id);
		},
		handleOrder2() {
			console.log('发货单2', this.source.uid || this.source.id);
		},
		handleOrder3() {
			console.log('发货单3', this.source.uid || this.source.id);
		}
	}
};
</script>

<style lang="scss" scoped>
// ==================== 样式变量 ====================
// 字体大小
$table-header-font-size: 15px; // 表头字体大小
$table-cell-font-size: 14px; // 单元格字体大小
$table-button-font-size: 13px; // 按钮字体大小
$table-link-font-size: 14px; // 链接文字字体大小（供应商、仓库等）

// 行高和高度
$table-header-height: 42px; // 表头行高
$table-row-height: 32px; // 数据行高
$table-row-min-height: 32px; // 最小行高
$table-cell-line-height: 22px; // 单元格行高

// 内边距
$table-header-padding-vertical: 10px; // 表头垂直内边距
$table-header-padding-horizontal: 6px; // 表头水平内边距
$table-cell-padding: 6px; // 单元格内边距
$table-button-padding: 4px; // 按钮内边距
$table-gap: 6px; // 元素间距

// 边框
$table-border-color: #ebeef5; // 普通边框颜色
$table-border-color-strong: #dcdfe6; // 强调边框颜色（固定列）
$table-border-width: 1px; // 普通边框宽度
$table-border-width-strong: 2px; // 强调边框宽度

// 颜色
$table-header-bg: #f5f7fa; // 表头背景色
$table-row-bg: #fff; // 行背景色
$table-row-bg-stripe: #fafafa; // 斑马纹背景色
$table-row-bg-hover: #f5f7fa; // 悬停背景色
$table-header-text-color: #303133; // 表头文字颜色
$table-cell-text-color: #606266; // 单元格文字颜色
$table-link-color: #409eff; // 链接颜色（供应商）
$table-link-hover-color: #df6565; // 链接悬停颜色
$table-warehouse-color: #67c23a; // 仓库颜色
$table-amount-color: #e6a23c; // 金额颜色
$table-profit-color: #67c23a; // 利润颜色
$table-empty-color: #909399; // 空值颜色

// 阴影
$table-fixed-shadow: 0 0 6px rgba(0, 0, 0, 0.1); // 固定列阴影
$table-fixed-shadow-left: 2px 0 6px rgba(0, 0, 0, 0.1); // 固定列左侧阴影
$table-fixed-shadow-right: -2px 0 6px rgba(0, 0, 0, 0.1); // 固定列右侧阴影

// Z-index
$table-header-z-index: 100; // 表头层级
$table-fixed-z-index: 101; // 固定列表头层级
$table-fixed-cell-z-index: 10; // 固定列单元格层级

// ==================== 样式定义 ====================
.virtual-list-item {
	padding: 0;
	border-bottom: $table-border-width solid $table-border-color;
	transition: background-color 0.2s;
	min-height: $table-row-min-height;

	&:hover {
		background-color: $table-row-bg-hover;
	}

	.table-row {
		width: 100%;
		border-collapse: collapse;
		table-layout: fixed;
		border-spacing: 0;

		thead.table-header {
			background-color: $table-header-bg;
			position: sticky;
			top: 0;
			z-index: $table-header-z-index;

			tr {
				height: $table-header-height;
				border-bottom: $table-border-width-strong solid $table-border-color-strong;
			}

			th {
				padding: $table-header-padding-vertical $table-header-padding-horizontal;
				vertical-align: middle;
				text-align: center;
				font-size: $table-header-font-size;
				font-weight: 600;
				color: $table-header-text-color;
				background-color: $table-header-bg;
				border-right: $table-border-width solid $table-border-color;
				white-space: nowrap;
				overflow: hidden;
				text-overflow: ellipsis;
				position: relative;

				&.resizable {
					user-select: none;
				}

				.resize-handle {
					position: absolute;
					top: 0;
					right: -4px;
					width: 8px;
					height: 100%;
					cursor: col-resize;
					z-index: 1;
					background: transparent;
					transition: background-color 0.2s;

					&:hover {
						background-color: rgba(64, 158, 255, 0.2);
					}

					&::after {
						content: '';
						position: absolute;
						right: 3px;
						top: 50%;
						transform: translateY(-50%);
						width: 2px;
						height: 60%;
						background-color: #c0c4cc;
						opacity: 0;
						transition: opacity 0.2s;
					}

					&:hover::after {
						opacity: 1;
					}
				}

				&.fixed-left {
					position: sticky;
					left: 0;
					z-index: $table-fixed-z-index;
					background-color: $table-header-bg;
					border-right: $table-border-width-strong solid $table-border-color-strong;
					box-shadow: $table-fixed-shadow-left;

					.resize-handle {
						right: -6px;
					}
				}

				&.fixed-right {
					position: sticky;
					right: 0;
					z-index: $table-fixed-z-index;
					background-color: $table-header-bg;
					border-left: $table-border-width-strong solid $table-border-color-strong;
					box-shadow: $table-fixed-shadow-right;

					.resize-handle {
						right: -4px;
					}
				}

				&:last-child {
					border-right: none;
				}
			}
		}

		tbody tr {
			height: $table-row-height;
			line-height: $table-row-height;
		}

		td {
			padding: $table-cell-padding;
			vertical-align: middle;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
			height: $table-row-height;
			line-height: $table-cell-line-height;
			border-right: $table-border-width solid $table-border-color;

			&:last-child {
				border-right: none;
			}
		}

		// 列宽度设置（基于原来的 span 比例，同时应用于 th 和 td）
		th,
		td {
			&.col-actions {
				width: 6.7%; // 2/29.8
			}

			&.col-id {
				width: 3.4%; // 1/29.8
			}

			&.col-date {
				width: 5%; // 1.5/29.8
			}

			&.col-customer {
				width: 5%; // 1.5/29.8
			}

			&.col-supplier-warehouse {
				width: 8.4%; // 2.5/29.8
			}

			&.col-check-state {
				width: 5%; // 1.5/29.8
			}

			&.col-fleet {
				width: 4%; // 1.2/29.8
			}

			&.col-car-no {
				width: 4%; // 1.2/29.8
			}

			&.col-payment {
				width: 5%; // 1.5/29.8
			}

			&.col-tonnage {
				width: 5%; // 1.5/29.8
			}

			&.col-profit {
				width: 5%; // 1.5/29.8
			}

			&.col-sale-manager {
				width: 4%; // 1.2/29.8
			}

			&.col-user {
				width: 4%; // 1.2/29.8
			}

			&.col-remark {
				width: 6.7%; // 2/29.8
			}

			&.col-edit {
				width: 4%; // 1.2/29.8
			}

			&.col-customer-tax {
				width: 5%; // 1.5/29.8
			}

			&.col-supplier-tax {
				width: 5%; // 1.5/29.8
			}

			&.col-order-actions {
				width: 8.4%; // 2.5/29.8
			}
		}

		.text-center {
			text-align: center;
		}

		.cell-content {
			width: 100%;
			text-align: center;
			font-size: $table-cell-font-size;
			color: $table-cell-text-color;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;

			&.amount {
				color: $table-amount-color;
				font-weight: 500;

				&.profit {
					color: $table-profit-color;
				}
			}

			&.remark {
				max-width: 100%;
				overflow: hidden;
				text-overflow: ellipsis;
				white-space: nowrap;
			}
		}

		td.fixed-left {
			position: sticky;
			left: 0;
			background: inherit;
			z-index: $table-fixed-cell-z-index;
			border-right: $table-border-width-strong solid $table-border-color-strong;
			box-shadow: $table-fixed-shadow-left;

			&:hover {
				background: $table-row-bg-hover !important;
			}
		}

		td.fixed-right {
			position: sticky;
			right: 0;
			background: inherit;
			z-index: $table-fixed-cell-z-index;
			border-left: $table-border-width-strong solid $table-border-color-strong;
			box-shadow: $table-fixed-shadow-right;

			&:hover {
				background: $table-row-bg-hover !important;
			}
		}

		.row-actions {
			display: flex;
			align-items: center;
			justify-content: center;
			gap: $table-gap;
			flex-wrap: wrap;

			.el-button {
				padding: 0 $table-button-padding;
				margin: 0;
				font-size: $table-button-font-size;
			}
		}

		.order-actions {
			display: flex;
			align-items: center;
			justify-content: center;
			gap: $table-gap;
			flex-wrap: wrap;

			.el-button {
				padding: 0 $table-button-padding;
				margin: 0;
				font-size: $table-button-font-size;
			}
		}

		// 供应商和仓库的容器
		.supplier-warehouse-container {
			display: inline-flex;
			align-items: center;
			justify-content: flex-start;
			flex-wrap: nowrap;
			gap: $table-gap;
			max-width: 100%;
			overflow: hidden;
			line-height: 1.2;

			.supplier-name {
				color: $table-link-color;
				cursor: pointer;
				display: inline-block;
				margin-right: $table-gap;
				white-space: nowrap;
				font-weight: 500;
				font-size: $table-link-font-size;

				&:hover {
					color: $table-link-hover-color;
					font-weight: bold;
				}

				&:not(:last-of-type)::after {
					content: ',';
					margin-right: $table-gap;
					color: $table-empty-color;
				}
			}

			.warehouse-name {
				color: $table-warehouse-color;
				display: inline-block;
				margin-right: $table-gap;
				white-space: nowrap;
				font-weight: 500;
				font-size: $table-link-font-size;

				&:not(:last-of-type)::after {
					content: ',';
					margin-right: $table-gap;
					color: $table-empty-color;
				}
			}

			.empty-item {
				color: $table-empty-color;
				display: inline-block;
				font-style: italic;
				font-size: $table-cell-font-size;
			}
		}
	}
}

// 表格行样式模拟
.table-row-simulate {
	background: $table-row-bg;

	&:nth-child(even) tbody tr {
		background: $table-row-bg-stripe;
	}

	&:hover tbody tr {
		background: $table-row-bg-hover !important;
	}

	// 确保表头行不受斑马纹影响
	thead.table-header {
		background-color: $table-header-bg !important;

		tr {
			background-color: $table-header-bg !important;
		}
	}
}
</style>
