export var mixin_gift_out_fill = {
	data: function () {
		return {
			companyName: '',
			itemName: ''
		};
	},
	methods: {
		handleUpdateCompanyName(value) {
			this.companyName = value;
		},
		handleCommitBackCompany(value) {
			// 填充客户信息
			this.form.companyName = value.companyName;
			// this.form.recipientInfo = value.id;

			// 填充对方客户类型
			this.form.recipientType = value.companyType;
		},
		handleUpdateItemName(value) {
			this.itemName = value;
		},
		handleCommitBackItem(value) {
			// 填充物品信息
			this.form.itemName = value.itemName;
			this.form.quantity = value.quantity;
			this.form.estimatedValue = value.estimatedValue;
			this.form.inId = value.id;
			// 如果后端返回了单位信息，也填充单位
			if (value.unit) {
				this.form.unit = value.unit;
			}
		}
	}
};
