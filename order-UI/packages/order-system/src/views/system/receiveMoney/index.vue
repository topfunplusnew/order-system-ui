<template>
	<div class="app-container" :class="{ 'mask-overlay': showMask }">
		<!-- 遮罩层 -->
		<div v-if="showMask" class="container-mask"></div>
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="120px">
			<el-form-item label="收款时间">
				<el-date-picker v-model="dateRange" class="date-range-280" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>
			<el-form-item label="支付类型" prop="receiveType">
				<el-cascader v-model="queryParams.receiveType" :options="paymentTypeTree" :props="props" class="input-medium" clearable />
			</el-form-item>
			<el-form-item label="我方户名" prop="selfAcountsName">
				<el-input v-model="queryParams.selfAcountsName" class="input-medium" placeholder="请输入我方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-input v-model="queryParams.otherAcountsName" class="input-medium" placeholder="请输入对方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方公司名称" prop="companyName">
				<el-input v-model="queryParams.companyName" class="input-medium" placeholder="请输入对方公司名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="票据号码" prop="bankacceptanceBillNo">
				<el-input v-model="queryParams.params.bankacceptanceBillNo" class="input-medium" placeholder="请输入票据号码" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #left>
					<el-row :gutter="10">
						<el-col :span="1.5">
							<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
						</el-col>
						<el-col :span="1.5">
							<el-button v-hasPermi="['system:receivemoney:import']" size="mini" @click="handleDownloadTemplate">下载导入模板</el-button>
						</el-col>
						<el-col :span="1.5">
							<el-button v-hasPermi="['system:receivemoney:import']" size="mini" @click="handleImportData">导入模板</el-button>
						</el-col>
						<el-col :span="1.5" style="margin-left: 15px">
							<el-button v-hasPermi="['system:receivemoney:add']" type="danger" size="mini" @click="handleAdd">新增收款信息</el-button>
						</el-col>
					</el-row>
				</template>
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:receivemoney:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<u-table
			id="printBox"
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="receiveMoneyList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<CustomTableColumn label="ID" align="center" prop="id" width="60" show-overflow-tooltip />
			<CustomTableColumn v-if="columns[0].visible" label="日期" align="center" prop="fundsDate" width="140" show-overflow-tooltip />
			<CustomTableColumn v-if="columns[1].visible" label="支付类型" align="center" prop="receiveType" width="180" show-overflow-tooltip />
			<CustomTableColumn v-if="columns[9].visible" label="对方公司名称" align="center" prop="companyName" width="165" show-overflow-tooltip />
			<CustomTableColumn v-if="columns[10].visible" label="对方公司类型" align="center" prop="companyType" width="140"></CustomTableColumn>
			<CustomTableColumn v-if="columns[2].visible" label="金额" align="center" prop="moneyAmount" width="110" show-overflow-tooltip />
			<CustomTableColumn v-if="columns[3].visible" label="我方户名" align="center" prop="selfAcountsName" width="165" show-overflow-tooltip />
			<CustomTableColumn v-if="columns[4].visible" label="我方账号" align="center" prop="selfBankNo" width="180" show-overflow-tooltip />
			<CustomTableColumn v-if="columns[5].visible" label="我方开户行" align="center" prop="selfBankName" width="165" show-overflow-tooltip />
			<CustomTableColumn v-if="columns[6].visible" label="对方户名" align="center" prop="otherAcountsName" width="165" show-overflow-tooltip />
			<CustomTableColumn v-if="columns[7].visible" label="对方账号" align="center" prop="otherBankNo" width="190" show-overflow-tooltip />
			<CustomTableColumn v-if="columns[8].visible" label="对方开户行" align="center" prop="otherBankName" width="180" show-overflow-tooltip />
			<CustomTableColumn label="备注" align="center" prop="comments" width="165" />
			<CustomTableColumn label="银行卡流水编号" align="center" prop="transactionHistory" width="165" />
			<CustomTableColumn label="录入人员" align="center" prop="userName" width="120" />
			<CustomTableColumn label="银行卡流水附件" align="center" prop="attachmentList" width="165" fixed="right">
				<template slot-scope="scope">
					<!-- 这是封装的一个通用组件 可以直接传入url 组件效果为一个按钮 点击后可以查看附件-->
					<CheckFiles :attachmentList="scope.row.attachmentList" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getReceiveMoney(), updateReceiveMoney())" flag="transactionHistoryAttachment" />
				</template>
			</CustomTableColumn>
			<CustomTableColumn label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="150">
				<template slot-scope="scope">
					<el-dropdown @command="command => handleCommand(command, scope.row)">
						<el-button type="primary" size="mini">
							操作
							<i class="el-icon-arrow-down el-icon--right"></i>
						</el-button>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item v-hasPermi="['system:receivemoney:edit']" command="edit">修改</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:receivemoney:remove']" command="delete" divided>删除</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:tableeditmessage:list']" command="viewEditReason">查看修改原因</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
				</template>
			</CustomTableColumn>
		</u-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 导入结果弹窗 -->
		<el-dialog title="导入结果" :visible.sync="importResultVisible" width="500px" :close-on-click-modal="false" append-to-body>
			<div style="padding: 20px 0">
				<div style="margin-bottom: 15px; font-weight: 600; font-size: 16px">导入结果：完成</div>
				<div style="color: #606266; line-height: 1.6; white-space: pre-line">{{ importResultMessage }}</div>
			</div>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="closeImportResult">确定</el-button>
			</div>
		</el-dialog>

		<!-- 查看修改原因弹窗 -->
		<el-dialog title="查看修改原因" :visible.sync="editReasonDialogVisible" width="800px" append-to-body>
			<u-table :data="editReasonList" style="width: 100%">
				<CustomTableColumn prop="addtime" label="修改时间" />
				<CustomTableColumn prop="reason" label="修改原因" />
				<CustomTableColumn prop="userName" label="修改人" />
			</u-table>
			<pagination v-show="editReasonTotal > 0" :total="editReasonTotal" :page.sync="editReasonQueryParams.pageNum" :limit.sync="editReasonQueryParams.pageSize" @pagination="getEditReasonList" />
		</el-dialog>

		<!-- 添加收款信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1000px" append-to-body>
			<div>
				<el-form ref="form" :model="form" :rules="rules" label-width="170px">
					<!-- 收款编码（只读，仅编辑时展示） -->
					<el-form-item v-if="form && form.id != null" label="收款编码">
						<el-input v-model="form.code" disabled style="width: 100%" />
					</el-form-item>
					<!--        第一列-->
					<el-col :span="isPaymentFee ? 24 : 12">
						<el-form-item label="日期" prop="fundsDate">
							<el-date-picker v-model="form.fundsDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择日期" style="width: 100%" />
						</el-form-item>
						<el-form-item label="收款类型" prop="receiveType">
							<el-cascader v-model="form.receiveType" :options="paymentTypeTree" :props="props" style="width: 100%" />
						</el-form-item>
						<el-form-item label="金额" prop="moneyAmount">
							<el-input v-model="form.moneyAmount" placeholder="请输入金额" style="width: 100%" />
						</el-form-item>
						<!--  对方银行卡的消费类型 (承兑户或者现金户)-->
						<el-form-item label="我方银行账户类型">
							<BankType
								ref="selfSelectedBankType"
								:bill-type="BankAcceptanceType.PAY_TYPE.RECEIVE"
								:select-type="form.selfBankCardType"
								:external-bankacceptance-info="form.params.bankacceptance"
								@updateSelectedType="changeSelfBankType"
								@updateBankAcceptance="handleBankAcceptanceUpdate"
								style="width: 100%"
							/>
						</el-form-item>
						<el-form-item label="我方户名" prop="selfAcountsName">
							<div style="width: 100%; display: flex">
								<el-input disabled v-model="form.selfAcountsName" placeholder="请选择" style="flex: 1; margin-right: 8px" />
								<SearchOption
									:get-data="listBankAccount"
									title="银行卡信息"
									icon="el-icon-search"
									:limit-info="{
										acountsType: '己方公司'
									}"
									:query-name="bankQuery"
									query-info="acountsName"
									query-label="户名查询"
									width="1000px"
									@commitBack="handleCallBack"
									@update:queryName="handleCommitBackBank"
								>
									<template #table-columns>
										<CustomTableColumn label="账户类型" align="center" prop="acountsType" width="100" />
										<CustomTableColumn label="开户名称(户名)" align="center" prop="acountsName" width="300" />
										<CustomTableColumn label="账号(银行账号)" align="center" prop="bankNo" width="300" />
										<CustomTableColumn label="开户行" align="center" prop="bankName" width="300" />
										<CustomTableColumn label="己方公司" align="center" prop="displayName" width="300" />
									</template>
								</SearchOption>
							</div>
						</el-form-item>
						<el-form-item label="我方账号" prop="selfBankNo">
							<el-input disabled v-model="form.selfBankNo" placeholder="请选择" style="width: 100%" />
						</el-form-item>
						<el-form-item label="我方开户行" prop="selfBankName">
							<el-input disabled v-model="form.selfBankName" placeholder="请选择" style="width: 100%" />
						</el-form-item>
						<el-form-item label="对方类型(请确认)">
							<el-tooltip content="请注意选择正确的对方公司类型!" placement="top" effect="dark">
								<el-select v-model="form.companyType" placeholder="请选择" style="width: 100%">
									<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
								</el-select>
							</el-tooltip>
						</el-form-item>
						<el-form-item v-if="form.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE && form.companyType !== PUBLIC_DICT_TYPE.EMPLOYEE" :label="form.companyType === PAYMENT_TARGET_TYPE.DRIVER ? PUBLIC_DICT_TYPE.DRIVER : '对方公司名称'" prop="companyName">
							<div style="width: 100%; display: flex">
								<el-input disabled v-model="form.companyName" placeholder="请选择" style="flex: 1; margin-right: 8px" />
								<SearchOption v-if="form.companyType === PAYMENT_TARGET_TYPE.DRIVER" :limit-info="{}" :get-data="listCars" query-info="carNo" query-label="车牌/柜号" :query-name="carName" @update:queryName="handleUpdateCarName" @commitBack="handleCommitBackCar">
									<template #table-columns>
										<CustomTableColumn label="车牌/柜号" align="center" prop="carNo" width="220" />
										<CustomTableColumn label="司机姓名/海运公司" align="center" prop="driver" width="220" />
										<CustomTableColumn label="司机电话" align="center" prop="tel" width="200" />
										<CustomTableColumn label="户名" align="center" prop="acountsName" width="200" />
										<CustomTableColumn label="银行账号" align="center" prop="bankNo" width="200" />
										<CustomTableColumn label="开户行" align="center" prop="bankName" width="200" />
										<CustomTableColumn label="运输类型" align="center" prop="carType" width="200" />
									</template>
								</SearchOption>
								<SearchOption v-else :limit-info="{ companyType: form.companyType }" :get-data="listCompany" query-info="companyName" query-label="公司名称" :query-name="companyName" @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
									<template #table-columns>
										<CustomTableColumn :label="value" align="center" prop="companyName" />
										<CustomTableColumn label="公司类型" align="center" prop="companyType" />
										<CustomTableColumn label="老板姓名" align="center" prop="leader" />
										<CustomTableColumn label="老板电话" align="center" prop="leaderTel" />
										<CustomTableColumn label="区域" align="center" prop="region" />
										<CustomTableColumn label="销售经理" align="center" prop="salesManager" />
									</template>
								</SearchOption>
							</div>
						</el-form-item>
					</el-col>

					<!--        第二列-->
					<el-col :span="isPaymentFee ? 24 : 12" class="receive-second-col">
						<el-form-item label="对方银行账户类型" v-if="form.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE">
							<BankType ref="otherSelectedBankType" :option-baned="true" :baned="true" :select-type="form.otherBankCardType" @updateSelectedType="changeOtherBankType" style="width: 100%" />
						</el-form-item>
						<el-form-item label="对方户名" prop="otherAcountsName" v-if="form.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE">
							<el-input disabled v-model="form.otherAcountsName" placeholder="请选择" style="width: 100%" />
						</el-form-item>
						<el-form-item label="对方账号" prop="otherBankNo" v-if="form.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE">
							<div style="width: 100%; display: flex">
								<el-input disabled v-model="form.otherBankNo" placeholder="请选择" style="flex: 1; margin-right: 8px" />
								<SearchOption
									:get-data="listBankAccount"
									title="银行卡信息"
									icon="el-icon-search"
									query-label="户名查找"
									query-info="acountsName"
									:query-name="queryCustomerBank"
									:limit-info="{ acountsType: form.companyType }"
									width="1100px"
									@update:queryName="handleUpdateQueryNameCustomer"
									@commitBack="handleCallBackCompany"
									:extra-params="{
										companyId: form.companyId,
										companyType: form.companyType
									}"
								>
									<template #table-columns>
										<CustomTableColumn label="账户类型" align="center" prop="acountsType" width="100" />
										<CustomTableColumn label="开户名称(户名)" align="center" prop="acountsName" width="300" />
										<CustomTableColumn label="账号(银行账号)" align="center" prop="bankNo" width="300" />
										<CustomTableColumn label="开户行" align="center" prop="bankName" width="300" />
									</template>
								</SearchOption>
							</div>
						</el-form-item>
						<el-form-item label="对方开户行" prop="otherBankName" v-if="form.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE">
							<el-input disabled v-model="form.otherBankName" placeholder="请选择" style="width: 100%" />
						</el-form-item>
						<el-form-item label="银行卡流水编号" prop="transactionHistory">
							<el-input v-model="form.transactionHistory" placeholder="请输入银行卡流水编号" style="width: 100%" />
						</el-form-item>
						<el-form-item label="银行卡流水编号附件">
							<UploadFilesButton ref="attachmentUploader" flag="transactionHistoryAttachment" :extra-info="{ moduleType: 'receiveMoney', formId: form.id }" :initial-attachments="form.attachmentList || []" @files-updated="handleAttachmentFilesUpdated" style="width: 100%" />
						</el-form-item>
						<el-form-item label="录入人员" prop="userName">
							<el-input v-model="form.userName" placeholder="请输入录入人员" style="width: 100%" />
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" style="width: 100%" />
						</el-form-item>
					</el-col>
				</el-form>
			</div>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { addReceiveMoney, delReceiveMoney, listReceiveMoney, importReceiveMoneyData } from '@/api/system/receiveMoney';
