<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="交易时间">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" />
			</el-form-item>
			<el-form-item label="收入方" prop="targetCompanyName">
				<el-input v-model="queryParams.sourceCompanyName" placeholder="请输入收入方公司名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="支出方" prop="sourceCompanyName">
				<el-input v-model="queryParams.targetCompanyName" placeholder="请输入收入方公司名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="备注" prop="remarks">
				<el-input v-model="queryParams.remarks" placeholder="请输入备注" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="我方户名" prop="selfAccountName">
				<el-input v-model="querySelfAccountName" placeholder="请输入我方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="承兑号" prop="bankacceptanceBillNo">
				<el-input v-model="queryBankacceptanceBillNo" placeholder="请输入承兑号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:record:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:record:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
			</el-col>

			<right-toolbar :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:payment:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			:data="recordList"
			size="mini"
			border
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" />
			<el-table-column v-if="columns[1].visible" label="交易时间" align="center" prop="transactionTime" width="180">
				<template slot-scope="scope">
					<span>{{ parseTime(scope.row.transactionTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="金额" align="center" prop="amount" />
			<el-table-column v-if="columns[3].visible" label="收入方/资金流入方" align="center" prop="targetCompanyName" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="支出方/资金流出方" align="center" prop="sourceCompanyName" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="资金流入户名" align="center" prop="targetAccountName" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="资金流入账号" align="center" prop="targetBankNo" show-overflow-tooltip width="170" />
			<el-table-column v-if="columns[7].visible" label="资金流出户名" align="center" prop="sourceAccountName" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="资金流出账号" align="center" prop="sourceBankNo" show-overflow-tooltip width="170" />
			<el-table-column v-if="columns[9].visible" label="收入公司类型" align="center" prop="targetCompanyType" show-overflow-tooltip />
			<el-table-column v-if="columns[10].visible" label="收入方支付类型" align="center" prop="targetPaymentType" show-overflow-tooltip />
			<el-table-column v-if="columns[11].visible" label="支出方公司类型" align="center" prop="sourceCompanyType" show-overflow-tooltip />
			<el-table-column v-if="columns[12].visible" label="支出方支付类型" align="center" prop="sourcePaymentType" show-overflow-tooltip />
			<el-table-column v-if="columns[13].visible" label="收入方开户行" align="center" prop="targetBankName" show-overflow-tooltip />
			<!-- TODO 这地方后续需要更正 只是一个类型 用来标识冲抵类型 -->
			<el-table-column v-if="columns[14].visible" label="冲抵类型" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					<span>{{ scope.row.type === CASH_TYPE.CASH_RECORD ? '冲抵货款' : '内部转账' }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[15].visible" label="支出方开户行" align="center" prop="sourceBankName" show-overflow-tooltip />
			<el-table-column v-if="columns[16].visible" label="备注" align="center" prop="remarks" show-overflow-tooltip />
			<el-table-column v-if="columns[17].visible" label="账户类型" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					<div>
						{{ handleDisplayType(scope.row, scope.row.type) }}
					</div>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[18].visible" label="操作人员姓名" align="center" prop="userName" show-overflow-tooltip />
			<!-- 附件列 -->
			<el-table-column label="附件" align="center" prop="attachment">
				<template #default="scope">
					<div v-if="Array.isArray(scope.row.attachmentList)">
						<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'attachment'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getRecord, updateRecord)" />
					</div>
					<div v-else>
						<el-tag type="danger">加载错误</el-tag>
					</div>
				</template>
			</el-table-column>
			<!-- 操作列 -->
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
				<template slot-scope="scope">
					<el-dropdown @command="command => handleCommand(command, scope.row)">
						<el-button type="primary" size="mini">
							操作
							<i class="el-icon-arrow-down el-icon--right"></i>
						</el-button>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item v-hasPermi="['system:record:edit']" command="edit">修改</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:record:remove']" command="delete" divided>删除</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:tableeditmessage:list']" command="viewEditReason">查看修改原因</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 查看修改原因弹窗 -->
		<el-dialog title="查看修改原因" :visible.sync="editReasonDialogVisible" width="800px" append-to-body>
			<el-table :data="editReasonList" style="width: 100%">
				<el-table-column prop="addtime" label="修改时间" />
				<el-table-column prop="reason" label="修改原因" />
				<el-table-column prop="userName" label="修改人" />
			</el-table>
			<pagination v-show="editReasonTotal > 0" :total="editReasonTotal" :page.sync="editReasonQueryParams.pageNum" :limit.sync="editReasonQueryParams.pageSize" @pagination="getEditReasonList" />
		</el-dialog>

		<!-- 添加现金记账对话框  cashType 用于分别管理冲抵类型 : 冲抵货款 或者 冲抵第三方开票-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="1000px" append-to-body @close="handleDialogClose">
			<el-form ref="form" :model="form" :rules="rules" label-width="150px">
				<!-- 冲抵类型选择 -->
				<el-form-item label="冲抵类型">
					<el-row>
						<!-- 2025-08-14 CASH_RECORD是指的冲抵货款，而不再是offsetting -->
						<el-radio v-model="cashType" :label="CASH_TYPE.CASH_RECORD">冲抵货款</el-radio>
						<el-radio v-model="cashType" :label="CASH_TYPE.TRANSFER">内部转账</el-radio>
					</el-row>
				</el-form-item>

				<!-- ============================== 冲抵货款相关内容 ============================== -->
				<template v-if="cashType === CASH_TYPE.CASH_RECORD">
					<!-- 现金记账编码（只读，仅编辑时展示） -->
					<el-row>
						<el-col :span="12">
							<el-form-item v-if="form && form.id != null" label="记账编码">
								<el-input v-model="form.code" disabled style="width: 100%" />
							</el-form-item>
						</el-col>
					</el-row>
					<el-row :gutter="20">
						<!-- 左侧：支出方信息 -->
						<el-col :span="12">
							<el-divider>
								<div>
									<el-icon class="el-icon-remove" />
									<span>支出方信息</span>
								</div>
							</el-divider>
							<el-form-item label="支出方类型" label-width="120px">
								<el-radio v-model="form.sourceCompanyType" label="客户">客户</el-radio>
								<el-radio v-model="form.sourceCompanyType" label="供应商">供应商</el-radio>
								<el-radio v-model="form.sourceCompanyType" label="司机">司机</el-radio>
							</el-form-item>
							<el-form-item label="支付类型" prop="sourcePaymentType" label-width="120px">
								<el-cascader
									v-model="form.sourcePaymentType"
									:options="paymentTypeTree"
									:props="props"
									@change="handleChange"
									placeholder="请选择支出方支付类型"
									style="width: 100%"
								></el-cascader>
							</el-form-item>
							<el-form-item label="支出方" label-width="120px">
								<el-row>
									<el-col :span="16">
										<el-input disabled v-model="sourceName" type="text" placeholder="请选择" style="width: 100%" />
									</el-col>
									<!--               如果是司机-->
									<el-col v-if="form.sourceCompanyType === '司机'" :span="8">
										<SearchOption
											:limit-info="{}"
											:get-data="listCars"
											query-info="driver"
											query-label="司机姓名"
											:query-name="querySourceDriver"
											@update:queryName="handleUpdateSourceDriver"
											@commitBack="handleCommitBackSourceDriver"
										>
											<template #table-columns>
												<el-table-column label="司机姓名" align="center" prop="driver" />
												<el-table-column label="司机电话" align="center" prop="tel" />
												<el-table-column label="账号类型" align="center" prop="acountsType" />
												<el-table-column label="运输类型" align="center" prop="carType" />
											</template>
										</SearchOption>
									</el-col>
									<el-col v-else-if="form.sourceCompanyType === '己方公司'" :span="8">
										<SearchOption
											:limit-info="{
												acountsType: form.sourceCompanyType
											}"
											:get-data="listBankAccount"
											query-info="acountsName"
											query-label="户名查找"
											:query-name="querySourceSelfAccount"
											@update:queryName="handleUpdateSourceSelfAccount"
											@commitBack="handleCommitBackSourceSelfAccount"
										>
											<template #table-columns>
												<el-table-column label="账户类型" align="center" prop="acountsType" />
												<el-table-column label="己方公司" align="center" prop="displayName" />
												<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
												<el-table-column label="账号(银行账号)" align="center" prop="bankNo" width="200" />
												<el-table-column label="开户行" align="center" prop="bankName" />
												<el-table-column label="公司名称" align="center" prop="companyName" />
											</template>
										</SearchOption>
									</el-col>
									<el-col v-else :span="8">
										<SearchOption
											:limit-info="{
												companyType: form.sourceCompanyType
											}"
											:get-data="listCompany"
											query-info="companyName"
											query-label="公司名称"
											:query-name="querySourceCompanyName"
											@update:queryName="handleUpdateSourceCompanyName"
											@commitBack="handleCommitBackSourceCompany"
										>
											<template #table-columns>
												<el-table-column label="公司名称" align="center" prop="companyName" />
												<el-table-column label="公司类型" align="center" prop="companyType" />
												<el-table-column label="老板姓名" align="center" prop="leader" />
												<el-table-column label="老板电话" align="center" prop="leaderTel" />
												<el-table-column label="区域" align="center" prop="region" />
												<el-table-column label="销售经理" align="center" prop="salesManager" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>
							<el-form-item label="户名" prop="sourceAccountName" label-width="120px">
								<el-row>
									<el-col :span="16">
										<el-input v-model="form.sourceAccountName" placeholder="请输入支出方户名" disabled style="width: 100%" />
									</el-col>
									<el-col :span="8">
										<SearchOption
											:limit-info="{
												acountsType: form.sourceCompanyType,
												companyId: form.sourceId
											}"
											:get-data="listBankAccount"
											query-info="acountsName"
											query-label="户名查找"
											:query-name="querySourceBankAccount"
											@update:queryName="handleUpdateQuerySourceBankAccount"
											@commitBack="handleCommitBackSourceBankAccount"
										>
											<template #table-columns>
												<el-table-column label="账户类型" align="center" prop="acountsType" />
												<el-table-column label="己方公司" align="center" prop="displayName" />
												<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
												<el-table-column label="账号(银行账号)" align="center" prop="bankNo" width="200" />
												<el-table-column label="开户行" align="center" prop="bankName" />
												<el-table-column label="公司名称" align="center" prop="companyName" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>

							<!-- 支出方账号 -->
							<el-form-item label="账号" prop="sourceBankNo" label-width="120px">
								<el-input v-model="form.sourceBankNo" placeholder="请输入支出方账号" disabled style="width: 100%" />
							</el-form-item>

							<!-- 支出方开户行 -->
							<el-form-item label="开户行" prop="sourceBankName" label-width="120px">
								<el-input v-model="form.sourceBankName" placeholder="请输入支出方开户行" disabled style="width: 100%" />
							</el-form-item>
						</el-col>

						<!-- 右侧：收入方信息 -->
						<el-col :span="12">
							<el-divider>
								<div>
									<el-icon class="el-icon-circle-plus" />
									<span>收入方信息</span>
								</div>
							</el-divider>

							<el-form-item label="收入方类型" label-width="120px">
								<el-radio v-model="form.targetCompanyType" label="客户">客户</el-radio>
								<el-radio v-model="form.targetCompanyType" label="供应商">供应商</el-radio>
								<el-radio v-model="form.targetCompanyType" label="司机">司机</el-radio>
							</el-form-item>

							<!-- 收入方支付类型 -->
							<el-form-item label="支付类型" prop="targetPaymentType" label-width="120px">
								<el-cascader
									v-model="form.targetPaymentType"
									:options="paymentTypeTree"
									:props="props"
									@change="handleChange"
									placeholder="请选择收入方支付类型"
									style="width: 100%"
								></el-cascader>
							</el-form-item>

							<el-form-item label="收入方" label-width="120px">
								<el-row>
									<el-col :span="16">
										<el-input disabled v-model="targetName" type="text" placeholder="请选择" style="width: 100%" />
									</el-col>

									<el-col v-if="form.targetCompanyType === PUBLIC_DICT_TYPE.DRIVER" :span="8">
										<SearchOption
											:limit-info="{}"
											:get-data="listCars"
											query-info="driver"
											query-label="司机姓名"
											:query-name="queryTargetDriver"
											@update:queryName="handleUpdateTargetDriver"
											@commitBack="handleCommitBackTargetDriver"
										>
											<template #table-columns>
												<el-table-column label="司机姓名" align="center" prop="driver" />
												<el-table-column label="司机电话" align="center" prop="tel" />
												<el-table-column label="运输类型" align="center" prop="carType" />
											</template>
										</SearchOption>
									</el-col>
									<!--              如果是己方公司 -->
									<el-col v-if="form.targetCompanyType === PUBLIC_DICT_TYPE.SELF_COMPANY" :span="8">
										<SearchOption
											:limit-info="{
												acountsType: form.targetCompanyType
											}"
											:get-data="listBankAccount"
											query-info="acountsName"
											query-label="户名查找"
											:query-name="queryTargetSelfAccount"
											@update:queryName="handleUpdateTargetSelfAccount"
											@commitBack="handleCommitBackTargetSelfAccount"
										>
											<template #table-columns>
												<el-table-column label="账户类型" align="center" prop="acountsType" />
												<el-table-column label="己方公司" align="center" prop="displayName" />
												<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
												<el-table-column label="账号(银行账号)" align="center" prop="bankNo" width="200" />
												<el-table-column label="开户行" align="center" prop="bankName" />
												<el-table-column label="公司名称" align="center" prop="companyName" />
											</template>
										</SearchOption>
									</el-col>
									<!--              如果是其他-->
									<el-col v-if="form.targetCompanyType !== '司机' && form.targetCompanyType !== '己方公司'" :span="8">
										<SearchOption
											:limit-info="{
												companyType: form.targetCompanyType
											}"
											:get-data="listCompany"
											query-info="companyName"
											query-label="公司名称"
											:query-name="queryTargetCompanyName"
											@update:queryName="handleUpdateTargetCompanyName"
											@commitBack="handleCommitBackTargetCompany"
										>
											<template #table-columns>
												<el-table-column label="公司名称" align="center" prop="companyName" />
												<el-table-column label="公司类型" align="center" prop="companyType" />
												<el-table-column label="老板姓名" align="center" prop="leader" />
												<el-table-column label="老板电话" align="center" prop="leaderTel" />
												<el-table-column label="区域" align="center" prop="region" />
												<el-table-column label="销售经理" align="center" prop="salesManager" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>

							<!-- 收入方户名 -->
							<el-form-item label="户名" prop="targetAccountName" label-width="120px">
								<el-row>
									<el-col :span="16">
										<el-input v-model="form.targetAccountName" placeholder="请输入收入方户名" disabled style="width: 100%" />
									</el-col>
									<el-col :span="8">
										<SearchOption
											:limit-info="{
												acountsType: form.targetCompanyType,
												companyId: form.targetId
											}"
											:get-data="listBankAccount"
											query-info="acountsName"
											query-label="户名查找"
											:query-name="queryTargetBankAccount"
											@update:queryName="handleUpdateQueryTargetBankAccount"
											@commitBack="handleCommitBackTargetBankAccount"
										>
											<template #table-columns>
												<el-table-column label="账户类型" align="center" prop="acountsType" />
												<el-table-column label="己方公司" align="center" prop="displayName" />
												<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
												<el-table-column label="账号(银行账号)" align="center" prop="bankNo" width="200" />
												<el-table-column label="开户行" align="center" prop="bankName" />
												<el-table-column label="公司名称" align="center" prop="companyName" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>

							<!-- 收入方账号 -->
							<el-form-item label="账号" prop="targetBankNo" label-width="170px">
								<el-input v-model="form.targetBankNo" placeholder="请输入收入方账号" disabled style="width: 100%" />
							</el-form-item>

							<!-- 收入方开户行 -->
							<el-form-item label="开户行" prop="targetBankName" label-width="170px">
								<el-input v-model="form.targetBankName" placeholder="请输入收入方开户行" disabled style="width: 100%" />
							</el-form-item>
						</el-col>
					</el-row>
				</template>

				<!-- ============================== 内部转账相关内容 ============================== -->
				<template v-if="cashType === CASH_TYPE.TRANSFER">
					<!-- 资金流出部分 -->
					<el-divider>
						<div>
							<el-icon class="el-icon-circle-plus" />
							<span>资金流出</span>
						</div>
					</el-divider>

					<!-- 资金流出方支付类型 -->
					<el-form-item label="资金流出方支付类型" prop="sourcePaymentType">
						<el-row>
							<el-col :span="24">
								<el-input v-model="sourcePaymentTypeDisplay" placeholder="内部往来支出" disabled style="width: 100%" />
							</el-col>
						</el-row>
					</el-form-item>

					<!-- 转账账户 -->
					<el-form-item label="转账账户">
						<el-row>
							<el-col :span="20">
								<el-input v-model="form.sourceBankNo" disabled placeholder="请选择转账账户" style="width: 100%"></el-input>
							</el-col>
							<el-col :span="4">
								<SearchOption
									:get-data="listBankAccount"
									:limit-info="{ acountsType: PUBLIC_DICT_TYPE.SELF_COMPANY }"
									query-info="acountsName"
									:query-name="querySourceBankNo"
									query-label="户名"
									@commitBack="
										value => {
											form.sourceBankNo = value.bankNo;
											sourceName = value.acountsName;
											form.sourceId = value.id;
											// 保存转账账户信息到store
											saveInternalTransferFormData({
												formId: `income-${form.id || 'new'}`,
												accountInfo: value,
												accountType: 'source',
												formData: form
											});
										}
									"
									@update:queryName="value => (querySourceBankNo = value)"
								>
									<template #table-columns>
										<el-table-column label="账户类型" align="center" prop="acountsType" width="200" />
										<el-table-column label="己方公司" align="center" prop="displayName" />
										<el-table-column label="开户名称" align="center" prop="acountsName" width="200" />
										<el-table-column label="银行账号" align="center" prop="bankNo" width="200" />
										<el-table-column label="开户行" align="center" prop="bankName" width="200" />
										<el-table-column label="公司名称" align="center" prop="companyName" width="200" />
										<el-table-column label="余额" align="center" prop="amount" width="200" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>

					<!-- 支出账户类型 -->
					<el-form-item label="支出账户类型">
						<BankType
							ref="selfSelectBankType"
							@updateSelectedType="changeSelfBankType"
							@updateBankAcceptance="handleSelfBankAcceptanceUpdate"
							:bill-type="PayType.TRANSFOR"
							:is-internal-transfer="cashType === CASH_TYPE.TRANSFER"
							:form-id="`income-${form.id || 'new'}`"
							:wait-for-both-selection="true"
							:component-role="'source'"
							style="width: 100%"
						/>
					</el-form-item>

					<el-form-item :label="source">
						<el-row>
							<el-col :span="24">
								<el-input disabled v-model="sourceName" placeholder="请选择" style="width: 100%" />
							</el-col>
						</el-row>
					</el-form-item>

					<!-- 资金流入部分 -->
					<el-divider>
						<div>
							<el-icon class="el-icon-remove" />
							<span>资金流入</span>
						</div>
					</el-divider>

					<!-- 资金流入方支付类型 -->
					<el-form-item label="资金流入方支付类型" prop="targetPaymentType">
						<el-row>
							<el-col :span="24">
								<el-input v-model="targetPaymentTypeDisplay" placeholder="内部往来收入" disabled style="width: 100%" />
							</el-col>
						</el-row>
					</el-form-item>

					<!-- 目标账户 -->
					<el-form-item label="目标账户">
						<el-row>
							<el-col :span="20">
								<el-input v-model="form.targetBankNo" disabled placeholder="请选择目标账户" style="width: 100%"></el-input>
							</el-col>
							<el-col :span="4">
								<SearchOption
									:get-data="listBankAccount"
									:limit-info="{ acountsType: PUBLIC_DICT_TYPE.SELF_COMPANY }"
									query-info="acountsName"
									:query-name="querySourceBankNo"
									query-label="户名"
									@commitBack="
										value => {
											form.targetBankNo = value.bankNo;
											targetName = value.acountsName;
											form.targetId = value.id;
											// 保存目标账户信息到store
											saveInternalTransferFormData({
												formId: `income-${form.id || 'new'}`,
												accountInfo: value,
												accountType: 'target',
												formData: form
											});
										}
									"
									@update:queryName="value => (querySourceBankNo = value)"
								>
									<template #table-columns>
										<el-table-column label="账户类型" align="center" prop="acountsType" width="200" />
										<el-table-column label="己方公司" align="center" prop="displayName" />
										<el-table-column label="开户名称" align="center" prop="acountsName" width="200" />
										<el-table-column label="银行账号" align="center" prop="bankNo" width="200" />
										<el-table-column label="开户行" align="center" prop="bankName" width="200" />
										<el-table-column label="公司名称" align="center" prop="companyName" width="200" />
										<el-table-column label="余额" align="center" prop="amount" width="200" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>

					<!-- 收入账户类型 -->
					<el-form-item label="收入账户类型">
						<BankType
							ref="otherSelectBankType"
							@updateSelectedType="changeOtherBankType"
							@updateBankAcceptance="handleOtherBankAcceptanceUpdate"
							:bill-type="PayType.TRANSFOR"
							:is-internal-transfer="cashType === CASH_TYPE.TRANSFER"
							:form-id="`expense-${form.id || 'new'}`"
							:wait-for-both-selection="true"
							:component-role="'target'"
							style="width: 100%"
						/>
					</el-form-item>

					<el-form-item :label="target">
						<el-row>
							<el-col :span="24">
								<el-input disabled v-model="targetName" placeholder="请选择" style="width: 100%" />
							</el-col>
						</el-row>
					</el-form-item>
				</template>

				<!-- ============================== 基本信息（公共部分） ============================== -->
				<el-divider>
					<el-icon class="el-icon-edit" />
					基本信息
				</el-divider>

				<!-- 金额 -->
				<el-form-item :label="cashType === CASH_TYPE.TRANSFER ? '转账金额' : '冲抵金额'" prop="amount">
					<el-row>
						<el-col :span="14">
							<el-input v-model="form.amount" :placeholder="cashType === CASH_TYPE.TRANSFER ? '转账金额' : '冲抵金额'" type="number" style="width: 100%" />
						</el-col>
					</el-row>
				</el-form-item>

				<!-- 附件 -->
				<el-form-item label="附件" prop="attachment">
					<UploadFilesButton
						ref="attachmentUpload"
						flag="attachment"
						:initial-attachments="(form.params && form.params.attachments) || []"
						:extra-info="{ moduleType: 'record', formId: form.id }"
						@files-updated="handleAttachmentFilesUpdated"
						style="width: 100%"
					/>
				</el-form-item>

				<!-- 交易时间 -->
				<el-form-item label="交易时间" prop="transactionTime">
					<el-date-picker v-model="form.transactionTime" clearable type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择交易时间" style="width: 100%" />
				</el-form-item>

				<!-- 备注 -->
				<el-form-item label="备注" prop="remarks">
					<el-input v-model="form.remarks" placeholder="请输入备注" style="width: 100%" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    查看附件列表的组件-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="查看附件"
			:visible.sync="checkAttachmentVisible"
			width="48%"
		>
			<el-row v-for="(item, index) in checkFileList" :key="index">
				<el-button type="text" icon="el-icon-document" @click="checkFileItem(item)">
					{{ item }}
				</el-button>
			</el-row>
			<el-button @click="checkAttachmentVisible = false">关 闭</el-button>
		</el-dialog>
	</div>
