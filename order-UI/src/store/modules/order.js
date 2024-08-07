//订单状态信息 由订单Item组件主动推入
const state = {
  //订单详情列表
  orderItemList: [],
}

const mutations = {
  //添加订单详情列表
  ADD_ORDER_ITEM_LIST(state, orderItem) {
    state.orderItemList.push(orderItem)
  },
  CHANGE_ORDER_ITEM(state, index, orderItem) {
    state.orderItemList[index] = orderItem;
  },
}

const actions = {
  //添加
  addOrderItemList({commit}, orderItem) {
    commit('ADD_ORDER_ITEM_LIST', orderItem)
  },
  //修改
  changeOrderItem({commit}, index, orderItem) {
    commit('CHANGE_ORDER_ITEM', index, orderItem)
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
