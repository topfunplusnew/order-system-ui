<template>
	<div class="order-table-container">
		<!-- 搜索模块 -->
		<QuerySearchBar @updateQuery="handleGetQueryParams" :is-adjust="isAdjustOrder" />
		<br />

		<!-- 订单修改记录查看 -->
		<OrderHistoryCheck
			:check-history-order-visible="checkHistoryOrderVisible"
			:order-history-info-list="orderHistoryInfoList"
			:current-info="currentOrderItemInfo"
			@close="closeOrderHistoryCheck"
		/>

		<!-- 右侧工具栏 -->
		<div class="toolbar-wrapper">
			<right-toolbar :columns="columns" @queryTable="getList">
				<!-- 左侧新增订单按钮 -->
				<template #left>
					<div class="toolbar-left">
						<el-row :gutter="10" class="mb8">
							<el-col v-if="!isAdjustOrder" :span="1.5">
								<el-button type="danger" size="mini" @click="handleAdd" :disabled="!hasPermission(['admin', 'orderManager'])">添加订单信息</el-button>
							</el-col>
						</el-row>
					</div>
				</template>

				<!-- 打印按钮 -->
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" :disabled="goodsOrderList.length === 0" />
					</el-col>
				</template>

				<!-- 导出按钮 -->
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport" :disabled="goodsOrderList.length === 0">导出订单目录</el-button>
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExportNoPage" :disabled="goodsOrderList.length === 0">导出全部订单</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</div>

		<!-- 订单表格 -->
		<div class="table-container" v-loading="loading">
			<!-- 渲染进度提示 -->
			<div v-if="isRendering" class="rendering-progress">
				<el-progress :percentage="renderProgress" :status="renderProgress === 100 ? 'success' : null" :stroke-width="6"></el-progress>
				<span class="progress-text">正在渲染数据: {{ renderedData.length }} / {{ paginatedData.length }}</span>
			</div>

			<div class="table-wrapper" id="printBox">
				<table class="native-table">
					<thead>
						<tr>
							<!-- 行操作 -->
							<th class="fixed-left col-row-action" :style="{ width: columnWidths.rowAction }">行操作</th>
							<!-- ID -->
							<th v-if="columns[0].visible" class="fixed-left col-id" :style="{ width: columnWidths.id }">ID</th>
							<!-- 日期 -->
							<th v-if="columns[1].visible" class="fixed-left col-date" :style="{ width: columnWidths.date }">日期</th>
							<!-- 客户 -->
							<th v-if="columns[2].visible" class="fixed-left col-customer" :style="{ width: columnWidths.customer }">客户</th>
							<!-- 供应商/仓库 -->
							<th v-if="columns[3].visible" class="fixed-left col-supplier" :style="{ width: columnWidths.supplier }">供应商/仓库</th>
							<!-- 陆运车牌 -->
							<th v-if="columns[4].visible" class="fixed-left col-land-car" :style="{ width: columnWidths.landCar }">陆运车牌</th>
							<!-- 审核状态 -->
							<th v-if="columns[5].visible" :style="{ width: columnWidths.checkState }">审核状态</th>
							<!-- 车队 -->
							<th v-if="columns[6].visible" :style="{ width: columnWidths.fleet }">车队</th>
							<!-- 陆运司机电话 -->
							<th v-if="columns[7].visible" :style="{ width: columnWidths.landDriverTel }">陆运司机电话</th>
							<!-- 陆地司机姓名 -->
							<th v-if="columns[8].visible" :style="{ width: columnWidths.landDriverName }">陆地司机姓名</th>
							<!-- 海运柜号 -->
							<th v-if="columns[9].visible" :style="{ width: columnWidths.seaCarNo }">海运柜号</th>
							<!-- 海运司机电话 -->
							<th v-if="columns[10].visible" :style="{ width: columnWidths.seaDriverTel }">海运司机电话</th>
							<!-- 海运公司 -->
							<th v-if="columns[11].visible" :style="{ width: columnWidths.seaDriverName }">海运公司</th>
							<!-- 总货款 -->
							<th v-if="columns[12].visible" :style="{ width: columnWidths.allPayments }">总货款</th>
							<!-- 总吨位 -->
							<th v-if="columns[13].visible" :style="{ width: columnWidths.allTonnage }">总吨位</th>
							<!-- 陆运费 -->
							<th v-if="columns[14].visible" :style="{ width: columnWidths.landFreight }">陆运费</th>
							<!-- 海运费 -->
							<th v-if="columns[15].visible" :style="{ width: columnWidths.seaFreight }">海运费</th>
							<!-- 总利润(含税) -->
							<th v-if="columns[16].visible" :style="{ width: columnWidths.allProfit }">总利润(含税)</th>
							<!-- 总利润(不含税) -->
							<th v-if="columns[17].visible" :style="{ width: columnWidths.allProfitNoTax }">总利润(不含税)</th>
							<!-- 销售经理 -->
							<th v-if="columns[18].visible" :style="{ width: columnWidths.saleManager }">销售经理</th>
							<!-- 录入员 -->
							<th v-if="columns[19].visible" :style="{ width: columnWidths.userName }">录入员</th>
							<!-- 备注 -->
							<th v-if="columns[20].visible" :style="{ width: columnWidths.comments }">备注</th>
							<!-- 附件 -->
							<th v-if="columns[21].visible" :style="{ width: columnWidths.attachment }">附件</th>
							<!-- 收到条附件 -->
							<th v-if="columns[22].visible" :style="{ width: columnWidths.receiveProof }">收到条附件</th>
							<!-- 是否可编辑 -->
							<th v-if="columns[23].visible" :style="{ width: columnWidths.isedit }">是否可编辑</th>
							<!-- 客户是否含税 -->
							<th v-if="columns[24].visible" :style="{ width: columnWidths.customerTax }">客户是否含税</th>
							<!-- 供应商是否开票 -->
							<th v-if="columns[25].visible" :style="{ width: columnWidths.supplierInvoice }">供应商是否开票</th>
							<!-- 右侧操作栏 -->
							<th class="fixed-right col-order-action" :style="{ width: columnWidths.orderAction }">订单操作</th>
						</tr>
					</thead>
					<tbody>
						<tr v-for="(row, index) in renderedData" :key="row.id" :style="getRowStyle(row)" :class="{ 'stripe-row': index % 2 === 1 }">
							<!-- 行操作 -->
							<td class="fixed-left col-row-action">
								<el-button size="mini" type="text" @click="checkOrderItemInfo(row)">查看</el-button>

								<el-dropdown size="mini" @command="command => handleCommand(command, row)">
									<el-button size="mini" type="text">操作</el-button>
									<el-dropdown-menu slot="dropdown">
										<el-dropdown-item command="handleUpdate">
											<el-button
												size="mini"
												type="primary"
												:disabled="!row.isedit || row.isAdjust < 0 || isOrderExpired(row.addtime)"
												:title="isOrderExpired(row.addtime) ? '订单已超过7天，无法修改' : ''"
											>
												修改
											</el-button>
										</el-dropdown-item>
										<el-dropdown-item command="handleDelete">
											<el-button size="mini" type="danger" :disabled="!hasPermission(['admin'])">删除</el-button>
										</el-dropdown-item>
									</el-dropdown-menu>
								</el-dropdown>

								<el-dropdown size="mini" :disabled="row.historyCount === 0">
									<el-button size="mini" type="text" :disabled="row.historyCount === 0">修改记录</el-button>
									<el-dropdown-menu slot="dropdown" v-if="row.historyCount > 0">
										<el-dropdown-item>
											<HistoryList :row="row" />
										</el-dropdown-item>
									</el-dropdown-menu>
								</el-dropdown>
							</td>

							<!-- 数据列 -->
							<td v-if="columns[0].visible" class="fixed-left col-id">{{ row.id }}</td>
							<td v-if="columns[1].visible" class="fixed-left col-date">{{ parseTime(row.orderDate, '{y}-{m}-{d}') }}</td>
							<td v-if="columns[2].visible" class="fixed-left col-customer">{{ row.customer }}</td>

							<td v-if="columns[3].visible" class="fixed-left col-supplier">
								<ExpandCursor>
									<div class="supplier-warehouse-container">
										<span v-if="row._uniqueSuppliers.length === 0 && row._uniqueWarehouses.length === 0" class="empty-item">-</span>
										<span v-else>
											<span
												v-for="supplier in row._uniqueSuppliers"
												:key="`supplier-${supplier.supplierID}`"
												class="supplier-name"
												@click="hasPermission(['finance']) && updateOrderItemVisibleSupplierInvoice(row, supplier.supplierID)"
											>
												{{ supplier.supplier }}
											</span>
											<span v-for="warehouse in row._uniqueWarehouses" :key="`warehouse-${warehouse.storeHouseID}`" class="warehouse-name">
												{{ warehouse.storeHouseName }}
											</span>
										</span>
									</div>
								</ExpandCursor>
							</td>

							<td v-if="columns[4].visible" class="fixed-left col-land-car">{{ row.landCarNo }}</td>

							<td v-if="columns[5].visible">
								<div v-if="row.checkState === '已审核'">
									<StateTag
										:state-title="row.checkState"
										:state-mapper="{ 2: '已审核' }"
										@click.native="hasPermission(['finance', 'admin']) && handleReCheck(row)"
										:style="{ cursor: hasPermission(['finance', 'admin']) ? 'pointer' : 'default' }"
									/>
								</div>
								<div v-else>
									<el-button v-if="hasPermission(['finance', 'admin'])" type="text" size="mini" @click="handleCheck(row)">审核</el-button>
									<span v-else class="pending-text">待审核</span>
								</div>
							</td>

							<td v-if="columns[6].visible">{{ row.fleet }}</td>
							<td v-if="columns[7].visible">{{ row.landDriverTel }}</td>
							<td v-if="columns[8].visible">{{ row.landDriverName }}</td>
							<td v-if="columns[9].visible">{{ row.seaCarNo || '无' }}</td>
							<td v-if="columns[10].visible">{{ row.seaDriverTel || '无' }}</td>
							<td v-if="columns[11].visible">{{ row.seaDriverName || '无' }}</td>
							<td v-if="columns[12].visible">{{ formatCurrency(row.allPayments) }}</td>
							<td v-if="columns[13].visible">{{ formatNumber(row.allTonnage) }}</td>
							<td v-if="columns[14].visible">{{ formatCurrency(row.landFreight) }}</td>
							<td v-if="columns[15].visible">{{ formatCurrency(row.seaFreight) }}</td>
							<td v-if="columns[16].visible">{{ formatCurrency(row.allProfit) }}</td>
							<td v-if="columns[17].visible">{{ formatCurrency(row.allProfitNoTax) }}</td>
							<td v-if="columns[18].visible">{{ row.saleManager }}</td>
							<td v-if="columns[19].visible">{{ row.userName }}</td>
							<td v-if="columns[20].visible" class="text-ellipsis">{{ row.comments }}</td>

							<td v-if="columns[21].visible">
								<div v-if="Array.isArray(row.attachmentList)">
									<CheckFiles :attachmentList="row.attachmentList" flag="path" @needToUpdate="value => handleUpdateFilePath(value, row)" />
								</div>
								<div v-else>
									<el-tag type="danger">加载错误</el-tag>
								</div>
							</td>

							<td v-if="columns[22].visible">
								<div v-if="Array.isArray(row.attachmentList)">
									<CheckFiles :attachmentList="row.attachmentList" flag="receiveProof" @needToUpdate="value => handleUpdateFilePath(value, row)" />
								</div>
								<div v-else>
									<el-tag type="danger">加载错误</el-tag>
								</div>
							</td>

							<td v-if="columns[23].visible">
								<StateTag :state-title="row.isedit === 0 ? '否' : '是'" :state-mapper="{ 0: '否', 2: '是' }" />
							</td>

							<td v-if="columns[24].visible">
								<div v-if="hasInvoice(row, PUBLIC_DICT_TYPE.CUSTOMER)">
									<el-button type="text" size="mini" @click="showCustomerInvoiceList(row)">是</el-button>
								</div>
								<div v-else>
									<StateTag :state-title="'否'" :state-mapper="{ 3: '否' }" />
								</div>
							</td>

							<td v-if="columns[25].visible">
								<div v-if="hasInvoice(row, PUBLIC_DICT_TYPE.SUPPLIER)">
									<el-button type="text" size="mini" @click="showSupplierInvoiceList(row)">是</el-button>
								</div>
								<div v-else>
									<StateTag :state-title="'否'" :state-mapper="{ 3: '否' }" />
								</div>
							</td>

							<!-- 右侧操作栏 -->
							<td class="fixed-right col-order-action">
								<el-button size="mini" type="text" :disabled="row.isAdjusted !== 1" v-if="!isAdjustOrder" @click="handleCheckAdjust(row)">查看调整单</el-button>
								<el-button size="mini" type="text" :disabled="row.isAdjusted === 1 || !hasPermission(['orderManager'])" @click="handleOrderItemInfo(row)">调整单</el-button>
								<el-button v-if="isAdjustOrder" size="mini" type="text" @click="handleCheckPrevious(row)">查看原单据</el-button>

								<el-button size="mini" type="text" @click="handleOrder1(row)">发货单1</el-button>
								<el-dropdown size="mini" type="text" trigger="click">
									<el-button type="text" size="mini">
										发货单
										<i class="el-icon-arrow-down el-icon--right" />
									</el-button>
									<el-dropdown-menu slot="dropdown">
										<el-dropdown-item>
											<el-button size="mini" type="text" @click="handleOrder2(row)">发货单2</el-button>
										</el-dropdown-item>
										<el-dropdown-item>
											<el-button size="mini" type="text" @click="handleOrder3(row)">发货单3</el-button>
										</el-dropdown-item>
									</el-dropdown-menu>
								</el-dropdown>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<!-- 分页组件 -->
			<pagination v-if="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

			<br />

			<!-- 调整单说明 -->
			<div v-if="isAdjustOrder">
				<el-row>
					<el-card class="box-card">
						<div slot="header" class="clearfix">
							<span class="adjust-title">调整次数示意</span>
							<el-tooltip
								content="负数单，表示该订单为调整订单A后，A订单产生的负数订单，数值与A订单为相反数调整一次意为订单A调整一次,产生的调整单B,记录此时该调整单B为一次调整;调整两次为，对调整单B进行调整，生成调整单C,记录该调整单C为二次调整,以此类推"
								placement="bottom"
								effect="light"
							>
								<el-button class="explain-btn" type="text">解释?</el-button>
							</el-tooltip>
						</div>
						<el-alert title="订单列表点击调整单后，会在此生成调整单，不能对负数单进行调整，且负数单不可修改!" type="warning" show-icon effect="light" />
						<div class="tag-container">
							<el-tag class="custom-tag">负数单</el-tag>
							<el-tag type="info" class="tag-spacing">调整一次</el-tag>
							<el-tag type="success" class="tag-spacing">调整两次</el-tag>
							<el-tag type="warning" class="tag-spacing">调整三次</el-tag>
							<el-tag class="tag-spacing high-adjust">三次以上</el-tag>
						</div>
					</el-card>
				</el-row>
			</div>
		</div>

		<!-- 客户开票列表弹窗 -->
		<el-dialog
			:modal="false"
			title="客户开票记录"
			:visible.sync="customerInvoiceListVisible"
			width="70%"
			:before-close="closeCustomerInvoiceList"
			class="invoice-list-dialog compact-dialog"
			append-to-body
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:close-on-press-escape="false"
			:destroy-on-close="true"
		>
			<div v-if="currentOrderInfo" class="invoice-dialog-content">
				<el-card class="order-info-card" shadow="hover">
					<div class="order-info-header">
						<i class="el-icon-document-checked"></i>
						<span class="order-title">订单信息</span>
					</div>
					<div class="order-info-content">
						<div class="order-info-item">
							<span class="info-label">订单ID:</span>
							<span class="info-value order-id">#{{ currentOrderInfo.id }}</span>
						</div>
						<div class="order-info-item">
							<span class="info-label">客户名称:</span>
							<span class="info-value customer-name">{{ currentOrderInfo.customer }}</span>
						</div>
						<div class="order-info-item">
							<span class="info-label">总货款:</span>
							<span class="info-value total-amount">{{ formatCurrency(currentOrderInfo.allPayments) }}</span>
						</div>
					</div>
				</el-card>

				<div class="action-bar">
					<div class="action-left">
						<el-tag v-if="customerInvoiceList.length > 0" type="info" size="medium">
							<i class="el-icon-tickets"></i>
							已开票 {{ customerInvoiceList.length }} 次
						</el-tag>
					</div>
					<div class="action-right">
						<el-button type="primary" size="medium" @click="handleAddCustomerInvoice" class="add-invoice-btn" :disabled="!hasPermission(['finance'])">
							<i class="el-icon-plus"></i>
							新增开票
						</el-button>
					</div>
				</div>

				<div class="invoice-table-container">
					<el-table
						v-loading="customerInvoiceListLoading"
						:data="customerInvoiceList"
						border
						stripe
						class="invoice-table compact-table"
						size="small"
						:header-cell-style="{ background: '#f8f9fa', color: '#495057', fontWeight: 600 }"
						:row-class-name="getInvoiceRowClassName"
					>
						<el-table-column prop="orderDate" label="日期" align="center" width="170" show-overflow-tooltip>
							<template #default>
								<div class="date-cell">
									<i class="el-icon-date"></i>
									{{ currentOrderInfo && currentOrderInfo.orderDate ? parseTime(currentOrderInfo.orderDate, '{y}-{m}-{d}') : '-' }}
								</div>
							</template>
						</el-table-column>

						<el-table-column prop="companyName" label="客户名称" align="center" min-width="120" show-overflow-tooltip>
							<template #default="scope">
								<div class="company-cell">
									<i class="el-icon-office-building"></i>
									{{ scope.row.companyName || currentOrderInfo.customer }}
								</div>
							</template>
						</el-table-column>

						<el-table-column prop="allPayments" label="需开票金额" align="center" width="110" show-overflow-tooltip>
							<template #default>
								<div class="amount-cell need-amount">
									<span class="currency-symbol">¥</span>
									{{ formatCurrency(currentOrderInfo ? currentOrderInfo.allPayments : 0) }}
								</div>
							</template>
						</el-table-column>

						<el-table-column prop="invoiceDate" label="开票时间" align="center" width="200" show-overflow-tooltip>
							<template #default="scope">
								<div class="datetime-cell">
									<i class="el-icon-time"></i>
									{{ scope.row.invoiceDate ? parseTime(scope.row.invoiceDate, '{y}-{m}-{d} {h}:{i}') : '-' }}
								</div>
							</template>
						</el-table-column>

						<el-table-column prop="invoiceAmount" label="开票金额" align="center" width="130" show-overflow-tooltip>
							<template #default="scope">
								<div class="amount-cell invoiced-amount">
									<span class="currency-symbol">¥</span>
									{{ formatCurrency(scope.row.invoiceAmount || 0) }}
								</div>
							</template>
						</el-table-column>

						<el-table-column label="累计开票金额" align="center" width="140" show-overflow-tooltip>
							<template #default="scope">
								<div class="amount-cell accumulated-amount">
									<span class="currency-symbol">¥</span>
									{{ formatCurrency(calculateAccumulatedInvoiceAmount(scope.$index)) }}
								</div>
							</template>
						</el-table-column>
					</el-table>
				</div>
			</div>
		</el-dialog>

		<!-- 供应商开票列表弹窗 -->
		<el-dialog
			:modal="false"
			title="供应商开票记录"
			:visible.sync="supplierInvoiceListVisible"
			width="75%"
			:before-close="closeSupplierInvoiceList"
			class="invoice-list-dialog supplier-invoice-dialog compact-dialog"
			append-to-body
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:close-on-press-escape="false"
			:destroy-on-close="true"
		>
			<div v-if="currentOrderInfo" class="invoice-dialog-content">
				<el-card class="order-info-card" shadow="hover">
					<div class="order-info-header">
						<i class="el-icon-document-checked"></i>
						<span class="order-title">订单信息</span>
					</div>
					<div class="order-info-content">
						<div class="order-info-item">
							<span class="info-label">订单ID:</span>
							<span class="info-value order-id">{{ currentOrderInfo.id }}</span>
						</div>
						<div class="order-info-item">
							<span class="info-label">供应商数量:</span>
							<span class="info-value total-amount">{{ supplierInvoiceGroups.length }} 家</span>
						</div>
					</div>
				</el-card>

				<div v-if="supplierInvoiceGroups.length > 0" class="supplier-groups-container">
					<div v-for="group in supplierInvoiceGroups" :key="group.companyId" class="supplier-group-card">
						<div class="supplier-group-header">
							<div class="supplier-info">
								<i class="el-icon-office-building"></i>
								<span class="supplier-name">{{ group.companyName }}</span>
								<el-tag type="warning" size="small" class="record-tag">{{ group.invoices.length }} 条记录</el-tag>
							</div>
							<div class="supplier-actions">
								<el-button type="primary" size="small" @click="handleAddSupplierInvoice(group)" :disabled="!hasPermission(['finance'])">
									<i class="el-icon-plus"></i>
									新增开票
								</el-button>
							</div>
						</div>

						<div class="supplier-table-container">
							<el-table
								:data="group.invoices"
								border
								stripe
								size="small"
								class="supplier-invoice-table"
								:header-cell-style="{ background: '#f8f9fa', color: '#495057', fontWeight: 600 }"
							>
								<el-table-column prop="orderDate" label="日期" align="center" width="170" show-overflow-tooltip>
									<template #default>
										<div class="date-cell">
											<i class="el-icon-date"></i>
											{{ currentOrderInfo && currentOrderInfo.orderDate ? parseTime(currentOrderInfo.orderDate, '{y}-{m}-{d}') : '-' }}
										</div>
									</template>
								</el-table-column>

								<el-table-column prop="companyName" label="供应商名称" align="center" min-width="120" show-overflow-tooltip>
									<template #default="scope">
										<div class="company-cell">
											<i class="el-icon-office-building"></i>
											{{ scope.row.companyName }}
										</div>
									</template>
								</el-table-column>

								<el-table-column label="需开票金额" align="center" width="130" show-overflow-tooltip>
									<template #default>
										<div class="amount-cell need-amount">
											<span class="currency-symbol">¥</span>
											{{ formatCurrency(group.needInvoiceAmount) }}
										</div>
									</template>
								</el-table-column>

								<el-table-column prop="invoiceDate" label="开票时间" align="center" width="200" show-overflow-tooltip>
									<template #default="scope">
										<div class="datetime-cell">
											<i class="el-icon-time"></i>
											{{ scope.row.invoiceDate ? parseTime(scope.row.invoiceDate, '{y}-{m}-{d} {h}:{i}') : '-' }}
										</div>
									</template>
								</el-table-column>

								<el-table-column prop="invoiceAmount" label="开票金额" align="center" width="130" show-overflow-tooltip>
									<template #default="scope">
										<div class="amount-cell invoiced-amount">
											<span class="currency-symbol">¥</span>
											{{ formatCurrency(scope.row.invoiceAmount || 0) }}
										</div>
									</template>
								</el-table-column>

								<el-table-column label="累计开票金额" align="center" width="140" show-overflow-tooltip>
									<template #default="scope">
										<div class="amount-cell accumulated-amount">
											<span class="currency-symbol">¥</span>
											{{ formatCurrency(calculateSupplierAccumulatedInvoiceAmount(group.invoices, scope.$index)) }}
										</div>
									</template>
								</el-table-column>
							</el-table>
						</div>
					</div>
				</div>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import CheckFiles from '@/components/CheckFiles.vue';
