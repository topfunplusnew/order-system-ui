export var mixin_bankacception_fill = {
	data: function () {
		return {
			queryBank: '',
			// 背书人类型 默认为客户
			type: '客户',
			// 展示背书人
			endorser: '',
			// 搜索客户
			companyName: ''
		};
	},
	methods: {
		handleUpdateQueryName(val) {
			this.queryBank = val;
		},

		// 背书人相关的填充
		handleUpdateCompanyName(val) {
			this.companyName = val;
		},
		handleCommitBackCompany(val) {
			// 填充展示字段
			this.endorser = val.companyName;
			// 数据库修改 2024/12/5
			this.form.origin = val.companyType;
			this.form.endorser = val.id;
		}
	}
};
