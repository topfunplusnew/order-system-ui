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
			if (value && value.companyName) {
				this.$set(this.form, 'fromInfo', value.companyName);
				this.$set(this.form, 'companyName', value.companyName);
			}
		}
	}
};
