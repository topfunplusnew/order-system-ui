<script>
import { getOrderFreightList } from '@/api/system/orderFreight';
import { mixin_order_freeApply } from '../../dashboard/mixins/order/order_freeApply';
export default {
	name: 'index',
	mixins: [mixin_order_freeApply],
	data() {
		const today = new Date();
		const oneMonthAgo = new Date();
		oneMonthAgo.setMonth(today.getMonth() - 1);
		return {
			queryParams: {
				startDate: this.formatDate(oneMonthAgo),
				endDate: this.formatDate(today),
				payDate: '',
				fleet: '',
				carNo: '',
				bankName: '',
				paymentState: '',
				pageNum: 1,
				pageSize: 10
			},
			freightList: [],
			loading: false,
			total: 0,
			receiptDialogVisible: false,
			receiptImageUrl: ''
		};
	},
	methods: {
		formatDate(date) {
			const year = date.getFullYear();
			const month = (date.getMonth() + 1).toString().padStart(2, '0');
			const day = date.getDate().toString().padStart(2, '0');
			return `${year}-${month}-${day}`;
		},
		async fetchFreightList() {
			this.loading = true;
			const response = await getOrderFreightList(this.queryParams);
			if (response.code === 200) {
				this.freightList = response.rows;
				this.total = response.total;
			}
			this.loading = false;
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.fetchFreightList();
		},
		resetQuery() {
			const today = new Date();
			const oneMonthAgo = new Date();
			oneMonthAgo.setMonth(today.getMonth() - 1);
			this.queryParams = {
				startDate: this.formatDate(oneMonthAgo),
				endDate: this.formatDate(today),
				payDate: '',
				fleet: '',
				carNo: '',
				bankName: '',
				paymentState: '',
				pageNum: 1,
				pageSize: 10
			};
			this.handleQuery();
		},
		viewReceipt(url) {
			this.receiptImageUrl = url;
			this.receiptDialogVisible = true;
		}
	},
	created() {
		this.fetchFreightList();
	}
};
</script>

<template>
	<div class="app-container">
		<el-form
			:model="queryParams"
			ref="queryForm"
			size="mini"
			:inline="true"
			label-width="80px"
			class="query-form"
		>
			<el-form-item label="开始时间">
				<el-date-picker
					v-model="queryParams.startDate"
					type="date"
					value-format="yyyy-MM-dd"
					placeholder="请选择开始时间"
					clearable
				/>
			</el-form-item>
			<el-form-item label="结束时间">
				<el-date-picker
					v-model="queryParams.endDate"
					type="date"
					value-format="yyyy-MM-dd"
					placeholder="请选择结束时间"
					clearable
				/>
			</el-form-item>
			<el-form-item label="支付时间">
				<el-date-picker
					v-model="queryParams.payDate"
					type="date"
					value-format="yyyy-MM-dd"
					placeholder="请选择支付时间"
					clearable
				/>
			</el-form-item>
			<el-form-item label="车队">
				<el-input
					v-model="queryParams.fleet"
					placeholder="请输入车队"
					clearable
				/>
			</el-form-item>
			<el-form-item label="车牌号">
				<el-input
					v-model="queryParams.carNo"
					placeholder="请输入车牌号"
					clearable
				/>
			</el-form-item>
			<el-form-item label="银行卡号">
				<el-input
					v-model="queryParams.bankName"
					placeholder="请输入银行卡号"
					clearable
				/>
			</el-form-item>
			<el-form-item label="支付状态">
				<el-input
					v-model="queryParams.paymentState"
					placeholder="请输入支付状态"
					clearable
				/>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" @click="handleQuery"
					>搜索</el-button
				>
				<el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-table
			:data="freightList"
			v-loading="loading"
			border
			fit
			size="mini"
			style="width: 100%; margin-top: 20px"
		>
			<el-table-column
				show-overflow-tooltip
				prop="fleet"
				label="车队"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="driver_bank_no"
				label="银行卡号"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="payment_state"
				label="支付状态"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="entry_user"
				label="录入用户"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="addTime"
				label="添加时间"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="driver_bank_name"
				label="银行名称"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="freight"
				label="运费"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="check_state"
				label="审核状态"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="document_date"
				label="单据日期"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="source"
				label="来源"
				align="center"
			/>
			<el-table-column show-overflow-tooltip label="收据" align="center">
				<template slot-scope="scope">
					<el-button
						type="text"
						size="mini"
						@click="viewReceipt(scope.row.receiveProof)"
					>
						查看
					</el-button>
				</template>
			</el-table-column>
			<el-table-column
				show-overflow-tooltip
				prop="average_freight_price"
				label="平均运费价格"
				align="center"
			/>
			<el-table-column show-overflow-tooltip label="运输类型" align="center">
				<template slot-scope="scope">
					<span
						:class="{
							'sea-transport': scope.row.transport_type === 'sea',
							'land-transport': scope.row.transport_type === 'land'
						}"
					>
						{{ scope.row.transport_type === 'sea' ? '海运' : '陆运' }}
					</span>
				</template>
			</el-table-column>
			<el-table-column
				show-overflow-tooltip
				prop="customer_or_storehouse_name"
				label="客户或仓库名称"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="car_no"
				label="车牌号"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				prop="tonnage"
				label="吨位"
				align="center"
			/>
			<el-table-column
				show-overflow-tooltip
				label="运费申请"
				align="center"
				class-name="small-padding fixed-width"
				width="100px"
				fixed="right"
			>
				<template slot-scope="scope">
					<el-dropdown size="mini" type="text">
						<el-button type="text" :disabled="!(scope.row.freight > 0)">
							操作
						</el-button>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item>
								<el-row v-if="scope.row.freight > 0">
									<el-button
										v-if="scope.row.transport_type === 'land'"
										size="mini"
										type="warning"
										@click="handleApplyLandFree(scope.row)"
									>
										陆运费申请
									</el-button>
									<el-button
										v-if="scope.row.transport_type === 'sea'"
										size="mini"
										type="primary"
										@click="handleApplySeaFree(scope.row)"
									>
										海运费申请
									</el-button>
								</el-row>
								<el-row v-else>无运费信息</el-row>
							</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
				</template>
			</el-table-column>
		</el-table>

		<pagination
			v-show="total > 0"
			:total="total"
			:page.sync="queryParams.pageNum"
			:limit.sync="queryParams.pageSize"
			@pagination="fetchFreightList"
		/>

		<el-dialog
			:title="'查看收据'"
			:visible.sync="receiptDialogVisible"
			width="50%"
			append-to-body
		>
			<img :src="receiptImageUrl" alt="收据" style="width: 100%" />
		</el-dialog>
	</div>
</template>

<style scoped>
.query-form {
	background-color: #f5f7fa;
	padding: 20px;
	border-radius: 8px;
	margin-bottom: 20px;
}
.sea-transport {
	font-weight: bold;
	color: #409eff;
}
.land-transport {
	font-weight: bold;
	color: #e6a23c;
}
</style>
