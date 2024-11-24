const state = {
  // 读取的excel数据sheets列表
  excelData: [],
  // 暂存
  tempData: [],
  // 打开的批量开票页面 已经选中的订单列表
  selectedOrders: []
}

const mutations = {
  SET_EXCEL_DATA: (state, data) => {
    state.excelData = data
  },
  CLEAR_EXCEL_DATA: (state) => {
    state.excelData = []
  },

  SET_TEMP_DATA: (state, data) => {
    state.tempData = data
  },
  CLEAR_TEMP_DATA: (state) => {
    state.tempData = []
  },

  SET_SELECTED_ORDERS: (state, data) => {
    state.selectedOrders = data
  },
  CLEAR_SELECTED_ORDERS: (state) => {
    state.selectedOrders = []
  }
}

const actions = {
  setExcelData({ commit }, data) {
    commit('SET_EXCEL_DATA', data)
  },
  clearExcelData({ commit }) {
    commit('CLEAR_EXCEL_DATA')
  },

  // 暂存数据的操作
  setTempData({ commit }, data) {
    commit('SET_TEMP_DATA', data)
  },
  clearTempData({ commit }) {
    commit('CLEAR_TEMP_DATA')
  },

  setSelectedOrders({ commit }, data) {
    commit('SET_SELECTED_ORDERS', data)
  },
  clearSelectedOrders({ commit }) {
    commit('CLEAR_SELECTED_ORDERS')
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
