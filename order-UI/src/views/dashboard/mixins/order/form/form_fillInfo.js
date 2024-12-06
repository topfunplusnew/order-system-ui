// 这是订单表单的填充相关的逻辑混入，目的是为了避免OrderForm中的代码过于冗余

export var mixin_form_fillInfo = {
	data: function () {
		return {
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
		// 车队的自动填充
		handleChangeFleet(val) {
			this.queryFleet = val;
		},
		handleCommitBackFleet(val) {
			this.orderInfo.fleet = val.fname;
		},
		// 客户搜索的自动填充
		handleCommitBackCompany(val) {
			this.orderInfo.customerID = val.id;
			this.orderInfo.customer = val.companyName;
			this.orderInfo.saleManager = val.salesManager;
		},
		handleUpdateCompanyName(val) {
			this.queryCompanyName = val;
		},

		// 陆运车牌的自动填充
		handleChangeCar(val) {
			this.queryLandCar = val;
		},
		handleCommitBackCar(val) {
			this.orderInfo.landCarID = val.id;
			// 与上面填充客户信息同理
			this.orderInfo.landCarNo = val.carNo;
			this.orderInfo.landDriverName = val.driver;
			this.orderInfo.landDriverTel = val.tel;
			// 填充银行信息
			this.orderInfo.landBankName = val.bankName;
			this.orderInfo.landBankNo = val.bankNo;
		},
		// 海运车牌的填充
		handleChangeSeaCar(val) {
			this.querySeaCars = val;
		},
		handleCommitBackSeaCar(val) {
			this.orderInfo.seaCarID = val.id;
			// this.orderInfo.seaCarNo = val.carNo;  // 原为海运车牌号 现改为柜号 且不提供自动填充
			this.orderInfo.seaDriverName = val.driver;
			this.orderInfo.seaDriverTel = val.tel;
			// 填充银行信息
			this.orderInfo.seaBankName = val.bankName;
			this.orderInfo.seaBankNo = val.bankNo;
		}
	}
};
