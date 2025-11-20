<template>
	<div class="app-container" :class="{ 'mask-overlay': showMask }">
		<!-- 遮罩层 -->
		<div v-if="showMask" class="container-mask"></div>
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="120px">
			<el-form-item label="收款时间">
				<el-date-picker v-model="dateRange" class="date-range-280" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>
			<el-form-item label="支付类型" prop="receiveType">
				<el-cascader v-model="queryParams.receiveType" :options="paymentTypeTree" :props="props" class="input-medium" clearable @keyup.enter.native="handleQuery" />
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
		<!-- 右侧工具栏 -->
		<div class="toolbar-wrapper">
			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #left>
					<div class="toolbar-left">
						<el-row :gutter="10" class="mb8">
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
					</div>
				</template>
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" :disabled="receiveMoneyList.length === 0" />
					</el-col>
				</template>
				<!-- 导出 -->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:receivemoney:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" :disabled="receiveMoneyList.length === 0" />
					</el-col>
				</template>
			</right-toolbar>
		</div>

		<!-- 收款信息表格 -->
		<div class="table-container" v-loading="loading">
			<!-- 渲染进度提示 -->
			<div v-if="isRendering" class="rendering-progress">
				<el-progress :percentage="renderProgress" :status="renderProgress === 100 ? 'success' : null" :stroke-width="6"></el-progress>
				<span class="progress-text">正在渲染数据: {{ renderedData.length }} / {{ paginatedData.length }}</span>
			</div>

			<div class="table-wrapper" id="printBox">
				<table class="native-table">
					<thead>
						<tr>
							<!-- ID -->
							<th :style="{ width: columnWidths.id }">ID</th>
							<!-- 日期 -->
							<th v-if="columns[0] && columns[0].visible"  :style="{ width: columnWidths.date }">日期</th>
							<!-- 支付类型 -->
							<th v-if="columns[1] && columns[1].visible !== false"  :style="{ width: columnWidths.receiveType }">支付类型</th>
							<!-- 金额 -->
							<th v-if="columns[2] && columns[2].visible" :style="{ width: columnWidths.moneyAmount }">金额</th>
							<!-- 我方户名 -->
							<th v-if="columns[3] && columns[3].visible" :style="{ width: columnWidths.selfAcountsName }">我方户名</th>
							<!-- 我方账号 -->
							<th v-if="columns[4] && columns[4].visible" :style="{ width: columnWidths.selfBankNo }">我方账号</th>
							<!-- 我方开户行 -->
							<th v-if="columns[5] && columns[5].visible" :style="{ width: columnWidths.selfBankName }">我方开户行</th>
							<!-- 对方户名 -->
							<th v-if="columns[6] && columns[6].visible" :style="{ width: columnWidths.otherAcountsName }">对方户名</th>
							<!-- 对方账号 -->
							<th v-if="columns[7] && columns[7].visible" :style="{ width: columnWidths.otherBankNo }">对方账号</th>
							<!-- 对方开户行 -->
							<th v-if="columns[8] && columns[8].visible" :style="{ width: columnWidths.otherBankName }">对方开户行</th>
							<!-- 对方公司名称 -->
							<th v-if="columns[9] && columns[9].visible" :style="{ width: columnWidths.companyName }">对方公司名称</th>
							<!-- 对方公司类型 -->
							<th v-if="columns[10] && columns[10].visible" :style="{ width: columnWidths.companyType }">对方公司类型</th>
							<!-- 备注 -->
							<th :style="{ width: columnWidths.comments }">备注</th>
							<!-- 银行卡流水编号 -->
							<th :style="{ width: columnWidths.transactionHistory }">银行卡流水编号</th>
							<!-- 录入人员 -->
							<th :style="{ width: columnWidths.userName }">录入人员</th>
							<!-- 银行卡流水附件 -->
							<th :style="{ width: columnWidths.attachment }">银行卡流水附件</th>
							<!-- 操作 -->
							<th class="fixed-right col-action" :style="{ width: columnWidths.action }">操作</th>
						</tr>
					</thead>
					<tbody>
						<tr v-for="(row, index) in renderedData" :key="row.id" :class="{ 'stripe-row': index % 2 === 1 }">
							<!-- ID -->
							<td>{{ row.id }}</td>
							<!-- 日期 -->
							<td v-if="columns[0] && columns[0].visible" >{{ row.fundsDate || '-' }}</td>
							<!-- 支付类型 -->
							<td v-if="columns[1] && columns[1].visible !== false" >{{ row.receiveType || '-' }}</td>
							<!-- 金额 -->
							<td v-if="columns[2] && columns[2].visible">{{ row.moneyAmount || '-' }}</td>
							<!-- 我方户名 -->
							<td v-if="columns[3] && columns[3].visible">{{ row.selfAcountsName || '-' }}</td>
							<!-- 我方账号 -->
							<td v-if="columns[4] && columns[4].visible">{{ row.selfBankNo || '-' }}</td>
							<!-- 我方开户行 -->
							<td v-if="columns[5] && columns[5].visible">{{ row.selfBankName || '-' }}</td>
							<!-- 对方户名 -->
							<td v-if="columns[6] && columns[6].visible">{{ row.otherAcountsName || '-' }}</td>
							<!-- 对方账号 -->
							<td v-if="columns[7] && columns[7].visible">{{ row.otherBankNo || '-' }}</td>
							<!-- 对方开户行 -->
							<td v-if="columns[8] && columns[8].visible">{{ row.otherBankName || '-' }}</td>
							<!-- 对方公司名称 -->
							<td v-if="columns[9] && columns[9].visible">{{ row.companyName || '-' }}</td>
							<!-- 对方公司类型 -->
							<td v-if="columns[10] && columns[10].visible">{{ row.companyType || '-' }}</td>
							<!-- 备注 -->
							<td class="text-ellipsis">{{ row.comments || '-' }}</td>
							<!-- 银行卡流水编号 -->
							<td>{{ row.transactionHistory || '-' }}</td>
							<!-- 录入人员 -->
							<td>{{ row.userName || '-' }}</td>
							<!-- 银行卡流水附件 -->
							<td>
								<el-tooltip effect="light" placement="top" enterable :hide-after="0" popper-class="interactive-tooltip">
						<div slot="content" @click.stop>
										<CheckFiles :attachmentList="row.attachmentList" @needToUpdate="value => handleUpdateFilePath(value, row, getReceiveMoney(), updateReceiveMoney())" flag="transactionHistoryAttachment" />
						</div>
					</el-tooltip>
							</td>
							<!-- 操作 -->
							<td class="fixed-right col-action">
								<el-dropdown @command="command => handleCommand(command, row)">
						<el-button type="primary" size="mini" >
							操作
							<i class="el-icon-arrow-down el-icon--right"></i>
						</el-button>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item v-hasPermi="['system:receivemoney:edit']" command="edit">修改</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:receivemoney:remove']" command="delete" divided>删除</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:tableeditmessage:list']" command="viewEditReason">查看修改原因</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>



		<!-- 分页组件 -->
    <div class="pagination-wrapper">
      <pagination
          v-show="total > 0"
          :total="total"
          :page.sync="queryParams.pageNum"
          :limit.sync="queryParams.pageSize"
          :page-sizes="[10, 20, 50, 100, 200, 500]"
          layout="total, sizes, prev, pager, next, jumper"
          background
          @pagination="getList"
      />
    </div>

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
			<el-table :data="editReasonList" style="width: 100%">
				<el-table-column prop="addtime" label="修改时间" />
				<el-table-column prop="reason" label="修改原因" />
				<el-table-column prop="userName" label="修改人" />
			</el-table>
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
										<el-table-column label="账户类型" align="center" prop="acountsType" width="100" />
										<el-table-column label="开户名称(户名)" align="center" prop="acountsName" width="300" />
										<el-table-column label="账号(银行账号)" align="center" prop="bankNo" width="300" />
										<el-table-column label="开户行" align="center" prop="bankName" width="300" />
										<el-table-column label="己方公司" align="center" prop="displayName" width="300" />
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
										<el-table-column label="车牌/柜号" align="center" prop="carNo" width="220" />
										<el-table-column label="司机姓名/海运公司" align="center" prop="driver" width="220" />
										<el-table-column label="司机电话" align="center" prop="tel" width="200" />
										<el-table-column label="户名" align="center" prop="acountsName" width="200" />
										<el-table-column label="银行账号" align="center" prop="bankNo" width="200" />
										<el-table-column label="开户行" align="center" prop="bankName" width="200" />
										<el-table-column label="运输类型" align="center" prop="carType" width="200" />
									</template>
								</SearchOption>
								<SearchOption v-else :limit-info="{ companyType: form.companyType }" :get-data="listCompany" query-info="companyName" query-label="公司名称" :query-name="companyName" @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
									<template #table-columns>
										<el-table-column :label="value" align="center" prop="companyName" />
										<el-table-column label="公司类型" align="center" prop="companyType" />
										<el-table-column label="老板姓名" align="center" prop="leader" />
										<el-table-column label="老板电话" align="center" prop="leaderTel" />
										<el-table-column label="区域" align="center" prop="region" />
										<el-table-column label="销售经理" align="center" prop="salesManager" />
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
										<el-table-column label="账户类型" align="center" prop="acountsType" width="100" />
										<el-table-column label="开户名称(户名)" align="center" prop="acountsName" width="300" />
										<el-table-column label="账号(银行账号)" align="center" prop="bankNo" width="300" />
										<el-table-column label="开户行" align="center" prop="bankName" width="300" />
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
							<UploadFilesButton ref="attachmentUploader" flag="transactionHistoryAttachment" accept-types="image/*,.pdf,.jpg,.jpeg,.png,.gif,.bmp,.doc,.docx,.xls,.xlsx" :extra-info="{ moduleType: 'receiveMoney', formId: form.id }" :initial-attachments="form.attachmentList || []" @files-updated="handleAttachmentFilesUpdated" style="width: 100%" />
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
import { BankAcceptanceType, PayType, PAYMENT_TARGET_TYPE, TableName, PUBLIC_DICT_TYPE } from '@/api/tool/enums';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import CheckFiles from '../../../components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';

