<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="100px">
			<el-row>
				<el-form-item label="返利开始日期" prop="rebateStartTime">
					<el-date-picker v-model="queryParams.rebateStartTime" type="datetime" placeholder="选择开始时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<el-form-item label="返利结束日期" prop="rebateEndTime">
					<el-date-picker v-model="queryParams.rebateEndTime" type="datetime" placeholder="选择开始时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<el-form-item label="供应商" prop="supplier">
					<el-input v-model="queryParams.supplier" placeholder="请输入供应商" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
			</el-row>

			<el-row>
				<!--      返利允许根据产品级别搜索-->
				<el-form-item label="级别名称">
					<el-input v-model="queryParams.params.orderDetailLevelName" placeholder="请输入级别名称" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
				<el-form-item label="长度">
					<el-input v-model="queryParams.params.orderDetailLength" placeholder="请输入长度" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
				<el-form-item label="宽度">
					<el-input v-model="queryParams.params.orderDetailWidth" placeholder="请输入宽度" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
				<el-form-item label="厚度">
					<el-input v-model="queryParams.params.orderDetailHeight" placeholder="请输入厚度" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
			</el-row>

			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
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
				<!--        导出2-->
				<template #export2>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:rebate:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport2"></el-button>
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
			<!-- 日期 -->
			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="rebateDate" show-overflow-tooltip />

			<!-- 金额 -->
			<el-table-column v-if="columns[1].visible" label="金额" align="center" prop="rebate" show-overflow-tooltip />

			<!-- 类型 -->
			<el-table-column v-if="columns[2].visible" label="类型" align="center" prop="rebateType" show-overflow-tooltip />

			<!-- 供应商 -->
			<el-table-column v-if="columns[3].visible" label="供应商" align="center" prop="supplier" />

			<!-- 返利原因 -->
			<el-table-column v-if="columns[4].visible" label="返利原因" align="center" prop="rebateReason" show-overflow-tooltip />

			<!-- 返利方式 -->
			<el-table-column v-if="columns[5].visible" label="返利方式" align="center" prop="rebateMethod" show-overflow-tooltip />

			<!-- 备注 -->
			<el-table-column v-if="columns[6].visible" label="备注" align="center" prop="comments" show-overflow-tooltip />

			<!-- 返利流水 -->
			<el-table-column label="返利流水" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="handleRebateDetail(scope.row)">查看流水</el-button>
				</template>
			</el-table-column>

			<!-- 操作 -->
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150px" fixed="right">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:rebate:edit']" size="mini" type="text" @click="handleRebate(scope.row)">返利</el-button>
					<el-button v-hasPermi="['system:rebate:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:rebate:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改返利回扣对话框 -->
		<el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="50%" append-to-body>
			<el-row>
				<el-form ref="form" :model="form" :rules="rules" label-width="120px">
					<el-row>
						<el-col :span="12">
							<!-- 系数输入框 -->
							<el-form-item label="系数" prop="unitPrice">
								<el-input v-model="form.unitPrice" placeholder="请输入系数" />
							</el-form-item>

							<!--              需要进行选择 是面积值还是重箱值-->
							<el-form-item label="返利方式" prop="rebateMethod">
								<el-select v-model="form.rebateMethod" placeholder="请选择" :disabled="!form.unitPrice" @change="() => (form.rebate > 0 ? submitSelectOrderDetail() : '')">
									<el-option label="重箱" :value="1" />
									<el-option label="面积" :value="2" />
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

							<!-- 日期 -->
							<el-form-item label="日期" prop="rebateDate">
								<el-date-picker v-model="form.rebateDate" type="datetime" placeholder="日期" value-format="yyyy-MM-dd HH:mm:ss" :disabled="!form.unitPrice" />
							</el-form-item>

							<!-- 类型 -->
							<el-form-item label="类型" prop="rebateType">
								<el-select v-model="form.rebateType" placeholder="请选择" :disabled="!form.unitPrice">
									<el-option v-for="item in rebateTypes" :key="item.value" :label="item.label" :value="item.value" />
								</el-select>
							</el-form-item>

							<!-- 供应商 -->
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
							<el-form-item label="重箱值" prop="weightBox" v-if="areaOrWeightBox === 1">
								<el-input v-model="form.weightBox" placeholder="根据订单自动计算" disabled />
							</el-form-item>
							<!-- 面积值 -->
							<el-form-item label="面积值" prop="area" v-if="areaOrWeightBox === 2">
								<el-input v-model="form.area" placeholder="根据订单自动计算" disabled />
							</el-form-item>

							<!-- 金额 -->
							<el-form-item label="金额" prop="rebate">
								<el-input v-model="form.rebate" placeholder="请输入金额" :disabled="!form.unitPrice" />
							</el-form-item>
						</el-col>

						<el-col :span="12">
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
		<el-dialog :close-on-click-modal="false" :show-close="true" title="订单选择" :visible.sync="orderDialogVisible" width="65%">
			<el-row>
				<el-button type="primary" size="mini" @click="selectBySupplier">根据供应商选择</el-button>
				<el-button type="primary" size="mini" @click="selectOrderItem">选择订单</el-button>
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
							@selection-change="handleSelectionChangeOrderDetail"
						>
							<el-table-column type="selection" width="55" align="center" fixed="left" />
							<el-table-column label="订单日期" align="center" prop="orderDate" fixed="left" />
							<el-table-column label="客户" align="center" prop="customer" />
							<el-table-column label="供应商" align="center" prop="supplier" :filters="nameFilters" :filter-method="filterName" filter-placement="bottom" filterable />
							<el-table-column label="级别名称" align="center" prop="levelName" />
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
							<el-table-column label="实际片数" align="center" prop="actualPieces" />
							<el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" />
							<el-table-column label="加费" align="center" prop="additionalFees" />
							<el-table-column label="仓库名称" align="center" prop="storeHouseName" />
							<el-table-column label="物流利润" align="center" prop="logisticsProfit" />
							<el-table-column label="佣金" align="center" prop="customerCommission" />
						</el-table>
					</el-row>
				</el-row>
			</el-row>
		</el-dialog>

		<!--    两种方式中点击第二种直接选择订单进行返利-->
		<el-dialog :close-on-click-modal="false" :show-close="true" title="选择订单" :visible.sync="orderSelectVisible" width="70%">
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
				<el-table-column show-overflow-tooltip label="打款状态" align="center" prop="paymentState" width="120px"></el-table-column>
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
		<InfoDialog title="根据供应商选择订单" :visible.sync="orderBySupplierVisible" @update:visible="orderBySupplierVisible = false">
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
											@commitBack="handleCommitCompany"
										>
											<template #table-columns>
												<el-table-column label="公司名称" align="center" prop="companyName" />
												<el-table-column label="老板姓名" align="center" prop="leader" />
												<el-table-column label="老板电话" align="center" prop="leaderTel" />
												<el-table-column label="开户行" align="center" prop="bankName" />
												<el-table-column label="开户名" align="center" prop="acountsName" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>
							<el-form-item label="时间段">
								<el-date-picker
									v-model="queryParamsSupplier.dateRange"
									style="width: 240px"
									value-format="yyyy-MM-dd HH:mm:ss"
									type="daterange"
									range-separator="-"
									start-placeholder="开始日期"
									end-placeholder="结束日期"
								></el-date-picker>
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
				<OrderDetailList :order-detail-list="needToSelectOrderDetailList" @handleSelect="handleSelectOrderDetailChange" />
			</template>
		</InfoDialog>
	</div>