</template>

<script>
import { listCars } from '@/api/system/cars';
import { addRecord, delRecord, listRecord } from '@/api/system/record';
import { listTableEditMessage } from '@/api/system/tableEditMessage';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import { mixin_bankType } from '@/views/dashboard/mixins/common/common_bankType';
import { listBankAccount, getBankAccount } from '../../../api/system/bankAccount';
import { listCompany } from '../../../api/system/company';
import { getRecord, updateRecord } from '../../../api/system/record';
import { BankAcceptanceType, PayType, TableName } from '../../../api/tool/enums';
import { excludeParams } from '../../../api/tool/exclude';
import CheckFiles from '../../../components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import SearchOption from '../../../components/SearchOption.vue';
import { PUBLIC_DICT_TYPE } from '../../../utils/order';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { mixin_record_uploadFiles } from '../../dashboard/mixins/record/record_upload';
import { mixin_payment_subject } from '../../dashboard/mixins/payment/payment_subject';
import { CASH_TYPE } from './constrant';
import { mixin_record_fill } from './recordFill';
import { mixin_record_auto_save } from './record_auto_save';
import { mapActions, mapGetters } from 'vuex';
export default {
	name: 'Record',
	components: { BankType, CheckFiles, UploadFilesButton, SearchOption },
	mixins: [
		// 公共打印混入
		mixin_printHTML,
		// 填充相关混入
		mixin_record_fill,
		// 上传文件相关
		mixin_record_uploadFiles,
		// 通用文件上传下载混入
		mixin_checkfile,
		// 通用银行卡类型选择混入
		mixin_bankType,
		// 支付类型选择混入
		mixin_payment_subject,
		// 内部转账表单自动保存混入
		mixin_record_auto_save
	],
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
			// 现金记账表格数据
			recordList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 删除标记时间范围
			dateRange: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				transactionTime: null,
				supplierId: null,
				customerId: null,
				amount: null,
				referenceTableId: null,
				type: null,
				attachment: null,
				remarks: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				sourceCompanyName: null,
				targetCompanyName: null
			},
			// 表单参数
			form: {},
			columns: [
				{ key: 0, label: 'ID', prop: 'id', visible: true },
				{ key: 1, label: '交易时间', prop: 'transactionTime', visible: true },
				{ key: 2, label: '金额', prop: 'amount', visible: true },
				{ key: 3, label: '收入方/资金流入方', prop: 'targetCompanyName', visible: true },
				{ key: 4, label: '支出方/资金流出方', prop: 'sourceCompanyName', visible: true },
				{ key: 5, label: '资金流入户名', prop: 'targetAccountName', visible: true },
				{ key: 6, label: '资金流入账号', prop: 'targetBankNo', visible: true },
				{ key: 7, label: '资金流出户名', prop: 'sourceAccountName', visible: true },
				{ key: 8, label: '资金流出账号', prop: 'sourceBankNo', visible: true },
				{ key: 9, label: '收入公司类型', prop: 'targetCompanyType', visible: true },
				{ key: 10, label: '收入方支付类型', prop: 'targetPaymentType', visible: true },
				{ key: 11, label: '支出方公司类型', prop: 'sourceCompanyType', visible: true },
				{ key: 12, label: '支出方支付类型', prop: 'sourcePaymentType', visible: true },
				{ key: 13, label: '收入方开户行', prop: 'targetBankName', visible: true },
				{ key: 14, label: '冲抵类型', prop: 'type', visible: true },
				{ key: 15, label: '支出方开户行', prop: 'sourceBankName', visible: true },
				{ key: 16, label: '备注', prop: 'remarks', visible: true },
				{ key: 17, label: '账户类型', prop: 'accountType', visible: true },
				{ key: 18, label: '操作人员姓名', prop: 'userName', visible: true }
			],
			// 表单校验
			rules: {
				transactionTime: [
					{
						required: true,
						message: '交易时间不能为空',
						trigger: 'blur'
					}
				],
				supplierId: [
					{
						required: true,
						message: '供应商id(或者说来源方)不能为空',
						trigger: 'blur'
					}
				],
				customerId: [
					{
						required: true,
						message: '客户id(或者说目的地)不能为空',
						trigger: 'blur'
					}
				],
				amount: [{ required: true, message: '金额不能为空', trigger: 'blur' }],
				referenceTableId: [
					{
						required: true,
						message: '对应表id不能为空',
						trigger: 'blur'
					}
				],
				type: [
					{
						required: true,
						message: '对应表名不能为空',
						trigger: 'blur'
					}
				]
			},
			// 冲抵类型 默认为冲抵货款
			cashType: CASH_TYPE.CASH_RECORD,
			// 新增的字段
			querySourceBankNo: null,
			// 新增银行账户查询变量
			querySourceBankAccount: null,
			queryTargetBankAccount: null,
			// 司机查询变量 - 分别为支出方和收入方
			querySourceDriver: null,
			queryTargetDriver: null,
			// 公司查询变量 - 分别为支出方和收入方
			querySourceCompanyName: null,
			queryTargetCompanyName: null,
			// 己方公司查询变量 - 分别为支出方和收入方
			querySourceSelfAccount: null,
			queryTargetSelfAccount: null,
			// 内部转账支付类型显示字段
			sourcePaymentTypeDisplay: '内部往来支出',
			targetPaymentTypeDisplay: '内部往来收入',
			// 查看修改原因相关
			editReasonDialogVisible: false,
			editReasonList: [],
			editReasonTotal: 0,
			editReasonQueryParams: {
				pageNum: 1,
				pageSize: 20,
				tableName: TableName.RECORD,
				tid: null
			},
			// 查询相关变量
			querySelfAccountName: null,
			queryBankacceptanceBillNo: null
		};
	},
	// 计算属性
	computed: {
		PayType() {
			return PayType;
		},
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		CASH_TYPE() {
			return CASH_TYPE;
		},

		// Vuex getters 映射 - 获取保存的内部转账表单信息
		...mapGetters('bankAcceptance', ['internalTransferFormData', 'sourceAccountInfo', 'targetAccountInfo', 'savedFormData', 'hasSavedInternalTransferData', 'hasAcceptanceSelection']),

		/**
		 * 显示的去
		 * 冲抵货款的时候就是收入方金额
		 * 内部转账的时候显示目标账号 并且要显示填充搜索按钮
		 */
		target() {
			// 如果是冲抵货款 那么就是用货款来去冲抵金额
			if (this.cashType === CASH_TYPE.CASH_RECORD) {
				return '支出方金额';
			}
			if (this.cashType === CASH_TYPE.TRANSFER) {
				return '目标账号';
			}
			return '支出';
		},
		/**
		 * 显示的源
		 * 冲抵货款的时候就是支出方金额
		 * 内部转账的时候显示转账账号 并且要显示填充搜索按钮
		 */
		source() {
			if (this.cashType === CASH_TYPE.CASH_RECORD) {
				return '收入方金额';
			}
			if (this.cashType === CASH_TYPE.TRANSFER) {
				return '转账账号';
			}

			return '收入';
		}
	},
	watch: {
		cashType: {
			/**
			 * 只要冲抵类型改变那么就是要重新赋值表单
			 * @param val
			 */
			handler() {
				this.reset();
			},
			immediate: true
		}
	},
	created() {
		this.getList();
		// 清除保存的内部转账表单数据
		this.clearSavedInternalTransferForm();
	},
	beforeDestroy() {
		// 顶层生命周期清理（原 methods 内实现迁移到此）
		this.clearAcceptanceFillStatus();
		if (this.$refs.otherSelectBankType && this.$refs.otherSelectBankType.forceClearAcceptanceInfo) {
			this.$refs.otherSelectBankType.forceClearAcceptanceInfo();
		}
		if (this.$refs.selfSelectBankType && this.$refs.selfSelectBankType.forceClearAcceptanceInfo) {
			this.$refs.selfSelectBankType.forceClearAcceptanceInfo();
		}
		this.$bus.$emit('changeFlag', false);
		if (this.$refs.otherSelectBankType && this.$refs.otherSelectBankType.resetComponentState) {
			this.$refs.otherSelectBankType.resetComponentState();
		}
		if (this.$refs.selfSelectBankType && this.$refs.selfSelectBankType.resetComponentState) {
			this.$refs.selfSelectBankType.resetComponentState();
		}
		if (this.cashType === this.CASH_TYPE.TRANSFER) {
			const formId = `internal-transfer-${this.form.id || Date.now()}`;
			this.$store.dispatch('bankAcceptance/resetDualSelection', formId);
		}
		sessionStorage.removeItem('bankAcceptanceFilled');
	},
	methods: {
		listCars,
		listBankAccount,
		getBankAccount,
		listCompany,
		parseTime,
		updateRecord,
		getRecord,
		...mapActions('bankAcceptance', ['setAccountTypeSelection', 'resetDualSelection', 'clearRoleSelection', 'saveInternalTransferFormData', 'clearInternalTransferFormData']),
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
		// 处理附件文件更新
		handleAttachmentFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				this.form.params.attachmentIds = uploadParams.params.attachmentIds;
			}
		},
		// 收入方银行账户查询相关函数
		handleUpdateQuerySourceBankAccount(value) {
			this.querySourceBankAccount = value;
		},
		handleCommitBackSourceBankAccount(value) {
			this.form.sourceAccountName = value.acountsName;
			this.form.sourceBankNo = value.bankNo;
			this.form.sourceBankName = value.bankName;
		},
		// 支出方银行账户查询相关函数
		handleUpdateQueryTargetBankAccount(value) {
			this.queryTargetBankAccount = value;
		},
		handleCommitBackTargetBankAccount(value) {
			this.form.targetAccountName = value.acountsName;
			this.form.targetBankNo = value.bankNo;
			this.form.targetBankName = value.bankName;
		},
		// 支出方司机查询相关函数
		handleUpdateSourceDriver(value) {
			this.querySourceDriver = value;
		},
		handleCommitBackSourceDriver(value) {
			this.sourceName = value.driver;
			this.form.sourceId = value.id;
		},
		// 收入方司机查询相关函数
		handleUpdateTargetDriver(value) {
			this.queryTargetDriver = value;
		},
		handleCommitBackTargetDriver(value) {
			this.targetName = value.driver;
			this.form.targetId = value.id;
		},
		// 支出方公司查询相关函数
		handleUpdateSourceCompanyName(value) {
			this.querySourceCompanyName = value;
		},
		handleCommitBackSourceCompany(value) {
			this.sourceName = value.companyName;
			this.form.sourceId = value.id;
		},
		// 收入方公司查询相关函数
		handleUpdateTargetCompanyName(value) {
			this.queryTargetCompanyName = value;
		},
		handleCommitBackTargetCompany(value) {
			this.targetName = value.companyName;
			this.form.targetId = value.id;
		},
		// 支出方己方公司查询相关函数
		handleUpdateSourceSelfAccount(value) {
			this.querySourceSelfAccount = value;
		},
		handleCommitBackSourceSelfAccount(value) {
			this.sourceName = value.acountsName;
			this.form.sourceId = value.id;
		},
		// 收入方己方公司查询相关函数
		handleUpdateTargetSelfAccount(value) {
			this.queryTargetSelfAccount = value;
		},
		handleCommitBackTargetSelfAccount(value) {
			this.targetName = value.acountsName;
			this.form.targetId = value.id;
		},
		//type为 transfor的时候才进行判断,显示为银行活期存款,如果不为空 那么就是承兑类型
		handleDisplayType(row, type) {
			if (type === CASH_TYPE.TRANSFER) {
				if (row.selfBankCardType !== row.otherBankCardType) {
					return '银承互转';
				}
				if (row.selfBankCardType === BankAcceptanceType.ACCEPTANCE) return '承兑';
				if (row.selfBankCardType === BankAcceptanceType.BANK_CASH) return '银行活期存款';
			}
			return '-';
		},
		// 处理收入方银行账户类型的承兑信息更新
		handleSelfBankAcceptanceUpdate(value) {
			this.form.params.bankacceptance = value;
			this.maintainInternalTransferPaymentTypes();

			// 如果是内部转账且有承兑信息，执行反向填充
			if (this.cashType === this.CASH_TYPE.TRANSFER && value) {
				this.handleBankAcceptanceUpdate(value, 'source');
			}
		},
		// 处理支出方银行账户类型的承兑信息更新
		handleOtherBankAcceptanceUpdate(value) {
			this.form.params.bankacceptance = value;
			this.maintainInternalTransferPaymentTypes();

			// 如果是内部转账且有承兑信息，执行反向填充
			if (this.cashType === this.CASH_TYPE.TRANSFER && value) {
				this.handleBankAcceptanceUpdate(value, 'target');
			}
		},
		// 处理承兑信息更新（包含反向填充逻辑）
		handleBankAcceptanceUpdate(acceptanceData, componentRole) {
			// 如果不是内部转账或没有承兑信息，则跳过反向填充
			if (this.cashType !== this.CASH_TYPE.TRANSFER || !acceptanceData || !acceptanceData.endorserName || !acceptanceData.billAccount) {
				return;
			}
			// 获取当前账户类型
			const sourceType = this.form.selfBankCardType; // 支出方账户类型
			const targetType = this.form.otherBankCardType; // 收入方账户类型
			// 如果账户类型还没选择完毕，则跳过
			if (!sourceType || !targetType) {
				return;
			}

			const BankCash = BankAcceptanceType.BANK_CASH;
			const Acceptance = BankAcceptanceType.ACCEPTANCE;

			// 调试日志移除

			// 根据场景判断如何反向填充
			if (sourceType === BankCash && targetType === Acceptance) {
				// ①A账户现金到A账户承兑
				// 承兑表单中: 背书人=A账户, 我方承兑账户=A账户
				// 反向填充: 支出方账户=背书人, 收入方账户=我方承兑账户
				this.fillAccountInfo(acceptanceData.endorser, 'source', acceptanceData.endorserName);
				this.fillAccountInfo(acceptanceData.billAccountId, 'target', acceptanceData.billAccount);
			} else if (sourceType === Acceptance && targetType === BankCash) {
				// ②B账户承兑到B账户现金
				// 承兑表单中: 被背书人=B账户, 我方承兑账户=B账户
				// 反向填充: 支出方账户=我方承兑账户, 收入方账户=被背书人
				this.fillAccountInfo(acceptanceData.billAccountId, 'source', acceptanceData.billAccount);
				this.fillAccountInfo(acceptanceData.endorser, 'target', acceptanceData.endorserName);
			} else if (sourceType === Acceptance && targetType === Acceptance) {
				// ③C账户承兑到D账户承兑
				// 承兑表单中: 被背书人=D账户, 我方承兑账户=C账户
				// 反向填充: 支出方账户=我方承兑账户, 收入方账户=被背书人
				this.fillAccountInfo(acceptanceData.billAccountId, 'source', acceptanceData.billAccount);
				this.fillAccountInfo(acceptanceData.endorser, 'target', acceptanceData.endorserName);
			}

			// 调试日志移除
		},

		// 根据账户ID获取银行卡信息并填充
		async fillAccountInfo(accountId, accountType, accountName) {
			if (!accountId) {
				console.warn('账户ID为空，跳过填充');
				return;
			}

			try {
				const response = await getBankAccount(accountId);
				if (response.data) {
					const bankInfo = response.data;

					if (accountType === 'source') {
						// 填充支出方/转账账户信息
						this.form.sourceBankNo = bankInfo.bankNo;
						this.form.sourceName = accountName || bankInfo.acountsName;
						this.form.sourceId = bankInfo.id;

						// 更新显示变量
						this.sourceName = this.form.sourceName;

						// 调试日志移除
					} else if (accountType === 'target') {
						// 填充收入方/目标账户信息
						this.form.targetBankNo = bankInfo.bankNo;
						this.form.targetName = accountName || bankInfo.acountsName;
						this.form.targetId = bankInfo.id;

						// 更新显示变量
						this.targetName = this.form.targetName;

						// 调试日志移除
					}
				}
			} catch (error) {
				console.error(`获取账户信息失败 (ID: ${accountId}):`, error);
			}
		},
		// 补充统一清理保存的内部转账表单数据，防止方法缺失报错
		clearSavedInternalTransferForm() {
			const incomeKey = `income-${this.form?.id || 'new'}`;
			try {
				this.clearInternalTransferFormData && this.clearInternalTransferFormData(incomeKey);
			} catch (err) {
				if (process.env.NODE_ENV !== 'production') {
					console.warn('clearSavedInternalTransferForm 调用异常:', err);
				}
			}
		},
		// 处理收入方银行类型变化
		changeSelfBankType(value) {
			this.form.selfBankCardType = value;
			this.maintainInternalTransferPaymentTypes();
		},
		// 处理支出方银行类型变化
		changeOtherBankType(value) {
			this.form.otherBankCardType = value;
			this.maintainInternalTransferPaymentTypes();
		},
		// 维护内部转账的支付类型
		maintainInternalTransferPaymentTypes() {
			if (this.cashType === CASH_TYPE.TRANSFER) {
				this.$nextTick(() => {
					if (!this.form.sourcePaymentType || this.form.sourcePaymentType === null) {
						this.form.sourcePaymentType = '内部往来支出';
					}
					if (!this.form.targetPaymentType || this.form.targetPaymentType === null) {
						this.form.targetPaymentType = '内部往来收入';
					}
				});
			}
		},
		/** 查询现金记账列表 */
		getList() {
			this.loading = true;
			this.queryParams.params = {};
			if (this.dateRange != null && this.dateRange !== '') {
				this.queryParams.params['beginTransactionTime'] = this.dateRange[0];
				this.queryParams.params['endTransactionTime'] = this.dateRange[1];
			}
			// 添加我方户名搜索参数
			if (this.querySelfAccountName) {
				this.queryParams.params['selfAccountName'] = this.querySelfAccountName;
			}
			// 添加承兑号搜索参数
			if (this.queryBankacceptanceBillNo) {
				this.queryParams.params['bankacceptanceBillNo'] = this.queryBankacceptanceBillNo;
			}
			listRecord(this.queryParams).then(response => {
				this.recordList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
			// 清理 UploadFilesButton 组件状态
			if (this.$refs.attachmentUpload) {
				this.$refs.attachmentUpload.clearUploadedFiles();
			}
			this.clearAcceptanceFillStatus();
			// 这里使用手动清空方法，因为用户主动取消意味着放弃当前操作
			if (this.$refs.otherSelectBankType && this.$refs.otherSelectBankType.forceClearAcceptanceInfo) {
				this.$refs.otherSelectBankType.forceClearAcceptanceInfo();
			}
			if (this.$refs.selfSelectBankType && this.$refs.selfSelectBankType.forceClearAcceptanceInfo) {
				this.$refs.selfSelectBankType.forceClearAcceptanceInfo();
			}
			// 清除内部转账表单信息
			const formId = `income-${this.form.id || 'new'}`;
			this.clearInternalTransferFormData(formId);
			this.$bus.$emit('changeFlag', false);
			// **优化的状态重置：使用组件的重置方法**
			if (this.$refs.otherSelectBankType && this.$refs.otherSelectBankType.resetComponentState) {
				this.$refs.otherSelectBankType.resetComponentState();
			}
			if (this.$refs.selfSelectBankType && this.$refs.selfSelectBankType.resetComponentState) {
				this.$refs.selfSelectBankType.resetComponentState();
			}
			if (this.cashType === this.CASH_TYPE.TRANSFER) {
				// 使用唯一的formId确保状态隔离
				const formId = `internal-transfer-${this.form.id || Date.now()}`;
				this.$store.dispatch('bankAcceptance/resetDualSelection', formId);
			}
			sessionStorage.removeItem('bankAcceptanceFilled');
			this.clearSavedInternalTransferForm();
		},
		// 表单重置
		reset() {
			// 保存当前的 cashType，因为重置后需要根据它来设置支付类型
			const currentCashType = this.cashType;

			this.form = {
				id: null,
				code: null,
				transactionTime: parseTime(new Date()),
				sourceId: null,
				targetId: null,
				amount: null,
				referenceTableId: null,
				type: null,
				remarks: null,
				// 收入方与支付方的公司类型
				sourceCompanyType: '客户',
				targetCompanyType: '客户',
				// 收入方与支付方的银行卡账户类型
				selfBankCardType: null,
				otherBankCardType: null,
				// 2025-2-28 新增转账账户
				sourceBankNo: null,
				// 支出方额外字段 - 用于冲抵货款时的支付详细信息
				targetBankNo: null,
				// 收入方支付详细信息
				sourcePaymentType: currentCashType === CASH_TYPE.TRANSFER ? '内部往来支出' : null,
				sourceAccountName: null,
				sourceBankName: null,
				// 支出方支付详细信息
				targetPaymentType: currentCashType === CASH_TYPE.TRANSFER ? '内部往来收入' : null,
				targetAccountName: null,
				targetBankName: null,
				params: {
					bankacceptance: null,
					attachmentIds: []
				}
			};
			// 把展示字段给赋值为null
			this.sourceName = null;
			this.targetName = null;
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.dateRange = [];
			this.querySelfAccountName = null;
			this.queryBankacceptanceBillNo = null;
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
			this.clearAcceptanceFillStatus(); // 清理所有承兑相关状态
			this.open = true;
			this.title = '添加冲抵款';
		},
		// 修改操作
		handleUpdate(row) {
			// 先获取记录详情，判断是否需要填写修改原因
			getRecord(row.id || this.ids)
				.then(response => {
					const recordData = response.data;
					// 判断是否需要填写修改原因
					if (recordData && recordData.shouldTrackEditReason === true) {
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
								sessionStorage.setItem('editReason_record', value);
								// 根据类型赋值
								this.reset();
								// 添加现金记账记录
								this.handleAddRecord(recordData);
							})
							.catch(() => {
								this.$message({
									type: 'info',
									message: '已取消修改'
								});
							});
					} else {
						// 不需要填写修改原因，直接进行修改操作
						this.reset();
						// 添加现金记账记录
						this.handleAddRecord(recordData);
					}
				})
				.catch(error => {
					console.error('获取记录详情失败:', error);
					this.$message.error('获取记录详情失败');
				});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (!valid) return;

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
				if (this.$refs.attachmentUpload) {
					const attachmentParams = this.$refs.attachmentUpload.getUploadParams();
					if (attachmentParams && attachmentParams.params) {
						this.form.params = { ...this.form.params, ...attachmentParams.params };
					}
				}

				// 处理收入方支付类型 - 将数组转换为以短横线分隔的字符串
				if (this.form.sourcePaymentType && Array.isArray(this.form.sourcePaymentType)) {
					this.form.sourcePaymentType = this.form.sourcePaymentType.join('-');
				}

				// 处理支出方支付类型 - 将数组转换为以短横线分隔的字符串
				if (this.form.targetPaymentType && Array.isArray(this.form.targetPaymentType)) {
					this.form.targetPaymentType = this.form.targetPaymentType.join('-');
				}

				// 确保银行账户类型从组件同步到form对象
				if (this.$refs.selfSelectBankType && this.$refs.selfSelectBankType.localSelectType !== null) {
					this.form.selfBankCardType = this.$refs.selfSelectBankType.localSelectType;
				}
				if (this.$refs.otherSelectBankType && this.$refs.otherSelectBankType.localSelectType !== null) {
					this.form.otherBankCardType = this.$refs.otherSelectBankType.localSelectType;
				}

				// **新增：内部转账时的承兑信息验证**
				if (this.cashType === this.CASH_TYPE.TRANSFER) {
					// 检查是否有任一方选择了承兑类型
					if (this.hasAcceptanceSelection) {
						// 如果有承兑选择，检查是否已填写承兑信息
						if (!this.form.params.bankacceptance || this.form.params.bankacceptance === null) {
							this.$message.error('请先填写承兑信息！');
							return;
						}
					}
				}

				// 提取公共逻辑
				this.form = excludeParams(this.form, this.$exclude);

				// 创建提交数据的副本
				const submitData = { ...this.form };

				// 判断是修改还是新增
				if (this.form.id != null) {
					// 如果是修改操作，添加修改原因
					const editReason = sessionStorage.getItem('editReason_record');
					if (editReason) {
						submitData.editReason = editReason;
					}
					this.updateRecordInfo(originalAttachmentIds, submitData);
					// 只在成功时发送 changeFlag 事件，错误时在各自的 catch 块中处理
				} else {
					// 新增时，移除修改原因字段
					delete submitData.editReason;
					this.addRecordInfo(originalAttachmentIds, submitData);
					// 只在成功时发送 changeFlag 事件，错误时在各自的 catch 块中处理
				}
			});
		},

		// 修改记录
		updateRecordInfo(originalAttachmentIds, submitData = null) {
			const dataToUpdate = submitData || this.form;
			updateRecord(dataToUpdate)
				.then(() => {
					// 清理修改原因的sessionStorage
					sessionStorage.removeItem('editReason_record');
					// 只在成功时清空票据信息状态
					this.$bus.$emit('changeFlag', false);
					this.clearSavedInternalTransferForm();
					this.onSuccess('修改成功');
				})
				.catch(error => {
					console.error('修改记录失败:', error);
					// 回滚附件ID到原始状态
					this.$store.commit('CLEAR_ATTACHMENT_IDS');
					originalAttachmentIds.forEach(id => {
						this.$store.commit('ADD_ATTACHMENT_ID', id);
					});
					// **关键修复：错误时不清空票据信息，保留用户已填写的承兑信息**
					this.$message.error('修改失败，请重试');
				});
		},

		// 新增记录
		addRecordInfo(originalAttachmentIds, submitData = null) {
			const dataToAdd = submitData || this.form;
			if (this.cashType === CASH_TYPE.CASH_RECORD) {
				this.handleOffsetting(originalAttachmentIds, dataToAdd);
			} else {
				this.handleTransfer(originalAttachmentIds, dataToAdd);
			}
		},

		// 处理冲抵货款逻辑
		handleOffsetting(originalAttachmentIds, dataToAdd = null) {
			const formData = dataToAdd || this.form;
			formData.type = TableName.CASH_RECORD;
			formData.referenceTableId = 0;
			addRecord(formData)
				.then(() => {
					// 只在成功时清空票据信息状态
					this.$bus.$emit('changeFlag', false);
					this.onSuccess('新增成功', true);
				})
				.catch(error => {
					// 回滚附件ID到原始状态
					this.$store.commit('CLEAR_ATTACHMENT_IDS');
					originalAttachmentIds.forEach(id => {
						this.$store.commit('ADD_ATTACHMENT_ID', id);
					});
					// **关键修复：错误时不清空票据信息，保留用户已填写的承兑信息**
					this.$message.error('新增失败，请重试');
				});
		},

		// 处理内部转账逻辑
		handleTransfer(originalAttachmentIds, dataToAdd = null) {
			const formData = dataToAdd || this.form;

			// 确保从组件获取最新的银行账户类型
			const selfType = this.$refs.selfSelectBankType?.localSelectType || formData.selfBankCardType;
			const otherType = this.$refs.otherSelectBankType?.localSelectType || formData.otherBankCardType;

			// 更新formData中的银行账户类型
			formData.selfBankCardType = selfType;
			formData.otherBankCardType = otherType;

			if (selfType !== otherType) {
				// 确保 bankacceptance 对象存在
				if (!formData.params.bankacceptance) {
					formData.params.bankacceptance = {};
				}
				if (selfType === BankAcceptanceType.ACCEPTANCE) {
					formData.params.bankacceptance.billType = PayType.PAYMENT;
				}
				if (otherType === BankAcceptanceType.ACCEPTANCE) {
					formData.params.bankacceptance.billType = PayType.RECEIVE;
				}
			}
			// 填充表单的公司类型和转账相关信息
			formData.sourceCompanyType = PUBLIC_DICT_TYPE.SELF_COMPANY;
			formData.targetCompanyType = PUBLIC_DICT_TYPE.SELF_COMPANY;
			// 填充转账类型表
			formData.type = CASH_TYPE.TRANSFER;
			formData.referenceTableId = 0;
			addRecord(formData)
				.then(() => {
					// 只在成功时清空票据信息状态和重置组件状态
					this.$bus.$emit('changeFlag', false);
					this.onSuccess('新增成功', true, true);
					// 清除承兑信息状态
					this.clearAcceptanceFillStatus();
					this.clearSavedInternalTransferForm();
					this.$refs.selfSelectBankType.localSelectType = null;
					this.$refs.otherSelectBankType.localSelectType = null;
				})
				.catch(error => {
					console.error('新增转账记录失败:', error);
					// 回滚附件ID到原始状态
					this.$store.commit('CLEAR_ATTACHMENT_IDS');
					originalAttachmentIds.forEach(id => {
						this.$store.commit('ADD_ATTACHMENT_ID', id);
					});
					// **关键修复：错误时不清空票据信息，保留用户已填写的承兑信息**
					// 不调用 clearAcceptanceFillStatus() 和组件状态重置
					this.$message.error('新增失败，请重试');
				});
		},
		// 公共成功处理逻辑
		onSuccess(message, resetForm = false, resetEachInfo = false) {
			this.$modal.msgSuccess(message);
			this.open = false;
			this.getList();

			// 清理 UploadFilesButton 组件状态
			if (this.$refs.attachmentUpload) {
				this.$refs.attachmentUpload.clearUploadedFiles();
			}

			// 清理承兑相关状态
			this.clearAcceptanceFillStatus();

			// **参考 cancel 方法：强制清空承兑信息（绕过错误保护机制）**
			if (this.$refs.otherSelectBankType && this.$refs.otherSelectBankType.forceClearAcceptanceInfo) {
				this.$refs.otherSelectBankType.forceClearAcceptanceInfo();
			}
			if (this.$refs.selfSelectBankType && this.$refs.selfSelectBankType.forceClearAcceptanceInfo) {
				this.$refs.selfSelectBankType.forceClearAcceptanceInfo();
			}

			// **发送 changeFlag 事件进行最终清理**
			this.$bus.$emit('changeFlag', false);

			// **优化的状态重置：使用组件的重置方法**
			if (this.$refs.otherSelectBankType && this.$refs.otherSelectBankType.resetComponentState) {
				this.$refs.otherSelectBankType.resetComponentState();
			}
			if (this.$refs.selfSelectBankType && this.$refs.selfSelectBankType.resetComponentState) {
				this.$refs.selfSelectBankType.resetComponentState();
			}

			// **Vuex全局状态清理：确保双选择状态彻底清除**
			if (this.cashType === this.CASH_TYPE.TRANSFER) {
				// 使用唯一的formId确保状态隔离
				const formId = `internal-transfer-${this.form.id || Date.now()}`;
				this.$store.dispatch('bankAcceptance/resetDualSelection', formId);
			}

			// 清除内部转账表单信息
			const formId = `income-${this.form.id || 'new'}`;
			this.clearInternalTransferFormData(formId);

			// **会话存储清理：防止跨弹窗状态污染**
			sessionStorage.removeItem('bankAcceptanceFilled');

			if (resetForm) this.reset();
			if (resetEachInfo) this.resetEachInfo();
		},

		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除现金记账编号为"' + ids + '"的数据项？')
				.then(function () {
					return delRecord(ids);
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
				'system/record/export',
				{
					...this.queryParams
				},
				`record_${new Date().getTime()}.xlsx`
			);
		},
		// 关闭表单时清除localStorage和sessionStorage中的承兑信息填写状态
		clearAcceptanceFillStatus() {
			// 清除localStorage中所有与承兑相关的状态
			localStorage.removeItem('bankAcceptanceFilled');
			localStorage.removeItem('bankAcceptanceFilledTime');
			localStorage.removeItem('sharedBankAcceptanceFilled');
			// 清除特定实例的状态
			localStorage.removeItem(`bankAcceptanceFilled_income-${this.form.id || 'new'}`);
			localStorage.removeItem(`bankAcceptanceFilled_expense-${this.form.id || 'new'}`);
			// 同时清除sessionStorage中的承兑信息
			sessionStorage.removeItem('bankAcceptanceFilled');
			sessionStorage.removeItem('bankAcceptanceFilledTime');
			sessionStorage.removeItem('sharedBankAcceptanceFilled');
			// 清除特定实例的状态
			sessionStorage.removeItem(`bankAcceptanceFilled_income-${this.form.id || 'new'}`);
			sessionStorage.removeItem(`bankAcceptanceFilled_expense-${this.form.id || 'new'}`);
		},

		// 确保对话框关闭时也清理状态
		handleDialogClose() {
			this.clearAcceptanceFillStatus();

			// **参考 cancel 方法：强制清空承兑信息（绕过错误保护机制）**
			if (this.$refs.otherSelectBankType && this.$refs.otherSelectBankType.forceClearAcceptanceInfo) {
				this.$refs.otherSelectBankType.forceClearAcceptanceInfo();
			}
			if (this.$refs.selfSelectBankType && this.$refs.selfSelectBankType.forceClearAcceptanceInfo) {
				this.$refs.selfSelectBankType.forceClearAcceptanceInfo();
			}

			// **发送 changeFlag 事件进行最终清理**
			this.$bus.$emit('changeFlag', false);

			// **优化的状态重置：使用组件的重置方法**
			if (this.$refs.otherSelectBankType && this.$refs.otherSelectBankType.resetComponentState) {
				this.$refs.otherSelectBankType.resetComponentState();
			}
			if (this.$refs.selfSelectBankType && this.$refs.selfSelectBankType.resetComponentState) {
				this.$refs.selfSelectBankType.resetComponentState();
			}

			// **Vuex全局状态清理：确保双选择状态彻底清除**
			if (this.cashType === this.CASH_TYPE.TRANSFER) {
				const formId = `internal-transfer-${this.form.id || Date.now()}`;
				this.$store.dispatch('bankAcceptance/resetDualSelection', formId);
			}
			// 清除内部转账表单信息
			const formId = `income-${this.form.id || 'new'}`;
			this.clearInternalTransferFormData(formId);
			sessionStorage.removeItem('bankAcceptanceFilled');
		},

		/**
		 * 添加现金记账记录
		 * @param data 冲抵记录数据
		 */
		handleAddRecord(data) {
			// 确保 params 对象存在
			if (!this.form.params) {
				this.form.params = {};
			}
			// 确保 attachmentIds 是数组
			if (!Array.isArray(this.form.params.attachmentIds)) {
				this.form.params.attachmentIds = [];
			}
			// 处理附件列表
			if (this.form.attachmentList && Array.isArray(this.form.attachmentList)) {
				this.form.params.attachmentIds = this.form.attachmentList.map(item => item.id);
			}
			this.cashType = data.type;
			this.$nextTick(() => {
				// 根据冲抵类型处理支付类型
				if (this.cashType === CASH_TYPE.CASH_RECORD) {
					// 冲抵货款：将字符串转换为数组（用于级联选择器）
					if (data.sourcePaymentType) {
						this.form.sourcePaymentType = data.sourcePaymentType.split('-');
					}
					if (data.targetPaymentType) {
						this.form.targetPaymentType = data.targetPaymentType.split('-');
					}
				}
				// 填充id 用于区分是新增还是修改
				this.form.id = data.id;
				// 公共字段填充逻辑
				this.sourceName = data.sourceCompanyName;
				this.targetName = data.targetCompanyName;
				this.form.sourceId = data.sourceId;
				this.form.targetId = data.targetId;
				this.form.type = data.type;
				this.form.referenceTableId = data.referenceTableId;
				this.form.amount = data.amount;
				this.form.transactionTime = data.transactionTime;
				this.form.remarks = data.remarks;
				this.form.code = data.code;
				// 填充转账账户和目标账户
				this.form.sourceBankNo = data.sourceBankNo;
				this.form.targetBankNo = data.targetBankNo;
				if (this.cashType === CASH_TYPE.CASH_RECORD) {
					// 如果是冲抵货款
					this.form.targetCompanyType = data.targetCompanyType;
					this.form.sourceCompanyType = data.sourceCompanyType;
				} else {
					// 如果是内部转账
					this.form.sourceCompanyType = PUBLIC_DICT_TYPE.SELF_COMPANY;
					this.form.targetCompanyType = PUBLIC_DICT_TYPE.SELF_COMPANY;
					// 填充己方和对方银行卡类型
					this.$refs.selfSelectBankType.localSelectType = data.selfBankCardType;
					this.$refs.otherSelectBankType.localSelectType = data.otherBankCardType;
					// 同步银行账户类型到form对象
					this.form.selfBankCardType = data.selfBankCardType;
					this.form.otherBankCardType = data.otherBankCardType;
					// 处理承兑信息
					if (data.bankacceptanceId) {
						// 设置己方账户类型和对方账户类型
						this.setAccountTypeSelection({
							role: 'source',
							accountType: data.selfBankCardType
						});
						this.setAccountTypeSelection({
							role: 'target',
							accountType: data.otherBankCardType
						});
						this.$bus.$emit('changeFlag', data.bankacceptanceId);
					}
				}
			});
			this.open = true;
			this.title = '修改冲抵款';
		}
	}
};
</script>
