<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<!--      时间查询-->
			<el-form-item label="开票开始日期" prop="beginTime">
				<el-date-picker v-model="queryParams.beginTime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" />
			</el-form-item>
			<el-form-item label="开票结束日期" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:invoicein:add']" type="danger" size="mini" @click="handleAdd">新增发票购入信息</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:orderdetail:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="invoiceInList"
			fit
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@header-dragend="changeColWidth"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="invoiceDate" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="我方收票主体" align="center" prop="invoiceObject" show-overflow-tooltip width="100px" />
			<el-table-column v-if="columns[2].visible" label="开票金额" align="center" prop="invoiceAmount" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="对方公司类别" align="center" prop="companyType" width="100px" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="对方公司名称" align="center" prop="companyName" width="100px" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="票据单位名称" align="center" prop="invoiceCompanyName" show-overflow-tooltip width="100px" />
			<el-table-column v-if="columns[6].visible" label="票点" align="center" prop="ticketPoint" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="票点金额" align="center" prop="ticketPointAmount" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.ticketPointAmount }}
				</template>
			</el-table-column>
			<!-- 新增 extraInfo 属性展示 -->
			<el-table-column v-if="columns[11].visible" label="实际开票金额" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.actualInvoiceAmount }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="开票时间" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.actualInvoiceTime }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[13].visible" label="当月欠票金额" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.currentMonthOweInvoiceAmount }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[14].visible" label="额外备注" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.comment }}
				</template>
			</el-table-column>
			<!-- 现在不显示 -->
			<el-table-column v-if="columns[9].visible && false" label="审核状态" align="center" prop="checkState" width="240">
				<template #default="scope">
					<el-row>
						<el-col :span="12">
							<el-tag>
								{{ scope.row.checkState }}
							</el-tag>
						</el-col>
						<el-col :span="12">
							<el-button size="mini" type="text" :disabled="scope.row.checkState !== '未申请'" @click="addPaymentApplyInfos(scope.row)">添加付款申请</el-button>
						</el-col>
					</el-row>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="备注" align="center" prop="comments" />
			<el-table-column label="银行回执单" align="center" prop="paymentReceipts">
				<template #default="scope">
					<div v-if="Array.isArray(scope.row.attachmentList)">
						<CheckFiles
							:attachmentList="scope.row.attachmentList"
							:flag="'paymentReceipts'"
							@needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceIn, updateInvoiceIn)"
						/>
					</div>
					<div v-else>
						<el-tag type="danger">加载错误</el-tag>
					</div>
				</template>
			</el-table-column>
			<el-table-column label="发票单" align="center" prop="invoiceAttachments">
				<template #default="scope">
					<div v-if="Array.isArray(scope.row.attachmentList)">
						<CheckFiles
							:attachmentList="scope.row.attachmentList"
							:flag="'invoiceAttachments'"
							@needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceIn, updateInvoiceIn)"
						/>
					</div>
					<div v-else>
						<el-tag type="danger">加载错误</el-tag>
					</div>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="180px">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="handleCheck(scope.row)">查看</el-button>
					<el-button size="mini" type="text" @click="handleAddExtraInfo(scope.row)">补充信息</el-button>
					<el-button v-hasPermi="['system:invoicein:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:invoicein:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改发票购入信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="700px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="150px">
				<!--        新增开票日期 需要单独的接口来进行新增操作-->
				<el-form-item label="开票日期" prop="extraInfo.actualInvoiceTime">
					<el-date-picker v-model="form.extraInfo.actualInvoiceTime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" />
				</el-form-item>
				<el-form-item label="日期" prop="invoiceDate">
					<el-date-picker v-model="form.invoiceDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" />
				</el-form-item>
				<el-form-item label="我方收票主体" prop="invoiceObject">
					<el-input v-model="form.invoiceObject" placeholder="请输入我方收票主体" />
				</el-form-item>
				<el-form-item label="开票金额" prop="invoiceAmount">
					<el-input v-model="form.invoiceAmount" placeholder="请输入开票金额" />
				</el-form-item>
				<el-form-item label="对方公司类型">
					<el-select v-model="type" placeholder="请选择">
						<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
					</el-select>
				</el-form-item>
				<el-form-item label="对方公司名称" prop="companyName">
					<el-row>
						<el-col :span="10">
							<el-input disabled v-model="form.companyName" placeholder="请选择" />
						</el-col>
						<el-col :span="2">
							<SearchOption
								:limit-info="{ companyType: type }"
								:get-data="listCompany"
								query-info="companyName"
								query-label="公司名称"
								:query-name="companyName"
								@update:queryName="handleUpdateCompanyName"
								@commitBack="handleCommitBackCompany"
							>
								<template #table-columns>
									<el-table-column :label="type" align="center" prop="companyName" />
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
					<UploadFilesButton ref="receiptUploader" flag="paymentReceipts" :extra-info="{ moduleType: 'noneInvoiceIn', formId: form.id }" @files-updated="handleReceiptFilesUpdated" />
				</el-form-item>
				<el-form-item label="发票单">
					<UploadFilesButton
						ref="attachmentUploader"
						flag="invoiceAttachments"
						:extra-info="{ moduleType: 'noneInvoiceIn', formId: form.id }"
						@files-updated="handleAttachmentFilesUpdated"
					/>
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
				<!-- 修改原因字段，只在修改时显示 -->
				<el-form-item v-if="form.id != null" label="修改原因" prop="editReason">
					<el-input v-model="form.editReason" placeholder="请输入修改原因" type="textarea" :rows="3" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!-- 补充信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="'补充发票信息'" :visible.sync="extraInfoDialogVisible" width="500px" append-to-body>
			<el-form ref="extraInfoForm" :model="currentExtraInfo" :rules="extraInfoRules" label-width="120px">
				<el-form-item label="实际开票金额" prop="actualInvoiceAmount">
					<el-input v-model="currentExtraInfo.actualInvoiceAmount" placeholder="请输入实际开票金额"></el-input>
				</el-form-item>
				<el-form-item label="实际开票时间" prop="actualInvoiceTime">
					<el-date-picker v-model="currentExtraInfo.actualInvoiceTime" type="datetime" placeholder="请选择实际开票时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<el-form-item label="当月欠票金额" prop="currentMonthOweInvoiceAmount">
					<el-input v-model="currentExtraInfo.currentMonthOweInvoiceAmount" placeholder="请输入当月欠票金额"></el-input>
				</el-form-item>
				<el-form-item label="备注" prop="comment">
					<el-input v-model="currentExtraInfo.comment" type="textarea" placeholder="请输入备注信息（选填）"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="saveExtraInfo">确 定</el-button>
				<el-button @click="extraInfoDialogVisible = false">取 消</el-button>
			</div>
		</el-dialog>

		<!--    添加付款申请-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="付款申请"
			:visible.sync="PaymentApplyInfoVisible"
			append-to-body
		>
			<ApplyPayment :table-name="TableName.INVOICE_IN" :t-i-d="tID" :need-money="needMoney" :need-info="{}" @changeOpen="changePaymentApplyInfoVisible" />
		</el-dialog>

		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="true"
			title="查看订单信息"
			:visible.sync="checkOrderInfoVisible"
			width="70%"
			append-to-body
		>
			<OrderInfos :order-info="orderInfo" />
		</el-dialog>

		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
		</div>
	</div>