</template>

<script>
import { listRebate, getRebate, delRebate, addRebate, updateRebate } from '@/api/system/Rebate';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { TableName } from '@/api/tool/enums';
import { listGoodsOrder } from '@/api/system/goodsOrder';
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
			// 供应商选择的时间段
			dateRange: [],
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
				rebateEndTime: null,
				rebateStartTime: null,
				pageNum: 1,
				pageSize: 10,
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
				params: {
					orderDetailLevelName: null,
					orderDetailWidth: null,
					orderDetailHeight: null,
					orderDetailLength: null
				}
			},
			queryOrderParams: {
				pageNum: 1,
				pageSize: 10
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
						message: '系数不能为空',
						trigger: 'blur'
					},
					{ min: 0, message: '系数必须大于0', trigger: 'blur' }
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
					},
					{ min: 0, message: '返利金额必须大于0', trigger: 'blur' }
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
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `金额`, visible: true },
				{ key: 2, label: `类型`, visible: true },
				{ key: 3, label: `供应商`, visible: true },
				{ key: 4, label: `返利原因`, visible: true },
				{ key: 5, label: `返利方式`, visible: true },
				{ key: 6, label: `备注`, visible: true }
			],

			// 订单列表 级联
			orderList: [],
			// 订单详情列表 级联
			orderDetailList: [],
			orderDialogVisible: false,
			// 订单个人信息和订单详情信息
			orderInfo: {},
			queryBankAcount: '',
			// 搜索供应商
			queryCompanyGive: '',
			bankAcountSelf: '',

			// 订单选择的框
			selectOrdersList: [],

			// 选择重箱还是面积
			areaOrWeightBox: 1
		};
	},
	computed: {
		TableName() {
			return TableName;
		}
	},
	watch: {},
	created() {
		this.getList();
		// 获取订单列表 级联选择
		listGoodsOrder().then(res => {
			this.orderList = res.rows;
		});
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
		handleRebate(row) {
			this.$prompt('请输入本次返利金额', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				inputPattern: /^\d+$/,
				inputErrorMessage: '请输入正确的数字!',
				inputType: 'number'
			})
				.then(({ value }) => {
					this.$prompt('请选择返利日期', '提示', {
						confirmButtonText: '确定',
						cancelButtonText: '取消',
						inputType: 'date'
					})
						.then(({ value: date }) => {
							getRebate(row.id).then(res => {
								let rebate = res.data.actualReceivedDetails;
								let item = {
									uuid: getUuid(),
									actualReceived: Number(value),
									actualReceivedDate: parseTime(new Date(date))
								};
								let body = JSON.parse(JSON.stringify(row));
								if (rebate === null) {
									let actualReceivedDetails = {
										detailList: []
									};
									actualReceivedDetails.detailList.push(item);
									body.actualReceivedDetails = actualReceivedDetails;
								} else {
									rebate.detailList.push(item);
									body.actualReceivedDetails = {
										detailList: rebate.detailList
									};
								}
								updateRebate(body).then(() => {
									this.$modal.msgSuccess('返利成功');
								});
							});
						})
						.catch(() => {
							this.$modal.msgError('取消选择返利日期');
						});
				})
				.catch(() => {
					this.$modal.msgError('取消输入返利金额');
				});
		},
		// 查询返利流水账
		handleRebateDetail(row) {
			getRebate(row.id).then(res => {
				this.$model({
					type: 'array',
					items: res.data.actualReceivedDetails.detailList,
					array: [
						{
							prop: 'actualReceived',
							label: '实收'
						},
						{
							prop: 'actualReceivedDate',
							label: '实收日期'
						}
					],
					title: '返利流水账 '
				});
			});
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
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
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
				if (this.form.orderDetailIds?.length > 0) {
					// goods 要填充这个数组 这个是货物的id 查询货物list 筛选需要的货物
					const ids = JSON.parse(JSON.stringify(this.form.orderDetailIds));
					listOrderDetailByIds(ids).then(res => {
						this.goods = res.rows;
					});
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
