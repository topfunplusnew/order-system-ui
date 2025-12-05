export var mixin_gift_out_fill = {
	data: function () {
		return {
			itemName: ''
		};
	},
	methods: {
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
