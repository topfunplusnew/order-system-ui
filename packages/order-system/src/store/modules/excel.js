import Vue from 'vue';

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
	// 购买方临时信息存储 类型为数组
	purchaseTempInfo: [],
	// 卖家临时信息存储 类型为数组
	sellerTempInfo: [],
	// 导入模板数据（按购买方/销方）
	purchaseTemplateData: [],
	sellerTemplateData: []
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
	SET_SELECTED_ORDERS: (state, data) => {
		state.selectedOrders = data;
	},
	CLEAR_SELECTED_ORDERS: state => {
		state.selectedOrders = [];
	},
	SET_SELECTED_INVOICE_LIST: (state, data) => {
		state.selectedInvoiceList = data;
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
	// 加上开票金额
	ADD_INVOICE_AMOUNT: (state, data) => {
		// 开票金额不能为负数
		if (data < 0) {
			throw new Error('开票金额不能为负数');
		}

		// state.invoiceAmount += data;
		Vue.set(state, 'invoiceAmount', state.invoiceAmount + data);
	},
	// 扣除开票金额
	MULTI_INVOICE_AMOUNT: (state, data) => {
		// 开票金额不能为负数
		if (data < 0) {
			throw new Error('开票金额不能为负数');
		}

		// 不能超过原有的钱
		if (state.invoiceAmount - data < 0) {
			throw new Error('超出开票金额');
		}

		// state.invoiceAmount -= data;
		Vue.set(state, 'invoiceAmount', state.invoiceAmount - data);
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
	},
	SET_PURCHASE_TEMPLATE: (state, data) => {
		state.purchaseTemplateData = data;
	},
	CLEAR_PURCHASE_TEMPLATE: state => {
		state.purchaseTemplateData = [];
	},
	SET_SELLER_TEMPLATE: (state, data) => {
		state.sellerTemplateData = data;
	},
	CLEAR_SELLER_TEMPLATE: state => {
		state.sellerTemplateData = [];
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
		commit('CLEAR_SELLER_TEMP_INFO');
	},

	// template data for purchase/seller (from imported excel)
	setPurchaseTemplateData({ commit }, data) {
		commit('SET_PURCHASE_TEMPLATE', data);
	},
	clearPurchaseTemplateData({ commit }) {
		commit('CLEAR_PURCHASE_TEMPLATE');
	},
	setSellerTemplateData({ commit }, data) {
		commit('SET_SELLER_TEMPLATE', data);
	},
	clearSellerTemplateData({ commit }) {
		commit('CLEAR_SELLER_TEMPLATE');
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions
};
