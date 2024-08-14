//货物入库状态管理
const state = {
  inventoryInfoAll: {}
}

const mutations = {
  SET_INVENTORY_INFO_ALL(state, inventoryInfoAll) {
    Object.assign(state.inventoryInfoAll, inventoryInfoAll)
  }
}

const actions = {
  setInventoryInfoAll({commit}, inventoryInfoAll) {
    commit('SET_INVENTORY_INFO_ALL', inventoryInfoAll)
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
