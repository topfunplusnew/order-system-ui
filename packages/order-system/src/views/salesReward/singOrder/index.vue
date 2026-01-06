<template>
	<div class="app-container">
		<div class="fixed-top-section">
			<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px" class="form-container">
				<el-form-item label="订单ID" prop="orderId">
					<el-col :span="20">
						<el-input v-model="queryParams.orderId" disabled placeholder="请选择订单" style="width: 100%" />
					</el-col>
					<el-col :span="4">
						<SearchOption :limit-info="{}" :get-data="listGoodsOrder" query-info="customer" query-label="客户名称" :query-name="querySearchGoodsOrder" @update:queryName="handleUpdateSearchGoodsOrder" @commitBack="handleCommitBackSearchGoodsOrder">
							<template #table-columns>
								<el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left" />
								<el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left" />
								<el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left" />
								<el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left" />
								<el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" />
								<el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager" />
								<el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" />
								<el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120"></el-table-column>
							</template>
						</SearchOption>
					</el-col>
				</el-form-item>
				<el-form-item label="奖励接收人" prop="rewardReceiver">
					<el-input v-model="queryParams.rewardReceiver" placeholder="请输入奖励接收人" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
				<el-form-item label="审核状态" prop="auditState">
					<el-select v-model="queryParams.auditState" placeholder="请选择审核状态" clearable>
						<el-option label="未审核" value="未审核" />
						<el-option label="已审核" value="已审核" />
					</el-select>
				</el-form-item>
				<el-form-item label="支付状态" prop="paymentStatus">
					<el-select v-model="queryParams.paymentStatus" placeholder="请选择支付状态" clearable>
						<el-option label="已支付" value="PAID" />
						<el-option label="未支付" value="UNPAID" />
					</el-select>
				</el-form-item>
				<el-form-item label="订单日期">
					<el-date-picker v-model="daterangeOrderDate" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" clearable></el-date-picker>
				</el-form-item>
				<el-form-item label="奖励日期">
					<el-date-picker v-model="daterangeRewardDate" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" clearable></el-date-picker>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
					<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
				</el-form-item>
			</el-form>
			<el-row :gutter="10" class="mb8">
				<el-col :span="1.5">
					<el-button v-hasPermi="['system:salesReward:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
				</el-col>
				<el-col :span="1.5">
					<el-button v-hasPermi="['system:salesReward:edit']" type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate">修改</el-button>
				</el-col>
				<el-col :span="1.5">
					<el-button v-hasPermi="['system:salesReward:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
				</el-col>

				<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
					<template #print>
						<el-col :span="1.5">
							<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
						</el-col>
					</template>
					<template #export>
						<el-col :span="1.5">
							<el-button v-hasPermi="['system:salesReward:export']" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
						</el-col>
					</template>
				</right-toolbar>
			</el-row>
		</div>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			:data="salesRewardList"
			show-summary
			:summary-method="getSummaries"
			border
			size="mini"
			:cell-style="
				() => {
					return { padding: '1px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" width="80" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.id }}</div>
						<span>{{ scope.row.id }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="订单ID" align="center" prop="orderId" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.orderId }}</div>
						<span>{{ scope.row.orderId }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="订单日期" align="center" prop="orderDate" width="180" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ parseTime(scope.row.orderDate, '{y}-{m}-{d} {h}:{i}:{s}') }}</div>
						<span>{{ parseTime(scope.row.orderDate, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="客户名称" align="center" prop="customerName" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.customerName }}</div>
						<span>{{ scope.row.customerName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[4].visible" label="人员身份" align="center" prop="personnelIdentity" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.personnelIdentity }}</div>
						<span>{{ scope.row.personnelIdentity }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[5].visible" label="奖励接收人" align="center" prop="rewardReceiver" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.rewardReceiver }}</div>
						<span>{{ scope.row.rewardReceiver }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="奖励原因" align="center" prop="rewardReason" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.rewardReason }}</div>
						<span>{{ scope.row.rewardReason }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[7].visible" label="订单不含税利润" align="center" prop="orderProfit" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ formatAmount(scope.row.orderProfit) }}</div>
						<span>{{ formatAmount(scope.row.orderProfit) }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="综合单车利润" align="center" prop="comprehensiveProfit" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ formatAmount(scope.row.comprehensiveProfit) }}</div>
						<span>{{ formatAmount(scope.row.comprehensiveProfit) }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[9].visible" label="利润是否达标" align="center" prop="isTargetReached" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tag :type="scope.row.isTargetReached === 1 ? 'success' : 'info'">{{ scope.row.isTargetReached === 1 ? '达标' : '未达标' }}</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="是否含税" align="center" prop="salesTaxIncluded" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tag :type="scope.row.salesTaxIncluded === 1 ? 'success' : 'info'">{{ scope.row.salesTaxIncluded === 1 ? '是' : '否' }}</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="奖励金额" align="center" prop="rewardAmount" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ formatAmount(scope.row.rewardAmount) }}</div>
						<span>{{ formatAmount(scope.row.rewardAmount) }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="实际支付金额" align="center" prop="paymentAmount" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.paymentAmount ? formatAmount(scope.row.paymentAmount) : '-' }}</div>
						<span>{{ scope.row.paymentAmount ? formatAmount(scope.row.paymentAmount) : '-' }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[13].visible" label="奖励日期" align="center" prop="rewardDate" width="180" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.rewardDate ? parseTime(scope.row.rewardDate, '{y}-{m}-{d}') : '-' }}</div>
						<span>{{ scope.row.rewardDate ? parseTime(scope.row.rewardDate, '{y}-{m}-{d}') : '-' }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[14].visible" label="审核状态" align="center" prop="auditState" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tag :type="scope.row.auditState === '已审核' ? 'success' : 'warning'">{{ scope.row.auditState }}</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[15].visible" label="审核人" align="center" prop="auditUserName" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.auditUserName || '-' }}</div>
						<span>{{ scope.row.auditUserName || '-' }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[16].visible" label="操作" align="center" class-name="small-padding fixed-width" width="400" fixed="right">
				<template #default="scope">
					<el-button size="mini" type="text" @click="handleCheckOrder(scope.row)">查看订单</el-button>
					<el-button v-hasPermi="['system:salesReward:edit']" size="mini" type="text" icon="el-icon-edit" :disabled="scope.row.auditState === '已审核'" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:salesReward:supplement']" size="mini" type="text" icon="el-icon-edit-outline" :disabled="isSupplementDisabled(scope.row)" @click="handleSupplement(scope.row)">补充信息</el-button>
					<el-button v-if="scope.row.auditState === '未审核'" v-hasPermi="['system:salesReward:audit']" size="mini" type="text" icon="el-icon-check" @click="handleAudit(scope.row, true)">审核</el-button>
					<el-button v-else v-hasPermi="['system:salesReward:audit']" size="mini" type="text" icon="el-icon-close" @click="handleAudit(scope.row, false)">取消审核</el-button>
					<el-button v-hasPermi="['system:salesReward:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改唱单奖励对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="900px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="150px">
				<el-row>
					<el-col :span="12">
						<el-form-item label="订单ID" prop="orderId">
							<el-col :span="20">
								<el-input v-model="form.orderId" disabled placeholder="请选择关联订单" />
							</el-col>
							<el-col :span="4">
								<SearchOption :limit-info="{}" :get-data="listGoodsOrder" query-info="customer" query-label="客户名称" :query-name="queryGoodsOrder" @update:queryName="handleUpdateGoodsOrder" @commitBack="handleCommitBackGoodsOrder">
									<template #table-columns>
										<el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left" />
										<el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left" />
										<el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left" />
										<el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left" />
										<el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" />
										<el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel" width="100px" />
										<el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName" width="100px" />
										<el-table-column show-overflow-tooltip label="柜号" align="center" prop="seaCarNo">
											<template #default="scope">
												{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
											</template>
										</el-table-column>
										<el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel" width="100px">
											<template #default="scope">
												{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
											</template>
										</el-table-column>
										<el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="100px">
											<template #default="scope">
												{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverName }}
											</template>
										</el-table-column>
										<el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager" />
										<el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" />
										<el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120"></el-table-column>
										<el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState" width="120px"></el-table-column>
										<el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" />
									</template>
								</SearchOption>
							</el-col>
						</el-form-item>
						<el-form-item label="订单日期" prop="orderDate">
							<el-date-picker v-model="form.orderDate" clearable type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择订单日期" style="width: 100%"></el-date-picker>
						</el-form-item>
						<el-form-item label="客户名称" prop="customerName">
							<el-input v-model="form.customerName" placeholder="请输入客户名称" />
						</el-form-item>
						<el-form-item label="人员身份" prop="personnelIdentity">
							<el-select v-model="form.personnelIdentity" placeholder="请选择人员身份" style="width: 100%">
								<el-option label="销售经理" value="销售经理" />
								<el-option label="录入员" value="录入员" />
							</el-select>
						</el-form-item>
						<el-form-item label="奖励接收人" prop="rewardReceiver">
							<el-input v-model="form.rewardReceiver" placeholder="请输入奖励接收人" />
						</el-form-item>
						<el-form-item label="奖励原因" prop="rewardReason">
							<el-input v-model="form.rewardReason" placeholder="请输入奖励原因" />
						</el-form-item>
						<el-form-item label="订单不含税利润" prop="orderProfit">
							<el-input v-model="form.orderProfit" placeholder="请输入订单不含税利润" @blur="formatAmountField('orderProfit')" style="width: 100%"></el-input>
						</el-form-item>
						<el-form-item label="厂家返利及降价合计" prop="manufacturerRebateDiscountAmount">
							<el-input v-model="form.manufacturerRebateDiscountAmount" placeholder="请输入厂家返利及降价合计" @blur="formatAmountField('manufacturerRebateDiscountAmount')" style="width: 100%"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="承兑贴息收益" prop="acceptanceDiscountProfit">
							<el-input v-model="form.acceptanceDiscountProfit" placeholder="请输入承兑贴息收益" @blur="formatAmountField('acceptanceDiscountProfit')" style="width: 100%"></el-input>
						</el-form-item>
						<el-form-item label="客户及厂家佣金合计" prop="customerManufacturerCommissionAmount">
							<el-input v-model="form.customerManufacturerCommissionAmount" placeholder="请输入客户及厂家佣金合计" @blur="formatAmountField('customerManufacturerCommissionAmount')" style="width: 100%"></el-input>
						</el-form-item>
						<el-form-item label="综合单车利润" prop="comprehensiveProfit">
							<el-input v-model="form.comprehensiveProfit" placeholder="综合单车利润" disabled style="width: 100%"></el-input>
						</el-form-item>
						<el-form-item label="是否含税" prop="salesTaxIncluded">
							<el-radio-group v-model="form.salesTaxIncluded">
								<el-radio :label="0">否</el-radio>
								<el-radio :label="1">是</el-radio>
							</el-radio-group>
						</el-form-item>
						<el-form-item label="利润是否达标" prop="isTargetReached">
							<el-radio-group v-model="form.isTargetReached">
								<el-radio :label="0">未达标</el-radio>
								<el-radio :label="1">达标</el-radio>
							</el-radio-group>
						</el-form-item>
						<el-form-item label="奖励金额" prop="rewardAmount">
							<el-input v-model="form.rewardAmount" placeholder="请输入奖励金额" @blur="formatAmountField('rewardAmount')" style="width: 100%"></el-input>
						</el-form-item>
						<el-form-item label="审核状态" prop="auditState">
							<el-select v-model="form.auditState" placeholder="请选择审核状态" style="width: 100%">
								<el-option label="未审核" value="未审核" />
								<el-option label="已审核" value="已审核" />
							</el-select>
						</el-form-item>
						<el-form-item label="备注" prop="remark">
							<el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" style="width: 100%"></el-input>
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!-- 补充信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="补充信息" :visible.sync="supplementOpen" width="500px" append-to-body>
			<el-form ref="supplementForm" :model="supplementForm" :rules="supplementRules" label-width="150px">
				<el-form-item label="实际支付金额" prop="paymentAmount">
					<el-input v-model="supplementForm.paymentAmount" placeholder="请输入实际支付金额" @blur="formatSupplementAmountField('paymentAmount')" style="width: 100%"></el-input>
				</el-form-item>
				<el-form-item label="奖励日期" prop="rewardDate">
					<el-date-picker v-model="supplementForm.rewardDate" clearable type="date" value-format="yyyy-MM-dd" placeholder="请选择奖励日期" style="width: 100%"></el-date-picker>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitSupplementForm">确 定</el-button>
				<el-button @click="cancelSupplement">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listSalesReward, getSalesReward, delSalesReward, addSalesReward, updateSalesReward, auditSalesReward, getOrderRewardData, supplementSalesReward } from '@/api/salesReward/salesReward';
import { parseTime } from '@/utils/ruoyi';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { getGoodsOrder, listGoodsOrder } from '@/api/system/goodsOrder';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
import SearchOption from '@/components/SearchOption.vue';
import { add, bignumber, format } from 'mathjs';

export default {
	name: 'SingOrderReward',
	components: { SearchOption },
	mixins: [mixin_printHTML, common_dialog],
	data() {
		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			salesRewardList: [],
			title: '',
			open: false,
			supplementOpen: false,
			supplementForm: {},
			daterangeOrderDate: [],
			daterangeRewardDate: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				incentiveType: '唱单',
				orderId: null,
				rewardReceiver: null,
				auditState: null,
				paymentStatus: null,
				orderDateBegin: null,
				orderDateEnd: null,
				rewardDateBegin: null,
				rewardDateEnd: null
			},
			form: {},
			queryGoodsOrder: '',
			querySearchGoodsOrder: '',
			orderSaleManager: null, // 订单的销售经理
			orderUserName: null, // 订单的录入人员
			rules: {
				orderId: [{ required: true, message: '请选择订单', trigger: 'change' }],
				orderDate: [{ required: true, message: '请选择订单日期', trigger: 'change' }],
				customerName: [{ required: true, message: '请输入客户名称', trigger: 'blur' }],
				personnelIdentity: [{ required: true, message: '请选择人员身份', trigger: 'change' }],
				rewardReceiver: [{ required: true, message: '请输入奖励接收人', trigger: 'blur' }],
				rewardReason: [{ required: true, message: '请输入奖励原因', trigger: 'blur' }],
				orderProfit: [
					{ required: true, message: '请输入订单不含税利润', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (value === null || value === undefined || value === '') {
								callback(new Error('请输入订单不含税利润'));
								return;
							}
							const numStr = String(value).trim();
							if (!/^-?(\d+\.?\d{0,2}|\.\d{1,2})$/.test(numStr)) {
								callback(new Error('只能输入数字，可以输入负数，小数点最多保留两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				manufacturerRebateDiscountAmount: [
					{ required: true, message: '请输入厂家返利及降价合计', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (value === null || value === undefined || value === '') {
								callback(new Error('请输入厂家返利及降价合计'));
								return;
							}
							const numStr = String(value).trim();
							if (!/^-?(\d+\.?\d{0,2}|\.\d{1,2})$/.test(numStr)) {
								callback(new Error('只能输入数字，可以输入负数，小数点最多保留两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				acceptanceDiscountProfit: [
					{ required: true, message: '请输入承兑贴息收益', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (value === null || value === undefined || value === '') {
								callback(new Error('请输入承兑贴息收益'));
								return;
							}
							const numStr = String(value).trim();
							if (!/^-?(\d+\.?\d{0,2}|\.\d{1,2})$/.test(numStr)) {
								callback(new Error('只能输入数字，可以输入负数，小数点最多保留两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				customerManufacturerCommissionAmount: [
					{ required: true, message: '请输入客户及厂家佣金合计', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (value === null || value === undefined || value === '') {
								callback(new Error('请输入客户及厂家佣金合计'));
								return;
							}
							const numStr = String(value).trim();
							if (!/^-?(\d+\.?\d{0,2}|\.\d{1,2})$/.test(numStr)) {
								callback(new Error('只能输入数字，可以输入负数，小数点最多保留两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				isTargetReached: [{ required: true, message: '请选择利润是否达标', trigger: 'change' }],
				rewardAmount: [
					{ required: true, message: '请输入奖励金额', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (value === null || value === undefined || value === '') {
								callback(new Error('请输入奖励金额'));
								return;
							}
							const numStr = String(value).trim();
							if (!/^-?(\d+\.?\d{0,2}|\.\d{1,2})$/.test(numStr)) {
								callback(new Error('只能输入数字，可以输入负数，小数点最多保留两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				auditState: [{ required: true, message: '请选择审核状态', trigger: 'change' }],
				comprehensiveProfit: [
					{
						validator: (rule, value, callback) => {
							if (value === null || value === undefined || value === '') {
								callback();
								return;
							}
							const numStr = String(value).trim();
							if (!/^-?(\d+\.?\d*|\.\d+)$/.test(numStr)) {
								callback(new Error('只能输入数字，可以输入负数'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				salesTaxIncluded: [{ required: true, message: '请选择是否含税', trigger: 'change' }],
				paymentAmount: [
					{
						validator: (rule, value, callback) => {
							if (value === null || value === undefined || value === '') {
								callback();
								return;
							}
							const numStr = String(value).trim();
							if (!/^-?(\d+\.?\d*|\.\d+)$/.test(numStr)) {
								callback(new Error('只能输入数字，可以输入负数'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				]
			},
			supplementRules: {
				paymentAmount: [
					{
						validator: (rule, value, callback) => {
							if (!value && !this.supplementForm.rewardDate) {
								callback();
								return;
							}
							if (value) {
								const numStr = String(value).trim();
								if (!/^-?(\d+\.?\d{0,2}|\.\d{1,2})$/.test(numStr)) {
									callback(new Error('只能输入数字，可以输入负数，小数点最多保留两位'));
									return;
								}
							}
							callback();
						},
						trigger: 'blur'
					}
				],
				rewardDate: [
					{
						validator: (rule, value, callback) => {
							if (!value && !this.supplementForm.paymentAmount) {
								callback(new Error('请至少填写支付金额或奖励日期其中一个'));
								return;
							}
							callback();
						},
						trigger: 'change'
					}
				]
			},
			columns: [
				{ key: 0, label: 'ID', visible: true },
				{ key: 1, label: '订单ID', visible: true },
				{ key: 2, label: '订单日期', visible: true },
				{ key: 3, label: '客户名称', visible: true },
				{ key: 4, label: '人员身份', visible: true },
				{ key: 5, label: '奖励接收人', visible: true },
				{ key: 6, label: '奖励原因', visible: true },
				{ key: 7, label: '订单不含税利润', visible: true },
				{ key: 8, label: '综合单车利润', visible: true },
				{ key: 9, label: '利润是否达标', visible: true },
				{ key: 10, label: '是否含税', visible: true },
				{ key: 11, label: '奖励金额', visible: true },
				{ key: 12, label: '实际支付金额', visible: true },
				{ key: 13, label: '奖励日期', visible: true },
				{ key: 14, label: '审核状态', visible: true },
				{ key: 15, label: '审核人', visible: true },
				{ key: 16, label: '操作', visible: true }
			]
		};
	},
	watch: {
		form: {
			handler() {
				const orderProfit = parseFloat(this.form.orderProfit) || 0;
				const manufacturerRebateDiscountAmount = parseFloat(this.form.manufacturerRebateDiscountAmount) || 0;
				const acceptanceDiscountProfit = parseFloat(this.form.acceptanceDiscountProfit) || 0;
				const customerManufacturerCommissionAmount = parseFloat(this.form.customerManufacturerCommissionAmount) || 0;
				const result = orderProfit + manufacturerRebateDiscountAmount + acceptanceDiscountProfit - customerManufacturerCommissionAmount;
				this.form.comprehensiveProfit = isNaN(result) ? '' : this.formatAmountValue(result);
			},
			deep: true
		},
		'form.personnelIdentity'(newVal) {
			// 当人员身份变化时，自动填充奖励接收人
			if (newVal && (this.orderSaleManager || this.orderUserName)) {
				this.fillRewardReceiver();
			}
		}
	},
	created() {
		this.getList();
	},
	methods: {
		parseTime,
		listGoodsOrder,
		// 格式化金额显示（保留两位小数）
		formatAmount(value) {
			if (value === null || value === undefined || value === '') {
				return '-';
			}
			const num = parseFloat(value);
			if (isNaN(num)) {
				return value;
			}
			return num.toFixed(2);
		},
		// 格式化金额值（保留两位小数，用于表单字段）
		formatAmountValue(value) {
			if (value === null || value === undefined || value === '') {
				return '';
			}
			const num = parseFloat(value);
			if (isNaN(num)) {
				return value;
			}
			return parseFloat(num.toFixed(2));
		},
		// 合计行（汇总奖励金额、实际支付金额；高精度）
		getSummaries({ columns = [], data = [] }) {
			const sums = (columns || []).map(() => '');
			const firstDataColumnIndex = columns.findIndex(col => col.property);
			sums[(firstDataColumnIndex > -1 ? firstDataColumnIndex : 0)] = '合计';

			const sumByProp = prop =>
				(data || []).reduce((acc, row) => {
					const num = Number(row?.[prop]);
					return add(acc, bignumber(isNaN(num) ? 0 : num));
				}, bignumber(0));

			const rewardIdx = columns.findIndex(col => col.property === 'rewardAmount');
			if (rewardIdx > -1) sums[rewardIdx] = format(sumByProp('rewardAmount'), { notation: 'fixed', precision: 2 });

			const paymentIdx = columns.findIndex(col => col.property === 'paymentAmount');
			if (paymentIdx > -1) sums[paymentIdx] = format(sumByProp('paymentAmount'), { notation: 'fixed', precision: 2 });

			return sums;
		},
		// 格式化金额输入框字段
		formatAmountField(fieldName) {
			if (this.form[fieldName] !== null && this.form[fieldName] !== undefined && this.form[fieldName] !== '') {
				const formatted = this.formatAmountValue(this.form[fieldName]);
				this.$set(this.form, fieldName, formatted);
			}
		},
		// 格式化补充信息金额字段
		formatSupplementAmountField(fieldName) {
			if (this.supplementForm[fieldName] !== null && this.supplementForm[fieldName] !== undefined && this.supplementForm[fieldName] !== '') {
				const formatted = this.formatAmountValue(this.supplementForm[fieldName]);
				this.$set(this.supplementForm, fieldName, formatted);
			}
		},
		// 判断是否禁用补充信息按钮
		isSupplementDisabled(row) {
			// 只有在该行数据已经审核的前提下，如果补充信息不为空，才需要禁用
			// 如果该行数据没有审核，补充信息按钮应该常亮（不禁用）
			if (row.auditState !== '已审核') {
				return false; // 未审核时不禁用
			}
			// 已审核时，如果补充信息不为空，则禁用
			const hasPaymentAmount = row.paymentAmount != null && row.paymentAmount !== '';
			const hasRewardDate = row.rewardDate != null && row.rewardDate !== '';
			return hasPaymentAmount || hasRewardDate;
		},
		handleUpdateGoodsOrder(val) {
			this.queryGoodsOrder = val;
		},
		handleCommitBackGoodsOrder(val) {
			this.form.orderId = val.id;
			// 保存订单的录入人员和销售经理信息
			this.orderSaleManager = val.saleManager || null;
			this.orderUserName = val.userName || null;
			// 自动填充销售是否含税字段：检查smailOrderDetails中是否有任意一条isIncludeTaxSale为1
			if (val.smailOrderDetails && Array.isArray(val.smailOrderDetails) && val.smailOrderDetails.length > 0) {
				const hasIncludeTax = val.smailOrderDetails.some(item => item.isIncludeTaxSale === 1);
				this.form.salesTaxIncluded = hasIncludeTax ? 1 : 0;
			} else {
				this.form.salesTaxIncluded = 0;
			}
			this.handleLoadOrderData();
		},
		handleUpdateSearchGoodsOrder(val) {
			this.querySearchGoodsOrder = val;
		},
		handleCommitBackSearchGoodsOrder(val) {
			this.queryParams.orderId = val.id;
		},
		handleCheckOrder(row) {
			if (!row.orderId) {
				this.$message.error('该行数据有误,订单ID为空!');
				return;
			}
			getGoodsOrder(row.orderId).then(result => {
				if (!result.data) {
					this.$message.error('获取订单数据失败');
					return;
				}
				this.openDialog(GOODS_ORDER, '订单信息', '100%', { needToShowInfo: result.data }, false);
			});
		},
		handleLoadOrderData() {
			if (!this.form.orderId) {
				return;
			}
			getOrderRewardData(this.form.orderId).then(response => {
				if (response.data) {
					const orderData = response.data;
					this.form.orderDate = orderData.orderDate;
					this.form.customerName = orderData.customerName;
					this.form.orderProfit = orderData.orderProfit;
					this.form.manufacturerRebateDiscountAmount = orderData.manufacturerRebateDiscountAmount;
					this.form.acceptanceDiscountProfit = orderData.acceptanceDiscountProfit;
					this.form.customerManufacturerCommissionAmount = orderData.customerManufacturerCommissionAmount;
					this.form.comprehensiveProfit = orderData.comprehensiveProfit;
					this.form.paymentAmount = orderData.paymentAmount;
					// 根据人员身份自动填充奖励接收人
					this.fillRewardReceiver();
				}
			});
		},
		// 根据人员身份填充奖励接收人
		fillRewardReceiver() {
			if (!this.form.personnelIdentity) {
				return;
			}
			if (this.form.personnelIdentity === '销售经理' && this.orderSaleManager) {
				this.form.rewardReceiver = this.orderSaleManager;
			} else if (this.form.personnelIdentity === '录入员' && this.orderUserName) {
				this.form.rewardReceiver = this.orderUserName;
			}
		},
		getList() {
			this.loading = true;
			if (this.daterangeOrderDate && this.daterangeOrderDate.length === 2) {
				this.queryParams.orderDateBegin = this.daterangeOrderDate[0];
				this.queryParams.orderDateEnd = this.daterangeOrderDate[1];
			} else {
				this.queryParams.orderDateBegin = null;
				this.queryParams.orderDateEnd = null;
			}
			if (this.daterangeRewardDate && this.daterangeRewardDate.length === 2) {
				this.queryParams.rewardDateBegin = this.daterangeRewardDate[0];
				this.queryParams.rewardDateEnd = this.daterangeRewardDate[1];
			} else {
				this.queryParams.rewardDateBegin = null;
				this.queryParams.rewardDateEnd = null;
			}
			listSalesReward(this.queryParams).then(response => {
				this.salesRewardList = response.rows || [];
				this.total = response.total || 0;
				this.loading = false;
			});
		},
		cancel() {
			this.open = false;
			this.reset();
		},
		reset() {
			this.form = {
				id: null,
				incentiveType: '唱单',
				personnelIdentity: null,
				orderId: null,
				orderDate: null,
				customerName: null,
				rewardReceiver: null,
				rewardReason: null,
				orderProfit: null,
				manufacturerRebateDiscountAmount: null,
				acceptanceDiscountProfit: null,
				customerManufacturerCommissionAmount: null,
				comprehensiveProfit: null,
				salesTaxIncluded: 0,
				paymentAmount: null,
				isTargetReached: 1,
				rewardAmount: null,
				rewardDate: null,
				auditState: '未审核',
				remark: null
			};
			this.queryGoodsOrder = '';
			this.orderSaleManager = null;
			this.orderUserName = null;
			this.resetForm('form');
		},
		handleSupplement(row) {
			this.supplementForm = {
				id: row.id,
				paymentAmount: row.paymentAmount || null,
				rewardDate: row.rewardDate || null
			};
			this.supplementOpen = true;
		},
		cancelSupplement() {
			this.supplementOpen = false;
			this.supplementForm = {};
			this.resetForm('supplementForm');
		},
		submitSupplementForm() {
			this.$refs['supplementForm'].validate(valid => {
				if (valid) {
					if (!this.supplementForm.paymentAmount && !this.supplementForm.rewardDate) {
						this.$message.error('请至少填写支付金额或奖励日期其中一个');
						return;
					}
					supplementSalesReward(this.supplementForm).then(() => {
						this.$modal.msgSuccess('补充信息成功');
						this.supplementOpen = false;
						this.getList();
					});
				}
			});
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.daterangeOrderDate = [];
			this.daterangeRewardDate = [];
			this.querySearchGoodsOrder = '';
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加唱单奖励';
		},
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids[0];
			getSalesReward(id).then(response => {
				this.form = response.data;
				this.form.isTargetReached = response.data.isTargetReached;
				const serverSalesTaxIncluded = response?.data?.salesTaxIncluded;
				this.form.salesTaxIncluded = serverSalesTaxIncluded === 1 ? 1 : 0;
				this.open = true;
				this.title = '修改唱单奖励';
			});
		},
		handleAudit(row, approved) {
			const id = row.id;
			const action = approved ? '审核通过' : '取消审核';
			this.$modal
				.confirm(`是否确认${action}该奖励？`)
				.then(() => {
					return auditSalesReward(id, approved);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess(`${action}成功`);
				})
				.catch(() => {});
		},
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateSalesReward(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addSalesReward(this.form).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		handleDelete(row) {
			const ids = row.id || this.ids.join(',');
			this.$modal
				.confirm('是否确认删除奖励编号为"' + ids + '"的数据项？')
				.then(() => {
					return delSalesReward(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		handleExport() {
			const exportParams = { ...this.queryParams };
			if (this.daterangeOrderDate && this.daterangeOrderDate.length === 2) {
				exportParams.orderDateBegin = this.daterangeOrderDate[0];
				exportParams.orderDateEnd = this.daterangeOrderDate[1];
			}
			if (this.daterangeRewardDate && this.daterangeRewardDate.length === 2) {
				exportParams.rewardDateBegin = this.daterangeRewardDate[0];
				exportParams.rewardDateEnd = this.daterangeRewardDate[1];
			}
			this.download('system/salesReward/export', exportParams, `销售奖励_${new Date().getTime()}.xlsx`);
		}
	}
};
</script>
