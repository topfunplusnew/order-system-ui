<script>
import { getOrderFreightList, getOrderFreight, updateOrderFreight } from '@/api/system/orderFreight';
import { mixin_order_freeApply } from '../../dashboard/mixins/order/order_freeApply';
import { common_dialog } from '../../dashboard/mixins/common/common_dialog';
import DialogWrapper from '../../dashboard/components/common/DialogWrapper.vue';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { getGoodsOrder } from '@/api/system/goodsOrder';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
import { APPLY_FREIGHT_SOURCE_TYPE } from '@/api/tool/enums';
import { getInventoryMain } from '@/api/system/inventoryMain';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';
import CheckFiles from '@/components/CheckFiles.vue';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';

export default {
	name: 'ApplyFreight',
	components: { DialogWrapper, CheckFiles },
	mixins: [mixin_order_freeApply, common_dialog, mixin_printHTML, mixin_checkfile],
	data() {
		const today = new Date();
		const oneMonthAgo = new Date();
		oneMonthAgo.setMonth(today.getMonth() - 1);
		const oneMonthLater = new Date();
		oneMonthLater.setMonth(today.getMonth() + 1);
		return {
			queryParams: {
				startDate: null,
				endDate: null,
				payDate: '',
				fleet: '',
				carNo: '',
				bankName: '',
				paymentState: '',
				pageNum: 1,
				pageSize: 20
			},
			freightList: [],
			loading: false,
			total: 0,
			receiptDialogVisible: false,
			receiptImageUrl: '',
			attachmentDialogVisible: false,
			attachments: [],
			orderDetailsDialogVisible: false,
			currentOrder: null,
			columns: [
				{
					key: 0,
					label: '运费状态',
					prop: 'payment_state',
					visible: true
				},
				{ key: 1, label: '支付时间', prop: 'payDate', visible: true },
				{
					key: 2,
					label: '运输类型',
					prop: 'transport_type',
					visible: true
				},
				{
					key: 3,
					label: '订单日期',
					prop: 'document_date',
					visible: true
				},
				{
					key: 4,
					label: '客户/仓库名称',
					prop: 'customer_or_storehouse_name',
					visible: true
				},
				{ key: 5, label: '录入员', prop: 'entry_user', visible: true },
				{ key: 6, label: '车队/海运公司', prop: 'fleet', visible: true },
				{ key: 7, label: '车牌号/柜号', prop: 'car_no', visible: true },
				{ key: 8, label: '吨位', prop: 'tonnage', visible: true },
				{
					key: 9,
					label: '平均运费价格',
					prop: 'average_freight_price',
					visible: true
				},
				{ key: 10, label: '运费', prop: 'freight', visible: true },
				{
					key: 11,
					label: '司机户名',
					prop: 'driver_bank_name',
					visible: true
				},
				{
					key: 12,
					label: '司机银行账号',
					prop: 'driver_bank_no',
					visible: true
				},
				{ key: 13, label: '订单来源', prop: 'source', visible: true },
				{
					key: 14,
					label: '订单状态',
					prop: 'check_state',
					visible: true
				},
				{
					key: 15,
					label: '收到条',
					prop: 'receiveProof',
					visible: true
				},
				{
					key: 16,
					label: '已支付金额',
					prop: 'paid_amount',
					visible: true
				}
			]
		};
	},
	computed: {
		imageAttachments() {
			return this.attachments.filter(att => att.match(/\.(jpeg|jpg|gif|png)$/));
		}
	},
	methods: {
		formatDate(date) {
			const year = date.getFullYear();
			const month = (date.getMonth() + 1).toString().padStart(2, '0');
			const day = date.getDate().toString().padStart(2, '0');
			return `${year}-${month}-${day}`;
		},
		async getList() {
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

			// 处理一下时间 客户要求开始时间和结束时间都是同一天 前端拼接零点和二十四点
			if (this.queryParams.startDate && this.queryParams.endDate) {
				// 检查长度，yyyy-MM-dd 格式长度为10，如果长度超过10说明已经拼接过时间
				if (this.queryParams.startDate.length === 10) {
					this.queryParams.startDate = this.queryParams.startDate + ' 00:00:00';
				}
				if (this.queryParams.endDate.length === 10) {
					this.queryParams.endDate = this.queryParams.endDate + ' 23:59:59';
				}
			}

			this.getList();
		},
		resetQuery() {
			const today = new Date();
			const oneMonthAgo = new Date();
			oneMonthAgo.setMonth(today.getMonth() - 1);
			const oneMonthLater = new Date();
			oneMonthLater.setMonth(today.getMonth() + 1);
			this.queryParams = {
				startDate: this.formatDate(oneMonthAgo),
				endDate: this.formatDate(oneMonthLater),
				payDate: '',
				fleet: '',
				carNo: '',
				bankName: '',
				paymentState: '',
				pageNum: 1,
				pageSize: 20
			};
			this.handleQuery();
		},
		viewAttachments(receiveProof) {
			if (!receiveProof.trim()) {
				this.$message.warning('没有附件');
				return;
			}
			this.attachments = receiveProof.split('|').filter(Boolean);
			this.attachmentDialogVisible = true;
		},
		// 查看该运费信息的订单或者库存的信息
		viewOrderDetails(row) {
			// 如果该行的订单或者库存的id不存在,那么就报错
			if (!row.source_id) {
				this.$message.error('该行数据有误, 订单编号或库存编号为空');
				return;
			}

			// 判断是订单产生的运费 还是库存产生的运费
			switch (row.source) {
				case APPLY_FREIGHT_SOURCE_TYPE.GOODS_ORDER: {
					getGoodsOrder(row.source_id).then(res => {
						if (!res.data) {
							this.$message.error('该行为订单产生的运费,但获取订单信息有误!');
							return;
						}
						this.currentOrder = res.data;
						this.openDialog(
							GOODS_ORDER,
							'订单信息',
							'1000px',
							{
								needToShowInfo: this.currentOrder
							},
							false
						);
					});
					break;
				}
				case APPLY_FREIGHT_SOURCE_TYPE.INVENTORY_MAIN: {
					getInventoryMain(row.source_id).then(res => {
						if (!res.data) {
							this.$message.error('该行为库存产生的运费,但获取库存信息失误');
							return;
						}
						this.currentOrder = res.data;
						this.openDialog(
							INVENTORY,
							'库存信息',
							'1000px',
							{
								needToShowInfo: this.currentOrder
							},
							false
						);
					});
					break;
				}
			}
		},
		handleApplyFreight(row) {
			if (row.transport_type === 'land') {
				this.handleApplyLandFree(row);
			} else if (row.transport_type === 'sea') {
				this.handleApplySeaFree(row);
			}
		}
	},
	created() {
		this.getList();
	}
};
</script>