import { listCompany, getCompany } from '../../../api/system/company';
import { mixin_receive_money_fill } from './receiveMoneyFill';
import { listCars } from '../../../api/system/cars';
import { getReceiveMoney, updateReceiveMoney } from '../../../api/system/receiveMoney';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import { mixin_bankType } from '../../dashboard/mixins/common/common_bankType';
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
		},
		// 分页后的数据（后端已分页，直接使用列表数据）
		paginatedData() {
			return this.receiveMoneyList;
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
					{ required: true, message: '金额不能为空', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (value && !/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				receiveType: [{ required: true, message: '请选择收款类型', trigger: 'change' }],
				selfAcountsName: [{ required: true, message: '我方户名不能为空', trigger: 'change' }],
				selfBankNo: [{ required: true, message: '我方账号不能为空', trigger: 'blur' }],
				selfBankName: [{ required: true, message: '我方开户行不能为空', trigger: 'blur' }],
				companyName: [{ required: true, message: '对方公司名称不能为空', trigger: 'blur' }],
				otherAcountsName: [{ required: true, message: '对方户名不能为空', trigger: 'blur' }],
				otherBankNo: [{ required: true, message: '对方账号不能为空', trigger: 'blur' }]
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
			// 列宽度配置
			columnWidths: {
				id: '80px',
				date: '180px',
				receiveType: '250px',
				moneyAmount: '120px',
				selfAcountsName: '180px',
				selfBankNo: '200px',
				selfBankName: '200px',
				otherAcountsName: '180px',
				otherBankNo: '200px',
				otherBankName: '200px',
				companyName: '200px',
				companyType: '150px',
				comments: '200px',
				transactionHistory: '180px',
				userName: '120px',
				attachment: '180px',
				action: '150px'
			},
			// 分片渲染相关
			renderedData: [],
			isRendering: false,
			renderProgress: 0,
			renderChunkSize: 50,
			renderTimer: null,
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
			importResultMessage: '',
			// 窗口大小变化防抖定时器
			resizeTimer: null
		};
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('receivemoney-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		// 监听分页数据变化，触发分片渲染
		paginatedData: {
			handler(newData) {
				if (newData && newData.length > 0) {
					this.renderDataInChunks(newData);
				} else {
					this.renderedData = [];
					this.isRendering = false;
					this.renderProgress = 0;
				}
			},
			immediate: true
		},
		// 监听对方类型 切换类型时清空已填充的值
		'form.companyType'(newVal, oldVal) {
			// 如果类型发生变化（不是初始化），清空相关字段
			if (oldVal !== undefined && oldVal !== null && newVal !== oldVal) {
				this.clearCompanyTypeFields(newVal);
			} else if (newVal === PAYMENT_TARGET_TYPE.PAYMENT_FEE) {
				// 初始化时如果直接选择支付费用，也要清空
				this.clearCompanyTypeFields(newVal);
			}
		}
	},

	created() {
		this.reset();
		this.getList();
		// 获取本地显示隐藏列的存储，以便于下一次用户打开的时候读取喜好
		const savedColumns = localStorage.getItem('receivemoney-columns');
		if (savedColumns && savedColumns !== 'null') {
			try {
				const parsedColumns = JSON.parse(savedColumns);
				// 确保 columns 数组完整且每个元素都有 visible 属性
				if (Array.isArray(parsedColumns) && parsedColumns.length >= 12) {
					// 确保所有必需的列都存在
					this.columns = parsedColumns.map((col, index) => {
						if (!col || typeof col.visible === 'undefined') {
							// 如果列配置缺失，使用默认配置
							const defaultColumns = [
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
							];
							return defaultColumns[index] || col;
						}
						return col;
					});
				} else {
					// 如果解析的列配置不完整，使用默认配置
			localStorage.setItem('receivemoney-columns', JSON.stringify(this.columns));
				}
			} catch (error) {
				console.error('解析列配置失败:', error);
				localStorage.setItem('receivemoney-columns', JSON.stringify(this.columns));
			}
		} else {
			localStorage.setItem('receivemoney-columns', JSON.stringify(this.columns));
		}
		// 监听窗口大小变化，重新计算表格高度
		window.addEventListener('resize', this.handleResize);
	},
	beforeDestroy() {
		// 移除窗口大小变化监听
		window.removeEventListener('resize', this.handleResize);
		// 清理定时器
		if (this.resizeTimer) {
			clearTimeout(this.resizeTimer);
			this.resizeTimer = null;
		}
		// 清理渲染定时器
		if (this.renderTimer) {
			cancelAnimationFrame(this.renderTimer);
			this.renderTimer = null;
		}
	},
	methods: {
		// 分片渲染数据
		renderDataInChunks(data) {
			// 如果正在渲染，先取消
			if (this.renderTimer) {
				cancelAnimationFrame(this.renderTimer);
				this.renderTimer = null;
			}

			const total = data.length;

			// 如果数据量很小，直接一次性渲染
			if (total <= this.renderChunkSize) {
				this.renderedData = [...data];
				this.isRendering = false;
				this.renderProgress = 0;
				return;
			}

			// 重置状态
			this.renderedData = [];
			this.isRendering = true;
			this.renderProgress = 0;

			let currentIndex = 0;

			const renderChunk = () => {
				// 计算本次要渲染的数据范围
				const endIndex = Math.min(currentIndex + this.renderChunkSize, total);
				const chunk = data.slice(currentIndex, endIndex);

				// 添加到已渲染数据
				this.renderedData = [...this.renderedData, ...chunk];

				// 更新进度
				currentIndex = endIndex;
				this.renderProgress = Math.round((currentIndex / total) * 100);

				// 如果还有数据未渲染，继续下一批
				if (currentIndex < total) {
					this.renderTimer = requestAnimationFrame(renderChunk);
				} else {
					// 渲染完成
					this.isRendering = false;
					this.renderProgress = 100;
					this.renderTimer = null;

					// 延迟隐藏进度条，让用户看到完成状态
					setTimeout(() => {
						this.renderProgress = 0;
					}, 500);
				}
			};

			// 开始渲染
			this.renderTimer = requestAnimationFrame(renderChunk);
		},
		// 处理窗口大小变化
		handleResize() {
			// 使用防抖，避免频繁触发
			if (this.resizeTimer) {
				clearTimeout(this.resizeTimer);
			}
			this.resizeTimer = setTimeout(() => {
				// 表格布局已由原生 table 处理，无需额外操作
			}, 100);
		},
		// 重置BankType组件状态
		resetBankTypeComponents() {
				this.$nextTick(() => {
				if (this.$refs.selfSelectedBankType?.resetComponentState) {
					this.$refs.selfSelectedBankType.resetComponentState();
				}
				if (this.$refs.otherSelectedBankType?.resetComponentState) {
					this.$refs.otherSelectedBankType.resetComponentState();
				}
			});
		},
		// 清理上传组件状态
		clearUploaderState() {
			if (this.$refs.attachmentUploader) {
				this.$refs.attachmentUploader.clearUploadedFiles();
			}
		},
		// 清空公司类型相关字段
		clearCompanyTypeFields(companyType) {
			this.form.companyName = null;
			this.form.companyId = null;
			// 如果切换到支付费用，还需要清空银行账户相关字段
			if (companyType === PAYMENT_TARGET_TYPE.PAYMENT_FEE) {
				this.form.otherAcountsName = null;
				this.form.otherBankNo = null;
				this.form.otherBankName = null;
			}
		},
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
			listTableEditMessage(this.editReasonQueryParams)
				.then(response => {
				this.editReasonList = response.rows;
				this.editReasonTotal = response.total;
				})
				.catch(error => {
					console.error('获取修改原因列表失败:', error);
					this.$message.error('获取修改原因失败');
			});
		},
		handleAttachmentFilesUpdated(uploadParams) {
			try {
				// 确保 form.params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}

				// 检查 uploadParams 是否存在
				if (!uploadParams) {
					console.warn('handleAttachmentFilesUpdated: uploadParams 为空');
					return;
				}

				// 检查 params 是否存在
				if (!uploadParams.params) {
					console.warn('handleAttachmentFilesUpdated: uploadParams.params 不存在', uploadParams);
					return;
				}

				// 检查 attachmentIds 是否存在且为数组
				if (!uploadParams.params.attachmentIds) {
					console.warn('handleAttachmentFilesUpdated: attachmentIds 不存在', uploadParams.params);
					// 如果 attachmentIds 不存在，设置为空数组
					this.form.params.attachmentIds = [];
					return;
				}

				// 确保 attachmentIds 是数组
				if (!Array.isArray(uploadParams.params.attachmentIds)) {
					console.error('handleAttachmentFilesUpdated: attachmentIds 不是数组', uploadParams.params.attachmentIds);
					this.$message.warning('附件ID格式错误，请重新上传');
					return;
				}

				// 直接使用上传组件返回的统一附件ID数组
				this.form.params.attachmentIds = uploadParams.params.attachmentIds;
				console.log('附件更新成功，附件ID:', this.form.params.attachmentIds);
			} catch (error) {
				console.error('handleAttachmentFilesUpdated 处理失败:', error);
				this.$message.error('处理附件更新时出错：' + (error.message || '未知错误'));
			}
		},
		listCars,
		listCompany,
		getCompany,
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
				getCompany(acceptanceData.endorser, acceptanceData.origin)
					.then(response => {
					if (response.data) {
						const companyInfo = response.data;
						this.form.companyName = companyInfo.companyName;
						this.form.companyId = companyInfo.id;
					}
					})
					.catch(error => {
						console.error('获取背书人/被背书人公司信息失败:', error);
					});
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
				params.startTime = null;
				params.endTime = null;
			}
			// 把查询条件中的receiveType转成字符串
			if (params.receiveType && Array.isArray(params.receiveType)) {
				params.receiveType = params.receiveType.join('-');
			}

			listReceiveMoney(params)
				.then(response => {
				this.receiveMoneyList = response.rows;
				this.total = response.total;
				})
				.catch(error => {
					console.error('查询收款信息列表失败:', error);
					this.$message.error('查询失败，请重试');
				})
				.finally(() => {
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.showMask = false;
			this.$bus.$emit('changeFlag', false);
			this.reset();
			this.resetBankTypeComponents();
			this.clearUploaderState();
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
			this.clearUploaderState();
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
			this.clearUploaderState();
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
			// 使用 $nextTick 确保组件渲染完成后再设置银行账户类型和其他属性
			this.$nextTick(() => {
				// 先保存 companyName，避免 watch 监听器清空它
				const savedCompanyName = receiveMoneyData.companyName;
				const savedCompanyId = receiveMoneyData.companyId;
				// 保留表单结构，特别是 params.attachmentIds 和 params.bankacceptance
				Object.assign(this.form, {
					...receiveMoneyData,
					params: {
						...receiveMoneyData.params,
						attachmentIds: receiveMoneyData.attachmentList ? receiveMoneyData.attachmentList.map(item => item.id) : [],
						bankacceptance: receiveMoneyData.params?.bankacceptance || null
					}
				});
				// 如果 companyType 发生了变化，watch 可能已经清空了 companyName，需要恢复
				// 使用 $nextTick 确保 watch 执行完毕后再恢复值
				this.$nextTick(() => {
					// 确保 companyName 和 companyId 被正确赋值（包括 0 值）
					// 使用 hasOwnProperty 或 in 操作符检查属性是否存在，而不是判断值是否为 falsy
					if (receiveMoneyData.hasOwnProperty('companyName')) {
						this.form.companyName = savedCompanyName;
					}
					if (receiveMoneyData.hasOwnProperty('companyId')) {
						this.form.companyId = savedCompanyId;
					}
				});
				// 处理银行账户类型
				let flag = false;
				if (!receiveMoneyData.bankacceptanceId) {
					this.$message.warning('该收款信息无凭证相关信息');
					flag = true;
					this.form.params.bankacceptance = null;
				}
				this.open = true;
				this.title = '修改收款信息';
				// 使用额外的 $nextTick 确保 BankType 组件已经挂载并注册了事件监听器
				this.$nextTick(() => {
					this.$bus.$emit('changeFlag', receiveMoneyData.bankacceptanceId !== null ? receiveMoneyData.bankacceptanceId : false);
				});
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
							this.form.params.bankacceptance = result.data;
						});
					}
				}
				// 设置级联选择器的值 - 使用searchSubjectFromMap查找完整路径数组
				if (this.form.receiveType) {
					this.form.receiveType = this.searchSubjectFromMap(this.form.receiveType);
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

					// 确保 form.params 对象存在
					if (!this.form.params) {
						this.form.params = {};
					}

					// 确保 form.params.attachmentIds 存在且为数组
					if (!this.form.params.attachmentIds || !Array.isArray(this.form.params.attachmentIds)) {
						// 从 Vuex store 获取附件ID作为备用
						const storeAttachmentIds = this.$store.getters.attachmentIds || [];
						this.form.params.attachmentIds = Array.isArray(storeAttachmentIds) ? [...storeAttachmentIds] : [];
					}

					// 去重附件ID
					const uniqueAttachmentIds = [...new Set(this.form.params.attachmentIds)];
					this.form.params.attachmentIds = uniqueAttachmentIds;

					// 保存当前附件ID用于错误回滚
					const originalAttachmentIds = [...uniqueAttachmentIds];

					// 同步到 Vuex store（用于其他组件）
					if (uniqueAttachmentIds.length > 0) {
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
							} else if (otherType === BankAcceptanceType.ACCEPTANCE) {
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
								this.resetBankTypeComponents();
								this.clearUploaderState();
							})
							.catch(error => {
								console.error('修改收款记录失败:', error);
								// 回滚附件ID到原始状态
								if (originalAttachmentIds && originalAttachmentIds.length > 0) {
									this.$store.commit('CLEAR_ATTACHMENT_IDS');
									originalAttachmentIds.forEach(id => {
										this.$store.commit('ADD_ATTACHMENT_ID', id);
									});
									// 同时回滚 form.params.attachmentIds
									if (this.form.params) {
										this.form.params.attachmentIds = [...originalAttachmentIds];
									}
								}
								this.$message.error('修改失败：' + (error.msg || error.message || '请重试'));
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
								this.resetBankTypeComponents();
								this.clearUploaderState();
							})
							.catch(error => {
								console.error('新增收款记录失败:', error);
								// 回滚附件ID到原始状态
								if (originalAttachmentIds && originalAttachmentIds.length > 0) {
									this.$store.commit('CLEAR_ATTACHMENT_IDS');
									originalAttachmentIds.forEach(id => {
										this.$store.commit('ADD_ATTACHMENT_ID', id);
									});
									// 同时回滚 form.params.attachmentIds
									if (this.form.params) {
										this.form.params.attachmentIds = [...originalAttachmentIds];
									}
								}
								this.$message.error('新增失败：' + (error.msg || error.message || '请重试'));
							});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm(`是否确认删除收款信息编号为"${ids}"的数据项？`)
				.then(() => delReceiveMoney(ids))
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
						if (res.code === 200 && !res.msg?.includes('无有效数据')) {
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
<style scoped lang="scss">
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
	overflow: visible;
	min-height: 100vh;
}
.app-container.mask-overlay {
	position: relative;
}
.container-mask {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.1);
	z-index: 999;
	pointer-events: all;
	cursor: not-allowed;
}
/* 搜索表单样式 */
#top-search-form-item {
	position: relative;
	background-color: #fff;
	padding: 10px 0;
	margin-bottom: 10px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.toolbar-wrapper {
	margin-bottom: 15px;

	.toolbar-left {
	padding: 10px 0;
	}
}

