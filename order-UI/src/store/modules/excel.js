const state = {
	// 读取的excel数据sheets列表
	excelData: [],
	// 打开的批量开票页面 已经选中的订单列表
	selectedOrders: [],
	// todo 选中的批量开票的列表 需要对订单列表进行处理
	selectedInvoiceList: [],
	// 左侧选择的公司信息
	companyList: [],
	// 购买方临时信息存储 类型为数组
	purchaseTempInfo: [],
	// 卖家临时信息存储 类型为数组
	sellerTempInfo: []
};

const mutations = {
	SET_EXCEL_DATA: (state, data) => {
		state.excelData = data;
	},
	CLEAR_EXCEL_DATA: state => {
		state.excelData = [];
	},
	SET_COMPANY_LIST: (state, data) => {
		state.companyList = data;
	},
	CLEAR_COMPANY_LIST: state => {
		state.companyList = [];
	},

	SET_SELECTED_ORDERS: (state, data) => {
		state.selectedOrders = data;
	},
	CLEAR_SELECTED_ORDERS: state => {
		state.selectedOrders = [];
	},

	SET_PURCHASE_TEMP_INFO: (state, data) => {
		state.purchaseTempInfo = data;
	},
	CLEAR_PURCHASE_TEMP_INFO: state => {
		state.purchaseTempInfo = [];
	},
	SET_SELLER_TEMP_INFO: (state, data) => {
		state.sellerTempInfo = data;
	},
	CLEAR_SELLER_TEMP_INFO: state => {
		state.sellerTempInfo = [];
	}
};

const actions = {
	setExcelData({ commit }, data) {
		commit('SET_EXCEL_DATA', data);
	},
	clearExcelData({ commit }) {
		commit('CLEAR_EXCEL_DATA');
	},
	setCompanyList({ commit }, data) {
		commit('SET_COMPANY_LIST', data);
	},
	clearCompanyList({ commit }) {
		commit('CLEAR_COMPANY_LIST');
	},

	setSelectedOrders({ commit }, data) {
		commit('SET_SELECTED_ORDERS', data);
	},
	clearSelectedOrders({ commit }) {
		commit('CLEAR_SELECTED_ORDERS');
	},

	setPurchaseTempInfo({ commit }, data) {
		commit('SET_PURCHASE_TEMP_INFO', data);
	},
	clearPurchaseTempInfo({ commit }) {
		commit('CLEAR_PURCHASE_TEMP_INFO');
	},
	setSellerTempInfo({ commit }, data) {
		commit('SET_SELLER_TEMP_INFO', data);
	},
	clearSellerTempInfo({ commit }) {
		commit('CLEAR_SELLER_TEMP_INFO)');
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions
};
