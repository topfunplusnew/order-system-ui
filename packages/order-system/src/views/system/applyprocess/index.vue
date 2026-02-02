<!--付款审核流程页面 需求:渲染需要付款的信息列表，付款信息中有多个审核流程 提供按钮筛选仅
当前账号需要审核的流程 审核的过程调用修改接口-->
<script>
import { getPaymentApply, listPaymentApply, submitPaymentApply, delPaymentApply, exportPaymentApply } from '@/api/system/paymentApply';
import { addPayment, generatePaymentFromApply } from '@/api/system/payment';
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
import { TableName, getTagColor, PAYMENT_APPLY_STATE, BankAcceptanceType, PAYMENT_TARGET_TYPE, PUBLIC_DICT_TYPE, PayType, PAYMENT_STATE } from '@/api/tool/enums';
import { listCars } from '@/api/system/cars';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import _ from 'lodash';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import PAYMENT_APPLY_INFO from '@/components/NeedToShow/PAYMENT_APPLY_INFO.vue';
import { listMyPaymentApply } from '../../../api/system/paymentApply';
import SearchOption from '@/components/SearchOption.vue';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import UploadFilesButton from '@/components/UploadFilesButton';
import { parseTime } from '@/utils/ruoyi';

export default {
	name: 'ApplyProcess',
	components: {
		ApplyPayment,
		CheckFiles,
		StepInfo,
		SearchOption,
		BankType,
		UploadFilesButton
	},
	mixins: [mixin_printHTML, mixin_payment_subject, mixin_bankType, mixin_paymentindex_fill, mixin_payment_select, common_dialog],
	data() {
		return {
			// 已经提交的申请
			alreadyApplyList: [],
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
				pageSize: 20
			},
			loading: false,
			columns: [
				{ key: 0, label: `ID`, visible: true },
				{ key: 1, label: `申请日期`, visible: true },
				{ key: 2, label: `支付类型`, visible: true },
				{ key: 3, label: `金额`, visible: true },
				{ key: 4, label: `对方账号`, visible: true },
				{ key: 5, label: `对方户名`, visible: true },
				{ key: 6, label: `对方公司`, visible: true },
				{ key: 7, label: `付款原因`, visible: true },
				{ key: 8, label: `申请人`, visible: true },
				{ key: 9, label: `备注`, visible: true },
				{ key: 10, label: `附件`, visible: true },
				{ key: 11, label: `审核人`, visible: true },
				{ key: 12, label: `操作`, visible: true }
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
			// 显示搜索条件
			showSearch: true,
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
			pageSize: 20,
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
				otherAccountsName: [
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
				otherAccountsName: '',
				otherBankNo: '',
				otherBankName: '',
				companyName: '',
				companyId: '',
				companyType: '',
				reason: '',
				applyPerson: '',
				params: {
					checkStateList: ['审核中', '通过', '未通过', '驳回']
				}
			},

			// 当前操作的ID
			currentID: '',
			// 当前操作的付款申请ID（用于生成付款信息）
			currentPaymentApplyId: null,
			// 传递给子组件的参数
			needInfo: {},
			extraInformation: {},
			// 付款弹窗
			generatePaymentVisible: false,
			generatePaymentForm: {
				fundsDate: null,
				payType: null,
				moneyAmount: null,
				selfBankCardType: BankAcceptanceType.BANK_CASH,
				otherBankCardType: BankAcceptanceType.BANK_CASH,
				selfAccountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAccountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				comments: null,
				transactionHistory: null,
				userName: null,
				attachmentList: [],
				params: {
					attachmentIds: [],
					bankacceptance: null
				}
			},
			// 对方类型选项
			generatePaymentOptions: [
				{ value: PAYMENT_TARGET_TYPE.CUSTOMER, label: PUBLIC_DICT_TYPE.CUSTOMER },
				{ value: PAYMENT_TARGET_TYPE.SUPPLIER, label: PUBLIC_DICT_TYPE.SUPPLIER },
				{ value: PAYMENT_TARGET_TYPE.DRIVER, label: PUBLIC_DICT_TYPE.DRIVER },
				{ value: PAYMENT_TARGET_TYPE.PAYMENT_FEE, label: PAYMENT_TARGET_TYPE.PAYMENT_FEE },
				{ value: PUBLIC_DICT_TYPE.EMPLOYEE, label: PUBLIC_DICT_TYPE.EMPLOYEE }
			],
			// 付款表单校验规则
			generatePaymentFormRules: {
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
				otherAccountsName: [
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
			}
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
		// 'generatePaymentForm.companyType'(newVal) {
		// 	if (newVal === PAYMENT_TARGET_TYPE.PAYMENT_FEE) {
		// 		this.generatePaymentForm.companyName = null;
		// 		this.generatePaymentForm.companyId = null;
		// 		this.generatePaymentForm.otherAccountsName = null;
		// 		this.generatePaymentForm.otherBankNo = null;
		// 		this.generatePaymentForm.otherBankName = null;
		// 	}
		// }
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

		// 监听 payment-apply-unaudit-list-update 事件
		this.$bus.$on('payment-apply-unaudit-list-update', () => {
			this.getUnProcessedAuditList();
		});
	},
	computed: {
		PAYMENT_APPLY_STATE() {
			return PAYMENT_APPLY_STATE;
		},
		TableName() {
			return TableName;
		},
		PAYMENT_TARGET_TYPE() {
			return PAYMENT_TARGET_TYPE;
		},
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		BankAcceptanceType() {
			return BankAcceptanceType;
		},
		PAYMENT_STATE() {
			return PAYMENT_STATE;
		},
		...mapGetters(['checked', 'getId'])
	},
	methods: {
		getTagColor,
		listCars,
		listBankAccount,
		listCompany,
		// 获取 auditInfoList 中 id 最大且审核状态不为"审核中"的元素的 userName
		getLatestAuditor(auditInfoList) {
			if (!auditInfoList || !Array.isArray(auditInfoList) || auditInfoList.length === 0) {
				return '-';
			}
			// 过滤掉审核状态为"审核中"的记录
			const filteredList = auditInfoList.filter(item => item.checkState !== PAYMENT_APPLY_STATE.V2.ING);
			if (filteredList.length === 0) {
				return '-';
			}
			const latestAudit = filteredList.reduce((prev, curr) => (curr.id > prev.id ? curr : prev));
			return latestAudit.userName || '-';
		},
		// 获取待提交或者驳回的付款申请记录
		getUnProcessedAuditList() {
			const query = {
				pageNum: this.pageNum,
				pageSize: this.pageSize
			};
			const json = {
				params: {
					userId: this.getId,
					checkStateList: ['待提交', '驳回']
				}
			};
			// 获取付款申请信息
			listMyPaymentApply(query, json).then(res => {
				this.alreadyApplyList = res.rows;
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
			});
		},
		// 修改已经提交的 待提交或者驳回的付款申请记录 isEdit=true时为修改原有信息
		reApply(paymentApplyInfo, isEdit = true) {
			const clonedPaymentApplyInfo = _.cloneDeep(paymentApplyInfo);
			// 需要自动填充的信息
			this.needInfo = {
				bankNo: clonedPaymentApplyInfo.otherBankNo,
				acountsName: clonedPaymentApplyInfo.otherAccountsName,
				bankName: clonedPaymentApplyInfo.otherBankName,
				companyName: clonedPaymentApplyInfo.companyName,
				companyType: clonedPaymentApplyInfo.companyType,
				companyId: clonedPaymentApplyInfo.companyId,
				// 对于员工类型的时候 这个是有值的 其他时候没值
				employeeId: clonedPaymentApplyInfo.companyId,
				payType: clonedPaymentApplyInfo.payType.split('-') || [],
				attachmentList: clonedPaymentApplyInfo.attachmentList,
				reason: clonedPaymentApplyInfo.reason,
				// 票的额外信息和 返利的实收详情里面有comment，其他的都是comments字段
				comments: clonedPaymentApplyInfo.comments,
				remark: clonedPaymentApplyInfo.remark
			};
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
		// 删除付款申请信息
		handleDeleteApply(paymentApplyInfo) {
			const { id, reason } = paymentApplyInfo;
			this.$modal
				.confirm(`是否确认删除付款申请"${reason || '无原因'}"？`)
				.then(() => {
					return delPaymentApply(id);
				})
				.then(() => {
					this.$modal.msgSuccess('删除成功');
					this.getUnProcessedAuditList(); // 刷新待提交/驳回列表
				})
				.catch(() => {});
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
			// 同时刷新待提交或驳回的付款申请列表
			this.getUnProcessedAuditList();
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
				otherAccountsName: '',
				otherBankNo: '',
				otherBankName: '',
				companyName: '',
				companyId: '',
				companyType: '',
				reason: '',
				applyPerson: '',
				params: {
					checkStateList: []
				}
			};
			this.getAuditList();
		},
		// 新增搜索按钮处理函数
		handleQuery() {
			this.pageNum = 1;
			this.getAuditList();
			this.getUnProcessedAuditList();
		},
		// 判断当前用户是否是审核人
		isCurrentUserAuditor(row) {
			if (!row.auditInfoList || !Array.isArray(row.auditInfoList)) {
				return false;
			}
			const currentUserId = this.getId;
			return row.auditInfoList.some(auditInfo => auditInfo.userId === currentUserId);
		},
		// 删除付款申请
		handleDeletePaymentApply(row) {
			const { id, reason } = row;
			this.$modal
				.confirm(`是否确认删除付款申请"${reason || '无原因'}"？`)
				.then(() => {
					return delPaymentApply(id);
				})
				.then(() => {
					this.$modal.msgSuccess('删除成功');
					this.getAuditList();
				})
				.catch(() => {});
		},
		// 付款
		handleGeneratePayment(row) {
			// 保存当前操作的付款申请ID
			this.currentPaymentApplyId = row.id;
			// 重置表单
			this.generatePaymentForm = {
				fundsDate: parseTime(new Date()),
				payType: null,
				moneyAmount: row.moneyAmount || null,
				selfBankCardType: BankAcceptanceType.BANK_CASH,
				otherBankCardType: BankAcceptanceType.BANK_CASH,
				selfAccountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAccountsName: row.otherAccountsName || null,
				otherBankNo: row.otherBankNo || null,
				otherBankName: row.otherBankName || null,
				companyName: row.companyName || null,
				companyId: row.companyId || null,
				companyType: row.companyType || null,
				comments: row.comments || row.reason || null,
				transactionHistory: null,
				userName: null,
				attachmentList: row.attachmentList && Array.isArray(row.attachmentList) ? row.attachmentList : [],
				params: {
					attachmentIds: row.attachmentList && Array.isArray(row.attachmentList) ? row.attachmentList.map(item => item.id) : [],
					bankacceptance: null
				}
			};
			this.generatePaymentVisible = true;
			// 使用 $nextTick 确保弹窗渲染完成后再设置 payType
			this.$nextTick(() => {
				if (row.payType) {
					if (typeof row.payType === 'string') {
						// 使用 searchSubjectFromMap 方法将字符串转换为级联选择器需要的数组格式
						this.generatePaymentForm.payType = this.searchSubjectFromMap(row.payType);
					} else if (Array.isArray(row.payType)) {
						this.generatePaymentForm.payType = row.payType;
					}
				}
			});
		},
		// 提交付款
		submitGeneratePayment() {
			// 使用表单校验
			this.$refs.generatePaymentFormRef.validate(valid => {
				if (!valid) {
					return;
				}
				// 校验付款类型
				if (!this.generatePaymentForm.payType) {
					this.$message.warning('请选择付款类型');
					return;
				}
				// 校验银行账户类型
				if (this.generatePaymentForm.selfBankCardType && this.generatePaymentForm.otherBankCardType) {
					if (this.generatePaymentForm.selfBankCardType !== this.generatePaymentForm.otherBankCardType) {
						this.$message.warning('操作失败，无法进行承兑与活期存款或者相反的交易,类型需要保持一致');
						return;
					}
				}

				const formData = _.cloneDeep(this.generatePaymentForm);

				// 处理付款类型：如果是数组则转换为字符串
				if (Array.isArray(formData.payType)) {
					formData.payType = formData.payType.join('-');
				}
				// 处理日期格式
				if (formData.fundsDate && typeof formData.fundsDate === 'string') {
					formData.fundsDate = formData.fundsDate.replace('T', ' ').slice(0, 19);
				}

				// 处理承兑逻辑
				const selfType = this.$refs.generatePaymentSelfSelectedBankType?.localSelectType;
				const otherType = this.$refs.generatePaymentOtherSelectedBankType?.localSelectType;
				if (selfType && otherType && selfType !== otherType) {
					if (!formData.params) {
						formData.params = {};
					}
					if (!formData.params.bankacceptance) {
						formData.params.bankacceptance = {};
					}
					if (!formData.params.bankacceptance.billType) {
						if (selfType === BankAcceptanceType.ACCEPTANCE) {
							formData.params.bankacceptance.billType = PayType.PAYMENT;
						}
						if (otherType === BankAcceptanceType.ACCEPTANCE) {
							formData.params.bankacceptance.billType = PayType.RECEIVE;
						}
					}
				}

				generatePaymentFromApply(this.currentPaymentApplyId, formData)
					.then(res => {
						this.$modal.msgSuccess('付款成功');
						this.cancelGeneratePayment();
						this.getAuditList();
					})
					.catch(error => {
						this.$message.error(error.msg || '付款失败');
					});
			});
		},
		// 取消付款
		cancelGeneratePayment() {
			this.generatePaymentVisible = false;
			this.currentPaymentApplyId = null;
			this.generatePaymentForm = {
				fundsDate: null,
				payType: null,
				moneyAmount: null,
				selfBankCardType: BankAcceptanceType.BANK_CASH,
				otherBankCardType: BankAcceptanceType.BANK_CASH,
				selfAccountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAccountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				comments: null,
				transactionHistory: null,
				userName: null,
				attachmentList: [],
				params: {
					attachmentIds: [],
					bankacceptance: null
				}
			};
			// 重置表单校验状态
			if (this.$refs.generatePaymentFormRef) {
				this.$refs.generatePaymentFormRef.resetFields();
			}
			// 清除附件上传状态
			if (this.$refs.generatePaymentAttachmentUpload) {
				this.$refs.generatePaymentAttachmentUpload.clearUploadedFiles();
			}
			if (this.$refs.generatePaymentTransactionHistoryUpload) {
				this.$refs.generatePaymentTransactionHistoryUpload.clearUploadedFiles();
			}
		},
		// 处理付款表单的附件更新
		handleGeneratePaymentAttachmentFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				if (!this.generatePaymentForm.params) {
					this.generatePaymentForm.params = {};
				}
				this.generatePaymentForm.params.attachmentIds = uploadParams.params.attachmentIds;
			}
		},
		// 表格行样式类名
		tableRowClassName({ row }) {
			if (row.tableReferences) {
				return 'highlight-row';
			}
			return '';
		},
		// 表格行样式
		tableRowStyle({ row }) {
			if (row.tableReferences) {
				return {
					backgroundColor: '#f5f5f5'
				};
			}
			return {};
		},
		/** 导出按钮操作 */
		handleExport() {
			// 使用与 list 接口相同的参数格式
			const data = _.cloneDeep(this.queryParams);
			exportPaymentApply(data)
				.then(res => {
					const blob = new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
					const link = document.createElement('a');
					link.href = window.URL.createObjectURL(blob);
					link.download = `付款申请信息_${new Date().getTime()}.xlsx`;
					link.click();
					window.URL.revokeObjectURL(link.href);
				})
				.catch(error => {
					this.$message.error('导出失败，请重试');
					console.error('导出失败:', error);
				});
		}
	}
};
</script>

