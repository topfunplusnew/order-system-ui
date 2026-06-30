import _ from 'lodash';

// 创建运费 来源
export const FREIGHT_PAYMENT = {
	GOODS_ORDER: 'goodsorder',
	INVENTORY: 'inventory'
};

/**
 * 从运费记录关联的订单或库存对象中提取单据日期
 * @param {Object} row - 运费列表行（含 goodsOrder / inventoryMain）
 * @returns {string} 订单日期或入库日期
 */
export function getOrderFreightDocumentDate(row) {
	const goodsOrder = _.get(row, 'goodsOrder');
	const orderDate = _.get(goodsOrder, 'orderDate');
	if (orderDate) {
		return orderDate;
	}
	const inventoryMain = _.get(row, 'inventoryMain');
	const storeDate = _.get(inventoryMain, 'storeDate');
	return storeDate || '';
}

// 运费的相关填充信息
export var mixin_order_freight_fill = {
	data: function () {
		return {
			queryCompany: '',
			queryCars: '',
			queryFleet: ''
		};
	},
	methods: {
		// 己方公司点击确定的回调
		handleCommitBack(val) {
			this.form.otherBankNo = val.bankNo;
			this.form.otherBankName = val.bankName;
			this.form.companyName = val.companyName;
			this.form.companyId = val.id;
			this.form.otherAcountsName = val.acountsName;
			this.form.companyType = val.companyType;
		},
		handleCommitBackCars(val) {
			this.form.carNo = val.dictLabel;
		},
		updateQueryCars(val) {
			this.queryCars = val;
		},
		// update
		handleUpdateQueryName(val) {
			this.queryCompany = val;
		},
		handleCommitBackFleet(val) {
			this.form.fleet = val.fname;
		},
		updateQueryFleet(val) {
			this.queryFleet = val;
		}
	}
};