.text-ellipsis {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	max-width: 200px;
}

/* 总条数显示样式 */
.total-info {
	margin: 0;
	padding: 5px 0;
	text-align: left;
	border-top: 1px solid #ebeef5;
}

.total-text {
	font-size: 14px;
	color: #606266;
}

.total-text strong {
	color: #409eff;
	font-weight: 600;
	font-size: 16px;
}

/* 确保对话框在遮罩层之上 */
.app-container >>> .el-dialog__wrapper {
	z-index: 2000 !important;
}

/* 表格容器样式 */
.table-container {
	position: relative;

	.rendering-progress {
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		z-index: 1000;
		background: rgba(255, 255, 255, 0.95);
		padding: 10px 20px;
		border-bottom: 1px solid #ebeef5;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

		.progress-text {
			display: block;
			margin-top: 8px;
			text-align: center;
			font-size: 12px;
			color: #606266;
		}
	}

	.table-wrapper {
	position: relative;
		width: 100%;
		max-height: 750px;
		overflow-x: auto;
		overflow-y: auto;
		border: 1px solid #ebeef5;
		border-radius: 4px;
		background: #fff;

			.native-table {
			width: 100%;
			min-width: max-content;
			table-layout: auto;
			border-collapse: collapse;
			border-spacing: 0;
			font-size: 12px;
			color: #606266;
			background: #fff;

			thead {
				background: #f5f7fa;
				position: sticky;
				top: 0;
				z-index: 10;
				display: table-header-group;

				th {
					padding: 8px 4px;
					text-align: center;
					font-weight: 500;
					color: #909399;
					border: 1px solid #ebeef5;
					border-top: none;
					background: #f5f7fa;
					white-space: nowrap;
					position: relative;
					line-height: 1.5;
					min-height: 32px;
					height: auto;
					vertical-align: middle;

					&.fixed-left {
						position: sticky;
						z-index: 11;
						background: #f5f7fa;
						box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);

						&.col-date {
							left: 60px;
						}

						&.col-receive-type {
							left: 200px;
						}
					}

					&.fixed-right {
						position: sticky;
						right: 0;
						z-index: 11;
						background: #f5f7fa;
						box-shadow: -2px 0 4px rgba(0, 0, 0, 0.1);
					}
				}
			}

			tbody {
				tr {
					transition: background-color 0.25s ease;

					&:hover {
						background: #f5f7fa;
					}

					&.stripe-row {
						background: #fafafa;
					}

					&.stripe-row:hover {
						background: #f5f7fa;
					}

					td {
						padding: 4px 2px;
						border: 1px solid #ebeef5;
						border-top: none;
						white-space: nowrap;
						text-align: center;
						position: relative;
						line-height: 1.2;
						vertical-align: middle;
						
						// 确保单元格内的按钮和组件正常显示
						.el-button,
						.el-dropdown,
						.el-tooltip {
							margin: 0;
						}

						&.fixed-left {
							position: sticky;
							z-index: 9;
							background: inherit;
							box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);

							&.col-date {
								left: 60px;
							}

							&.col-receive-type {
								left: 200px;
							}
						}

						&.fixed-right {
							position: sticky;
							right: 0;
							z-index: 9;
							background: inherit;
							box-shadow: -2px 0 4px rgba(0, 0, 0, 0.1);
						}
					}
				}
			}

			// 启用硬件加速
			transform: translateZ(0);
			-webkit-transform: translateZ(0);
		}
	}
}

.pagination-wrapper {
  position: relative;
  margin-top: 20px; /* 调整与表格的间距 */
  padding: 10px 20px;
  background-color: #fff;
  border-top: 1px solid #ebeef5;
  text-align: right;
}


.pagination-wrapper ::v-deep .pagination-container {
	margin: 0;
	padding: 0;
}

// 响应式优化
@media screen and (max-width: 768px) {
	.table-wrapper {
		max-height: 500px;
	}

	.column-hidden-mobile {
		display: none;
	}
}
</style>
