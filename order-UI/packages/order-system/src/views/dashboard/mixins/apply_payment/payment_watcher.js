import { listBankAccount } from '../../../../api/system/bankAccount';

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
		// 是否为多个付款申请
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
		// 监听银行卡的变化 如果传入的银行卡信息有变化 就自动填充
		'needInfo.bankNo': {
			handler(val) {
				// 如果传入的银行卡是空的就直接返回
				if (val === undefined) {
					if (this.isOtherButtonDisabled) {
						this.$notification.open({
							message: '未找到对应的银行卡信息',
							description: '该付款申请信息中的银行卡信息不存在,可能被删除或填写错误!',
							onClick: () => {
								console.log('Notification Clicked!');
							}
						});
					}
					return;
				}
				// 否则去查询银行卡数据
				const search = {
					bankNo: this.needInfo.bankNo,
					bankName: this.needInfo.bankName,
					acountsName: this.needInfo.acountsName
				};
				listBankAccount(search).then(res => {
					// 如果没有查到 那么就提示 并且清空数据
					if (res.rows.length === 0) {
						this.$notification['error']({
							message: '未找到对应的银行卡信息',
							description: '该付款申请信息中的银行卡信息不存在,可能被删除或填写错误!',
							onClick: () => {
								console.log('Notification Clicked!');
							}
						});
						this.form.otherAcountsName = '';
						this.form.otherBankNo = '';
						this.form.otherBankName = '';
					} else {
						this.form.otherAcountsName = res.rows[0].acountsName;
						this.form.otherBankNo = res.rows[0].bankNo;
						this.form.otherBankName = res.rows[0].bankName;
					}
				});
			},
			deep: true
		},
		// 检测整个对象
		needInfo: {
			handler(val) {
				if (JSON.stringify(this.needInfo) !== '{}') {
					this.fillFreightInfo();
				} else {
					this.loadForm();
				}
			},
			deep: true
		},
		// 监听传入的金额
		needMoney: {
			handler(val) {
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
		}
	},
	methods: {}
};