import QuerySearchBar from '@/views/dashboard/components/goodsOrder/QuerySearchBar.vue';
import HistoryList from '@/views/dashboard/components/goodsOrder/HistoryList.vue';
import OrderHistoryCheck from '@/views/dashboard/components/goodsOrder/OrderHistoryCheck.vue';
import { parseTime } from '@/utils/ruoyi';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import StateTag from '@/views/dashboard/components/common/StateTag.vue';
import ExpandCursor from '@/views/dashboard/components/common/ExpandCursor.vue';
import { getGoodsOrder, getHistoryGoodsOrder } from '@/api/system/goodsOrder';
import { excludeParams } from '@/api/tool/exclude';

export default {
	name: 'OrderTable',
	components: {
		StateTag,
		HistoryList,
		OrderHistoryCheck,
		CheckFiles,
		QuerySearchBar,
		ExpandCursor
	},
	props: {
		isAdjustOrder: {
			type: Boolean,
			default: false
		}
	},
	data() {
		return {
			loading: false,
			total: 0,
			queryParams: {
				pageNum: 1,
				pageSize: 50
			},
			// 客户开票列表相关数据
			customerInvoiceListVisible: false,
			customerInvoiceList: [],
			customerInvoiceListLoading: false,
			currentOrderInfo: null,
			// 供应商开票列表相关数据
			supplierInvoiceListVisible: false,
			supplierInvoiceList: [],
			supplierInvoiceListLoading: false,
			supplierInvoiceGroups: [],
			// 订单列表数据
			goodsOrderList: [],
			// 分片渲染相关
			renderedData: [],
			isRendering: false,
			renderProgress: 0,
			renderChunkSize: 50,
			renderTimer: null,
			// 订单修改记录相关
			checkHistoryOrderVisible: false,
			orderHistoryInfoList: [],
			currentOrderItemInfo: null,
			// 列配置
			columns: [
				{ key: 0, label: 'ID', visible: true },
				{ key: 1, label: '日期', visible: true },
				{ key: 2, label: '客户', visible: true },
				{ key: 3, label: '供应商/仓库', visible: true },
				{ key: 4, label: '陆运车牌', visible: true },
				{ key: 5, label: '审核状态', visible: true },
				{ key: 6, label: '车队', visible: true },
				{ key: 7, label: '陆运司机电话', visible: true },
				{ key: 8, label: '陆地司机姓名', visible: true },
				{ key: 9, label: '海运柜号', visible: true },
				{ key: 10, label: '海运司机电话', visible: true },
				{ key: 11, label: '海运公司', visible: true },
				{ key: 12, label: '总货款', visible: true },
				{ key: 13, label: '总吨位', visible: true },
				{ key: 14, label: '陆运费', visible: true },
				{ key: 15, label: '海运费', visible: true },
				{ key: 16, label: '总利润(含税)', visible: true },
				{ key: 17, label: '总利润(不含税)', visible: true },
				{ key: 18, label: '销售经理', visible: true },
				{ key: 19, label: '录入员', visible: true },
				{ key: 20, label: '备注', visible: true },
				{ key: 21, label: '附件', visible: true },
				{ key: 22, label: '收到条附件', visible: true },
				{ key: 23, label: '是否可编辑', visible: true },
				{ key: 24, label: '客户是否含税', visible: true },
				{ key: 25, label: '供应商是否开票', visible: true }
			],
			// 列宽度配置
			columnWidths: {
				rowAction: '180px',
				id: '100px',
				date: '120px',
				customer: '100px',
				supplier: '200px',
				landCar: '100px',
				checkState: '120px',
				fleet: '100px',
				landDriverTel: '100px',
				landDriverName: '100px',
				seaCarNo: '100px',
				seaDriverTel: '100px',
				seaDriverName: '100px',
				allPayments: '100px',
				allTonnage: '120px',
				landFreight: '100px',
				seaFreight: '100px',
				allProfit: '120px',
				allProfitNoTax: '120px',
				saleManager: '100px',
				userName: '120px',
				comments: '150px',
				attachment: '150px',
				receiveProof: '150px',
				isedit: '100px',
				customerTax: '120px',
				supplierInvoice: '120px',
				orderAction: '320px'
			},
			changeLength: 2,
			// 用户权限
			userRoles: []
		};
	},
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		// 分页后的数据
		paginatedData() {
			const start = (this.queryParams.pageNum - 1) * this.queryParams.pageSize;
			const end = start + this.queryParams.pageSize;
			return this.goodsOrderList.slice(start, end);
		}
	},
	watch: {
		// 监听分页数据变化，触发分片渲染
		paginatedData: {
			handler(newData) {
				if (newData && newData.length > 0) {
					this.renderDataInChunks(newData);
				} else {
					this.renderedData = [];
					this.isRendering = false;
					this.renderProgress = 0;
				}
			},
			immediate: true
		}
	},
	mounted() {
		this.getUserRoles();
		this.getList();
	},
	beforeDestroy() {
		// 清理渲染定时器
		if (this.renderTimer) {
			cancelAnimationFrame(this.renderTimer);
			this.renderTimer = null;
		}
	},
	methods: {
		// 获取用户权限
		getUserRoles() {
			// 模拟获取用户权限，实际应从store或API获取
			this.userRoles = ['admin']; // 示例权限
		},

		// 检查用户是否具有指定权限
		hasPermission(roles) {
			if (!roles || roles.length === 0) return true;
			return roles.some(role => this.userRoles.includes(role));
		},

		// 分片渲染数据
		renderDataInChunks(data) {
			// 如果正在渲染，先取消
			if (this.renderTimer) {
				cancelAnimationFrame(this.renderTimer);
				this.renderTimer = null;
			}

			const total = data.length;

			// 如果数据量很小，直接一次性渲染
			if (total <= this.renderChunkSize) {
				this.renderedData = [...data];
				this.isRendering = false;
				this.renderProgress = 0;
				return;
			}

			// 重置状态
			this.renderedData = [];
			this.isRendering = true;
			this.renderProgress = 0;

			let currentIndex = 0;

			const renderChunk = () => {
				// 计算本次要渲染的数据范围
				const endIndex = Math.min(currentIndex + this.renderChunkSize, total);
				const chunk = data.slice(currentIndex, endIndex);

				// 添加到已渲染数据
				this.renderedData = [...this.renderedData, ...chunk];

				// 更新进度
				currentIndex = endIndex;
				this.renderProgress = Math.round((currentIndex / total) * 100);

				// 如果还有数据未渲染，继续下一批
				if (currentIndex < total) {
					this.renderTimer = requestAnimationFrame(renderChunk);
				} else {
					// 渲染完成
					this.isRendering = false;
					this.renderProgress = 100;
					this.renderTimer = null;

					// 延迟隐藏进度条，让用户看到完成状态
					setTimeout(() => {
						this.renderProgress = 0;
					}, 500);
				}
			};

			// 开始渲染
			this.renderTimer = requestAnimationFrame(renderChunk);
		},

		// 格式化货币显示
		formatCurrency(value) {
			if (value === null || value === undefined) return '¥0.00';
			return `¥${Number(value).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
		},

		// 格式化数字显示
		formatNumber(value) {
			if (value === null || value === undefined) return '0';
			return Number(value).toLocaleString('zh-CN', { minimumFractionDigits: this.changeLength, maximumFractionDigits: this.changeLength });
		},

		// 统一行样式
		getRowStyle(row) {
			const base = { height: '28px', lineHeight: '28px' };
			if (!row.isAdjust) return base;
			if (row.isAdjust > 0 && this.isAdjustOrder) {
				if (row.isAdjust === 1) return { ...base, background: '#f0f0f0' };
				if (row.isAdjust === 2) return { ...base, background: '#f0f9eb' };
				if (row.isAdjust === 3) return { ...base, background: '#fdf6ec' };
				return { ...base, background: '#ffcccc' };
			}
			return base;
		},

		// 处理顶部搜索框
		handleGetQueryParams(value) {
			if (value) {
				this.queryParams = { ...this.queryParams, ...value };
			}
			this.getList();
		},

		// 获取列表
		async getList() {
			this.loading = true;
			try {
				// 模拟API调用，实际应替换为真实API
				await new Promise(resolve => setTimeout(resolve, 800));

				// 模拟数据获取
				const data = [];
				const total = 1000;

				for (let i = 1; i <= total; i++) {
					data.push({
						id: i,
						orderDate: new Date().toISOString().split('T')[0],
						customer: `客户${i}`,
						supplierNames: `供应商${i}`,
						_uniqueSuppliers: [{ supplierID: i, supplier: `供应商${i}` }],
						_uniqueWarehouses: [{ storeHouseID: i, storeHouseName: `仓库${i}` }],
						landCarNo: `车牌${i}`,
						checkState: i % 2 === 0 ? '已审核' : '待审核',
						fleet: `车队${i}`,
						landDriverTel: `1380000${String(i).padStart(4, '0')}`,
						landDriverName: `司机${i}`,
						seaCarNo: i % 3 === 0 ? `柜号${i}` : null,
						seaDriverTel: i % 3 === 0 ? `1390000${String(i).padStart(4, '0')}` : null,
						seaDriverName: i % 3 === 0 ? `海运公司${i}` : null,
						allPayments: (Math.random() * 100000).toFixed(2),
						allTonnage: (Math.random() * 1000).toFixed(2),
						landFreight: (Math.random() * 10000).toFixed(2),
						seaFreight: (Math.random() * 5000).toFixed(2),
						allProfit: (Math.random() * 50000).toFixed(2),
						allProfitNoTax: (Math.random() * 45000).toFixed(2),
						saleManager: `经理${i}`,
						userName: `录入员${i}`,
						comments: `备注信息${i}，这是一段较长的备注内容用于测试文本溢出效果`,
						attachmentList: [],
						isedit: i % 2,
						historyCount: i % 5 === 0 ? 1 : 0,
						isAdjust: 0,
						isAdjusted: i % 3 === 0 ? 1 : 0,
						addtime: new Date(Date.now() - i * 24 * 60 * 60 * 1000).toISOString()
					});
				}

				this.goodsOrderList = data;
				this.total = total;
			} catch (error) {
				console.error('获取订单列表失败:', error);
				this.$message.error('获取订单列表失败');
			} finally {
				this.loading = false;
			}
		},

		// 行操作中点击查看
		checkOrderItemInfo(row) {
			this.currentOrderItemInfo = row;
			this.checkHistoryOrderVisible = true;
		},

		// 处理下拉菜单
		handleCommand(command, row) {
			switch (command) {
				case 'handleUpdate':
					this.handleUpdate(row);
					break;
				case 'handleDelete':
					this.handleDelete(row);
					break;
				default:
					console.warn('未知操作命令:', command);
			}
		},

		// 修改订单
		handleUpdate(row) {
			console.log('修改订单:', row);
			// 实际应跳转到编辑页面或打开编辑弹窗
			this.$message.info('修改订单功能待实现');
		},

		// 删除订单
		handleDelete(row) {
			this.$confirm('确定要删除该订单吗？此操作不可恢复', '删除确认', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			})
				.then(() => {
					// 实际应调用API删除订单
					console.log('删除订单:', row);
					this.$message.success('删除成功');
					this.getList(); // 重新获取列表
				})
				.catch(() => {
					this.$message.info('已取消删除');
				});
		},

		// 审核
		async handleCheck(row) {
			try {
				// 模拟API调用
				await new Promise(resolve => setTimeout(resolve, 500));
				row.checkState = '已审核';
				this.$message.success('审核成功');
			} catch (error) {
				this.$message.error('审核失败');
			}
		},

		// 取消审核
		async handleReCheck(row) {
			try {
				// 模拟API调用
				await new Promise(resolve => setTimeout(resolve, 500));
				row.checkState = '待审核';
				this.$message.success('取消审核成功');
			} catch (error) {
				this.$message.error('取消审核失败');
			}
		},

		// 计算订单是否超过7天
		isOrderExpired(addtime) {
			if (!addtime) return false;
			const addDate = new Date(addtime);
			const currentDate = new Date();
			const timeDiff = currentDate.getTime() - addDate.getTime();
			const daysDiff = timeDiff / (24 * 60 * 60 * 1000);
			return daysDiff >= 7;
		},

		// 添加订单
		handleAdd() {
			console.log('添加订单');
			// 实际应跳转到新增页面或打开新增弹窗
			this.$message.info('添加订单功能待实现');
		},

		// 打印
		printHTML() {
			console.log('打印订单');
			this.$message.info('打印功能待实现');
		},

		// 导出
		handleExport() {
			console.log('导出订单目录');
			this.$message.info('导出订单目录功能待实现');
		},

		// 导出全部
		handleExportNoPage() {
			console.log('导出全部订单');
			this.$message.info('导出全部订单功能待实现');
		},

		// 查看调整单
		handleCheckAdjust(row) {
			console.log('查看调整单:', row);
			this.$message.info('查看调整单功能待实现');
		},

		// 调整单
		handleOrderItemInfo(row) {
			console.log('生成调整单:', row);
			this.$message.info('生成调整单功能待实现');
		},

		// 查看原单据
		handleCheckPrevious(row) {
			console.log('查看原单据:', row);
			this.$message.info('查看原单据功能待实现');
		},

		// 发货单1
		handleOrder1(row) {
			console.log('生成发货单1:', row);
			this.$message.info('生成发货单1功能待实现');
		},

		// 发货单2
		handleOrder2(row) {
			console.log('生成发货单2:', row);
			this.$message.info('生成发货单2功能待实现');
		},

		// 发货单3
		handleOrder3(row) {
			console.log('生成发货单3:', row);
			this.$message.info('生成发货单3功能待实现');
		},

		// 更新供应商开票
		updateOrderItemVisibleSupplierInvoice(row, supplierID) {
			console.log('更新供应商开票:', row, supplierID);
			this.$message.info('更新供应商开票功能待实现');
		},

		// 更新文件路径
		handleUpdateFilePath(value, row) {
			console.log('更新文件路径:', value, row);
			// 实际应调用API更新文件路径
			this.$message.success('文件路径更新成功');
		},

		// 检查是否有开票
		hasInvoice(row, type) {
			// 模拟开票状态检查
			if (type === PUBLIC_DICT_TYPE.CUSTOMER) {
				return row.id % 3 === 0; // 模拟1/3的客户有开票
			} else if (type === PUBLIC_DICT_TYPE.SUPPLIER) {
				return row.id % 4 === 0; // 模拟1/4的供应商有开票
			}
			return false;
		},

		// 显示客户开票列表
		showCustomerInvoiceList(row) {
			this.currentOrderInfo = row;
			this.customerInvoiceListVisible = true;
			this.getCustomerInvoiceList(row.id);
		},

		// 获取客户开票列表
		async getCustomerInvoiceList(orderId) {
			this.customerInvoiceListLoading = true;
			try {
				// 模拟API调用
				await new Promise(resolve => setTimeout(resolve, 500));

				// 模拟开票数据
				const invoices = [];
				const count = Math.floor(Math.random() * 5); // 0-4条记录

				for (let i = 1; i <= count; i++) {
					invoices.push({
						id: `${orderId}-${i}`,
						orderDate: new Date().toISOString().split('T')[0],
						companyName: `客户${orderId}`,
						allPayments: (Math.random() * 10000).toFixed(2),
						invoiceDate: new Date(Date.now() - i * 24 * 60 * 60 * 1000).toISOString(),
						invoiceAmount: (Math.random() * 5000).toFixed(2),
						isInvoiced: i % 2 === 0
					});
				}

				this.customerInvoiceList = invoices;
			} catch (error) {
				console.error('获取客户开票列表失败:', error);
				this.$message.error('获取客户开票列表失败');
			} finally {
				this.customerInvoiceListLoading = false;
			}
		},

		// 关闭客户开票列表
		closeCustomerInvoiceList() {
			this.customerInvoiceListVisible = false;
			this.customerInvoiceList = [];
			this.currentOrderInfo = null;
		},

		// 添加客户开票
		handleAddCustomerInvoice() {
			console.log('添加客户开票');
			this.$message.info('添加客户开票功能待实现');
		},

		// 计算累计开票金额
		calculateAccumulatedInvoiceAmount(index) {
			let accumulated = 0;
			for (let i = 0; i <= index; i++) {
				accumulated += Number(this.customerInvoiceList[i]?.invoiceAmount || 0);
			}
			return accumulated.toFixed(2);
		},

		// 获取开票记录行样式
		getInvoiceRowClassName({ row, rowIndex }) {
			if (row.isInvoiced) {
				return 'invoice-row-completed';
			}
			return 'invoice-row-pending';
		},

		// 显示供应商开票列表
		showSupplierInvoiceList(row) {
			this.currentOrderInfo = row;
			this.supplierInvoiceListVisible = true;
			this.getSupplierInvoiceList(row.id);
		},

		// 获取供应商开票列表
		async getSupplierInvoiceList(orderId) {
			this.supplierInvoiceListLoading = true;
			try {
				// 模拟API调用
				await new Promise(resolve => setTimeout(resolve, 500));

				// 模拟供应商开票数据
				const suppliers = [
					{ companyId: 'S001', companyName: '供应商A' },
					{ companyId: 'S002', companyName: '供应商B' },
					{ companyId: 'S003', companyName: '供应商C' }
				];

				const invoices = [];
				suppliers.forEach((supplier, idx) => {
					const supplierInvoices = [];
					const count = Math.floor(Math.random() * 3) + 1; // 1-3条记录

					for (let i = 1; i <= count; i++) {
						supplierInvoices.push({
							id: `${supplier.companyId}-${i}`,
							orderDate: new Date().toISOString().split('T')[0],
							companyName: supplier.companyName,
							companyId: supplier.companyId,
							invoiceDate: new Date(Date.now() - (idx * 3 + i) * 24 * 60 * 60 * 1000).toISOString(),
							invoiceAmount: (Math.random() * 3000).toFixed(2),
							isInvoiced: i % 2 === 0
						});
					}

					invoices.push(...supplierInvoices);
				});

				this.supplierInvoiceList = invoices;
				this.groupSupplierInvoicesByCompany();
			} catch (error) {
				console.error('获取供应商开票列表失败:', error);
				this.$message.error('获取供应商开票列表失败');
			} finally {
				this.supplierInvoiceListLoading = false;
			}
		},

		// 按供应商分组开票记录
		groupSupplierInvoicesByCompany() {
			const groups = {};
			this.supplierInvoiceList.forEach(invoice => {
				const companyId = invoice.companyId;
				if (!groups[companyId]) {
					groups[companyId] = {
						companyId: companyId,
						companyName: invoice.companyName,
						invoices: [],
						totalInvoiceAmount: 0,
						needInvoiceAmount: (Math.random() * 10000).toFixed(2)
					};
				}
				groups[companyId].invoices.push(invoice);
				groups[companyId].totalInvoiceAmount += Number(invoice.invoiceAmount || 0);
			});
			this.supplierInvoiceGroups = Object.values(groups);
		},

		// 关闭供应商开票列表
		closeSupplierInvoiceList() {
			this.supplierInvoiceListVisible = false;
			this.supplierInvoiceList = [];
			this.supplierInvoiceGroups = [];
			this.currentOrderInfo = null;
		},

		// 添加供应商开票
		handleAddSupplierInvoice(supplierGroup) {
			console.log('添加供应商开票:', supplierGroup);
			this.$message.info(`为供应商 ${supplierGroup.companyName} 添加开票功能待实现`);
		},

		// 计算供应商累计开票金额
		calculateSupplierAccumulatedInvoiceAmount(invoices, index) {
			let accumulated = 0;
			for (let i = 0; i <= index; i++) {
				accumulated += Number(invoices[i]?.invoiceAmount || 0);
			}
			return accumulated.toFixed(2);
		},

		// 查看订单历史信息
		checkOrderHistory(row) {
			const id = row.id;
			// 先获取原订单的信息
			getGoodsOrder(row.id)
				.then(res => {
					this.currentOrderItemInfo = res.data;
					// 获取订单修改记录信息
					getHistoryGoodsOrder({ goodsOrderID: id })
						.then(res => {
							if (res.total === 0) {
								this.$message.warning('无订单历史信息');
								return;
							}
							this.orderHistoryInfoList = [];
							let array = res.rows;

							array.unshift(JSON.parse(JSON.stringify(row)));

							for (let i = array.length - 1; i > 0; i--) {
								const item = array[i];
								const new_item = array[i - 1];
								this.orderHistoryInfoList.push({
									diff: {
										old: this.formatData(excludeParams(item, this.$excludeWithUpdate || [])),
										new: this.formatData(excludeParams(new_item, this.$excludeWithUpdate || [])),
										updateTime: item.updateTime,
										userName: item.userName,
										remark: item.remark
									}
								});
							}
							this.orderHistoryInfoList.reverse();
							this.checkHistoryOrderVisible = true;
						})
						.catch(error => {
							console.error('获取订单修改记录失败:', error);
							this.$message.error('获取订单修改记录失败，请重试');
						});
				})
				.catch(error => {
					console.error('获取订单信息失败:', error);
					this.$message.error('获取订单信息失败，请重试');
				});
		},

		// 格式化数据（用于历史记录对比）
		formatData(data) {
			if (!data) return '';
			return JSON.stringify(data, null, 2);
		},

		// 关闭订单修改记录查看
		closeOrderHistoryCheck() {
			this.checkHistoryOrderVisible = false;
			this.currentOrderItemInfo = null;
		},

		parseTime
	}
};
</script>

<style scoped lang="scss">
.order-table-container {
	.toolbar-wrapper {
		margin-bottom: 15px;

		.toolbar-left {
			padding: 10px 0;
		}
	}

	.text-ellipsis {
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		max-width: 200px;
	}

	.pending-text {
		color: #909399;
		font-size: 12px;
	}

	.adjust-title {
		font-weight: bold;
		font-size: 16px;
	}

	.explain-btn {
		float: right;
		padding: 3px 0;
	}

	.tag-container {
		margin-top: 10px;

		.tag-spacing {
			margin-right: 8px;
			margin-bottom: 5px;
		}

		.high-adjust {
			background-color: #ed5b3a !important;
			color: white !important;
		}
	}

	.record-tag {
		margin-left: 10px;
	}
}

// 客户开票列表弹窗样式
.invoice-list-dialog {
	.invoice-dialog-content {
		padding: 0;
	}

	.order-info-card {
		margin-bottom: 20px;
		border-radius: 8px;
		border: 1px solid #e4e7ed;

		.order-info-header {
			display: flex;
			align-items: center;
			margin-bottom: 15px;
			color: #409eff;

			i {
				font-size: 18px;
				margin-right: 8px;
			}

			.order-title {
				font-size: 16px;
				font-weight: 600;
			}
		}

		.order-info-content {
			display: flex;
			flex-wrap: wrap;
			gap: 20px;

			.order-info-item {
				display: flex;
				align-items: center;
				flex: 1;
				min-width: 200px;

				.info-label {
					color: #606266;
					font-weight: 500;
					margin-right: 8px;
					white-space: nowrap;
				}

				.info-value {
					font-weight: 600;

					&.order-id {
						color: #409eff;
					}

					&.customer-name {
						color: #67c23a;
					}

					&.total-amount {
						color: #e6a23c;
						font-size: 16px;
					}
				}
			}
		}
	}

	.action-bar {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 20px;

		.action-left {
			.el-tag {
				font-size: 13px;

				i {
					margin-right: 5px;
				}
			}
		}

		.add-invoice-btn {
			border-radius: 6px;
			font-weight: 500;
			box-shadow: 0 2px 4px rgba(64, 158, 255, 0.3);

			&:hover {
				box-shadow: 0 4px 8px rgba(64, 158, 255, 0.4);
				transform: translateY(-1px);
			}

			i {
				margin-right: 5px;
			}
		}
	}

	.invoice-table-container {
		.invoice-table {
			border-radius: 8px;
			overflow: hidden;

			.date-cell,
			.datetime-cell,
			.company-cell {
				display: flex;
				align-items: center;
				justify-content: center;

				i {
					margin-right: 6px;
					color: #909399;
				}
			}

			.amount-cell {
				display: flex;
				align-items: center;
				justify-content: center;
				font-weight: 600;

				.currency-symbol {
					margin-right: 2px;
					color: #909399;
				}

				&.need-amount {
					color: #e6a23c;
				}

				&.invoiced-amount {
					color: #67c23a;
				}

				&.accumulated-amount {
					color: #409eff;
					font-size: 14px;
				}
			}
		}

		// 表格行样式
		::v-deep .invoice-row-completed {
			background-color: #f0f9ff !important;
		}

		::v-deep .invoice-row-pending {
			background-color: #fffbf0 !important;
		}
	}
}

// 供应商开票列表弹窗专属样式
.supplier-invoice-dialog {
	.supplier-groups-container {
		.supplier-group-card {
			margin-bottom: 25px;
			border: 1px solid #e4e7ed;
			border-radius: 8px;
			overflow: hidden;
			background: #fff;
			box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

			&:last-child {
				margin-bottom: 0;
			}

			.supplier-group-header {
				display: flex;
				justify-content: space-between;
				align-items: center;
				padding: 15px 20px;
				background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
				border-bottom: 1px solid #e4e7ed;

				.supplier-info {
					display: flex;
					align-items: center;

					i {
						font-size: 18px;
						color: #e6a23c;
						margin-right: 8px;
					}

					.supplier-name {
						font-size: 16px;
						font-weight: 600;
						color: #303133;
					}
				}

				.supplier-actions {
					.el-button {
						border-radius: 6px;
						font-size: 13px;
						padding: 6px 12px;
						box-shadow: 0 2px 4px rgba(230, 162, 60, 0.3);

						&:hover {
							box-shadow: 0 4px 8px rgba(230, 162, 60, 0.4);
							transform: translateY(-1px);
						}

						i {
							margin-right: 4px;
						}
					}
				}
			}

			.supplier-table-container {
				padding: 0;

				.supplier-invoice-table {
					border: none;
					margin: 0;

					::v-deep .el-table__header {
						border-radius: 0;
					}

					.date-cell,
					.datetime-cell,
					.company-cell {
						display: flex;
						align-items: center;
						justify-content: center;

						i {
							margin-right: 6px;
							color: #909399;
						}
					}

					.amount-cell {
						display: flex;
						align-items: center;
						justify-content: center;
						font-weight: 600;

						.currency-symbol {
							margin-right: 2px;
							color: #909399;
						}

						&.need-amount {
							color: #e6a23c;
						}

						&.invoiced-amount {
							color: #67c23a;
						}

						&.accumulated-amount {
							color: #409eff;
							font-size: 14px;
						}
					}
				}
			}
		}
	}
}

// 供应商和仓库的容器
.supplier-warehouse-container {
	display: inline-flex;
	align-items: center;
	justify-content: flex-start;
	flex-wrap: nowrap;
	gap: 4px;
	max-width: 100%;
	overflow: hidden;
	line-height: 1.2;
}

.supplier-name {
	color: #409eff;
	cursor: pointer;
	display: inline-block;
	margin-right: 4px;
	white-space: nowrap;
	font-weight: 500;

	&:hover {
		color: #df6565;
		font-weight: bold;
	}

	&:not(:last-of-type)::after {
		content: ',';
		margin-right: 4px;
		color: #909399;
	}
}

.warehouse-name {
	color: #67c23a;
	display: inline-block;
	margin-right: 4px;
	white-space: nowrap;
	font-weight: 500;

	&:not(:last-of-type)::after {
		content: ',';
		margin-right: 4px;
		color: #909399;
	}
}

.empty-item {
	color: #909399;
	display: inline-block;
	font-style: italic;
}

.tag-spacing {
	margin-right: 8px;
}

.custom-tag {
	background-color: #ffffff !important;
	border: 0.4px solid #aed3fa !important;
	color: #a6a5a5 !important;
	font-weight: bold;
	margin-right: 8px;
}

// 紧凑型对话框样式
::v-deep .compact-dialog {
	.el-dialog__body {
		padding: 15px;
	}

	.el-dialog__header {
		padding: 15px 20px 10px;
	}
}

// 表格容器样式
.table-container {
	position: relative;

	.rendering-progress {
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		z-index: 1000;
		background: rgba(255, 255, 255, 0.95);
		padding: 10px 20px;
		border-bottom: 1px solid #ebeef5;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

		.progress-text {
			display: block;
			margin-top: 8px;
			text-align: center;
			font-size: 12px;
			color: #606266;
		}
	}

	.table-wrapper {
		position: relative;
		width: 100%;
		max-height: 750px;
		overflow: auto;
		border: 1px solid #ebeef5;
		border-radius: 4px;
		background: #fff;

		.native-table {
			width: 100%;
			border-collapse: collapse;
			font-size: 12px;
			color: #606266;
			background: #fff;

			thead {
				background: #f5f7fa;
				position: sticky;
				top: 0;
				z-index: 10;

				th {
					padding: 8px 10px;
					text-align: center;
					font-weight: 500;
					color: #909399;
					border: 1px solid #ebeef5;
					border-top: none;
					background: #f5f7fa;
					white-space: nowrap;
					position: relative;

					&.fixed-left {
						position: sticky;
						z-index: 11;
						background: #f5f7fa;
						box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);

						&.col-row-action {
							left: 0;
						}

						&.col-id {
							left: 180px;
						}

						&.col-date {
							left: 280px;
						}

						&.col-customer {
							left: 400px;
						}

						&.col-supplier {
							left: 500px;
						}

						&.col-land-car {
							left: 700px;
						}
					}

					&.fixed-right {
						position: sticky;
						right: 0;
						z-index: 11;
						background: #f5f7fa;
						box-shadow: -2px 0 4px rgba(0, 0, 0, 0.1);
					}
				}
			}

			tbody {
				tr {
					transition: background-color 0.25s ease;

					&:hover {
						background: #f5f7fa;
					}

					&.stripe-row {
						background: #fafafa;
					}

					&.stripe-row:hover {
						background: #f5f7fa;
					}

					td {
						padding: 8px 10px;
						border: 1px solid #ebeef5;
						border-top: none;
						white-space: nowrap;
						text-align: center;
						position: relative;

						&.fixed-left {
							position: sticky;
							z-index: 9;
							background: inherit;
							box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);

							&.col-row-action {
								left: 0;
							}

							&.col-id {
								left: 180px;
							}

							&.col-date {
								left: 280px;
							}

							&.col-customer {
								left: 400px;
							}

							&.col-supplier {
								left: 500px;
							}

							&.col-land-car {
								left: 700px;
							}
						}

						&.fixed-right {
							position: sticky;
							right: 0;
							z-index: 9;
							background: inherit;
							box-shadow: -2px 0 4px rgba(0, 0, 0, 0.1);
						}
					}
				}
			}

			// 启用硬件加速
			transform: translateZ(0);
			-webkit-transform: translateZ(0);
		}
	}
}

// 响应式优化
@media screen and (max-width: 768px) {
	.table-wrapper {
		max-height: 500px;
	}

	.column-hidden-mobile {
		display: none;
	}
}
</style>
