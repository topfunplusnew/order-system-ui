<template>
	<div class="app-container" :class="{ 'mask-overlay': showMask }">
		<!-- 遮罩层 -->
		<div v-if="showMask" class="container-mask"></div>
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="120px">
			<el-form-item label="付款时间">
				<el-date-picker v-model="dateRange" class="date-range-280" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>
			<!--      客户还是供应商-->
			<el-form-item label="对象类型" prop="companyType">
				<el-select class="input-medium" v-model="queryParams.companyType" placeholder="请选择对象类型" clearable @keyup.enter.native="handleQuery">
					<el-option v-for="item in options_companyType" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="付款类型" prop="payType">
				<el-cascader v-model="queryParams.payType" :options="paymentTypeTree" :props="props" @keyup.enter.native="handleQuery"></el-cascader>
			</el-form-item>
			<el-form-item label="我方户名" prop="selfAccountsName">
				<el-input class="input-medium" v-model="queryParams.selfAccountsName" placeholder="请输入我方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方公司" prop="companyName">
				<el-input class="input-medium" v-model="queryParams.companyName" placeholder="请输入对方公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAccountsName">
				<el-input class="input-medium" v-model="queryParams.otherAccountsName" placeholder="请输入对方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方银行卡号" prop="selfBankID">
				<el-input class="input-medium" v-model="queryParams.otherBankNo" placeholder="请输入对方银行卡号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="备注" prop="otherBankNo">
				<el-input class="input-long" v-model="queryParams.comments" placeholder="请输入备注" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="票据号码" prop="bankacceptanceBillNo">
				<el-input class="input-medium" v-model="queryParams.params.bankacceptanceBillNo" placeholder="请输入票据号码" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="复核状态" prop="auditState">
				<el-select class="input-medium" v-model="queryParams.auditState" placeholder="请选择复核状态" clearable @keyup.enter.native="handleQuery">
					<el-option v-for="item in auditState_options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
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
							<!-- 刷新按钮-->
							<el-col :span="1.5">
								<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
							</el-col>
							<el-col :span="1.5">
								<el-button v-hasPermi="['system:payment:import']" size="mini" @click="handleDownloadTemplate">下载导入模板</el-button>
							</el-col>
							<el-col :span="1.5">
								<el-button v-hasPermi="['system:payment:import']" size="mini" @click="handleImportData">导入模板</el-button>
							</el-col>
							<!--      解开了新增付款信息-->
							<el-col :span="1.5" style="margin-left: 15px">
								<el-button v-hasPermi="['system:payment:add']" type="danger" size="mini" @click="handleAdd">新增付款信息</el-button>
							</el-col>
						</el-row>
					</div>
				</template>
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" :disabled="paymentList.length === 0" />
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:payment:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" :disabled="paymentList.length === 0" />
					</el-col>
				</template>
			</right-toolbar>
		</div>

		<!-- 付款信息表格 -->
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
							<th v-if="columns[1] && columns[1].visible" :style="{ width: columnWidths.date }">日期</th>
							<!-- 支付类型 -->
							<th v-if="columns[2] && columns[2].visible" :style="{ width: columnWidths.payType }">支付类型</th>
							<!-- 对方公司 -->
							<th v-if="columns[11] && columns[11].visible" :style="{ width: columnWidths.companyName }">对方公司</th>
							<!-- 对方公司类型 -->
							<th v-if="columns[12] && columns[12].visible" :style="{ width: columnWidths.companyType }">对方公司类型</th>
							<!-- 金额 -->
							<th v-if="columns[3] && columns[3].visible" :style="{ width: columnWidths.moneyAmount }">金额</th>
							<!-- 我方户名 -->
							<th v-if="columns[4] && columns[4].visible" :style="{ width: columnWidths.selfAccountsName }">我方户名</th>
							<!-- 我方账号 -->
							<th v-if="columns[5] && columns[5].visible" :style="{ width: columnWidths.selfBankNo }">我方账号</th>
							<!-- 我方开户行 -->
							<th v-if="columns[6] && columns[6].visible" :style="{ width: columnWidths.selfBankName }">我方开户行</th>
							<!-- 对方户名 -->
							<th v-if="columns[7] && columns[7].visible" :style="{ width: columnWidths.otherAccountsName }">对方户名</th>
							<!-- 对方账号 -->
							<th v-if="columns[8] && columns[8].visible" :style="{ width: columnWidths.otherBankNo }">对方账号</th>
							<!-- 对方开户行 -->
							<th v-if="columns[9] && columns[9].visible" :style="{ width: columnWidths.otherBankName }">对方开户行</th>
							<!-- 支付状态 -->
							<th v-if="columns[10] && columns[10].visible" :style="{ width: columnWidths.paymentState }">支付状态</th>
							<!-- 备注 -->
							<th v-if="columns[13] && columns[13].visible" :style="{ width: columnWidths.comments }">备注</th>
							<!-- 附件 -->
							<th v-if="columns[14] && columns[14].visible" :style="{ width: columnWidths.attachment }">附件</th>
							<!-- 银行卡流水编号 -->
							<th v-if="columns[15] && columns[15].visible" :style="{ width: columnWidths.transactionHistory }">银行卡流水编号</th>
							<!-- 银行卡流水附件 -->
							<th v-if="columns[16] && columns[16].visible" :style="{ width: columnWidths.transactionHistoryAttachment }">银行卡流水附件</th>
							<!-- 录入人员 -->
							<th v-if="columns[17] && columns[17].visible" :style="{ width: columnWidths.userName }">录入人员</th>
							<!-- 复核状态 -->
							<th :style="{ width: columnWidths.auditState }">复核状态</th>
							<!-- 操作 -->
							<th class="fixed-right col-action" :style="{ width: columnWidths.action }">操作</th>
						</tr>
					</thead>
					<tbody>
						<tr v-for="(row, index) in renderedData" :key="row.id" :class="{ 'stripe-row': index % 2 === 1 }">
							<!-- ID -->
							<td>{{ row.id }}</td>
							<!-- 日期 -->
							<td v-if="columns[1] && columns[1].visible">{{ row.fundsDate || '-' }}</td>
							<!-- 支付类型 -->
							<td v-if="columns[2] && columns[2].visible">{{ row.payType || '-' }}</td>
							<!-- 对方公司 -->
							<td v-if="columns[11] && columns[11].visible">{{ row.companyName || '-' }}</td>
							<!-- 对方公司类型 -->
							<td v-if="columns[12] && columns[12].visible">{{ row.companyType || '-' }}</td>
							<!-- 金额 -->
							<td v-if="columns[3] && columns[3].visible">{{ row.moneyAmount || '-' }}</td>
							<!-- 我方户名 -->
							<td v-if="columns[4] && columns[4].visible" class="text-ellipsis">{{ row.selfAccountsName || '-' }}</td>
							<!-- 我方账号 -->
							<td v-if="columns[5] && columns[5].visible" class="text-ellipsis">{{ row.selfBankNo || '-' }}</td>
							<!-- 我方开户行 -->
							<td v-if="columns[6] && columns[6].visible">{{ row.selfBankName || '-' }}</td>
							<!-- 对方户名 -->
							<td v-if="columns[7] && columns[7].visible">{{ row.otherAccountsName || '-' }}</td>
							<!-- 对方账号 -->
							<td v-if="columns[8] && columns[8].visible" class="text-ellipsis">{{ row.otherBankNo || '-' }}</td>
							<!-- 对方开户行 -->
							<td v-if="columns[9] && columns[9].visible">{{ row.otherBankName || '-' }}</td>
							<!-- 支付状态 -->
							<td v-if="columns[10] && columns[10].visible">
								<el-tag :type="row.paymentState === PAYMENT_STATE.PAID ? 'success' : row.paymentState === PAYMENT_STATE.UNPAID ? 'info' : 'warning'" size="mini">
									{{ row.paymentState || '-' }}
								</el-tag>
							</td>
							<!-- 备注 -->
							<td v-if="columns[13] && columns[13].visible" class="text-ellipsis">{{ row.comments || '-' }}</td>
							<!-- 附件 -->
							<td v-if="columns[14] && columns[14].visible">
								<el-tooltip effect="light" placement="top" enterable :hide-after="0" popper-class="interactive-tooltip">
									<div slot="content" @click.stop>
										<CheckFiles :attachmentList="row.attachmentList" @needToUpdate="value => handleUpdateFilePath(value, row, getPayment, updatePayment)" flag="attachments" />
									</div>
									<CheckFiles :attachmentList="row.attachmentList" @needToUpdate="value => handleUpdateFilePath(value, row, getPayment, updatePayment)" flag="attachments" />
								</el-tooltip>
							</td>
							<!-- 银行卡流水编号 -->
							<td v-if="columns[15] && columns[15].visible">{{ row.transactionHistory || '-' }}</td>
							<!-- 银行卡流水附件 -->
							<td v-if="columns[16] && columns[16].visible">
								<el-tooltip effect="light" placement="top" enterable :hide-after="0" popper-class="interactive-tooltip">
									<div slot="content" @click.stop>
										<CheckFiles :attachmentList="row.attachmentList" @needToUpdate="value => handleUpdateFilePath(value, row, getPayment, updatePayment)" flag="transactionHistoryAttachmentList" />
									</div>
									<CheckFiles :attachmentList="row.attachmentList" @needToUpdate="value => handleUpdateFilePath(value, row, getPayment, updatePayment)" flag="transactionHistoryAttachmentList" />
								</el-tooltip>
							</td>
							<!-- 录入人员 -->
							<td v-if="columns[17] && columns[17].visible">{{ row.userName || '-' }}</td>
							<!-- 复核状态 -->
							<td >
								<el-tooltip :content="hasAuditPermission ? '点击切换复核状态' : '您没有复核权限'" placement="top">
									<el-switch v-model="row.auditState" :disabled="!hasAuditPermission" :active-value="'1'" :inactive-value="'0'" active-color="#13ce66" inactive-color="#ff4949" @change="value => hasAuditPermission && handlePaymentAudit(row, value)" />
								</el-tooltip>
							</td>
							<!-- 操作 -->
							<td class="fixed-right col-action">
								<el-dropdown @command="command => handleCommand(command, row)">
									<el-button type="primary" size="mini">
										操作
										<i class="el-icon-arrow-down el-icon--right"></i>
									</el-button>
									<el-dropdown-menu slot="dropdown">
										<el-dropdown-item v-if="row.paymentState === PAYMENT_STATE.UNPAID" v-hasPermi="['system:payment:edit']" command="payment">付款</el-dropdown-item>
										<el-dropdown-item v-else-if="row.paymentState === PAYMENT_STATE.PAID" disabled command="paid">已付款</el-dropdown-item>
										<el-dropdown-item v-else disabled command="applying">申请中</el-dropdown-item>
										<el-dropdown-item v-hasPermi="['system:payment:edit']" :disabled="row.paymentState === PAYMENT_STATE.UNPAID || (row.paymentState === PAYMENT_STATE.PAID && row.auditState === '1')" command="edit" divided>编辑</el-dropdown-item>
										<el-dropdown-item v-hasPermi="['system:payment:remove']" :disabled="row.paymentState === PAYMENT_STATE.PAID && row.auditState === '1'" command="delete">删除</el-dropdown-item>
										<el-dropdown-item v-hasPermi="['system:tableeditmessage:list']" command="viewEditReason">查看修改原因</el-dropdown-item>
										<el-dropdown-item v-if="hasTableReference(row, TableName.ORDER_FREIGHT)" command="viewFreightInfo" divided>查看运费信息</el-dropdown-item>
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
				<el-table-column prop="addtime" label="修改时间" show-overflow-tooltip />
				<el-table-column prop="reason" label="修改原因" show-overflow-tooltip />
				<el-table-column prop="userName" label="修改人" show-overflow-tooltip />
			</el-table>
			<pagination v-show="editReasonTotal > 0" :total="editReasonTotal" :page.sync="editReasonQueryParams.pageNum" :limit.sync="editReasonQueryParams.pageSize" @pagination="getEditReasonList" />
		</el-dialog>

		<!--		     添加或修改付款信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1000px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="170px">
				<!-- 付款编码（只读，仅编辑时展示） -->
				<el-form-item v-if="form && form.id != null" label="付款编码">
					<el-input v-model="form.code" disabled />
				</el-form-item>
				<el-row :gutter="40">
					<!-- 左列 -->
					<el-col :span="form.companyType === PAYMENT_TARGET_TYPE.PAYMENT_FEE ? 24 : 12">
						<el-form-item label="日期" prop="fundsDate">
							<el-date-picker v-model="form.fundsDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%"></el-date-picker>
						</el-form-item>

						<el-form-item label="付款类型" prop="payType">
							<el-cascader v-model="form.payType" :options="paymentTypeTree" :props="props" @change="handleChange" style="width: 100%"></el-cascader>
						</el-form-item>

						<el-form-item label="金额" prop="moneyAmount">
							<el-input v-model="form.moneyAmount" placeholder="请输入金额" style="width: 100%" />
						</el-form-item>

						<el-form-item label="我方银行账户类型">
							<BankType
								ref="selfSelectedBankType"
								:bill-type="BankAcceptanceType.PAY_TYPE.PAYMENT"
								:select-type="form.selfBankCardType"
								:external-bankacceptance-info="form.params.bankacceptance"
								@updateSelectedType="changeSelfBankType"
								@updateBankAcceptance="handleBankAcceptanceUpdate"
								style="width: 100%"
							/>
						</el-form-item>

						<el-form-item label="我方户名" prop="selfAccountsName">
							<el-row>
								<el-col :span="22">
									<el-input disabled v-model="form.selfAccountsName" placeholder="请选择" style="width: 100%" />
								</el-col>
								<el-col :span="2">
									<SearchOption
										:limit-info="{ acountsType: '己方公司' }"
										:get-data="listBankAccount"
										icon="el-icon-search"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										width="1000px"
										@commitBack="handleCommitBack"
										@update:queryName="handleUpdateQueryName"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" width="100" />
											<el-table-column label="开户名称(户名)" align="center" prop="acountsName" width="300" />
											<el-table-column label="账号(银行账号)" align="center" prop="bankNo" width="300" />
											<el-table-column label="开户行" align="center" prop="bankName" width="300" />
											<el-table-column label="己方公司" align="center" prop="displayName" width="300" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>

						<el-form-item label="我方账号" prop="selfBankNo">
							<el-input disabled v-model="form.selfBankNo" placeholder="请选择" style="width: 100%" />
						</el-form-item>

						<el-form-item label="我方开户行" prop="selfBankName">
							<el-input disabled v-model="form.selfBankName" placeholder="请选择" style="width: 100%" />
						</el-form-item>

						<el-form-item label="对方类型">
							<el-select v-model="form.companyType" placeholder="请选择" style="width: 100%">
								<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
							</el-select>
						</el-form-item>

						<el-form-item v-if="form.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE && form.companyType !== PUBLIC_DICT_TYPE.EMPLOYEE" label="对方公司名称" prop="companyName">
							<el-row>
								<el-col :span="22">
									<el-input disabled v-model="form.companyName" placeholder="请选择" style="width: 100%" />
								</el-col>
								<el-col :span="2" v-if="form.companyType === PAYMENT_TARGET_TYPE.CUSTOMER || form.companyType === PAYMENT_TARGET_TYPE.SUPPLIER">
									<SearchOption
										:limit-info="{ companyType: form.companyType }"
										:get-data="listCompany"
										:query-info="`companyName`"
										:query-label="`公司名称`"
										:query-name="companyName"
										@update:queryName="value => (companyName = value)"
										@commitBack="handleCommitBackCompany"
									>
										<template #table-columns>
											<el-table-column :label="form.companyType" align="center" prop="companyName" :width="form.companyType === PAYMENT_TARGET_TYPE.SUPPLIER ? 340 : 150" />
											<el-table-column label="老板姓名" align="center" prop="leader" />
											<el-table-column label="老板电话" align="center" prop="leaderTel" />
											<el-table-column label="区域" align="center" prop="region" />
											<el-table-column label="销售经理" align="center" prop="salesManager" v-if="form.companyType !== PAYMENT_TARGET_TYPE.SUPPLIER" />
										</template>
									</SearchOption>
								</el-col>
								<el-col :span="2" v-if="form.companyType === PAYMENT_TARGET_TYPE.DRIVER">
									<SearchOption
										:limit-info="{ companyType: form.companyType }"
										:get-data="listCars"
										:query-info="`driver`"
										:query-label="`司机`"
										:query-name="companyName"
										@update:queryName="value => (companyName = value)"
										@commitBack="handleCommitBackCompany"
									>
										<template #table-columns>
											<el-table-column label="运输类型" align="center" prop="carType" />
											<el-table-column label="车牌/柜号" align="center" prop="carNo" />
											<el-table-column label="司机姓名/海运公司" align="center" prop="driver" />
											<el-table-column label="司机电话" align="center" prop="tel" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>

					<!-- 右列 -->
					<el-col :span="form.companyType === PAYMENT_TARGET_TYPE.PAYMENT_FEE ? 24 : 12">
						<el-form-item v-if="form.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE" label="对方银行账户类型">
							<BankType
								ref="otherSelectedBankType"
								:option-baned="true"
								:baned="true"
								:select-type="form.otherBankCardType"
								@updateSelectedType="changeOtherBankType"
								style="width: 100%"
							/>
						</el-form-item>

						<!-- 选择供应商 -->
						<el-form-item v-if="form.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE" label="对方户名" prop="otherAccountsName">
							<el-input disabled v-model="form.otherAccountsName" placeholder="请选择" style="width: 100%" />
						</el-form-item>

						<el-form-item v-if="form.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE" label="对方账号" prop="otherBankNo">
							<el-row>
								<el-col :span="22">
									<el-input disabled v-model="form.otherBankNo" placeholder="请选择" style="width: 100%" />
								</el-col>
								<el-col :span="2">
									<SearchOption
										:limit-info="{ acountsType: form.companyType }"
										:get-data="listBankAccount"
										:query-name="queryBankAcount"
										query-label="户名查找"
										query-info="acountsName"
										@commitBack="handleCommitBackBankAcount"
										@update:queryName="handleUpdateQueryBankAcount"
										:extra-params="{
											companyId: form.companyId,
											companyType: form.companyType
										}"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" />
											<el-table-column label="公司名称" align="center" prop="companyName" />
											<el-table-column label="户名" align="center" prop="acountsName" />
											<el-table-column label="账号(银行账号)" align="center" prop="bankNo" width="200" />
											<el-table-column label="开户行" align="center" prop="bankName" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>

						<el-form-item v-if="form.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE" label="对方开户行" prop="otherBankName">
							<el-input disabled v-model="form.otherBankName" placeholder="请选择" style="width: 100%" />
						</el-form-item>

						<el-form-item label="附件" prop="attachmentIds">
							<UploadFilesButton
								ref="attachmentUpload"
								flag="attachments"
								:extra-info="{ moduleType: 'payment', formId: form.id }"
								:initial-attachments="form.attachmentList || []"
								@files-updated="handleAttachmentFilesUpdated"
								style="width: 100%"
							/>
						</el-form-item>

						<el-form-item label="银行卡流水编号" prop="transactionHistory">
							<el-input v-model="form.transactionHistory" placeholder="请输入银行卡流水编号" style="width: 100%" />
						</el-form-item>
						<el-form-item label="银行卡流水附件" prop="attachmentIds">
							<UploadFilesButton
								ref="transactionHistoryUpload"
								flag="transactionHistoryAttachmentList"
								:extra-info="{ moduleType: 'payment', formId: form.id }"
								:initial-attachments="form.attachmentList || []"
								@files-updated="handleAttachmentFilesUpdated"
								style="width: 100%"
							/>
						</el-form-item>
						<el-form-item label="录入人员" prop="userName">
							<el-input v-model="form.userName" placeholder="请输入录入人员" style="width: 100%" />
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" style="width: 100%" />
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">{{ form.id != null ? '确 定' : '确认付款' }}</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    选择银行卡的页面-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="请填写付款信息" :visible.sync="chooseBankDialogVisible" width="600px">
			<div>
				<el-form :model="chooseInfo" label-width="170px">
					<el-form-item label="对方银行账户类型" prop="selfBankNo">
						<BankType
							:bill-type="BankAcceptanceType.PAY_TYPE.PAYMENT"
							:select-type="chooseInfo.otherBankCardType"
							@updateSelectedType="changeCustomSelfBankType"
							@updateBankAcceptance="value => (chooseInfo.params.bankacceptance = value)"
						/>
					</el-form-item>
					<el-form-item label="我方银行账户类型" prop="selfBankNo">
						<BankType
							:option-baned="true"
							:baned="true"
							:bill-type="BankAcceptanceType.PAY_TYPE.PAYMENT"
							:select-type="chooseInfo.selfBankCardType"
							@updateSelectedType="changeCustomSelfBankType"
							@updateBankAcceptance="value => (chooseInfo.params.bankacceptance = value)"
						/>
					</el-form-item>
					<el-form-item label="我方户名" prop="selfAccountsName">
						<el-row>
							<el-col :span="22">
								<el-input v-model="chooseInfo.selfAccountsName" placeholder="请输入我方户名" />
							</el-col>
							<el-col :span="2">
								<SearchOption
									:limit-info="{ acountsType: '己方公司' }"
									:get-data="listBankAccount"
									icon="el-icon-search"
									query-label="户名查找"
									query-info="acountsName"
									:query-name="queryChoose"
									@commitBack="handleCommitBackChoose"
									@update:queryName="handleUpdateQueryChoose"
								>
									<template #table-columns>
										<el-table-column label="账号类型" align="center" prop="acountsType" width="100" />
										<el-table-column label="我方公司" align="center" prop="displayName" width="200" />
										<el-table-column label="开户名" align="center" prop="acountsName" width="200" />
										<el-table-column label="账号" align="center" prop="bankNo" width="200" />
										<el-table-column label="开户行" align="center" prop="bankName" width="200" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="我方账号" prop="selfBankNo">
						<el-input v-model="chooseInfo.selfBankNo" placeholder="请输入我方账号" />
					</el-form-item>
					<el-form-item label="我方开户行" prop="selfBankName">
						<el-input v-model="chooseInfo.selfBankName" placeholder="请输入我方开户行" />
					</el-form-item>
				</el-form>
			</div>
			<span slot="footer" class="dialog-footer">
				<el-button @click="chooseBankDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="handlePayment">确 定</el-button>
			</span>
		</el-dialog>
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="信息" :visible.sync="infoVisible" width="900px" append-to-body>
			<component :is="Components" :need-to-show-info="needToShowInfo" />
		</el-dialog>

		<!--     查看运费信息弹窗-->
		<InfoDialog :visible.sync="viewFreightVisible" title="查看运费信息" :width="'1100px'" @close="closeViewFreight">
			<template #info>
				<div class="order-freight-body">
					<!-- 左侧：运费信息展示区域 -->
					<div class="order-freight-info">
						<el-collapse v-model="activeNames">
							<el-collapse-item v-for="(item, index) in viewFreightList" :key="index" :title="'运费信息(' + (index + 1) + ')'" :name="index + ''">
								<el-card class="box-card">
									<div>
										<el-descriptions :title="'运费信息(' + (index + 1) + ')'" :column="2" border>
											<el-descriptions-item label="运费ID" :span="1">{{ item.id }}</el-descriptions-item>
											<el-descriptions-item label="运费类型" :span="1">
												<el-tag size="mini">{{ item.freightType }}</el-tag>
											</el-descriptions-item>
											<el-descriptions-item label="司机/海运公司" :span="1">{{ item.driverName || '-' }}</el-descriptions-item>
											<el-descriptions-item label="车牌号/柜号" :span="1">{{ item.carNo || '-' }}</el-descriptions-item>
											<el-descriptions-item label="车队" :span="1">{{ item.fleet || '-' }}</el-descriptions-item>
											<el-descriptions-item label="运费金额" :span="1">
												<span style="color: #f56c6c; font-weight: bold">{{ item.moneyAmount || 0 }}</span>
											</el-descriptions-item>
											<el-descriptions-item label="已付金额" :span="1">
												<span style="color: #67c23a; font-weight: bold">{{ item.paidAmount || 0 }}</span>
											</el-descriptions-item>
											<el-descriptions-item label="支付状态" :span="1">
												<el-tag :type="item.paymentState === '已支付' ? 'success' : 'danger'" size="mini">
													{{ item.paymentState || '未支付' }}
												</el-tag>
											</el-descriptions-item>
											<el-descriptions-item label="运费来源" :span="1">
												<el-tag size="mini">{{ item.source === 'goodsorder' ? '订单' : item.source || '-' }}</el-tag>
											</el-descriptions-item>
											<el-descriptions-item label="对方户名" :span="1">{{ item.otherAcountsName || '-' }}</el-descriptions-item>
											<el-descriptions-item label="对方账号" :span="1">{{ item.otherBankNo || '-' }}</el-descriptions-item>
											<el-descriptions-item label="对方开户行" :span="1">{{ item.otherBankName || '-' }}</el-descriptions-item>
											<el-descriptions-item label="申请人员" :span="1">{{ item.applyUserName || '-' }}</el-descriptions-item>
											<el-descriptions-item label="申请日期" :span="1">{{ item.applyDate || '-' }}</el-descriptions-item>
											<el-descriptions-item label="付款人员" :span="1">{{ item.payUserName || '-' }}</el-descriptions-item>
											<el-descriptions-item label="付款日期" :span="1">{{ item.payDate || '-' }}</el-descriptions-item>
											<el-descriptions-item label="备注" :span="2">{{ item.comments || item.content || '-' }}</el-descriptions-item>
											<!-- 付款信息 -->
											<el-descriptions-item label="付款信息" :span="2">
												<div v-if="item.payment" style="margin-top: 8px">
													<el-descriptions :column="2" border size="mini">
														<el-descriptions-item label="付款编码" :span="1">{{ item.payment.code || '-' }}</el-descriptions-item>
														<el-descriptions-item label="付款日期" :span="1">{{ item.payment.fundsDate || '-' }}</el-descriptions-item>
														<el-descriptions-item label="付款类型" :span="1">{{ item.payment.payType || '-' }}</el-descriptions-item>
														<el-descriptions-item label="付款金额" :span="1">
															<span style="color: #67c23a; font-weight: bold">{{ item.payment.moneyAmount || 0 }}</span>
														</el-descriptions-item>
														<el-descriptions-item label="我方银行类型" :span="1">{{ item.payment.selfBankCardType || '-' }}</el-descriptions-item>
														<el-descriptions-item label="对方银行类型" :span="1">{{ item.payment.otherBankCardType || '-' }}</el-descriptions-item>
														<el-descriptions-item label="对方户名" :span="1">{{ item.payment.otherAccountsName || '-' }}</el-descriptions-item>
														<el-descriptions-item label="对方账号" :span="1">{{ item.payment.otherBankNo || '-' }}</el-descriptions-item>
														<el-descriptions-item label="对方开户行" :span="1">{{ item.payment.otherBankName || '-' }}</el-descriptions-item>
														<el-descriptions-item label="复核状态" :span="1">
															<el-tag :type="item.payment.auditState === '1' ? 'success' : 'info'" size="mini">
																{{ item.payment.auditState === '1' ? '已复核' : '未复核' }}
															</el-tag>
														</el-descriptions-item>
														<el-descriptions-item label="付款备注" :span="2">{{ item.payment.comments || '-' }}</el-descriptions-item>
													</el-descriptions>
												</div>
												<span v-else>-</span>
											</el-descriptions-item>
										</el-descriptions>
									</div>
								</el-card>
							</el-collapse-item>
						</el-collapse>
					</div>
					<!-- 右侧：我方信息和运费合计 -->
					<div class="order-freight-self-info">
						<el-form label-width="120px">
							<el-form-item label="我方户名">
								<el-input :value="selfBankInfo.selfAcountsName" disabled />
							</el-form-item>
							<el-form-item label="我方账号">
								<el-input :value="selfBankInfo.selfBankNo" disabled />
							</el-form-item>
							<el-form-item label="我方开户行">
								<el-input :value="selfBankInfo.selfBankName" disabled />
							</el-form-item>
							<!-- 运费总和展示区域 -->
							<div class="total-freight-section">
								<div class="total-freight-label">运费总和</div>
								<div class="total-freight-amount">{{ fix(totalFreightAmount) }}</div>
							</div>
						</el-form>
					</div>
				</div>
			</template>
		</InfoDialog>
	</div>
