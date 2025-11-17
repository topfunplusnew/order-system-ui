<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-row>
				<el-form-item label="计提返利时间段" prop="rebateDateRange">
					<el-date-picker v-model="rebateDateRange" type="datetimerange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd HH:mm:ss" style="width: 350px"></el-date-picker>
				</el-form-item>
				<el-form-item label="收到返利时间段" prop="receivedRebateDateRange">
					<el-date-picker v-model="receivedRebateDateRange" type="datetimerange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd HH:mm:ss" style="width: 350px"></el-date-picker>
				</el-form-item>
				<el-form-item label="供应商" prop="supplier">
					<el-input v-model="queryParams.supplier" placeholder="请输入供应商" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
			</el-row>
			<el-row>
				<el-form-item label="是否收到返利" prop="isReceivedRebate">
					<el-select v-model="queryParams.params.isReceivedRebate" placeholder="请选择" clearable @keyup.enter.native="handleQuery">
						<el-option label="全部" value="" />
						<el-option label="已收到" value="Y" />
						<el-option label="未收到" value="N" />
					</el-select>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
					<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
				</el-form-item>
			</el-row>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<!-- 刷新按钮-->
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:rebate:add']" type="danger" size="mini" @click="handleAdd">新增供应商返利信息</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:rebate:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="RebateList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
		<!-- 计提返利日期 -->
		<el-table-column v-if="columns[0].visible" label="计提返利日期" align="center" prop="rebateDate" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.rebateDate }}</div>
					<span>{{ scope.row.rebateDate }}</span>
				</el-tooltip>
			</template>
		</el-table-column>

		<!-- 类型 -->
		<el-table-column v-if="columns[1].visible" label="类型" align="center" prop="rebateType" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.rebateType }}</div>
					<span>{{ scope.row.rebateType }}</span>
				</el-tooltip>
			</template>
		</el-table-column>

		<!-- 供应商 -->
		<el-table-column v-if="columns[2].visible" label="供应商" align="center" prop="supplier" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.supplier }}</div>
					<span>{{ scope.row.supplier }}</span>
				</el-tooltip>
			</template>
		</el-table-column>

		<!-- 返利方式 -->
		<el-table-column v-if="columns[3].visible" label="返利方式" align="center" prop="rebateMethod" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.rebateMethod == 2 ? '面积' : '重箱' }}</div>
					<span>{{ scope.row.rebateMethod == 2 ? '面积' : '重箱' }}</span>
				</el-tooltip>
			</template>
		</el-table-column>

		<!-- （返利/降价）单价 -->
		<el-table-column v-if="columns[4].visible" label="（返利/降价）单价" align="center" prop="unitPrice" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.unitPrice }}</div>
					<span>{{ scope.row.unitPrice }}</span>
				</el-tooltip>
			</template>
		</el-table-column>

		<!-- 金额 -->
		<el-table-column v-if="columns[5].visible" label="金额" align="center" prop="rebate" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.rebate }}</div>
					<span class="money">{{ scope.row.rebate }}</span>
				</el-tooltip>
			</template>
		</el-table-column>

		<!-- 返利原因 -->
		<el-table-column v-if="columns[6].visible" label="返利原因" align="center" prop="rebateReason" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.rebateReason }}</div>
					<span>{{ scope.row.rebateReason }}</span>
				</el-tooltip>
			</template>
		</el-table-column>

		<!-- 收到返利日期 -->
		<el-table-column v-if="columns[7].visible" label="收到返利日期" align="center" prop="receivedRebateDate" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ getEarliestReceivedDate(scope.row) }}</div>
					<span>{{ getEarliestReceivedDate(scope.row) }}</span>
				</el-tooltip>
			</template>
		</el-table-column>

		<!-- 收到返利金额 -->
		<el-table-column v-if="columns[8].visible" label="收到返利金额" align="center" prop="receivedRebateAmount" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ getTotalReceivedAmount(scope.row) > 0 ? getTotalReceivedAmount(scope.row) : '未收到' }}</div>
					<span v-if="getTotalReceivedAmount(scope.row) > 0" class="money">{{ getTotalReceivedAmount(scope.row) }}</span>
					<span v-else>未收到</span>
				</el-tooltip>
			</template>
		</el-table-column>

		<!-- 返利流水 -->
		<el-table-column label="返利流水" align="center" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">查看流水</div>
					<el-button size="mini" type="text" @click="handleRebateDetail(scope.row)">查看流水</el-button>
				</el-tooltip>
			</template>
		</el-table-column>

			<!-- 操作 -->
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200px">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="handleRebate(scope.row)">返利</el-button>
					<el-button v-hasPermi="['system:rebate:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:rebate:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- todo 添加或修改返利回扣对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="800px" append-to-body>
			<el-row>
				<el-form ref="form" :model="form" :rules="rules" label-width="150px">
					<el-row>
						<el-col :span="12">
							<!-- 系数输入框 -->
							<el-form-item label="（返利/降价）单价" prop="unitPrice">
								<el-input v-model="form.unitPrice" placeholder="请输入（返利/降价）单价" @input="isManualEditRebate = false" />
							</el-form-item>

							<!--              需要进行选择 是面积值还是重箱值-->
							<el-form-item label="返利方式" prop="rebateMethod">
								<el-select
									v-model="form.rebateMethod"
									placeholder="请选择"
									:disabled="!form.unitPrice"
									@change="
										() => {
											areaOrWeightBox = form.rebateMethod;
											// 返利方式变化时，重置手动编辑标志，使用自动计算
											isManualEditRebate = false;
										}
									"
								>
									<el-option label="重箱" value="重箱" />
									<el-option label="面积" value="面积" />
								</el-select>
							</el-form-item>

							<!-- 返利货物 -->
							<el-form-item label="返利货物">
								<el-button v-if="goods.length === 0" size="mini" :disabled="!form.unitPrice" @click="orderDialogVisible = true">
									{{ form.unitPrice ? `选择订单` : `请先输入系数后选择订单` }}
								</el-button>
								<el-row v-else>
									<el-button size="mini" type="success" :disabled="!form.unitPrice" @click="checkSelectedGoods">查看已选择货物</el-button>
									<el-button size="mini" type="danger" :disabled="!form.unitPrice" @click="refreshSelectedGoods">重新选择货物</el-button>
								</el-row>
							</el-form-item>

							<!-- 计提返利日期 -->
							<el-form-item label="计提返利日期" prop="rebateDate">
								<el-date-picker v-model="form.rebateDate" type="datetime" placeholder="计提返利日期" value-format="yyyy-MM-dd HH:mm:ss" :disabled="!form.unitPrice" />
							</el-form-item>

							<!-- 类型 -->
							<el-form-item label="类型" prop="rebateType">
								<el-select v-model="form.rebateType" placeholder="请选择" :disabled="!form.unitPrice">
									<el-option v-for="item in rebateTypes" :key="item.value" :label="item.label" :value="item.value" />
								</el-select>
							</el-form-item>

							<!-- 供应商 -->
						</el-col>
						<el-col :span="12">
							<el-form-item label="请选择供应商" prop="supplier">
								<el-row>
									<el-col :span="15">
										<el-input v-model="form.supplier" disabled placeholder="请选择供应商" />
									</el-col>
									<el-col :span="4">
										<SearchOption
											:limit-info="{
												companyType: '供应商'
											}"
											:get-data="listCompany"
											:query-name="queryCompanyGive"
											query-info="companyName"
											query-label="供应商查找"
											@commitBack="handleCommitBackCompanyGive"
											@update:queryName="handleQueryCompanyGive"
											:disabled="!form.unitPrice"
										>
											<template #table-columns>
												<el-table-column label="供应商" align="center" prop="companyName" />
												<el-table-column label="地址" align="center" prop="address" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>
							<!-- 重箱值 -->
							<el-form-item label="重箱值" prop="weightBox" v-if="areaOrWeightBox === RebateType.Weight">
								<el-input :value="calculatedWeightBox" placeholder="根据订单自动计算" disabled />
							</el-form-item>
							<!-- 面积值 -->
							<el-form-item label="面积值" prop="area" v-if="areaOrWeightBox === RebateType.Square">
								<el-input :value="calculatedArea" placeholder="根据订单自动计算" disabled />
							</el-form-item>

							<!-- 金额 -->
							<el-form-item label="金额" prop="rebate">
								<el-input v-model="calculatedRebate" placeholder="请输入金额" :disabled="!form.unitPrice" />
							</el-form-item>
							<!-- 返利原因 -->
							<el-form-item label="返利原因" prop="rebateReason">
								<el-input v-model="form.rebateReason" placeholder="请输入返利原因" :disabled="!form.unitPrice" />
							</el-form-item>

							<!-- 备注 -->
							<el-form-item label="备注" prop="comments">
								<el-input v-model="form.comments" placeholder="请输入备注" :disabled="!form.unitPrice" />
							</el-form-item>
						</el-col>
					</el-row>
				</el-form>
			</el-row>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    选择订单详情 点击返利货物后面的选择订单打开的弹窗 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="true" title="订单选择" :visible.sync="orderDialogVisible" width="65%">
			<el-row>
				<el-button type="primary" size="mini" @click="selectBySupplier">根据供应商选择</el-button>
				<el-button type="primary" size="mini" @click="handleOpenSelectOrder">选择订单</el-button>
			</el-row>
			<hr />
			<el-row>
				<el-row>
					<!--  展示订单信息的组件  orderInfo-->
					<OrderInfos :orderInfo="orderInfo" />
				</el-row>
				<el-row>
					<el-row>
						<span style="font-weight: bolder">货物详情列表</span>
					</el-row>
					<!-- 订单选择的货物-->
					<el-row>
						<el-button :disabled="goods.length === 0" type="success" size="mini" @click="submitSelectOrderDetail">选择所选货物</el-button>
						<el-table
							ref="multipleTable"
							border
							:data="orderDetailList"
							max-height="700"
							size="mini"
							:cell-style="
								() => {
									return { padding: '.5px' };
								}
							"
							:row-class-name="getRowClassName"
							@selection-change="handleSelectionChangeOrderDetail"
						>
							<el-table-column type="selection" width="55" align="center" fixed="left" :selectable="checkSupplierSelectable" />
							<el-table-column label="订单日期" align="center" prop="orderDate" fixed="left" />
							<el-table-column label="客户" align="center" prop="customer" />
							<el-table-column label="供应商" align="center" prop="supplier" :filters="nameFilters" :filter-method="filterName" filter-placement="bottom" filterable />
							<el-table-column label="级别名称" align="center" prop="levelName" width="150" />
							<el-table-column label="计量单位" align="center" prop="countingUnit" />
							<el-table-column label="厚度" align="center" prop="height" />
							<el-table-column label="长度" align="center" prop="length" />
							<el-table-column label="宽度" align="center" prop="width" />
							<el-table-column label="出厂片数" align="center" prop="pieces" />
							<el-table-column label="每包片数" align="center" prop="piecesPerPack" />
							<el-table-column label="包数" align="center" prop="packs" />
							<el-table-column label="出厂单价" align="center" prop="price" />
							<el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory">
								<template slot-scope="scope">
									<el-tag disable-transitions>{{ scope.row.isIncludeTaxFactory === 0 ? '否' : '是' }}</el-tag>
								</template>
							</el-table-column>
							<el-table-column label="杂费" align="center" prop="sundryCost" />
							<el-table-column label="出厂货款" align="center" prop="paymentFactory" />
							<el-table-column label="卸货价" align="center" prop="paymentUnload" />
							<el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale">
								<template slot-scope="scope">
									<el-tag disable-transitions>{{ scope.row.isIncludeTaxSale === 0 ? '否' : '是' }}</el-tag>
								</template>
							</el-table-column>
							<el-table-column label="总货款" align="center" prop="payments" />
							<el-table-column label="误差" align="center" prop="erro" />
							<el-table-column label="吨位" align="center" prop="tonnage" />
							<el-table-column label="陆运费单价" align="center" prop="landFreightPrice" />
							<el-table-column label="陆运费" align="center" prop="landFreight" />
							<el-table-column label="海运费" align="center" prop="seaFreight" />
							<el-table-column label="总运费" align="center" prop="freight" />
							<el-table-column label="其他费用" align="center" prop="otherCost" />
							<el-table-column label="利润" align="center" prop="profit" />
							<el-table-column label="不含税利润" align="center" prop="profitNoTax" />
							<el-table-column label="卸货片数" align="center" prop="actualPieces" />
							<el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" />
							<el-table-column label="加费" align="center" prop="additionalFees" />
							<el-table-column label="仓库名称" align="center" prop="storeHouseName" />
							<el-table-column label="物流利润" align="center" prop="logisticsProfit" />
							<el-table-column label="客户佣金" align="center" prop="customerCommission" />
						</el-table>
					</el-row>
				</el-row>
			</el-row>
		</el-dialog>

		<!--    两种方式中点击第二种直接选择订单进行返利-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="true" title="选择订单" :visible.sync="orderSelectVisible" width="70%">
			<QuerySearchBar @updateQuery="handleGetQueryParams" />
			<el-table
				v-loading="loading"
				fit
				border
				:data="selectOrdersList"
				max-height="750"
				size="mini"
				:cell-style="
					() => {
						return { padding: '2px' };
					}
				"
				@selection-change="handleSelectionChangeOrders"
			>
				<el-table-column show-overflow-tooltip label="行操作" align="center" class-name="small-padding fixed-width" width="200px" fixed="left">
					<template slot-scope="scope">
						<el-button size="mini" type="text" @click="handleSelectOrderItem(scope.row)">选择</el-button>
						<el-button size="mini" type="text" @click="checkOrderInfo(scope.row)">查看订单</el-button>
					</template>
				</el-table-column>
				<el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left" />
				<el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left" />
				<el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left" />
				<!--        供应商可筛选 多选-->
				<el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left" />
				<el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" />
				<el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel" width="100px" />
				<el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName" width="100px" />
				<el-table-column show-overflow-tooltip label="柜号" align="center" prop="seaCarNo">
					<template #default="scope">
						{{ isNull(scope.row.seaCarNo) }}
					</template>
				</el-table-column>
				<el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel">
					<template #default="scope">
						{{ isNull(scope.row.seaDriverTel) }}
					</template>
				</el-table-column>
				<el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="100px">
					<template #default="scope">
						{{ isNull(scope.row.seaDriverTel) }}
					</template>
				</el-table-column>
				<el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager" />
				<el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" />
				<el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120"></el-table-column>
				<el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState" width="120px"></el-table-column>
				<!--				<el-table-column show-overflow-tooltip label="打款状态" align="center" prop="paymentState" width="120px"></el-table-column>-->
				<el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" />
			</el-table>
			<pagination v-show="orderTotal > 0" :total="orderTotal" :page.sync="queryOrderParams.pageNum" :limit.sync="queryOrderParams.pageSize" @pagination="selectOrderItem" />
		</el-dialog>

		<!--    查看已经选择的货物-->
		<InfoDialog title="已选择货物" :visible.sync="orderGoodsVisible" @update:visible="orderGoodsVisible = false">
			<template #info>
				<!--        订单货物详情的展示组件-->
				<OrderDetailInfo :orderDetailInfoList="goods" :ban="true" />
			</template>
		</InfoDialog>

		<!--    查看订单信息-->
		<InfoDialog title="查看订单信息" :visible.sync="orderVisible" @update:visible="orderVisible = false">
			<template #info>
				<OrderInfos :orderInfo="checkOrderInformation" />
				<OrderDetailInfo :orderDetailInfoList="checkOrderInformation.orderDetailList" :ban="true" />
			</template>
		</InfoDialog>

		<!--    根据供应商选择订单-->
		<InfoDialog title="根据供应商选择订单" :visible.sync="orderBySupplierVisible" @update:visible="orderBySupplierVisible = false" width="500px">
			<template #info>
				<div>
					<el-row style="text-align: center">
						<el-form :model="queryParamsSupplier" size="mini" :inline="true" label-width="68px">
							<el-form-item label="供应商">
								<el-row>
									<el-col :span="20">
										<el-input v-model="queryParamsSupplier.supplier" placeholder="请输入供应商" />
									</el-col>
									<el-col :span="4">
										<SearchOption
											:get-data="listCompany"
											:limit-info="{
												companyType: '供应商'
											}"
											:query-name="queryCompany"
											query-info="companyName"
											query-label="供应商查找"
											@update:queryName="value => (queryCompany = value)"
											@commitBack="handleCommitCompany"
										>
											<template #table-columns>
												<el-table-column label="供应商" align="center" prop="companyName" />
												<el-table-column label="老板姓名" align="center" prop="leader" />
												<el-table-column label="老板电话" align="center" prop="leaderTel" />
												<el-table-column label="开户行" align="center" prop="bankName" />
												<el-table-column label="开户名" align="center" prop="acountsName" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>
							<el-form-item label="开始时间">
								<el-date-picker v-model="queryParamsSupplier.params.beginTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd"></el-date-picker>
							</el-form-item>
							<el-form-item label="结束时间">
								<el-date-picker v-model="queryParamsSupplier.params.endTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd"></el-date-picker>
							</el-form-item>
						</el-form>
					</el-row>
					<el-row style="text-align: center; margin-top: 15px">
						<el-button type="primary" @click="handleCommitSupplier">确定</el-button>
					</el-row>
				</div>
			</template>
		</InfoDialog>

		<!--    订单货物列表-->
		<InfoDialog title="根据供应商所选货物列表" :visible.sync="orderGoodsListVisible" @update:visible="orderGoodsListVisible = false">
			<template #info>
				<OrderDetailList :order-detail-list="needToSelectOrderDetailList" :total="orderDetailTotal" @handleSelect="handleSelectOrderDetailChange" @handleQuery="value => getDetailBySupper(value)" />
			</template>
		</InfoDialog>

		<!-- 返利弹窗 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" title="返利" :visible.sync="rebateDialogVisible" width="500px" append-to-body>
			<el-form ref="rebateForm" :model="rebateForm" :rules="rebateFormRules" label-width="120px">
				<el-form-item label="返利金额" prop="amount">
					<el-input v-model="rebateForm.amount" type="number" placeholder="请输入返利金额" clearable>
						<template slot="append">元</template>
					</el-input>
				</el-form-item>
				<el-form-item label="返利日期" prop="date">
					<el-date-picker v-model="rebateForm.date" type="datetime" placeholder="请选择返利日期时间" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%"></el-date-picker>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button @click="rebateDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="submitRebateForm">确 定</el-button>
			</div>
		</el-dialog>

		<!-- 返利流水查看对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" title="返利流水账" :visible.sync="rebateDetailDialogVisible" width="800px" append-to-body>
			<el-table :data="rebateDetailList" style="width: 100%" show-summary border :summary-method="getRebateDetailSummaries" size="mini">
				<el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
				<el-table-column prop="actualReceived" label="实收" align="center" width="120">
					<template #default="scope">
						<span class="money">{{ scope.row.actualReceived }}</span>
					</template>
				</el-table-column>
				<el-table-column prop="actualReceivedDate" label="实收日期" align="center" width="180"></el-table-column>
				<el-table-column prop="comment" label="备注" align="center" show-overflow-tooltip></el-table-column>
				<el-table-column label="操作" align="center" width="150" fixed="right">
					<template #default="scope">
						<el-button size="mini" type="primary" @click="handleEditRebateDetail(scope.row, scope.$index)">修改</el-button>
						<el-button size="mini" type="danger" @click="handleDeleteRebateDetail(scope.row, scope.$index)">删除</el-button>
					</template>
				</el-table-column>
			</el-table>
			<div slot="footer" class="dialog-footer">
				<el-button @click="rebateDetailDialogVisible = false">关 闭</el-button>
			</div>
		</el-dialog>

		<!-- 修改返利流水对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" title="修改返利流水" :visible.sync="editRebateDetailDialogVisible" width="500px" append-to-body>
			<el-form ref="editRebateDetailForm" :model="editRebateDetailForm" :rules="rebateFormRules" label-width="120px">
				<el-form-item label="返利金额" prop="amount">
					<el-input v-model="editRebateDetailForm.amount" type="number" placeholder="请输入返利金额" clearable>
						<template slot="append">元</template>
					</el-input>
				</el-form-item>
				<el-form-item label="返利日期" prop="date">
					<el-date-picker v-model="editRebateDetailForm.date" type="datetime" placeholder="请选择返利日期时间" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%"></el-date-picker>
				</el-form-item>
				<el-form-item label="备注">
					<el-input v-model="editRebateDetailForm.comment" type="textarea" placeholder="请输入备注" :rows="3"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button @click="editRebateDetailDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="submitEditRebateDetail">确 定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listRebate, getRebate, delRebate, addRebate, updateRebate } from '@/api/system/Rebate';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { RebateType, TableName } from '@/api/tool/enums';
