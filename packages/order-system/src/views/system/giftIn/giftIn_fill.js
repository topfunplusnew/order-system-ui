export var mixin_gift_in_fill = {
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
			if (value && value.companyName) {
				this.$set(this.form, 'fromInfo', value.companyName);
				this.$set(this.form, 'companyName', value.companyName);
			}
		},
		handleUpdateItemName(value) {
			this.itemName = value;
		},
		handleCommitBackGift(selectedItem) {
			if (selectedItem) {
				const isEditMode = this.form && this.form.id != null;
				
				// 从礼品库存获取物品名称
				this.$set(this.form, 'itemName', selectedItem.itemName || '');
				
				// 新增模式：从礼品库存同步单位等信息
				if (!isEditMode) {
					// 从礼品库存获取单位
					if (selectedItem.unit) {
						this.$set(this.form, 'unit', selectedItem.unit);
					}
					
					// 从礼品库存获取单价（如果有）
					if (selectedItem.unitPrice !== null && selectedItem.unitPrice !== undefined && selectedItem.unitPrice !== '') {
						const { round } = require('mathjs');
						const unitPrice = Number(selectedItem.unitPrice) || 0;
						this.$set(this.form, 'unitPrice', unitPrice > 0 ? round(unitPrice, 2).toFixed(2) : '');
					}
				}
			}
		}
	}
};