</template>

<script>
import { listPayment, delPayment, addPayment, updatePayment, updatePaymentSimulate, getPayment, importPaymentData } from '@/api/system/payment';
import { listTableEditMessage } from '@/api/system/tableEditMessage';
import { TableName } from '@/api/tool/enums';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { excludeParams } from '@/api/tool/exclude';
import { addDateRange, parseTime } from '@/utils/ruoyi';
import { listBankAccount, getBankAccount } from '../../../api/system/bankAccount';
import { mixin_payment_audit } from '../../dashboard/mixins/payment/payment_audit';
import { mixin_payment_select, PAYMENT_TYPES } from '../../dashboard/mixins/payment/payment_select';
import { listCars } from '../../../api/system/cars';
import { isNull } from '../../../main';
import { mixin_payment_subject } from '../../dashboard/mixins/payment/payment_subject';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { mixin_paymentindex_fill } from './paymentFill';
import CheckDetail from '../../dashboard/components/payment/CheckDetail.vue';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import { mixin_bankType } from '../../dashboard/mixins/common/common_bankType';
import StateTag from '@/views/dashboard/components/common/StateTag.vue';
import { BankAcceptanceType, PayType, PAYMENT_TARGET_TYPE, PUBLIC_DICT_TYPE, PAYMENT_STATE } from '../../../api/tool/enums';
import CheckFiles from '@/components/CheckFiles.vue';
import { mixin_checkfile } from '@/views/dashboard/mixins/checkfiles/mixin_checkfile';
import _ from 'lodash';
import UploadFilesButton from '@/components/UploadFilesButton';
import PaymentFlag from '@/components/PaymentFlag';
import { getBankAcceptance } from '../../../api/system/bankAcceptance';
import { checkPermi } from '@/utils/permission';
import ExpandCursor from '../../dashboard/components/common/ExpandCursor.vue';
import { getOrderFreight } from '@/api/system/orderFreight';
import { hasTableReference } from '@/utils/payment/utils';
import InfoDialog from '../../../components/InfoDialog.vue';
import { fix } from '../../../api/tool/format';
import { getCompany } from '../../../api/system/company';

