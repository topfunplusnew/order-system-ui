<template>
	<div class="app-container">
		<hr color="#e6e6e6" />
		<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="queryParams.params.startTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd" clearable />
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="queryParams.params.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd" clearable />
			</el-form-item>
			<el-form-item label="客户名称" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入客户名称" clearable />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-row>
			<el-button size="mini" icon="el-icon-refresh" @click="refresh">刷新</el-button>
			<el-button type="danger" size="mini" icon="el-icon-plus" @click="handleAdd">新增</el-button>
		</el-row>
		<br />
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="tableData"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="55" align="center" />
			<!--			<el-table-column show-overflow-tooltip label="订单号" align="center" prop="ordersNo" width="140" />-->
			<el-table-column show-overflow-tooltip label="订单日期" align="center" prop="orderDate" width="140" />
			<el-table-column show-overflow-tooltip label="客户名称" align="center" prop="companyName" width="140" />
			<el-table-column show-overflow-tooltip label="产品名称" align="center" prop="levelName" width="140" />
			<el-table-column show-overflow-tooltip label="单位" align="center" prop="countingUnit" width="100" />
			<el-table-column show-overflow-tooltip label="高度" align="center" prop="height" width="100" />
			<el-table-column show-overflow-tooltip label="长度" align="center" prop="length" width="100" />
			<el-table-column show-overflow-tooltip label="宽度" align="center" prop="width" width="100" />
			<el-table-column show-overflow-tooltip label="每包片数" align="center" prop="piecesPerPack" width="100" />
			<el-table-column show-overflow-tooltip label="包数" align="center" prop="packs" width="100" />
			<el-table-column show-overflow-tooltip label="实际片数" align="center" prop="actualPieces" width="100" />
			<el-table-column show-overflow-tooltip label="卸货费用" align="center" prop="paymentUnload" width="100" />
			<el-table-column show-overflow-tooltip label="含税销售" align="center" prop="isIncludeTaxSale" width="100" />
			<el-table-column show-overflow-tooltip label="杂费" align="center" prop="sundryCost" width="100" />
			<el-table-column show-overflow-tooltip label="付款金额" align="center" prop="payments" width="100" />
			<el-table-column show-overflow-tooltip label="利润" align="center" prop="profit" width="100" />
			<el-table-column show-overflow-tooltip label="不含税利润" align="center" prop="profitNoTax" width="100" />
			<el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" width="140" />
			<el-table-column show-overflow-tooltip label="面积" align="center" prop="area" width="100" />
			<el-table-column show-overflow-tooltip label="佣金单价" align="center" prop="commissionUnitPrice" width="100" />
			<el-table-column show-overflow-tooltip label="已验证佣金" align="center" prop="verifiedCommission" width="100" />
			<el-table-column show-overflow-tooltip label="其他付款金额" align="center" prop="otherPaymentAmount" width="100" />
			<el-table-column show-overflow-tooltip label="佣金金额" align="center" prop="commissionAmount" width="100" />
			<el-table-column show-overflow-tooltip label="实际客户佣金" align="center" prop="actualCustomerCommission" width="100" />
			<el-table-column show-overflow-tooltip label="资金日期" align="center" prop="fundDate" width="100" />
			<el-table-column show-overflow-tooltip label="差异" align="center" prop="difference" width="100" />
			<el-table-column show-overflow-tooltip label="差异原因" align="center" prop="differenceReason" width="100" />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<div v-if="currentComponent">
			<DialogWrapper
				:current-component="currentComponent"
				:dialog-visible="dialogVisible"
				:dialog-props="dialogProps"
				:dialog-title="dialogTitle"
				:dialog-width="dialogWidth"
				@update:dialogVisible="args => (dialogVisible = false)"
				@close="handleCloseDialog"
				@confirm="handleDialogConfirm"
			/>
		</div>
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { listCommission } from '@/api/commission';
import { CommissionType } from '@/api/tool/enums';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import CommissionsForm from '@/views/system/Commission/components/CommissionsForm.vue';

export default {
	name: 'CUSTOMERCommission',
	components: { DialogWrapper },
	mixins: [mixin_printHTML, common_dialog],
	data() {
		return {
			queryParams: {
				companyName: '',
				pageNum: 1,
				pageSize: 10,
				params: {
					showOrder: null,
					isNoPay: null,
					isCanPay: null,
					startTime: null,
					endTime: null
				}
			},
			columns: [],
			loading: false,
			tableData: [],
			selectedRow: null, // 当前选中的行
			orderDetailId: null,
			total: 0
		};
	},
	methods: {
		// 刷新表格
		refresh() {
			this.queryParams = {
				companyName: '',
				pageNum: 1,
				pageSize: 10,
				params: {
					showOrder: null,
					isNoPay: null,
					isCanPay: null,
					startTime: null,
					endTime: null
				}
			};
			this.getList();
		},
		// 查询数据
		handleQuery() {
			this.getList();
		},
		// 获取数据
		async getList() {
			this.loading = true;
			try {
				const response = await listCommission(this.queryParams, CommissionType.CUSTOMER);
				this.tableData = response.rows;
			} catch (error) {
				console.error('获取数据失败', error);
			} finally {
				this.loading = false;
			}
		},
		// 选中行
		handleSelectionChange(selection) {
			this.selectedRow = selection.length > 0 ? selection[0] : null;
		},
		// 新增
		handleAdd() {
			this.openDialog(
				CommissionsForm,
				'新增厂家返利',
				'50%',
				{
					type: CommissionType.CUSTOMER,
					orderDetailId: this.orderDetailId
				},
				false
			);
		},
		// 修改
		handleEdit() {},
		// 提交表单
		async submitForm() {},
		// 导出
		async handleExport() {}
	},
	mounted() {
		this.getList(); // 页面加载时获取数据
	}
};
</script>
