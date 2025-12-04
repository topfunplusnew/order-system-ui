export var mixin_gift_in_fill = {
	data: function () {
		return {
			companyName: ''
		};
	},
	methods: {
		handleUpdateCompanyName(value) {
			this.companyName = value;
		},
		handleCommitBackCompany(value) {
			this.form.fromInfo = value.companyName;
		}
	}
};