</template>

<script>
import { listInvoiceIn, delInvoiceIn, addInvoiceIn } from '@/api/system/invoiceIn';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { TableName } from '@/api/tool/enums';
import { excludeParams } from '@/api/tool/exclude';
import { addReason } from '@/api/system/user';
import { getGoodsOrder } from '@/api/system/goodsOrder';
import OrderInfos from '@/views/dashboard/components/goodsOrder/OrderInfos.vue';
import CheckFiles from '../../../components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import reLength from '../../dashboard/mixins/reLength';
import { getInvoiceIn, updateInvoiceIn, updateInvoiceInExtra } from '../../../api/system/invoiceIn';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { parseTime } from '@/utils/ruoyi';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue';

export default {
	name: 'NoneInvoiceIn',
	components: { DialogWrapper, CheckFiles, UploadFilesButton, OrderInfos, ApplyPayment, SearchOption },
	mixins: [mixin_printHTML, reLength, mixin_checkfile, common_dialog],
	data() {
		// 金额格式验证（最多两位小数）
		const validateAmount = (rule, value, callback) => {
			if (value === '' || value === null || value === undefined) {
				callback(new Error('请输入金额'));
			} else {
				const reg = /^(\d+)(\.\d{1,2})?$/;
				if (!reg.test(value)) {
					callback(new Error('金额格式不正确，最多两位小数'));
				} else {
					callback();
				}
			}
		};
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
			// 发票购入信息表格数据
			invoiceInList: [],

			// 分别跟踪不同类型的附件ID
			paymentReceiptIds: [], // 银行回执附件
			invoiceAttachmentIds: [], // 发票单附件

			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				invoiceDate: null,
				invoiceObject: null,
				invoiceAmount: null,
				companyType: null,
				companyName: null,
				companyID: null,
				invoiceCompanyName: null,
				ticketPoint: null,
				ticketPointAmount: null,
				isOrderTax: 0,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 表单参数
			form: {
				editReason: null // 添加修改原因字段
			},
			orderInfo: {},
			checkOrderInfoVisible: false,
			// 表单校验
			rules: {
				invoiceDate: [
					{
						required: true,
						message: '请选择日期',
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
				companyType: [
					{
						required: true,
						message: '请选择对方公司类型',
						trigger: 'blur'
					}
				],
				companyName: [
					{
						required: true,
						message: '请输入对方公司名称',
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
				],
				// 只有在修改时（form.id不为null）才需要验证修改原因
				editReason: [
					{
						validator: (rule, value, callback) => {
							if (this.form.id != null && (!value || value.trim() === '')) {
								callback(new Error('修改时必须填写修改原因'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `开票日期`, visible: true },
				{ key: 1, label: `我方收票主体`, visible: true },
				{ key: 2, label: `开票金额`, visible: true },
				{ key: 3, label: `对方公司类别`, visible: true },
				{ key: 4, label: `对方公司名称`, visible: true },
				{ key: 5, label: `票据单位名称`, visible: true },
				{ key: 6, label: `票点`, visible: true },
				{ key: 7, label: `票点金额`, visible: true },
				{ key: 8, label: `订单信息`, visible: true },
				{ key: 9, label: `审核状态`, visible: true },
				{ key: 10, label: `备注`, visible: true },
				// 新增的 extraInfo 相关列
				{ key: 11, label: `实际开票金额`, visible: true },
				{ key: 12, label: `实际开票时间`, visible: true },
				{ key: 13, label: `当月欠票金额`, visible: true },
				{ key: 14, label: `额外备注`, visible: true }
			],

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
			// 付款申请
			PaymentApplyInfoVisible: false,
			tID: '',
			needMoney: 0,
			// 补充信息对话框
			extraInfoDialogVisible: false,
			currentExtraInfo: {},
			currentRow: null,
			extraInfoRules: {
				actualInvoiceAmount: [
					{ required: true, message: '请输入实际开票金额', trigger: 'blur' },
					{ validator: validateAmount, trigger: 'blur' }
				],
				actualInvoiceTime: [{ required: true, message: '请选择实际开票时间', trigger: 'blur' }],
				currentMonthOweInvoiceAmount: [
					{ required: true, message: '请输入当月欠票金额', trigger: 'blur' },
					{ validator: validateAmount, trigger: 'blur' }
				]
				// 备注字段不需要验证，因为是可选的
			}
		};
	},
	computed: {
		TableName() {
			return TableName;
		},
		// 票点金额 开票金额*票点
		invoiceAmount: {
			set(val) {
				this.form.ticketPointAmount = val;
			},
			get() {
				// 保留两位小数
				return Number(this.form.invoiceAmount * this.form.ticketPoint).toFixed(3);
			}
		}
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('none-invoicein-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		form: {
			handler() {
				this.invoiceAmount = Number(this.form.invoiceAmount * this.form.ticketPoint).toFixed(3);
			},
			deep: true
		}
	},
	created() {
		this.reset();
		this.getList();
		if (localStorage.getItem('none-invoicein-columns') === 'null' || !localStorage.getItem('none-invoicein-columns')) {
			// 设置localStorage
			localStorage.setItem('none-invoicein-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('none-invoicein-columns'));
		}
	},
	methods: {
		updateInvoiceIn,
		getInvoiceIn,
		listCompany,
		// 银行回执附件更新处理
		handleReceiptFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 存储银行回执附件ID
				this.paymentReceiptIds = uploadParams.params.attachmentIds;
				this.updateAllAttachmentIds();
			}
		},
		// 发票单附件更新处理
		handleAttachmentFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 存储发票单附件ID
				this.invoiceAttachmentIds = uploadParams.params.attachmentIds;
				this.updateAllAttachmentIds();
			}
		},
		// 更新所有附件ID到params.attachmentIds
		updateAllAttachmentIds() {
			if (!this.form.params) {
				this.$set(this.form, 'params', { attachmentIds: [] });
			}
			// 合并所有类型的附件ID
			const allIds = [...(this.paymentReceiptIds || []), ...(this.invoiceAttachmentIds || [])];
			// 去重
			this.form.params.attachmentIds = [...new Set(allIds)];
		},
		/** 查询发票购入信息列表 */
		getList() {
			this.loading = true;
			listInvoiceIn(this.queryParams).then(response => {
				this.invoiceInList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		handleUpdateCompanyName(val) {
			this.companyName = val;
		},
		handleCommitBackCompany(val) {
			console.log(val);
			this.form.companyName = val.companyName;
			this.form.companyID = val.id;
			this.form.companyType = val.companyType;
		},
		// 添加付款申请
		addPaymentApplyInfos(row) {
			this.tID = row.id;
			this.needMoney = row.ticketPointAmount;
			this.PaymentApplyInfoVisible = true;
		},
		changePaymentApplyInfoVisible() {
			this.needMoney = 0;
			this.PaymentApplyInfoVisible = false;
			this.getList();
		},
		// 取消按钮
		cancel() {
			// 清空两个上传附件显示的文件列表
			this.$refs.receiptUploader.clearUploadedFiles();
			this.$refs.attachmentUploader.clearUploadedFiles();
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				invoiceDate: parseTime(new Date()),
				invoiceObject: null,
				invoiceAmount: null,
				companyType: null,
				companyName: null,
				companyID: null,
				invoiceCompanyName: null,
				ticketPoint: null,
				ticketPointAmount: null,
				isOrderTax: 0,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				editReason: null, // 重置修改原因
				// 额外信息
				extraInfo: {
					actualInvoiceAmount: null,
					actualInvoiceTime: null,
					currentMonthOweInvoiceAmount: null,
					comment: null
				}
			};
			this.resetForm('form');
			// 重置附件数组
			this.paymentReceiptIds = [];
			this.invoiceAttachmentIds = [];
		},
		/** 搜索按钮操作 */
		handleQuery() {
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
			this.title = '添加发票购入信息';
		},
		// 查看改行的发票信息
		handleCheck(row) {
			if (!row.id) {
				this.$message.error('改行数据有误!');
				return;
			}
			getInvoiceIn(row.id).then(res => {
				if (!res.data) {
					this.$message.error('暂无该条数据');
					return;
				}
				this.openDialog(
					INVOICE_IN,
					'发票信息',
					'900px',
					{
						needToShowInfo: res.data
					},
					true
				);
			});
		},
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getInvoiceIn(id).then(response => {
				this.form = response.data;
				this.form.editReason = null; // 打开编辑时清空修改原因
				this.open = true;
				this.title = '修改发票购入信息';
			});
		}, // 银行回执
		handleCommitUpload(val) {
			this.form.paymentReceipts = val;
		},
		// 发票单
		handleCommitUploadInvoiceAttachments(val) {
			this.form.invoiceAttachments = val;
		},

		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 编辑时校验修改原因
					if (this.form.id != null && (!this.form.editReason || this.form.editReason.trim() === '')) {
						this.$message.error('修改时必须填写修改原因');
						return;
					}
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateInvoiceIn({
							...this.form,
							params: {
								attachmentIds: this.form.params?.attachmentIds || []
							}
						}).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							// 清空两个上传附件显示的文件列表
							this.$refs.receiptUploader.clearUploadedFiles();
							this.$refs.attachmentUploader.clearUploadedFiles();
							this.getList();
						});
					} else {
						// 新增时，移除修改原因字段
						delete this.form.editReason;
						this.form = excludeParams(this.form, this.$exclude);
						addInvoiceIn({
							...this.form,
							params: {
								attachmentIds: this.form.params?.attachmentIds || []
							}
						}).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							// 清空两个上传附件显示的文件列表
							this.$refs.receiptUploader.clearUploadedFiles();
							this.$refs.attachmentUploader.clearUploadedFiles();
							this.getList();
						});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除发票购入信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delInvoiceIn(ids);
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
				'system/invoiceIn/export',
				{
					...this.queryParams
				},
				`invoiceIn_${new Date().getTime()}.xlsx`
			);
		},

		/** 补充信息操作 */
		handleAddExtraInfo(row) {
			this.currentRow = row;
			// 确保extraInfo存在
			this.currentExtraInfo = row.extraInfo
				? { ...row.extraInfo }
				: {
						actualInvoiceAmount: null,
						actualInvoiceTime: null,
						currentMonthOweInvoiceAmount: null,
						comment: null
				  };
			this.extraInfoDialogVisible = true;
		},

		/** 保存补充信息 */
		saveExtraInfo() {
			this.$refs['extraInfoForm'].validate(valid => {
				if (valid) {
					if (this.currentRow) {
						updateInvoiceInExtra(this.currentRow.id, this.currentExtraInfo)
							.then(() => {
								this.$modal.msgSuccess('补充信息更新成功');
								this.extraInfoDialogVisible = false;
								this.getList();
							})
							.catch(error => {
								this.$modal.msgError('更新失败: ' + error);
							});
					}
				} else {
					return false;
				}
			});
		}
	}
};
</script>
