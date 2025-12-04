// src/constants/searchFields.js
export const SearchFieldEnum = {
	DATE_RANGE: 'dateRange',
	CUSTOMER: 'customer',
	SUPPLIER_NAMES: 'supplierNames',
	LAND_DRIVER_NAME: 'landDriverName',
	LAND_CAR_NO: 'landCarNo',
	SEA_DRIVER_NAME: 'seaDriverName',
	SEA_CAR_NO: 'seaCarNo',
	FLEET: 'fleet',
	USER_NAME: 'userName',
	SALE_MANAGER: 'saleManager',
	CHECK_STATE: 'checkState',
	IS_INCLUDE_TAX_FACTORY: 'isIncludeTaxFactory',
	IS_INCLUDE_TAX_SALE: 'isIncludeTaxSale',
	LEVEL_NAME: 'levelName',
	LENGTH: 'length',
	WIDTH: 'width',
	HEIGHT: 'height',

	// 获取所有字段配置
	getAllFields() {
		return [
			{ value: this.DATE_RANGE, label: '时间范围' },
			{ value: this.CUSTOMER, label: '客户名称' },
			{ value: this.SUPPLIER_NAMES, label: '供应商' },
			{ value: this.LAND_DRIVER_NAME, label: '司机名称' },
			{ value: this.LAND_CAR_NO, label: '车牌' },
			{ value: this.SEA_DRIVER_NAME, label: '海运公司' },
			{ value: this.SEA_CAR_NO, label: '柜号' },
			{ value: this.FLEET, label: '车队名称' },
			{ value: this.USER_NAME, label: '录入员' },
			{ value: this.SALE_MANAGER, label: '销售经理' },
			{ value: this.CHECK_STATE, label: '审核状态' },
			{ value: this.IS_INCLUDE_TAX_FACTORY, label: '供应商是否开票' },
			{ value: this.IS_INCLUDE_TAX_SALE, label: '客户是否开票' },
			{ value: this.LEVEL_NAME, label: '级别名称' },
			{ value: this.LENGTH, label: '长度' },
			{ value: this.WIDTH, label: '宽度' },
			{ value: this.HEIGHT, label: '厚度' }
		];
	},

	// 根据字段值获取标签
	getFieldLabel(fieldValue) {
		const field = this.getAllFields().find(f => f.value === fieldValue);
		return field ? field.label : fieldValue;
	}
};

export default SearchFieldEnum;
