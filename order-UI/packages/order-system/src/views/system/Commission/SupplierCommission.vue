<template>
	<div class="app-container">
		<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="130px">
			<el-form-item label="时间范围">
				<el-date-picker
					v-model="dateRange"
					type="daterange"
					range-separator="至"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
					value-format="yyyy-MM-dd"
					size="mini"
					style="width: 280px"
					unlink-panels
					:clearable="true"
					@change="onDateRangeChange"
				/>
			</el-form-item>
			<el-form-item label="厂家名称" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入厂家名称" clearable />
			</el-form-item>
			<el-form-item label="支付状态" prop="isNoPay">
				<el-select v-model="queryParams.isNoPay" placeholder="请选择">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
				</el-select>
			</el-form-item>
			<el-form-item label="是否可支付" prop="isCanPay">
				<el-select v-model="queryParams.isCanPay" placeholder="请选择">
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
			<el-button :disabled="batchFillDisabled" size="mini" type="primary" icon="el-icon-edit" @click="handleBatchFill">批量填写佣金</el-button>
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
		<el-alert title="添加佣金信息后，方可进行付款申请操作!" type="warning"></el-alert>
		<br />
		<el-table
			ref="multipleTable"
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="computedTableData"
			size="mini"
			:height="600"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="55" align="center" :selectable="(row, index) => row.id !== null && isPaymentUnApplied(row)" />
			<el-table-column label="批量佣金" width="80" align="center">
				<template slot-scope="scope">
					<el-checkbox v-if="scope.row.id === null" :value="scope.row.batchSelected" @input="handleBatchToggle(scope.row, $event)"></el-checkbox>
					<span v-else>-</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[0].visible" show-overflow-tooltip label="订单日期" align="center" prop="orderDate" width="140" />
			<el-table-column show-overflow-tooltip label="佣金来源" align="center" prop="source">
				<template slot-scope="scope">
					{{ scope.row.source === TableName.ORDER_DETAIL ? '订单' : '库存' }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" show-overflow-tooltip label="厂家名称" align="center" prop="companyName" width="140" />
			<el-table-column v-if="columns[2].visible" show-overflow-tooltip label="车牌号" align="center" prop="landCarNo" width="140" />
			<el-table-column v-if="columns[3].visible" show-overflow-tooltip label="产品名称" align="center" prop="levelName" width="140" />
			<el-table-column v-if="columns[4].visible" show-overflow-tooltip label="单位" align="center" prop="countingUnit" width="100" />
			<el-table-column v-if="columns[5].visible" show-overflow-tooltip label="高度" align="center" prop="height" width="100" />
			<el-table-column v-if="columns[6].visible" show-overflow-tooltip label="长度" align="center" prop="length" width="100" />
			<el-table-column v-if="columns[7].visible" show-overflow-tooltip label="宽度" align="center" prop="width" width="100" />
			<el-table-column v-if="columns[8].visible" show-overflow-tooltip label="每包片数" align="center" prop="piecesPerPack" width="100" />
			<el-table-column v-if="columns[9].visible" show-overflow-tooltip label="包数" align="center" prop="packs" width="100" />
			<el-table-column v-if="columns[10].visible" show-overflow-tooltip label="出厂片数" align="center" prop="pieces" width="100" />
			<el-table-column v-if="columns[11].visible" show-overflow-tooltip label="卸货价" align="center" prop="paymentUnload" width="100" />
			<el-table-column v-if="columns[12].visible" show-overflow-tooltip label="含税销售" align="center" prop="isIncludeTaxSale" width="100">
				<template slot-scope="scope">
					{{ scope.row.isIncludeTaxSale ? '含税' : '不含税' }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[13].visible" show-overflow-tooltip label="杂费" align="center" prop="sundryCost" width="100" />
			<el-table-column v-if="columns[14].visible" show-overflow-tooltip label="总货款" align="center" prop="payments" width="100" />
			<el-table-column v-if="columns[15].visible" show-overflow-tooltip label="利润" align="center" prop="profit" width="100" />
			<el-table-column v-if="columns[16].visible" show-overflow-tooltip label="不含税利润" align="center" prop="profitNoTax" width="100" />
			<el-table-column v-if="columns[17].visible" show-overflow-tooltip label="备注" align="center" prop="comments" width="140" />
			<el-table-column v-if="columns[18].visible" show-overflow-tooltip label="面积" align="center" prop="area" width="100" />
			<el-table-column v-if="columns[19].visible" show-overflow-tooltip label="订单计提佣金" align="center" prop="commissionAmount" width="100" />
			<el-table-column v-if="columns[20].visible" show-overflow-tooltip label="佣金单价" align="center" prop="commissionUnitPrice" width="100" />
			<el-table-column v-if="columns[21].visible" show-overflow-tooltip label="其他付款金额" align="center" prop="otherPaymentAmount" width="100" />
			<el-table-column v-if="columns[22].visible" show-overflow-tooltip label="已验证佣金" align="center" prop="verifiedCommission" width="100" />
			<el-table-column v-if="columns[23].visible" show-overflow-tooltip label="实际厂家佣金" align="center" prop="actualCustomerCommission" width="100" />
			<el-table-column v-if="columns[24].visible" show-overflow-tooltip label="支付日期" align="center" prop="fundDate" width="100" />
			<el-table-column v-if="columns[25].visible" show-overflow-tooltip label="支付状态" align="center" width="120">
				<template slot-scope="scope">
					<PaymentFlag :business-object="scope.row" />
				</template>
			</el-table-column>
			<el-table-column v-if="columns[26].visible" show-overflow-tooltip label="差异" align="center" prop="difference" width="100" />
			<el-table-column v-if="columns[27].visible" show-overflow-tooltip label="差异原因" align="center" prop="differenceReason" width="150">
				<template slot-scope="scope">
					<el-button v-if="scope.row.difference && scope.row.difference !== 0" size="mini" type="text" @click="handleDifferenceReason(scope.row)">
						{{ scope.row.differenceReason || '填写差异原因' }}
					</el-button>
					<span v-else>-</span>
				</template>
			</el-table-column>
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
		<!--    申请付款-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="付款申请"
			:visible.sync="PaymentApplyInfoVisible"
			width="45%"
		>
			<keep-alive>
				<ApplyPayment :money-input-disabled="false" :table-name="TableName.ORDERCOMMISION" :t-i-d="tID" :need-money="needMoney" :need-info="{}" @changeOpen="changePaymentApplyInfoVisible" />
			</keep-alive>
		</el-dialog>

		<!--    批量填写佣金-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" title="批量填写佣金信息" :visible.sync="batchFillVisible" width="500px">
			<el-form ref="batchForm" :model="batchForm" :rules="batchRules" label-width="140px">
				<el-form-item label="佣金单价" prop="commissionUnitPrice">
					<el-input v-model="batchForm.commissionUnitPrice" placeholder="请输入佣金单价" type="number" step="0.01" />
				</el-form-item>
				<el-form-item label="其他付款金额" prop="otherPaymentAmount">
					<el-input v-model="batchForm.otherPaymentAmount" placeholder="请输入其他付款金额" type="number" step="0.01" />
				</el-form-item>
				<el-form-item label="差异原因" prop="difference_reason">
					<el-input v-model="batchForm.difference_reason" placeholder="请输入差异原因" type="textarea" :rows="3" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button @click="batchFillVisible = false">取 消</el-button>
				<el-button type="primary" @click="submitBatchFill" :loading="batchSubmitting">确认填写</el-button>
			</div>
		</el-dialog>

		<!--    一键申请对话框-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" title="供应商佣金一键申请" :visible.sync="onceApplyVisible" width="1100px">
			<el-card class="box-card">
				<div slot="header" class="clearfix">
					<span>申请列表</span>
					<div style="float: right">
						<el-button size="small" type="primary" @click="handleApproveApply">统一填写申请</el-button>
						<el-button size="small" type="success" @click="handleProcessApply">批量申请</el-button>
					</div>
				</div>

				<el-table :data="localApplications" style="width: 100%" size="mini">
					<el-table-column fixed prop="fundsDate" label="日期" width="150" show-overflow-tooltip></el-table-column>
					<el-table-column prop="payType" label="支付类型" width="150" show-overflow-tooltip></el-table-column>
					<el-table-column prop="moneyAmount" label="金额" width="120" show-overflow-tooltip></el-table-column>
					<el-table-column prop="otherBankNo" label="对方账号" width="300" show-overflow-tooltip></el-table-column>
					<el-table-column prop="companyName" label="对方公司" width="120" show-overflow-tooltip></el-table-column>
					<el-table-column prop="reason" label="付款原因" width="120" show-overflow-tooltip></el-table-column>
					<el-table-column prop="comments" label="备注" width="120" show-overflow-tooltip></el-table-column>
				</el-table>
			</el-card>
		</el-dialog>

		<!--    申请信息填写对话框-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="付款申请"
			:visible.sync="applyPaymentVisible"
			width="45%"
			append-to-body
		>
			<keep-alive>
				<ApplyPayment
					ref="applyPayment"
					:money-input-disabled="false"
					:table-name="TableName.ORDERCOMMISION"
					:t-i-d="applyTid"
					:need-money="applyNeedMoney"
					:need-info="applyNeedInfo"
					@changeOpen="() => (applyPaymentVisible = false)"
					:is-multi="true"
					@getApplyPayment="handleCommitApplyInfo"
				/>
			</keep-alive>
		</el-dialog>
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { deleteCommission, getCommission, listCommission, updateDifferenceReason, batchAddCommission } from '@/api/commission';
import { CommissionType, TableName, PAYMENT_APPLY_STATE } from '@/api/tool/enums';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import CommissionsForm from '@/views/system/Commission/components/CommissionsForm.vue';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { ExtraInfo, PaymentApply, SourceInfo } from '@/types/payment';
import { addPaymentApply } from '@/api/system/paymentApply';
import { mixin_checkfile } from '@/views/dashboard/mixins/checkfiles/mixin_checkfile';
import PaymentFlag from '@/components/PaymentFlag';
import { mapGetters } from 'vuex/dist/vuex.common.js';
import { getDateRangeDays } from '@/utils';

export default {
	name: 'SUPPLIERCommission',
	computed: {
		TableName() {
			return TableName;
		},
		// 批量填写按钮是否禁用
		batchFillDisabled() {
			// 直接检查 tableData 中是否有选中的批量佣金行
			return !this.tableData.some(row => row.batchSelected === true);
		},
		// 获取批量选中的行
		batchSelectedRows() {
			return this.tableData.filter(row => row.batchSelected === true);
		},
		// 处理表格数据，构造 PaymentFlag 组件需要的业务对象结构
		computedTableData() {
			return this.tableData.map(item => {
				return {
					...item,
					// 构造 PaymentFlag 组件需要的业务对象结构
					// 根据 fundDate 字段判断支付状态：有支付日期表示已支付，否则未支付
					payment: {
						paymentState: item.fundDate ? '已支付' : '未支付'
					}
				};
			});
		},
		...mapGetters(['id', 'trueName'])
	},
	components: { ApplyPayment, PaymentFlag },
	mixins: [mixin_printHTML, common_dialog, mixin_checkfile],
	data() {
		return {
			dateRange: [],
			queryParams: {
				companyName: '',
				pageNum: 1,
				pageSize: 20,
				startTime: null,
				endTime: null,
				isNoPay: null,
				isCanPay: null,
				showOrder: null
			},
			columns: [
				{ key: 0, label: '订单日期', visible: true },
				{ key: 1, label: '厂家名称', visible: true },
				{ key: 2, label: '车牌号', visible: true },
				{ key: 3, label: '产品名称', visible: true },
				{ key: 4, label: '单位', visible: true },
				{ key: 5, label: '高度', visible: true },
				{ key: 6, label: '长度', visible: true },
				{ key: 7, label: '宽度', visible: true },
				{ key: 8, label: '每包片数', visible: true },
				{ key: 9, label: '包数', visible: true },
				{ key: 10, label: '出厂片数', visible: true },
				{ key: 11, label: '卸货价', visible: true },
				{ key: 12, label: '含税销售', visible: true },
				{ key: 13, label: '杂费', visible: true },
				{ key: 14, label: '总货款', visible: true },
				{ key: 15, label: '利润', visible: true },
				{ key: 16, label: '不含税利润', visible: true },
				{ key: 17, label: '备注', visible: true },
				{ key: 18, label: '面积', visible: true },
				{ key: 19, label: '订单计提佣金', visible: true },
				{ key: 20, label: '佣金单价', visible: true },
				{ key: 21, label: '其他付款金额', visible: true },
				{ key: 22, label: '已验证佣金', visible: true },
				{ key: 23, label: '实际厂家佣金', visible: true },
				{ key: 24, label: '支付日期', visible: true },
				{ key: 25, label: '支付状态', visible: true },
				{ key: 26, label: '差异', visible: true },
				{ key: 27, label: '差异原因', visible: true }
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
					value: true,
					label: '未付款'
				},
				{
					value: false,
					label: '已付款'
				}
			],
			pay_options: [
				{
					value: '',
					label: '全部'
				},
				{
					value: true,
					label: '可支付'
				},
				{
					value: false,
					label: '不可支付'
				}
			],
			PaymentApplyInfoVisible: false,
			tID: null,
			needMoney: null,
			// 一键申请相关数据
			onceApplyVisible: false,
			localApplications: [],
			applyPaymentVisible: false,
			applyTid: null,
			applyNeedMoney: 0,
			applyNeedInfo: {},
			// 批量填写相关
			batchFillVisible: false,
			batchSubmitting: false,
			batchForm: {
				commissionUnitPrice: '',
				otherPaymentAmount: '',
				difference_reason: '',
				extraInfo: {
					var: '',
					rebate: '',
					period: ''
				}
			},
			batchRules: {
				commissionUnitPrice: [
					{ required: true, message: '请输入佣金单价', trigger: 'blur' },
					{ pattern: /^\d+(\.\d{1,3})?$/, message: '佣金单价格式不正确', trigger: 'blur' }
				]
			}
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
	async created() {
		// 尝试使用系统默认时间范围填充查询条件（只保留日期部分 yyyy-MM-dd）
		try {
			const range = await getDateRangeDays();
			if (range && range.startTime && range.endTime) {
				const start = String(range.startTime).slice(0, 10);
				const end = String(range.endTime).slice(0, 10);
				this.dateRange = [start, end];
				this.queryParams.startTime = start;
				this.queryParams.endTime = end;
			}
		} catch (e) {
			console.error('读取默认时间范围失败', e);
		}

		this.getList(); // 页面加载时获取数据
		if (localStorage.getItem('supplier-commission-columns') === 'null' || !localStorage.getItem('supplier-commission-columns')) {
			localStorage.setItem('supplier-commission-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('supplier-commission-columns'));
		}
	},
	methods: {
		onDateRangeChange(val) {
			// 仅选择完整的时间段时触发搜索；清空时不触发
			if (Array.isArray(val) && val.length === 2) {
				this.dateRange = val;
				this.handleQuery();
			} else {
				this.dateRange = [];
				// 不触发搜索
			}
		},
		handleOnceApply() {
			if (this.selections.length === 0) {
				this.$message.warning('请先选择需要申请的记录');
				return;
			}

			let extra = new ExtraInfo({ sourceInfos: [] });
			this.selections.forEach(item => {
				let s = new SourceInfo({
					tableId: item.id,
					tableName: TableName.ORDERCOMMISION
				});
				extra.pushSourceInfo(s);
			});

			// 计算总金额
			const totalAmount = this.selections.reduce((sum, item) => {
				return sum + (parseFloat(item.commissionAmount) || 0);
			}, 0);

			let applications = this.selections.map(item => {
				return new PaymentApply({
					moneyAmount: totalAmount, // 使用总金额而不是单个金额
					extraInfo: extra,
					tableName: TableName.ORDERCOMMISION, // 后端要求必须传递 否则会出问题
					// 添加新结构需要的字段
					fundsDate: new Date().toISOString().slice(0, 19).replace('T', ' '),
					payType: '',
					otherAcountsName: '',
					otherBankNo: '',
					otherBankName: '',
					companyName: '',
					companyId: null,
					companyType: '',
					reason: '供应商佣金支付申请',
					applyPerson: '',
					applyPersonID: null,
					comments: ''
				});
			});

			// 由于是批量申请，只需要一条申请记录
			applications = [applications[0]];

			// 深拷贝数据并显示申请列表对话框
			this.localApplications = JSON.parse(JSON.stringify(applications));
			this.onceApplyVisible = true;
		},
		// 刷新表格（保留当前时间范围）
		refresh() {
			const range = Array.isArray(this.dateRange) ? this.dateRange : [];
			const [start, end] = range.length === 2 ? range : [null, null];
			// 重置除时间外的其他筛选项
			this.queryParams = {
				companyName: '',
				pageNum: 1,
				pageSize: 20,
				showOrder: '',
				isNoPay: '',
				isCanPay: '',
				startTime: start,
				endTime: end
			};
			// 保留 dateRange，不清空组件
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
				// 将日期范围同步到查询参数
				if (Array.isArray(this.dateRange) && this.dateRange.length === 2) {
					this.queryParams.startTime = this.dateRange[0];
					this.queryParams.endTime = this.dateRange[1];
				} else {
					this.queryParams.startTime = null;
					this.queryParams.endTime = null;
				}
				// 构建符合后端API要求的查询参数
				const queryParams = {
					pageNum: this.queryParams.pageNum,
					pageSize: this.queryParams.pageSize,
					type: CommissionType.SUPPLIER,
					params: {}
				};

				// 添加厂家名称参数
				if (this.queryParams.companyName) {
					queryParams.companyName = this.queryParams.companyName.trim();
				}
				// 添加params参数
				if (this.queryParams.startTime) {
					queryParams.params.startTime = this.queryParams.startTime;
				}
				if (this.queryParams.endTime) {
					queryParams.params.endTime = this.queryParams.endTime;
				}
				if (this.queryParams.isNoPay !== null && this.queryParams.isNoPay !== '') {
					queryParams.params.isNoPay = this.queryParams.isNoPay;
				}
				if (this.queryParams.isCanPay !== null && this.queryParams.isCanPay !== '') {
					queryParams.params.isCanPay = this.queryParams.isCanPay;
				}
				// showOrder: 平时查看给true，一键付款给false
				queryParams.params.showOrder = true;

				console.log(this.queryParams);
				const response = await listCommission(queryParams, CommissionType.SUPPLIER);
				// 为每行数据添加批量选择字段
				this.tableData = response.rows.map(row => ({
					...row,
					batchSelected: false
				}));
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
		// 处理批量勾选变化
		handleBatchSelectionChange() {
			// 手动触发计算属性更新，确保按钮状态正确响应
			this.$nextTick(() => {
				console.log('批量选中状态变化，当前选中数量:', this.batchSelectedRows.length);
				console.log('batchFillDisabled 状态:', this.batchFillDisabled);
				console.log(
					'当前 tableData 中的 batchSelected 状态:',
					this.tableData.map(row => ({
						orderDetailId: row.orderDetailId,
						batchSelected: row.batchSelected
					}))
				);
			});
		},
		// 处理批量勾选框状态变化
		handleBatchToggle(row, value) {
			console.log(`选中`, row, value);

			// 找到 tableData 中对应的行并修改，确保数据的一致性
			const tableDataRow = this.tableData.find(item => item.orderDetailId === row.orderDetailId || (item.id && item.id === row.id));

			if (tableDataRow) {
				// 使用 Vue.set 在 tableData 上设置响应性字段
				this.$set(tableDataRow, 'batchSelected', value);
			}

			this.handleBatchSelectionChange();
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
				this.$antdconfirm({
					title: '提示',
					content: '是否确认删除佣金信息?',
					okText: '确定',
					cancelText: '取消',
					type: 'warning',
					zIndex: 2600,
					onOk: async () => {
						try {
							await deleteCommission(row.id);
							this.$message.success('删除成功');
							this.getList();
						} catch {
							this.$message.error('删除失败，请重试');
						}
					},
					onCancel: () => {
						this.$message.info('已取消删除操作');
					}
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
			// 构建符合后端API要求的导出参数
			const exportParams = {
				pageNum: this.queryParams.pageNum,
				pageSize: this.queryParams.pageSize,
				type: 1, // 供应商佣金类型
				params: {}
			};

			// 添加厂家名称参数
			if (this.queryParams.companyName && this.queryParams.companyName.trim()) {
				exportParams.companyName = this.queryParams.companyName.trim();
			}

			// 添加params参数
			if (this.queryParams.startTime) {
				exportParams.params.startTime = this.queryParams.startTime;
			}
			if (this.queryParams.endTime) {
				exportParams.params.endTime = this.queryParams.endTime;
			}
			if (this.queryParams.isNoPay !== null && this.queryParams.isNoPay !== '') {
				exportParams.params.isNoPay = this.queryParams.isNoPay;
			}
			if (this.queryParams.isCanPay !== null && this.queryParams.isCanPay !== '') {
				exportParams.params.isCanPay = this.queryParams.isCanPay;
			}
			// showOrder: 平时查看给true
			exportParams.params.showOrder = true;

			this.download('system/ordercommission/export', exportParams, `厂家佣金_${new Date().getTime()}.xlsx`);
		},
		changePaymentApplyInfoVisible() {
			this.needMoney = 0;
			this.PaymentApplyInfoVisible = false;
			this.getList();
		},
		// 处理差异原因
		handleDifferenceReason(row) {
			this.$prompt('请输入差异原因', '填写差异原因', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				inputPattern: /\S/,
				inputErrorMessage: '差异原因不能为空',
				inputValue: row.differenceReason || ''
			})
				.then(({ value }) => {
					updateDifferenceReason(row.id, value)
						.then(() => {
							this.$message.success('差异原因更新成功');
							this.getList(); // 刷新列表
						})
						.catch(() => {
							this.$message.error('差异原因更新失败');
						});
				})
				.catch(() => {
					// 用户取消
				});
		},
		// 批量填写佣金
		handleBatchFill() {
			// 获取批量选中的行
			const eligibleRows = this.batchSelectedRows;
			if (eligibleRows.length === 0) {
				this.$message.warning('请先勾选需要批量填写佣金信息的行');
				return;
			}
			// 重置表单
			this.resetBatchForm();
			this.batchFillVisible = true;
		},
		// 重置批量填写表单
		resetBatchForm() {
			this.batchForm = {
				commissionUnitPrice: '',
				otherPaymentAmount: '',
				difference_reason: '',
				extraInfo: {
					var: '',
					rebate: '',
					period: ''
				}
			};
			this.$nextTick(() => {
				if (this.$refs.batchForm) {
					this.$refs.batchForm.clearValidate();
				}
			});
		},
		// 提交批量填写
		submitBatchFill() {
			this.$refs.batchForm.validate(async valid => {
				if (!valid) {
					return;
				}

				// 获取批量选中的行
				const eligibleRows = this.batchSelectedRows;

				if (eligibleRows.length === 0) {
					this.$message.warning('没有可填写的佣金信息');
					return;
				}

				// 构建批量请求数据
				const batchData = eligibleRows.map(row => ({
					type: CommissionType.SUPPLIER,
					orderDetailId: row.orderDetailId,
					commissionUnitPrice: parseFloat(this.batchForm.commissionUnitPrice),
					otherPaymentAmount: parseFloat(this.batchForm.otherPaymentAmount),
					difference_reason: this.batchForm.difference_reason,
					extraInfo: {
						var: this.batchForm.extraInfo.var,
						rebate: this.batchForm.extraInfo.rebate,
						period: this.batchForm.extraInfo.period
					}
				}));

				this.batchSubmitting = true;
				try {
					await batchAddCommission(batchData);
					this.$message.success(`成功批量填写了 ${batchData.length} 条佣金信息`);
					this.batchFillVisible = false;
					this.getList(); // 刷新列表
				} catch (error) {
					this.$message.error('批量填写佣金信息失败，请重试');
					console.error('批量填写佣金信息失败:', error);
				} finally {
					this.batchSubmitting = false;
				}
			});
		},
		// 一键申请相关方法
		handleApproveApply() {
			this.applyPaymentVisible = true;
		},
		// 处理申请信息提交
		handleCommitApplyInfo(value) {
			console.log(`付款申请审核信息`, value);
			this.$nextTick(() => {
				this.localApplications.forEach(item => {
					Object.assign(item, value);
				});
				this.$message.success('申请信息已更新');
			});
		},
		// 处理申请流程
		handleProcessApply() {
			if (this.localApplications.length === 0) {
				this.$message.error('申请列表为空!');
				return;
			}

			try {
				// 处理payType数组转字符串
				this.localApplications.forEach(item => {
					if (Array.isArray(item.payType)) {
						item.payType = item.payType.join('-');
					}
				});
			} catch (err) {
				this.$message.error('请先填写申请信息!');
				return;
			}

			this.$antdconfirm({
				title: '提示',
				content: '确定批量申请吗？',
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: async () => {
					try {
						// 使用优化后的数据转换逻辑
						const firstApplication = this.localApplications[0];
						const currentTime = new Date().toISOString().slice(0, 19).replace('T', ' ');

						// 构建新的数据结构
						const data = {
							fundsDate: firstApplication.fundsDate || currentTime,
							payType: firstApplication.payType || '',
							moneyAmount: parseFloat(firstApplication.moneyAmount) || 0,
							otherAccountsName: firstApplication.otherAcountsName || '', // 注意字段名变化
							otherBankNo: firstApplication.otherBankNo || '',
							otherBankName: firstApplication.otherBankName || '',
							companyName: firstApplication.companyName || '',
							companyId: firstApplication.companyId || null,
							companyType: firstApplication.companyType || '',
							reason: firstApplication.reason || '',
							applyPerson: firstApplication.applyPerson || '',
							applyPersonId: firstApplication.applyPersonID || null, // 注意字段名变化
							comments: firstApplication.comments || '',
							addTime: currentTime,
							userId: this.id || '',
							userName: this.trueName || '',
							// 转换extraInfo为tableReferences
							tableReferences:
								firstApplication.extraInfo && firstApplication.extraInfo.sourceInfos
									? firstApplication.extraInfo.sourceInfos.map(source => ({
											refTableName: source.tableName,
											refTableId: source.tableId,
											amount: parseFloat(firstApplication.moneyAmount) || 0
									  }))
									: []
						};

						// 数据验证
						if (!data.fundsDate || !data.moneyAmount || data.moneyAmount <= 0) {
							this.$message.error('请完善申请信息！');
							return;
						}

						if (data.tableReferences.length === 0) {
							this.$message.error('申请数据异常，请重试！');
							return;
						}

						await addPaymentApply(data);
						this.$message.success('一键申请成功');
						this.onceApplyVisible = false;
						this.$refs[`applyPayment`].reset();
						this.getList(); // 刷新列表
					} catch (error) {
						console.error('申请失败:', error);
						this.$message.error('申请失败，请重试');
					}
				},
				onCancel: () => {
					this.$message.info('已取消批量申请');
				}
			});
		},

		// 判断行是否处于“未申请”状态（仅当未申请时复选框可选）
		isPaymentUnApplied(row) {
			if (row && row.paymentApply && row.paymentApply.checkState !== undefined && row.paymentApply.checkState !== null) {
				return row.paymentApply.checkState === PAYMENT_APPLY_STATE.V2.UN_APPLIED;
			}

			if (row && row.payment && row.payment.paymentState !== undefined && row.payment.paymentState !== null) {
				return row.payment.paymentState !== '已支付' && row.payment.paymentState !== 'PAID';
			}

			return true;
		}
	}
};
</script>

<style scoped></style>