import { fix } from '@/api/tool/format';
import OrderInfos from '@/views/dashboard/components/goodsOrder/OrderInfos.vue';
import OrderDetailInfo from '@/views/dashboard/components/goodsOrder/OrderDetailInfo.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import { listCompany } from '@/api/system/company';
import SearchOption from '@/components/SearchOption.vue';
import InfoDialog from '../../../components/InfoDialog.vue';
import OrderDetailList from '../../dashboard/components/rebate/OrderDetailList.vue';
import { mixin_choose_order } from '../../dashboard/mixins/rebate/choose_order';
import { mixin_rebate_fill } from '../../dashboard/mixins/rebate/rebate_fill';
import { isNull } from '../../../main';
import { listOrderDetailByIds } from '@/api/system/orderDetail';
import { mixin_bankType } from '../../dashboard/mixins/common/common_bankType';
import { getUuid } from '../../../utils/trash/utils';
import { parseTime } from '../../../utils/ruoyi';
import QuerySearchBar from '../../dashboard/components/goodsOrder/QuerySearchBar.vue';
import _ from 'lodash';

export default {
	name: 'Rebate',
	components: {
		QuerySearchBar,
		OrderDetailList,
		InfoDialog,
		SearchOption,
		OrderDetailInfo,
		OrderInfos
	},
	mixins: [mixin_printHTML, mixin_choose_order, mixin_rebate_fill, mixin_bankType],
	data() {
		return {
			// 遮罩层
			loading: true,
			// 选中数组
			ids: [],
			// 非单个禁用
			single: true,
			// 非多个禁用
			multiple: true,
			// 当前选中的供应商（用于一致性检查）
			currentSelectedSupplier: null,
			// 计提返利时间段选择（前端使用，用于时间段组件绑定）
			rebateDateRange: null,
			// 收到返利时间段选择（前端使用，用于时间段组件绑定）
			receivedRebateDateRange: null,
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 弹出的订单列表页的总条数
			orderTotal: 0,
			// 返利回扣表格数据
			RebateList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				ordersNo: null,
				rebateDate: null,
				rebate: null,
				rebateType: null,
				inAcountsName: null,
				inBankNo: null,
				supplier: null,
				supplierID: null,
				outAcountsName: null,
				outBankNo: null,
				rebateReason: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				// 删除了不需要的级别名称、长度、宽度、厚度搜索参数
				params: {
					// 计提返利时间参数移到params中
					rebateStartTime: null,
					rebateEndTime: null,
					// 收到返利时间参数（精确到时分秒）
					receivedRebateStartTime: null,
					receivedRebateEndTime: null,
					// 是否收到返利筛选框 Y/N
					isReceivedRebate: null
				}
			},
			queryOrderParams: {
				pageNum: 1,
				pageSize: 20
			},
			// 表单参数
			form: {},
			rebateTypes: [
				{
					value: '返利',
					label: '返利'
				},
				{
					value: '降价',
					label: '降价'
				},
				{
					value: '售后质量赔偿',
					label: '售后质量赔偿'
				}
			],
			// 表单校验
			rules: {
				unitPrice: [
					{
						required: true,
						message: '单价不能为空',
						trigger: 'blur'
					}
				],
				rebateDate: [
					{
						required: true,
						message: '返利日期不能为空',
						trigger: 'blur'
					}
				],
				rebate: [
					{
						required: true,
						message: '返利金额不能为空',
						trigger: 'blur'
					}
				],
				rebateType: [
					{
						required: true,
						message: '返利类型不能为空',
						trigger: 'change'
					}
				],
				inAcountsName: [
					{
						required: true,
						message: '收款户名不能为空',
						trigger: 'blur'
					}
				],
				inBankNo: [
					{
						required: true,
						message: '收款账号不能为空',
						trigger: 'blur'
					}
				],
				supplier: [
					{
						required: true,
						message: '供应商不能为空',
						trigger: 'blur'
					}
				],
				outAcountsName: [
					{
						required: true,
						message: '付款户名不能为空',
						trigger: 'blur'
					}
				],
				outBankNo: [
					{
						required: true,
						message: '付款账号不能为空',
						trigger: 'blur'
					}
				],
				rebateReason: [
					{
						required: true,
						message: '请输入返利原因!',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `计提返利日期`, visible: true },
				{ key: 1, label: `类型`, visible: true },
				{ key: 2, label: `供应商`, visible: true },
				{ key: 3, label: `返利方式`, visible: true },
				{ key: 4, label: `（返利/降价）单价`, visible: true },
				{ key: 5, label: `金额`, visible: true },
				{ key: 6, label: `返利原因`, visible: true },
				{ key: 7, label: `收到返利日期`, visible: true },
				{ key: 8, label: `收到返利金额`, visible: true }
			],
			// 订单详情列表 级联
			orderDetailList: [],
			orderDialogVisible: false,
			// 订单个人信息和订单详情信息
			orderInfo: {},
			// 搜索供应商
			queryCompanyGive: '',
			queryCompany: '',

			// 订单选择的框
			selectOrdersList: [],

			// 选择重箱还是面积
			areaOrWeightBox: RebateType.Weight,
			// 是否手动编辑过金额
			isManualEditRebate: false,
			// 返利弹窗相关
			rebateDialogVisible: false,
			currentRebateRow: null, // 当前正在处理的返利行数据
			rebateForm: {
				amount: '',
				date: ''
			},
			rebateFormRules: {
				amount: [
					{ required: true, message: '请输入返利金额', trigger: 'blur' },
					{ pattern: /^\d+(\.\d+)?$/, message: '请输入正确的数字', trigger: 'blur' }
				],
				date: [{ required: true, message: '请选择返利日期', trigger: 'change' }]
			},
			// 返利流水查看相关
			rebateDetailDialogVisible: false,
			rebateDetailList: [], // 返利流水列表
			currentRebateData: null, // 当前返利记录的完整数据（用于更新）
			// 修改返利流水相关
			editRebateDetailDialogVisible: false,
			editRebateDetailForm: {
				amount: '',
				date: '',
				comment: ''
			},
			currentEditIndex: -1 // 当前正在编辑的流水记录索引
		};
	},
	computed: {
		RebateType() {
			return RebateType;
		},
		TableName() {
			return TableName;
		},
		// 计算面积值
		calculatedArea() {
			if (_.isEmpty(this.goods)) {
				return 0;
			}
			return this.goods.reduce((sum, item) => {
				return sum + (item.length * item.width * item.pieces) / 1000000;
			}, 0);
		},
		// 计算重箱值
		calculatedWeightBox() {
			if (_.isEmpty(this.goods)) {
				return 0;
			}
			return this.goods.reduce((sum, item) => {
				return sum + (item.height * item.length * item.width * item.pieces) / 1000000 / 20;
			}, 0);
		},
		// 计算返利金额（支持手动编辑）
		calculatedRebate: {
			get() {
				// 如果手动编辑过，返回手动值
				if (this.isManualEditRebate) {
					return this.form.rebate || 0;
				}
				// 否则返回计算值
				if (_.isEmpty(this.goods) || !this.form.unitPrice || !this.form.rebateMethod) {
					return this.form.rebate || 0;
				}
				const baseValue = this.form.rebateMethod === this.RebateType.Weight ? this.calculatedWeightBox : this.calculatedArea;
				return fix(baseValue * this.form.unitPrice);
			},
			set(value) {
				this.form.rebate = value;
				// 计算当前应该的值
				let expectedValue = 0;
				if (!_.isEmpty(this.goods) && this.form.unitPrice && this.form.rebateMethod) {
					const baseValue = this.form.rebateMethod === this.RebateType.Weight ? this.calculatedWeightBox : this.calculatedArea;
					expectedValue = fix(baseValue * this.form.unitPrice);
				}
				// 如果用户输入的值与计算值不同，标记为手动编辑
				this.isManualEditRebate = Number(value) !== expectedValue;
			}
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('rebate-columns') === 'null' || !localStorage.getItem('rebate-columns')) {
			// 设置localStorage
			localStorage.setItem('rebate-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('rebate-columns'));
		}
	},
	methods: {
		isNull,
		listCompany,
		listBankAccount,
		// 为不同供应商的行添加样式
		getRowClassName({ row, rowIndex }) {
			// 如果有选中的供应商，且当前行的供应商不匹配，添加禁用样式
			if (this.currentSelectedSupplier && row.supplier !== this.currentSelectedSupplier) {
				return 'disabled-row';
			}
			return '';
		},
		// 供应商一致性检查 - 控制checkbox是否可选
		checkSupplierSelectable(row, index) {
			// 如果还没有选中任何货物，所有行都可选
			if (!this.currentSelectedSupplier) {
				return true;
			}
			// 如果已经选中了供应商，只有相同供应商的行才可选
			return row.supplier === this.currentSelectedSupplier;
		},
		// 重写mixin中的多选某个货物方法，添加供应商一致性检查
		handleSelectionChangeOrderDetail(selection) {
			// 如果没有选中任何货物，清空当前供应商
			if (_.isEmpty(selection)) {
				this.currentSelectedSupplier = null;
				this.goods = [];
				return;
			}

			// 如果是第一次选择，设置当前供应商
			if (!this.currentSelectedSupplier) {
				this.currentSelectedSupplier = selection[0].supplier;
			}

			// 过滤出相同供应商的货物
			const validSelection = selection.filter(item => item.supplier === this.currentSelectedSupplier);

			// 如果过滤后的选择与原选择不同，说明有跨供应商选择，需要提示用户
			if (validSelection.length !== selection.length) {
				this.$message.warning(`只能选择供应商为"${this.currentSelectedSupplier}"的货物，已自动过滤其他供应商的货物`);

				// 重新设置表格选择状态
				this.$nextTick(() => {
					this.$refs.multipleTable.clearSelection();
					validSelection.forEach(row => {
						this.$refs.multipleTable.toggleRowSelection(row, true);
					});
				});
			}

			this.goods = validSelection;
		},
		// 重写mixin中的清空已选择的货物方法，添加供应商状态重置
		refreshSelectedGoods() {
			this.goods = [];
			this.form.orderDetailIds = [];
			// 重置当前选中的供应商
			this.currentSelectedSupplier = null;
			// 调用mixin中的toggleSelection方法
			if (this.$refs.multipleTable) {
				this.$refs.multipleTable.clearSelection();
			}
		},
		// 重写mixin中的确认选择货物方法，添加供应商自动填充功能
		submitSelectOrderDetail() {
			this.form.orderDetailIds = [];
			if (_.isEmpty(this.goods)) {
				this.$message.info('请选择货物');
				return;
			}

			// 自动填充供应商信息（基于已选择的货物）
			if (this.currentSelectedSupplier) {
				this.form.supplier = this.currentSelectedSupplier;

				// 尝试找到供应商ID（如果货物数据中包含supplierID）
				const firstGood = this.goods[0];
				if (firstGood.supplierID) {
					this.form.supplierID = firstGood.supplierID;
				}

				this.$message.success(`已自动填充供应商：${this.currentSelectedSupplier}`);
			}

			// 推入id数组
			this.form.orderDetailIds = this.goods.map(item => item.id);

			// 更新返利方式对应的显示变量
			this.areaOrWeightBox = this.form.rebateMethod;

			// 更新面积和重箱值到表单（用于提交）
			if (this.form.rebateMethod === this.RebateType.Weight) {
				this.form.weightBox = this.calculatedWeightBox;
			} else {
				this.form.area = this.calculatedArea;
			}

			// 重置手动编辑标志，使用自动计算
			this.isManualEditRebate = false;
			// 更新金额（使用计算属性的值）
			this.form.rebate = this.calculatedRebate;

			// 关闭对话框
			this.orderDialogVisible = false;

			// 重置供应商选择状态
			this.currentSelectedSupplier = null;
		},
		// 获取最早的返利日期
		getEarliestReceivedDate(row) {
			const detailList = _.get(row, 'actualReceivedDetails.detailList', []);
			if (_.isEmpty(detailList)) {
				return '未收到';
			}

			const dates = detailList
				.map(item => item.actualReceivedDate)
				.filter(Boolean)
				.sort();

			return _.isEmpty(dates) ? '未收到' : dates[0];
		},
		// 计算返利金额总和
		getTotalReceivedAmount(row) {
			const detailList = _.get(row, 'actualReceivedDetails.detailList', []);
			if (_.isEmpty(detailList)) {
				return 0;
			}

			return detailList.reduce((total, item) => {
				return total + (Number(item.actualReceived) || 0);
			}, 0);
		},
		handleCommitBackCompanyGive(val) {
			this.form.supplier = val.companyName;
			this.form.supplierID = val.id;
		},
		handleQueryCompanyGive(val) {
			this.queryCompanyGive = val;
		},
		// 表格中的表头 筛选方法 主要是为了筛选供应商
		filterName(value, row) {
			return row.supplier === value;
		},
		/**
		 * 返利按钮逻辑分析：
		 * 1. 保存当前返利记录行数据到 currentRebateRow
		 * 2. 重置返利表单（金额和日期）
		 * 3. 打开返利弹窗，用户输入返利金额和日期
		 * 4. 提交时调用 submitRebateForm，会：
		 *    - 获取完整的返利数据（包含已有的流水记录）
		 *    - 计算累计返利金额
		 *    - 检查是否需要备注（单次或累计金额超过原金额）
		 *    - 创建新的流水记录项（包含uuid、金额、日期、备注）
		 *    - 将新记录添加到 actualReceivedDetails.detailList 数组
		 *    - 调用 updateRebate 更新整个返利记录
		 */
		handleRebate(row) {
			// 保存当前行数据
			this.currentRebateRow = row;
			// 重置表单
			this.rebateForm = {
				amount: '',
				date: ''
			};
			// 打开弹窗
			this.rebateDialogVisible = true;
			// 清除表单验证
			this.$nextTick(() => {
				if (this.$refs.rebateForm) {
					this.$refs.rebateForm.clearValidate();
				}
			});
		},
		/**
		 * 提交返利表单
		 * 将返利金额和日期推入当前数据的detailList中，并调用修改接口
		 */
		submitRebateForm() {
			this.$refs.rebateForm.validate(valid => {
				if (valid) {
					const row = this.currentRebateRow;
					const currentAmount = Number(this.rebateForm.amount);
					const date = this.rebateForm.date;

					if (!row || !row.id) {
						this.$message.error('数据错误，请重新操作');
						return;
					}

					// 获取完整的返利数据
					getRebate(row.id).then(res => {
						if (!res.data) {
							this.$message.error('暂无该条数据');
							return;
						}

						const originalAmount = res.data.rebate || row.rebate; // 原返利金额

						// 获取已有的流水列表
						const existingDetailList = _.get(res.data, 'actualReceivedDetails.detailList', []) || [];
						
						// 计算已累计返利金额
						const existingTotal = existingDetailList.reduce((sum, item) => {
							return sum + (Number(item.actualReceived) || 0);
						}, 0);

						const newTotal = existingTotal + currentAmount;

						// 检查是否需要备注：单次金额超标或累计金额超标
						const needRemark = currentAmount > originalAmount || newTotal > originalAmount;

						/**
						 * 处理返利逻辑
						 * @param {string} remark - 备注信息
						 */
						const processRebate = (remark = '') => {
							// 创建新的流水记录项
							const newItem = {
								uuid: getUuid(),
								actualReceived: currentAmount,
								actualReceivedDate: date, // date已经是格式化后的字符串，不需要再转换
								comment: remark || null
							};

							// 基于完整的返利数据创建更新对象
							const body = _.cloneDeep(res.data);
							
							// 将新记录推入detailList
							body.actualReceivedDetails = {
								detailList: [...existingDetailList, newItem]
							};

							// 调用修改接口更新返利记录
							updateRebate(body).then(() => {
								this.$modal.msgSuccess('返利成功');
								this.rebateDialogVisible = false;
								// 重置表单
								this.rebateForm = {
									amount: '',
									date: ''
								};
								// 刷新列表
								this.getList();
							}).catch(error => {
								this.$message.error('返利失败：' + (error.msg || '未知错误'));
							});
						};

						// 如果需要备注，弹出输入框
						if (needRemark) {
							let remarkMessage = '';
							if (currentAmount > originalAmount && newTotal > originalAmount) {
								remarkMessage = `本次返利金额(${currentAmount})和累计返利金额(${newTotal})均超过原金额(${originalAmount})，请输入备注原因：`;
							} else if (currentAmount > originalAmount) {
								remarkMessage = `本次返利金额(${currentAmount})超过原金额(${originalAmount})，请输入备注原因：`;
							} else if (newTotal > originalAmount) {
								remarkMessage = `累计返利金额(${newTotal})超过原金额(${originalAmount})，请输入备注原因：`;
							}

							this.$prompt(remarkMessage, '需要备注', {
								confirmButtonText: '确定',
								cancelButtonText: '取消',
								inputType: 'textarea',
								inputValidator: val => {
									return val && val.trim().length > 0;
								},
								inputErrorMessage: '请输入备注原因'
							})
								.then(({ value: remarkValue }) => {
									processRebate(remarkValue);
								})
								.catch(() => {
									this.$modal.msgError('取消输入备注');
								});
						} else {
							// 不需要备注，直接处理
							processRebate();
						}
					}).catch(error => {
						this.$message.error('获取返利数据失败：' + (error.msg || '未知错误'));
					});
				}
			});
		},
		/**
		 * 查询返利流水账
		 * 获取返利记录的完整数据，显示流水列表，支持修改和删除操作
		 */
		handleRebateDetail(row) {
			getRebate(row.id).then(res => {
				if (!res.data) {
					this.$modal.msgError('暂无该条数据');
					return;
				}
				const detailList = _.get(res.data, 'actualReceivedDetails.detailList', []);
				if (_.isEmpty(detailList)) {
					this.$modal.msgError('没有返利流水账');
					return;
				}
				// 保存完整的返利数据，用于后续更新
				this.currentRebateData = _.cloneDeep(res.data);
				// 保存流水列表
				this.rebateDetailList = detailList;
				// 打开流水查看对话框
				this.rebateDetailDialogVisible = true;
			});
		},
		/**
		 * 计算返利流水表格合计
		 */
		getRebateDetailSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
				} else if (column.property === 'actualReceived') {
					const values = data.map(item => Number(item.actualReceived) || 0);
					sums[index] = values.reduce((prev, curr) => {
						return prev + curr;
					}, 0);
				} else {
					sums[index] = '';
				}
			});
			return sums;
		},
		/**
		 * 修改返利流水记录
		 * 打开编辑弹窗，填充当前记录的数据
		 */
		handleEditRebateDetail(row, index) {
			this.currentEditIndex = index;
			this.editRebateDetailForm = {
				amount: String(row.actualReceived || ''),
				date: row.actualReceivedDate || '',
				comment: row.comment || ''
			};
			this.editRebateDetailDialogVisible = true;
			// 清除表单验证
			this.$nextTick(() => {
				if (this.$refs.editRebateDetailForm) {
					this.$refs.editRebateDetailForm.clearValidate();
				}
			});
		},
		/**
		 * 提交修改返利流水
		 * 更新流水列表中的对应项，然后调用 updateRebate 更新整个返利记录
		 */
		submitEditRebateDetail() {
			this.$refs.editRebateDetailForm.validate(valid => {
				if (valid) {
					if (this.currentEditIndex < 0 || !this.currentRebateData) {
						this.$modal.msgError('数据错误，请重新操作');
						return;
					}

					const currentAmount = Number(this.editRebateDetailForm.amount);
					const originalAmount = this.currentRebateData.rebate; // 原返利金额

					// 计算修改后的累计返利金额
					const detailList = _.cloneDeep(this.rebateDetailList);
					// 临时移除当前编辑的项，计算其他项的累计金额
					const otherTotal = detailList
						.filter((item, idx) => idx !== this.currentEditIndex)
						.reduce((sum, item) => {
							return sum + (Number(item.actualReceived) || 0);
						}, 0);
					const newTotal = otherTotal + currentAmount;

					// 检查是否需要备注
					const needRemark = currentAmount > originalAmount || newTotal > originalAmount;

					const processUpdate = (remark = '') => {
						// 更新流水列表中的对应项
						detailList[this.currentEditIndex] = {
							...detailList[this.currentEditIndex],
							actualReceived: currentAmount,
							actualReceivedDate: this.editRebateDetailForm.date,
							comment: remark || this.editRebateDetailForm.comment || null
						};

						// 更新返利数据
						const body = _.cloneDeep(this.currentRebateData);
						body.actualReceivedDetails = {
							detailList: detailList
						};

						updateRebate(body).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.editRebateDetailDialogVisible = false;
							// 更新本地流水列表
							this.rebateDetailList = detailList;
							// 刷新主列表
							this.getList();
						});
					};

					if (needRemark) {
						let remarkMessage = '';
						if (currentAmount > originalAmount && newTotal > originalAmount) {
							remarkMessage = `本次返利金额(${currentAmount})和累计返利金额(${newTotal})均超过原金额(${originalAmount})，请输入备注原因：`;
						} else if (currentAmount > originalAmount) {
							remarkMessage = `本次返利金额(${currentAmount})超过原金额(${originalAmount})，请输入备注原因：`;
						} else if (newTotal > originalAmount) {
							remarkMessage = `累计返利金额(${newTotal})超过原金额(${originalAmount})，请输入备注原因：`;
						}

						this.$prompt(remarkMessage, '需要备注', {
							confirmButtonText: '确定',
							cancelButtonText: '取消',
							inputType: 'textarea',
							inputValidator: val => {
								return val && val.trim().length > 0;
							},
							inputErrorMessage: '请输入备注原因'
						})
							.then(({ value: remarkValue }) => {
								processUpdate(remarkValue);
							})
							.catch(() => {
								this.$modal.msgError('取消输入备注');
							});
					} else {
						processUpdate();
					}
				}
			});
		},
		/**
		 * 删除返利流水记录
		 * 从流水列表中删除对应项，然后调用 updateRebate 更新整个返利记录
		 */
		handleDeleteRebateDetail(row, index) {
			this.$modal
				.confirm(`是否确认删除该条返利流水记录？金额：${row.actualReceived}元，日期：${row.actualReceivedDate}`)
				.then(() => {
					if (!this.currentRebateData) {
						this.$modal.msgError('数据错误，请重新操作');
						return;
					}

					// 从流水列表中删除对应项
					const detailList = _.cloneDeep(this.rebateDetailList);
					detailList.splice(index, 1);

					// 更新返利数据
					const body = _.cloneDeep(this.currentRebateData);
					body.actualReceivedDetails = {
						detailList: detailList
					};

					updateRebate(body).then(() => {
						this.$modal.msgSuccess('删除成功');
						// 更新本地流水列表
						this.rebateDetailList = detailList;
						// 如果删除后列表为空，关闭对话框
						if (_.isEmpty(detailList)) {
							this.rebateDetailDialogVisible = false;
						}
						// 刷新主列表
						this.getList();
					});
				})
				.catch(() => {});
		},
		// 订单选择的搜索模组
		handleGetQueryParams(value) {
			this.queryOrderParams = value;
			this.selectOrderItem();
		},
		/** 查询返利回扣列表 */
		getList() {
			this.loading = true;
			listRebate(this.queryParams).then(response => {
				this.RebateList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},

		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				orderDetailIds: [],
				rebateDate: null,
				rebate: null,
				rebateType: null,
				// 我方银行卡账户类型
				selfBankCardType: null,
				inAcountsName: null,
				inBankNo: null,
				supplier: null,
				supplierID: null,
				// 对方银行卡账户的类型
				otherBankCardType: null,
				outAcountsName: null,
				outBankNo: null,
				rebateReason: null,
				unitPrice: null,
				weightBox: null,
				area: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.goods = [];
			// 重置当前选中的供应商
			this.currentSelectedSupplier = null;
			// 重置手动编辑标志
			this.isManualEditRebate = false;
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			// 处理计提返利时间段选择数据转换（移到params中）
			if (this.rebateDateRange && this.rebateDateRange.length === 2) {
				this.queryParams.params.rebateStartTime = this.rebateDateRange[0];
				this.queryParams.params.rebateEndTime = this.rebateDateRange[1];
			} else {
				this.queryParams.params.rebateStartTime = null;
				this.queryParams.params.rebateEndTime = null;
			}

			// 处理收到返利时间段选择数据转换
			if (this.receivedRebateDateRange && this.receivedRebateDateRange.length === 2) {
				this.queryParams.params.receivedRebateStartTime = this.receivedRebateDateRange[0];
				this.queryParams.params.receivedRebateEndTime = this.receivedRebateDateRange[1];
			} else {
				this.queryParams.params.receivedRebateStartTime = null;
				this.queryParams.params.receivedRebateEndTime = null;
			}

			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.rebateDateRange = null;
			this.receivedRebateDateRange = null;
			this.resetForm('queryForm');
			this.handleQuery();
		},
		// 多选框选中数据
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加返利回扣';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			// 获取订单返利信息
			getRebate(id).then(response => {
				this.form = response.data;
				// 这里打开的时候要判断后端返回的数据 如果orderDetailIds有数据 那么要自动选择相关订单
				if (!_.isEmpty(this.form.orderDetailIds)) {
					// goods 要填充这个数组 这个是货物的id 查询货物list 筛选需要的货物
					const ids = _.cloneDeep(this.form.orderDetailIds);
					listOrderDetailByIds(ids).then(res => {
						this.goods = res.rows;
					});
					// 填充选择框
					this.form.rebateMethod = response.data.rebateMethod === 1 ? RebateType.Weight : RebateType.Square;
					this.areaOrWeightBox = this.form.rebateMethod;
				}
				// 打开修改弹窗
				this.open = true;
				this.title = '修改返利回扣';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					this.form.rebateMethod = this.form.rebateMethod === RebateType.Weight ? 1 : 2;
					if (this.form.id != null) {
						updateRebate(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.goods = [];
							this.getList();
						});
					} else {
						addRebate(this.form).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.goods = [];
							this.getList();
						});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除返利回扣编号为"' + ids + '"的数据项？')
				.then(function () {
					return delRebate(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/Rebate/export',
				{
					...this.queryParams
				},
				`Rebate_${new Date().getTime()}.xlsx`
			);
		},
		handleExport2() {
			this.download(
				'system/Rebate/export2',
				{
					...this.queryParams
				},
				`厂家(返利+降价+售后质量赔偿)_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>

<style scoped lang="scss">
.money {
	color: #e6a23c;
	font-weight: bold;
	font-size: 13px;
}

// 表格样式优化
::v-deep .el-table {
	.el-table__header {
		background-color: #fafafa;

		th {
			background-color: #fafafa !important;
			color: #606266;
			font-weight: 600;
		}
	}

	// 金额相关列的样式
	.el-table__body {
		.money {
			color: #e6a23c;
			font-weight: bold;
		}
	}

	// 禁用行样式 - 不同供应商的货物
	.disabled-row {
		background-color: #f5f7fa !important;
		color: #c0c4cc !important;

		td {
			background-color: #f5f7fa !important;
			color: #c0c4cc !important;
		}

		// 禁用状态下的文字透明度
		.el-tag {
			opacity: 0.6;
		}
	}
}
</style>