<template>
	<div class="app-container">
		<el-card class="box-card">
			<el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" label-width="110px" class="query-form">
				<el-form-item label="开始时间">
					<el-date-picker v-model="queryParams.startDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择开始时间" clearable />
				</el-form-item>
				<el-form-item label="结束时间">
					<el-date-picker v-model="queryParams.endDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择结束时间" clearable />
				</el-form-item>
				<el-form-item label="支付时间">
					<el-date-picker v-model="queryParams.payDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择支付时间" clearable />
				</el-form-item>
				<el-form-item label="车队">
					<el-input v-model="queryParams.fleet" placeholder="请输入车队" clearable />
				</el-form-item>
				<el-form-item label="司机名称">
					<el-input v-model="queryParams.landDriverName" placeholder="请输入陆运司机名称" clearable />
				</el-form-item>
				<el-form-item label="海运公司">
					<el-input v-model="queryParams.seaDriverName" placeholder="请输入海运公司" clearable />
				</el-form-item>
				<el-form-item label="车牌号/柜号">
					<el-input v-model="queryParams.carNo" placeholder="请输入车牌号/柜号" clearable />
				</el-form-item>
				<el-form-item label="对方户名">
					<el-input v-model="queryParams.bankName" placeholder="请输入对方户名" clearable />
				</el-form-item>
				<el-form-item label="支付状态">
					<el-input v-model="queryParams.paymentState" placeholder="请输入支付状态" clearable />
				</el-form-item>
				<el-form-item>
					<el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
					<el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
				</el-form-item>
			</el-form>
		</el-card>

		<el-row>
			<el-col>
				<right-toolbar :columns="columns" @queryTable="getList">
					<template #print>
						<el-col :span="1.5">
							<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
						</el-col>
					</template>
				</right-toolbar>
			</el-col>
		</el-row>
		<el-table id="printBox" :data="freightList" v-loading="loading" border fit size="mini" style="width: 100%; margin-top: 20px">
			<!-- 运费状态 -->
			<el-table-column v-if="columns[0].visible" show-overflow-tooltip prop="payment_state" label="运费状态" align="center" />

			<!-- 支付时间 -->
			<el-table-column v-if="columns[1].visible" show-overflow-tooltip prop="payDate" label="支付时间" align="center" />

			<!-- 运输类型 -->
			<el-table-column v-if="columns[2].visible" show-overflow-tooltip label="运输类型" align="center">
				<template #default="scope">
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

			<!-- 订单日期 -->
			<el-table-column v-if="columns[3].visible" show-overflow-tooltip prop="document_date" label="订单日期" align="center" />

			<!-- 订单来源 -->
			<el-table-column v-if="columns[13].visible" show-overflow-tooltip prop="source" label="订单来源" align="center" />

			<!-- 订单状态 -->
			<el-table-column v-if="columns[14].visible" show-overflow-tooltip prop="check_state" label="订单状态" align="center" />

			<!-- 客户/仓库名称 -->
			<el-table-column v-if="columns[4].visible" show-overflow-tooltip prop="customer_or_storehouse_name" label="客户/仓库名称" align="center" />

			<!-- 录入员 -->
			<el-table-column v-if="columns[5].visible" show-overflow-tooltip prop="entry_user" label="录入员" align="center" />

			<el-table-column show-overflow-tooltip prop="fleet" label="司机" align="center">
				<template #default="scope">
					{{ scope.row.transport_type === 'sea' ? '无' : scope.row.driverName }}
				</template>
			</el-table-column>

			<!-- 车队 -->
			<el-table-column v-if="columns[6].visible" show-overflow-tooltip prop="fleet" label="车队" align="center">
				<template #default="scope">
					{{ scope.row.transport_type === 'sea' ? '无' : scope.row.fleet }}
				</template>
			</el-table-column>

			<el-table-column v-if="columns[6].visible" show-overflow-tooltip prop="driverName" label="海运公司" align="center">
				<template #default="scope">
					{{ scope.row.transport_type === 'sea' ? scope.row.driverName : '无' }}
				</template>
			</el-table-column>

			<!-- 车牌号/柜号 -->
			<el-table-column v-if="columns[7].visible" show-overflow-tooltip prop="car_no" label="车牌号/柜号" align="center" />

			<!-- 吨位 -->
			<el-table-column v-if="columns[8].visible" show-overflow-tooltip prop="tonnage" label="吨位" align="center">
				<template #default="scope">
					{{ scope.row.transport_type === 'sea' ? '无' : scope.row.tonnage }}
				</template>
			</el-table-column>

			<!-- 平均运费价格 -->
			<el-table-column v-if="columns[9].visible" show-overflow-tooltip prop="average_freight_price" label="平均运费价格" align="center" />

			<!-- 运费 -->
			<el-table-column v-if="columns[10].visible" show-overflow-tooltip prop="freight" label="运费" align="center" />

			<!-- 司机户名 -->
			<el-table-column v-if="columns[11].visible" show-overflow-tooltip prop="driver_bank_name" label="司机户名" align="center" />

			<!-- 司机银行账号 -->
			<el-table-column v-if="columns[12].visible" show-overflow-tooltip prop="driver_bank_no" label="司机银行账号" align="center" />

			<!-- 收到条 -->
			<el-table-column v-if="columns[15].visible" show-overflow-tooltip label="收到条" align="center">
				<template #default="scope">
					<CheckFiles
						:attachmentList="scope.row.attachmentList"
						:flag="'receiveProof'"
						:is-upload="false"
						@needToUpdate="value => handleUpdateFilePath(value, scope.row, getOrderFreight, updateOrderFreight)"
					/>
				</template>
			</el-table-column>

			<!-- 已支付金额 -->
			<el-table-column v-if="columns[16].visible" show-overflow-tooltip prop="paid_amount" label="已支付金额" align="center" />

			<!-- 操作列 -->
			<el-table-column show-overflow-tooltip label="操作" align="center" class-name="small-padding fixed-width" width="180px" fixed="right">
				<template #default="scope">
					<el-button size="mini" type="text" @click="viewOrderDetails(scope.row)">查看详情</el-button>
					<el-button size="mini" type="text" :disabled="scope.row.payment_state !== '未申请'" @click="handleApplyFreight(scope.row)">运费申请</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="'附件查看'" :visible.sync="attachmentDialogVisible" width="50%" append-to-body>
			<el-carousel :interval="5000" type="card" height="400px" v-if="imageAttachments.length">
				<el-carousel-item v-for="(item, index) in imageAttachments" :key="index">
					<img :src="item" alt="附件" style="width: 100%; height: 100%" />
				</el-carousel-item>
			</el-carousel>
			<div v-else>
				<el-link v-for="(item, index) in attachments" :key="index" :href="item" target="_blank">
					{{ item }}
				</el-link>
			</div>
		</el-dialog>

		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
		</div>
	</div>
</template>

<style scoped>
.query-form {
	padding: 20px;
	border-radius: 8px;
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