export default {
	name: 'Payment',
	components: {
		UploadFilesButton,
		CheckFiles,
		StateTag,
		BankType,
		CheckDetail,
		SearchOption,
		PaymentFlag,
		ExpandCursor,
		InfoDialog
	},
	mixins: [mixin_printHTML, mixin_payment_audit, mixin_payment_select, mixin_payment_subject, mixin_paymentindex_fill, mixin_bankType, mixin_checkfile],
	data() {
		return {
			// 遮罩层
			loading: true,
			// 对方类型选项 (绑定 form.companyType)
			options: [
				{ value: PAYMENT_TARGET_TYPE.CUSTOMER, label: PUBLIC_DICT_TYPE.CUSTOMER },
				{ value: PAYMENT_TARGET_TYPE.SUPPLIER, label: PUBLIC_DICT_TYPE.SUPPLIER },
				{ value: PAYMENT_TARGET_TYPE.DRIVER, label: PUBLIC_DICT_TYPE.DRIVER },
				{ value: PAYMENT_TARGET_TYPE.PAYMENT_FEE, label: PAYMENT_TARGET_TYPE.PAYMENT_FEE },
				{ value: PUBLIC_DICT_TYPE.EMPLOYEE, label: PUBLIC_DICT_TYPE.EMPLOYEE }
			],
			defaultCompanyType: '供应商', // 添加默认公司类型
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
			// 付款信息表格数据
			paymentList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				payNO: null,
				fundsDate: null,
				payType: null,
				tableName: null,
				tID: null,
				moneyAmount: null,
				selfAccountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAccountsName: null,
				otherBankNo: null,
				otherBankName: null,
				paymentState: null,
				companyName: null,
				companyId: null,
				companyType: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				auditState: null,
				params: {
					bankacceptanceBillNo: null
				}
			},
			auditState_options: [
				{ label: '未复核', value: '0' },
				{ label: '已复核', value: '1' }
			],
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				fundsDate: [{ required: true, message: '请选择日期', trigger: 'blur' }],
				payType: [
					{
						required: true,
						message: '请选择付款类型',
						trigger: 'blur'
					}
				],
				moneyAmount: [
					{ required: true, message: '请输入金额', trigger: 'blur' },
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
				selfAccountsName: [
					{
						required: true,
						message: '请输入我方户名',
						trigger: 'blur'
					}
				],
				selfBankNo: [
					{
						required: true,
						message: '请输入我方账号',
						trigger: 'blur'
					}
				],
				selfBankName: [
					{
						required: true,
						message: '请输入我方开户行',
						trigger: 'blur'
					}
				],
				companyName: [
					{
						required: true,
						message: '对方公司不能为空',
						trigger: 'blur'
					}
				],
				otherBankNo: [
					{
						required: true,
						message: '请输入对方账号',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: ` id`, visible: true },
				{ key: 1, label: `日期`, visible: true },
				{ key: 2, label: `支付类型`, visible: true },
				{ key: 3, label: `金额`, visible: true },
				{ key: 4, label: `我方户名`, visible: true },
				{ key: 5, label: `我方账号`, visible: true },
				{ key: 6, label: `我方开户行`, visible: true },
				{ key: 7, label: `对方户名`, visible: true },
				{ key: 8, label: `对方账号`, visible: true },
				{ key: 9, label: `对方开户行`, visible: true },
				{ key: 10, label: `支付状态`, visible: true },
				{ key: 11, label: `对方公司`, visible: true },
				{ key: 12, label: `对方公司类型`, visible: true },
				{ key: 13, label: `备注`, visible: true },
				{ key: 14, label: `附件`, visible: true },
				// 新增银行卡流水编号和附件列
				{ key: 15, label: `银行卡流水编号`, visible: true },
				{ key: 16, label: `银行卡流水附件`, visible: true },
				{ key: 17, label: `录入人员`, visible: true }
			],
			// 顶部筛选框
			queryPayment: {},
			dateRange: [],
			options_companyType: [
				{ value: PAYMENT_TARGET_TYPE.CUSTOMER, label: PUBLIC_DICT_TYPE.CUSTOMER },
				{ value: PAYMENT_TARGET_TYPE.SUPPLIER, label: PUBLIC_DICT_TYPE.SUPPLIER },
				{ value: PAYMENT_TARGET_TYPE.DRIVER, label: PUBLIC_DICT_TYPE.DRIVER },
				{ value: PAYMENT_TARGET_TYPE.PAYMENT_FEE, label: PAYMENT_TARGET_TYPE.PAYMENT_FEE },
				{ value: PUBLIC_DICT_TYPE.EMPLOYEE, label: PUBLIC_DICT_TYPE.EMPLOYEE }
			],
			// 银行卡选择的弹窗
			chooseBankDialogVisible: false,
			chooseInfo: {
				params: {
					bankacceptance: null
				}
			},
			oneClickPaymentDialogVisible: false,

			// 展示一下合并的信息
			batchPaymentData: [],
			// 对应渲染的组件和信息
			Components: null,
			needToShowInfo: null,
			infoVisible: false,
			// 查看修改原因相关
			editReasonDialogVisible: false,
			editReasonList: [],
			editReasonTotal: 0,
			editReasonQueryParams: {
				pageNum: 1,
				pageSize: 20,
				tableName: TableName.PAYMENT,
				tid: null
			},
			// 遮罩层显示状态
			showMask: false,
			// 查看运费信息相关数据
			viewFreightVisible: false, // 查看运费信息弹窗显示状态
			viewFreightList: [], // 查看的运费信息列表
			activeNames: [], // 折叠面板激活项
			// 导入结果弹窗
			importResultVisible: false,
			importResultMessage: '',
			// 列宽度配置
			columnWidths: {
				id: '80px',
				date: '120px',
				payType: '180px',
				companyName: '120px',
				companyType: '130px',
				moneyAmount: '70px',
				selfAccountsName: '250px',
				selfBankNo: '180px',
				selfBankName: '120px',
				otherAccountsName: '120px',
				otherBankNo: '190px',
				otherBankName: '120px',
				paymentState: '120px',
				comments: '120px',
				attachment: '120px',
				transactionHistory: '120px',
				transactionHistoryAttachment: '120px',
				userName: '120px',
				auditState: '80px',
				action: '200px'
			},
			// 分片渲染相关
			renderedData: [],
			isRendering: false,
			renderProgress: 0,
			renderChunkSize: 50,
			renderTimer: null,
			// 窗口大小变化防抖定时器
			resizeTimer: null
		};
	},
	computed: {
		PAYMENT_TARGET_TYPE() {
			return PAYMENT_TARGET_TYPE;
		},
		BankAcceptanceType() {
			return BankAcceptanceType;
		},
		PAYMENT_TYPES() {
			return PAYMENT_TYPES;
		},
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		PAYMENT_STATE() {
			return PAYMENT_STATE;
		},
		TableName() {
			return TableName;
		},
		// 检查是否有复核权限（包含admin权限）
		hasAuditPermission() {
			return checkPermi(['system:payment:audit']);
		},
		// 计算运费总和
		totalFreightAmount() {
			if (_.isEmpty(this.viewFreightList)) {
				return 0;
			}
			return _.sumBy(this.viewFreightList, item => Number(item.moneyAmount) || 0);
		},
		// 获取我方信息（从第一条运费信息中获取，因为应该都是一样的）
		selfBankInfo() {
			if (_.isEmpty(this.viewFreightList)) {
				return {
					selfAcountsName: '-',
					selfBankNo: '-',
					selfBankName: '-'
				};
			}
			const firstItem = this.viewFreightList[0];
			return {
				selfAcountsName: firstItem.selfAcountsName || '-',
				selfBankNo: firstItem.selfBankNo || '-',
				selfBankName: firstItem.selfBankName || '-'
			};
		},
		// 分页后的数据（后端已分页，直接使用列表数据）
		paginatedData() {
			return this.paymentList;
		}
	},
	// 展示与隐藏
	// 在现有的 watch 对象中添加新的监听器
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('payment-columns', JSON.stringify(newVal));
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
		'form.companyType'(newVal, oldVal) {
			// 如果类型发生变化（不是初始化），清空相关字段
			if (oldVal !== undefined && oldVal !== null && newVal !== oldVal) {
				// 如果切换到支付费用，清空隐藏的表单项
				if (newVal === PAYMENT_TARGET_TYPE.PAYMENT_FEE) {
					this.clearPaymentFeeHiddenFields();
				}
				// 如果从支付费用切换到其他类型，需要重置对方银行卡类型为默认值
				if (oldVal === PAYMENT_TARGET_TYPE.PAYMENT_FEE && newVal !== PAYMENT_TARGET_TYPE.PAYMENT_FEE) {
					this.resetOtherBankCardType();
				}
			} else if (newVal === PAYMENT_TARGET_TYPE.PAYMENT_FEE) {
				// 初始化时如果直接选择支付费用，也要清空隐藏的表单项
				this.clearPaymentFeeHiddenFields();
			}
		}
	},

	created() {
		this.reset();
		this.getList();
		if (localStorage.getItem('payment-columns') === 'null' || !localStorage.getItem('payment-columns')) {
			// 设置localStorage
			localStorage.setItem('payment-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('payment-columns'));
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
		updatePayment,
		getPayment,
		isNull,
		listCars,
		listBankAccount,
		getBankAccount,
		listCompany,
		hasTableReference,
		fix,
		// 重置对方银行卡类型为默认值（银行活期存款）
		resetOtherBankCardType() {
			this.$set(this.form, 'otherBankCardType', BankAcceptanceType.BANK_CASH);
			// 如果存在对方银行账户类型组件引用，也需要更新组件状态
			if (this.$refs.otherSelectedBankType) {
				this.$refs.otherSelectedBankType.localSelectType = BankAcceptanceType.BANK_CASH;
			}
		},
		// 清空选择"支付费用"时隐藏的表单项的值
		clearPaymentFeeHiddenFields() {
			// 清空对方银行账户相关字段
			this.$set(this.form, 'otherBankCardType', null);
			this.$set(this.form, 'otherAccountsName', null);
			this.$set(this.form, 'otherBankNo', null);
			this.$set(this.form, 'otherBankName', null);
			// 清空对方公司相关字段
			this.$set(this.form, 'companyName', null);
			this.$set(this.form, 'companyId', null);
			// 如果存在对方银行账户类型组件引用，也需要重置组件状态
			if (this.$refs.otherSelectedBankType) {
				this.$refs.otherSelectedBankType.localSelectType = null;
				// 重置组件状态
				if (this.$refs.otherSelectedBankType.resetComponentState) {
					this.$refs.otherSelectedBankType.resetComponentState();
				}
			}
		},
		// 下拉菜单命令处理
		handleCommand(command, row) {
			switch (command) {
				case 'payment':
					this.handlePaymentRow(row);
					break;
				case 'edit':
					// 检查付款状态，如果是未支付状态则不允许编辑
					if (row.paymentState === PAYMENT_STATE.UNPAID) {
						this.$message.warning('未支付的付款信息不允许编辑，请先完成付款操作');
						return;
					}
					// 检查是否已付款且已复核，如果是则不允许编辑
					if (row.paymentState === PAYMENT_STATE.PAID && row.auditState === '1') {
						this.$message.warning('已付款且已复核的付款信息不允许编辑');
						return;
					}
					this.handleEdit(row);
					break;
				case 'delete':
					// 检查是否已付款且已复核，如果是则不允许删除
					if (row.paymentState === PAYMENT_STATE.PAID && row.auditState === '1') {
						this.$message.warning('已付款且已复核的付款信息不允许删除');
						return;
					}
					this.handleDelete(row);
					break;
				case 'viewEditReason':
					this.handleViewEditReason(row);
					break;
				case 'viewFreightInfo':
					this.handleViewFreightInfo(row);
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
		// 处理附件文件更新
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
		handleCommitUpload(value) {
			this.form.attachment = value;
		},
		// 选择我方银行账户类型
		changeCustomSelfBankType(value) {
			this.chooseInfo.otherBankCardType = value;
			this.chooseInfo.selfBankCardType = value;
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
							this.form.selfAccountsName = bankInfo.acountsName;
							this.form.selfBankNo = bankInfo.bankNo;
							this.form.selfBankName = bankInfo.bankName;
							this.form.selfBankID = bankInfo.id;
						}
					})
					.catch(error => {
						console.error('获取我方承兑账户信息失败:', error);
					});
			}

			// 填充背书人/被背书人信息 只填充对方公司
			// 不过获取一张银行卡，需要对象+卡号，对象需要对象companyId+companyType
			if (acceptanceData.endorser) {
				getCompany(acceptanceData.endorser, acceptanceData.origin).then(response => {
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
				// 			this.form.otherAccountsName = bankInfo.acountsName;
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
		/** 查询付款信息列表 */
		getList() {
			this.loading = true;
			let payTypeString = '';
			// 把查询条件中的payType转成字符串
			if (this.queryParams.payType) {
				payTypeString = this.queryParams.payType.join('-');
			}
			// 查询
			return listPayment(addDateRange({ ...this.queryParams, payType: payTypeString }, this.dateRange, 'payment')).then(response => {
				// 规范化 auditState：后端已复核为字符串 '1'，未复核为 null，这里统一为 '1' 或 '0'
				const rows = Array.isArray(response.rows) ? response.rows : [];
				rows.forEach(r => {
					if (r && (r.auditState === null || r.auditState === undefined || r.auditState === '0' || r.auditState === 0 || r.auditState === false)) {
						r.auditState = '0';
					} else if (r && (r.auditState === '1' || r.auditState === 1 || r.auditState === true)) {
						r.auditState = '1';
					}
				});
				this.paymentList = rows;
				this.total = response.total;
				this.loading = false;
				return response;
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
			// 清除附件上传状态
			if (this.$refs.attachmentUpload) {
				this.$refs.attachmentUpload.clearUploadedFiles();
			}
			// 清除银行卡流水附件上传状态
			if (this.$refs.transactionHistoryUpload) {
				this.$refs.transactionHistoryUpload.clearUploadedFiles();
			}
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				code: null,
				payNO: null,
				fundsDate: parseTime(new Date()),
				payType: null,
				tableName: null,
				tID: null,
				moneyAmount: null,
				selfBankCardType: BankAcceptanceType.BANK_CASH, // 默认设置为银行活期存款
				otherBankCardType: BankAcceptanceType.BANK_CASH,
				selfAccountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAccountsName: null,
				otherBankNo: null,
				otherBankName: null,
				paymentState: null,
				companyName: null,
				companyId: null,
				companyType: this.defaultCompanyType, // 设置默认公司类型为客户
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
			if (this.$refs.attachmentUpload) {
				this.$refs.attachmentUpload.clearUploadedFiles();
			}
			// 清除银行卡流水附件上传状态
			if (this.$refs.transactionHistoryUpload) {
				this.$refs.transactionHistoryUpload.clearUploadedFiles();
			}
		},
		// 部分重置 - 保留银行账户类型和付款类型
		partialReset() {
			// 保存原始的payType，如果是字符串格式则通过searchSubjectFromMap查找完整路径数组
			let preservedPayType = this.form.payType;
			if (typeof preservedPayType === 'string' && preservedPayType) {
				preservedPayType = this.searchSubjectFromMap(preservedPayType);
			}
			const preservedSelfBankCardType = this.form.selfBankCardType;
			const preservedOtherBankCardType = this.form.otherBankCardType;

			this.form = {
				id: null,
				payNO: null,
				fundsDate: parseTime(new Date()),
				payType: preservedPayType,
				tableName: null,
				tID: null,
				moneyAmount: null,
				selfBankCardType: preservedSelfBankCardType,
				otherBankCardType: preservedOtherBankCardType,
				selfAccountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAccountsName: null,
				otherBankNo: null,
				otherBankName: null,
				paymentState: null,
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
				bankacceptance: null,
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
			if (this.$refs.attachmentUpload) {
				this.$refs.attachmentUpload.clearUploadedFiles();
			}
			// 清除银行卡流水附件上传状态
			if (this.$refs.transactionHistoryUpload) {
				this.$refs.transactionHistoryUpload.clearUploadedFiles();
			}
		},
		resetChooseInfo() {
			this.chooseInfo = {
				id: null,
				payNO: null,
				fundsDate: null,
				payType: null,
				tableName: null,
				tID: null,
				moneyAmount: null,
				// 我方银行账户类型
				selfBankCardType: null,
				// 对方银行账户类型
				otherBankCardType: null,
				selfAccountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAccountsName: null,
				otherBankNo: null,
				otherBankName: null,
				paymentState: null,
				companyName: null,
				companyId: null,
				companyType: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				params: {
					attachmentIds: [],
					bankacceptance: {}
				}
			};
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
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
			this.title = '添加付款信息';
			this.showMask = true;
		},
		/** 编辑按钮操作 */
		handleEdit(row) {
			this.showMask = true;
			// 先获取付款详情，判断是否需要填写修改原因
			const id = row.id || this.ids;
			getPayment(id)
				.then(response => {
					if (!response.data) {
						this.$message.error('获取付款信息失败');
						return;
					}
					const paymentData = response.data;
					// 判断是否需要填写修改原因
					if (paymentData && paymentData.shouldTrackEditReason === true) {
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
								sessionStorage.setItem('editReason_payment', value);
								// 继续编辑操作
								this.performEditLogic(paymentData);
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
						this.performEditLogic(paymentData);
					}
				})
				.catch(error => {
					console.error('获取付款详情失败:', error);
					this.showMask = false;
					this.$message.error('获取付款详情失败');
				});
		},

		// 执行编辑操作的逻辑
		performEditLogic(paymentData) {
			this.reset();
			// 使用 $nextTick 确保组件渲染完成后再设置银行账户类型和其他属性
			this.$nextTick(() => {
				// 先保存 companyName，避免 watch 监听器清空它
				const savedCompanyName = paymentData.companyName;
				const savedCompanyId = paymentData.companyId;
				// 保留表单结构，特别是 params.attachmentIds 和 params.bankacceptance
				Object.assign(this.form, {
					...paymentData,
					params: {
						...paymentData.params,
						attachmentIds: paymentData.attachmentList ? paymentData.attachmentList.map(item => item.id) : [],
						bankacceptance: paymentData.params?.bankacceptance || null
					}
				});
				// 如果 companyType 发生了变化，watch 可能已经清空了 companyName，需要恢复
				// 使用 $nextTick 确保 watch 执行完毕后再恢复值
				this.$nextTick(() => {
					// 确保 companyName 和 companyId 被正确赋值（包括 0 值）
					// 使用 hasOwnProperty 或 in 操作符检查属性是否存在，而不是判断值是否为 falsy
					if (paymentData.hasOwnProperty('companyName')) {
						this.form.companyName = savedCompanyName;
					}
					if (paymentData.hasOwnProperty('companyId')) {
						this.form.companyId = savedCompanyId;
					}
				});
				// 处理银行账户类型
				let flag = false;
				if (!paymentData.bankacceptanceId) {
					this.$message.warning('该付款信息无凭证相关信息');
					flag = true;
					this.form.params.bankacceptance = null;
				}
				this.open = true;
				this.title = '修改付款信息';
				console.log(`paymentData.bankacceptanceId`, paymentData.bankacceptanceId);
				// 使用额外的 $nextTick 确保 BankType 组件已经挂载并注册了事件监听器
				this.$nextTick(() => {
					this.$bus.$emit('changeFlag', paymentData.bankacceptanceId > 0 ? paymentData.bankacceptanceId : false);
				});
				if (!flag) {
					if (this.$refs[`selfSelectedBankType`] && paymentData.selfBankCardType) {
						this.$refs.selfSelectedBankType.localSelectType = paymentData.selfBankCardType;
					}
					if (this.$refs[`otherSelectedBankType`] && paymentData.otherBankCardType) {
						this.$refs.otherSelectedBankType.localSelectType = paymentData.otherBankCardType;
					}
					if (paymentData.bankacceptanceId) {
						getBankAcceptance(paymentData.bankacceptanceId).then(result => {
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
				if (this.form.payType) {
					this.form.payType = this.searchSubjectFromMap(this.form.payType);
				}
			});
		},
		// 付款的操作
		handlePaymentRow(row) {
			// 如果没有我方银行卡信息 需要跳出选择银行卡信息
			if (!row.selfBankID) {
				this.resetChooseInfo();
				Object.assign(this.chooseInfo, _.cloneDeep(row));
				this.chooseBankDialogVisible = true;
				return;
			}
			this.$antdconfirm({
				title: '提示',
				content: '是否付款?',
				okText: '是',
				cancelText: '否',
				type: 'success',
				zIndex: 2600,
				onOk: async () => {
					try {
						const res = await updatePayment({ ...row, paymentState: PAYMENT_STATE.PAID });
						this.$message.success(res.msg || '付款成功');
						this.reset();
						this.getList();
						// TODO: 付款没有修改，承兑的逻辑没有从收款信息迁移过来
					} catch {
						this.$message.error('付款失败，请重试');
					}
				},
				onCancel: () => {
					this.$message.info('已取消付款操作');
				}
			});
		},
		// 付款处理 用户在弹出的弹窗点击确定
		handlePayment() {
			// 先去除无用参数
			this.chooseInfo = excludeParams(this.chooseInfo, this.$exclude);
			// 对auditState做保证处理
			this.chooseInfo.auditState = this.chooseInfo.auditState === null ? '0' : this.chooseInfo.auditState === true ? '1' : '0';
			// 更新付款状态
			const newPayment = { ...this.chooseInfo, paymentState: PAYMENT_STATE.PAID };
			updatePayment(newPayment).then(res => {
				this.$modal.msgSuccess(res.msg);
				// 重置弹出窗的付款信息 主要包含我方银行卡的信息
				this.resetChooseInfo();
				this.reset();
				this.chooseBankDialogVisible = false;
				this.getList();
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 校验收款类型 和银行卡类型
					if (!this.form.payType) {
						this.$message.warning('请选择付款类型');
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
						const editReason = sessionStorage.getItem('editReason_payment');
						if (editReason) {
							submitData.editReason = editReason;
						}
					}

					// 对提交数据进行处理，不影响页面显示
					submitData = excludeParams(submitData, this.$exclude);

					// 对结果进行特殊处理 - 只处理提交数据
					if (typeof submitData.payType === 'string') {
						this.$message.warning('请选择付款类型');
						return;
					}

					// 将数组格式转换为字符串格式用于提交
					if (Array.isArray(submitData.payType)) {
						submitData.payType = submitData.payType.join('-');
					}

					if (submitData.id != null) {
						// submitData.editReason 已经在深克隆中包含了

						// 编辑操作，使用新的编辑接口
						const originalId = submitData.id;
						updatePaymentSimulate(submitData)
							.then(response => {
								this.$modal.msgSuccess('修改成功');
								// 清除sessionStorage中的修改原因
								sessionStorage.removeItem('editReason_payment');
								// 先部分重置表单，保留关键字段
								this.partialReset();
								this.open = false;
								this.showMask = false;
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
								// 清除附件上传状态
								if (this.$refs.attachmentUpload) {
									this.$refs.attachmentUpload.clearUploadedFiles();
								}
								// 清除银行卡流水附件上传状态
								if (this.$refs.transactionHistoryUpload) {
									this.$refs.transactionHistoryUpload.clearUploadedFiles();
								}
								// 由于返回了新的id，需要刷新列表并保持选中状态
								this.getList().then(() => {
									// 如果需要保持选中状态，可以根据返回的新id来处理
									if (response.data && response.data.id) {
										// 可以根据需要添加选中逻辑
									}
								});
							})
							.catch(error => {
								console.error('修改付款记录失败:', error);
								// 如果编辑失败，保持原有id
								this.form.id = originalId;
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

						// 新增操作 使用 form.companyType
						submitData.companyType = this.form.companyType;
						addPayment(submitData)
							.then(() => {
								this.$modal.msgSuccess('新增成功');
								this.$bus.$emit('changeFlag', false);
								// 先部分重置表单，保留关键字段
								this.partialReset();
								this.open = false;
								this.showMask = false;
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
								// 清除附件上传状态
								if (this.$refs.attachmentUpload) {
									this.$refs.attachmentUpload.clearUploadedFiles();
								}
								// 清除银行卡流水附件上传状态
								if (this.$refs.transactionHistoryUpload) {
									this.$refs.transactionHistoryUpload.clearUploadedFiles();
								}
								this.getList();
							})
							.catch(error => {
								console.error('新增付款记录失败:', error);
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
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除付款信息编号为"' + ids + '"的数据项？删除后只能通过重新发起付款申请恢复')
				.then(function () {
					return delPayment(ids);
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
				'system/payment/export',
				{
					...this.queryParams,
					payType: this.queryParams.payType?.join('-')
				},
				`payment_${new Date().getTime()}.xlsx`
			);
		},
		// 下载导入模板
		handleDownloadTemplate() {
			this.download('system/payment/importTemplate', {}, `付款导入模板_${parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`);
		},
		// 导入付款数据
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
				importPaymentData(formData)
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
		},
		// 查看运费信息相关方法
		// 打开查看运费信息弹窗
		handleViewFreightInfo(row) {
			// 从 tableReferences 中提取运费ID列表
			const freightIds = _.chain(row.tableReferences)
				.filter(ref => ref.refTableName === TableName.ORDER_FREIGHT && ref.refTableId)
				.map('refTableId')
				.value();

			if (_.isEmpty(freightIds)) {
				this.$message.warning('未找到关联的运费信息');
				return;
			}

			// 批量查询运费信息
			this.viewFreightList = [];
			this.viewFreightVisible = true;
			this.activeNames = []; // 重置展开项

			// 使用 Promise.all 并行查询所有运费信息
			Promise.all(_.map(freightIds, id => getOrderFreight(id)))
				.then(responses => {
					// 提取所有成功返回的运费数据
					this.viewFreightList = _.chain(responses)
						.map('data')
						.filter(data => data)
						.value();

					if (_.isEmpty(this.viewFreightList)) {
						this.$message.warning('未查询到运费信息');
						this.viewFreightVisible = false;
					} else {
						// 默认展开第一项
						this.$nextTick(() => {
							this.activeNames = ['0'];
						});
					}
				})
				.catch(error => {
					console.error('查询运费信息失败:', error);
					this.$message.error('查询运费信息失败');
					this.viewFreightVisible = false;
				});
		},
		// 关闭查看运费信息弹窗
		closeViewFreight() {
			this.viewFreightVisible = false;
			this.viewFreightList = [];
		}
	}
};
</script>
<style scoped lang="scss">
.w-85px {
	width: 85px;
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
						.el-tooltip,
						.el-switch {
							margin: 0;
						}

						&.fixed-left {
							position: sticky;
							z-index: 9;
							background: inherit;
							box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);
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
	margin-top: 20px;
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

/* 查看运费信息弹窗样式 */
.order-freight-body {
	display: grid;
	grid-template-columns: 1.1fr 0.9fr;
	gap: 16px;
	height: 68vh;
	min-height: 420px;
	overflow: hidden;
	padding-right: 4px;
}

.order-freight-info,
.order-freight-self-info {
	min-width: 0;
}

.order-freight-info {
	height: 100%;
	overflow: auto;
	padding-right: 4px;
}

.order-freight-self-info {
	height: 100%;
	display: flex;
	flex-direction: column;
	background: #fafafa;
	border-left: 1px solid #f0f0f0;
	padding: 16px 16px 0 16px;
}

.order-freight-self-info ::v-deep .el-form {
	height: 100%;
	display: flex;
	flex-direction: column;
	padding-right: 4px;
}

.order-freight-self-info ::v-deep .el-form-item {
	margin-bottom: 16px;
}

.order-freight-self-info ::v-deep .el-form-item__label {
	font-weight: 500;
	color: #606266;
}

.order-freight-self-info ::v-deep .el-input {
	width: 100%;
}

.order-freight-info ::v-deep .el-collapse {
	border: none;
}

.order-freight-info ::v-deep .el-collapse-item {
	margin-bottom: 12px;
	border: 1px solid #e4e7ed;
	border-radius: 6px;
	overflow: hidden;
}

.order-freight-info ::v-deep .el-collapse-item__header {
	padding: 12px 16px;
	font-size: 14px;
	font-weight: 500;
	background-color: #f5f7fa;
	color: #303133;
	border-bottom: 1px solid #e4e7ed;
}

.order-freight-info ::v-deep .el-collapse-item__header:hover {
	background-color: #ecf5ff;
}

.order-freight-info ::v-deep .el-collapse-item__wrap {
	border-bottom: none;
}

.order-freight-info ::v-deep .el-collapse-item__content {
	padding: 0;
}

.order-freight-info ::v-deep .el-card {
	border: none;
	box-shadow: none;
	margin: 0;
}

.order-freight-info ::v-deep .el-card__body {
	padding: 2px;
}

.order-freight-info ::v-deep .el-descriptions {
	background-color: #fff;
}

.order-freight-info ::v-deep .el-descriptions__title {
	font-size: 15px;
	font-weight: 600;
	color: #303133;
	margin-bottom: 12px;
}

.order-freight-info ::v-deep .el-descriptions__label {
	color: #606266;
	width: 100px;
	font-weight: 500;
}

.order-freight-info ::v-deep .el-descriptions__content {
	color: #303133;
}

.order-freight-info ::v-deep .el-tag.el-tag--mini {
	line-height: 20px;
	height: 20px;
	padding: 0 8px;
}

/* 运费总和展示区域 - 醒目样式 */
.total-freight-section {
	margin: 10px 0;
	padding: 5px;
	background: linear-gradient(135deg, #093b61 0%, #156fb2 100%);
	border-radius: 8px;
	box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
	text-align: center;
	color: #fff;
}

.total-freight-label {
	font-size: 14px;
	font-weight: 500;
	margin-bottom: 8px;
	opacity: 0.95;
	letter-spacing: 0.5px;
}

.total-freight-amount {
	font-size: 32px;
	font-weight: bold;
	line-height: 1.2;
	text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
	font-family: 'Arial', 'Microsoft YaHei', sans-serif;
}

/* 小屏幕降级为单列布局 */
@media (max-width: 1366px) {
	.order-freight-body {
		grid-template-columns: 1fr;
		height: 75vh;
	}

	.order-freight-self-info {
		border-left: none;
		border-top: 1px solid #f0f0f0;
		padding-top: 12px;
	}
}
</style>
