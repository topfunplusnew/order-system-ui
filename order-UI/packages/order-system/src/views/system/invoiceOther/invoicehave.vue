<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="开票日期" prop="invoiceDate">
				<el-date-picker
					v-model="dateRange"
					type="daterange"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
					range-separator="至"
					value-format="yyyy-MM-dd"
					unlink-panels
					style="width: 240px"
				/>
			</el-form-item>
			<el-form-item label="开票单位" prop="invoiceCompanyName">
				<el-input v-model="queryParams.invoiceCompanyName" placeholder="请输入开票单位" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方名称" prop="mixCompanyName">
				<el-input v-model="queryParams.params.mixCompanyName" placeholder="可搜索供应商或客户名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="开票状态" prop="isInvoiced">
				<el-select v-model="queryParams.params.isInvoiced" placeholder="请选择开票状态" clearable style="width: 150px">
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
			<!--      <el-col :span="1.5">
			              <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			            </el-col>-->
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:invoiceother:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
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
			<el-table-column type="index" label="ID" width="60" align="center" />
			<el-table-column v-if="columns[4].visible" label="供应商公司名称" align="center" prop="Supplier" show-overflow-tooltip />
			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="invoiceDate" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="开票金额" align="center" prop="invoiceAmount" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="供应商票点" align="center" prop="supplierTicketPoint" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="供应商票点金额" align="center" prop="supplierPointAmount" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.supplierPointAmount | changeNumber(changeLength) }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[5].visible" label="客户名称" align="center" prop="customer" show-overflow-tooltip />
			<el-table-column v-if="columns[12].visible" label="开票单位" align="center" prop="invoiceCompanyName" show-overflow-tooltip />

			<!-- 新增 extraInfo 属性展示 -->
			<el-table-column v-if="columns[8].visible" label="实际开票金额" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.actualInvoiceAmount }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[9].visible" label="开票时间" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.actualInvoiceTime }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="当月欠票金额" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.currentMonthOweInvoiceAmount }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="额外备注" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.extraInfo && scope.row.extraInfo.comment }}
				</template>
			</el-table-column>

			<el-table-column v-if="columns[6].visible" label="订单信息" align="center" prop="isOrderTax" width="180" show-overflow-tooltip>
				<template slot-scope="scope">
					<el-row>
						<el-button size="mini" type="text" @click="checkOrderInfo(scope.row)" :disabled="!scope.row.ordersNo">查看订单信息</el-button>
					</el-row>
				</template>
			</el-table-column>
			<el-table-column label="银行回执单" align="center" prop="paymentReceipts">
				<template #default="scope">
					<div v-if="Array.isArray(scope.row.attachmentList)">
						<CheckFiles
							:attachmentList="scope.row.attachmentList"
							flag="paymentReceipts"
							@needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOther, updateInvoiceOther)"
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
							flag="invoiceAttachments"
							@needToUpdate="value => handleUpdateFilePath(value, scope.row, getInvoiceOther, updateInvoiceOther)"
						/>
					</div>
					<div v-else>
						<el-tag type="danger">加载错误</el-tag>
					</div>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[7].visible" label="备注" align="center" prop="comments" />
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
					<!--        订单编号应该是选择某个订单 然后自动填充-->
					<el-col :span="12">
						<el-form-item label="订单ID" prop="ordersNo">
							<el-col :span="20">
								<!--              <el-input v-model="form.ordersNo" placeholder="请选择关联订单"/>-->
								<el-input v-model="form.orderIDS" disabled placeholder="请选择关联订单" />
							</el-col>
							<el-col :span="4">
								<SearchOption
									:limit-info="{}"
									:get-data="listGoodsOrder"
									query-info="customer"
									query-label="客户名称"
									:query-name="queryGoodsOrder"
									@update:queryName="handleUpdateGoodsOrder"
									@commitBack="handleCommitBackGoodsOrder"
								>
									<template #table-columns>
										<el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left" />
										<el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left" />
										<el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left" />
										<el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left" />
										<el-table-column label="订单编号" align="center" prop="ordersNo" width="200px" />
										<el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" />
										<el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel" width="100px" />
										<el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName" width="100px" />
										<el-table-column show-overflow-tooltip label="柜号" align="center" prop="seaCarNo">
											<template #default="scope">
												{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
											</template>
										</el-table-column>
										<el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel" width="100px">
											<template #default="scope">
												{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
											</template>
										</el-table-column>
										<el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="100px">
											<template #default="scope">
												{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverTel }}
											</template>
										</el-table-column>
										<el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager" />
										<el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" />
										<el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120"></el-table-column>
										<el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState" width="120px"></el-table-column>
										<!--									<el-table-column show-overflow-tooltip label="打款状态" align="center" prop="paymentState">-->
										<!--										<template slot-scope="scope">-->
										<!--											<el-tag disable-transitions>-->
										<!--												{{ scope.row.paymentState }}-->
										<!--											</el-tag>-->
										<!--										</template>-->
										<!--									</el-table-column>-->

										<el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" />
									</template>
								</SearchOption>
							</el-col>
						</el-form-item>
						<el-form-item label="日期" prop="invoiceDate">
							<el-date-picker v-model="form.invoiceDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>

						<el-form-item label="供应商公司名称" prop="Supplier">
							<el-col :span="20">
								<el-input disabled v-model="form.Supplier" placeholder="请选择" />
							</el-col>
							<el-col :span="4">
								<SearchOption
									:limit-info="{ companyType: '供应商' }"
									:get-data="listCompany"
									query-info="companyName"
									query-label="公司名称"
									:query-name="queryCompanyName"
									@update:queryName="handleUpdateCompanyName"
									@commitBack="handleCommitBackCompany"
								>
									<template #table-columns>
										<el-table-column label="供应商" align="center" prop="companyName" />
										<el-table-column label="老板姓名" align="center" prop="leader" />
										<el-table-column label="老板电话" align="center" prop="leaderTel" />
										<el-table-column label="区域" align="center" prop="region" />
										<el-table-column label="公司名称" align="center" prop="companyName" />
										<el-table-column label="销售经理" align="center" prop="salesManager" />
									</template>
								</SearchOption>
							</el-col>
						</el-form-item>
						<el-form-item label="开票金额" prop="invoiceAmount">
							<el-input v-model="form.invoiceAmount" placeholder="请输入开票金额" />
						</el-form-item>
						<el-form-item label="供应商票点" prop="supplierTicketPoint">
							<el-input v-model="form.supplierTicketPoint" placeholder="请输入供应商票点" />
						</el-form-item>
						<el-form-item label="供应商票点金额" prop="supplierPointAmount">
							<el-input disabled v-model="form.supplierPointAmount" placeholder="请输入供应商票点金额" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="客户名称" prop="customer">
							<el-col :span="20">
								<el-input disabled v-model="form.customer" placeholder="请选择" />
							</el-col>
							<el-col :span="4">
								<SearchOption
									:limit-info="{ companyType: '客户' }"
									:get-data="listCompany"
									query-info="companyName"
									query-label="公司名称"
									:query-name="queryCompanyCustomerName"
									@update:queryName="handleUpdateCompanyCustomerName"
									@commitBack="handleCommitBackCompanyCustomer"
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
						</el-form-item>
						<el-form-item label="票据单位名称" prop="invoiceCompanyName">
							<el-input v-model="form.invoiceCompanyName" placeholder="请输入票据单位名称" />
						</el-form-item>
						<el-form-item label="开票日期" prop="invoiceDate">
							<el-date-picker v-model="form.extraInfo.actualInvoiceTime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>
						<!-- 银行回执单附件-->
						<el-form-item label="银行回执附件">
							<UploadFilesButton
								ref="paymentReceiptsUpload"
								flag="paymentReceipts"
								:extra-info="{ moduleType: 'invoiceOtherHave', formId: form.id }"
								:initial-attachments="(form.attachmentList || []).filter(item => item.flag === 'paymentReceipts')"
								@files-updated="handlePaymentReceiptsUpdated"
							/>
						</el-form-item>
						<el-form-item label="发票单">
							<UploadFilesButton
								ref="invoiceAttachmentsUpload"
								flag="invoiceAttachments"
								:extra-info="{ moduleType: 'invoiceOtherHave', formId: form.id }"
								:initial-attachments="(form.attachmentList || []).filter(item => item.flag === 'invoiceAttachments')"
								@files-updated="handleInvoiceAttachmentsUpdated"
							/>
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
import { listInvoiceOther, delInvoiceOther, addInvoiceOther, getInvoiceOther, updateInvoiceOther, updateInvoiceOtherExtra } from '@/api/system/invoiceOther';
import { listTableEditMessage } from '@/api/system/tableEditMessage';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { addReason } from '@/api/system/user';
import { TableName } from '@/api/tool/enums';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { listGoodsOrder } from '@/api/system/goodsOrder';
import { addDateRange } from '@/utils/ruoyi';
import OrderInfos from '../../dashboard/components/goodsOrder/OrderInfos.vue';
import { fix } from '../../../api/tool/format';
import reLength from '../../dashboard/mixins/reLength';
import CheckFiles from '../../../components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import INVOICE_ORTHER from '@/components/NeedToShow/INVOICE_ORTHER.vue';

export default {
	name: 'InvoiceOtherHave',
	components: { DialogWrapper, CheckFiles, UploadFilesButton, OrderInfos, SearchOption },
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
			// 商家直接给客户开发票表格数据
			invoiceOtherList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			dateRange: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				ordersNo: null,
				invoiceDate: null,
				invoiceAmount: null,
				supplierTicketPoint: null,
				supplierPointAmount: null,
				Supplier: null,
				SupplierID: null,
				customer: null,
				CustomerID: null,
				invoiceCompanyName: null,
				// 客户不含税
				customerTicketPoint: 0,
				customerPointAmount: 0,
				// 区分客户含税开票 和 成本和收入
				type: 'customerTicketPointIsZero',
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
			// 表单参数
			form: {},
			queryCompanyName: '',
			queryCompanyCustomerName: '',
			queryGoodsOrder: '',
			// 表单校验
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
						message: '请输入供应商票点',
						trigger: 'blur'
					}
				],
				supplierPointAmount: [
					{
						required: true,
						message: '请输入供应商票点金额',
						trigger: 'blur'
					}
				],
				Supplier: [
					{
						required: true,
						message: '请输入供应商公司名称',
						trigger: 'blur'
					}
				],
				customer: [
					{
						required: true,
						message: '请输入客户名称',
						trigger: 'blur'
					}
				],
				invoiceCompanyName: [
					{
						required: true,
						message: '请输入票据单位名称',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `开票日期`, visible: true },
				{ key: 1, label: `开票金额`, visible: true },
				{ key: 2, label: `供应商票点`, visible: true },
				{ key: 3, label: `供应商票点金额`, visible: true },
				{ key: 4, label: `供应商公司名称`, visible: true },
				{ key: 5, label: `客户名称`, visible: true },
				{ key: 6, label: `订单信息`, visible: true },
				{ key: 7, label: `备注`, visible: true },
				// 新增的 extraInfo 相关列
				{ key: 8, label: `实际开票金额`, visible: true },
				{ key: 9, label: `实际开票时间`, visible: true },
				{ key: 10, label: `当月欠票金额`, visible: true },
				{ key: 11, label: `额外备注`, visible: true },
				{ key: 12, label: `开票单位`, visible: true }
			],
			checkOrderInfoVisible: false,
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
				// 备注字段不需要验证，因为是可选的
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
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('invoiceother-have-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		form: {
			handler() {
				this.form.supplierPointAmount = fix(this.form.supplierTicketPoint * this.form.invoiceAmount);
				this.form.customerPointAmount = fix(this.form.customerTicketPoint * this.form.invoiceAmount);
			},
			deep: true,
			immediate: true
		}
	},
	created() {
		this.reset();
		this.getList();
		if (localStorage.getItem('invoiceother-have-columns') === 'null' || !localStorage.getItem('invoiceother-have-columns')) {
			// 设置localStorage
			localStorage.setItem('invoiceother-have-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('invoiceother-have-columns'));
		}
	},
	methods: {
		listGoodsOrder,
		listCompany,
		getInvoiceOther,
		updateInvoiceOther,
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
		// 银行回执附件上传处理
		// 统一的附件更新处理函数
		handlePaymentReceiptsUpdated(uploadParams) {
			// UploadFilesButton已经自动管理了Vuex全局池，这里只需要简单的确认
			console.log('付款收据附件上传完成，当前全局池ID:', this.$store.getters['attachments/getAttachmentIds']);
		},
		// 发票单附件上传处理
		handleInvoiceAttachmentsUpdated(uploadParams) {
			// UploadFilesButton已经自动管理了Vuex全局池，这里只需要简单的确认
			console.log('发票附件上传完成，当前全局池ID:', this.$store.getters['attachments/getAttachmentIds']);
		},
		// 自动填充的方法
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
		handleUpdateGoodsOrder(val) {
			this.queryGoodsOrder = val;
		},
		handleCommitBackGoodsOrder(val) {
			this.form.orderIDS = val.id;
			this.form.ordersNo = val.ordersNo;
		},
		// 表格中查看订单信息
		checkOrderInfo(row) {
			// 发请求 查看订单信息
			listGoodsOrder({ ordersNo: row.ordersNo }).then(res => {
				this.orderInfo = res.rows[0];
				this.checkOrderInfoVisible = true;
			});
		},
		/** 查询商家直接给客户开发票列表 */
		getList() {
			this.loading = true;
			listInvoiceOther(addDateRange(this.queryParams, this.dateRange)).then(response => {
				this.invoiceOtherList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
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
				ordersNo: null,
				orderIDS: null,
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
				customerPointAmount: null,
				type: 'customerTicketPointIsZero',
				comments: null,
				editReason: null, // 添加修改原因字段
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
				},
				params: {
					attachmentIds: []
				}
			};
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.dateRange = [];
			this.queryParams.invoiceCompanyName = null;
			this.queryParams.params.mixCompanyName = null;
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
		/** 新增按钮操作 */
		handleAdd() {
			// 清空全局附件池，避免残留其他表单的附件ID
			this.$store.dispatch('attachments/clearAttachmentIds');

			this.reset();
			this.open = true;
			this.title = '添加商家直接给客户开发票';
		},

		/** 修改按钮操作 */
		handleUpdate(row) {
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
					sessionStorage.setItem('editReason_invoiceOther_have', value);

					// 清空全局附件池，避免残留其他表单的附件ID
					this.$store.dispatch('attachments/clearAttachmentIds');

					this.reset();
					const id = row.id || this.ids;
					getInvoiceOther(id).then(response => {
						this.form = response.data;
						// 确保 params 对象存在
						if (!this.form.params) {
							this.form.params = {};
						}
						// 确保 attachmentIds 是数组
						if (!Array.isArray(this.form.params.attachmentIds)) {
							this.form.params.attachmentIds = [];
						}
						// 处理附件列表 - 统一放入params.attachmentIds
						if (this.form.attachmentList && Array.isArray(this.form.attachmentList)) {
							this.form.params.attachmentIds = this.form.attachmentList.map(item => item.id);
						}
						this.open = true;
						this.title = '修改商家直接给客户开发票';
					});
				})
				.catch(() => {
					this.$message({
						type: 'info',
						message: '已取消修改'
					});
				});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 直接从Vuex全局池获取所有附件ID
					const allAttachmentIds = this.$store.getters['attachments/getAttachmentIds'];

					if (!this.form.params) {
						this.form.params = {};
					}
					this.form.params.attachmentIds = [...allAttachmentIds];

					// 创建提交数据的副本
					const submitData = { ...this.form };

					if (this.form.id != null) {
						// 修改时，从sessionStorage获取修改原因
						const editReason = sessionStorage.getItem('editReason_invoiceOther_have');
						submitData.editReason = editReason;
					} else {
						// 新增时，移除修改原因字段
						delete submitData.editReason;
						submitData.customerTicketPoint = 0;
					}

					const submitPromise = this.form.id != null ? updateInvoiceOther(submitData) : addInvoiceOther(submitData);

					submitPromise
						.then(response => {
							this.$modal.msgSuccess(this.form.id != null ? '修改成功' : '新增成功');
							this.open = false;
							this.getList();
							// 清除sessionStorage中的修改原因
							if (this.form.id != null) {
								sessionStorage.removeItem('editReason_invoiceOther_have');
							}
							// 提交成功后清理上传组件状态
							if (this.$refs.paymentReceiptsUpload) {
								this.$refs.paymentReceiptsUpload.clearUploadedFiles();
							}
							if (this.$refs.invoiceAttachmentsUpload) {
								this.$refs.invoiceAttachmentsUpload.clearUploadedFiles();
							}
						})
						.catch(error => {
							// 提交失败时，恢复原始的附件 ID 列表
							if (this.form.params) {
								this.form.params.attachmentIds = originalAttachmentIds;
							}

							// 从全局 Vuex 池中移除本次添加的文件 ID
							const currentIds = this.form.params ? this.form.params.attachmentIds : [];
							const addedIds = currentIds.filter(id => !originalAttachmentIds.includes(id));
							addedIds.forEach(id => {
								this.$store.dispatch('attachments/removeAttachmentId', id);
							});

							console.error('提交失败:', error);
							this.$modal.msgError('提交失败: ' + (error.message || error.msg || '未知错误'));
						});
				}
			});
		},
		/** 删除按钮操作 */
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
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/invoiceOther/export',
				{
					...this.queryParams
				},
				`invoiceOther_${new Date().getTime()}.xlsx`
			);
		},

		/** 查看按钮操作 */
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
					'开票信息',
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
