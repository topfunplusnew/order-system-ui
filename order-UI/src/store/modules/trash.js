const state = {
  currentOrderInfo: {},
  // 订单运费
  freightInfo: {},

  // 部门
  deptName: ''
}

const mutations = {
  SET_CURRENT_ORDER_INFO(state, currentOrderInfo) {
    state.currentOrderInfo = currentOrderInfo
  },

  // 运费
  SET_FREIGHT_INFO(state, freightInfo) {
    state.freightInfo = freightInfo
  },
  // 清空
  CLEAR_CURRENT_ORDER_INFO(state) {
    state.currentOrderInfo = {}
  },

  // 设置部门名称
  SET_DEPT_NAME(state, deptName) {
    state.deptName = deptName
  },


}

const actions = {
  setCurrentOrderInfo({ commit }, currentOrderInfo) {
    commit('SET_CURRENT_ORDER_INFO', currentOrderInfo)
  },
  setFreightInfo({ commit }, freightInfo) {
    commit('SET_FREIGHT_INFO', freightInfo)
  },
  // 清空
  clearCurrentOrderInfo({ commit }) {
    commit('CLEAR_CURRENT_ORDER_INFO')
  },

  // 设置部门信息
  setDeptName({ commit }, deptName) {
    commit('SET_DEPT_NAME', deptName)
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
