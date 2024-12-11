<template>
	<div class="app-container">
		<el-form
			v-show="showSearch"
			ref="queryForm"
			:model="queryParams"
			size="mini"
			:inline="true"
			label-width="120px"
		>
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
				<el-select
					v-model="queryParams.companyType"
					placeholder="请选择对象类型"
					class="w-85px"
					clearable
				>
					<el-option
						v-for="item in options_companyType"
						:key="item.value"
						:label="item.label"
						:value="item.value"
					></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="付款类型" prop="payType">
				<el-cascader
					v-model="queryParams.payType"
					:options="paymentTypeTree"
					:props="props"
					@change="handleChange"
				></el-cascader>
			</el-form-item>
			<el-form-item label="户名" prop="selfBankName">
				<el-input
					v-model="queryParams.selfBankName"
					placeholder="请输入己方户名"
					clearable
					class="w-85px"
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="对方银行卡号" prop="selfBankID">
				<el-input
					v-model="queryParams.otherBankNo"
					placeholder="请输入对方银行卡号"
					clearable
					class="w-85px"
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-input
					v-model="queryParams.otherAcountsName"
					placeholder="请输入对方户名"
					clearable
					class="w-85px"
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="备注" prop="otherBankNo">
				<el-input
					v-model="queryParams.comments"
					placeholder="请输入备注"
					clearable
					class="w-85px"
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="复核状态" prop="auditState">
				<el-select
					v-model="queryParams.auditState"
					placeholder="请选择复核状态"
					clearable
				>
					<el-option
						v-for="item in auditState_options"
						:key="item.value"
						:label="item.label"
						:value="item.value"
					></el-option>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
				>
					搜索
				</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<!-- 刷新按钮-->
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">
					刷新
				</el-button>
			</el-col>
			<!--      解开了新增付款信息-->
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:payment:add']"
					type="danger"
					size="mini"
					@click="handleAdd"
				>
					新增付款信息
				</el-button>
			</el-col>
			<right-toolbar
				:showSearch.sync="showSearch"
				:columns="columns"
				@queryTable="getList"
			>
				<template #print>
					<el-col :span="1.5">
						<el-button
							plain
							icon="el-icon-printer"
							size="mini"
							@click="printHTML"
						></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button
							v-hasPermi="['system:payment:export']"
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						></el-button>
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
					return { padding: '2px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column label="id" align="center" prop="id" />
			<el-table-column
				label="日期"
				align="center"
				prop="fundsDate"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="fundsDate" />
				</template>
			</el-table-column>
			<el-table-column
				label="支付类型"
				align="center"
				prop="payType"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="payType" />
				</template>
			</el-table-column>
			<el-table-column
				label="金额"
				align="center"
				prop="moneyAmount"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="moneyAmount" />
				</template>
			</el-table-column>
			<el-table-column
				label="己方户名"
				align="center"
				prop="selfAcountsName"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="selfAcountsName" />
				</template>
			</el-table-column>
			<el-table-column
				label="己方账号"
				align="center"
				prop="selfBankNo"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="selfBankNo" />
				</template>
			</el-table-column>
			<el-table-column
				label="己方开户行"
				align="center"
				prop="selfBankName"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="selfBankName" />
				</template>
			</el-table-column>
			<el-table-column
				label="对方户名"
				align="center"
				prop="otherAcountsName"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="otherAcountsName" />
				</template>
			</el-table-column>
			<el-table-column
				label="对方账号"
				align="center"
				prop="otherBankNo"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="otherBankNo" />
				</template>
			</el-table-column>
			<el-table-column
				label="对方开户行"
				align="center"
				prop="otherBankName"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="otherBankName" />
				</template>
			</el-table-column>
			<el-table-column
				label="支付状态"
				align="center"
				prop="paymentState"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="paymentState" />
				</template>
			</el-table-column>
			<el-table-column
				label="对方公司"
				align="center"
				prop="companyName"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="companyName" />
				</template>
			</el-table-column>
			<el-table-column
				label="对方公司类型"
				align="center"
				prop="companyType"
				width="120"
				show-overflow-tooltip
			>
				<template #default="scope">
					<DynamicField :row="scope.row" field="companyType" />
				</template>
			</el-table-column>
			<el-table-column
				label="备注"
				align="center"
				prop="comments"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				label="复核状态"
				align="center"
				class-name="small-padding fixed-width"
				width="80"
				fixed="right"
			>
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
			<el-table-column
				label="操作"
				align="center"
				class-name="small-padding fixed-width"
				width="150"
				fixed="right"
			>
				<template slot-scope="scope">
					<el-button
						v-if="scope.row.paymentState === '未支付'"
						v-hasPermi="['system:payment:edit']"
						size="mini"
						type="text"
						@click="handleUpdate(scope.row)"
					>
						付款
					</el-button>
					<el-button
						v-else-if="scope.row.paymentState === '已支付'"
						v-hasPermi="['system:payment:edit']"
						size="mini"
						disabled
						type="success"
					>
						已付款
					</el-button>
					<el-button v-else size="mini" disabled type="warning">
						申请中
					</el-button>
					<el-button
						v-hasPermi="['system:payment:remove']"
						size="mini"
						type="danger"
						@click="handleDelete(scope.row)"
					>
						删除
					</el-button>
				</template>
			</el-table-column>

			<el-table-column
				label="运费信息"
				align="center"
				class-name="small-padding fixed-width"
				width="150"
				fixed="right"
			>
				<template slot-scope="scope">
					<CheckDetail :row="scope.row" />
				</template>
			</el-table-column>
		</el-table>

		<pagination
			v-show="total > 0"
			:total="total"
			:page.sync="queryParams.pageNum"
			:limit.sync="queryParams.pageSize"
			@pagination="getList"
		/>

		<!--     添加或修改付款信息对话框 -->
		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			title="付款处理"
			:visible.sync="open"
			width="650px"
			append-to-body
		>
			<el-form ref="form" :model="form" :rules="rules" label-width="140px">
				<el-form-item label="日期" prop="fundsDate">
					<el-date-picker
						v-model="form.fundsDate"
						type="datetime"
						placeholder="选择日期"
						value-format="yyyy-MM-dd HH:mm:ss"
					></el-date-picker>
				</el-form-item>
				<!--        付款类型-->
				<el-form-item label="付款类型" prop="payType">
					<el-cascader
						v-model="form.payType"
						:options="paymentTypeTree"
						:props="props"
						@change="handleChange"
					></el-cascader>
				</el-form-item>
				<el-form-item label="金额" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
				</el-form-item>
				<el-form-item label="我方银行账户类型">
					<BankType
						:select-type="form.selfBankCardType"
						@updateSelectedType="changeSelfBankType"
					/>
				</el-form-item>
				<!--        对方信息-->
				<el-form-item label="己方户名" prop="selfAcountsName">
					<el-row>
						<el-col :span="10">
							<el-input
								v-model="form.selfAcountsName"
								placeholder="请输入己方户名"
							/>
						</el-col>
						<el-col :span="3">
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
									<el-table-column
										label="账号类型"
										align="center"
										prop="acountsType"
									/>
									<el-table-column
										label="显示名称"
										align="center"
										prop="displayName"
									/>
									<el-table-column
										label="开户行"
										align="center"
										prop="bankName"
									/>
									<el-table-column
										label="开户名"
										align="center"
										prop="acountsName"
									/>
									<el-table-column label="账号" align="center" prop="bankNo" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="己方账号" prop="selfBankNo">
					<el-input v-model="form.selfBankNo" placeholder="请输入己方账号" />
				</el-form-item>
				<el-form-item label="己方开户行" prop="selfBankName">
					<el-input
						v-model="form.selfBankName"
						placeholder="请输入己方开户行"
					/>
				</el-form-item>
				<el-form-item label="对方类型">
					<el-select v-model="value" placeholder="请选择">
						<el-option
							v-for="item in options"
							:key="item.value"
							:label="item.label"
							:value="item.value"
						></el-option>
					</el-select>
				</el-form-item>

				<!--        下面的操作是 客户id  配合 银行卡信息进行付款.-->
				<!--      选择供应商-->
				<el-row v-if="value === PAYMENT_TYPES.SUPPLIER">
					<el-form-item label="供应商名称" prop="otherAcountsName">
						<el-row>
							<el-col :span="10">
								<!--                <el-input v-model="form.otherAcountsName" placeholder="请输入对方户名"/>-->
								<el-input
									v-model="form.companyName"
									placeholder="请输入供应商名称"
								/>
							</el-col>
							<el-col :span="3">
								<SearchOption
									:limit-info="{ companyType: PAYMENT_TYPES.SUPPLIER }"
									:get-data="listCompany"
									icon="el-icon-search"
									:query-label="'供应商'"
									query-info="companyName"
									:query-name="queryOtherSupplier"
									@update:queryName="handleUpdateQueryNameOtherSupplier"
									@commitBack="handleCommitBackOtherSupplier"
								>
									<template #table-columns>
										<el-table-column
											label="供应商"
											align="center"
											prop="companyName"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="老板姓名"
											align="center"
											prop="leader"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="老板电话"
											align="center"
											prop="leaderTel"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="区域"
											align="center"
											prop="region"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="联系人"
											align="center"
											prop="relationName"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="销售经理"
											align="center"
											prop="salesManager"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="地址"
											align="center"
											prop="address"
											width="150"
											show-overflow-tooltip
										/>
										<el-table-column
											label="电话"
											align="center"
											prop="relationTel"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="备注"
											align="center"
											prop="comments"
											width="180"
											show-overflow-tooltip
										/>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
				</el-row>
				<!--      选择客户-->
				<el-row v-if="value === PAYMENT_TYPES.CUSTOMER">
					<el-form-item label="对方公司" prop="companyName">
						<el-row>
							<el-col :span="10">
								<!--                <el-input v-model="form.otherAcountsName" placeholder="请输入对方户名"/>-->
								<el-input
									v-model="form.companyName"
									placeholder="请输入对方公司"
								/>
							</el-col>
							<el-col :span="3">
								<SearchOption
									:limit-info="{ companyType: PAYMENT_TYPES.CUSTOMER }"
									:get-data="listCompany"
									:query-label="'客户'"
									query-info="companyName"
									:query-name="queryOtherCustomer"
									icon="el-icon-search"
									@update:queryName="handleUpdateQueryNameOtherCustomer"
									@commitBack="handleCommitBackOther"
								>
									<template #table-columns>
										<el-table-column
											label="客户"
											align="center"
											prop="companyName"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="老板姓名"
											align="center"
											prop="leader"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="老板电话"
											align="center"
											prop="leaderTel"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="区域"
											align="center"
											prop="region"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="联系人"
											align="center"
											prop="relationName"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="销售经理"
											align="center"
											prop="salesManager"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="地址"
											align="center"
											prop="address"
											width="150"
											show-overflow-tooltip
										/>
										<el-table-column
											label="电话"
											align="center"
											prop="relationTel"
											width="180"
											show-overflow-tooltip
										/>
										<el-table-column
											label="备注"
											align="center"
											prop="comments"
											width="180"
											show-overflow-tooltip
										/>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
				</el-row>
				<!--      选择司机-->
				<el-row v-if="value === PAYMENT_TYPES.DRIVER">
					<el-form-item label="司机名称" prop="companyName">
						<el-row>
							<el-col :span="10">
								<!--                <el-input v-model="form.otherAcountsName" placeholder="请输入对方户名"/>-->
								<el-input
									v-model="form.companyName"
									placeholder="请输入对方公司"
								/>
							</el-col>
							<el-col :span="3">
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
										<el-table-column
											label="车牌"
											align="center"
											prop="carNo"
											width="200"
										/>
										<el-table-column
											label="司机姓名"
											align="center"
											prop="driver"
											width="200"
										/>
										<el-table-column
											label="司机电话"
											align="center"
											prop="tel"
											width="200"
										/>
										<el-table-column
											label="户名"
											align="center"
											prop="acountsName"
											width="200"
										>
											<template slot-scope="scope">
												{{ isNull(scope.row.acountsName) }}
											</template>
										</el-table-column>
										<el-table-column
											label="银行账号"
											align="center"
											prop="bankNo"
											width="200"
										>
											<template slot-scope="scope">
												{{ isNull(scope.row.bankNo) }}
											</template>
										</el-table-column>
										<el-table-column
											label="开户行"
											align="center"
											prop="bankName"
											width="200"
										>
											<template slot-scope="scope">
												{{ isNull(scope.row.bankName) }}
											</template>
										</el-table-column>
										<el-table-column
											label="运输类型"
											align="center"
											prop="carType"
											width="200"
										/>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
				</el-row>
				<el-form-item label="对方银行账户类型" v-if="value !== '对外付款'">
					<BankType
						:select-type="form.otherBankCardType"
						@updateSelectedType="changeOtherBankType"
					/>
				</el-form-item>
				<el-form-item
					label="对方账号"
					prop="otherBankNo"
					v-if="value !== '对外付款'"
				>
					<el-row>
						<el-col :span="14">
							<el-input
								v-model="form.otherBankNo"
								placeholder="请输入对方账号"
							/>
						</el-col>
						<el-col :span="4">
							<SearchOption
								:limit-info="{ acountsType: value }"
								:get-data="listBankAccount"
								:query-name="queryBankAcount"
								query-label="户名查找"
								query-info="acountsName"
								@commitBack="handleCommitBackBankAcount"
								@update:queryName="handleUpdateQueryBankAcount"
							>
								<template #table-columns>
									<el-table-column
										label="账户类型"
										align="center"
										prop="acountsType"
									/>
									<el-table-column
										label="显示名称"
										align="center"
										prop="displayName"
									/>
									<el-table-column
										label="账号(银行账号)"
										align="center"
										prop="bankNo"
									/>
									<el-table-column
										label="开户行"
										align="center"
										prop="bankName"
									/>
									<el-table-column
										label="公司名称"
										align="center"
										prop="companyName"
									/>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item
					label="对方开户行"
					prop="otherBankName"
					v-if="value !== '对外付款'"
				>
					<el-input
						v-model="form.otherBankName"
						placeholder="请输入对方开户行"
					/>
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确认付款</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    选择银行卡的页面-->
		<el-dialog
			title="请选择付款银行卡"
			:visible.sync="chooseBankDialogVisible"
			width="600px"
		>
			<div>
				<el-form :model="chooseInfo" label-width="150px">
					<el-form-item label="己方银行账户类型" prop="selfBankNo">
						<BankType
							:select-type="chooseInfo.selfBankCardType"
							@updateSelectedType="changeCustomSelfBankType"
						/>
					</el-form-item>
					<el-form-item label="己方户名" prop="selfAcountsName">
						<el-row>
							<el-col :span="10">
								<el-input
									v-model="chooseInfo.selfAcountsName"
									placeholder="请输入己方户名"
								/>
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
										<el-table-column
											label="账号类型"
											align="center"
											prop="acountsType"
										/>
										<el-table-column
											label="显示名称"
											align="center"
											prop="displayName"
										/>
										<el-table-column
											label="开户行"
											align="center"
											prop="bankName"
										/>
										<el-table-column
											label="开户名"
											align="center"
											prop="acountsName"
										/>
										<el-table-column
											label="账号"
											align="center"
											prop="bankNo"
										/>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="己方账号" prop="selfBankNo">
						<el-input
							v-model="chooseInfo.selfBankNo"
							placeholder="请输入己方账号"
						/>
					</el-form-item>
					<el-form-item label="己方开户行" prop="selfBankName">
						<el-input
							v-model="chooseInfo.selfBankName"
							placeholder="请输入己方开户行"
						/>
					</el-form-item>
					<!--          选择对方银行账户类型-->
					<el-form-item label="对方银行账户类型">
						<BankType
							:select-type="chooseInfo.otherBankCardType"
							@updateSelectedType="changeCustomOtherBankType"
						/>
					</el-form-item>
				</el-form>
			</div>
			<span slot="footer" class="dialog-footer">
				<el-button @click="chooseBankDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="handlePayment">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import {
	listPayment,
	delPayment,
	addPayment,
	updatePayment
} from '@/api/system/payment';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { excludeParams } from '@/api/tool/exclude';
import { addDateRange } from '@/utils/ruoyi';
import { listBankAccount } from '../../../api/system/bankAccount';
import { mixin_payment_audit } from '../../dashboard/mixins/payment/payment_audit';
import {
	mixin_payment_select,
	PAYMENT_TYPES
} from '../../dashboard/mixins/payment/payment_select';
import { listCars } from '../../../api/system/cars';
import { isNull } from '../../../main';
import { mixin_payment_subject } from '../../dashboard/mixins/payment/payment_subject';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import DynamicField from '@/components/DynamicField.vue';
import { mixin_paymentindex_fill } from './paymentFill';
import CheckDetail from '../../dashboard/components/payment/CheckDetail.vue';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import { mixin_bankType } from '../../dashboard/mixins/common/common_bankType';

