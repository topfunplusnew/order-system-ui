<!--
  用户需求：新增 DOS-74 质量赔偿统计表，订单指标取自订单，赔偿信息手动录入，剩余利润按公式计算，并支持查询、审核、删除和导出。
  实际改动：重建质量赔偿页面，固定 incentiveType=质量赔偿，接入订单预览、14 个业务字段、独立记录操作、边界校验和 POST 表单导出。
-->
<template>
	<div class="app-container">
		<div class="fixed-top-section">
			<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="100px" class="form-container">
				<el-form-item label="订单ID" prop="orderId"><el-input v-model="queryParams.orderId" clearable placeholder="请输入订单ID" @keyup.enter.native="handleQuery" /></el-form-item>
				<el-form-item label="客户名称" prop="customerName"><el-input v-model="queryParams.customerName" clearable placeholder="请输入客户名称" @keyup.enter.native="handleQuery" /></el-form-item>
				<el-form-item label="审核状态" prop="auditState">
					<el-select v-model="queryParams.auditState" clearable placeholder="请选择审核状态">
						<el-option label="未审核" value="未审核" />
						<el-option label="已审核" value="已审核" />
					</el-select>
				</el-form-item>
				<el-form-item label="订单日期"><el-date-picker v-model="daterangeOrderDate" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" clearable /></el-form-item>
				<el-form-item label="厂家赔偿日期"><el-date-picker v-model="daterangeManufacturerCompensationDate" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" clearable /></el-form-item>
				<el-form-item label="客户赔偿日期"><el-date-picker v-model="daterangeCustomerCompensationDate" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" clearable /></el-form-item>
				<el-form-item label="添加时间"><el-date-picker v-model="daterangeCreateTime" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" clearable /></el-form-item>
				<el-form-item>
					<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
					<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
				</el-form-item>
			</el-form>
			<el-row :gutter="10" class="mb8">
				<el-col :span="1.5"><el-button v-hasPermi="['system:salesReward:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button></el-col>
				<el-col :span="1.5"><el-button v-hasPermi="['system:salesReward:edit']" type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate()">修改</el-button></el-col>
				<el-col :span="1.5"><el-button v-hasPermi="['system:salesReward:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete()">删除</el-button></el-col>
				<right-toolbar :showSearch.sync="showSearch" :columns="columns" table-name="views-sales-reward-quality-compensation-index-columns" @queryTable="getList">
					<template #print>
						<el-col :span="1.5"><el-button plain icon="el-icon-printer" size="mini" @click="printHTML" /></el-col>
					</template>
					<template #export>
						<el-col :span="1.5"><el-button v-hasPermi="['system:salesReward:export']" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button></el-col>
					</template>
				</right-toolbar>
			</el-row>
		</div>

		<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" row-key="id" :data="salesRewardList" show-summary :summary-method="getSummaries" border size="mini" :cell-style="() => ({ padding: '1px' })" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column v-if="columns[0].visible" label="ID" prop="id" width="80" align="center" />
			<el-table-column v-if="columns[1].visible" label="订单ID" prop="orderId" width="90" align="center" />
			<el-table-column v-if="columns[2].visible" label="订单日期" prop="orderDate" width="160" align="center">
				<template #default="scope">{{ formatDateTime(scope.row.orderDate) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="客户名称" prop="customerName" min-width="140" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="订单不含税利润" prop="orderProfit" width="125" align="right">
				<template #default="scope">{{ formatAmount(scope.row.orderProfit) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[5].visible" label="厂家返利及降价金额合计" prop="manufacturerRebateDiscountAmount" width="160" align="right">
				<template #default="scope">{{ formatAmount(scope.row.manufacturerRebateDiscountAmount) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="客户及厂家佣金合计" prop="customerManufacturerCommissionAmount" width="145" align="right">
				<template #default="scope">{{ formatAmount(scope.row.customerManufacturerCommissionAmount) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[7].visible" label="综合单车利润" prop="comprehensiveProfit" width="120" align="right">
				<template #default="scope">{{ formatAmount(scope.row.comprehensiveProfit) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="厂家赔偿我方金额" prop="manufacturerCompensationAmount" width="135" align="right">
				<template #default="scope">{{ formatAmount(scope.row.manufacturerCompensationAmount) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[9].visible" label="厂家赔偿我方日期" prop="manufacturerCompensationDate" width="135" align="center">
				<template #default="scope">{{ formatDate(scope.row.manufacturerCompensationDate) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="我方赔偿客户金额" prop="customerCompensationAmount" width="135" align="right">
				<template #default="scope">{{ formatAmount(scope.row.customerCompensationAmount) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="我方赔偿客户日期" prop="customerCompensationDate" width="135" align="center">
				<template #default="scope">{{ formatDate(scope.row.customerCompensationDate) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="质量赔偿后剩余利润" prop="remainingProfit" width="145" align="right">
				<template #default="scope">{{ formatAmount(scope.row.remainingProfit) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[13].visible" label="质量问题简易描述" prop="qualityIssueDescription" min-width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[14].visible" label="备注" prop="remark" min-width="160" show-overflow-tooltip />
			<el-table-column v-if="columns[15].visible" label="审核状态" prop="auditState" width="100" align="center">
				<template #default="scope">
					<el-tag :type="scope.row.auditState === '已审核' ? 'success' : 'warning'">{{ scope.row.auditState }}</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[16].visible" label="审核人" prop="auditUserName" width="100" align="center">
				<template #default="scope">{{ scope.row.auditUserName || '—' }}</template>
			</el-table-column>
			<el-table-column v-if="columns[17].visible" label="添加时间" prop="createTime" width="170" align="center">
				<template #default="scope">{{ formatDateTime(scope.row.createTime) }}</template>
			</el-table-column>
			<el-table-column v-if="columns[18].visible" label="操作" width="350" fixed="right" align="center">
				<template #default="scope">
					<el-button size="mini" type="text" @click="handleCheckOrder(scope.row)">查看订单</el-button>
					<el-button v-hasPermi="['system:salesReward:edit']" size="mini" type="text" icon="el-icon-edit" :disabled="scope.row.auditState === '已审核'" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-if="scope.row.auditState === '未审核'" v-hasPermi="['system:salesReward:audit']" size="mini" type="text" icon="el-icon-check" @click="handleAudit(scope.row, true)">审核</el-button>
					<el-button v-else v-hasPermi="['system:salesReward:audit']" size="mini" type="text" icon="el-icon-close" @click="handleAudit(scope.row, false)">取消审核</el-button>
					<el-button v-hasPermi="['system:salesReward:remove']" size="mini" type="text" icon="el-icon-delete" :disabled="scope.row.auditState === '已审核'" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="900px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="160px">
				<el-row :gutter="12">
					<el-col :span="12">
						<el-form-item label="订单ID" prop="orderId">
							<el-input v-model="form.orderId" disabled placeholder="请选择订单">
								<SearchOption slot="append" :limit-info="{}" :get-data="listWithFullDetail" query-info="customer" query-label="客户名称" :query-name="queryGoodsOrder" @update:queryName="handleUpdateGoodsOrder" @commitBack="handleCommitBackGoodsOrder">
									<template #table-columns>
										<el-table-column label="ID" prop="id" />
										<el-table-column label="日期" prop="orderDate" />
										<el-table-column label="客户" prop="customer" />
										<el-table-column label="供应商" prop="supplierNames" />
										<el-table-column label="审核状态" prop="checkState" />
									</template>
								</SearchOption>
							</el-input>
						</el-form-item>
						<el-form-item label="订单日期"><el-input :value="formatDateTime(form.orderDate)" disabled /></el-form-item>
						<el-form-item label="客户名称"><el-input v-model="form.customerName" disabled /></el-form-item>
						<el-form-item label="订单不含税利润"><el-input :value="formatAmount(form.orderProfit)" disabled /></el-form-item>
						<el-form-item label="厂家返利及降价金额合计"><el-input :value="formatAmount(form.manufacturerRebateDiscountAmount)" disabled /></el-form-item>
						<el-form-item label="客户及厂家佣金合计"><el-input :value="formatAmount(form.customerManufacturerCommissionAmount)" disabled /></el-form-item>
						<el-form-item label="综合单车利润"><el-input :value="formatAmount(form.comprehensiveProfit)" disabled /></el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="厂家赔偿我方金额" prop="manufacturerCompensationAmount"><el-input v-model="form.manufacturerCompensationAmount" clearable placeholder="可不填" @blur="formatAmountField('manufacturerCompensationAmount')" /></el-form-item>
						<el-form-item label="厂家赔偿我方日期" prop="manufacturerCompensationDate"><el-date-picker v-model="form.manufacturerCompensationDate" clearable type="date" value-format="yyyy-MM-dd" placeholder="可不填" style="width: 100%" /></el-form-item>
						<el-form-item label="我方赔偿客户金额" prop="customerCompensationAmount"><el-input v-model="form.customerCompensationAmount" clearable placeholder="可不填" @blur="formatAmountField('customerCompensationAmount')" /></el-form-item>
						<el-form-item label="我方赔偿客户日期" prop="customerCompensationDate"><el-date-picker v-model="form.customerCompensationDate" clearable type="date" value-format="yyyy-MM-dd" placeholder="可不填" style="width: 100%" /></el-form-item>
						<el-form-item label="质量赔偿后剩余利润"><el-input :value="formatAmount(remainingProfit)" disabled /></el-form-item>
						<el-form-item label="质量问题简易描述" prop="qualityIssueDescription"><el-input v-model="form.qualityIssueDescription" clearable maxlength="500" show-word-limit placeholder="最多 500 个字符" /></el-form-item>
						<el-form-item label="备注" prop="remark"><el-input v-model="form.remark" clearable type="textarea" :rows="3" maxlength="550" show-word-limit placeholder="最多 550 个字符" /></el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listSalesReward, getSalesReward, delSalesReward, addSalesReward, updateSalesReward, auditSalesReward, getOrderRewardData } from '@/api/salesReward/salesReward';