import { listTableEditMessage } from '@/api/system/tableEditMessage';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount, getBankAccount } from '@/api/system/bankAccount';
import { excludeParams } from '@/api/tool/exclude';
import { addReason } from '@/api/system/user';
import { BankAcceptanceType, PayType, PAYMENT_TARGET_TYPE, TableName, PUBLIC_DICT_TYPE } from '@/api/tool/enums';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import CheckFiles from '../../../components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';

import { listCompany } from '../../../api/system/company';
import { mixin_receive_money_fill } from './receiveMoneyFill';
import { listCars } from '../../../api/system/cars';
import { getReceiveMoney, updateReceiveMoney } from '../../../api/system/receiveMoney';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import { mixin_bankType } from '../../dashboard/mixins/common/common_bankType';
import { mixin_receive_money_subject } from '@/views/dashboard/mixins/receivemoney/receive_money_subject';
import { getBankAcceptance } from '@/api/system/bankAcceptance';
import { parseTime } from '@/utils/ruoyi';
import { mixin_payment_subject } from '../../dashboard/mixins/payment/payment_subject';

export default {
	name: 'ReceiveMoney',
	computed: {
		PAYMENT_TARGET_TYPE() {
			return PAYMENT_TARGET_TYPE;
		},
		BankAcceptanceType() {
			return BankAcceptanceType;
		},
		isPaymentFee() {
			return this.form.companyType === PAYMENT_TARGET_TYPE.PAYMENT_FEE;
		},
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		}
	},
	components: { BankType, CheckFiles, UploadFilesButton, SearchOption },
	mixins: [mixin_printHTML, mixin_receive_money_fill, mixin_checkfile, mixin_bankType, mixin_payment_subject],
	data() {
		return {
			// 遮罩层
			loading: true,
			defaultCompanyType: PAYMENT_TARGET_TYPE.CUSTOMER,
			// 对方类型选项（直接使用 form.companyType 绑定）
			options: [
				{ value: PAYMENT_TARGET_TYPE.CUSTOMER, label: PUBLIC_DICT_TYPE.CUSTOMER },
				{ value: PAYMENT_TARGET_TYPE.SUPPLIER, label: PUBLIC_DICT_TYPE.SUPPLIER },
				{ value: PAYMENT_TARGET_TYPE.DRIVER, label: PUBLIC_DICT_TYPE.DRIVER },
				{ value: PAYMENT_TARGET_TYPE.PAYMENT_FEE, label: PAYMENT_TARGET_TYPE.PAYMENT_FEE },
				{ value: PUBLIC_DICT_TYPE.EMPLOYEE, label: PUBLIC_DICT_TYPE.EMPLOYEE }
			],
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
			// 收款信息表格数据
			receiveMoneyList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				receiveNO: null,
				fundsDate: null,
				receiveType: [],
				tableName: null,
				tID: null,
				moneyAmount: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				startTime: null,
				endTime: null,
				params: {
					bankacceptanceBillNo: null
				}
			},
			// 时间范围选择器
			dateRange: [],
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				fundsDate: [{ required: true, message: '日期不能为空', trigger: 'blur' }],
				moneyAmount: [
					{
						required: true,
						message: '金额不能为空',
						trigger: 'blur'
					},
					// 金额校验 小数点只能两位
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				receiveType: [
					{
						required: true,
						message: '请选择收款类型',
						trigger: 'change'
					}
				],
				selfAcountsName: [
					{
						required: true,
						message: '我方户名不能为空',
						trigger: 'change'
					}
				],
				selfBankNo: [
					{
						required: true,
						message: '我方账号不能为空',
						trigger: 'blur'
					}
				],
				selfBankName: [
					{
						required: true,
						message: '我方开户行不能为空',
						trigger: 'blur'
					}
				],
				companyName: [
					{
						required: true,
						message: '对方公司名称不能为空',
						trigger: 'blur'
					}
				],
				otherAcountsName: [
					{
						required: true,
						message: '对方户名不能为空',
						trigger: 'blur'
					}
				],
				otherBankNo: [
					{
						required: true,
						message: '对方账号不能为空',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `支付类型`, visible: true },
				{ key: 2, label: `金额`, visible: true },
				{ key: 3, label: `乙方户名`, visible: true },
				{ key: 4, label: `我方账号`, visible: true },
				{ key: 5, label: `我方开户行`, visible: true },
				{ key: 6, label: `对方户名`, visible: true },
				{ key: 7, label: `对方账号`, visible: true },
				{ key: 8, label: `对方开户行`, visible: true },
				{ key: 9, label: `对方公司名称`, visible: true },
				{ key: 10, label: `对方公司类型`, visible: true },
				{ key: 11, label: `录入人员`, visible: true }
			],
			// 银行卡查询
			bankQuery: '',
			// 查看修改原因相关
			editReasonDialogVisible: false,
			editReasonList: [],
			editReasonTotal: 0,
			editReasonQueryParams: {
				pageNum: 1,
				pageSize: 20,
				tableName: TableName.RECEIVE_MONEY,
				tid: null
			},
			// 遮罩层显示状态
			showMask: false,
			// 导入结果弹窗
			importResultVisible: false,
			importResultMessage: ''
		};
	},
	// 展示与隐藏
	// 在 watch 中添加对公司ID变化的监听
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('receivemoney-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		// 监听对方类型 切换为支付费用时清理右侧字段，员工时只清理公司字段
		'form.companyType'(newVal) {
			if (newVal === PAYMENT_TARGET_TYPE.PAYMENT_FEE) {
				this.form.companyName = null;
				this.form.companyId = null;
				this.form.otherAcountsName = null;
				this.form.otherBankNo = null;
				this.form.otherBankName = null;
			}
		}
	},

	created() {
		this.reset();
		// 查询列表
		this.getList();
		// 获取本地显示隐藏列的存储 以便于下一次用户打开的时候读取喜好
		if (localStorage.getItem('receivemoney-columns') === 'null' || !localStorage.getItem('receivemoney-columns')) {
			// 设置localStorage
			localStorage.setItem('receivemoney-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('receivemoney-columns'));
		}
	},
	methods: {
		// 下拉菜单命令处理
		handleCommand(command, row) {
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
		listCars,
		listCompany,
		listBankAccount,
		getBankAccount,
		updateReceiveMoney() {
			return updateReceiveMoney;
		},
		getReceiveMoney() {
			return getReceiveMoney;
		},
		// 处理承兑信息更新，自动填充我方户名和对方户名
		handleBankAcceptanceUpdate(acceptanceData) {
			// 保存承兑信息
			this.form.params.bankacceptance = acceptanceData;

			// 如果没有承兑信息，直接返回
			if (!acceptanceData) {
				return;
			}

			// 填充我方承兑账户信息（我方户名、账号、开户行）
			if (acceptanceData.billAccountId) {
				getBankAccount(acceptanceData.billAccountId)
					.then(response => {
						if (response.data) {
							const bankInfo = response.data;
							this.form.selfAcountsName = bankInfo.acountsName;
							this.form.selfBankNo = bankInfo.bankNo;
							this.form.selfBankName = bankInfo.bankName;
							this.form.selfBankID = bankInfo.id;
						}
					})
					.catch(error => {
						console.error('获取我方承兑账户信息失败:', error);
					});
			}

			// 填充背书人/被背书人信息（对方户名、账号、开户行）
			if (acceptanceData.endorser) {
				getCompany(acceptanceData.endorser).then(response => {
					if (response.data) {
						const companyInfo = response.data;
						this.form.companyName = companyInfo.companyName;
						this.form.companyId = companyInfo.id;
					}
				});
				// getBankAccount(acceptanceData.endorser)
				// 	.then(response => {
				// 		if (response.data) {
				// 			const bankInfo = response.data;
				// 			this.form.otherAcountsName = bankInfo.acountsName;
				// 			this.form.otherBankNo = bankInfo.bankNo;
				// 			this.form.otherBankName = bankInfo.bankName;
				// 			// 如果对方公司信息存在，也填充
				// 			if (bankInfo.companyId) {
				// 				this.form.companyId = bankInfo.companyId;
				// 			}
				// 		}
				// 	})
				// 	.catch(error => {
				// 		console.error('获取背书人/被背书人账户信息失败:', error);
				// 	});
			}
		},
		/** 查询收款信息列表 */
		getList() {
			this.loading = true;
			// 处理时间段参数
			const params = { ...this.queryParams };
			if (this.dateRange && this.dateRange.length === 2) {
				params.startTime = this.dateRange[0];
				params.endTime = this.dateRange[1];
			} else {
				// 如果时间范围为空，清空时间参数
				params.startTime = null;
				params.endTime = null;
			}
			// 把查询条件中的receiveType转成字符串
			if (params.receiveType && Array.isArray(params.receiveType)) {
				params.receiveType = params.receiveType.join('-');
			}

			listReceiveMoney(params).then(response => {
				this.receiveMoneyList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.showMask = false;
			this.$bus.$emit('changeFlag', false);
			this.reset();
			// 使用 $nextTick 确保 reset() 后 form 的值已更新，再重置 BankType 组件状态
			this.$nextTick(() => {
				// 安全地清除 BankType 组件状态，此时会使用 reset() 中设置的默认值
				if (this.$refs.selfSelectedBankType && this.$refs.selfSelectedBankType.resetComponentState) {
					this.$refs.selfSelectedBankType.resetComponentState();
				}
				if (this.$refs.otherSelectedBankType && this.$refs.otherSelectedBankType.resetComponentState) {
					this.$refs.otherSelectedBankType.resetComponentState();
				}
			});
			// 清除上传组件状态
			if (this.$refs.attachmentUploader) {
				this.$refs.attachmentUploader.clearUploadedFiles();
			}
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				code: null,
				receiveNO: null,
				fundsDate: parseTime(new Date()),
				receiveType: null,
				tableName: null,
				tID: null,
				moneyAmount: null,
				// 我方银行卡的账户类型
				selfBankCardType: `银行活期存款`,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				// 对方银行卡账户的类型
				otherBankCardType: `银行活期存款`,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				// 设置默认公司类型为客户
				companyType: this.defaultCompanyType,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				transactionHistory: null,
				params: {
					attachmentIds: [],
					bankacceptance: null
				}
			};
			// 安全地重置表单，避免引用错误
			if (this.$refs.form) {
				this.resetForm('form');
			}
			// 清除上传组件状态
			if (this.$refs.attachmentUploader) {
				this.$refs.attachmentUploader.clearUploadedFiles();
			}
		},
		// 部分重置 - 保留银行账户类型和收款类型
		partialReset() {
			// 保存原始的receiveType，如果是字符串格式则通过searchSubjectFromMap查找完整路径数组
			let preservedReceiveType = this.form.receiveType;
			if (typeof preservedReceiveType === 'string' && preservedReceiveType) {
				preservedReceiveType = this.searchSubjectFromMap(preservedReceiveType);
			}
			const preservedSelfBankCardType = this.form.selfBankCardType;
			const preservedOtherBankCardType = this.form.otherBankCardType;

			this.form = {
				id: null,
				receiveNO: null,
				fundsDate: parseTime(new Date()),
				receiveType: preservedReceiveType,
				tableName: null,
				tID: null,
				moneyAmount: null,
				// 我方银行卡的账户类型
				selfBankCardType: preservedSelfBankCardType,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				// 对方银行卡账户的类型
				otherBankCardType: preservedOtherBankCardType,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				transactionHistory: null,
				params: {
					attachmentIds: [],
					bankacceptance: null
				}
			};
			// 安全地重置表单，避免引用错误
			if (this.$refs.form) {
				this.resetForm('form');
			}
			// 清除上传组件状态
			if (this.$refs.attachmentUploader) {
				this.$refs.attachmentUploader.clearUploadedFiles();
			}
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
			// 重置级联选择器
			this.queryParams.receiveType = [];
			// 确保 params 对象存在并重置
			if (!this.queryParams.params) {
				this.queryParams.params = {};
			}
			this.queryParams.params.bankacceptanceBillNo = null;
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
			this.title = '添加收款信息';
			this.showMask = true;
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.showMask = true;
			// 先获取收款详情，判断是否需要填写修改原因
			const id = row.id || this.ids;
			getReceiveMoney(id)
				.then(response => {
					if (!response.data) {
						this.$message.error('获取收款信息失败');
						return;
					}

					const receiveMoneyData = response.data;

					// 判断是否需要填写修改原因
					if (receiveMoneyData && receiveMoneyData.shouldTrackEditReason === true) {
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
								sessionStorage.setItem('editReason_receiveMoney', value);

								// 继续编辑操作
								this.performReceiveMoneyEdit(receiveMoneyData);
							})
							.catch(() => {
								this.showMask = false;
								this.$message({
									type: 'info',
									message: '已取消修改'
								});
							});
					} else {
						// 不需要填写修改原因，直接进行编辑操作
						this.performReceiveMoneyEdit(receiveMoneyData);
					}
				})
				.catch(error => {
					console.error('获取收款详情失败:', error);
					this.showMask = false;
					this.$message.error('获取收款详情失败');
				});
		},

		// 执行收款编辑操作的逻辑
		performReceiveMoneyEdit(receiveMoneyData) {
			this.reset();

			// 保留表单结构，特别是 params.attachmentIds 和 params.bankacceptance
			this.form = {
				...receiveMoneyData,
				params: {
					...receiveMoneyData.params,
					attachmentIds: receiveMoneyData.attachmentList ? receiveMoneyData.attachmentList.map(item => item.id) : [],
					bankacceptance: receiveMoneyData.params?.bankacceptance || null
				}
			};
			console.log(`receiveMoneyData.bankacceptanceId`, receiveMoneyData.bankacceptanceId);
			// 使用searchSubjectFromMap查找完整路径数组
			if (receiveMoneyData.receiveType) {
				this.form.receiveType = this.searchSubjectFromMap(receiveMoneyData.receiveType);
			}
			// 处理银行账户类型
			let flag = false;
			if (!receiveMoneyData.bankacceptanceId) {
				this.$message.warning('该收款信息无凭证相关信息');
				flag = true;
				this.form.params.bankacceptance = null;
			}

			this.open = true;
			this.title = '修改收款信息';

			// 使用 $nextTick 确保组件渲染完成后再触发事件和设置银行账户类型
			this.$nextTick(() => {
				// 确保 BankType 组件已经挂载并注册了监听器后再触发事件
				this.$bus.$emit('changeFlag', receiveMoneyData.bankacceptanceId !== null ? receiveMoneyData.bankacceptanceId : false);

				if (!flag) {
					if (this.$refs[`selfSelectedBankType`] && receiveMoneyData.selfBankCardType) {
						this.$refs.selfSelectedBankType.localSelectType = receiveMoneyData.selfBankCardType;
					}
					if (this.$refs[`otherSelectedBankType`] && receiveMoneyData.otherBankCardType) {
						this.$refs.otherSelectedBankType.localSelectType = receiveMoneyData.otherBankCardType;
					}

					if (receiveMoneyData.bankacceptanceId) {
						getBankAcceptance(receiveMoneyData.bankacceptanceId).then(result => {
							if (!result.data) {
								this.$message.error('获取凭证数据失败:该行数据存储了凭证ID但没有查询到该ID对应的相关数据');
								// 设置为null避免undefined错误
								this.form.params.bankacceptance = null;
								return;
							}
							this.$nextTick(() => {
								this.form.params.bankacceptance = result.data;
							});
						});
					}
				}
			});
		},

		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 校验收款类型 和银行卡类型
					if (!this.form.receiveType) {
						this.$message.warning('请选择收款类型');
						return;
					}
					if (this.form.selfBankCardType && this.form.otherBankCardType) {
						if (this.form.selfBankCardType !== this.form.otherBankCardType) {
							this.$message.warning('操作失败，无法进行承兑与活期存款或者相反的交易,类型需要保持一致');
							return;
						}
					}

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

					// 处理承兑逻辑
					const selfType = this.$refs.selfSelectedBankType?.localSelectType;
					const otherType = this.$refs.otherSelectedBankType?.localSelectType;
					if (selfType && otherType && selfType !== otherType) {
						if (!this.form.params) {
							this.form.params = {};
						}
						if (!this.form.params.bankacceptance) {
							this.form.params.bankacceptance = {};
						}
						// 只有在没有设置billType时才设置，避免覆盖用户的选择
						if (!this.form.params.bankacceptance.billType) {
							if (selfType === BankAcceptanceType.ACCEPTANCE) {
								this.form.params.bankacceptance.billType = PayType.PAYMENT;
							}
							if (otherType === BankAcceptanceType.ACCEPTANCE) {
								this.form.params.bankacceptance.billType = PayType.RECEIVE;
							}
						}
					}

					// 创建提交数据的深克隆，避免修改原始响应式数据
					let submitData = JSON.parse(JSON.stringify(this.form));

					// 如果是修改操作，添加修改原因
					if (submitData.id != null) {
						const editReason = sessionStorage.getItem('editReason_receiveMoney');
						if (editReason) {
							submitData.editReason = editReason;
						}
					}

					// 对提交数据进行处理，不影响页面显示
					submitData = excludeParams(submitData, this.$exclude);

					// 对结果进行特殊处理 - 只处理提交数据
					if (typeof submitData.receiveType === 'string') {
						this.$message.warning('请选择收款类型');
						return;
					}

					// 将数组格式转换为字符串格式用于提交
					if (Array.isArray(submitData.receiveType)) {
						submitData.receiveType = submitData.receiveType.join('-');
					}

					if (submitData.id != null) {
						// submitData.editReason 已经在深克隆中包含了

						updateReceiveMoney(submitData)
							.then(() => {
								this.$modal.msgSuccess('修改成功');
								// 清理修改原因的sessionStorage
								sessionStorage.removeItem('editReason_receiveMoney');
								// 先部分重置表单，保留关键字段
								this.partialReset();
								this.open = false;
								this.showMask = false;
								this.getList();
								this.$bus.$emit('changeFlag', false);
								this.reset();
								// 使用 $nextTick 确保 reset() 后 form 的值已更新，再重置 BankType 组件状态
								this.$nextTick(() => {
									// 清除 BankType 组件状态，此时会使用 reset() 中设置的默认值
									if (this.$refs.selfSelectedBankType && this.$refs.selfSelectedBankType.resetComponentState) {
										this.$refs.selfSelectedBankType.resetComponentState();
									}
									if (this.$refs.otherSelectedBankType && this.$refs.otherSelectedBankType.resetComponentState) {
										this.$refs.otherSelectedBankType.resetComponentState();
									}
								});
								// 清理上传组件
								if (this.$refs.attachmentUploader) {
									this.$refs.attachmentUploader.clearUploadedFiles();
								}
							})
							.catch(error => {
								console.error('修改收款记录失败:', error);
								// 回滚附件ID到原始状态
								this.$store.commit('CLEAR_ATTACHMENT_IDS');
								originalAttachmentIds.forEach(id => {
									this.$store.commit('ADD_ATTACHMENT_ID', id);
								});
								this.$message.error('修改失败，请重试');
							});
					} else {
						// 新增时，移除修改原因字段
						delete submitData.editReason;

						addReceiveMoney(submitData)
							.then(() => {
								this.$modal.msgSuccess('新增成功');
								// 先部分重置表单，保留关键字段
								this.partialReset();
								this.open = false;
								this.showMask = false;
								this.getList();
								this.reset();
								this.$bus.$emit('changeFlag', false);
								// 使用 $nextTick 确保 reset() 后 form 的值已更新，再重置 BankType 组件状态
								this.$nextTick(() => {
									// 清除 BankType 组件状态，此时会使用 reset() 中设置的默认值
									if (this.$refs.selfSelectedBankType && this.$refs.selfSelectedBankType.resetComponentState) {
										this.$refs.selfSelectedBankType.resetComponentState();
									}
									if (this.$refs.otherSelectedBankType && this.$refs.otherSelectedBankType.resetComponentState) {
										this.$refs.otherSelectedBankType.resetComponentState();
									}
								});
								// 清理上传组件
								if (this.$refs.attachmentUploader) {
									this.$refs.attachmentUploader.clearUploadedFiles();
								}
							})
							.catch(error => {
								console.error('新增收款记录失败:', error);
								// 回滚附件ID到原始状态
								this.$store.commit('CLEAR_ATTACHMENT_IDS');
								originalAttachmentIds.forEach(id => {
									this.$store.commit('ADD_ATTACHMENT_ID', id);
								});
								this.$message.error('新增失败，请重试');
							});
					}
					// 清理上传组件
					if (this.$refs.attachmentUploader) {
						this.$refs.attachmentUploader.clearUploadedFiles();
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除收款信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delReceiveMoney(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			// 处理时间段参数
			const params = { ...this.queryParams };
			if (this.dateRange && this.dateRange.length === 2) {
				params.startTime = this.dateRange[0];
				params.endTime = this.dateRange[1];
			} else {
				// 如果时间范围为空，清空时间参数
				params.startTime = null;
				params.endTime = null;
			}
			params.receiveType = this.queryParams.receiveType?.join('-');

			this.download('system/receiveMoney/export', params, `receiveMoney_${new Date().getTime()}.xlsx`);
		},
		// 下载导入模板
		handleDownloadTemplate() {
			this.download('system/receiveMoney/importTemplate', {}, `收款导入模板_${parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`);
		},
		// 导入收款数据
		handleImportData() {
			const input = document.createElement('input');
			input.type = 'file';
			input.accept = '.xlsx,.xls';
			input.onchange = e => {
				const file = e.target.files[0];
				if (!file) return;

				// 校验文件格式
				const fileName = file.name.toLowerCase();
				const validExtensions = ['.xlsx', '.xls'];
				const isValidFormat = validExtensions.some(ext => fileName.endsWith(ext));

				if (!isValidFormat) {
					this.$message.error('请上传Excel格式的文件（.xlsx 或 .xls）');
					return;
				}

				// 上传文件
				const formData = new FormData();
				formData.append('file', file);

				this.$message.info('正在导入，请稍候...');
				importReceiveMoneyData(formData)
					.then(res => {
						this.importResultMessage = res.msg || '导入完成';
						this.importResultVisible = true;
						// 如果导入成功，刷新列表
						if (res.code === 200 && !res.msg.includes('无有效数据')) {
							this.getList();
						}
					})
					.catch(error => {
						console.error('导入失败:', error);
						this.importResultMessage = error.msg || '导入失败，请重试';
						this.importResultVisible = true;
					});
			};
			input.click();
		},
		// 关闭导入结果弹窗
		closeImportResult() {
			this.importResultVisible = false;
			this.importResultMessage = '';
		}
	}
};
</script>
<style scoped>
.w-85px {
	width: 85px;
}
.receive-second-col {
	/* 当隐藏右侧部分字段时保持与左列间距 */
	margin-top: 0;
}
.receive-second-col ::v-deep(.el-form-item) {
	/* 防止两列合并后左右紧贴 */
	padding-right: 8px;
}
.app-container {
	position: relative;
}
.app-container.mask-overlay {
	position: relative;
}
.container-mask {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.1);
	z-index: 999;
	pointer-events: all;
	cursor: not-allowed;
}
/* 确保对话框在遮罩层之上 */
.app-container >>> .el-dialog__wrapper {
	z-index: 2000 !important;
}
</style>
