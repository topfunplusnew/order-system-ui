<!--付款审核流程页面 需求:渲染需要付款的信息列表，付款信息中有多个审核流程 提供按钮筛选仅
当前账号需要审核的流程 审核的过程调用修改接口-->
<script>
import { getPaymentApply, listPaymentApply, submitPaymentApply } from '@/api/system/paymentApply';
import { listAuditInfoGroup } from '@/api/system/auditInfo';
import StepInfo from '@/views/dashboard/components/applyProcess/StepInfo.vue';
import { mapGetters } from 'vuex';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { mixin_payment_subject } from '@/views/dashboard/mixins/payment/payment_subject';
import { mixin_bankType } from '@/views/dashboard/mixins/common/common_bankType';
import { mixin_paymentindex_fill } from '@/views/system/payment/paymentFill';
import { mixin_payment_select, PAYMENT_TYPES } from '@/views/dashboard/mixins/payment/payment_select';
import { listCompany } from '@/api/system/company';
import { listBankAccount } from '@/api/system/bankAccount';
import CheckFiles from '@/components/CheckFiles.vue';
import { TableName, AuditCheckState, getTagColor } from '@/api/tool/enums';
import { listCars } from '@/api/system/cars';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import _ from 'lodash';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { mixin_tour } from '@/views/dashboard/mixins/tour';
import PAYMENT_APPLY_INFO from '@/components/NeedToShow/PAYMENT_APPLY_INFO.vue';

