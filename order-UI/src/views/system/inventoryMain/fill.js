// 这是订单表单的填充相关的逻辑混入，目的是为了避免OrderForm中的代码过于冗余

export var _fill = {
	data: function () {
		return {
			queryStore: '',
			// 客户搜索
			queryCompanyName: '',
			// 车牌银行卡
			queryLandCar: '',
			// 车队
			queryFleet: '',
			// 海运车牌
			querySeaCars: ''
		};
	},
	methods: {
		handleCommitBackInventory(val) {
			this.form.storeHouseid = val.id;
			this.form.storeHouseName = val.storeHouseName;
		},
		handleUpdateQueryNameStore(value) {
			this.queryStore = value;
		},
		// 车队的自动填充
		handleChangeFleet(val) {
			this.queryFleet = val;
		},
		handleCommitBackFleet(val) {
			this.form.fleet = val.fname;
		},
		// 客户搜索的自动填充
		handleCommitBackCompany(val) {
			this.form.customerID = val.id;
			this.form.customer = val.companyName;
			this.form.saleManager = val.salesManager;
		},
		handleUpdateCompanyName(val) {
			this.queryCompanyName = val;
		},

		// 陆运车牌的自动填充
		handleChangeCar(val) {
			this.queryLandCar = val;
		},
		handleCommitBackCar(val) {
			this.form.landCarID = val.id;
			// 与上面填充客户信息同理
			this.form.landCarNo = val.carNo;
			this.form.landDriverName = val.driver;
			this.form.landDriverTel = val.tel;
			// 填充银行信息
			this.form.landBankName = val.bankName;
			this.form.landBankNo = val.bankNo;
		},
		// 海运车牌的填充
		handleChangeSeaCar(val) {
			this.querySeaCars = val;
		},
		handleCommitBackSeaCar(val) {
			this.form.seaCarID = val.id;
			this.form.seaDriverName = val.driver;
			this.form.seaDriverTel = val.tel;
			// 填充银行信息
			this.form.seaBankName = val.bankName;
			this.form.seaBankNo = val.bankNo;
		}
	}
};
