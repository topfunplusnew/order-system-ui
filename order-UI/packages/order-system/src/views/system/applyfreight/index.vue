<script>
import { getOrderFreightList } from '@/api/system/orderFreight';
import { mixin_order_freeApply } from '../../dashboard/mixins/order/order_freeApply';
import { common_dialog } from '../../dashboard/mixins/common/common_dialog';
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
	components: { CheckFiles },
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
				paymentDate: '',
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
					prop: 'paymentState',
					visible: true
				},
				{ key: 1, label: '支付时间', prop: 'paymentDate', visible: true },
				{
					key: 2,
					label: '运输类型',
					prop: 'transportType',
					visible: true
				},
				{
					key: 3,
					label: '订单日期',
					prop: 'documentDate',
					visible: true
				},
				{
					key: 4,
					label: '客户/仓库名称',
					prop: 'customerOrStorehouseName',
					visible: true
				},
				{ key: 5, label: '录入员', prop: 'entryUser', visible: true },
				{ key: 6, label: '车队/海运公司', prop: 'fleet', visible: true },
				{ key: 7, label: '车牌号/柜号', prop: 'carNo', visible: true },
				{ key: 8, label: '吨位', prop: 'tonnage', visible: true },
				{
					key: 9,
					label: '平均运费价格',
					prop: 'averageFreightPrice',
					visible: true
				},
				{ key: 10, label: '运费', prop: 'freight', visible: true },
				{
					key: 11,
					label: '司机户名',
					prop: 'driverAccountName',
					visible: true
				},
				{
					key: 12,
					label: '司机银行账号',
					prop: 'driverBankNo',
					visible: true
				},
				{ key: 13, label: '订单来源', prop: 'source', visible: true },
				{
					key: 14,
					label: '订单状态',
					prop: 'checkState',
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
					prop: 'paidAmount',
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
				startDate: null,
				endDate: null,
				paymentDate: '',
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
			if (!row.sourceId) {
				this.$message.error('该行数据有误, 订单编号或库存编号为空');
				return;
			}

			// 判断是订单产生的运费 还是库存产生的运费
			switch (row.source) {
				case APPLY_FREIGHT_SOURCE_TYPE.GOODS_ORDER: {
					getGoodsOrder(row.sourceId).then(res => {
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
					getInventoryMain(row.sourceId).then(res => {
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
			if (row.transportType === 'land') {
				this.handleApplyLandFree(row);
			} else if (row.transportType === 'sea') {
				this.handleApplySeaFree(row);
			}
		},
		handleExport() {
			this.download(
				'/system/orderFreight/ledger/export',
				{
					...this.queryParams
				},
				`orderFreight_${new Date().getTime()}.xlsx`
			);
		}
	},
	created() {
		this.getList();
	}
};
</script>

<template>
	<div class="app-container">
		<el-form id="top-search-form-item" :model="queryParams" ref="queryForm" size="mini" :inline="true" label-width="150" class="query-form">
			<el-form-item label="开始时间">
				<el-date-picker v-model="queryParams.startDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择开始时间" clearable />
			</el-form-item>
			<el-form-item label="结束时间">
				<el-date-picker v-model="queryParams.endDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择结束时间" clearable />
			</el-form-item>
			<el-form-item label="支付时间">
				<el-date-picker v-model="queryParams.paymentDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择支付时间" clearable />
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
				<el-select v-model="queryParams.paymentState" placeholder="请选择支付状态" clearable>
					<el-option label="已支付" value="已支付"></el-option>
					<el-option label="未支付" value="未支付"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row>
			<el-col>
				<right-toolbar :columns="columns" @queryTable="getList">
					<template #print>
						<el-col :span="1.5">
							<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
						</el-col>
					</template>
					<template #export>
						<el-col :span="1.5">
							<el-button v-hasPermi="['system:orderfreight:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
						</el-col>
					</template>
				</right-toolbar>
			</el-col>
		</el-row>
		<u-table id="printBox" :data="freightList" v-loading="loading" border fit size="mini" style="width: 100%; margin-top: 20px">
			<CustomTableColumn v-if="columns[0].visible" show-overflow-tooltip prop="paymentState" label="运费状态" align="center" />
			<CustomTableColumn v-if="columns[1].visible" show-overflow-tooltip prop="paymentDate" label="支付时间" align="center" />
			<CustomTableColumn v-if="columns[2].visible" show-overflow-tooltip label="运输类型" align="center">
				<template #default="scope">
					<span
						:class="{
							'sea-transport': scope.row.transportType === 'sea',
							'land-transport': scope.row.transportType === 'land'
						}"
					>
						{{ scope.row.transportType === 'sea' ? '海运' : '陆运' }}
					</span>
				</template>
			</CustomTableColumn>
			<CustomTableColumn v-if="columns[3].visible" show-overflow-tooltip prop="documentDate" label="订单日期" align="center" />
			<CustomTableColumn v-if="columns[13].visible" show-overflow-tooltip prop="source" label="订单来源" align="center" />
			<CustomTableColumn v-if="columns[14].visible" show-overflow-tooltip prop="checkState" label="订单状态" align="center" />
			<CustomTableColumn v-if="columns[4].visible" show-overflow-tooltip prop="customerOrStorehouseName" label="客户/仓库名称" align="center" />
			<CustomTableColumn v-if="columns[5].visible" show-overflow-tooltip prop="entryUser" label="录入员" align="center" />
			<CustomTableColumn show-overflow-tooltip prop="fleet" label="司机" align="center">
				<template #default="scope">
					{{ scope.row.transportType === 'sea' ? '无' : scope.row.driverName }}
				</template>
			</CustomTableColumn>
			<CustomTableColumn v-if="columns[6].visible" show-overflow-tooltip prop="fleet" label="车队" align="center">
				<template #default="scope">
					{{ scope.row.transportType === 'sea' ? '无' : scope.row.fleet }}
				</template>
			</CustomTableColumn>
			<CustomTableColumn v-if="columns[6].visible" show-overflow-tooltip prop="driverName" label="海运公司" align="center">
				<template #default="scope">
					{{ scope.row.transportType === 'sea' ? scope.row.driverName : '无' }}
				</template>
			</CustomTableColumn>
			<CustomTableColumn v-if="columns[7].visible" show-overflow-tooltip prop="carNo" label="车牌号/柜号" align="center" />
			<CustomTableColumn v-if="columns[8].visible" show-overflow-tooltip prop="tonnage" label="吨位" align="center">
				<template #default="scope">
					{{ scope.row.transportType === 'sea' ? '无' : scope.row.tonnage }}
				</template>
			</CustomTableColumn>
			<CustomTableColumn v-if="columns[9].visible" show-overflow-tooltip prop="averageFreightPrice" label="平均运费价格" align="center" />
			<CustomTableColumn v-if="columns[10].visible" show-overflow-tooltip prop="freight" label="运费" align="center" />
			<CustomTableColumn v-if="columns[11].visible" show-overflow-tooltip prop="driverAccountName" label="司机户名" align="center" />
			<CustomTableColumn v-if="columns[12].visible" show-overflow-tooltip prop="driverBankNo" label="司机银行账号" align="center" />
			<CustomTableColumn v-if="columns[15].visible" show-overflow-tooltip label="收到条" align="center">
				<template #default="scope">
					<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'receiveProof'" :is-upload="false" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getOrderFreight, updateOrderFreight)" />
				</template>
			</CustomTableColumn>
			<CustomTableColumn v-if="columns[16].visible" show-overflow-tooltip prop="paidAmount" label="已支付金额" align="center" />
			<CustomTableColumn show-overflow-tooltip label="操作" align="center" class-name="small-padding fixed-width" width="220" fixed="right">
				<template #default="scope">
					<el-button size="mini" type="text" @click="viewOrderDetails(scope.row)">查看详情</el-button>
					<el-button size="mini" type="text" :disabled="scope.row.paymentState !== '未申请'" @click="handleApplyFreight(scope.row)">运费申请</el-button>
				</template>
			</CustomTableColumn>
		</u-table>

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
	</div>
</template>

<style scoped>
.sea-transport {
	font-weight: bold;
	color: #409eff;
}

.land-transport {
	font-weight: bold;
	color: #e6a23c;
}
</style>
