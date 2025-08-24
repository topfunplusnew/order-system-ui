import { listBankAccount } from '../../../../api/system/bankAccount';
import { PAYMENT_TARGET_TYPE } from '@/api/tool/enums';

export var mixin_payment_watcher = {
	data: function () {
		return {};
	},
	props: {
		// 关联表名
		tableName: '',
		// 关联表的主键ID
		tID: '',
		// 需要自动填充的钱
		needMoney: {
			type: Number
		},
		// 需要自动填充的信息 包含 对方户名:acountsName 对方账号 bankNo 对方开户行 bankName 对方公司 companyName
		needInfo: {
			type: Object
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
		}
	},
	watch: {
		'needInfo.companyName': {
			handler(val) {
				this.form.companyName = val;
			},
			deep: true,
			immediate: true
		},
		// 检测整个needInfo对象，统一处理银行卡信息填充
		needInfo: {
			handler() {
				if (JSON.stringify(this.needInfo) !== '{}') {
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
	methods: {
		// 处理银行卡信息填充，避免重复调用
		handleBankAccountInfo() {
			// 只有在非付款状态且有银行卡号时才查询
			if (!this.isPayment && this.needInfo.bankNo) {
				const search = {
					bankNo: this.needInfo.bankNo,
					companyName: this.needInfo.companyName,
					companyId: this.needInfo.companyId
				};
				listBankAccount(search).then(res => {
					// 如果没有查到 那么就提示 并且清空数据
					if (res.rows.length === 0) {
						Object.assign(this.form, {
							otherAcountsName: '',
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
								otherAcountsName: res.rows[0].acountsName,
								otherBankNo: res.rows[0].bankNo,
								otherBankName: res.rows[0].bankName
							});
						}
					}
				});
			}
		}
	}
};
