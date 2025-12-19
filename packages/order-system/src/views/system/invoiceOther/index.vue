<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="日期范围" prop="invoiceDate">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd HH:mm:ss" type="daterange" start-placeholder="开始日期" end-placeholder="结束日期" />
			</el-form-item>
			<el-form-item label="开票单位" prop="invoiceCompanyName">
				<el-input v-model="queryParams.invoiceCompanyName" placeholder="请输入开票单位" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方名称" prop="mixCompanyName">
				<el-input v-model="queryParams.params.mixCompanyName" placeholder="可搜索供应商或客户名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="开票状态" prop="isInvoiced">
				<el-select v-model="queryParams.params.isInvoiced" placeholder="请选择开票状态" clearable @keyup.enter.native="handleQuery" style="width: 150px">
					<el-option label="已开票" value="true" />
					<el-option label="未开票" value="false" />
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:invoiceother:add']" type="danger" size="mini" @click="handleAdd">新增</el-button>
			</el-col>
			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:invoiceother:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="invoiceOtherList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@header-dragend="changeColWidth"
			@selection-change="handleSelectionChange"
		>
			<el-table-column label="ID" align="center" prop="id" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.id }}</div>
						<span>{{ scope.row.id }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="invoiceDate" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ parseTime(scope.row.invoiceDate, '{y}-{m}-{d}') }}</div>
						<span>{{ parseTime(scope.row.invoiceDate, '{y}-{m}-{d}') }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[4].visible" label="开票方公司名称" align="center" prop="Supplier" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.Supplier }}</div>
						<span>{{ scope.row.Supplier }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="开票金额" align="center" prop="invoiceAmount" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.invoiceAmount }}</div>
						<span>{{ scope.row.invoiceAmount }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="开票方票点" align="center" prop="supplierTicketPoint" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.supplierTicketPoint }}</div>
						<span>{{ scope.row.supplierTicketPoint }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="开票方票点金额" align="center" prop="supplierPointAmount" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.supplierPointAmount | changeNumber(changeLength) }}</div>
						<span>{{ scope.row.supplierPointAmount | changeNumber(changeLength) }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[5].visible" label="收票方公司名称" align="center" prop="customer" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.customer }}</div>
						<span>{{ scope.row.customer }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="票据单位名称" align="center" prop="invoiceCompanyName" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.invoiceCompanyName }}</div>
						<span>{{ scope.row.invoiceCompanyName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[7].visible" label="收票方票点" align="center" prop="customerTicketPoint" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.customerTicketPoint }}</div>
						<span>{{ scope.row.customerTicketPoint }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="收票方票点金额" align="center" prop="customerPointAmount" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.customerPointAmount | changeNumber(changeLength) }}</div>
						<span>{{ scope.row.customerPointAmount | changeNumber(changeLength) }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="票点差额" align="center" prop="pointAmountDifference" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.pointAmountDifference }}</div>
						<span>{{ scope.row.pointAmountDifference }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="实际开票金额" align="center" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.extraInfo && scope.row.extraInfo.actualInvoiceAmount }}</div>
						<span>{{ scope.row.extraInfo && scope.row.extraInfo.actualInvoiceAmount }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="实际开票时间" align="center" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ parseTime(scope.row.extraInfo && scope.row.extraInfo.actualInvoiceTime, '{y}-{m}-{d}') }}</div>
						<span>{{ parseTime(scope.row.extraInfo && scope.row.extraInfo.actualInvoiceTime, '{y}-{m}-{d}') }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[13].visible" label="当月欠票金额" align="center" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.extraInfo && scope.row.extraInfo.currentMonthOweInvoiceAmount }}</div>
						<span>{{ scope.row.extraInfo && scope.row.extraInfo.currentMonthOweInvoiceAmount }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[14].visible" label="额外备注" align="center" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.extraInfo && scope.row.extraInfo.comment }}</div>
						<span>{{ scope.row.extraInfo && scope.row.extraInfo.comment }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<!-- 2025-11-4 去除订单信息查看 -->
			<!-- <el-table-column v-if="columns[9].visible" label="订单信息" align="center" prop="isOrderTax" width="180" show-overflow-tooltip>
			<template slot-scope="scope">
				<el-row v-if="scope.row.isOrderTax === 0">无关联订单</el-row>
				<el-row v-else>
					<el-button size="mini" type="text" @click="checkOrderInfo(scope.row)">查看订单信息</el-button>
				</el-row>
			</template>
		</el-table-column> -->
			<el-table-column label="银行回执单" align="center" prop="attachmentList">
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
						<div slot="content" @click.stop>
							<div v-if="Array.isArray(scope.row.attachmentList)">
								<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'attachmentList'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOther, updateInvoiceOther)" />
							</div>
							<div v-else>
								<el-tag type="danger">加载错误</el-tag>
							</div>
						</div>
						<div v-if="Array.isArray(scope.row.attachmentList)">
							<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'attachmentList'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOther, updateInvoiceOther)" />
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
								<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'invoiceAttachmentList'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOther, updateInvoiceOther)" />
							</div>
							<div v-else>
								<el-tag type="danger">加载错误</el-tag>
							</div>
						</div>
						<div v-if="Array.isArray(scope.row.attachmentList)">
							<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'invoiceAttachmentList'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOther, updateInvoiceOther)" />
						</div>
						<div v-else>
							<el-tag type="danger">加载错误</el-tag>
						</div>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="备注" align="center" prop="comments">
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.comments }}</div>
						<span>{{ scope.row.comments }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180px" fixed="right">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="handleAddExtraInfo(scope.row)">补充信息</el-button>
					<el-dropdown @command="command => handleCommand(command, scope.row)">
						<el-button type="primary" size="mini">
							操作
							<i class="el-icon-arrow-down el-icon--right"></i>
						</el-button>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item command="view">查看</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:invoiceother:edit']" command="edit">修改</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:invoiceother:remove']" command="delete" divided>删除</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:tableeditmessage:list']" command="viewEditReason">查看修改原因</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改商家直接给客户开发票对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" append-to-body width="800px">
			<el-row>
				<el-form ref="form" :model="form" :rules="rules" label-width="140px">
					<el-col :span="12">
						<el-form-item label="日期" prop="invoiceDate">
							<el-date-picker v-model="form.invoiceDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>

						<el-form-item label="开票金额" prop="invoiceAmount">
							<el-input v-model="form.invoiceAmount" placeholder="请输入开票金额" />
						</el-form-item>
						<!-- 开票方公司类型：只是一个名称标识，实际值可以为客户或供应商 -->
						<el-form-item label="开票方公司类型" prop="supplierCompanyType">
							<el-radio-group v-model="form.supplierCompanyType">
								<el-radio :label="PUBLIC_DICT_TYPE.CUSTOMER">{{ PUBLIC_DICT_TYPE.CUSTOMER }}</el-radio>
								<el-radio :label="PUBLIC_DICT_TYPE.SUPPLIER">{{ PUBLIC_DICT_TYPE.SUPPLIER }}</el-radio>
							</el-radio-group>
						</el-form-item>
						<el-form-item label="开票方公司名称" prop="Supplier">
							<el-col :span="20">
								<el-input disabled v-model="form.Supplier" placeholder="请选择" />
							</el-col>
							<el-col :span="4">
								<SearchOption
									:limit-info="{ companyType: form.supplierCompanyType || PUBLIC_DICT_TYPE.SUPPLIER }"
									:get-data="listCompany"
									query-info="companyName"
									query-label="公司名称"
									:query-name="queryCompanyName"
									@update:queryName="handleUpdateCompanyName"
									@commitBack="handleCommitBackCompany"
								>
									<template #table-columns>
										<el-table-column :label="form.supplierCompanyType || '开票方'" align="center" prop="companyName" />
										<el-table-column label="老板姓名" align="center" prop="leader" />
										<el-table-column label="老板电话" align="center" prop="leaderTel" />
										<el-table-column label="区域" align="center" prop="region" />
										<el-table-column label="销售经理" align="center" prop="salesManager" />
									</template>
								</SearchOption>
							</el-col>
						</el-form-item>

						<el-form-item label="开票方票点" prop="supplierTicketPoint">
							<el-input v-model="form.supplierTicketPoint" placeholder="请输入开票方票点" />
						</el-form-item>
						<el-form-item label="开票方票点金额" prop="supplierPointAmount">
							<el-input disabled v-model="form.supplierPointAmount" placeholder="请输入开票方票点金额" />
						</el-form-item>
						<!-- 收票方公司类型：只是一个名称标识，实际值可以为客户或供应商 -->
						<el-form-item label="收票方公司类型" prop="customerCompanyType">
							<el-radio-group v-model="form.customerCompanyType">
								<el-radio :label="PUBLIC_DICT_TYPE.CUSTOMER">{{ PUBLIC_DICT_TYPE.CUSTOMER }}</el-radio>
								<el-radio :label="PUBLIC_DICT_TYPE.SUPPLIER">{{ PUBLIC_DICT_TYPE.SUPPLIER }}</el-radio>
							</el-radio-group>
						</el-form-item>
						<el-form-item label="收票方公司名称" prop="customer">
							<el-col :span="20">
								<el-input disabled v-model="form.customer" placeholder="请选择" />
							</el-col>
							<el-col :span="4">
								<SearchOption
									:limit-info="{ companyType: form.customerCompanyType || PUBLIC_DICT_TYPE.CUSTOMER }"
									:get-data="listCompany"
									query-info="companyName"
									query-label="公司名称"
									:query-name="queryCompanyCustomerName"
									@update:queryName="handleUpdateCompanyCustomerName"
									@commitBack="handleCommitBackCompanyCustomer"
								>
									<template #table-columns>
										<el-table-column :label="form.customerCompanyType || '收票方'" align="center" prop="companyName" />
										<el-table-column label="老板姓名" align="center" prop="leader" />
										<el-table-column label="老板电话" align="center" prop="leaderTel" />
										<el-table-column label="区域" align="center" prop="region" />
										<el-table-column label="销售经理" align="center" prop="salesManager" />
									</template>
								</SearchOption>
							</el-col>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="收票方票点" prop="customerTicketPoint">
							<el-input v-model="form.customerTicketPoint" placeholder="请输入收票方票点" />
						</el-form-item>
						<el-form-item label="收票方票点金额" prop="customerPointAmount">
							<el-input disabled v-model="form.customerPointAmount" placeholder="自动计算收票方票点金额" />
						</el-form-item>
						<el-form-item label="票据单位名称" prop="invoiceCompanyName">
							<el-input v-model="form.invoiceCompanyName" placeholder="请输入票据单位名称" />
						</el-form-item>
						<el-form-item label="开票日期" prop="extraInfo.actualInvoiceTime">
							<el-date-picker v-model="form.extraInfo.actualInvoiceTime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>
						<el-form-item label="银行回执附件">
							<UploadFilesButton ref="paymentReceiptsUpload" flag="paymentReceipts" :extra-info="{ moduleType: 'invoiceOther', formId: form.id }" :initial-attachments="(form.params && form.params.paymentReceipts) || []" @files-updated="handleAttachmentFilesUpdated" />
						</el-form-item>
						<el-form-item label="发票单">
							<UploadFilesButton ref="invoiceAttachmentsUpload" flag="invoiceAttachments" :extra-info="{ moduleType: 'invoiceOther', formId: form.id }" :initial-attachments="(form.params && form.params.invoiceAttachments) || []" @files-updated="handleAttachmentFilesUpdated" />
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" />
						</el-form-item>
					</el-col>
				</el-form>
			</el-row>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

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
import { listInvoiceOther, delInvoiceOther, addInvoiceOther, updateInvoiceOtherExtra } from '@/api/system/invoiceOther';
import { listTableEditMessage } from '@/api/system/tableEditMessage';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { TableName, PUBLIC_DICT_TYPE } from '@/api/tool/enums';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { addDateRange, parseTime } from '@/utils/ruoyi';
import CheckFiles from '../../../components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import { fix_2 } from '../../../api/tool/format';
import reLength from '../../dashboard/mixins/reLength';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import { getInvoiceOther, updateInvoiceOther } from '../../../api/system/invoiceOther';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import INVOICE_ORTHER from '@/components/NeedToShow/INVOICE_ORTHER.vue';