export default {
	name: 'ApplyProcess',
	components: {
		DialogWrapper,
		ApplyPayment,
		CheckFiles,
		StepInfo
	},
	mixins: [mixin_printHTML, mixin_payment_subject, mixin_bankType, mixin_paymentindex_fill, mixin_payment_select, common_dialog],
	data() {
		return {
			// 已经提交的申请
			alreadyApplyList: [
				{
					title: '测试数据',
					description: '测试数据'
				}
			],
			tourSteps: [
				{
					target: '#step-1',
					header: {
						title: '搜索条件'
					},
					content: `点击这里可以搜索,可以搜索多个状态的付款申请信息`
				},
				{
					target: '#printBox',
					header: {
						title: '非待提交的列表'
					},
					content: `这里可以看到状态为非 [待申请] 的付款申请信息列表`
				},
				{
					target: '#step-3',
					header: {
						title: '查看申请列表'
					},
					content: `点击这里,可以查看待提交(创建但未进入审核流程),或者被驳回(审核人驳回付款申请)的付款申请信息`
				}
			],
			// 漫游组件的完成的回调
			tourCallBacks: {
				onFinish: () => {
					localStorage.setItem('applyprocess-tour', 'true');
				}
			},
			tourOptions: {
				labels: {
					buttonSkip: '跳过教程',
					buttonPrevious: '上一步',
					buttonNext: '下一步',
					buttonStop: '完成'
				}
			},
			pagination: {
				onChange: page => {
					console.log(page);
				},
				pageSize: 10
			},
			loading: false,
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `支付类型`, visible: true },
				{ key: 2, label: `金额`, visible: true },
				{ key: 3, label: `对方账号`, visible: true },
				{ key: 4, label: `对方公司`, visible: true },
				{ key: 5, label: `付款原因`, visible: true },
				{ key: 6, label: `申请人`, visible: true },
				{ key: 7, label: `备注`, visible: true },
				{ key: 8, label: `附件`, visible: true },
				{ key: 9, label: `审核流程`, visible: true }
			],
			// 查看付款信息的
			checkInfoDialogVisible: false,
			// 查看审核流程
			checkApplyInfoDialogVisible: false,
			// 筛选项
			options: [
				{
					value: '1',
					label: '所有审核信息'
				},
				{
					value: '2',
					label: '仅我需要审核'
				}
			],
			// 筛选限制值
			select: '',
			// 折叠面板默认打开
			activeNames: '1',
			// 付款信息列表
			paymentList: [],
			// 查看付款信息的描述表
			checkPaymentInfo: {},
			auditInfoList: [],
			auditItemList: [],
			// 所有的审核流程列表 后期需要筛选这里面的审核流程
			allAuditInfoList: [],
			// 分页信息
			pageNum: 1,
			pageSize: 10,
			total: 0,
			// 付款审核
			addCheckApplyProcessVisible: false,

			// 2025-2-17 新增付款新增功能
			open: false,
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
			needMoney: 0,
			tID: null,
			// 新增搜索参数，默认值均为空
			queryParams: {
				fundsDate: '',
				fundsDateBegin: '',
				fundsDateEnd: '',
				payType: '',
				otherAcountsName: '',
				otherBankNo: '',
				otherBankName: '',
				companyName: '',
				companyId: '',
				companyType: '',
				reason: '',
				params: {
					checkStateList: ['审核中', '通过', '未通过', '驳回', '作废']
				}
			},

			// 当前操作的ID
			currentID: '',
			// 传递给子组件的参数
			needInfo: {},
			extraInformation: {}
		};
	},
	watch: {
		// 监听刷新标记
		checked: {
			columns: {
				handler: function (newVal) {
					localStorage.setItem('applyprocess-columns', JSON.stringify(newVal));
				},
				deep: true
			},
			handler(val) {
				if (val !== '') {
					setTimeout(() => {
						this.refreshApplyCheckInfo(val);
						this.$store.dispatch('apply/clearChecked');
					}, 500);
				}
			}
		}
	},
	created() {
		if (localStorage.getItem('applyprocess-columns') === 'null' || !localStorage.getItem('applyprocess-columns')) {
			// 设置localStorage
			localStorage.setItem('applyprocess-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('applyprocess-columns'));
		}
		this.getAuditList();
		this.getUnProcessedAuditList();
	},
	mounted() {
		if (!localStorage.getItem('applyprocess-tour')) {
			this.$tours['paymentApplyTour'].start();
			localStorage.setItem('applyprocess-tour', 'true');
		}
	},
	computed: {
		TableName() {
			return TableName;
		},
		...mapGetters(['checked'])
	},
	methods: {
		getTagColor,
		listCars,
		listBankAccount,
		listCompany,
		// 获取待提交或者驳回的付款申请记录
		getUnProcessedAuditList() {
			const query = {
				pageNum: this.pageNum,
				pageSize: this.pageSize
			};
			const json = {
				params: {
					userId: this.$store.getters.userId,
					checkStateList: ['待提交', '驳回']
				}
			};
			// 获取付款申请信息
			listPaymentApply(query, json).then(res => {
				this.alreadyApplyList = res.rows;
				this.$message.success(`成功获取待提交或已驳回的付款信息`);
			});
		},
		// 获取所有付款申请列表
		getAuditList() {
			const query = {
				pageNum: this.pageNum,
				pageSize: this.pageSize
			};
			const json = _.cloneDeep(this.queryParams);
			// 获取付款申请信息
			listPaymentApply(query, json).then(res => {
				this.paymentList = res.rows;
				this.total = res.total;
				this.$message.success(`成功获取付款信息`);
			});
		},
		// 修改已经提交的 待提交或者驳回的付款申请记录 isEdit=true时为修改原有信息
		reApply(paymentApplyInfo, isEdit = true) {
			const clonedPaymentApplyInfo = _.cloneDeep(paymentApplyInfo);
			console.log(`clonedPaymentApplyInfo`, clonedPaymentApplyInfo);
			// 需要自动填充的信息
			this.needInfo = {
				bankNo: clonedPaymentApplyInfo.otherBankNo,
				acountsName: clonedPaymentApplyInfo.otherAcountsName,
				bankName: clonedPaymentApplyInfo.otherBankName
			};
			console.log(`needInfo:`, this.needInfo);
			// 额外信息
			this.extraInformation = {
				__companyType: isEdit ? clonedPaymentApplyInfo.companyType : '',
				__referenceId: clonedPaymentApplyInfo.id
			};
			if (isEdit) {
				this.openDialog(
					ApplyPayment,
					'付款申请(点击确认后将保存数据,点击提交后信息进入审核流程)',
					'650px',
					{
						tableName: clonedPaymentApplyInfo.tableName,
						// 关联表的主键ID
						tID: clonedPaymentApplyInfo.tid,
						// 需要自动填充的钱
						needMoney: clonedPaymentApplyInfo.moneyAmount,
						// 需要自动填充的信息 包含 对方户名:acountsName 对方账号 bankNo 对方开户行 bankName 对方公司 companyName
						needInfo: this.needInfo,
						// 是否禁用金额输入框
						moneyInputDisabled: true,
						// 是否为多个付款申请
						isMulti: false,
						isOtherButtonDisabled: true,
						extraInformation: this.extraInformation
					},
					false
				);
			} else {
				this.openDialog(ApplyPayment, '付款申请(点击确认后将保存数据,点击提交后信息进入审核流程)', '650px', {
					tableName: clonedPaymentApplyInfo.tableName,
					// 关联表的主键ID
					tID: clonedPaymentApplyInfo.tid,
					// 需要自动填充的钱
					needMoney: clonedPaymentApplyInfo.moneyAmount,
					// 需要自动填充的信息 包含 对方户名:acountsName 对方账号 bankNo 对方开户行 bankName 对方公司 companyName
					needInfo: this.needInfo,
					isOtherButtonDisabled: true,
					extraInformation: this.extraInformation
				});
			}
		},
		handleCheck(item) {
			// 查看付款申请详细
			if (!item.id) {
				this.$message.error('付款申请信息不存在');
				return;
			}
			getPaymentApply(item.id).then(res => {
				if (!res.data) {
					this.$message.error('付款申请信息不存在');
					return;
				}
				const paymentApplyInfo = res.data;
				this.openDialog(
					PAYMENT_APPLY_INFO,
					'付款申请信息',
					'650px',
					{
						needToShowInfo: paymentApplyInfo
					},
					false
				);
			});
		},
		// 提交付款申请信息 此时会将状态改为审核中
		submitReApplyInfo(paymentApplyInfo) {
			const { id } = paymentApplyInfo;
			submitPaymentApply(id).then(res => {
				this.$message.success('付款申请提交成功,请等待审核人审核!');
				this.getAuditList();
				this.getUnProcessedAuditList();
			});
		},
		handleAdd() {
			this.reset();
			this.open = true;
		},
		// 付款处理的回调函数
		changePaymentApplyInfoVisible() {
			this.needMoney = 0;
			this.open = false;
			this.getAuditList();
			this.getUnProcessedAuditList();
		},
		refresh() {
			this.loading = true;
			const query = { pageNum: this.pageNum, pageSize: this.pageSize };
			const json = { ...this.queryParams };
			listPaymentApply(query, json).then(res => {
				this.paymentList = res.rows;
				this.total = res.total;
				this.loading = false;
			});
		},
		handleLearn() {
			this.$tours['paymentApplyTour'].start();
		},
		// 重新刷新审核树
		refreshApplyCheckInfo() {
			this.getAuditList();
			this.getUnProcessedAuditList();
			// 重新获取当前的审核树
			this.getAuditStepsList();
		},
		// 查看某一个行的信息
		handleCheckInfo(row) {
			// 获取该行付款信息的详细信息 赋值到弹出框的描述表中
			getPaymentApply(row.id).then(res => {
				this.checkPaymentInfo = res.data;
				this.checkInfoDialogVisible = true;
			});
		},
		// 查看某一行的审核流程信息
		handleCheckApplyInfo(row) {
			if (!row.id) {
				this.$message.error('该行数据有误,付款申请编号为空!');
				return;
			}
			this.currentID = row.id;
			this.getAuditStepsList(row.id);
		},
		// 获取审核步骤信息
		getAuditStepsList(id) {
			const searchId = id || this.currentID;
			getPaymentApply(searchId).then(res => {
				if (!res.data) {
					this.$message.error('暂无数据!');
					return;
				}
				if (!res.data.auditInfoList) {
					this.$message.error('该付款申请没有审核记录!');
					return;
				}
				const paymentApplyInfo = _.cloneDeep(res.data);
				this.auditInfoList = paymentApplyInfo.auditInfoList.map(item => {
					// 将主表信息放入字表,方便拿表名和ID
					return {
						...item,
						paymentApply: paymentApplyInfo
					};
				});
				this.checkApplyInfoDialogVisible = true;
			});
		},
		// 审核完毕后点击确定
		onSubmitApply() {
			this.checkApplyInfoDialogVisible = false;
			this.refresh();
		},
		// 折叠面板打开某一个的回调
		handleChangeApplyItem(e) {
			console.log(e);
		},
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
		resetQuery() {
			this.queryParams = {
				fundsDate: '',
				fundsDateBegin: '',
				fundsDateEnd: '',
				payType: '',
				otherAcountsName: '',
				otherBankNo: '',
				otherBankName: '',
				companyName: '',
				companyId: '',
				companyType: '',
				reason: '',
				params: {
					checkStateList: ['审核中', '通过', '未通过', '驳回', '作废']
				}
			};
			this.getAuditList();
		},
		// 新增搜索按钮处理函数
		handleQuery() {
			this.pageNum = 1;
			this.getAuditList();
		}
	}
};
</script>