<template>
	<div class="app-container">
		<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150">
			<el-form-item label="开始日期" prop="fundsDateBegin">
				<el-date-picker clearable v-model="queryParams.fundsDateBegin" type="date" placeholder="开始日期" value-format="yyyy-MM-dd"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束日期" prop="fundsDateEnd">
				<el-date-picker clearable v-model="queryParams.fundsDateEnd" type="date" placeholder="结束日期" value-format="yyyy-MM-dd"></el-date-picker>
			</el-form-item>
			<el-form-item label="支付类型" prop="payType">
				<el-input clearable @keyup.enter.native="handleQuery" v-model="queryParams.payType" placeholder="请输入支付类型"></el-input>
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAccountsName">
				<el-input clearable @keyup.enter.native="handleQuery" v-model="queryParams.otherAccountsName" placeholder="请输入对方户名"></el-input>
			</el-form-item>
			<el-form-item label="对方账号" prop="otherBankNo">
				<el-input clearable @keyup.enter.native="handleQuery" v-model="queryParams.otherBankNo" placeholder="请输入对方账号"></el-input>
			</el-form-item>
			<el-form-item label="对方开户行" prop="otherBankName">
				<el-input clearable @keyup.enter.native="handleQuery" v-model="queryParams.otherBankName" placeholder="请输入对方开户行"></el-input>
			</el-form-item>
			<el-form-item label="公司名称" prop="companyName">
				<el-input clearable @keyup.enter.native="handleQuery" v-model="queryParams.companyName" placeholder="请输入公司名称"></el-input>
			</el-form-item>
			<el-form-item label="付款原因" prop="reason">
				<el-input clearable @keyup.enter.native="handleQuery" v-model="queryParams.reason" placeholder="请输入付款原因"></el-input>
			</el-form-item>
			<el-form-item label="申请人" prop="applyPerson">
				<el-input clearable @keyup.enter.native="handleQuery" v-model="queryParams.applyPerson" placeholder="请输入申请人"></el-input>
			</el-form-item>
			<el-form-item label="审核状态" prop="checkState" id="step-1">
				<el-select clearable @keyup.enter.native="handleQuery" v-model="queryParams.params.checkStateList" placeholder="请选择审核状态" multiple style="max-width: 220px" :collapse-tags="true" :collapse-tags-tooltip="true">
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

		<!-- 右侧工具栏 -->
		<div class="toolbar-wrapper">
			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getAuditList">
				<template #left>
					<div class="toolbar-left">
						<el-row :gutter="10" class="mb8">
							<!-- 刷新按钮-->
							<el-col :span="1.5">
								<el-button icon="el-icon-refresh" size="mini" @click="refresh">刷新</el-button>
							</el-col>
							<el-col :span="1.5">
								<el-button size="mini" @click="handleLearn">查看教程</el-button>
							</el-col>
							<!--      解开了新增付款信息-->
							<el-col :span="1.5">
								<el-button type="danger" size="mini" @click="handleAdd">申请日常费用报销</el-button>
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
						<el-button v-hasPermi="['system:paymentapply:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" :disabled="paymentList.length === 0" />
					</el-col>
				</template>
			</right-toolbar>
		</div>

		<el-col :span="1.5" style="position: fixed; bottom: 20px; right: 20px; z-index: 100">
			<el-popover placement="top-start" trigger="hover" width="1000" title="待提交或已驳回的付款申请">
				<template #reference>
					<el-button type="success" size="mini" id="step-3">
						<a-icon type="unordered-list" />
						<span style="margin-left: 6px">查看待提交/驳回的申请</span>
					</el-button>
				</template>
				<a-anchor>
					<div class="apply-list-scroll">
						<a-list item-layout="horizontal" :data-source="alreadyApplyList" :pagination="pagination">
							<!--  eslint-disable-next-line-->
							<a-list-item slot="renderItem" slot-scope="item, index">
								<a slot="actions" @click="reApply(item, true)">修改填写</a>
								<a slot="actions" @click="handleCheck(item)">查看详情</a>
								<a slot="actions" @click="submitReApplyInfo(item)">提交</a>
								<a slot="actions" @click="handleDeleteApply(item)" style="color: #f56c6c">删除</a>
								<a-list-item-meta>
									<template slot="title">
										<div class="apply-item-title">
											<span class="apply-reason">{{ item.reason || '无原因' }}</span>
											<a-tag color="blue" style="margin-left: 8px">{{ item.payType || '类型未知' }}</a-tag>
											<a-tag color="red">￥{{ item.moneyAmount }}</a-tag>
										</div>
									</template>
									<template slot="description">
										<div class="apply-item-desc">
											<div>提交时间：{{ item.addTime }}</div>
											<div>申请人：{{ item.applyPerson }}</div>
											<div>公司：{{ item.companyType }} - {{ item.companyName }}</div>
											<div v-if="item.otherBankNo">对方账号：{{ item.otherBankNo }}</div>
											<div v-else-if="item.otherAccountsName || item.otherAccountsName">对方户名：{{ item.otherAccountsName || item.otherAccountsName }}</div>
											<div v-if="Array.isArray(item.attachmentList)">附件：{{ item.attachmentList.length }} 个</div>
										</div>
									</template>
								</a-list-item-meta>

								<div style="margin: 5px">
									<a-tag :color="getTagColor(item.checkState)">{{ item.checkState }}</a-tag>
								</div>
							</a-list-item>
						</a-list>
					</div>
				</a-anchor>
			</el-popover>
		</el-col>

		<!--    放置付款信息列表-->
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			:data="paymentList"
			border
			:row-class-name="tableRowClassName"
			:row-style="tableRowStyle"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			style="width: 100%"
			size="mini"
			align="center"
		>
			<el-table-column v-if="columns[0].visible" prop="id" label="ID" width="80" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[1].visible" label="申请日期" width="150" show-overflow-tooltip>
				<template #default="scope">
					{{ scope.row.fundsDate }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" prop="payType" label="支付类型" width="150" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[3].visible" prop="moneyAmount" label="金额" width="120" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[4].visible" prop="otherBankNo" label="对方账号" width="300" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[5].visible" prop="otherAccountsName" label="对方户名" width="200" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[6].visible" prop="companyName" label="对方公司" width="120" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[7].visible" prop="reason" label="付款原因" width="120" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[8].visible" prop="applyPerson" label="申请人" width="120" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[9].visible" prop="comments" label="备注" width="120" show-overflow-tooltip></el-table-column>
			<el-table-column v-if="columns[10].visible" prop="comments" label="附件" width="120" show-overflow-tooltip>
				<template #default="scope">
					<div v-if="Array.isArray(scope.row.attachmentList)">
						<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'attachments'" :is-upload="false" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getPaymentApply, updatePaymentApply)" />
					</div>
					<div v-else>
						<el-tag type="danger">加载错误</el-tag>
					</div>
				</template>
			</el-table-column>
			<el-table-column label="付款详情" width="100" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					<el-button type="text" size="mini" @click="handleCheckInfo(scope.row)">查看</el-button>
				</template>
			</el-table-column>
			<el-table-column label="审核状态" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					<el-tag
						:type="
							{
								[PAYMENT_APPLY_STATE.V2.PENDING]: 'warning',
								[PAYMENT_APPLY_STATE.V2.ING]: 'info',
								[PAYMENT_APPLY_STATE.V2.PASS]: 'success',
								[PAYMENT_APPLY_STATE.V2.NOT_PASS]: 'danger',
								[PAYMENT_APPLY_STATE.V2.REJECT]: 'danger',
								[PAYMENT_APPLY_STATE.V2.VOID]: 'default'
							}[scope.row.checkState]
						"
					>
						{{ scope.row.checkState }}
					</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="审核人" width="120" align="center" show-overflow-tooltip>
				<template #default="scope">
					{{ getLatestAuditor(scope.row.auditInfoList) }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="操作" show-overflow-tooltip align="center" fixed="right" width="260">
				<template slot-scope="scope">
					<el-button type="text" size="mini" @click="handleCheckApplyInfo(scope.row)">查看</el-button>
					<el-button v-hasPermi="['system:paymentapply:generate']" type="text" size="mini" :disabled="scope.row.checkState !== PAYMENT_APPLY_STATE.V2.PASS || (scope.row.payment && scope.row.payment.paymentState === PAYMENT_STATE.PAID)" @click="handleGeneratePayment(scope.row)">
						付款
					</el-button>
					<el-button v-if="isCurrentUserAuditor(scope.row)" type="text" size="mini" style="color: #f56c6c" @click="handleDeletePaymentApply(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		<!--      分页-->
		<pagination v-show="total > 0" :total="total" :page.sync="pageNum" :limit.sync="pageSize" @pagination="getAuditList" />

		<!--    固定的锚点-->

		<!--    查看付款信息的详细信息-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="付款信息详细" :visible.sync="checkInfoDialogVisible" width="50%">
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
				<el-descriptions-item label="付款时间">
					{{ checkPaymentInfo.payment ? checkPaymentInfo.payment.fundsDate : '' }}
				</el-descriptions-item>
				<el-descriptions-item label="对方账户名称">
					{{ checkPaymentInfo.otherAccountsName }}
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
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :visible.sync="checkApplyInfoDialogVisible" title="审核流程多项信息" width="58%">
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
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="付款处理" :visible.sync="open" width="650px" append-to-body>
			<keep-alive>
				<ApplyPayment :is-daily-expense="1" :need-money="needMoney" :need-info="{}" @changeOpen="changePaymentApplyInfoVisible" :money-input-disabled="false" />
			</keep-alive>
		</el-dialog>

		<!-- 付款弹窗 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="付款" :visible.sync="generatePaymentVisible" width="1000px" append-to-body>
			<el-form ref="generatePaymentFormRef" :model="generatePaymentForm" :rules="generatePaymentFormRules" label-width="170px">
				<el-row :gutter="40">
					<!-- 左列 -->
					<el-col :span="generatePaymentForm.companyType === PAYMENT_TARGET_TYPE.PAYMENT_FEE ? 24 : 12">
						<el-form-item label="日期" prop="fundsDate">
							<el-date-picker v-model="generatePaymentForm.fundsDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%"></el-date-picker>
						</el-form-item>

						<el-form-item label="付款类型" prop="payType">
							<el-cascader v-model="generatePaymentForm.payType" :options="paymentTypeTree" :props="props" style="width: 100%"></el-cascader>
						</el-form-item>

						<el-form-item label="金额" prop="moneyAmount">
							<el-input v-model="generatePaymentForm.moneyAmount" placeholder="请输入金额" style="width: 100%" />
						</el-form-item>

						<el-form-item label="我方银行账户类型">
							<BankType
								ref="generatePaymentSelfSelectedBankType"
								:bill-type="BankAcceptanceType.PAY_TYPE.PAYMENT"
								:select-type="generatePaymentForm.selfBankCardType"
								:external-bankacceptance-info="generatePaymentForm.params.bankacceptance"
								@updateSelectedType="value => (generatePaymentForm.selfBankCardType = value)"
								@updateBankAcceptance="value => (generatePaymentForm.params.bankacceptance = value)"
								style="width: 100%"
							/>
						</el-form-item>

						<el-form-item label="我方户名" prop="selfAccountsName">
							<el-row>
								<el-col :span="22">
									<el-input disabled v-model="generatePaymentForm.selfAccountsName" placeholder="请选择" style="width: 100%" />
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
										@commitBack="
											val => {
												generatePaymentForm.selfBankName = val.bankName;
												generatePaymentForm.selfAccountsName = val.acountsName;
												generatePaymentForm.selfBankNo = val.bankNo;
												generatePaymentForm.selfBankID = val.id;
											}
										"
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
							<el-input disabled v-model="generatePaymentForm.selfBankNo" placeholder="请选择" style="width: 100%" />
						</el-form-item>

						<el-form-item label="我方开户行" prop="selfBankName">
							<el-input disabled v-model="generatePaymentForm.selfBankName" placeholder="请选择" style="width: 100%" />
						</el-form-item>

						<el-form-item label="对方类型">
							<el-select v-model="generatePaymentForm.companyType" placeholder="请选择" style="width: 100%">
								<el-option v-for="item in generatePaymentOptions" :key="item.value" :label="item.label" :value="item.value" />
							</el-select>
						</el-form-item>

						<el-form-item v-if="generatePaymentForm.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE && generatePaymentForm.companyType !== PUBLIC_DICT_TYPE.EMPLOYEE" label="对方公司名称" prop="companyName">
							<el-row>
								<el-col :span="22">
									<el-input disabled v-model="generatePaymentForm.companyName" placeholder="请选择" style="width: 100%" />
								</el-col>
								<el-col :span="2" v-if="generatePaymentForm.companyType === PAYMENT_TARGET_TYPE.CUSTOMER || generatePaymentForm.companyType === PAYMENT_TARGET_TYPE.SUPPLIER">
									<SearchOption
										:limit-info="{ companyType: generatePaymentForm.companyType }"
										:get-data="listCompany"
										:query-info="`companyName`"
										:query-label="`公司名称`"
										:query-name="companyName"
										@update:queryName="value => (companyName = value)"
										@commitBack="
											val => {
												if (generatePaymentForm.companyType !== PAYMENT_TARGET_TYPE.DRIVER) {
													generatePaymentForm.companyName = val.companyName;
												} else {
													generatePaymentForm.companyName = val.driver;
												}
												generatePaymentForm.companyId = val.id;
											}
										"
									>
										<template #table-columns>
											<el-table-column :label="generatePaymentForm.companyType" align="center" prop="companyName" :width="generatePaymentForm.companyType === PAYMENT_TARGET_TYPE.SUPPLIER ? 340 : 150" />
											<el-table-column label="老板姓名" align="center" prop="leader" />
											<el-table-column label="老板电话" align="center" prop="leaderTel" />
											<el-table-column label="区域" align="center" prop="region" />
											<el-table-column label="销售经理" align="center" prop="salesManager" v-if="generatePaymentForm.companyType !== PAYMENT_TARGET_TYPE.SUPPLIER" />
										</template>
									</SearchOption>
								</el-col>
								<el-col :span="2" v-if="generatePaymentForm.companyType === PAYMENT_TARGET_TYPE.DRIVER">
									<SearchOption
										:limit-info="{ companyType: generatePaymentForm.companyType }"
										:get-data="listCars"
										:query-info="`driver`"
										:query-label="`司机`"
										:query-name="companyName"
										@update:queryName="value => (companyName = value)"
										@commitBack="
											val => {
												generatePaymentForm.companyName = val.driver;
												generatePaymentForm.companyId = val.id;
											}
										"
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
					<el-col :span="generatePaymentForm.companyType === PAYMENT_TARGET_TYPE.PAYMENT_FEE ? 24 : 12">
						<el-form-item v-if="generatePaymentForm.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE" label="对方银行账户类型">
							<BankType ref="generatePaymentOtherSelectedBankType" :option-baned="true" :baned="true" :select-type="generatePaymentForm.otherBankCardType" @updateSelectedType="value => (generatePaymentForm.otherBankCardType = value)" style="width: 100%" />
						</el-form-item>

						<el-form-item v-if="generatePaymentForm.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE" label="对方户名" prop="otherAccountsName">
							<el-input disabled v-model="generatePaymentForm.otherAccountsName" placeholder="请选择" style="width: 100%" />
						</el-form-item>

						<el-form-item v-if="generatePaymentForm.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE" label="对方账号" prop="otherBankNo">
							<el-row>
								<el-col :span="22">
									<el-input disabled v-model="generatePaymentForm.otherBankNo" placeholder="请选择" style="width: 100%" />
								</el-col>
								<el-col :span="2">
									<SearchOption
										:limit-info="{ acountsType: generatePaymentForm.companyType }"
										:get-data="listBankAccount"
										:query-name="queryBankAcount"
										query-label="户名查找"
										query-info="acountsName"
										@commitBack="
											val => {
												generatePaymentForm.otherBankName = val.bankName;
												generatePaymentForm.otherAccountsName = val.acountsName;
												generatePaymentForm.otherBankNo = val.bankNo;
												if (generatePaymentForm.companyType === PUBLIC_DICT_TYPE.EMPLOYEE) {
													generatePaymentForm.companyId = val.companyId;
													generatePaymentForm.companyName = val.companyName;
												}
											}
										"
										@update:queryName="handleUpdateQueryBankAcount"
										:extra-params="{
											companyId: generatePaymentForm.companyId,
											companyType: generatePaymentForm.companyType
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

						<el-form-item v-if="generatePaymentForm.companyType !== PAYMENT_TARGET_TYPE.PAYMENT_FEE" label="对方开户行">
							<el-input disabled v-model="generatePaymentForm.otherBankName" placeholder="请选择" style="width: 100%" />
						</el-form-item>

						<el-form-item label="附件" prop="attachmentIds">
							<UploadFilesButton
								ref="generatePaymentAttachmentUpload"
								flag="attachments"
								:extra-info="{ moduleType: 'payment', formId: null }"
								:initial-attachments="generatePaymentForm.attachmentList || []"
								@files-updated="handleGeneratePaymentAttachmentFilesUpdated"
								style="width: 100%"
							/>
						</el-form-item>

						<el-form-item label="银行卡流水编号" prop="transactionHistory">
							<el-input v-model="generatePaymentForm.transactionHistory" placeholder="请输入银行卡流水编号" style="width: 100%" />
						</el-form-item>
						<el-form-item label="银行卡流水附件" prop="attachmentIds">
							<UploadFilesButton
								ref="generatePaymentTransactionHistoryUpload"
								flag="transactionHistoryAttachmentList"
								:extra-info="{ moduleType: 'payment', formId: null }"
								:initial-attachments="generatePaymentForm.attachmentList || []"
								@files-updated="handleGeneratePaymentAttachmentFilesUpdated"
								style="width: 100%"
							/>
						</el-form-item>
						<!-- 2025-11-1 录入人员不用录入了 -->
						<!-- <el-form-item label="录入人员" prop="userName">
							<el-input v-model="generatePaymentForm.userName" placeholder="请输入录入人员" style="width: 100%" />
						</el-form-item> -->
						<el-form-item label="备注" prop="comments">
							<el-input v-model="generatePaymentForm.comments" placeholder="请输入备注" style="width: 100%" />
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitGeneratePayment">确 定</el-button>
				<el-button @click="cancelGeneratePayment">取 消</el-button>
			</div>
		</el-dialog>
		<!--    漫游组件-->
		<v-tour name="paymentApplyTour" :steps="tourSteps" :options="tourOptions" :callbacks="tourCallBacks"></v-tour>
	</div>
</template>

<style scoped lang="scss">
.text-bolder {
	font-weight: bolder;
	line-height: 35px;
}

.apply-list-scroll {
	max-height: 500px;
	overflow: auto;
}

// 高亮行样式，确保优先级高于悬停和斑马纹
::v-deep .el-table__body-wrapper .el-table__body tr.highlight-row {
	background-color: #f5f5f5 !important;

	&:hover {
		background-color: #f5f5f5 !important;
	}

	&:nth-child(even) {
		background-color: #f5f5f5 !important;
	}

	td {
		background-color: #f5f5f5 !important;
	}
}

// 固定列的高亮行样式
::v-deep .el-table__fixed-body-wrapper .el-table__body tr.highlight-row {
	background-color: #f5f5f5 !important;

	&:hover {
		background-color: #f5f5f5 !important;
	}

	&:nth-child(even) {
		background-color: #f5f5f5 !important;
	}

	td {
		background-color: #f5f5f5 !important;
	}
}
</style>
