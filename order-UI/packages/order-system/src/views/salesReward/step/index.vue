<template>
	<div class="app-container">
		<div class="fixed-top-section" v-fixed="{ position: 'top', zIndex: 1000, offset: 100 }">
			<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px" class="form-container">
				<el-form-item label="订单ID" prop="orderId">
					<el-input v-model="queryParams.orderId" placeholder="请输入订单ID" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
				<el-form-item label="奖励接收人" prop="rewardReceiver">
					<el-input v-model="queryParams.rewardReceiver" placeholder="请输入奖励接收人" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
				<el-form-item label="客户名称" prop="customerName">
					<el-input v-model="queryParams.customerName" placeholder="请输入客户名称" clearable @keyup.enter.native="handleQuery" />
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
				<el-col :span="1.5">
					<el-button v-hasPermi="['system:salesReward:export']" type="warning" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
				</el-col>
				<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
					<template #print>
						<el-col :span="1.5">
							<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
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
			<el-table-column v-if="columns[7].visible" label="订单利润" align="center" prop="orderProfit" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.orderProfit }}</div>
						<span>{{ scope.row.orderProfit }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="综合利润" align="center" prop="comprehensiveProfit" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.comprehensiveProfit }}</div>
						<span>{{ scope.row.comprehensiveProfit }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[9].visible" label="利润是否达标" align="center" prop="isTargetReached" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tag :type="scope.row.isTargetReached === 1 ? 'success' : 'info'">{{ scope.row.isTargetReached === 1 ? '达标' : '未达标' }}</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="奖励金额" align="center" prop="rewardAmount" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.rewardAmount }}</div>
						<span>{{ scope.row.rewardAmount }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="支付金额" align="center" prop="paymentAmount" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.paymentAmount || '-' }}</div>
						<span>{{ scope.row.paymentAmount || '-' }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="奖励日期" align="center" prop="rewardDate" width="180" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.rewardDate ? parseTime(scope.row.rewardDate, '{y}-{m}-{d}') : '-' }}</div>
						<span>{{ scope.row.rewardDate ? parseTime(scope.row.rewardDate, '{y}-{m}-{d}') : '-' }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[13].visible" label="审核状态" align="center" prop="auditState" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tag :type="scope.row.auditState === '已审核' ? 'success' : 'warning'">{{ scope.row.auditState }}</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[14].visible" label="审核人" align="center" prop="auditUserName" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.auditUserName || '-' }}</div>
						<span>{{ scope.row.auditUserName || '-' }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[15].visible" label="操作" align="center" class-name="small-padding fixed-width" width="250">
				<template #default="scope">
					<el-button size="mini" type="text" @click="handleCheckOrder(scope.row)">查看订单</el-button>
					<el-button v-hasPermi="['system:salesReward:edit']" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-if="scope.row.auditState === '未审核'" v-hasPermi="['system:salesReward:audit']" size="mini" type="text" icon="el-icon-check" @click="handleAudit(scope.row, true)">审核</el-button>
					<el-button v-else v-hasPermi="['system:salesReward:audit']" size="mini" type="text" icon="el-icon-close" @click="handleAudit(scope.row, false)">取消审核</el-button>
					<el-button v-hasPermi="['system:salesReward:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改台阶奖励对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="900px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="150px">
				<el-row>
					<el-col :span="12">
						<el-form-item label="订单ID" prop="orderId">
							<el-input-number v-model="form.orderId" :min="1" placeholder="请输入订单ID" style="width: 100%" @change="handleOrderIdChange"></el-input-number>
							<el-button v-if="form.orderId" size="mini" type="text" @click="handleLoadOrderData">加载订单数据</el-button>
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
						<el-form-item label="订单利润" prop="orderProfit">
							<el-input-number v-model="form.orderProfit" :precision="2" placeholder="请输入订单利润" style="width: 100%"></el-input-number>
						</el-form-item>
						<el-form-item label="厂家返利折扣金额" prop="manufacturerRebateDiscountAmount">
							<el-input-number v-model="form.manufacturerRebateDiscountAmount" :precision="2" placeholder="请输入厂家返利折扣金额" style="width: 100%"></el-input-number>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="承兑折扣利润" prop="acceptanceDiscountProfit">
							<el-input-number v-model="form.acceptanceDiscountProfit" :precision="2" placeholder="请输入承兑折扣利润" style="width: 100%"></el-input-number>
						</el-form-item>
						<el-form-item label="客户厂家佣金金额" prop="customerManufacturerCommissionAmount">
							<el-input-number v-model="form.customerManufacturerCommissionAmount" :precision="2" placeholder="请输入客户厂家佣金金额" style="width: 100%"></el-input-number>
						</el-form-item>
						<el-form-item label="综合利润" prop="comprehensiveProfit">
							<el-input-number v-model="form.comprehensiveProfit" :precision="2" placeholder="综合利润" disabled style="width: 100%"></el-input-number>
						</el-form-item>
						<el-form-item label="利润是否达标" prop="isTargetReached">
							<el-radio-group v-model="form.isTargetReached">
								<el-radio :label="0">未达标</el-radio>
								<el-radio :label="1">达标</el-radio>
							</el-radio-group>
						</el-form-item>
						<el-form-item label="奖励金额" prop="rewardAmount">
							<el-input-number v-model="form.rewardAmount" :precision="2" placeholder="请输入奖励金额" style="width: 100%"></el-input-number>
						</el-form-item>
						<el-form-item label="支付金额" prop="paymentAmount">
							<el-input-number v-model="form.paymentAmount" :precision="2" placeholder="请输入支付金额" style="width: 100%"></el-input-number>
						</el-form-item>
						<el-form-item label="奖励日期" prop="rewardDate">
							<el-date-picker v-model="form.rewardDate" clearable type="date" value-format="yyyy-MM-dd" placeholder="请选择奖励日期" style="width: 100%"></el-date-picker>
						</el-form-item>
						<el-form-item label="审核状态" prop="auditState">
							<el-select v-model="form.auditState" placeholder="请选择审核状态" style="width: 100%">
								<el-option label="未审核" value="未审核" />
								<el-option label="已审核" value="已审核" />
							</el-select>
						</el-form-item>
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
import { listSalesReward, getSalesReward, delSalesReward, addSalesReward, updateSalesReward, auditSalesReward, getOrderRewardData, exportSalesReward } from '@/api/salesReward/salesReward';
import { parseTime } from '@/utils/ruoyi';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { getGoodsOrder } from '@/api/system/goodsOrder';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';

export default {
	name: 'StepReward',
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
			daterangeOrderDate: [],
			daterangeRewardDate: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				incentiveType: '台阶',
				orderId: null,
				rewardReceiver: null,
				customerName: null,
				auditState: null,
				paymentStatus: null,
				orderDateBegin: null,
				orderDateEnd: null,
				rewardDateBegin: null,
				rewardDateEnd: null
			},
			form: {},
			rules: {
				orderId: [{ required: true, message: '请输入订单ID', trigger: 'blur' }],
				personnelIdentity: [{ required: true, message: '请选择人员身份', trigger: 'change' }],
				rewardReceiver: [{ required: true, message: '请输入奖励接收人', trigger: 'blur' }],
				rewardAmount: [{ required: true, message: '请输入奖励金额', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, label: 'ID', visible: true },
				{ key: 1, label: '订单ID', visible: true },
				{ key: 2, label: '订单日期', visible: true },
				{ key: 3, label: '客户名称', visible: true },
				{ key: 4, label: '人员身份', visible: true },
				{ key: 5, label: '奖励接收人', visible: true },
				{ key: 6, label: '奖励原因', visible: true },
				{ key: 7, label: '订单利润', visible: true },
				{ key: 8, label: '综合利润', visible: true },
				{ key: 9, label: '利润是否达标', visible: true },
				{ key: 10, label: '奖励金额', visible: true },
				{ key: 11, label: '支付金额', visible: true },
				{ key: 12, label: '奖励日期', visible: true },
				{ key: 13, label: '审核状态', visible: true },
				{ key: 14, label: '审核人', visible: true },
				{ key: 15, label: '操作', visible: true }
			]
		};
	},
	watch: {
		form: {
			handler() {
				const orderProfit = Number(this.form.orderProfit) || 0;
				const manufacturerRebateDiscountAmount = Number(this.form.manufacturerRebateDiscountAmount) || 0;
				const acceptanceDiscountProfit = Number(this.form.acceptanceDiscountProfit) || 0;
				const customerManufacturerCommissionAmount = Number(this.form.customerManufacturerCommissionAmount) || 0;
				this.form.comprehensiveProfit = orderProfit + manufacturerRebateDiscountAmount + acceptanceDiscountProfit - customerManufacturerCommissionAmount;
			},
			deep: true
		}
	},
	created() {
		this.getList();
	},
	methods: {
		parseTime,
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
				this.openDialog(GOODS_ORDER, '订单信息', '800px', { needToShowInfo: result.data }, false);
			});
		},
		handleOrderIdChange() {
			if (this.form.orderId) {
				this.handleLoadOrderData();
			}
		},
		handleLoadOrderData() {
			if (!this.form.orderId) {
				this.$message.warning('请先输入订单ID');
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
				}
			});
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
				incentiveType: '台阶',
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
				paymentAmount: null,
				isTargetReached: 1,
				rewardAmount: null,
				rewardDate: null,
				auditState: '未审核'
			};
			this.resetForm('form');
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.daterangeOrderDate = [];
			this.daterangeRewardDate = [];
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
			this.title = '添加台阶奖励';
		},
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids[0];
			getSalesReward(id).then(response => {
				this.form = response.data;
				this.form.isTargetReached = response.data.isTargetReached;
				this.open = true;
				this.title = '修改台阶奖励';
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
			exportSalesReward(exportParams).then(response => {
				const blob = new Blob([response]);
				const url = window.URL.createObjectURL(blob);
				const link = document.createElement('a');
				link.href = url;
				link.setAttribute('download', `台阶奖励_${new Date().getTime()}.xlsx`);
				document.body.appendChild(link);
				link.click();
				document.body.removeChild(link);
				window.URL.revokeObjectURL(url);
			});
		}
	}
};
</script>
