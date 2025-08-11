<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd HH:mm:ss" type="daterange" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>
			<el-form-item label="对方公司" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入对方公司名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="开票单位" prop="invoiceCompanyName">
				<el-input v-model="queryParams.invoiceCompanyName" placeholder="请输入票据单位名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="是否已开发票" prop="isInvoiced">
				<el-select v-model="queryParams.params.isInvoiced" placeholder="请选择" clearable>
					<el-option label="全部" value="" />
					<el-option label="已开发票" value="true" />
					<el-option label="未开发票" value="false" />
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:invoiceout:add']" type="danger" size="mini" @click="handleAdd">新增发票卖出信息</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
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
			<el-table-column label="ID" align="center" type="index" show-overflow-tooltip />
			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="invoiceDate" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="我方开票主体" align="center" prop="invoiceObject" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="开票金额" align="center" prop="invoiceAmount" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="公司类别" align="center" prop="companyType" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="对方公司名称" align="center" prop="companyName" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="票据单位名称" align="center" prop="invoiceCompanyName" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="票点" align="center" prop="ticketPoint" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="票点金额" align="center" prop="ticketPointAmount" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.ticketPointAmount | changeNumber(changeLength) }}
				</template>
			</el-table-column>
			<!-- 新增 extraInfo 属性展示 -->
			<el-table-column v-if="columns[9].visible" label="实际开票金额" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.actualInvoiceAmount }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="开票时间" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.actualInvoiceTime }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="当月欠票金额" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.currentMonthOweInvoiceAmount }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="额外备注" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.comment }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="备注" align="center" prop="comments" show-overflow-tooltip />
			<el-table-column label="银行回执单" align="center" prop="paymentReceipts">
				<template #default="scope">
					<div v-if="Array.isArray(scope.row.attachmentList)">
						<CheckFiles
							:attachmentList="scope.row.attachmentList"
							:flag="'paymentReceipts'"
							@needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOut, updateInvoiceOut)"
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
							@needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOut, updateInvoiceOut)"
						/>
					</div>
					<div v-else>
						<el-tag type="danger">加载错误</el-tag>
					</div>
				</template>
			</el-table-column>

			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180px" fixed="right">
				<template slot-scope="scope">
					<el-button type="text" size="mini" @click="handleAddExtraInfo(scope.row)">补充信息</el-button>
					<el-dropdown @command="(command) => handleCommand(command, scope.row)">
						<el-button type="primary" size="mini">
							操作<i class="el-icon-arrow-down el-icon--right"></i>
						</el-button>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item command="view">查看</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:invoiceout:edit']" command="edit">修改</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:invoiceout:remove']" command="delete" divided>删除</el-dropdown-item>
							<el-dropdown-item command="viewEditReason">查看修改原因</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
				</template>
			</el-table-column>
		</el-table>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改发票卖出信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="700px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="150px">
				<el-form-item label="日期" prop="invoiceDate">
					<el-date-picker v-model="form.invoiceDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<el-form-item label="我方开票主体" prop="invoiceObject">
					<el-input v-model="form.invoiceObject" placeholder="请输入我方开票主体" />
				</el-form-item>
				<el-form-item label="开票金额" prop="invoiceAmount">
					<el-input v-model="form.invoiceAmount" placeholder="请输入开票金额" />
				</el-form-item>
				<el-form-item label="对方公司类型">
					<el-select v-model="type" placeholder="请选择">
						<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
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
				<el-form-item label="开票日期" prop="extraInfo.actualInvoiceTime">
					<el-date-picker v-model="form.extraInfo.actualInvoiceTime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<el-form-item label="银行回执附件">
					<UploadFilesButton 
						ref="receiptUploader" 
						flag="paymentReceipts" 
						:initial-attachments="(form.params && form.params.paymentReceiptsAttachments) || []" 
						:extra-info="{ moduleType: 'noneInvoiceOut', formId: form.id }" 
						@files-updated="handleReceiptFilesUpdated" 
					/>
				</el-form-item>
				<el-form-item label="发票单">
					<UploadFilesButton
						ref="attachmentUploader"
						flag="invoiceAttachments"
						:initial-attachments="(form.params && form.params.invoiceAttachments) || []"
						:extra-info="{ moduleType: 'noneInvoiceOut', formId: form.id }"
						@files-updated="handleAttachmentFilesUpdated"
					/>
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

		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
		</div>

		<!-- 查看修改原因弹窗 -->
		<el-dialog title="查看修改原因" :visible.sync="editReasonDialogVisible" width="800px" append-to-body>
			<el-table :data="editReasonList" style="width: 100%">
				<el-table-column prop="addtime" label="修改时间" />
				<el-table-column prop="reason" label="修改原因" />
				<el-table-column prop="userName" label="修改人" />
			</el-table>
			<pagination 
				v-show="editReasonTotal > 0" 
				:total="editReasonTotal" 
				:page.sync="editReasonQueryParams.pageNum" 
				:limit.sync="editReasonQueryParams.pageSize" 
				@pagination="getEditReasonList" 
			/>
		</el-dialog>
	</div>
</template>

<script>
import { listInvoiceOut, delInvoiceOut, addInvoiceOut, updateInvoiceOut, getInvoiceOut, updateInvoiceOutExtra } from '@/api/system/invoiceOut';
import { listTableEditMessage } from '@/api/system/tableEditMessage';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { excludeParams } from '@/api/tool/exclude';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { getGoodsOrder } from '@/api/system/goodsOrder';
import { addReason } from '@/api/system/user';
import { TableName } from '@/api/tool/enums';
import { addDateRange } from '@/utils/ruoyi';
import CheckFiles from '../../../components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import reLength from '../../dashboard/mixins/reLength';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import INVOICE_OUT from '@/components/NeedToShow/INVOICE_OUT.vue';

