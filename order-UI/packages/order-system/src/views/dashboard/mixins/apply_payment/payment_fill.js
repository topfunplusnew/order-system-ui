// 付款申请的付款填充逻辑文件

export var mixin_payment_fill = {
	data: function () {
		return {
			// 对方户名
			queryCompany: '',
			// 查询
			queryOther: ''
		};
	},
	methods: {
		// 填充 公司名称  点击后自动填充
		handleUpdateQueryNameOther(val) {
			this.queryOther = val;
		},
		handleCommitBackOther(val) {
			this.form.companyName = val.companyName;
			this.form.companyType = val.companyType;
			this.form.companyId = val.id;
		},
		// 对方信息(银行卡信息) - 点击确认后自动填充
		handleCommitBack(val) {
			// 如果选择的是员工 银行卡中的companyId即可填充
			if (this.value === '员工') {
				this.form.companyId = val.companyId;
			}
			this.form.otherBankNo = val.bankNo;
			this.form.otherBankName = val.bankName;
			this.form.otherAccountsName = val.acountsName;
		},
		handleUpdateQueryName(val) {
			this.queryCompany = val;
		}
	}
};
