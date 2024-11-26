import InventoryForm from '@/views/dashboard/components/inventory/InventoryForm.vue';

export var mixin_inventory_add = {
	data: function () {
		return {
			// 货物入库
			invoiceInVisible: false,
			// 库存信息
			inventoryInfo: {
				storeDate: '',
				storeHouseName: '',
				carNo: '',
				tel: ''
			},
			// 仓库信息
			storeList: []
		};
	},
	methods: {
		// 添加货物
		addNewInventory() {
			this.resetInventoryInfo();
			this.openDialog(InventoryForm, '添加货物', '1300px', {});
		},
		// 重置仓库信息
		resetInventoryInfo() {
			this.inventoryInfo = {
				storeDate: '',
				storeHouseName: '',
				carNo: '',
				tel: ''
			};
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加库存';
		}
	}
};