export default {
	name: 'NoneInvoiceOut',
	components: { DialogWrapper, CheckFiles, UploadFilesButton, SearchOption },
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
				delFlag: null,
				params: {
					isInvoiced: null
				}
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
				{ key: 8, label: `备注`, visible: true },
				// 新增的 extraInfo 相关列
				{ key: 9, label: `实际开票金额`, visible: true },
				{ key: 10, label: `实际开票时间`, visible: true },
				{ key: 11, label: `当月欠票金额`, visible: true },
				{ key: 12, label: `额外备注`, visible: true }
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
			orderInfo: {},
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
			},
			// 查看修改原因相关
			editReasonDialogVisible: false,
			editReasonList: [],
			editReasonTotal: 0,
			editReasonQueryParams: {
				pageNum: 1,
				pageSize: 10,
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
				localStorage.setItem('inone-invoiceout-columns', JSON.stringify(newVal));
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
		this.reset();
		this.getList();
		if (localStorage.getItem('inone-invoiceout-columns') === 'null' || !localStorage.getItem('inone-invoiceout-columns')) {
			// 设置localStorage
			localStorage.setItem('inone-invoiceout-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('inone-invoiceout-columns'));
		}
	},
	methods: {
		updateInvoiceOut,
		getInvoiceOut,
		listCompany,
		// 下拉菜单命令处理
		handleCommand(command, row) {
			switch (command) {
				case 'view':
					this.handleCheck(row);
					break;
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
		// 发票收据附件更新处理
		handleReceiptFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 存储银行回执附件ID
				this.paymentReceiptIds = uploadParams.params.attachmentIds;
				this.updateAllAttachmentIds();
			}
		},
		// 其他附件更新处理
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
		// 自动填充函数
		handleUpdateCompanyName(val) {
			this.companyName = val;
		},
		handleCommitBackCompany(val) {
			console.log(val);
			this.form.companyName = val.companyName;
			this.form.companyID = val.id;
			this.form.companyType = val.companyType;
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
			sessionStorage.removeItem('editReason_invoiceOut');
			// 清空两个上传附件显示的文件列表
			this.$refs.receiptUploader.clearUploadedFiles();
			this.$refs.attachmentUploader.clearUploadedFiles();
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
				isOrderTax: 0,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				// 添加额外信息字段
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
			this.dateRange = [];
			this.queryParams.companyName = null;
			this.queryParams.invoiceCompanyName = null;
			this.queryParams.params.isInvoiced = null;
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
			this.$prompt('请输入修改原因', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				inputType: 'textarea',
				inputPlaceholder: '请输入修改原因',
				inputValidator: (value) => {
					if (!value || value.trim() === '') {
						return '修改原因不能为空';
					}
					return true;
				},
				inputErrorMessage: '修改原因不能为空'
			}).then(({ value }) => {
				// 将修改原因保存到sessionStorage
				sessionStorage.setItem('editReason_invoiceOut', value);
				this.reset();
				const id = row.id || this.ids;
				getInvoiceOut(id).then(response => {
					this.form = response.data;
					
					// 处理附件列表，分别提取不同类型的附件
					if (this.form.attachmentList && Array.isArray(this.form.attachmentList)) {
						// 分别筛选出不同类型的附件
						const paymentReceiptsAttachments = this.form.attachmentList.filter(item => item.flag === 'paymentReceipts');
						const invoiceAttachments = this.form.attachmentList.filter(item => item.flag === 'invoiceAttachments');
						
						// 确保 params 对象存在
						if (!this.form.params) {
							this.form.params = {};
						}
						
						// 设置分类的附件数据
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
				});
			}).catch(() => {
				this.$message.info('已取消修改');
			});
		},
		// 银行回执
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
					// 创建提交数据的副本
					const submitData = { ...this.form };
					
					if (this.form.id != null) {
						// 编辑时，从sessionStorage获取修改原因
						const editReason = sessionStorage.getItem('editReason_invoiceOut');
						if (!editReason || editReason.trim() === '') {
							this.$message.error('修改原因丢失，请重新进入编辑');
							return;
						}
						submitData.editReason = editReason;
						
						const finalData = excludeParams(submitData, this.$exclude);
						updateInvoiceOut({
							...finalData,
							params: {
								attachmentIds: finalData.params?.attachmentIds || []
							}
						}).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							// 清空sessionStorage中的修改原因
							sessionStorage.removeItem('editReason_invoiceOut');
							// 清空两个上传附件显示的文件列表
							this.$refs.receiptUploader.clearUploadedFiles();
							this.$refs.attachmentUploader.clearUploadedFiles();
							this.getList();
						}).catch(() => {
							// 修改失败时不清空sessionStorage，用户可以重试
						});
					} else {
						// 新增时，不需要修改原因
						const finalData = excludeParams(submitData, this.$exclude);
						addInvoiceOut({
							...finalData,
							params: {
								attachmentIds: finalData.params?.attachmentIds || []
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
				.confirm('是否确认删除发票卖出信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delInvoiceOut(ids);
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
				`invoiceOut_${new Date().getTime()}.xlsx`
			);
		},
		/** 查看按钮操作 */
		handleCheck(row) {
			if (!row.id) {
				this.$message.error('行数据有误!');
				return;
			}
			getInvoiceOut(row.id).then(res => {
				if (!res.data) {
					this.$message.error('暂无该条数据');
					return;
				}
				this.openDialog(
					INVOICE_OUT,
					'发票信息',
					'900px',
					{
						needToShowInfo: res.data
					},
					false
				);
			});
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
						updateInvoiceOutExtra(this.currentRow.id, this.currentExtraInfo)
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
