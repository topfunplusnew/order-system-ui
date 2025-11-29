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
			// 填充物品信息（从入库记录获取）
			this.form.itemName = value.itemName;
			this.form.inId = value.id;
			// 预估价值可以从入库记录获取作为参考，但不强制
			if (value.estimatedValue) {
				this.$set(this.form, 'estimatedValue', value.estimatedValue);
			}
			// 数量不自动填充，由用户手动输入出库数量
		}
	}
};
