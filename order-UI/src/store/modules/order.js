import Vue from 'vue'
import {listGoodsOrder} from "@/api/system/goodsOrder";
//订单状态信息 由订单Item组件主动推入
const state = {
  //订单详情列表
  orderItemList: [],
  //订单列表
  orderList: []
}

const mutations = {
  //添加订单详情列表
  ADD_ORDER_ITEM_LIST(state, orderItem) {
    state.orderItemList.push(orderItem)
  },
  //删除订单详情
  DELETE_ORDER_ITEM(state, index) {
    state.orderItemList.splice(index, 1)
  },
  //清空填写缓存
  CLEAR_ORDER_ITEM_LIST(state) {
    state.orderItemList = []
  },
  //修改订单详情
  CHANGE_ORDER_ITEM(state, orderItemInfo) {
    //组装orderItem对象 剔除index属性
    const {index, ...orderItem} = orderItemInfo;
    //修改状态
    //Vue.set(state.orderItemList[index], key, value);
    // state.orderItemList[index] = orderItem;  这样会失去响应式
    for (let property in orderItem) {
      Vue.set(state.orderItemList[index], `${property}`, orderItem[property])
    }
  },


  //修改订单列表
  CHANGE_ORDER_LIST(state, orderList) {
    state.orderList = orderList
  }

}

const actions = {
  //1.订单详情
  //添加
  addOrderItemList({commit}, orderItem) {
    commit('ADD_ORDER_ITEM_LIST', orderItem)
  },
  //删除
  deleteOrderItem({commit}, index) {
    commit('DELETE_ORDER_ITEM', index)
  },
  //action只能传递一个参数
  changeOrderItem({commit}, orderItemInfo) {
    commit('CHANGE_ORDER_ITEM', orderItemInfo)
  },
  //清空填写缓存
  clearOrderItemList({commit}) {
    commit('CLEAR_ORDER_ITEM_LIST')
  },

  //2.订单列表
  //查询订单列表 赋值
  getOrderList({commit}) {
    listGoodsOrder().then(res => {
      commit('CHANGE_ORDER_LIST', res.rows)
    })
  },
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
