<template>
	<div class="app-container">
		<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="130px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="queryParams.params.startTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd" clearable />
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="queryParams.params.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd" clearable />
			</el-form-item>
			<el-form-item label="厂家名称" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入厂家名称" clearable />
			</el-form-item>
			<el-form-item label="支付状态" prop="companyName">
				<el-select v-model="queryParams.params.isNoPay" placeholder="请选择">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
				</el-select>
			</el-form-item>
			<el-form-item label="是否可支付" prop="companyName">
				<el-select v-model="queryParams.params.isCanPay" placeholder="请选择">
					<el-option v-for="item in pay_options" :key="item.value" :label="item.label" :value="item.value" />
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row>
			<el-button size="mini" icon="el-icon-refresh" @click="refresh">刷新</el-button>
			<el-button :disabled="selections.length <= 0" size="mini" type="success" icon="el-icon-s-claim" @click="handleOnceApply">一键申请</el-button>
		</el-row>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<br />
		<el-table
			ref="multipleTable"
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
			<el-table-column type="selection" width="55" align="center" :selectable="(row, index) => row.id !== null" />
			<el-table-column v-if="columns[0].visible" show-overflow-tooltip label="订单日期" align="center" prop="orderDate" width="140" />
			<el-table-column show-overflow-tooltip label="佣金来源" align="center" prop="source">
				<template slot-scope="scope">
					{{ scope.row.source === TableName.ORDER_DETAIL ? '订单' : '库存' }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" show-overflow-tooltip label="厂家名称" align="center" prop="companyName" width="140" />
			<el-table-column v-if="columns[2].visible" show-overflow-tooltip label="产品名称" align="center" prop="levelName" width="140" />
			<el-table-column v-if="columns[3].visible" show-overflow-tooltip label="单位" align="center" prop="countingUnit" width="100" />
			<el-table-column v-if="columns[4].visible" show-overflow-tooltip label="高度" align="center" prop="height" width="100" />
			<el-table-column v-if="columns[5].visible" show-overflow-tooltip label="长度" align="center" prop="length" width="100" />
			<el-table-column v-if="columns[6].visible" show-overflow-tooltip label="宽度" align="center" prop="width" width="100" />
			<el-table-column v-if="columns[7].visible" show-overflow-tooltip label="每包片数" align="center" prop="piecesPerPack" width="100" />
			<el-table-column v-if="columns[8].visible" show-overflow-tooltip label="包数" align="center" prop="packs" width="100" />
			<el-table-column v-if="columns[9].visible" show-overflow-tooltip label="卸货片数" align="center" prop="actualPieces" width="100" />
			<el-table-column v-if="columns[10].visible" show-overflow-tooltip label="卸货费用" align="center" prop="paymentUnload" width="100" />
			<el-table-column v-if="columns[11].visible" show-overflow-tooltip label="含税销售" align="center" prop="isIncludeTaxSale" width="100">
				<template slot-scope="scope">
					{{ scope.row.isIncludeTaxSale ? '含税' : '不含税' }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" show-overflow-tooltip label="杂费" align="center" prop="sundryCost" width="100" />
			<el-table-column v-if="columns[13].visible" show-overflow-tooltip label="付款金额" align="center" prop="payments" width="100" />
			<el-table-column v-if="columns[14].visible" show-overflow-tooltip label="利润" align="center" prop="profit" width="100" />
			<el-table-column v-if="columns[15].visible" show-overflow-tooltip label="不含税利润" align="center" prop="profitNoTax" width="100" />
			<el-table-column v-if="columns[16].visible" show-overflow-tooltip label="备注" align="center" prop="comments" width="140" />
			<el-table-column v-if="columns[17].visible" show-overflow-tooltip label="面积" align="center" prop="area" width="100" />
			<el-table-column v-if="columns[18].visible" show-overflow-tooltip label="佣金单价" align="center" prop="commissionUnitPrice" width="100" />
			<el-table-column v-if="columns[19].visible" show-overflow-tooltip label="已验证佣金" align="center" prop="verifiedCommission" width="100" />
			<el-table-column v-if="columns[20].visible" show-overflow-tooltip label="其他付款金额" align="center" prop="otherPaymentAmount" width="100" />
			<el-table-column v-if="columns[21].visible" show-overflow-tooltip label="应付佣金金额" align="center" prop="commissionAmount" width="100" />
			<el-table-column v-if="columns[22].visible" show-overflow-tooltip label="实际厂家佣金" align="center" prop="actualCustomerCommission" width="100" />
			<el-table-column v-if="columns[23].visible" show-overflow-tooltip label="支付日期" align="center" prop="fundDate" width="100" />
			<el-table-column v-if="columns[24].visible" show-overflow-tooltip label="差异" align="center" prop="difference" width="100" />
			<el-table-column v-if="columns[25].visible" show-overflow-tooltip label="差异原因" align="center" prop="differenceReason" width="100" />
			<!--      加一列操作列-->
			<el-table-column show-overflow-tooltip label="操作" align="center" width="230" fixed="right">
				<template slot-scope="scope">
					<el-button type="text" size="mini" @click="handleEdit(scope.row)">{{ scope.row.id ? '修改佣金信息' : '填写佣金信息' }}</el-button>
					<el-button :disabled="scope.row.id === null" type="text" size="mini" @click="handleDelete(scope.row)">删除</el-button>
					<el-button :disabled="scope.row.id === null" type="text" size="mini" @click="handleApplyPayment(scope.row)">申请付款</el-button>
				</template>
			</el-table-column>
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

		<!--    申请付款-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="付款申请" :visible.sync="PaymentApplyInfoVisible" width="45%">
			<keep-alive>
				<ApplyPayment :money-input-disabled="false" :table-name="TableName.ORDERCOMMISION" :t-i-d="tID" :need-money="needMoney" :need-info="{}" @changeOpen="changePaymentApplyInfoVisible" />
			</keep-alive>
		</el-dialog>
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { deleteCommission, getCommission, listCommission } from '@/api/commission';
import { CommissionType, TableName } from '@/api/tool/enums';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import CommissionsForm from '@/views/system/Commission/components/CommissionsForm.vue';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import OncePaymentApply from '@/views/system/Commission/components/OncePaymentApply.vue';
import { ExtraInfo, PaymentApply, SourceInfo } from '@/types/payment';

export default {
	name: 'SUPPLIERCommission',
	computed: {
		TableName() {
			return TableName;
		}
	},
	components: { ApplyPayment, DialogWrapper },
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
			columns: [
				{ key: 0, label: '订单日期', visible: true },
				{ key: 1, label: '厂家名称', visible: true },
				{ key: 2, label: '产品名称', visible: true },
				{ key: 3, label: '单位', visible: true },
				{ key: 4, label: '高度', visible: true },
				{ key: 5, label: '长度', visible: true },
				{ key: 6, label: '宽度', visible: true },
				{ key: 7, label: '每包片数', visible: true },
				{ key: 8, label: '包数', visible: true },
				{ key: 9, label: '卸货片数', visible: true },
				{ key: 10, label: '卸货费用', visible: true },
				{ key: 11, label: '含税销售', visible: true },
				{ key: 12, label: '杂费', visible: true },
				{ key: 13, label: '付款金额', visible: true },
				{ key: 14, label: '利润', visible: true },
				{ key: 15, label: '不含税利润', visible: true },
				{ key: 16, label: '备注', visible: true },
				{ key: 17, label: '面积', visible: true },
				{ key: 18, label: '佣金单价', visible: true },
				{ key: 19, label: '已验证佣金', visible: true },
				{ key: 20, label: '其他付款金额', visible: true },
				{ key: 21, label: '应付佣金金额', visible: true },
				{ key: 22, label: '实际厂家佣金', visible: true },
				{ key: 23, label: '支付日期', visible: true },
				{ key: 24, label: '差异', visible: true },
				{ key: 25, label: '差异原因', visible: true }
			],
			loading: false,
			tableData: [],
			selectedRow: null, // 当前选中的行
			selections: [],
			orderDetailId: null,
			total: 0,
			options: [
				{
					value: '',
					label: '全部'
				},
				{
					value: false,
					label: '已付款'
				},
				{
					value: true,
					label: '未付款'
				}
			],
			pay_options: [
				{
					value: false,
					label: '可支付'
				},
				{
					value: true,
					label: '不可支付'
				}
			],
			PaymentApplyInfoVisible: false,
			tID: null,
			needMoney: null
		};
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('supplier-commission-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList(); // 页面加载时获取数据
		if (localStorage.getItem('supplier-commission-columns') === 'null' || !localStorage.getItem('supplier-commission-columns')) {
			localStorage.setItem('supplier-commission-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('supplier-commission-columns'));
		}
	},
	methods: {
		handleOnceApply() {
			let extra = new ExtraInfo({ sourceInfos: [] });
			this.selections.forEach(item => {
				let s = new SourceInfo({
					tableId: item.id,
					tableName: TableName.ORDERCOMMISION
				});
				extra.pushSourceInfo(s);
			});

			let applications = this.selections.map(item => {
				return new PaymentApply({
					moneyAmount: item.commissionAmount,
					extraInfo: extra
				});
			});

			// 打开弹窗
			this.openDialog(
				OncePaymentApply,
				'申请列表',
				'1100px',
				{
					applications
				},
				false
			);
		},
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
		// 查询数据z
		handleQuery() {
			this.getList();
		},
		// 获取数据
		async getList() {
			this.loading = true;
			try {
				const response = await listCommission(this.queryParams, CommissionType.SUPPLIER);
				this.tableData = response.rows;
				this.total = response.total;
			} catch (error) {
				console.error('获取数据失败', error);
			} finally {
				this.loading = false;
			}
		},
		// 选中行
		handleSelectionChange(selection) {
			this.selectedRow = selection.length > 0 ? selection[0] : null;
			this.selections = selection;
		},
		handleAdd(source) {
			this.openDialog(
				CommissionsForm,
				'新增厂家佣金',
				'400px',
				{
					type: CommissionType.SUPPLIER,
					orderDetailId: this.orderDetailId,
					source: source
				},
				false
			);
		},
		// 修改
		handleEdit(row) {
			this.orderDetailId = row.orderDetailId;
			if (!row.id) {
				this.handleAdd(row.source);
			} else {
				getCommission(row.id).then(res => {
					if (!res.data) {
						this.$message.warning('数据不存在!');
						return;
					}
					const commissionData = {
						orderDetailId: res.data.orderDetailId,
						commissionUnitPrice: res.data.commissionUnitPrice,
						otherPaymentAmount: res.data.otherPaymentAmount
					};
					this.openDialog(
						CommissionsForm,
						'修改厂家佣金',
						'400px',
						{
							id: row.id,
							type: CommissionType.SUPPLIER,
							orderDetailId: this.orderDetailId,
							body: commissionData
						},
						false
					);
				});
			}
		},
		handleDelete(row) {
			if (row.id) {
				this.$confirm('是否确认删除佣金信息?', '提示', {
					confirmButtonText: '确定',
					cancelButtonText: '取消',
					type: 'warning'
				}).then(() => {
					deleteCommission(row.id).then(() => {
						this.$message.success('删除成功');
						this.getList();
					});
				});
			} else {
				this.$message.warning('此信息由订单产生，由于未生成相关佣金信息，不可删除!');
			}
		},
		handleApplyPayment(row) {
			if (!row.id) {
				this.$message.error('此佣金信息还未生成，无法进行付款申请');
			}
			this.tID = row.id;
			this.PaymentApplyInfoVisible = true;
		},
		// 导出
		handleExport() {
			this.download(
				'system/ordercommission/export',
				{
					...this.queryParams
				},
				`厂家佣金_${new Date().getTime()}.xlsx`
			);
		},
		changePaymentApplyInfoVisible() {
			this.needMoney = 0;
			this.PaymentApplyInfoVisible = false;
			this.getList();
		}
	}
};
</script>
