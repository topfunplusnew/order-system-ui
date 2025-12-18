<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="日期范围" prop="beginTime">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>
			<el-form-item label="公司名称" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入公司名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="票据单位名称" prop="invoiceCompanyName">
				<el-input v-model="queryParams.invoiceCompanyName" placeholder="请输入票据单位名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<!-- 20250710 振龙要求删除 -->
			<!-- <el-col :span="1.5">
				<el-button v-hasPermi="['system:invoiceout:add']" type="danger" size="mini" @click="handleAdd">新增发票卖出信息</el-button>
			</el-col> -->
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:invoiceout:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">批量删除</el-button>
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
						<el-button v-hasPermi="['system:bankaccount:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>
		<div>
			<InvoiceOptionPanel mode="out" />
		</div>
		<el-table
			id="printBox"
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="invoiceOutList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@selection-change="handleSelectionChange"
			@header-dragend="changeColWidth"
		>
			<el-table-column type="selection" width="50" align="center" />
			<el-table-column v-if="columns[0].visible" label="开票日期" align="center" prop="invoiceDate" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.invoiceDate }}</div>
						<span>{{ scope.row.invoiceDate }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="我方收票主体" align="center" prop="invoiceObject" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.invoiceObject }}</div>
						<span>{{ scope.row.invoiceObject }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="开票金额" align="center" prop="invoiceAmount" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.invoiceAmount }}</div>
						<span>{{ scope.row.invoiceAmount }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="公司类别" align="center" prop="companyType" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.companyType }}</div>
						<span>{{ scope.row.companyType }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[4].visible" label="公司名称" align="center" prop="companyName" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.companyName }}</div>
						<span>{{ scope.row.companyName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[5].visible" label="票据单位名称" align="center" prop="invoiceCompanyName" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.invoiceCompanyName }}</div>
						<span>{{ scope.row.invoiceCompanyName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="票点" align="center" prop="ticketPoint" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.ticketPoint }}</div>
						<span>{{ scope.row.ticketPoint }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[7].visible" label="票点金额" align="center" prop="ticketPointAmount" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.ticketPointAmount | changeNumber(changeLength) }}</div>
						<span>{{ scope.row.ticketPointAmount | changeNumber(changeLength) }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[9].visible" label="备注" align="center" prop="comments" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.comments }}</div>
						<span>{{ scope.row.comments }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="银行回执单" align="center" prop="attachmentList">
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
						<div slot="content" @click.stop>
							<div v-if="Array.isArray(scope.row.attachmentList)">
								<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'attachmentList'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOut, updateInvoiceOut)" />
							</div>
							<div v-else>
								<el-tag type="danger">加载错误</el-tag>
							</div>
						</div>
						<div v-if="Array.isArray(scope.row.attachmentList)">
							<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'attachmentList'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOut, updateInvoiceOut)" />
						</div>
						<div v-else>
							<el-tag type="danger">加载错误</el-tag>
						</div>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="发票单" align="center" prop="attachmentList">
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
						<div slot="content" @click.stop>
							<div v-if="Array.isArray(scope.row.attachmentList)">
								<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'attachmentList'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOut, updateInvoiceOut)" />
							</div>
							<div v-else>
								<el-tag type="danger">加载错误</el-tag>
							</div>
						</div>
						<div v-if="Array.isArray(scope.row.attachmentList)">
							<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'attachmentList'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOut, updateInvoiceOut)" />
						</div>
						<div v-else>
							<el-tag type="danger">加载错误</el-tag>
						</div>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="订单信息" align="center" prop="isOrderTax" width="180">
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">
							<el-row v-if="scope.row.isOrderTax === 0">无关联订单</el-row>
							<el-row v-else>
								<el-button size="mini" type="text" @click="checkOrderInfo(scope.row)">查看订单信息</el-button>
							</el-row>
						</div>
						<el-row v-if="scope.row.isOrderTax === 0">无关联订单</el-row>
						<el-row v-else>
							<el-button size="mini" type="text" @click="checkOrderInfo(scope.row)">查看订单信息</el-button>
						</el-row>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
				<template slot-scope="scope">
					<el-dropdown @command="command => handleCommand(command, scope.row)">
						<el-button type="primary" size="mini">
							操作
							<i class="el-icon-arrow-down el-icon--right"></i>
						</el-button>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item v-hasPermi="['system:invoiceout:edit']" :disabled="isBatchLocked(scope.row)" command="edit">
								<template v-if="isBatchLocked(scope.row)">
									<el-tooltip :content="getBatchLockTip()" placement="top">
										<span>修改</span>
									</el-tooltip>
								</template>
								<template v-else>修改</template>
							</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:invoiceout:remove']" :disabled="isBatchLocked(scope.row)" command="delete" divided>
								<template v-if="isBatchLocked(scope.row)">
									<el-tooltip :content="getBatchLockTip()" placement="top">
										<span>删除</span>
									</el-tooltip>
								</template>
								<template v-else>删除</template>
							</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:tableeditmessage:list']" command="viewEditReason">查看修改原因</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
				</template>
			</el-table-column>
		</el-table>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改发票卖出信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="700px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="150px">
				<el-form-item label="开票日期" prop="invoiceDate">
					<el-date-picker v-model="form.invoiceDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<el-form-item label="我方收票主体" prop="invoiceObject">
					<el-input v-model="form.invoiceObject" placeholder="请输入我方收票主体" />
				</el-form-item>
				<el-form-item label="开票金额" prop="invoiceAmount">
					<el-input v-model="form.invoiceAmount" placeholder="请输入开票金额" />
				</el-form-item>
				<el-form-item label="对方公司类型">
					<el-select v-model="type" placeholder="请选择">
						<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="公司名称" prop="companyName">
					<el-row>
						<el-col :span="10">
							<el-input disabled v-model="form.companyName" placeholder="请选择" />
						</el-col>
						<el-col :span="2">
							<SearchOption :limit-info="{ companyType: type }" :get-data="listCompany" query-info="companyName" query-label="公司名称" :query-name="companyName" @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
								<template #table-columns>
									<el-table-column label="客户" align="center" prop="companyName" />
									<el-table-column label="老板姓名" align="center" prop="leader" />
									<el-table-column label="老板电话" align="center" prop="leaderTel" />
									<el-table-column label="区域" align="center" prop="region" />
									<el-table-column label="销售经理" align="center" prop="salesManager" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="票据单位名称" prop="invoiceCompanyName">
					<el-input v-model="form.invoiceCompanyName" placeholder="请输入票据单位名称" />
				</el-form-item>
				<el-form-item label="票点" prop="ticketPoint">
					<el-input v-model="form.ticketPoint" placeholder="请输入票点" />
				</el-form-item>
				<el-form-item label="票点金额" prop="ticketPointAmount">
					<el-input v-model="invoiceAmount" placeholder="请输入票点金额" />
				</el-form-item>
				<el-form-item label="银行回执附件">
					<UploadFilesButton ref="paymentReceiptsUpload" flag="paymentReceipts" :initial-attachments="(form.params && form.params.paymentReceiptsAttachments) || []" :extra-info="{ moduleType: 'invoiceOut', formId: form.id }" @files-updated="handlePaymentReceiptsFilesUpdated" />
				</el-form-item>
				<el-form-item label="发票单">
					<UploadFilesButton ref="invoiceAttachmentsUpload" flag="invoiceAttachments" :initial-attachments="(form.params && form.params.invoiceAttachments) || []" :extra-info="{ moduleType: 'invoiceOut', formId: form.id }" @files-updated="handleInvoiceAttachmentsFilesUpdated" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!-- 查看修改原因弹窗 -->
		<el-dialog title="查看修改原因" :visible.sync="editReasonDialogVisible" width="800px" append-to-body>
			<el-table :data="editReasonList" style="width: 100%">
				<el-table-column prop="addtime" label="修改时间" />
				<el-table-column prop="reason" label="修改原因" />
				<el-table-column prop="userName" label="修改人" />
			</el-table>
			<pagination v-show="editReasonTotal > 0" :total="editReasonTotal" :page.sync="editReasonQueryParams.pageNum" :limit.sync="editReasonQueryParams.pageSize" @pagination="getEditReasonList" />
		</el-dialog>
	</div>
</template>

<script>
import { listInvoiceOut, delInvoiceOut, addInvoiceOut } from '@/api/system/invoiceOut';
import { listTableEditMessage } from '@/api/system/tableEditMessage';
import { updateInvoiceOut, getInvoiceOut } from '../../../api/system/invoiceOut';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { excludeParams } from '@/api/tool/exclude';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { getGoodsOrder } from '@/api/system/goodsOrder';
import CheckOrder from '@/views/dashboard/components/goodsOrder/CheckOrder.vue';
import { addReason } from '@/api/system/user';
import { TableName } from '@/api/tool/enums';
import { addDateRange } from '@/utils/ruoyi';
import CheckFiles from '../../../components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import reLength from '../../dashboard/mixins/reLength';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import InvoiceOptionPanel from '@/views/dashboard/components/common/InvoiceOptionPanel.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';

export default {
	name: 'InvoiceOut',
	components: { CheckFiles, UploadFilesButton, CheckOrder, SearchOption, InvoiceOptionPanel },
	mixins: [mixin_printHTML, reLength, mixin_checkfile, common_dialog],
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
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 发票卖出信息表格数据
			invoiceOutList: [],

			// 分别跟踪不同类型的附件ID
			paymentReceiptIds: [], // 银行回执附件
			invoiceAttachmentIds: [], // 发票单附件

			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			dateRange: [],
			queryParams: {
				beginTime: null,
				endTime: null,
				pageNum: 1,
				pageSize: 20,
				invoiceDate: null,
				invoiceObject: null,
				invoiceAmount: null,
				companyType: null,
				companyName: null,
				companyID: null,
				invoiceCompanyName: null,
				ticketPoint: null,
				ticketPointAmount: null,
				isOrderTax: -1,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				invoiceDate: [
					{
						required: true,
						message: '请选择开票日期',
						trigger: 'blur'
					}
				],
				invoiceObject: [
					{
						required: true,
						message: '请输入我方收票主体',
						trigger: 'blur'
					}
				],
				invoiceAmount: [
					{
						required: true,
						message: '请输入开票金额',
						trigger: 'blur'
					}
				],
				companyName: [
					{
						required: true,
						message: '请输入公司名称',
						trigger: 'blur'
					}
				],
				invoiceCompanyName: [
					{
						required: true,
						message: '请输入票据单位名称',
						trigger: 'blur'
					}
				],
				ticketPoint: [{ required: true, message: '请输入票点', trigger: 'blur' }],
				ticketPointAmount: [
					{
						required: true,
						message: '请输入票点金额',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `开票日期`, visible: true },
				{ key: 1, label: `我方收票主体`, visible: true },
				{ key: 2, label: `开票金额`, visible: true },
				{ key: 3, label: `公司类别`, visible: true },
				{ key: 4, label: `公司名称`, visible: true },
				{ key: 5, label: `票据单位名称`, visible: true },
				{ key: 6, label: `票点`, visible: true },
				{ key: 7, label: `票点金额`, visible: true },
				{ key: 8, label: `订单信息`, visible: true },
				{ key: 9, label: `备注`, visible: true }
			],
			beginTime: '',
			endTime: '',
			// 公司类型
			type: '',
			// 公司名称
			companyName: '',
			// 选项
			options: [
				{
					value: PUBLIC_DICT_TYPE.SUPPLIER,
					label: PUBLIC_DICT_TYPE.SUPPLIER
				},
				{
					value: PUBLIC_DICT_TYPE.CUSTOMER,
					label: PUBLIC_DICT_TYPE.CUSTOMER
				}
			],
			// 查看修改原因相关
			editReasonDialogVisible: false,
			editReasonList: [],
			editReasonTotal: 0,
			editReasonQueryParams: {
				pageNum: 1,
				pageSize: 20,
				tableName: TableName.INVOICE_OUT,
				tid: null
			}
		};
	},
	computed: {
		// 票点金额 开票金额*票点
		invoiceAmount: {
			set(val) {
				this.form.ticketPointAmount = val;
			},
			get() {
				return Number(this.form.invoiceAmount * this.form.ticketPoint).toFixed(3);
			}
		}
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('order-invoiceout-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		// 监听
		form: {
			handler() {
				this.invoiceAmount = this.form.invoiceAmount * this.form.ticketPoint;
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('order-invoiceout-columns') === 'null' || !localStorage.getItem('order-invoiceout-columns')) {
			// 设置localStorage
			localStorage.setItem('order-invoiceout-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('order-invoiceout-columns'));
		}
	},
	methods: {
		updateInvoiceOut,
		getInvoiceOut,
		listCompany,
		getBatchLockTip() {
			return '该发票由批量开票生成，请前往批量开票界面管理';
		},
		isBatchLocked(row) {
			return !!(row && row.batchInvoiceId);
		},
		hasLockedSelection() {
			return Array.isArray(this.ids) && this.ids.length > 0 && this.invoiceOutList.some(item => this.ids.includes(item.id) && this.isBatchLocked(item));
		},
		// 下拉菜单命令处理
		handleCommand(command, row) {
			if (this.isBatchLocked(row) && (command === 'edit' || command === 'delete')) {
				this.$message.warning(this.getBatchLockTip());
				return;
			}
			switch (command) {
				case 'edit':
					this.handleUpdate(row);
					break;
				case 'delete':
					this.handleDelete(row);
					break;
				case 'viewEditReason':
					this.handleViewEditReason(row);
					break;
			}
		},
		// 查看修改原因
		handleViewEditReason(row) {
			this.editReasonQueryParams.tid = row.id;
			this.editReasonQueryParams.pageNum = 1;
			this.getEditReasonList();
			this.editReasonDialogVisible = true;
		},
		// 获取修改原因列表
		getEditReasonList() {
			listTableEditMessage(this.editReasonQueryParams).then(response => {
				this.editReasonList = response.rows;
				this.editReasonTotal = response.total;
			});
		},
		// 统一附件更新处理
		// 银行回执附件更新处理
		handlePaymentReceiptsFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 确保 form.params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}
				// 存储银行回执附件ID
				this.form.params.paymentReceiptsAttachmentIds = [...uploadParams.params.attachmentIds];
				this.updateAllAttachmentIds();
			}
		},
		// 发票单附件更新处理
		handleInvoiceAttachmentsFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 确保 form.params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}
				// 存储发票单附件ID
				this.form.params.invoiceAttachmentsAttachmentIds = [...uploadParams.params.attachmentIds];
				this.updateAllAttachmentIds();
			}
		},
		// 更新所有附件ID到params.attachmentIds
		updateAllAttachmentIds() {
			if (!this.form.params) {
				this.form.params = {};
			}
			// 合并所有类型的附件ID
			const paymentIds = this.form.params.paymentReceiptsAttachmentIds || [];
			const invoiceIds = this.form.params.invoiceAttachmentsAttachmentIds || [];
			const allIds = [...paymentIds, ...invoiceIds];
			// 去重
			this.form.params.attachmentIds = [...new Set(allIds)];
		},
		// 自动填充函数
		handleUpdateCompanyName(val) {
			this.companyName = val;
		},
		handleCommitBackCompany(val) {
			this.form.companyName = val.companyName;
			this.form.companyID = val.id;
			this.form.companyType = val.companyType;
		},
		// 查看订单信息
		checkOrderInfo(row) {
			if (!row || !row.isOrderTax || row.isOrderTax === 0) {
				this.$message.warning('该发票无关联订单');
				return;
			}
			getGoodsOrder(row.isOrderTax)
				.then(res => {
					if (!res || !res.data) {
						this.$message.error('获取订单信息失败');
						return;
					}
					const orderInfo = res.data;
					// 使用 openDialog 打开 CheckOrder 组件
					this.openDialog(
						CheckOrder,
						'查看订单详情',
						'100%',
						{
							orderInfo: orderInfo
						},
						true
					);
				})
				.catch(error => {
					console.error('获取订单信息失败:', error);
					this.$message.error('获取订单信息失败，请重试');
				});
		},
		// 格式化日期范围，按照 QuerySearchBar.vue 的做法
		formatDateRange() {
			if (this.dateRange && this.dateRange.length === 2) {
				// 开始时间：如果只有日期没有时间，添加 00:00:00
				if (String(this.dateRange[0]).length === 10) {
					this.dateRange[0] += ' 00:00:00';
				}
				// 结束时间：如果只有日期没有时间，添加 23:59:59
				if (String(this.dateRange[1]).length === 10) {
					this.dateRange[1] += ' 23:59:59';
				}
			}
		},
		/** 查询发票卖出信息列表 */
		getList() {
			this.loading = true;
			// dateRange invoiceDateStartTime
			listInvoiceOut(addDateRange(this.queryParams, this.dateRange, 'invoiceout')).then(response => {
				this.invoiceOutList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			// 清空sessionStorage中的修改原因
			sessionStorage.removeItem('editReason_invoiceOut_main');
			// 清理 UploadFilesButton 组件状态
			if (this.$refs.paymentReceiptsUpload) {
				this.$refs.paymentReceiptsUpload.clearUploadedFiles();
			}
			if (this.$refs.invoiceAttachmentsUpload) {
				this.$refs.invoiceAttachmentsUpload.clearUploadedFiles();
			}
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				invoiceDate: null,
				invoiceObject: null,
				invoiceAmount: null,
				companyType: null,
				companyName: null,
				companyID: null,
				invoiceCompanyName: null,
				ticketPoint: null,
				ticketPointAmount: null,
				isOrderTax: -1,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				params: {
					attachmentIds: []
				}
			};
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			// 按照 QuerySearchBar.vue 的做法处理时间范围
			this.formatDateRange();
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
			this.title = '添加发票卖出信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			// 先获取发票卖出详情，判断是否需要填写修改原因
			const id = row.id || this.ids;
			getInvoiceOut(id)
				.then(response => {
					const invoiceOutData = response.data;

					// 判断是否需要填写修改原因
					if (invoiceOutData && invoiceOutData.shouldTrackEditReason === true) {
						// 需要填写修改原因
						this.$prompt('请输入修改原因', '提示', {
							confirmButtonText: '确定',
							cancelButtonText: '取消',
							inputType: 'textarea',
							inputPlaceholder: '请输入修改原因',
							inputValidator: value => {
								if (!value || value.trim() === '') {
									return '修改原因不能为空';
								}
								return true;
							}
						})
							.then(({ value }) => {
								// 将修改原因存储到sessionStorage
								sessionStorage.setItem('editReason_invoiceOut_main', value);

								// 继续编辑操作
								this.performInvoiceOutEdit(invoiceOutData);
							})
							.catch(() => {
								this.$message({
									type: 'info',
									message: '已取消修改'
								});
							});
					} else {
						// 不需要填写修改原因，直接进行编辑操作
						this.performInvoiceOutEdit(invoiceOutData);
					}
				})
				.catch(error => {
					console.error('获取发票卖出详情失败:', error);
					this.$message.error('获取发票卖出详情失败');
				});
		},

		// 执行发票卖出编辑操作的逻辑
		performInvoiceOutEdit(invoiceOutData) {
			this.reset();
			this.form = invoiceOutData;

			// 处理附件列表，分别提取不同类型的附件
			if (this.form.attachmentList && Array.isArray(this.form.attachmentList)) {
				// 分别筛选出不同类型的附件
				const paymentReceiptsAttachments = this.form.attachmentList.filter(item => item.flag === 'attachmentList');
				const invoiceAttachments = this.form.attachmentList.filter(item => item.flag === 'attachmentList');

				// 确保 params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}

				// 设置分类的附件数据（注意：invoiceOut 使用的都是 attachmentList flag）
				this.form.params.paymentReceiptsAttachments = paymentReceiptsAttachments;
				this.form.params.invoiceAttachments = invoiceAttachments;

				// 设置所有附件ID
				this.form.params.attachmentIds = this.form.attachmentList.map(item => item.id);
			} else {
				// 确保 params 和 attachmentIds 是数组
				if (!this.form.params) {
					this.form.params = {};
				}
				this.form.params.attachmentIds = [];
				this.form.params.paymentReceiptsAttachments = [];
				this.form.params.invoiceAttachments = [];
			}

			this.open = true;
			this.title = '修改发票卖出信息';
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 创建提交数据的副本，排除不应该提交的数据
					const submitData = { ...this.form };

					// 移除不应该提交给后端的字段
					delete submitData.attachmentList;
					if (submitData.params) {
						delete submitData.params.paymentReceiptsAttachments;
						delete submitData.params.invoiceAttachments;
						delete submitData.params.paymentReceiptsAttachmentIds;
						delete submitData.params.invoiceAttachmentsAttachmentIds;
					}

					if (this.form.id != null) {
						// 编辑时，从sessionStorage获取修改原因
						const editReason = sessionStorage.getItem('editReason_invoiceOut_main');
						if (!editReason || editReason.trim() === '') {
							return;
						}
						submitData.editReason = editReason;

						const finalData = excludeParams(submitData, this.$exclude);
						updateInvoiceOut({
							...finalData,
							params: {
								attachmentIds: this.form.params?.attachmentIds || []
							}
						})
							.then(() => {
								this.$modal.msgSuccess('修改成功');
								this.open = false;
								// 清空sessionStorage中的修改原因
								sessionStorage.removeItem('editReason_invoiceOut_main');
								// 清理 UploadFilesButton 状态
								if (this.$refs.paymentReceiptsUpload) {
									this.$refs.paymentReceiptsUpload.clearUploadedFiles();
								}
								if (this.$refs.invoiceAttachmentsUpload) {
									this.$refs.invoiceAttachmentsUpload.clearUploadedFiles();
								}
								this.getList();
							})
							.catch(() => {
								// 修改失败时不清空sessionStorage，用户可以重试
							});
					} else {
						// 新增时，不需要修改原因
						const finalData = excludeParams(submitData, this.$exclude);
						addInvoiceOut({
							...finalData,
							params: {
								attachmentIds: this.form.params?.attachmentIds || []
							}
						}).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							// 清理 UploadFilesButton 状态
							if (this.$refs.paymentReceiptsUpload) {
								this.$refs.paymentReceiptsUpload.clearUploadedFiles();
							}
							if (this.$refs.invoiceAttachmentsUpload) {
								this.$refs.invoiceAttachmentsUpload.clearUploadedFiles();
							}
							this.getList();
						});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			// 如果传入了 row 参数，则是单行删除；否则是批量删除
			const invoiceIds = row ? [row.id] : this.ids;

			if (row && this.isBatchLocked(row)) {
				this.$message.warning(this.getBatchLockTip());
				return;
			}
			if (!row && this.hasLockedSelection()) {
				this.$message.warning(this.getBatchLockTip());
				return;
			}

			if (!invoiceIds || invoiceIds.length === 0) {
				this.$message.warning('请选择要删除的数据');
				return;
			}

			const confirmMsg = row ? `是否确认删除发票卖出信息编号为"${row.id}"的数据项？` : `是否确认删除选中的${invoiceIds.length}条发票卖出信息？`;

			this.$modal
				.confirm(confirmMsg)
				.then(() => {
					return delInvoiceOut(invoiceIds.join(','));
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
				'system/invoiceOut/export',
				{
					...this.queryParams
				},
				`发票卖出信息_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
