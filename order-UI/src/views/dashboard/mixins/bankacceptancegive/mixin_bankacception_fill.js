export const mixin_bank_acception_fill = {
	data: function () {
		return {
			queryBank: ''
		};
	},
	methods: {
		handleCommitBack(val) {
			this.form.billAccount = val.acountsName;
		},
		handleUpdateQueryName(val) {
			this.queryBank = val;
		}
	}
};