export default {
	name: 'Payment',
	components: {
		BankType,
		CheckDetail,
		DynamicField,
		SearchOption
	},
	mixins: [
		mixin_printHTML,
		mixin_payment_audit,
		mixin_payment_select,
		mixin_payment_subject,
		mixin_paymentindex_fill,
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
			rules: {},
			columns: [
				{ key: 0, label: ` id`, visible: true },
				{ key: 1, label: `日期`, visible: true },
				{ key: 2, label: `支付类型`, visible: true },
				{ key: 3, label: `金额`, visible: true },
				{ key: 4, label: `己方户名`, visible: true },
				{ key: 5, label: `己方账号`, visible: true },
				{ key: 6, label: `己方开户行`, visible: true },
				{ key: 7, label: `对方户名`, visible: true },
				{ key: 8, label: `对方账号`, visible: true },
				{ key: 9, label: `对方开户行`, visible: true },
				{ key: 10, label: `支付状态`, visible: true },
				{ key: 11, label: `对方公司`, visible: true },
				{ key: 12, label: `对方公司类型`, visible: true },
				{ key: 13, label: `备注`, visible: true }
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
			chooseInfo: {}
		};
	},
	computed: {
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
		if (
			localStorage.getItem('payment-columns') === 'null' ||
			!localStorage.getItem('payment-columns')
		) {
			// 设置localStorage
			localStorage.setItem('payment-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('payment-columns'));
		}
	},
	methods: {
		isNull,
		listCars,
		listBankAccount,
		listCompany,
		// 选择己方银行账户类型
		changeCustomSelfBankType(value) {
			this.chooseInfo.selfBankCardType = value;
		},
		// 选择对方银行账户类型
		changeCustomOtherBankType(value) {
			this.chooseInfo.otherBankCardType = value;
		},
		/** 查询付款信息列表 */
		getList() {
			this.loading = true;
			// 把查询条件中的payType转成字符串
			if (this.queryParams.payType) {
				this.queryParams.payType = this.queryParams.payType.join('-');
			}
			// 查询
			listPayment(
				addDateRange(this.queryParams, this.dateRange, 'payment')
			).then(response => {
				this.paymentList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
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
				updateTime: null,
				delFlag: null
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
				// 己方银行账户类型
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
				delFlag: null
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
		// 付款的操作
		handleUpdate(row) {
			// 如果没有己方银行卡信息 需要跳出选择银行卡信息
			if (!row.selfBankID) {
				this.resetChooseInfo();
				this.chooseInfo = row;
				this.chooseBankDialogVisible = true;
				// 如果有己方银行卡的信息了 那么就直接蹦出确定
			} else {
				this.$confirm('是否付款?', '提示', {
					confirmButtonText: '是',
					cancelButtonText: '否',
					type: 'success'
				}).then(() => {
					// 只需要更新状态
					updatePayment({ ...row, paymentState: '已支付' }).then(res => {
						this.$modal.msgSuccess(res.msg);
						this.reset();
						this.getList();
					});
				});
			}
		},
		// 付款处理 用户在弹出的弹窗点击确定
		handlePayment() {
			// 先去除无用参数
			this.chooseInfo = excludeParams(this.chooseInfo, this.$exclude);

			// 对auditState做保证处理
			this.chooseInfo.auditState =
				this.chooseInfo.auditState === null
					? '0'
					: this.chooseInfo.auditState === true
					? '1'
					: '0';

			// 更新付款状态
			updatePayment({ ...this.chooseInfo, paymentState: '已支付' }).then(
				res => {
					this.$modal.msgSuccess(res.msg);
					// 重置弹出窗的付款信息 主要包含己方银行卡的信息
					this.resetChooseInfo();
					this.reset();
					this.chooseBankDialogVisible = false;
					this.getList();
				}
			);
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						this.form.paymentState = '已支付';
						// 修改支付状态
						updatePayment(this.form).then(() => {
							this.$modal.msgSuccess('支付成功~');
							this.open = false;
							this.getList();
						});

						// 新增操作
					} else {
						// 去除参数
						this.form = excludeParams(this.form, this.$exclude);
						// 需要拼凑支付类型  但是不能修改响应式的payType 这是一个数组
						let paymentType = null;
						if (this.form.payType) {
							paymentType = this.form.payType.join('-');
						} else {
							this.$message.warning('请选择付款类型');
							return;
						}
						// 填充公司类型
						this.form.companyType = this.value;
						// 拼凑body
						const body = { ...this.form, payType: paymentType };
						// 添加付款信息
						addPayment(body).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
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
				.confirm(
					'是否确认删除付款信息编号为"' +
						ids +
						'"的数据项？删除后只能通过重新发起付款申请恢复'
				)
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
