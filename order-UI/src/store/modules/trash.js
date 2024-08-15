const state = {
  currentOrderInfo: {}
}

const mutations = {
  SET_CURRENT_ORDER_INFO(state, currentOrderInfo) {
    state.currentOrderInfo = currentOrderInfo
  }
}

const actions = {
  setCurrentOrderInfo({ commit }, currentOrderInfo) {
    commit('SET_CURRENT_ORDER_INFO', currentOrderInfo)
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
