import { Message } from 'element-ui';

const state = {
	// 读取的excel数据sheets列表
	excelData: [],
	// 公共票点
	ticketPoint: 0,
	// 公共备注
	comment: '',
	// 打开的批量开票页面 已经选中的订单列表
	selectedOrders: [],
	// 选中的批量开票的列表 需要对订单列表进行处理 差一个选中订单后对订单的数据处理为开票的信息 然后交给右边组件进行批处理
	selectedInvoiceList: [],
	// 开票金额 用于判断是否超过了金额 超过不允许开票
	invoiceAmount: 0,
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
	SET_TICKET_POINT: (state, data) => {
		state.ticketPoint = data;
	},
	CLEAR_TICKET_POINT: state => {
		state.ticketPoint = 0;
	},
	SET_COMMENT: (state, data) => {
		state.comment = data;
	},
	CLEAR_COMMENT: state => {
		state.comment = '';
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
	SET_SELECTED_INVOICE_LIST: (state, data) => {
		state.selectedInvoiceList = data;
		console.log('批量开票信息:', state.selectedInvoiceList);
	},
	CLEAR_SELECTED_INVOICE_LIST: state => {
		state.selectedInvoiceList = [];
	},
	SET_INVOICE_AMOUNT: (state, data) => {
		state.invoiceAmount = data;
	},
	CLEAR_INVOICE_AMOUNT: state => {
		state.invoiceAmount = 0;
	},
	// 扣除开票金额
	MULTI_INVOICE_AMOUNT: (state, data) => {
		// 不能超过原有的钱
		if (state.invoiceAmount - data < 0) {
			throw new Error('超出开票金额');
		}
		state.invoiceAmount -= data;
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
	setTicketPoint({ commit }, data) {
		commit('SET_TICKET_POINT', data);
	},
	clearTicketPoint({ commit }) {
		commit('CLEAR_TICKET_POINT');
	},

	setComment({ commit }, data) {
		commit('SET_COMMENT', data);
	},
	clearComment({ commit }) {
		commit('CLEAR_COMMENT');
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
	setSelectedInvoiceList({ commit }, data) {
		commit('SET_SELECTED_INVOICE_LIST', data);
	},
	clearSelectedInvoiceList({ commit }) {
		commit('CLEAR_SELECTED_INVOICE_LIST');
	},
	setInvoiceAmount({ commit }, data) {
		commit('SET_INVOICE_AMOUNT', data);
	},
	clearInvoiceAmount({ commit }) {
		commit('CLEAR_INVOICE_AMOUNT');
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
