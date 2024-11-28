export var mixin_excel_server = {
	methods: {
		// 将读取的数据存储到vuex中
		handleStoreExcel(data) {
			// 把读取的tableData存储到vuex中
			this.$store.dispatch('excel/setExcelData', data);
		},
		// 清除读取的数据
		handleClearExcel() {
			this.$store.dispatch('excel/clearExcelData');
		},
		// 读取excel存储的数据
		handleReadExcel() {
			return this.$store.getters.excelData;
		},

		// 暂存购买的信息
		handleStorePurchaseInfo(data) {
			this.$store.dispatch('excel/setPurchaseTempInfo', data);
		},
		handleClearPurchaseInfo() {
			this.$store.dispatch('excel/clearPurchaseTempInfo');
		},
		// 暂存卖出方的信息
		handleStoreSellerInfo(data) {
			this.$store.dispatch('excel/setSellerTempInfo', data);
		},
		handleClearSellerInfo() {
			this.$store.dispatch('excel/clearSellerTempInfo');
		}
	}
};
