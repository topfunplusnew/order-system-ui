// 这是订单表单的填充相关的逻辑混入，目的是为了避免OrdersecondForm中的代码过于冗余

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
			this.secondForm.storeHouseid = val.id;
			this.secondForm.storeHouseName = val.storeHouseName;
		},
		handleUpdateQueryNameStore(value) {
			this.queryStore = value;
		},
		// 客户搜索的自动填充
		handleCommitBackCompany(val) {
			this.secondForm.customerID = val.id;
			this.secondForm.customer = val.companyName;
			this.secondForm.saleManager = val.salesManager;
		},
		handleUpdateCompanyName(val) {
			this.queryCompanyName = val;
		},

		// 陆运车牌的自动填充
		handleChangeCar(val) {
			this.queryLandCar = val;
		},
		handleCommitBackCar(val) {
			this.secondForm.landCarID = val.id;
			// 与上面填充客户信息同理
			this.secondForm.landCarNo = val.carNo;
			this.secondForm.landDriverName = val.driver;
			this.secondForm.landDriverTel = val.tel;
			// 填充银行信息
			this.secondForm.landBankName = val.bankName;
			this.secondForm.landBankNo = val.bankNo;
		},
		// 海运车牌的填充
		handleChangeSeaCar(val) {
			this.querySeaCars = val;
		},
		handleCommitBackSeaCar(val) {
			this.secondForm.seaCarID = val.id;
			this.secondForm.seaDriverName = val.driver;
			this.secondForm.seaDriverTel = val.tel;
			// 填充银行信息
			this.secondForm.seaBankName = val.bankName;
			this.secondForm.seaBankNo = val.bankNo;
		}
	}
};
