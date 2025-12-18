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
// 替换原有的 handleCommitBackItem 方法
		handleCommitBackItem(selectedItem) {
			if (selectedItem) {
				const isEditMode = this.form && this.form.id != null;

				// 同步物品名称（从入库记录获取）
				this.$set(this.form, 'itemName', selectedItem.itemName || '');

				// 设置入库记录ID（inId）- 用于关联入库记录
				// 优先使用 id 字段，如果没有则尝试使用其他可能的字段
				let inId = null;
				if (selectedItem.id) {
					inId = Number(selectedItem.id);
				} else if (selectedItem.inId) {
					inId = Number(selectedItem.inId);
				}

				if (inId && !isNaN(inId) && inId > 0) {
					this.$set(this.form, 'inId', inId);
					console.log('设置入库记录ID (inId):', inId, '来源数据:', selectedItem);
				} else {
					console.warn('无法从选中项获取有效的入库记录ID:', selectedItem);
					// 如果无法获取 inId，清空它（允许手动输入物品名称时不关联入库记录）
					this.$set(this.form, 'inId', null);
				}

				// 新增模式：从入库记录同步单位、单价等信息
				// 修改：使用 /system/giftIn/list 接口，返回的是入库记录数据
				if (!isEditMode) {
					// 从入库记录获取单位
					this.$set(this.form, 'unit', selectedItem.unit || '');

					// 从入库记录获取单价：优先使用入库记录的单价，否则根据金额和数量计算
					const { divide, round } = require('mathjs');
					let unitPrice = 0;
					if (selectedItem.unitPrice !== null && selectedItem.unitPrice !== undefined && selectedItem.unitPrice !== '') {
						unitPrice = Number(selectedItem.unitPrice);
					} else if (selectedItem.estimatedValue && selectedItem.quantity) {
						const estimatedValue = Number(selectedItem.estimatedValue) || 0;
						const quantity = Number(selectedItem.quantity) || 0;
						if (quantity > 0) {
							unitPrice = round(divide(estimatedValue, quantity), 2);
						}
					}
					this.$set(this.form, 'unitPrice', unitPrice > 0 ? unitPrice : null);

					// 注意：出库数量需要用户手动输入，不能自动填充
				}

				// 如果已有出库数量，自动计算金额
				if (this.form.quantity && this.form.unitPrice) {
					this.calculateAmount();
				}
			}
		}

	}

};
