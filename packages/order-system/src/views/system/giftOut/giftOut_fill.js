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
				const isEditMode = this.form && this.form.id != null;
				console.log('[handleCommitBackItem] 模式:', isEditMode ? '编辑模式' : '新增模式', '出库ID:', this.form?.id);
				
				// 同步物品名称
				this.$set(this.form, 'itemName', selectedItem.itemName || '');
				// 同步入库ID（关键步骤，用于关联入库记录）
				this.$set(this.form, 'inId', selectedItem.id);
				
				// ⭐ 编辑模式下：不覆盖 unit 和 unitPrice，保持原有值
				// 新增模式下：从入库记录同步 unit 和 unitPrice
				if (!isEditMode) {
					// 新增模式：同步单位（规格）
					this.$set(this.form, 'unit', selectedItem.unit || '');
					// 同步单价（优先使用入库记录的单价）
					const unitPrice = selectedItem.unitPrice !== null && selectedItem.unitPrice !== undefined 
						? Number(selectedItem.unitPrice) 
						: (selectedItem.estimatedValue && selectedItem.quantity 
							? Number(selectedItem.estimatedValue) / Number(selectedItem.quantity) 
							: 0);
					this.$set(this.form, 'unitPrice', unitPrice);
					console.log('[handleCommitBackItem] 新增模式 - 已设置 unit:', selectedItem.unit, 'unitPrice:', unitPrice);
				} else {
					// 编辑模式：只更新 originalUnit 和 originalUnitPrice（用于后续校验）
					// 但不覆盖 form.unit 和 form.unitPrice（保持用户当前编辑的值）
					const unitPrice = selectedItem.unitPrice !== null && selectedItem.unitPrice !== undefined 
						? Number(selectedItem.unitPrice) 
						: (selectedItem.estimatedValue && selectedItem.quantity 
							? Number(selectedItem.estimatedValue) / Number(selectedItem.quantity) 
							: 0);
					this.originalUnit = selectedItem.unit;
					this.originalUnitPrice = unitPrice;
					console.log('[handleCommitBackItem] 编辑模式 - 已更新 originalUnit:', this.originalUnit, 'originalUnitPrice:', this.originalUnitPrice);
					console.log('[handleCommitBackItem] 编辑模式 - 保持 form.unit:', this.form.unit, 'form.unitPrice:', this.form.unitPrice);
				}
				
				// 同步存货地点（如果有）
				if (selectedItem.inventoryLocation) {
					this.$set(this.form, 'inventoryLocation', selectedItem.inventoryLocation);
				}
				// 如果有数量，根据数量和单价自动计算金额
				if (this.form.quantity) {
					const { multiply, round } = require('mathjs');
					const quantity = Number(this.form.quantity) || 0;
					const price = this.form.unitPrice || 0;
					if (quantity > 0 && price > 0) {
						const result = multiply(quantity, price);
						this.$set(this.form, 'estimatedValue', round(result, 2));
					}
				} else if (selectedItem.estimatedValue && !isEditMode) {
					// 新增模式下，如果没有数量，使用入库记录的预估价值作为参考
					this.$set(this.form, 'estimatedValue', Number(selectedItem.estimatedValue) || 0);
				}
				// 更新显示的剩余数量（优先使用 selectedItem 中的剩余数量，如果没有则重新计算）
				if (selectedItem.remainingQuantity !== null && selectedItem.remainingQuantity !== undefined) {
					this.$set(this, 'remainingQuantity', selectedItem.remainingQuantity);
					this.$set(this.form, 'remainingQuantity', selectedItem.remainingQuantity);
				} else {
					// 如果没有，则重新计算
					this.calculateRemainingQuantity(selectedItem.id);
				}
				// 触发 Vue 响应式更新
				this.$forceUpdate();
			}
		}
	}
};
