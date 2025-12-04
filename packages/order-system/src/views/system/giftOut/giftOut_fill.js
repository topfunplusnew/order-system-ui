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
			if (value) {
				// 填充客户信息
				this.form.companyName = value.companyName;
				// 设置客户ID
				this.form.recipientInfo = value.id;
				// 填充对方客户类型（优先使用选中公司的类型，如果没有则使用当前选择的 companyType）
				this.form.recipientType = value.companyType || this.companyType;
				// 同步更新 companyType 变量，确保下拉框显示正确
				if (value.companyType) {
					this.companyType = value.companyType;
				}
			}
		},
		handleUpdateItemName(value) {
			this.itemName = value;
		},
		handleCommitBackItem(selectedItem) {
			if (selectedItem) {
				// 设置礼品来源名称
				this.$set(this.form, 'itemName', selectedItem.itemName);
				// 设置入库ID（关键步骤）
				this.$set(this.form, 'inId', selectedItem.id);
				// 可选：自动填充预估价值
				if (selectedItem.estimatedValue) {
					this.$set(this.form, 'estimatedValue', selectedItem.estimatedValue);
				}
				// 更新显示的剩余数量
				this.calculateRemainingQuantity(selectedItem.id);
			}
		}
	}
};
