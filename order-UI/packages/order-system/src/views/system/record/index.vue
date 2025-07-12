<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="交易时间">
				<el-date-picker
					v-model="dateRange"
					style="width: 240px"
					value-format="yyyy-MM-dd HH:mm:ss"
					type="daterange"
					range-separator="-"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
				/>
			</el-form-item>
			<el-form-item label="收入方" prop="sourceCompanyName">
				<el-input v-model="queryParams.sourceCompanyName" placeholder="请输入收入方公司名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="支出方" prop="targetCompanyName">
				<el-input v-model="queryParams.targetCompanyName" placeholder="请输入收入方公司名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="备注" prop="remarks">
				<el-input v-model="queryParams.remarks" placeholder="请输入备注" clearable @keyup.enter.native="handleQuery" />
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

			<el-table-column v-if="columns[0].visible" label="id" align="center" prop="id" />
			<el-table-column v-if="columns[1].visible" label="交易时间" align="center" prop="transactionTime" width="180">
				<template slot-scope="scope">
					<span>{{ parseTime(scope.row.transactionTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="收入方/资金流出方" align="center" prop="sourceCompanyName" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="来源方公司类型" align="center" prop="sourceCompanyType" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="资金流出账号" align="center" prop="sourceBankNo" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="金额" align="center" prop="amount" />
			<el-table-column v-if="columns[9].visible" label="目标公司类型" align="center" prop="targetCompanyType" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="支出方/资金流入方" align="center" prop="targetCompanyName" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="资金流入账号" align="center" prop="targetBankNo" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="冲抵类型" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					<span>{{ scope.row.referenceTableName === 'offsetting' ? '冲抵货款' : '内部转账' }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="账户类型" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					<div>
						{{ handleDisplayType(scope.row, scope.row.referenceTableName) }}
					</div>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="附件" align="center" prop="attachment">
				<template #default="scope">
					<CheckFiles :path="scope.row.attachment" @needToUpdate="value => handleUpdateFilePath(value, scope.row, 'attachment', getRecord, updateRecord)" />
				</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="备注" align="center" prop="remarks" show-overflow-tooltip />
			<el-table-column v-if="columns[13].visible" label="操作人员姓名" align="center" prop="userName" show-overflow-tooltip />

			<!-- 操作列 -->
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:record:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:record:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改现金记账对话框  cashType 用于分别管理冲抵类型 : 冲抵货款 或者 冲抵第三方开票-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="700px" append-to-body @close="handleDialogClose">
			<el-form ref="form" :model="form" :rules="rules" label-width="150px">
				<!--        目前支持两种类型 一种是冲抵货款 一种是冲抵第三方开票-->
				<el-form-item label="冲抵类型">
					<el-row>
						<el-radio v-model="cashType" label="offsetting">冲抵货款</el-radio>
						<el-radio v-model="cashType" label="transfer">内部转账</el-radio>
					</el-row>
				</el-form-item>
				<el-divider>
					<div>
						<el-icon class="el-icon-circle-plus" />
						<span v-if="CASH_TYPE.TRANSFER === cashType">资金流出</span>
						<span v-else>收入方信息</span>
					</div>
				</el-divider>

				<!--        2025-2-28 新增转账账户-->
				<el-form-item label="转账账户" v-if="cashType === CASH_TYPE.TRANSFER">
					<el-row>
						<el-col :span="14">
							<el-input v-model="form.sourceBankNo" disabled placeholder="请选择转账账户"></el-input>
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
									}
								"
								@update:queryName="value => (querySourceBankNo = value)"
							>
								<template #table-columns>
									<el-table-column label="账户类型" align="center" prop="acountsType" width="200" />
									<el-table-column label="显示名称" align="center" prop="displayName" />
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

				<!--        如果是冲抵货款 还需要选择一个公司 -->
				<el-row v-if="cashType === CASH_TYPE.OFF_SETTING">
					<el-form-item label="收入方类型">
						<el-radio v-model="form.sourceCompanyType" label="客户">客户</el-radio>
						<el-radio v-model="form.sourceCompanyType" label="供应商">供应商</el-radio>
						<el-radio v-model="form.sourceCompanyType" label="司机">司机</el-radio>

						<!--            2025年5月14号振龙要求删除己方公司-->
						<!--						<el-radio v-model="form.sourceCompanyType" label="己方公司">己方公司</el-radio>-->
					</el-form-item>
					<el-form-item label="收入方">
						<el-row>
							<el-col :span="14">
								<el-input disabled v-model="sourceName" type="text" placeholder="请选择" />
							</el-col>

							<!--              根据不同类型选择不同的 但是后来振龙说 选两次太麻烦, 所以去除-->
							<template v-if="cashType === CASH_TYPE.OFF_SETTING">
								<!--              如果是司机-->
								<el-col v-if="form.sourceCompanyType === PUBLIC_DICT_TYPE.DRIVER" :span="4">
									<SearchOption
										:limit-info="{}"
										:get-data="listCars"
										query-info="driver"
										query-label="司机姓名"
										:query-name="queryDriver"
										@update:queryName="handleUpdateDriver"
										@commitBack="handleCommitBackDriver"
									>
										<template #table-columns>
											<el-table-column label="司机姓名" align="center" prop="driver" />
											<el-table-column label="司机电话" align="center" prop="tel" />
											<el-table-column label="运输类型" align="center" prop="carType" />
										</template>
									</SearchOption>
								</el-col>
								<!--              如果是己方公司 -->
								<el-col v-if="form.sourceCompanyType === PUBLIC_DICT_TYPE.SELF_COMPANY" :span="4">
									<SearchOption
										:limit-info="{
											acountsType: form.sourceCompanyType
										}"
										:get-data="listBankAccount"
										query-info="acountsName"
										query-label="户名查找"
										:query-name="querySelfAccount"
										@update:queryName="handleUpdateSelfAccount"
										@commitBack="handleCommitBackSelfAccount"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" />
											<el-table-column label="显示名称" align="center" prop="displayName" />
											<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
											<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
											<el-table-column label="开户行" align="center" prop="bankName" />
											<el-table-column label="公司名称" align="center" prop="companyName" />
										</template>
									</SearchOption>
								</el-col>
								<!--              如果是其他-->
								<el-col v-if="form.sourceCompanyType !== '司机' && form.sourceCompanyType !== '己方公司'" :span="4">
									<SearchOption
										:limit-info="{
											companyType: form.sourceCompanyType
										}"
										:get-data="listCompany"
										query-info="companyName"
										query-label="公司名称"
										:query-name="queryCompanyName"
										@update:queryName="handleUpdateCompanyNameGet"
										@commitBack="handleCommitBackCompanyGet"
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
							</template>
						</el-row>
					</el-form-item>
				</el-row>

				<!--        1.选择原 只有在内部转账的情况下才会展示-->
				<div v-if="cashType === CASH_TYPE.TRANSFER">
					<!--          选择收入账户类型-->
					<el-form-item label="收入账户类型">
						<!-- 选择银行卡类型的组件 -->
						<BankType
							ref="selfSelectBankType"
							@updateSelectedType="changeSelfBankType"
							@updateBankAcceptance="
								value => {
									form.params.bankacceptance = value;
								}
							"
							:bill-type="PayType.TRANSFOR"
							:is-internal-transfer="cashType === CASH_TYPE.TRANSFER"
							:form-id="`income-${form.id || 'new'}`"
						/>
					</el-form-item>
					<el-form-item :label="source">
						<el-row>
							<el-col :span="14">
								<el-input disabled v-model="sourceName" placeholder="请选择" />
							</el-col>
							<template v-if="cashType === CASH_TYPE.OFF_SETTING">
								<el-col :span="3">
									<SearchOption
										:get-data="listBankAccount"
										:limit-info="{ acountsType: PUBLIC_DICT_TYPE.SELF_COMPANY }"
										query-info="acountsName"
										:query-name="querySupplier"
										query-label="户名"
										@commitBack="handleCommitCompanySupplier"
										@update:queryName="updateQuerySupplier"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" width="200" />
											<el-table-column label="显示名称" align="center" prop="displayName" />
											<el-table-column label="开户名称" align="center" prop="acountsName" width="200" />
											<el-table-column label="银行账号" align="center" prop="bankNo" width="200" />
											<el-table-column label="开户行" align="center" prop="bankName" width="200" />
											<el-table-column label="公司名称" align="center" prop="companyName" width="200" />
											<el-table-column label="余额" align="center" prop="amount" width="200" />
										</template>
									</SearchOption>
								</el-col>
							</template>
						</el-row>
					</el-form-item>
				</div>

				<el-divider>
					<div>
						<el-icon class="el-icon-remove" />
						<span v-if="CASH_TYPE.TRANSFER === cashType">资金流入</span>
						<span v-else>支出方信息</span>
					</div>
				</el-divider>
				<el-form-item label="目标账户" v-if="cashType === CASH_TYPE.TRANSFER">
					<el-row>
						<el-col :span="14">
							<el-input v-model="form.targetBankNo" disabled placeholder="请选择目标账户"></el-input>
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
									}
								"
								@update:queryName="value => (querySourceBankNo = value)"
							>
								<template #table-columns>
									<el-table-column label="账户类型" align="center" prop="acountsType" width="200" />
									<el-table-column label="显示名称" align="center" prop="displayName" />
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
				<!--        如果是冲抵货款 才要选择对方的公司类型 而如果是其他类型 不需要选择 直接填充-->
				<el-row v-if="cashType === CASH_TYPE.OFF_SETTING">
					<el-form-item label="支出方类型">
						<el-radio v-model="form.targetCompanyType" label="客户">客户</el-radio>
						<el-radio v-model="form.targetCompanyType" label="供应商">供应商</el-radio>
						<el-radio v-model="form.targetCompanyType" label="司机">司机</el-radio>
					</el-form-item>
					<el-form-item label="支出方">
						<el-row>
							<el-col :span="14">
								<el-input disabled v-model="targetName" type="text" placeholder="请选择" />
							</el-col>
							<template v-if="cashType === CASH_TYPE.OFF_SETTING">
								<!--               如果是司机-->
								<el-col v-if="form.targetCompanyType === '司机'" :span="4">
									<SearchOption
										:limit-info="{}"
										:get-data="listCars"
										query-info="driver"
										query-label="司机姓名"
										:query-name="queryDriver"
										@update:queryName="handleUpdateDriver"
										@commitBack="handleCommitBackDriver"
									>
										<template #table-columns>
											<el-table-column label="司机姓名" align="center" prop="driver" />
											<el-table-column label="司机电话" align="center" prop="tel" />
											<el-table-column label="账号类型" align="center" prop="acountsType" />
											<el-table-column label="运输类型" align="center" prop="carType" />
										</template>
									</SearchOption>
								</el-col>
								<!--              如果是己方公司-->
								<el-col v-else-if="form.targetCompanyType === '己方公司'" :span="4">
									<SearchOption
										:limit-info="{
											acountsType: form.targetCompanyType
										}"
										:get-data="listBankAccount"
										query-info="acountsName"
										query-label="户名查找"
										:query-name="querySelfAccount"
										@update:queryName="handleUpdateSelfAccount"
										@commitBack="handleCommitBackSelfAccount"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" />
											<el-table-column label="显示名称" align="center" prop="displayName" />
											<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
											<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
											<el-table-column label="开户行" align="center" prop="bankName" />
											<el-table-column label="公司名称" align="center" prop="companyName" />
										</template>
									</SearchOption>
								</el-col>
								<!--            其他-->
								<el-col v-else :span="4">
									<SearchOption
										:limit-info="{
											companyType: form.targetCompanyType
										}"
										:get-data="listCompany"
										query-info="companyName"
										query-label="公司名称"
										:query-name="queryCompanyName"
										@update:queryName="handleUpdateCompanyNamePay"
										@commitBack="handleCommitBackCompanyPay"
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
							</template>
						</el-row>
					</el-form-item>
				</el-row>
				<div v-if="cashType === CASH_TYPE.TRANSFER">
					<!--          选择支出账户类型-->
					<el-form-item label="支出账户类型">
						<BankType
							ref="otherSelectBankType"
							@updateSelectedType="changeOtherBankType"
							@updateBankAcceptance="
								value => {
									form.params.bankacceptance = value;
								}
							"
							:bill-type="PayType.TRANSFOR"
							:is-internal-transfer="cashType === CASH_TYPE.TRANSFER"
							:form-id="`expense-${form.id || 'new'}`"
						/>
					</el-form-item>
					<!--        2.选择去-->
					<el-form-item :label="target">
						<el-row>
							<el-col :span="14">
								<el-input disabled v-model="targetName" placeholder="请选择" />
							</el-col>
							<template v-if="cashType === CASH_TYPE.OFF_SETTING">
								<el-col :span="3">
									<SearchOption
										:get-data="listBankAccount"
										:limit-info="{ acountsType: PUBLIC_DICT_TYPE.SELF_COMPANY }"
										query-info="acountsName"
										:query-name="queryCustomer"
										query-label="户名"
										@commitBack="handleCommitCompanyCustomer"
										@update:queryName="updateQueryCustomer"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" width="200" />
											<el-table-column label="显示名称" align="center" prop="displayName" />
											<el-table-column label="开户名称" align="center" prop="acountsName" width="200" />
											<el-table-column label="银行账号" align="center" prop="bankNo" width="200" />
											<el-table-column label="开户行" align="center" prop="bankName" width="200" />
											<el-table-column label="公司名称" align="center" prop="companyName" width="200" />
											<el-table-column label="余额" align="center" prop="amount" width="200" />
										</template>
									</SearchOption>
								</el-col>
							</template>
						</el-row>
					</el-form-item>
				</div>

				<el-divider>
					<el-icon class="el-icon-edit" />
					基本信息
				</el-divider>
				<!--        金额只有在不是冲抵货款的其他类型中才会展示 冲抵货款在前面就已经输入了金额-->
				<el-form-item :label="cashType === CASH_TYPE.TRANSFER ? '转账金额' : '冲抵金额'" prop="amount">
					<el-row>
						<el-col :span="14">
							<el-input v-model="form.amount" :placeholder="cashType === CASH_TYPE.TRANSFER ? '转账金额' : '冲抵金额'" type="number" />
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="附件" prop="attachment">
					<file-upload ref="uploadFile" @input="handleCommitUpload" />
				</el-form-item>
				<el-form-item label="交易时间" prop="transactionTime">
					<el-date-picker v-model="form.transactionTime" clearable type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择交易时间" />
				</el-form-item>
				<el-form-item label="备注" prop="remarks">
					<el-input v-model="form.remarks" placeholder="请输入备注" />
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
import BankType from '@/views/dashboard/components/common/BankType.vue';
import { mixin_bankType } from '@/views/dashboard/mixins/common/common_bankType';
import { listBankAccount } from '../../../api/system/bankAccount';
import { listCompany } from '../../../api/system/company';
import { getRecord, updateRecord } from '../../../api/system/record';
import { BankAcceptanceType, PayType, TableName } from '../../../api/tool/enums';
import { excludeParams } from '../../../api/tool/exclude';
import CheckFiles from '../../../components/CheckFiles.vue';
import SearchOption from '../../../components/SearchOption.vue';
import { PUBLIC_DICT_TYPE } from '../../../utils/order';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { mixin_record_uploadFiles } from '../../dashboard/mixins/record/record_upload';
import { CASH_TYPE } from './constrant';
import { mixin_record_fill } from './recordFill';
import BANK_ACCEPTANCE from '@/components/NeedToShow/BANK_ACCEPTANCE.vue';

