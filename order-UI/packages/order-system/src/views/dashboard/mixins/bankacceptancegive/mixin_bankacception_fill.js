export const mixin_bank_acception_fill = {
	data: function () {
		return {
			queryBank: '',
			// 背书人类型 默认为客户
			type: '客户',
			// 搜索客户
			companyName: ''
		};
	},
	methods: {
		handleCommitBack(val) {
			this.form.billAccount = val.acountsName;
		},
		handleUpdateQueryName(val) {
			this.queryBank = val;
		},

		// 背书人相关的填充
		handleUpdateCompanyName(val) {
			this.companyName = val;
		},
		handleCommitBackCompany(val) {
			// 填充展示字段
			this.form.endorserName = val.companyName;
			// 数据库修改 2024/12/5
			this.form.origin = val.companyType;
			this.form.endorser = val.id;
		}
	}
};
