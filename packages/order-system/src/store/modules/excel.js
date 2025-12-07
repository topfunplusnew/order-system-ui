// 维护开票金额的模块

const state = {
	// 公共票点
	ticketPoint: 0,
	// 公共备注
	comment: '',
	// 打开的批量开票页面 已经选中的订单列表
	selectedOrders: [],
	// 选中的批量开票的列表
	selectedInvoiceList: [],
	// 开票金额 用于判断是否超过了金额 超过不允许开票
	invoiceAmount: 0,
	// 批量开票详情数据（从后端获取，用于生成发票）
	batchDetailRows: [],
	// 当前批量开票的凭证号
	currentVoucher: '',
	// 当前批量开票的模式（in/out）
	currentMode: 'in'
};

const mutations = {
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
	ADD_INVOICE_AMOUNT: (state, data) => {
		if (data < 0) {
			console.error('开票金额不能为负数');
			return;
		}
		state.invoiceAmount = state.invoiceAmount + data;
	},
	SUBTRACT_INVOICE_AMOUNT: (state, data) => {
		if (data < 0) {
			console.error('开票金额不能为负数');
			return;
		}
		state.invoiceAmount = state.invoiceAmount - data;
	},
	SET_BATCH_DETAIL_ROWS: (state, data) => {
		state.batchDetailRows = data || [];
	},
	CLEAR_BATCH_DETAIL_ROWS: state => {
		state.batchDetailRows = [];
	},
	SET_CURRENT_VOUCHER: (state, data) => {
		state.currentVoucher = data || '';
	},
	SET_CURRENT_MODE: (state, data) => {
		state.currentMode = data || 'in';
	},
	// 更新批次详情中某条记录的开票状态
	UPDATE_BATCH_ROW_INVOICED: (state, { id, invoiced, invoiceId }) => {
		const row = state.batchDetailRows.find(r => r.id === id);
		if (row) {
			row.invoiced = invoiced;
			if (invoiceId) {
				row.invoiceId = invoiceId;
			}
		}
	}
};

const actions = {
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
	addInvoiceAmount({ commit }, data) {
		commit('ADD_INVOICE_AMOUNT', data);
	},
	subtractInvoiceAmount({ commit }, data) {
		commit('SUBTRACT_INVOICE_AMOUNT', data);
	},
	setBatchDetailRows({ commit }, data) {
		commit('SET_BATCH_DETAIL_ROWS', data);
	},
	clearBatchDetailRows({ commit }) {
		commit('CLEAR_BATCH_DETAIL_ROWS');
	},
	setCurrentVoucher({ commit }, data) {
		commit('SET_CURRENT_VOUCHER', data);
	},
	setCurrentMode({ commit }, data) {
		commit('SET_CURRENT_MODE', data);
	},
	updateBatchRowInvoiced({ commit }, payload) {
		commit('UPDATE_BATCH_ROW_INVOICED', payload);
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions
};