export default {
	name: 'InvoiceOther',
	components: { CheckFiles, UploadFilesButton, SearchOption },
	mixins: [mixin_printHTML, reLength, mixin_checkfile, common_dialog],
	data() {
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
			// 枚举常量，供模板使用
			PUBLIC_DICT_TYPE,
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			invoiceOtherList: [],
			title: '',
			open: false,
			dateRange: [],
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				invoiceDate: null,
				invoiceAmount: null,
				supplierTicketPoint: null,
				supplierPointAmount: null,
				Supplier: null,
				SupplierID: null,
				customer: null,
				CustomerID: null,
				invoiceCompanyName: null,
				customerTicketPoint: null,
				type: 'customerTicketPointIsNotZero',
				customerPointAmount: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				params: {
					mixCompanyName: null,
					isInvoiced: null
				}
			},
			form: {},
			queryCompanyName: '',
			queryCompanyCustomerName: '',
			rules: {
				invoiceAmount: [
					{
						required: true,
						message: '请输入开票金额',
						trigger: 'blur'
					}
				],
				supplierTicketPoint: [
					{
						required: true,
						message: '请输入开票方票点',
						trigger: 'blur'
					}
				],
				supplierPointAmount: [
					{
						required: true,
						message: '请输入开票方票点金额',
						trigger: 'blur'
					}
				],
				Supplier: [
					{
						required: true,
						message: '请输入开票方公司名称',
						trigger: 'blur'
					}
				],
				customer: [
					{
						required: true,
						message: '请输入收票方公司名称',
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
				customerTicketPoint: [
					{
						required: true,
						message: '请输入收票方票点',
						trigger: 'blur'
					}
				],
				customerPointAmount: [
					{
						required: true,
						message: '请输入收票方票点金额',
						trigger: 'blur'
					}
				],
				supplierCompanyType: [
					{
						required: true,
						message: '请选择开票方公司类型',
						trigger: 'change'
					}
				],
				customerCompanyType: [
					{
						required: true,
						message: '请选择收票方公司类型',
						trigger: 'change'
					}
				],
				invoiceDate: [
					{
						required: true,
						message: '请选择开票日期',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `开票日期`, visible: true },
				{ key: 1, label: `开票金额`, visible: true },
				{ key: 2, label: `开票方票点`, visible: true },
				{ key: 3, label: `开票方票点金额`, visible: true },
				{ key: 4, label: `开票方公司名称`, visible: true },
				{ key: 5, label: `收票方公司名称`, visible: true },
				{ key: 6, label: `票据单位名称`, visible: true },
				{ key: 7, label: `收票方票点`, visible: true },
				{ key: 8, label: `收票方票点金额`, visible: true },
				{ key: 9, label: `是否订单对应`, visible: true },
				{ key: 10, label: `备注`, visible: true },
				{ key: 11, label: `实际开票金额`, visible: true },
				{ key: 12, label: `实际开票时间`, visible: true },
				{ key: 13, label: `当月欠票金额`, visible: true },
				{ key: 14, label: `额外备注`, visible: true }
			],
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
				pageSize: 20,
				tableName: TableName.INVOICE_OTHER,
				tid: null
			}
		};
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('invoiceother-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		form: {
			handler() {
				this.form.supplierPointAmount = fix_2(this.form.supplierTicketPoint * this.form.invoiceAmount);
				this.form.customerPointAmount = fix(this.form.customerTicketPoint * this.form.invoiceAmount);
			},
			deep: true,
			immediate: true
		}
	},
	created() {
		this.reset();
		this.getList();
		if (localStorage.getItem('invoiceother-columns') === 'null' || !localStorage.getItem('invoiceother-columns')) {
			localStorage.setItem('invoiceother-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('invoiceother-columns'));
		}
	},
	methods: {
		parseTime,
		updateInvoiceOther,
		getInvoiceOther,
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
		handleUpdateCompanyName(val) {
			this.queryCompanyName = val;
		},
		handleCommitBackCompany(val) {
			this.form.Supplier = val.companyName;
			this.form.SupplierID = val.id;
		},
		handleCommitBackCompanyCustomer(val) {
			this.form.customer = val.companyName;
			this.form.CustomerID = val.id;
		},
		handleUpdateCompanyCustomerName(val) {
			this.queryCompanyCustomerName = val;
		},
		// 统一附件更新处理
		handleAttachmentFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 确保 form.params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}
				// 直接使用上传组件返回的统一附件ID数组
				this.form.params.attachmentIds = uploadParams.params.attachmentIds;
			}
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
		getList() {
			this.loading = true;
			listInvoiceOther(addDateRange(this.queryParams, this.dateRange)).then(response => {
				this.invoiceOtherList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		cancel() {
			this.open = false;
			// 清空sessionStorage中的修改原因
			sessionStorage.removeItem('editReason_invoiceOther_main');
			// 清理 UploadFilesButton 组件状态
			if (this.$refs.paymentReceiptsUpload) {
				this.$refs.paymentReceiptsUpload.clearUploadedFiles();
			}
			if (this.$refs.invoiceAttachmentsUpload) {
				this.$refs.invoiceAttachmentsUpload.clearUploadedFiles();
			}
			this.reset();
		},
		reset() {
			this.form = {
				id: null,
				invoiceDate: null,
				invoiceAmount: null,
				supplierTicketPoint: null,
				supplierPointAmount: null,
				Supplier: null,
				SupplierID: null,
				customer: null,
				CustomerID: null,
				// 开票方公司类型：只是一个名称标识，实际值可以为客户或供应商
				supplierCompanyType: PUBLIC_DICT_TYPE.SUPPLIER,
				// 收票方公司类型：只是一个名称标识，实际值可以为客户或供应商
				customerCompanyType: PUBLIC_DICT_TYPE.CUSTOMER,
				invoiceCompanyName: null,
				customerTicketPoint: null,
				customerPointAmount: null,
				type: 'customerTicketPointIsNotZero',
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				extraInfo: {
					actualInvoiceAmount: null,
					actualInvoiceTime: null,
					currentMonthOweInvoiceAmount: null,
					comment: null
				},
				params: {
					attachmentIds: []
				}
			};
			this.resetForm('form');
		},
		handleQuery() {
			// 按照 QuerySearchBar.vue 的做法处理时间范围
			this.formatDateRange();
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.dateRange = [];
			this.queryParams.invoiceCompanyName = null;
			this.queryParams.params.mixCompanyName = null;
			this.queryParams.params.isInvoiced = null;
			this.handleQuery();
		},
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		handleAdd() {
			this.reset();
			// 设置日期默认为今天
			const now = new Date();
			const year = now.getFullYear();
			const month = String(now.getMonth() + 1).padStart(2, '0');
			const day = String(now.getDate()).padStart(2, '0');
			const hours = String(now.getHours()).padStart(2, '0');
			const minutes = String(now.getMinutes()).padStart(2, '0');
			const seconds = String(now.getSeconds()).padStart(2, '0');
			this.form.invoiceDate = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
			this.open = true;
			this.title = '添加商家直接给客户开发票';
		},
		handleUpdate(row) {
			// 先获取发票详情，判断是否需要填写修改原因
			const id = row.id || this.ids;
			getInvoiceOther(id)
				.then(response => {
					const invoiceOtherData = response.data;

					// 判断是否需要填写修改原因
					if (invoiceOtherData && invoiceOtherData.shouldTrackEditReason === true) {
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
								sessionStorage.setItem('editReason_invoiceOther_main', value);

								// 继续编辑操作
								this.performInvoiceOtherEdit(invoiceOtherData);
							})
							.catch(() => {
								this.$message({
									type: 'info',
									message: '已取消修改'
								});
							});
					} else {
						// 不需要填写修改原因，直接进行编辑操作
						this.performInvoiceOtherEdit(invoiceOtherData);
					}
				})
				.catch(error => {
					console.error('获取发票详情失败:', error);
					this.$message.error('获取发票详情失败');
				});
		},

		// 执行发票编辑操作的逻辑
		performInvoiceOtherEdit(invoiceOtherData) {
			this.reset();
			this.form = {
				...invoiceOtherData,
				params: {
					...invoiceOtherData.params,
					attachmentIds: invoiceOtherData.attachmentList ? invoiceOtherData.attachmentList.map(item => item.id) : [],
					paymentReceipts: invoiceOtherData.attachmentList ? invoiceOtherData.attachmentList.filter(item => item.flag === 'paymentReceipts') : [],
					invoiceAttachments: invoiceOtherData.attachmentList ? invoiceOtherData.attachmentList.filter(item => item.flag === 'invoiceAttachments') : []
				}
			};
			this.open = true;
			this.title = '修改商家直接给客户开发票';
		},
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 保存当前附件ID用于错误回滚
					const originalAttachmentIds = this.$store.getters.attachmentIds ? [...this.$store.getters.attachmentIds] : [];

					// 去重附件ID
					const uniqueAttachmentIds = [...new Set(originalAttachmentIds)];
					if (uniqueAttachmentIds.length !== originalAttachmentIds.length) {
						// 清空并重新添加去重后的ID
						this.$store.commit('CLEAR_ATTACHMENT_IDS');
						uniqueAttachmentIds.forEach(id => {
							this.$store.commit('ADD_ATTACHMENT_ID', id);
						});
					}

					// 获取附件上传参数
					if (this.$refs.paymentReceiptsUpload) {
						const paymentReceiptsParams = this.$refs.paymentReceiptsUpload.getUploadParams();
						if (paymentReceiptsParams && paymentReceiptsParams.params) {
							this.form.params = { ...this.form.params, ...paymentReceiptsParams.params };
						}
					}
					if (this.$refs.invoiceAttachmentsUpload) {
						const invoiceAttachmentsParams = this.$refs.invoiceAttachmentsUpload.getUploadParams();
						if (invoiceAttachmentsParams && invoiceAttachmentsParams.params) {
							this.form.params = { ...this.form.params, ...invoiceAttachmentsParams.params };
						}
					}

					// 创建提交数据的副本
					const submitData = { ...this.form };

					if (this.form.id != null) {
						// 编辑时，从sessionStorage获取修改原因
						const editReason = sessionStorage.getItem('editReason_invoiceOther_main');
						submitData.editReason = editReason;

						updateInvoiceOther(submitData)
							.then(() => {
								this.$modal.msgSuccess('修改成功');
								this.open = false;
								// 清空sessionStorage中的修改原因
								sessionStorage.removeItem('editReason_invoiceOther_main');
								// 清理 UploadFilesButton 状态
								if (this.$refs.paymentReceiptsUpload) {
									this.$refs.paymentReceiptsUpload.clearUploadedFiles();
								}
								if (this.$refs.invoiceAttachmentsUpload) {
									this.$refs.invoiceAttachmentsUpload.clearUploadedFiles();
								}
								this.getList();
							})
							.catch(error => {
								console.error('修改商家开票失败:', error);
								// 修改失败时不清空sessionStorage，用户可以重试
								// 回滚附件ID到原始状态
								this.$store.commit('CLEAR_ATTACHMENT_IDS');
								originalAttachmentIds.forEach(id => {
									this.$store.commit('ADD_ATTACHMENT_ID', id);
								});
								this.$message.error('修改失败，请重试');
							});
					} else {
						// 新增时，不需要修改原因
						addInvoiceOther(submitData)
							.then(() => {
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
							})
							.catch(error => {
								console.error('新增商家开票失败:', error);
								// 回滚附件ID到原始状态
								this.$store.commit('CLEAR_ATTACHMENT_IDS');
								originalAttachmentIds.forEach(id => {
									this.$store.commit('ADD_ATTACHMENT_ID', id);
								});
								this.$message.error('新增失败，请重试');
							});
					}
				}
			});
		},
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除商家直接给客户开发票编号为"' + ids + '"的数据项？')
				.then(function () {
					return delInvoiceOther(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		handleExport() {
			this.download(
				'system/invoiceOther/export',
				{
					...this.queryParams
				},
				`商家直接给客户开发票_${new Date().getTime()}.xlsx`
			);
		},
		handleCheck(row) {
			if (!row.id) {
				this.$message.error('行数据有误!');
				return;
			}
			getInvoiceOther(row.id).then(res => {
				if (!res.data) {
					this.$message.error('暂无该条数据');
					return;
				}
				this.openDialog(
					INVOICE_ORTHER,
					'发票信息',
					'900px',
					{
						needToShowInfo: res.data
					},
					false
				);
			});
		},
		handleAddExtraInfo(row) {
			this.currentRow = row;
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
		saveExtraInfo() {
			this.$refs['extraInfoForm'].validate(valid => {
				if (valid) {
					if (this.currentRow) {
						updateInvoiceOtherExtra(this.currentRow.id, this.currentExtraInfo)
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