import { parseTime } from '@/utils/ruoyi';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { getGoodsOrder, listWithFullDetail } from '@/api/system/goodsOrder';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
import SearchOption from '@/components/SearchOption.vue';

const INCENTIVE_TYPE = '质量赔偿';

export default {
	name: 'QualityCompensation',
	components: { SearchOption },
	mixins: [mixin_printHTML, common_dialog],
	data() {
		const optionalAmountValidator = (rule, value, callback) => {
			if (value === null || value === undefined || String(value).trim() === '') return callback();
			if (!/^\d{1,18}(\.\d{1,2})?$/.test(String(value).trim())) return callback(new Error('金额不能小于 0，最多 18 位整数且小数最多 2 位'));
			callback();
		};
		const optionalTextRule = max => (rule, value, callback) => {
			if (value !== null && value !== undefined && String(value).trim().length > max) return callback(new Error(`最多 ${max} 个字符`));
			callback();
		};
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
			queryGoodsOrder: '',
			daterangeOrderDate: [],
			daterangeManufacturerCompensationDate: [],
			daterangeCustomerCompensationDate: [],
			daterangeCreateTime: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				incentiveType: INCENTIVE_TYPE,
				orderId: null,
				customerName: null,
				auditState: null,
				orderDateBegin: null,
				orderDateEnd: null,
				manufacturerCompensationDateBegin: null,
				manufacturerCompensationDateEnd: null,
				customerCompensationDateBegin: null,
				customerCompensationDateEnd: null,
				createTimeBegin: null,
				createTimeEnd: null
			},
			form: {},
			rules: {
				orderId: [{ required: true, message: '请选择订单', trigger: 'change' }],
				manufacturerCompensationAmount: [{ validator: optionalAmountValidator, trigger: 'blur' }],
				customerCompensationAmount: [{ validator: optionalAmountValidator, trigger: 'blur' }],
				qualityIssueDescription: [{ validator: optionalTextRule(500), trigger: 'blur' }],
				remark: [{ validator: optionalTextRule(550), trigger: 'blur' }]
			},
			columns: [
				...[
					'ID',
					'订单ID',
					'订单日期',
					'客户名称',
					'订单不含税利润',
					'厂家返利及降价金额合计',
					'客户及厂家佣金合计',
					'综合单车利润',
					'厂家赔偿我方金额',
					'厂家赔偿我方日期',
					'我方赔偿客户金额',
					'我方赔偿客户日期',
					'质量赔偿后剩余利润',
					'质量问题简易描述',
					'备注',
					'审核状态',
					'审核人',
					'添加时间',
					'操作'
				].map((label, key) => ({ key, label, visible: true }))
			]
		};
	},
	created() {
		this.reset();
		this.getList();
	},
	computed: {
		remainingProfit() {
			return Number(this.form.comprehensiveProfit || 0) + Number(this.form.manufacturerCompensationAmount || 0) - Number(this.form.customerCompensationAmount || 0);
		}
	},
	methods: {
		parseTime,
		listWithFullDetail,
		formatAmount(value) {
			if (value === null || value === undefined || value === '') return '—';
			const number = Number(value);
			return Number.isFinite(number) ? number.toFixed(2) : '—';
		},
		formatDate(value) {
			return value ? parseTime(value, '{y}-{m}-{d}') : '—';
		},
		formatDateTime(value) {
			return value ? parseTime(value, '{y}-{m}-{d} {h}:{i}:{s}') : '—';
		},
		formatAmountField(field) {
			if (this.form[field] === '' || this.form[field] === undefined) this.$set(this.form, field, null);
			if (this.form[field] !== null) this.$set(this.form, field, Number(this.form[field]).toFixed(2));
		},
		applyDateRangeParams(target) {
			[
				['daterangeOrderDate', 'orderDateBegin', 'orderDateEnd'],
				['daterangeManufacturerCompensationDate', 'manufacturerCompensationDateBegin', 'manufacturerCompensationDateEnd'],
				['daterangeCustomerCompensationDate', 'customerCompensationDateBegin', 'customerCompensationDateEnd'],
				['daterangeCreateTime', 'createTimeBegin', 'createTimeEnd']
			].forEach(([source, begin, end]) => {
				const range = this[source];
				target[begin] = range && range.length === 2 ? range[0] : null;
				target[end] = range && range.length === 2 ? range[1] : null;
			});
			target.incentiveType = INCENTIVE_TYPE;
			return target;
		},
		getList() {
			this.loading = true;
			listSalesReward(this.applyDateRangeParams({ ...this.queryParams }))
				.then(response => {
					this.salesRewardList = response.rows || [];
					this.total = response.total || 0;
				})
				.finally(() => {
					this.loading = false;
				});
		},
		reset() {
			this.form = {
				id: null,
				incentiveType: INCENTIVE_TYPE,
				orderId: null,
				orderDate: null,
				customerName: null,
				orderProfit: null,
				manufacturerRebateDiscountAmount: null,
				customerManufacturerCommissionAmount: null,
				comprehensiveProfit: null,
				manufacturerCompensationAmount: null,
				manufacturerCompensationDate: null,
				customerCompensationAmount: null,
				customerCompensationDate: null,
				qualityIssueDescription: null,
				remark: null
			};
			this.queryGoodsOrder = '';
			if (this.$refs.form) this.resetForm('form');
		},
		cancel() {
			this.open = false;
			this.reset();
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.daterangeOrderDate = [];
			this.daterangeManufacturerCompensationDate = [];
			this.daterangeCustomerCompensationDate = [];
			this.daterangeCreateTime = [];
			this.queryParams.orderId = null;
			this.queryParams.customerName = null;
			this.queryParams.auditState = null;
			this.queryParams.pageNum = 1;
			this.getList();
		},
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加质量赔偿';
		},
		handleUpdate(row) {
			const id = row?.id || this.ids[0];
			if (!id) return;
			this.reset();
			getSalesReward(id).then(response => {
				this.form = { ...this.form, ...(response.data || {}), incentiveType: INCENTIVE_TYPE };
				this.open = true;
				this.title = '修改质量赔偿';
			});
		},
		handleUpdateGoodsOrder(value) {
			this.queryGoodsOrder = value;
		},
		handleCommitBackGoodsOrder(value) {
			this.$set(this.form, 'orderId', value.id);
			this.handleLoadOrderData();
		},
		handleLoadOrderData() {
			if (!this.form.orderId) return;
			getOrderRewardData(this.form.orderId).then(response => {
				const data = response.data || {};
				['orderId', 'orderDate', 'customerName', 'orderProfit', 'manufacturerRebateDiscountAmount', 'customerManufacturerCommissionAmount', 'comprehensiveProfit'].forEach(field => {
					if (data[field] !== undefined) this.$set(this.form, field, data[field]);
				});
			});
		},
		handleCheckOrder(row) {
			if (!row.orderId) return;
			getGoodsOrder(row.orderId).then(response => {
				if (response.data) this.openDialog(GOODS_ORDER, '订单信息', '100%', { needToShowInfo: response.data }, false);
			});
		},
		handleAudit(row, approved) {
			const action = approved ? '审核通过' : '取消审核';
			this.$modal
				.confirm(`是否确认${action}该质量赔偿？`)
				.then(() => auditSalesReward(row.id, approved))
				.then(() => {
					this.getList();
					this.$modal.msgSuccess(`${action}成功`);
				})
				.catch(() => {});
		},
		toPayload() {
			const payload = {
				id: this.form.id,
				incentiveType: INCENTIVE_TYPE,
				orderId: this.form.orderId,
				manufacturerCompensationAmount: this.form.manufacturerCompensationAmount === '' ? null : this.form.manufacturerCompensationAmount,
				manufacturerCompensationDate: this.form.manufacturerCompensationDate || null,
				customerCompensationAmount: this.form.customerCompensationAmount === '' ? null : this.form.customerCompensationAmount,
				customerCompensationDate: this.form.customerCompensationDate || null,
				qualityIssueDescription: this.form.qualityIssueDescription ? String(this.form.qualityIssueDescription).trim() : null,
				remark: this.form.remark ? String(this.form.remark).trim() : null
			};
			if (payload.id == null) delete payload.id;
			return payload;
		},
		submitForm() {
			this.$refs.form.validate(valid => {
				if (!valid) return;
				const payload = this.toPayload();
				const request = payload.id != null ? updateSalesReward(payload) : addSalesReward(payload);
				request.then(() => {
					this.$modal.msgSuccess(payload.id != null ? '修改成功' : '新增成功');
					this.open = false;
					this.reset();
					this.getList();
				});
			});
		},
		handleDelete(row) {
			const selected = row ? [row] : this.salesRewardList.filter(item => this.ids.includes(item.id));
			if (selected.some(item => item.auditState === '已审核')) {
				this.$message.warning('已审核记录不能删除，请先取消审核');
				return;
			}
			const ids = selected.map(item => item.id).join(',');
			if (!ids) return;
			this.$modal
				.confirm(`是否确认删除质量赔偿记录“${ids}”？`)
				.then(() => delSalesReward(ids))
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		handleExport() {
			const exportParams = this.applyDateRangeParams({ ...this.queryParams });
			delete exportParams.pageNum;
			delete exportParams.pageSize;
			this.download('system/salesReward/export', exportParams, `质量赔偿统计表_${new Date().getTime()}.xlsx`);
		},
		getSummaries({ columns = [], data = [] }) {
			const sums = columns.map(() => '');
			const first = columns.findIndex(column => column.property);
			if (first >= 0) sums[first] = '合计';
			['orderProfit', 'manufacturerRebateDiscountAmount', 'customerManufacturerCommissionAmount', 'comprehensiveProfit', 'manufacturerCompensationAmount', 'customerCompensationAmount', 'remainingProfit'].forEach(prop => {
				const index = columns.findIndex(column => column.property === prop);
				if (index >= 0) sums[index] = data.reduce((total, row) => total + Number(row[prop] || 0), 0).toFixed(2);
			});
			return sums;
		}
	}
};
</script>
