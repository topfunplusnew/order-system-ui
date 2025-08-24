<template>
	<div class="app-container">
		<!--    刷新行-->
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
		</el-row>

		<!--    搜索条件栏目-->
		<hr color="#e6e6e6" />
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="queryParams.params.beginTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="queryParams.params.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />

		<!--    操作行的部分-->
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button size="mini" type="danger" @click="handleAdd">添加借出款信息</el-button>
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
						<el-button v-hasPermi="['system:company:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<!--    数据表格 主要是借出款记录-->
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="lendMoneyList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
		>
			<el-table-column v-if="columns[0].visible" label="借款人" align="center" prop="target" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="对象类型" align="center" prop="targetType" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="借出金额" align="center" prop="moneyAmount" show-overflow-tooltip />
			<el-table-column v-if="columns[11].visible" label="未收回金额" align="center" prop="unrecoveredAmount" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="对方收借款账号" align="center" prop="targetBankNo" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="对方户名" align="center" prop="targetAcountsName" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="对方开户行" align="center" prop="targetBankName" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="我方支付借款账户名称" align="center" prop="selfAcountsName" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="我方支付借款开户行" align="center" prop="selfBankName" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="我方付款账号" align="center" prop="selfBankNo" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="支付员工/外面公司在我公司借款时间" align="center" prop="futuresDate" show-overflow-tooltip />
			<el-table-column v-if="columns[10].visible" label="借款事由" align="center" prop="reason" show-overflow-tooltip />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-dropdown trigger="click">
						<el-button size="mini" type="text">
							操作
							<i class="el-icon-arrow-down el-icon--right"></i>
						</el-button>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item @click.native="checkDetail(scope.row)">查看历史收回</el-dropdown-item>
							<el-dropdown-item @click.native="applyForPayment(scope.row)">坏账损失</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:lendmoney:remove']" @click.native="handleGetBackMoney(scope.row)">收回资金</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:lendmoney:edit']" @click.native="handleUpdate(scope.row)">修改</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:lendmoney:remove']" @click.native="handleDelete(scope.row)" style="color: red">删除</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
					<el-button v-if="scope.row.checkState === '审核中'" size="mini" type="warning" disabled style="margin-left: 8px">审核中</el-button>
				</template>
			</el-table-column>
		</el-table>

		<!--    分页-->

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!--    查看历史收回-->
		<InfoDialog title="历史还款记录" :visible.sync="dialogHistoryVisible" :width="'620px'">
			<template #info>
				<el-table
					v-if="recoverMoneyList.length !== 0"
					:data="recoverMoneyList"
					size="mini"
					:cell-style="
						() => {
							return { padding: '2px' };
						}
					"
					border
					:span-method="mergeCells"
				>
					<el-table-column prop="" width="180">
						<template #default="scope">
							<span v-if="scope.$index === 0">借出资金收回</span>
						</template>
					</el-table-column>
					<el-table-column prop="recoverDate" label="时间" width="180"></el-table-column>
					<el-table-column prop="moneyAmount" label="收回金额"></el-table-column>
					<!--          操作列-->
					<!--					<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="240" fixed="right">-->
					<!--						<template slot-scope="scope">-->
					<!--							<el-button size="mini" type="primary" @click="handleUpdateRecoverMoney(scope.row)" v-hasPermi="['system:recovermoney:edit']">修改</el-button>-->
					<!--							<el-button v-hasPermi="['system:recovermoney:remove']" size="mini" type="danger" @click="handleDeleteRecoverMoney(scope.row)">删除</el-button>-->
					<!--						</template>-->
					<!--					</el-table-column>-->
				</el-table>
				<pagination v-show="detailTotal > 0" :total="detailTotal" :page.sync="queryRepaymentParams.pageNum" :limit.sync="queryRepaymentParams.pageSize" @pagination="getRepaymentMoneyList" />
			</template>
		</InfoDialog>

		<!--    导出弹窗-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="请选择导出时间段"
			:visible.sync="dialogVisible"
			width="30%"
		>
			<el-form ref="queryForm" :model="queryParams" size="mini" label-width="68px">
				<el-form-item label="开始时间" prop="beginTime">
					<el-date-picker v-model="queryParams.beginTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
				<el-form-item label="结束时间" prop="endTime">
					<el-date-picker v-model="queryParams.endTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="handleSubmitTime">导 出</el-button>
			</span>
		</el-dialog>

		<!--    收回资金的弹窗-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="收回资金操作"
			:visible.sync="giveRecoverMoneyShow"
			width="40%"
			append-to-body
		>
			<el-row>
				<el-form :model="recoverMoneyEntity" label-width="120" :rules="receiveRules">
					<el-form-item label="收回账户" prop="acountsName">
						<el-row>
							<el-col :span="10">
								<el-input v-model="recoverMoneyEntity.acountsName" placeholder="请输入收回账户" />
							</el-col>
							<el-col :span="4">
								<SearchOption
									:get-data="listBankAccount"
									icon="el-icon-search"
									:limit-info="{ acountsType: '己方公司' }"
									query-label="户名查找"
									query-info="acountsName"
									:query-name="queryBank"
									@commitBack="handleCommitBackBankAcountForm"
									@update:queryName="handleUpdateQueryBankAcountForm"
								>
									<template #table-columns>
										<el-table-column label="账户类型" align="center" prop="acountsType" />
										<el-table-column label="己方公司" align="center" prop="displayName" />
										<el-table-column label="开户行" align="center" prop="bankName" />
										<el-table-column label="开户名" align="center" prop="acountsName" />
										<el-table-column label="账号" align="center" prop="bankNo" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="收回账号" prop="bankNo">
						<el-input v-model="recoverMoneyEntity.bankNo" placeholder="请输入收回账号" />
					</el-form-item>
					<el-form-item label="收回金额" prop="moneyAmount">
						<el-input v-model="recoverMoneyEntity.moneyAmount" placeholder="请输入收回金额" />
					</el-form-item>
					<el-form-item label="收回日期" prop="payDate">
						<el-date-picker v-model="recoverMoneyEntity.recoverDate" type="datetime" placeholder="请选择收回日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
					</el-form-item>
					<el-form-item label="备注信息" prop="comments">
						<el-input v-model="recoverMoneyEntity.comments" placeholder="请输入备注信息" />
					</el-form-item>
					<el-form-item>
						<el-button type="primary" @click="RecoverMoney">收款</el-button>
						<el-button type="primary" @click="resetRecoverMoney">取消</el-button>
					</el-form-item>
				</el-form>
			</el-row>
		</el-dialog>

		<!--    付款申请-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="付款申请" :visible.sync="applyDialogVisible" width="45%">
			<keep-alive>
				<ApplyPayment
					:extra-information="{
						__customizeSubjectName: this.customizeSubjectName,
						__isPayment: true,
						__futuresNO: this.currentFuturesNO
					}"
					:table-name="TableName.LEND_MONEY"
					:t-i-d="tid"
					:need-money="needMoney"
					:need-info="needInfo"
					@changeOpen="changeOpen"
					:money-input-disabled="false"
				/>
			</keep-alive>
		</el-dialog>

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1000px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="160px">
				<el-row>
					<el-col :span="12">
						<el-form-item label="支付时间" prop="futuresDate">
							<el-date-picker v-model="form.futuresDate" type="datetime" placeholder="请选择支付时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>
						<el-form-item label="金额" prop="moneyAmount">
							<el-input v-model="form.moneyAmount" placeholder="请输入保证金金额" />
						</el-form-item>
						<el-form-item label="对象" prop="target">
							<el-input v-model="form.target" placeholder="请输入对象(员工姓名、公司名称)" />
						</el-form-item>
						<!-- 
											<el-form-item label="对方类型" prop="targetType">
												<el-select v-model="form.targetType" placeholder="请选择对方类型">
													<el-option :label="'员工'" :value="PUBLIC_DICT_TYPE.EMPLOYEE"></el-option>
													<el-option :label="'供应商'" :value="PUBLIC_DICT_TYPE.SUPPLIER"></el-option>
													<el-option :label="'客户'" :value="PUBLIC_DICT_TYPE.CUSTOMER"></el-option>
												</el-select>
											</el-form-item> -->
						<el-form-item label="对方账户" prop="targetAcountsName">
							<el-row>
								<el-col :span="10">
									<el-input disabled v-model="form.targetAcountsName" placeholder="请选择" />
								</el-col>
								<el-col :span="3">
									<SearchOption
										title="对方账户"
										:get-data="listBankAccount"
										icon="el-icon-search"
										:limit-info="{
											acountsType: PUBLIC_DICT_TYPE.EMPLOYEE
										}"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										@commitBack="handleCommitBack"
										@update:queryName="handleUpdateQueryName"
									>
										<template #table-columns>
											<el-table-column label="员工户名" align="center" prop="acountsName" />
											<el-table-column label="开户行" align="center" prop="bankName" />
											<el-table-column label="开户名" align="center" prop="acountsName" />
											<el-table-column label="账号" align="center" prop="bankNo" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="对方账号" prop="targetBankNo">
							<el-input disabled v-model="form.targetBankNo" placeholder="请选择" />
						</el-form-item>
						<el-form-item label="对方开户行" prop="targetBankName">
							<el-input disabled v-model="form.targetBankName" placeholder="请选择" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="我方支付账户" prop="selfAcountsName">
							<el-row>
								<el-col :span="10">
									<el-input disabled v-model="form.selfAcountsName" placeholder="请选择" />
								</el-col>
								<el-col :span="3">
									<SearchOption
										:get-data="listBankAccount"
										icon="el-icon-search"
										:limit-info="{
											acountsType: '己方公司'
										}"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										@commitBack="handleCommitBackSelf"
										@update:queryName="handleUpdateQueryName"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" />
											<el-table-column label="己方公司" align="center" prop="displayName" />
											<el-table-column label="开户行" align="center" prop="bankName" />
											<el-table-column label="开户名" align="center" prop="acountsName" />
											<el-table-column label="账号" align="center" prop="bankNo" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="我方账号" prop="selfBankNo">
							<el-input disabled v-model="form.selfBankNo" placeholder="请选择" />
						</el-form-item>
						<el-form-item label="我方开户行" prop="selfBankName">
							<el-input disabled v-model="form.selfBankName" placeholder="请选择" />
						</el-form-item>
						<el-form-item label="事由" prop="reason">
							<el-input v-model="form.reason" placeholder="请输入事由" />
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" />
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    修改记录的修改-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			:title="recoverMoneyTitle"
			:visible.sync="recoverMoneyOpen"
			width="500px"
			append-to-body
		>
			<el-form ref="recover_form" :model="recoverMoneyForm" :rules="recoverMoneyRules" label-width="80px">
				<el-form-item label="收回金额" prop="moneyAmount">
					<el-input v-model="recoverMoneyForm.moneyAmount" placeholder="请输入收回金额" />
				</el-form-item>
				<el-form-item label="收回日期" prop="recoverDate">
					<el-input v-model="recoverMoneyForm.recoverDate" placeholder="请输入收回日期" />
				</el-form-item>
				<el-form-item label="收回账户" prop="acountsName">
					<el-input v-model="recoverMoneyForm.acountsName" placeholder="请输入收回账户" />
				</el-form-item>
				<el-form-item label="收回账号" prop="bankNo">
					<el-input v-model="recoverMoneyForm.bankNo" placeholder="请输入收回账号" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="recoverMoneyForm.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitRecoverMoneyForm">确 定</el-button>
				<el-button @click="cancelRecoverMoneyForm">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { addRecoverMoney, delRecoverMoney, getRecoverMoney, listRecoverMoney, updateRecoverMoney } from '../../../api/system/recoverMoney';
