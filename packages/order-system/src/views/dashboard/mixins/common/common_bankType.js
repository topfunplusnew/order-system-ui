// 通用的 只给付款模块使用的 全局银行卡账户类型  有两种类型 由字典管理 分别为 现金户 和 承兑户

import { BankAcceptanceType } from '@/api/tool/enums';

export var mixin_bankType = {
	methods: {
		// 填充我方的银行卡账户类型
		changeSelfBankType(value) {
			if (this.form && typeof this.form === 'object') {
				this.$set(this.form, 'selfBankCardType', value);
				if (value === BankAcceptanceType.ACCEPTANCE) {
					this.$set(this.form, 'otherBankCardType', BankAcceptanceType.ACCEPTANCE);
					this.form.params = {
						bankacceptance: null
					};
				}
				if (value === BankAcceptanceType.BANK_CASH) {
					this.$set(this.form, 'otherBankCardType', BankAcceptanceType.BANK_CASH);
					this.$bus.$emit('changeFlag', false);
				}
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