<template>
	<div class="app-container">
		<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="100px">
			<el-form-item label="开始日期" prop="fundsDateBegin">
				<el-date-picker clearable v-model="queryParams.fundsDateBegin" type="date" placeholder="开始日期" value-format="yyyy-MM-dd"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束日期" prop="fundsDateEnd">
				<el-date-picker clearable v-model="queryParams.fundsDateEnd" type="date" placeholder="结束日期" value-format="yyyy-MM-dd"></el-date-picker>
			</el-form-item>
			<el-form-item label="支付类型" prop="payType">
				<el-input clearable v-model="queryParams.payType" placeholder="请输入支付类型"></el-input>
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-input clearable v-model="queryParams.otherAcountsName" placeholder="请输入对方户名"></el-input>
			</el-form-item>
			<el-form-item label="对方账号" prop="otherBankNo">
				<el-input clearable v-model="queryParams.otherBankNo" placeholder="请输入对方账号"></el-input>
			</el-form-item>
			<el-form-item label="对方开户行" prop="otherBankName">
				<el-input clearable v-model="queryParams.otherBankName" placeholder="请输入对方开户行"></el-input>
			</el-form-item>
			<el-form-item label="公司名称" prop="companyName">
				<el-input clearable v-model="queryParams.companyName" placeholder="请输入公司名称"></el-input>
			</el-form-item>
			<el-form-item label="付款原因" prop="reason">
				<el-input clearable v-model="queryParams.reason" placeholder="请输入付款原因"></el-input>
			</el-form-item>
			<el-form-item label="审核状态" prop="checkState" id="step-1">
				<el-select clearable v-model="queryParams.params.checkStateList" placeholder="请选择审核状态" multiple>
					<el-option label="审核中" value="审核中"></el-option>
					<el-option label="通过" value="通过"></el-option>
					<el-option label="未通过" value="未通过"></el-option>
					<el-option label="驳回" value="驳回"></el-option>
					<el-option label="作废" value="作废"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-col :span="1.5">
					<el-button size="mini" @click="resetQuery">重置</el-button>
				</el-col>
			</el-form-item>
			<el-form-item>
				<el-col :span="1.5">
					<el-button size="mini" type="primary" @click="handleQuery">查询</el-button>
				</el-col>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button size="mini" @click="refresh">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button size="mini" @click="handleLearn">查看教程</el-button>
			</el-col>

			<el-col :span="1.5">
				<el-button size="mini" type="danger" @click="handleAdd">申请日常费用报销</el-button>
			</el-col>

			<el-col :span="1.5" style="position: fixed; bottom: 20px; right: 20px; z-index: 100">
				<el-popover placement="top-start" trigger="hover" width="1000" title="待提交或已驳回的付款申请">
					<template #reference>
						<el-button type="success" circle style="width: 40px; height: 40px" id="step-3">
							<a-icon type="unordered-list" />
						</el-button>
					</template>
					<a-anchor>
						<a-list item-layout="horizontal" :data-source="alreadyApplyList" :pagination="pagination">
							<a-list-item slot="renderItem" slot-scope="item, index">
								<a slot="actions" @click="reApply(item, true)">修改填写</a>
								<a slot="actions" @click="handleCheck(item)">查看详情</a>
								<a slot="actions" @click="submitReApplyInfo(item)">提交</a>
								<a-list-item-meta :description="'提交时间:' + item.addtime">
									<span slot="title">{{ item.reason }}</span>
								</a-list-item-meta>

								<div style="margin: 5px">
									<a-tag :color="getTagColor(item.checkState)">{{ item.checkState }}</a-tag>
								</div>
							</a-list-item>
						</a-list>
					</a-anchor>
				</el-popover>
			</el-col>
		</el-row>

		<!--    放置付款信息列表-->
		<el-row>
			<el-table
				id="printBox"
				v-loading="loading"
				:data="paymentList"
				border
				:cell-style="
					() => {
						return { padding: '.5px' };
					}
				"
				style="width: 100%"
				size="mini"
				align="center"
			>
				<el-table-column v-if="columns[0].visible" fixed prop="fundsDate" label="日期" width="150" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[1].visible" prop="payType" label="支付类型" width="150" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[2].visible" prop="moneyAmount" label="金额" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[3].visible" prop="otherBankNo" label="对方账号" width="300" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[4].visible" prop="companyName" label="对方公司" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[5].visible" prop="reason" label="付款原因" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[6].visible" prop="applyPerson" label="申请人" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[7].visible" prop="comments" label="备注" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[8].visible" prop="comments" label="附件" width="120" show-overflow-tooltip>
					<template #default="scope">
						<CheckFiles :path="scope.row.attachment" :is-upload="false"></CheckFiles>
					</template>
				</el-table-column>
				<el-table-column label="操作">
					<template slot-scope="scope">
						<el-button type="text" size="mini" @click="handleCheckInfo(scope.row)">查看</el-button>
					</template>
				</el-table-column>
				<el-table-column label="审核状态" fixed="right" align="center">
					<template slot-scope="scope">
						<el-tag :type="scope.row.checkState === '通过' ? 'success' : scope.row.checkState === '未通过' ? 'danger' : 'primary'">
							{{ scope.row.checkState }}
						</el-tag>
					</template>
				</el-table-column>
				<el-table-column v-if="columns[9].visible" fixed="right" label="审核流程" show-overflow-tooltip align="center">
					<template slot-scope="scope">
						<el-button type="text" size="mini" @click="handleCheckApplyInfo(scope.row)">查看</el-button>
					</template>
				</el-table-column>
			</el-table>
			<!--      分页-->
			<pagination v-show="total > 0" :total="total" :page.sync="pageNum" :limit.sync="pageSize" @pagination="getAuditList" />
		</el-row>

		<!--    固定的锚点-->

		<!--    查看付款信息的详细信息-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="付款信息详细" :visible.sync="checkInfoDialogVisible" width="50%">
			<el-descriptions title="付款信息明细">
				<el-descriptions-item label="申请人">
					{{ checkPaymentInfo.applyPerson }}
				</el-descriptions-item>
				<el-descriptions-item label="申请金额">
					{{ checkPaymentInfo.moneyAmount }}
				</el-descriptions-item>
				<el-descriptions-item label="备注">
					{{ checkPaymentInfo.comments }}
				</el-descriptions-item>
				<el-descriptions-item label="公司类型">
					{{ checkPaymentInfo.companyType }}
				</el-descriptions-item>
				<el-descriptions-item label="公司名称">
					{{ checkPaymentInfo.companyName }}
				</el-descriptions-item>
				<el-descriptions-item label="时间">
					{{ checkPaymentInfo.fundsDate }}
				</el-descriptions-item>
				<el-descriptions-item label="对方账户名称">
					{{ checkPaymentInfo.otherAcountsName }}
				</el-descriptions-item>
				<el-descriptions-item label="对方银行卡号">
					{{ checkPaymentInfo.otherBankNo }}
				</el-descriptions-item>
				<el-descriptions-item label="对方开户行">
					{{ checkPaymentInfo.otherBankName }}
				</el-descriptions-item>
				<el-descriptions-item label="申请原因">
					{{ checkPaymentInfo.reason }}
				</el-descriptions-item>
			</el-descriptions>
			<span slot="footer" class="dialog-footer">
				<el-button @click="checkInfoDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="checkInfoDialogVisible = false">确 定</el-button>
			</span>
		</el-dialog>

		<!--      审核流程步骤图信息  -->
		<el-dialog :close-on-click-modal="false" :show-close="false" :visible.sync="checkApplyInfoDialogVisible" title="审核流程多项信息" width="58%">
			<el-collapse v-model="activeNames" @change="handleChangeApplyItem">
				<el-collapse-item name="1">
					<template #title>
						<el-row>
							<span class="text-bolder">审核流程</span>
						</el-row>
					</template>
					<el-row>
						<el-col :span="24">
							<StepInfo :processInfo="auditInfoList" />
						</el-col>
					</el-row>
				</el-collapse-item>
			</el-collapse>
			<span slot="footer" class="dialog-footer">
				<el-button @click="checkApplyInfoDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="onSubmitApply">确 定</el-button>
			</span>
		</el-dialog>

		<!--   2025-2-17 新增付款功能-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="付款处理" :visible.sync="open" width="650px" append-to-body>
			<keep-alive>
				<ApplyPayment :table-name="TableName.DAILY" :t-i-d="tID" :need-money="needMoney" :need-info="{}" @changeOpen="changePaymentApplyInfoVisible" :money-input-disabled="false" />
			</keep-alive>
		</el-dialog>

		<div v-if="currentComponent">
			<DialogWrapper
				:current-component="currentComponent"
				:dialog-visible="dialogVisible"
				:dialog-props="dialogProps"
				:dialog-title="dialogTitle"
				:dialog-width="dialogWidth"
				:close-confirm="closeConfirm"
				@update:dialogVisible="args => (dialogVisible = false)"
				@close="handleCloseDialog"
				@confirm="handleDialogConfirm"
			/>
		</div>

		<!--    漫游组件-->
		<v-tour name="paymentApplyTour" :steps="tourSteps" :options="tourOptions" :callbacks="tourCallBacks"></v-tour>
	</div>
</template>

<style scoped lang="scss">
.text-bolder {
	font-weight: bolder;
	line-height: 35px;
}
</style>
