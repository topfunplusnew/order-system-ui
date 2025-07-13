<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="120px">
			<el-form-item label="付款时间">
				<el-date-picker
					v-model="dateRange"
					style="width: 240px"
					value-format="yyyy-MM-dd HH:mm:ss"
					type="daterange"
					range-separator="-"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
				></el-date-picker>
			</el-form-item>
			<!--      客户还是供应商-->
			<el-form-item label="对象类型" prop="companyType">
				<el-select v-model="queryParams.companyType" placeholder="请选择对象类型" class="w-85px" clearable>
					<el-option v-for="item in options_companyType" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="付款类型" prop="payType">
				<el-cascader v-model="queryParams.payType" :options="paymentTypeTree" :props="props" @change="handleChange"></el-cascader>
			</el-form-item>
			<el-form-item label="户名" prop="selfBankName">
				<el-input v-model="queryParams.selfBankName" placeholder="请输入我方户名" clearable class="w-85px" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方银行卡号" prop="selfBankID">
				<el-input v-model="queryParams.otherBankNo" placeholder="请输入对方银行卡号" clearable class="w-85px" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-input v-model="queryParams.otherAcountsName" placeholder="请输入对方户名" clearable class="w-85px" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="备注" prop="otherBankNo">
				<el-input v-model="queryParams.comments" placeholder="请输入备注" clearable class="w-85px" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="复核状态" prop="auditState">
				<el-select v-model="queryParams.auditState" placeholder="请选择复核状态" clearable>
					<el-option v-for="item in auditState_options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<!-- 刷新按钮-->
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<!--      解开了新增付款信息-->
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:payment:add']" type="danger" size="mini" @click="handleAdd">新增付款信息</el-button>
			</el-col>
			<!-- <el-col :span="1.5">
        <el-button type="success" size="mini" @click="handleOnce">
          一键付款
        </el-button>
      </el-col> -->
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:payment:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			:data="computedPaymentList"
			size="mini"
			border
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
			ref="paymentTable"
		>
			<!--			<el-table-column type="selection" width="55" />-->
			<el-table-column label="id" align="center" prop="id" v-if="columns[0].visible" />
			<el-table-column label="日期" align="center" prop="fundsDate" width="120" v-if="columns[1].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="fundsDate" />
				</template>
			</el-table-column>
			<el-table-column label="支付类型" align="center" prop="payType" width="120" v-if="columns[2].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="payType" />
				</template>
			</el-table-column>
			<el-table-column label="对方公司" align="center" prop="companyName" width="120" v-if="columns[11].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="companyName" />
				</template>
			</el-table-column>
			<el-table-column label="对方公司类型" align="center" prop="companyType" width="120" v-if="columns[12].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="companyType" />
				</template>
			</el-table-column>
			<el-table-column label="金额" align="center" prop="moneyAmount" width="120" v-if="columns[3].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="moneyAmount" />
				</template>
			</el-table-column>
			<el-table-column label="我方户名" align="center" prop="selfAcountsName" width="120" v-if="columns[4].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="selfAcountsName" />
				</template>
			</el-table-column>
			<el-table-column label="我方账号" align="center" prop="selfBankNo" width="120" v-if="columns[5].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="selfBankNo" />
				</template>
			</el-table-column>
			<el-table-column label="我方开户行" align="center" prop="selfBankName" width="120" v-if="columns[6].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="selfBankName" />
				</template>
			</el-table-column>
			<el-table-column label="对方户名" align="center" prop="otherAcountsName" width="120" v-if="columns[7].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="otherAcountsName" />
				</template>
			</el-table-column>
			<el-table-column label="对方账号" align="center" prop="otherBankNo" width="120" v-if="columns[8].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="otherBankNo" />
				</template>
			</el-table-column>
			<el-table-column label="对方开户行" align="center" prop="otherBankName" width="120" v-if="columns[9].visible" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="otherBankName" />
				</template>
			</el-table-column>
			<el-table-column label="支付状态" align="center" prop="paymentState" width="120" v-if="columns[10].visible" show-overflow-tooltip>
				<template #default="scope">
					<StateTag :state-title="scope.row.paymentState" :state-mapper="{ 0: '未支付', 2: '已支付' }" />
				</template>
			</el-table-column>

			<el-table-column label="备注" align="center" prop="comments" width="120" v-if="columns[13].visible" show-overflow-tooltip />
			<el-table-column label="附件" align="center" prop="attachmentList" width="120" v-if="columns[14].visible" show-overflow-tooltip>
				<template #default="scope">
					<CheckFiles :attachmentList="scope.row.attachmentList" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getPayment, updatePayment)" flag="attachments" />
				</template>
			</el-table-column>
			<!-- 新增银行卡流水编号列 -->
			<el-table-column label="银行卡流水编号" align="center" prop="transactionHistory" width="120" v-if="columns[15] && columns[15].visible" show-overflow-tooltip />
			<!-- 新增银行卡流水附件列 -->
			<el-table-column label="银行卡流水附件" align="center" prop="transactionHistoryAttachmentList" width="120" v-if="columns[16] && columns[16].visible" fixed="right">
				<template #default="scope">
					<CheckFiles
						:attachmentList="scope.row.attachmentList"
						@needToUpdate="value => handleUpdateFilePath(value, scope.row, getPayment, updatePayment)"
						:is-upload="false"
						flag="transactionHistoryAttachmentList"
					/>
				</template>
			</el-table-column>
			<el-table-column label="复核状态" align="center" class-name="small-padding fixed-width" width="80" fixed="right">
				<template slot-scope="scope">
					<el-switch
						v-model="scope.row.auditState"
						v-hasPermi="['system:payment:audit']"
						active-color="#13ce66"
						inactive-color="#ff4949"
						@change="value => handlePaymentAudit(scope.row, value)"
					></el-switch>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200" fixed="right">
				<template slot-scope="scope">
					<el-button v-if="scope.row.paymentState === '未支付'" v-hasPermi="['system:payment:edit']" size="mini" type="text" @click="handlePaymentRow(scope.row)">付款</el-button>
					<el-button v-else-if="scope.row.paymentState === '已支付'" v-hasPermi="['system:payment:edit']" size="mini" disabled type="success">已付款</el-button>
					<el-button v-else size="mini" disabled type="warning">申请中</el-button>
					<el-button v-hasPermi="['system:payment:edit']" size="mini" type="primary" @click="handleEdit(scope.row)">编辑</el-button>
					<el-button v-hasPermi="['system:payment:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>

			<!-- <el-table-column
        label="运费信息"
        align="center"
        class-name="small-padding fixed-width"
        width="150"
        fixed="right"
      >
        <template slot-scope="scope">
          <CheckDetail :row="scope.row" />
        </template>
      </el-table-column> -->
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" z />

		<!--     添加或修改付款信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1000px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="140px">
				<el-row :gutter="20">
					<el-col :span="12">
						<el-form-item label="日期" prop="fundsDate">
							<el-date-picker v-model="form.fundsDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="付款类型" prop="payType">
							<el-cascader v-model="form.payType" :options="paymentTypeTree" :props="props" @change="handleChange"></el-cascader>
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="12">
						<el-form-item label="金额" prop="moneyAmount">
							<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="我方银行账户类型">
							<BankType
								ref="selfSelectedBankType"
								:bill-type="BankAcceptanceType.PAY_TYPE.PAYMENT"
								:select-type="form.selfBankCardType"
								@updateSelectedType="changeSelfBankType"
								@updateBankAcceptance="value => (form.params.bankacceptance = value)"
							/>
						</el-form-item>
					</el-col>
				</el-row>

				<!--        对方信息-->
				<el-row :gutter="20">
					<el-col :span="12">
						<el-form-item label="我方户名" prop="selfAcountsName">
							<el-row>
								<el-col :span="16">
									<el-input disabled v-model="form.selfAcountsName" placeholder="请选择" />
								</el-col>
								<el-col :span="8">
									<SearchOption
										:limit-info="{ acountsType: '己方公司' }"
										:get-data="listBankAccount"
										icon="el-icon-search"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										@commitBack="handleCommitBack"
										@update:queryName="handleUpdateQueryName"
									>
										<template #table-columns>
											<el-table-column label="账号类型" align="center" prop="acountsType" />
											<el-table-column label="显示名称" align="center" prop="displayName" />
											<el-table-column label="开户行" align="center" prop="bankName" />
											<el-table-column label="开户名" align="center" prop="acountsName" />
											<el-table-column label="账号" align="center" prop="bankNo" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="我方账号" prop="selfBankNo">
							<el-input disabled v-model="form.selfBankNo" placeholder="请选择" />
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="12">
						<el-form-item label="我方开户行" prop="selfBankName">
							<el-input disabled v-model="form.selfBankName" placeholder="请选择" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="对方类型">
							<el-select v-model="value" placeholder="请选择">
								<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
				</el-row>

				<!--        下面的操作是 客户id  配合 银行卡信息进行付款.-->
				<!--      选择供应商-->
				<el-row v-if="value === PAYMENT_TYPES.SUPPLIER" :gutter="20">
					<el-col :span="12">
						<el-form-item label="对方户名(供应商)" prop="otherAcountsName">
							<el-row>
								<el-col :span="16">
									<el-input disabled v-model="form.companyName" placeholder="请选择" />
								</el-col>
								<el-col :span="8">
									<SearchOption
										:limit-info="{
											companyType: PAYMENT_TYPES.SUPPLIER
										}"
										:get-data="listCompany"
										icon="el-icon-search"
										:query-label="'供应商'"
										query-info="companyName"
										:query-name="queryOtherSupplier"
										@update:queryName="handleUpdateQueryNameOtherSupplier"
										@commitBack="handleCommitBackOtherSupplier"
									>
										<template #table-columns>
											<el-table-column label="供应商" align="center" prop="companyName" width="180" show-overflow-tooltip />
											<el-table-column label="老板姓名" align="center" prop="leader" width="180" show-overflow-tooltip />
											<el-table-column label="老板电话" align="center" prop="leaderTel" width="180" show-overflow-tooltip />
											<el-table-column label="区域" align="center" prop="region" width="180" show-overflow-tooltip />
											<el-table-column label="联系人" align="center" prop="relationName" width="180" show-overflow-tooltip />
											<el-table-column label="销售经理" align="center" prop="salesManager" width="180" show-overflow-tooltip />
											<el-table-column label="地址" align="center" prop="address" width="150" show-overflow-tooltip />
											<el-table-column label="电话" align="center" prop="relationTel" width="180" show-overflow-tooltip />
											<el-table-column label="备注" align="center" prop="comments" width="180" show-overflow-tooltip />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<!-- 预留给其他字段或空白 -->
					</el-col>
				</el-row>
				<!--      选择客户-->
				<el-row v-if="value === PAYMENT_TYPES.CUSTOMER" :gutter="20">
					<el-col :span="12">
						<el-form-item label="对方户名(客户)" prop="companyName">
							<el-row>
								<el-col :span="16">
									<el-input disabled v-model="form.companyName" placeholder="请选择" />
								</el-col>
								<el-col :span="8">
									<SearchOption
										:limit-info="{
											companyType: PAYMENT_TYPES.CUSTOMER
										}"
										:get-data="listCompany"
										:query-label="'客户'"
										query-info="companyName"
										:query-name="queryOtherCustomer"
										icon="el-icon-search"
										@update:queryName="handleUpdateQueryNameOtherCustomer"
										@commitBack="handleCommitBackOther"
									>
										<template #table-columns>
											<el-table-column label="客户" align="center" prop="companyName" width="180" show-overflow-tooltip />
											<el-table-column label="老板姓名" align="center" prop="leader" width="180" show-overflow-tooltip />
											<el-table-column label="老板电话" align="center" prop="leaderTel" width="180" show-overflow-tooltip />
											<el-table-column label="区域" align="center" prop="region" width="180" show-overflow-tooltip />
											<el-table-column label="联系人" align="center" prop="relationName" width="180" show-overflow-tooltip />
											<el-table-column label="销售经理" align="center" prop="salesManager" width="180" show-overflow-tooltip />
											<el-table-column label="地址" align="center" prop="address" width="150" show-overflow-tooltip />
											<el-table-column label="电话" align="center" prop="relationTel" width="180" show-overflow-tooltip />
											<el-table-column label="备注" align="center" prop="comments" width="180" show-overflow-tooltip />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<!-- 预留给其他字段或空白 -->
					</el-col>
				</el-row>
				<!--      选择司机-->
				<el-row v-if="value === PAYMENT_TYPES.DRIVER" :gutter="20">
					<el-col :span="12">
						<el-form-item label="对方户名(司机)" prop="companyName">
							<el-row>
								<el-col :span="16">
									<el-input disabled v-model="form.companyName" placeholder="请选择" />
								</el-col>
								<el-col :span="8">
									<SearchOption
										:limit-info="{}"
										:get-data="listCars"
										icon="el-icon-search"
										:query-label="'司机'"
										query-info="driver"
										:query-name="queryOtherDriver"
										@update:queryName="handleUpdateQueryNameOtherDriver"
										@commitBack="handleCommitBackOtherCars"
									>
										<template #table-columns>
											<el-table-column label="车牌" align="center" prop="carNo" width="200" />
											<el-table-column label="司机姓名" align="center" prop="driver" width="200" />
											<el-table-column label="司机电话" align="center" prop="tel" width="200" />
											<el-table-column label="户名" align="center" prop="acountsName" width="200">
												<template slot-scope="scope">
													{{ isNull(scope.row.acountsName) }}
												</template>
											</el-table-column>
											<el-table-column label="银行账号" align="center" prop="bankNo" width="200">
												<template slot-scope="scope">
													{{ isNull(scope.row.bankNo) }}
												</template>
											</el-table-column>
											<el-table-column label="开户行" align="center" prop="bankName" width="200">
												<template slot-scope="scope">
													{{ isNull(scope.row.bankName) }}
												</template>
											</el-table-column>
											<el-table-column label="运输类型" align="center" prop="carType" width="200" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<!-- 预留给其他字段或空白 -->
					</el-col>
				</el-row>

				<el-row :gutter="20" v-if="value !== PAYMENT_TARGET_TYPE.PAYMENT_FEE">
					<el-col :span="12">
						<el-form-item label="对方银行账户类型">
							<BankType ref="otherSelectedBankType" :option-baned="true" :baned="true" :select-type="form.otherBankCardType" @updateSelectedType="changeOtherBankType" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="对方账号" prop="otherBankNo">
							<el-row>
								<el-col :span="16">
									<el-input disabled v-model="form.otherBankNo" placeholder="请选择" />
								</el-col>
								<el-col :span="8">
									<SearchOption
										:limit-info="{ acountsType: value }"
										:get-data="listBankAccount"
										:query-name="queryBankAcount"
										query-label="户名查找"
										query-info="acountsName"
										@commitBack="handleCommitBackBankAcount"
										@update:queryName="handleUpdateQueryBankAcount"
										:extra-params="{
											companyId: form.companyId,
											companyType: value
										}"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" />
											<el-table-column label="显示名称" align="center" prop="displayName" />
											<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
											<el-table-column label="开户行" align="center" prop="bankName" />
											<el-table-column label="公司名称" align="center" prop="companyName" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="12">
						<el-form-item label="对方开户行" prop="otherBankName" v-if="value !== '支付费用'">
							<el-input disabled v-model="form.otherBankName" placeholder="请选择" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="附件" prop="attachmentList">
							<CheckFiles :attachmentList="form.attachmentList" @needToUpdate="value => (form.attachmentList = value)" flag="attachments" />
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="12">
						<el-form-item label="银行卡流水编号" prop="transactionHistory">
							<el-input v-model="form.transactionHistory" placeholder="请输入银行卡流水编号" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="银行卡流水附件" prop="transactionHistoryAttachmentList">
							<CheckFiles :attachmentList="form.attachmentList" @needToUpdate="value => (form.attachmentList = value)" flag="transactionHistoryAttachmentList" />
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="24">
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" />
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
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="请选择付款银行卡" :visible.sync="chooseBankDialogVisible" width="600px">
			<div>
				<el-form :model="chooseInfo" label-width="150px">
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
					<el-form-item label="我方户名" prop="selfAcountsName">
						<el-row>
							<el-col :span="10">
								<el-input v-model="chooseInfo.selfAcountsName" placeholder="请输入我方户名" />
							</el-col>
							<el-col :span="3">
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
										<el-table-column label="账号类型" align="center" prop="acountsType" />
										<el-table-column label="显示名称" align="center" prop="displayName" />
										<el-table-column label="开户行" align="center" prop="bankName" />
										<el-table-column label="开户名" align="center" prop="acountsName" />
										<el-table-column label="账号" align="center" prop="bankNo" />
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
	</div>
