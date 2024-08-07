import Vue from 'vue'
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
  //修改的mutation
  CHANGE_ORDER_ITEM(state, orderItemInfo) {
    //组装orderItem对象 剔除index属性
    const {index, ...orderItem} = orderItemInfo;
    //修改状态
    //Vue.set(state.orderItemList[index], key, value);
    // state.orderItemList[index] = orderItem;  这样会失去响应式
    for (let property in orderItem)
      Vue.set(state.orderItemList[index], `${property}`, orderItem[property])
  },
}

const actions = {
  //添加
  addOrderItemList({commit}, orderItem) {
    commit('ADD_ORDER_ITEM_LIST', orderItem)
  },
  //修改
  //action只能传递一个参数
  changeOrderItem({commit}, orderItemInfo) {
    commit('CHANGE_ORDER_ITEM', orderItemInfo)
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