export default {
	name: 'Record',
	components: { BankType, CheckFiles, SearchOption },
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
		mixin_bankType
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
				pageSize: 10,
				transactionTime: null,
				supplierId: null,
				customerId: null,
				amount: null,
				referenceTableId: null,
				referenceTableName: null,
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
				{
					key: 1,
					label: '交易时间',
					prop: 'transactionTime',
					visible: true
				},
				{ key: 2, label: '金额', prop: 'amount', visible: true },
				{ key: 3, label: '收入方', prop: 'incomeParty', visible: true },
				{ key: 4, label: '收入账户', prop: 'targetBankNo', visible: true },
				{
					key: 5,
					label: '收入方公司类型',
					prop: 'incomeCompanyType',
					visible: true
				},
				{
					key: 6,
					label: '支出方',
					prop: 'expenseParty',
					visible: true
				},
				{ key: 7, label: '转账账户', prop: 'sourceBankNo', visible: true },
				{
					key: 8,
					label: '冲抵类型',
					prop: 'offsetType',
					visible: true
				},
				{
					key: 9,
					label: '支出方公司类型',
					prop: 'expenseCompanyType',
					visible: true
				},
				{ key: 10, label: '附件', prop: 'attachment', visible: true },
				{ key: 11, label: '备注', prop: 'comments', visible: true },
				{ key: 12, label: '账户类型', prop: 'comments', visible: true },
				{ key: 13, label: '操作人员类型', prop: 'comments', visible: true }
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
				referenceTableName: [
					{
						required: true,
						message: '对应表名不能为空',
						trigger: 'blur'
					}
				]
			},

			// 冲抵类型 默认为冲抵货款
			cashType: CASH_TYPE.OFF_SETTING,

			// 新增的字段
			querySourceBankNo: null
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

		/**
		 * 显示的去
		 * 冲抵货款的时候就是收入方金额
		 * 内部转账的时候显示收入方 并且要显示填充搜索按钮
		 */
		target() {
			// 如果是冲抵货款 那么就是用货款来去冲抵金额
			if (this.cashType === CASH_TYPE.OFF_SETTING) {
				return '支出方金额';
			}
			if (this.cashType === CASH_TYPE.TRANSFER) {
				return '支出方';
			}
			return '支出';
		},
		/**
		 * 显示的源
		 * 冲抵货款的时候就是支出方金额
		 * 内部转账的时候显示支出方 并且要显示填充搜索按钮
		 */
		source() {
			if (this.cashType === CASH_TYPE.OFF_SETTING) {
				return '收入方金额';
			}
			if (this.cashType === CASH_TYPE.TRANSFER) {
				return '收入方';
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
	},
	methods: {
		listCars,
		listBankAccount,
		listCompany,
		parseTime,
		updateRecord,
		getRecord,
		//referenceTableName为 transfor的时候才进行判断,显示为银行活期存款,如果不为空 那么就是承兑类型
		handleDisplayType(row, referenceTableName) {
			if (referenceTableName === CASH_TYPE.TRANSFER) {
				if (row.selfBankCardType !== row.otherBankCardType) {
					return '银承互转';
				}
				if (row.selfBankCardType === BankAcceptanceType.ACCEPTANCE) return '承兑';
				if (row.selfBankCardType === BankAcceptanceType.BANK_CASH) return '银行活期存款';
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
			this.$refs.uploadFile.clearFileList();
			this.clearAcceptanceFillStatus();
			this.$bus.$emit('changeFlag', false);
			this.$refs.otherSelectBankType.localSelectType = null;
			this.$refs.selfSelectBankType.localSelectType = null;
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				transactionTime: parseTime(new Date()),
				sourceId: null,
				targetId: null,
				amount: null,
				referenceTableId: null,
				referenceTableName: null,
				attachment: null,
				remarks: null,
				// 收入方与支付方的公司类型
				sourceCompanyType: '客户',
				targetCompanyType: '客户',
				// 收入方与支付方的银行卡账户类型
				selfBankCardType: null,
				otherBankType: null,
				// 2025-2-28 新增转账账户
				sourceBankNo: null,
				targetBankNo: null,
				params: {
					bankacceptance: null
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
			// 根据类型赋值
			this.reset();
			const id = row.id || this.ids;
			// 添加现金记账记录
			this.handleAddRecord(id);
		},
		/**
		 * 添加现金记账记录
		 * @param id 冲抵记录id
		 */
		handleAddRecord(id) {
			getRecord(id).then(response => {
				const data = response.data;
				this.form = data;
				this.cashType = data.referenceTableName;
				this.$nextTick(() => {
					// 公共字段填充逻辑
					this.sourceName = data.sourceCompanyName;
					this.targetName = data.targetCompanyName;
					this.form.sourceId = data.sourceId;
					this.form.targetId = data.targetId;
					this.form.referenceTableName = data.referenceTableName;
					this.form.referenceTableId = data.referenceTableId;
					this.form.amount = data.amount;
					this.form.transactionTime = data.transactionTime;
					this.form.remarks = data.remarks;

					// 根据冲抵类型填充特定字段
					if (this.cashType === CASH_TYPE.OFF_SETTING) {
						// 如果是冲抵货款
						this.form.targetCompanyType = data.targetCompanyType;
						this.form.sourceCompanyType = data.sourceCompanyType;
					} else {
						// 如果是内部转账
						this.form.sourceCompanyType = PUBLIC_DICT_TYPE.SELF_COMPANY;
						this.form.targetCompanyType = PUBLIC_DICT_TYPE.SELF_COMPANY;
						// 填充转账账户和目标账户
						this.form.sourceBankNo = data.sourceBankNo;
						this.form.targetBankNo = data.targetBankNo;
						// 填充己方和对方银行卡类型
						this.$refs.selfSelectBankType.localSelectType = data.selfBankCardType;
						this.$refs.otherSelectBankType.localSelectType = data.otherBankCardType;
					}
				});

				this.open = true;
				this.title = '修改冲抵款';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (!valid) return;
				// 提取公共逻辑
				this.form = excludeParams(this.form, this.$exclude);
				// 判断是修改还是新增
				if (this.form.id != null) {
					this.updateRecordInfo();
					this.$bus.$emit('changeFlag', false);
				} else {
					this.addRecordInfo();
					this.$bus.$emit('changeFlag', false);
				}
			});
		},

		// 修改记录
		updateRecordInfo() {
			updateRecord(this.form).then(() => {
				this.onSuccess('修改成功');
			});
		},

		// 新增记录
		addRecordInfo() {
			if (this.cashType === CASH_TYPE.OFF_SETTING) {
				this.handleOffsetting();
			} else {
				this.handleTransfer();
			}
		},

		// 处理冲抵货款逻辑
		handleOffsetting() {
			this.form.referenceTableName = TableName.OFFSETTING;
			this.form.referenceTableId = -1;
			addRecord(this.form).then(() => {
				this.onSuccess('新增成功', true);
			});
		},

		// 处理内部转账逻辑
		handleTransfer() {
			const selfType = this.$refs.selfSelectBankType.localSelectType;
			const otherType = this.$refs.otherSelectBankType.localSelectType;
			if (selfType !== otherType) {
				if (selfType === BankAcceptanceType.ACCEPTANCE) {
					this.form.params.bankacceptance.billType = PayType.PAYMENT;
				}
				if (otherType === BankAcceptanceType.ACCEPTANCE) {
					this.form.params.bankacceptance.billType = PayType.RECEIVE;
				}
			}
			// 填充表单的公司类型和转账相关信息
			this.form.sourceCompanyType = PUBLIC_DICT_TYPE.SELF_COMPANY;
			this.form.targetCompanyType = PUBLIC_DICT_TYPE.SELF_COMPANY;
			// 填充转账类型表
			this.form.referenceTableName = CASH_TYPE.TRANSFER;
			this.form.referenceTableId = -1;
			addRecord(this.form).then(() => {
				this.onSuccess('新增成功', true, true);
				// 清除承兑信息状态
				this.clearAcceptanceFillStatus();
				this.$refs.selfSelectBankType.localSelectType = null;
				this.$refs.otherSelectBankType.localSelectType = null;
			});
		},
		// 公共成功处理逻辑
		onSuccess(message, resetForm = false, resetEachInfo = false) {
			this.$modal.msgSuccess(message);
			this.open = false;
			this.getList();
			this.$refs.uploadFile.clearFileList();
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
		// 关闭表单时清除localStorage中的承兑信息填写状态
		clearAcceptanceFillStatus() {
			// 清除所有与承兑相关的状态
			localStorage.removeItem('bankAcceptanceFilled');
			localStorage.removeItem('bankAcceptanceFilledTime');
			localStorage.removeItem('sharedBankAcceptanceFilled');
			// 清除特定实例的状态
			localStorage.removeItem(`bankAcceptanceFilled_income-${this.form.id || 'new'}`);
			localStorage.removeItem(`bankAcceptanceFilled_expense-${this.form.id || 'new'}`);
			// 清除可能存在的其他相关状态
			Object.keys(localStorage).forEach(key => {
				if (key.startsWith('bankAcceptanceFilled_') || key.includes('BankAcceptance')) {
					localStorage.removeItem(key);
				}
			});
		},

		// 确保对话框关闭时也清理状态
		handleDialogClose() {
			this.clearAcceptanceFillStatus();
		},

		// 在组件销毁时也清理状态
		beforeDestroy() {
			this.clearAcceptanceFillStatus();
		}
	}
};
</script>
