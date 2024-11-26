// 通用的 只给付款模块使用的 全局银行卡账户类型  有两种类型 由字典管理 分别为 现金户 和 承兑户

export var mixin_bankType = {
	methods: {
		// 填充己方的银行卡账户类型
		changeSelfBankType(value) {
			if (this.form && typeof this.form === 'object') {
				this.$set(this.form, 'selfBankCardType', value);
			} else {
				console.log('form unexpected');
			}
		},
		// 填充对方的银行卡账户类型
		changeOtherBankType(value) {
			if (this.form && typeof this.form === 'object') {
				this.$set(this.form, 'otherBankCardType', value);
			} else {
				console.log('form unexpected');
			}
		}
	}
};
