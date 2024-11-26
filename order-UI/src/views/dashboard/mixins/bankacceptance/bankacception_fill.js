export var mixin_bankacception_fill = {
	data: function () {
		return {
			queryBank: ''
		};
	},
	methods: {
		handleUpdateQueryName(val) {
			this.queryBank = val;
		}
	}
};
