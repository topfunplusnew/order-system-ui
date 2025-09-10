import { listBankAccount } from '../../../../api/system/bankAccount';
import { PAYMENT_TARGET_TYPE } from '@/api/tool/enums';
import { PaymentOptions, TableName } from '../../../../api/tool/enums';
import { listSubject } from '../../../../api/system/subject';
export var mixin_payment_watcher = {
	data: function () {
		return {
			options: PaymentOptions,
			value: '客户'
		};
	},
	props: {
		// 关联表名 - 已弃用，保留用于兼容性
		tableName: '',
		// 关联表的主键ID - 已弃用，保留用于兼容性
		tID: '',
		// 需要自动填充的钱
		needMoney: {
			type: Number
		},
		// 需要自动填充的信息 包含 对方户名:acountsName 对方账号 bankNo 对方开户行 bankName 对方公司 companyName
		needInfo: {
			type: Object
		},
		// 表关联数组 - 新的付款申请结构
		tableReferences: {
			type: Array,
			default: () => []
		},
		// 是否禁用金额输入框
		moneyInputDisabled: {
			type: Boolean,
			default: true
		},
		// 是否为多个付款申请 这个情况下是给批量申请使用 目前使用的是佣金信息
		isMulti: {
			type: Boolean,
			default: false
		},
		// 在待提交或者驳回的状态下,是否禁用原有的保存 和 保存并修改等按钮 控制按钮的显隐和银行卡的搜索
		isOtherButtonDisabled: {
			type: Boolean,
			default: false
		},
		// 额外信息 可以传递任意信息
		extraInformation: {
			type: Object,
			default: () => {
				return {};
			}
		},
		isDailyExpense: {
			type: Number,
			default: () => {
				return 0;
			}
		}
	},
	watch: {
		// 检测整个needInfo对象，统一处理银行卡信息填充
		needInfo: {
			handler(val) {
				if (JSON.stringify(this.needInfo) !== '{}') {
					Object.assign(this.form, {
						payType: val.payType,
						companyName: val.companyName,
						attachmentList: val.attachmentList,
						comment: val.comment,
						remark: val.remark,
						reason: val.reason
					});
					// 先填充运费信息
					this.fillFreightInfo();
					// 然后处理银行卡信息，避免重复触发
					this.handleBankAccountInfo();
				} else {
					this.loadForm();
				}
			},
			deep: true,
			immediate: true
		},
		// 监听传入的金额
		needMoney: {
			handler() {
				// 自动填充除了钱之外的信息
				this.loadForm();
				// 如果传入的必须自动填充的金额大于0 则自动填充 且无法修改
				if (this.needMoney >= 0) {
					this.form.moneyAmount = this.needMoney;
					this.inputDisabled = true;
				}
			},
			deep: true,
			immediate: true
		},
		// 监听表的变化
		tableName: {
			handler(val) {
				console.log('tableName', val);
				if (val === 'oilrecharge') {
					this.form.companyType = '其他';
				}
				if (val === 'repayment') {
					this.form.companyType = '其他';
				}
				if (val === 'orderfreight') {
					this.form.companyType = '司机';
				}
				if (val === 'invoicein') {
					this.form.companyType = '供应商';
				}
				// 打款是给供应商打款
				if (val === 'goodsorder') {
					this.form.companyType = '供应商';
				}
			}
		},
		// 监听额外信息
		extraInformation: {
			handler(val) {
				// 监听是否是付款 如果是 那么表单中某些字段要展示
				if (val.__isPayment) {
					this.isPayment = val.__isPayment;
					// 对方类型为支付费用
					this.value = PAYMENT_TARGET_TYPE.PAYMENT_FEE;
				}
				if (val.__companyType) {
					this.form.companyType = val.__companyType;
					this.value = val.__companyType;
				}
				if (val.__referenceId) {
					this.form.id = val.__referenceId;
				}
				if (val.__customizeSubjectName) {
					this.form.payType = val.__customizeSubjectName;
				}
			},
			deep: true,
			immediate: true
		}
	},
	created() {
		// 查询科目信息
		listSubject({}, true).then(res => {
			this.subjectTree = this.handleTree(res.data, 'id', 'parentId');
			this.OneLevelOption = this.subjectTree;
		});
		// 检查
		this.fillCompanyType();
	},
	methods: {
		// 处理银行卡信息填充，避免重复调用
		handleBankAccountInfo() {
			// 只有在非付款状态且有银行卡号时才查询
			if (!this.isPayment && this.needInfo.bankNo) {
				const search = {
					bankNo: this.needInfo.bankNo,
					companyType: this.needInfo.companyType,
					// 员工 companyId 怎么给？
					companyId: this.needInfo.companyId
				};
				listBankAccount(search).then(res => {
					// 如果没有查到 那么就提示 并且清空数据
					if (res.rows.length === 0) {
						Object.assign(this.form, {
							otherAccountsName: '',
							otherBankNo: '',
							otherBankName: '',
							selfAcountsName: '',
							selfBankNo: '',
							selfBankName: ''
						});
					} else {
						// 如果是己方的银行卡 填充己方银行卡信息
						if (this.needInfo.companyId === 0) {
							Object.assign(this.form, {
								selfAcountsName: res.rows[0].acountsName,
								selfBankNo: res.rows[0].bankNo,
								selfBankName: res.rows[0].bankName
							});
						} else {
							Object.assign(this.form, {
								otherAccountsName: res.rows[0].acountsName,
								otherBankNo: res.rows[0].bankNo,
								otherBankName: res.rows[0].bankName
							});
						}
					}
				});
			}
		},
		// 根据表名填充公司类型 这里是拿的父组件传递过来的tableName来判断 是哪个表的业务
		fillCompanyType() {
			// 根据传入的表名来赋值公司类型
			if (this.tableName === TableName.OIL_RECHARGE) {
				this.form.companyType = '其他';
			}
			if (this.tableName === TableName.REPAYMENT) {
				this.form.companyType = '其他';
			}
			// 如果是运费申请公司类型为司机
			if (this.tableName === TableName.ORDER_FREIGHT) {
				this.form.companyType = '司机';
				this.value = '司机';
			}
			// 如果是发票购入 对方公司类型那么就是供应商
			if (this.tableName === TableName.INVOICE_IN) {
				this.form.companyType = '供应商';
			}
			// 订单打款
			if (this.tableName === TableName.GOODS_ORDER) {
				this.form.companyType = '供应商';
			}
		},
		// 填充运费信息 这里是根据父组件传递过来的信息对象needInfo
		fillFreightInfo() {
			// 需要司机信息
			if (this.needInfo?.isExit !== undefined) {
				// 如果信息对象中需要司机信息
				if (this.needInfo?.isExit === true) {
					// 自动填充 拿到父组件传递过来的需要的信息对象 needInfo
					this.form.otherAcountsName = this.needInfo.otherAcountsName;
					this.form.companyName = this.needInfo.companyName;
					// 查询司机的银行卡信息 通过账户类型 和 账户名称 来绑定查询
					const search = {
						acountsType: '司机',
						acountsName: this.needInfo.otherAcountsName
					};
					listBankAccount(search).then(res => {
						this.form.otherBankNo = res.rows[0].bankNo;
						this.form.otherBankName = res.rows[0].bankName;
					});
				}
			}
		}
	}
};
