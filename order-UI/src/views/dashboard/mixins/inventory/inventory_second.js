import { addExWarehouse } from '@/api/system/exWarehouse';
import { parseTime } from '../../../../utils/ruoyi';

export var mixin_inventory_second = {
	data: function () {
		return {
			// 二次出库
			secondNumber: 0,
			secondInvoiceInVisible: false,
			secondInfo: {}
		};
	},
	methods: {
		// 二次出库
		secondryInventoryOut(row) {
			// 组装二次出库需要的信息
			this.secondInfo = {
				ordersNo: '二次加工',
				storeHouseid: row.storeHouseid,
				storeHouseName: row.storeHouseName,
				storeID: row.id,
				outDate: parseTime(new Date())
			};
			this.secondInvoiceInVisible = true;
		},
		// 提交二次出库信息
		submitSecondInvoiceIn() {
			this.secondInfo.outAmount = this.secondNumber;
			addExWarehouse(this.secondInfo).then(() => {
				this.$message.success('加工后出库成功~');
				this.secondInvoiceInVisible = false;
				this.getList();
			});
		}
	}
};
