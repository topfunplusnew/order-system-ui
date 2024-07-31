import {listBorrowedMoney} from "@/api/system/borrowedMoney";

/**
 * 获取借款列表的状态信息
 * @type {{tempBorrowedMoneyList: *[]}}
 */
const state = {
  tempBorrowedMoneyList: []
}

const mutations = {
  setTempBorrowedMoneyList(state, tempBorrowedMoneyList) {
    state.tempBorrowedMoneyList = tempBorrowedMoneyList
  }
}

const actions = {
  // 获取临时借款列表
  getTempBorrowedMoneyList({commit}, payload) {
    return new Promise((resolve, reject) => {
      listBorrowedMoney(this.queryParams).then(response => {
        let tempList = response.rows
        tempList.forEach(item => {
          item.isEnd = item.isEnd ? '是' : '否'
        })
        commit('setTempBorrowedMoneyList', tempList)
        resolve(response)
      }).catch(err => {
        reject(err)
      })
    })
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