</template>

<script>
import { listPayment, delPayment, addPayment, updatePayment, updatePaymentSimulate, getPayment } from '@/api/system/payment';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { excludeParams } from '@/api/tool/exclude';
import { addDateRange, parseTime } from '@/utils/ruoyi';
import { listBankAccount } from '../../../api/system/bankAccount';
import { mixin_payment_audit } from '../../dashboard/mixins/payment/payment_audit';
import { mixin_payment_select, PAYMENT_TYPES } from '../../dashboard/mixins/payment/payment_select';
import { listCars } from '../../../api/system/cars';
import { isNull } from '../../../main';
import { mixin_payment_subject } from '../../dashboard/mixins/payment/payment_subject';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import DynamicField from '@/components/DynamicField.vue';
import { mixin_paymentindex_fill } from './paymentFill';
import CheckDetail from '../../dashboard/components/payment/CheckDetail.vue';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import { mixin_bankType } from '../../dashboard/mixins/common/common_bankType';
import StateTag from '@/views/dashboard/components/common/StateTag.vue';
import { BankAcceptanceType, PAYMENT_TARGET_TYPE } from '../../../api/tool/enums';
import CheckFiles from '@/components/CheckFiles.vue';
import { mixin_checkfile } from '@/views/dashboard/mixins/checkfiles/mixin_checkfile';
import _ from 'lodash';