import { addDateRange, parseTime } from '../../../utils/ruoyi';
import InfoDialog from '../../../components/InfoDialog.vue';
import { addLendMoney, delLendMoney, getLendMoney, listLendMoney, updateLendMoney } from '@/api/system/lendMoney';
import { excludeParams } from '@/api/tool/exclude';
import { ReceiveType, TableName } from '@/api/tool/enums';
import SearchOption from '@/components/SearchOption.vue';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';

import { listBankAccount } from '@/api/system/bankAccount';
import { mixin_reviveMoney } from '@/views/dashboard/mixins/receive';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { getSubjectLevelTree } from '@/api/system/subject';
import { getConfigKey } from '@/api/system/config';
import _ from 'lodash';

export default {
	name: 'EmployeeLendMoney',
	computed: {
		TableName() {
			return TableName;
		},
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		}
	},
	components: { ApplyPayment, SearchOption, InfoDialog },
	dicts: ['order_target_type'],
	mixins: [mixin_printHTML, mixin_reviveMoney],
	data() {
		return {
			loading: true,
			ids: [],
			showSearch: true,
			// 表格中的数据
			total: 0,
			// 表格中的数据
			lendMoneyList: [],
			// 表格的查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 50,
				futuresNO: null,
				futuresMarginCompany: null,
				targetType: null,
				target: null,
				moneyAmount: null,
				targetAcountsName: null,
				targetBankNo: null,
				targetBankName: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				futuresDate: null,
				reason: null,
				comments: null,
				params: {
					beginTime: null,
					endTime: null
				}
			},
			// 添加或者修改
			title: '',
			open: false,
			// 表单校验
			columns: [
				{ key: 0, label: '借款人', prop: 'target', visible: true },
				{ key: 1, label: '对象', prop: 'targetType', visible: true },
				{
					key: 2,
					label: '借入金额',
					prop: 'moneyAmount',
					visible: true
				},
				{
					key: 11,
					label: '未收回金额',
					prop: 'unrecoveredAmount',
					visible: true
				},
				{
					key: 3,
					label: '对方收借款账号',
					prop: 'targetBankNo',
					visible: true
				},
				{
					key: 4,
					label: '对方户名',
					prop: 'targetAcountsName',
					visible: true
				},
				{
					key: 5,
					label: '对方开户行',
					prop: 'targetBankName',
					visible: true
				},
				{
					key: 6,
					label: '我方支付借款账户名称',
					prop: 'selfAcountsName',
					visible: true
				},
				{
					key: 7,
					label: '我方支付借款开户行',
					prop: 'selfBankName',
					visible: true
				},
				{
					key: 8,
					label: '我方付款账号',
					prop: 'selfBankNo',
					visible: true
				},
				{
					key: 9,
					label: '支付员工/外面公司在我公司借款时间',
					prop: 'futuresDate',
					visible: true
				},
				{ key: 10, label: '借款事由', prop: 'reason', visible: true }
			],

			// 搜索参数
			timesQuery: {
				beginTime: '',
				endTime: '',
				objectType: ''
			},
			// 详细的还款记录
			recoverMoneyList: [],
			dialogVisible: false,
			// 查看信息的分页
			detailTotal: 0,
			queryRepaymentParams: {
				pageNum: 1,
				pageSize: 20
			},
			dialogHistoryVisible: false,
			form: {},
			// 添加借给员工的表单校验
			rules: {
				// 添加校验
				futuresNO: [
					{
						required: true,
						message: '期货编号不能为空',
						trigger: 'blur'
					}
				],
				targetType: [
					{
						required: true,
						message: '对象类型不能为空',
						trigger: 'blur'
					}
				],

				target: [{ required: true, message: '对象不能为空', trigger: 'blur' }],

				moneyAmount: [
					{
						required: true,
						message: '保证金金额不能为空',
						trigger: 'blur'
					},
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

				targetAcountsName: [
					{
						required: true,
						message: '对方账户不能为空',
						trigger: 'blur'
					}
				],

				targetBankNo: [
					{
						required: true,
						message: '对方银行账号不能为空',
						trigger: 'blur'
					}
				],

				selfAcountsName: [
					{
						required: true,
						message: '我方账户不能为空',
						trigger: 'blur'
					}
				],

				selfBankNo: [
					{
						required: true,
						message: '我方银行账号不能为空',
						trigger: 'blur'
					}
				],

				selfBankName: [
					{
						required: true,
						message: '我方银行不能为空',
						trigger: 'blur'
					}
				],

				futuresDate: [
					{
						required: true,
						message: '支付期货保证金日期不能为空',
						trigger: 'blur'
					}
				],
				reason: [{ required: true, message: '请输入是由!', trigger: 'blur' }]
			},
			// 收回资金弹窗
			giveRecoverMoneyShow: false,
			// 借出款收回信息实体
			recoverMoneyEntity: {
				acountsName: '',
				bankNo: '',
				targetType: null
			},
			// 收款信息实体
			receiveMoneyEntity: {},
			applyDialogVisible: false,
			tid: '',
			needMoney: 0,
			needInfo: {},
			customizeSubjectName: null,
			currentFuturesNO: null,
			queryBank: null,
			receiveRules: {
				acountsName: [
					{
						required: true,
						message: '收回账户不能为空',
						trigger: 'blur'
					}
				],
				bankNo: [
					{
						required: true,
						message: '收回账号不能为空',
						trigger: 'blur'
					}
				],
				moneyAmount: [
					{
						required: true,
						message: '收回金额不能为空',
						trigger: 'blur'
					},
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
				payDate: [
					{
						required: true,
						message: '收回日期不能为空',
						trigger: 'blur'
					}
				]
			},
			// 弹窗中借出资金回收的钱
			recoverMoneyForm: {},
			recoverMoneyTitle: '',
			recoverMoneyOpen: false,
			recoverMoneyRules: {
				moneyAmount: [
					{
						required: true,
						message: '收回金额不能为空',
						trigger: 'blur'
					},
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
				recoverDate: [
					{
						required: true,
						message: '收回日期不能为空',
						trigger: 'blur'
					}
				],
				acountsName: [
					{
						required: true,
						message: '收回账户不能为空',
						trigger: 'blur'
					}
				],
				bankNo: [
					{
						required: true,
						message: '收回账号不能为空',
						trigger: 'blur'
					}
				],
				comments: [
					{
						required: true,
						message: '备注不能为空',
						trigger: 'blur'
					}
				]
			}
		};
	},
	created() {
		this.getList();
	},
	methods: {
		listBankAccount,
		getList() {
			this.loading = true;
			listLendMoney(this.queryParams).then(response => {
				this.lendMoneyList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 操作列相关函数 包括 查看历史收回 付款申请 收回资金 修改 删除
		checkDetail(row) {
			this.getRepaymentMoneyList(row);
		},
		applyForPayment(row) {
			this.tid = row.id;
			this.needMoney = row.moneyAmount;
			this.needInfo = {
				bankNo: row.selfBankNo,
				acountsName: row.selfAcountsName,
				bankName: row.selfBankName,
				companyId: 0,
				companyType: this.PUBLIC_DICT_TYPE.SELF_COMPANY
			};
			this.currentFuturesNO = row.futuresNO;
			this.applyDialogVisible = true;
		},

		// 点击收回资金按钮
		handleGetBackMoney(row) {
			// 初始化表的信息
			this.initReviveMoneyTableInfo(row.id, ReceiveType.LEND_MONEY_GET_BACK, TableName.LEND_MONEY);
			// 初始化对方账户信息
			this.initReviveMoneyOtherAccountInfo(row.targetAcountsName, row.targetBankNo, row.targetBankName);
			// 打开添加借出款收回的信息弹窗
			this.recoverMoneyEntity.futuresNO = row.futuresNO; // 初始化uuid
			// 赋值收款信息
			this.initComment('借出款收回');
			this.giveRecoverMoneyShow = true;
		},
		// 修改按钮操作
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getLendMoney(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改向外部借出款信息';
			});
		},
		// 删除按钮操作
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除向外部借出款信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delLendMoney(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		reset() {
			this.form = {
				id: null,
				futuresNO: null,
				futuresMarginCompany: null,
				targetType: null,
				target: null,
				moneyAmount: null,
				targetAcountsName: null,
				targetBankNo: null,
				targetBankName: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				futuresDate: null,
				reason: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.resetForm('form');
		},
		// 搜索栏
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加向外部借出款信息';
			// 默认对方类型可选，若需要默认值可加如下行
			this.form.targetType = this.PUBLIC_DICT_TYPE.EMPLOYEE;
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					this.form = excludeParams(this.form, this.$exclude);
					// 不再写死 targetType，直接用表单选择的
					if (this.form.id != null) {
						updateLendMoney(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addLendMoney(this.form).then(response => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		getRepaymentMoneyList(row) {
			// 查询
			listRecoverMoney({
				futuresNO: row.futuresNO,
				...this.queryRepaymentParams
			}).then(res => {
				this.recoverMoneyList = res.rows;
				this.detailTotal = res.total;
				if (res.rows.length === 0) {
					this.$message.error('暂无数据');
				} else {
					this.$message.success('查询成功');
					this.dialogHistoryVisible = true;
				}
			});
		},
		mergeCells({ row, column, rowIndex, columnIndex }) {
			if (columnIndex === 0) {
				// 合并第一列 "期货保证金收回"
				if (rowIndex === 0) {
					return {
						rowspan: this.recoverMoneyList.length,
						colspan: 1
					};
				} else {
					return {
						rowspan: 0,
						colspan: 0
					};
				}
			}
		},
		refresh() {
			this.getList();
		},
		handleSubmitTime() {
			this.download(
				'statistics/export/lendMoney',
				{
					...this.queryParams
				},
				`从我司借款${parseTime(new Date().getTime())}.xlsx`
			);
			this.dialogVisible = false;
		},
		/** 导出按钮操作 */
		handleExport() {
			this.dialogVisible = true;
		},
		changeOpen() {
			this.needMoney = 0;
			this.applyDialogVisible = false;
			this.getList();
		},
		// 收回资金的搜索按钮自动填充方法
		handleUpdateQueryBankAcountForm(val) {
			this.queryBank = val;
		},
		handleCommitBack(val) {
			this.form.targetBankNo = val.bankNo;
			this.form.targetBankName = val.bankName;
			this.form.targetAcountsName = val.acountsName;
		},
		handleUpdateQueryName(val) {
			this.queryBank = val;
		},
		handleCommitBackSelf(val) {
			this.form.selfBankNo = val.bankNo;
			this.form.selfBankName = val.bankName;
			this.form.selfAcountsName = val.acountsName;
		},
		// 修改对方账户类型
		changeCustomSelfBankType(value) {
			this.recoverMoneyEntity.selfBankCardType = value;
		},
		// 收回资金 首先添加借出款收回信息
		RecoverMoney() {
			this.initReceiveTime(this.recoverMoneyEntity.recoverDate);
			addRecoverMoney(this.recoverMoneyEntity).then(res => {
				this.$modal.msgSuccess('添加借出款收回信息成功~');
				// 同时也要添加到收款信息中
				// this.addReviveMoneyInfo()
				this.giveRecoverMoneyShow = false;
				this.resetRecoverMoney();
			});
		},
		resetRecoverMoney() {
			this.recoverMoneyEntity = {
				futuresNO: null,
				targetType: null,
				target: null,
				moneyAmount: null,
				targetAcountsName: null,
				targetBankNo: null,
				targetBankName: null,
				selfAcountsName: null,
				selfBankCardType: null,
				selfBankNo: null,
				selfBankName: null,
				recoverDate: null,
				reason: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			};
			this.giveRecoverMoneyShow = false;
		},
		handleCommitBackBankAcountForm(val) {
			// 初始化我方账户信息
			this.initReviveMoneySelfAccountInfo(val.acountsName, val.bankNo, val.bankName, val.id);
			this.recoverMoneyEntity.acountsName = val.acountsName;
			this.recoverMoneyEntity.bankNo = val.bankNo;
		},
		// 收回资金弹窗内的修改
		handleUpdateRecoverMoney(row) {
			this.resetRecoverMoneyForm();
			const id = row.id || this.ids;
			getRecoverMoney(id).then(response => {
				this.recoverMoneyForm = response.data;
				this.recoverMoneyOpen = true;
				this.recoverMoneyTitle = '修改借出款收回信息';
			});
		},
		handleDeleteRecoverMoney(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delRecoverMoney(ids);
				})
				.then(() => {
					this.getRecoverMoneyList();
					this.$modal.msgSuccess('删除成功');
				});
		},
		resetRecoverMoneyForm() {
			this.recoverMoneyForm = {
				id: null,
				futuresNO: null,
				recoverNO: null,
				moneyAmount: null,
				recoverDate: null,
				acountsName: null,
				bankNo: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.resetForm('recover_form');
		},
		submitRecoverMoneyForm() {
			this.$refs['recover_form'].validate(valid => {
				if (valid) {
					if (this.recoverMoneyForm.id != null) {
						this.recoverMoneyForm = excludeParams(this.recoverMoneyForm, this.$exclude);
						updateRecoverMoney(this.recoverMoneyForm).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.recoverMoneyOpen = false;
							this.getRecoverMoneyList();
						});
					} else {
						this.recoverMoneyForm = excludeParams(this.recoverMoneyForm, this.$exclude);
						addRecoverMoney(this.recoverMoneyForm).then(response => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getRecoverMoneyList();
						});
					}
				}
			});
		},
		getRecoverMoneyList() {
			this.loading = true;
			listRecoverMoney(addDateRange(this.queryParams, this.dateRange)).then(response => {
				this.recoverMoneyList = response.rows;
				this.detailTotal = response.total;
				this.loading = false;
			});
		},
		cancelRecoverMoneyForm() {
			this.recoverMoneyOpen = false;
			this.recoverMoneyReset();
		},
		recoverMoneyReset() {
			this.recoverMoneyForm = {
				id: null,
				futuresNO: null,
				recoverNO: null,
				moneyAmount: null,
				recoverDate: null,
				acountsName: null,
				bankNo: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.resetForm('recover_form');
		}
	}
};
</script>
