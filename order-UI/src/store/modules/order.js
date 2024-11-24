// 订单模块
const state = {
  // 订单货物列表
  orderItemList: [],
}

const mutations = {
  // 设置货物列表
  setOrderItemList(state, data) {
    state.orderItemList = data
  },
  // 添加货物到货物列表中
  addsOrderItem(state, data) {
    state.orderItemList.push(data)
  },
  // 移除货物
  removeOrderItem(state, index) {
    state.orderItemList.splice(index, 1)
  },
  // 修改货物的状态
  changeOrderItemStatus(state, payload) {
    // 获取传入的状态
    const { orderIndex, ...orderInfo } = payload
    state.orderItemList = state.orderItemList.map(item => {
      if (item.orderIndex === orderIndex) {
        return { ...orderInfo };
      }
      return item;
    });
  },

  clearOrderItemList(state) {
    state.orderItemList = []
  }
}

const actions = {
  // 设置订单货物信息
  setOrderItemListAsync({ commit }, data) {
    commit('setOrderItemList', data)
  },
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
