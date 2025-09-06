// payment/index.vue所需的付款
import { PAYMENT_TARGET_TYPE } from '../../../api/tool/enums';
export var mixin_paymentindex_fill = {
	data: function () {
		return {
			// bank搜索
			queryBank: '',
			companyName: '',
			// 银行卡选择搜索
			queryChoose: '',

			// 对方银行卡号的搜索
			queryBankAcount: ''
		};
	},
	methods: {
		// 自动填充我方信息
		handleCommitBack(val) {
			this.form.selfBankName = val.bankName;
			this.form.selfAccountsName = val.acountsName;
			this.form.selfBankNo = val.bankNo;
			this.form.selfBankID = val.id;
		},
		// 选择我方银行卡
		handleCommitBackChoose(val) {
			this.chooseInfo.selfBankName = val.bankName;
			this.chooseInfo.selfAccountsName = val.acountsName;
			this.chooseInfo.selfBankNo = val.bankNo;
		},
		// 填充对方公司信息
		handleCommitBackCompany(val) {
			if (this.value !== PAYMENT_TARGET_TYPE.DRIVER) {
				this.form.companyName = val.companyName;
			} else {
				this.form.companyName = val.driver;
			}
			this.form.companyId = val.id;
		},
		// 填充对方新信息
		handleCommitBackBankAcount(val) {
			this.form.otherBankName = val.bankName;
			this.form.otherAcountsName = val.acountsName;
			this.form.otherBankNo = val.bankNo;
		},
		handleUpdateQueryBankAcount(val) {
			this.queryBankAcount = val;
		},
		// 这些方法是组件中的检索字段填充方法
		handleUpdateQueryChoose(val) {
			this.queryChoose = val;
		},
		handleUpdateQueryName(val) {
			this.queryBank = val;
		}
	}
};