export default {
	name: 'Payment',
	components: {
		CheckFiles,
		StateTag,
		BankType,
		CheckDetail,
		DynamicField,
		SearchOption
	},
	mixins: [mixin_printHTML, mixin_payment_audit, mixin_payment_select, mixin_payment_subject, mixin_paymentindex_fill, mixin_bankType, mixin_checkfile],
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
			// 付款信息表格数据
			paymentList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				payNO: null,
				fundsDate: null,
				payType: null,
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
				paymentState: null,
				companyName: null,
				companyId: null,
				companyType: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
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
				selfAcountsName: [
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
				otherAcountsName: [
					{
						required: true,
						message: '请输入对方户名',
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
				{ key: 16, label: `银行卡流水附件`, visible: true }
			],
			// 顶部筛选框
			queryPayment: {},
			dateRange: [],
			options_companyType: [
				{
					value: '客户',
					label: '客户'
				},
				{
					value: '供应商',
					label: '供应商'
				},
				{
					value: '司机',
					label: '司机'
				},
				{
					value: '个人',
					label: '个人'
				},
				{
					value: '其他',
					label: '其他'
				}
			],
			// 银行卡选择的弹窗
			chooseBankDialogVisible: false,
			chooseInfo: {},
			oneClickPaymentDialogVisible: false,

			// 展示一下合并的信息
			batchPaymentData: [],
			// 对应渲染的组件和信息
			Components: null,
			needToShowInfo: null,
			infoVisible: false
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

		// 处理审核状态
		computedPaymentList() {
			return this.paymentList.map(item => {
				return {
					...item,
					auditState: item.auditState === null ? false : item.auditState === '1'
				};
			});
		}
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('payment-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('payment-columns') === 'null' || !localStorage.getItem('payment-columns')) {
			// 设置localStorage
			localStorage.setItem('payment-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('payment-columns'));
		}
	},
	methods: {
		updatePayment,
		getPayment,
		isNull,
		listCars,
		listBankAccount,
		listCompany,
		handleCommitUpload(value) {
			console.log(value);

			this.form.attachment = value;
		},
		// 选择我方银行账户类型
		changeCustomSelfBankType(value) {
			this.chooseInfo.otherBankCardType = value;
			this.chooseInfo.selfBankCardType = value;
		},
		/** 查询付款信息列表 */
		getList() {
			this.loading = true;
			// 把查询条件中的payType转成字符串
			if (this.queryParams.payType) {
				this.queryParams.payType = this.queryParams.payType.join('-');
			}
			// 查询
			return listPayment(addDateRange(this.queryParams, this.dateRange, 'payment')).then(response => {
				this.paymentList = response.rows;
				this.total = response.total;
				this.loading = false;
				return response;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.$bus.$emit('changeFlag', false);
			this.$refs.selfSelectedBankType.localSelectType = null;
			this.$refs.otherSelectedBankType.localSelectType = null;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				payNO: null,
				fundsDate: parseTime(new Date()),
				payType: null,
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
				// 新增银行卡流水编号和附件
				transactionHistory: null,
				attachmentList: [],
				params: {
					bankacceptance: null
				}
			};
			this.resetForm('form');
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
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAcountsName: null,
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
					bankacceptance: null
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
			this.title = '添加付款信息';
		},
		/** 编辑按钮操作 */
		handleEdit(row) {
			this.reset();
			const id = row.id || this.ids;
			getPayment(id).then(response => {
				this.form = response.data;
				// 设置级联选择器的值
				if (this.form.payType) {
					this.form.payType = this.form.payType.split('-');
				}
				// 设置银行账户类型
				if (this.form.selfBankCardType) {
					this.$nextTick(() => {
						if (this.$refs.selfSelectedBankType) {
							this.$refs.selfSelectedBankType.localSelectType = this.form.selfBankCardType;
						}
					});
				}
				if (this.form.otherBankCardType) {
					this.$nextTick(() => {
						if (this.$refs.otherSelectedBankType) {
							this.$refs.otherSelectedBankType.localSelectType = this.form.otherBankCardType;
						}
					});
				}
				// 设置对方类型
				if (this.form.companyType) {
					this.value = this.form.companyType;
				}
				this.open = true;
				this.title = '修改付款信息';
			});
		},
		// 付款的操作
		handlePaymentRow(row) {
			// 如果没有我方银行卡信息 需要跳出选择银行卡信息
			if (!row.selfBankID) {
				this.resetChooseInfo();
				// 深克隆防止出现引用问题
				this.chooseInfo = _.cloneDeep(row);
				// 初始化承兑对象
				this.chooseInfo.params = { bankacceptance: null };
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
						const res = await updatePayment({ ...row, paymentState: '已支付' });
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
			const newPayment = { ...this.chooseInfo, paymentState: '已支付' };
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
					if (!this.form.selfBankCardType || !this.form.otherBankCardType) {
						this.$message.warning('请选择银行账户类型,缺一不可!');
						return;
					}
					if (this.form.selfBankCardType && this.form.otherBankCardType) {
						if (this.form.selfBankCardType !== this.form.otherBankCardType) {
							this.$message.warning('操作失败，无法进行承兑与活期存款或者相反的交易,类型需要保持一致');
							return;
						}
					}
					// 去除无用的参数
					this.form = excludeParams(this.form, this.$exclude);
					// 对结果进行特殊处理 如果是字符串 就把响应式赋值为空，然后重新选择 如果是数组 ，那么不会进入这个判断
					if (typeof this.form.payType === 'string') {
						this.form.payType = null;
						this.$message.warning('请选择付款类型');
						return;
					}
					this.form.payType = this.form.payType.join('-');
					if (this.form.id != null) {
						// 编辑操作，使用新的编辑接口
						const originalId = this.form.id;
						updatePaymentSimulate(this.form)
							.then(response => {
								this.$modal.msgSuccess('修改成功');
								this.open = false;
								// 由于返回了新的id，需要刷新列表并保持选中状态
								this.getList().then(() => {
									// 如果需要保持选中状态，可以根据返回的新id来处理
									if (response.data && response.data.id) {
										// 可以根据需要添加选中逻辑
									}
								});
							})
							.catch(() => {
								// 如果编辑失败，保持原有id
								this.form.id = originalId;
							});
					} else {
						// 新增操作
						this.form.companyType = this.value;
						addPayment(this.form).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.$bus.$emit('changeFlag', false);
							this.open = false;
							this.getList();
						});
					}
					// 重置银行类型选择器
					if (this.$refs.selfSelectedBankType) {
						this.$refs.selfSelectedBankType.localSelectType = null;
					}
					if (this.$refs.otherSelectedBankType) {
						this.$refs.otherSelectedBankType.localSelectType = null;
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
					...this.queryParams
				},
				`payment_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
<style scoped>
.w-85px {
	width: 85px;
}
</style>
