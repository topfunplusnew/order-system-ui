import {listBorrowedMoney} from "@/api/system/borrowedMoney";
import {listRepayment} from "@/api/system/repayment";
import {listLendMoney} from "@/api/system/lendMoney";
import {listRecoverMoney} from "@/api/system/recoverMoney";

/**
 * 获取借款列表的状态信息
 * @type {{tempBorrowedMoneyList: *[]}}
 */
const state = {
  //借钱
  tempBorrowedMoneyList: [],
  //贷款还款记录
  tempRepaymentList: [],
  //向外借钱
  tempLendMoneyList: [],
  //资金收回
  tempRecoverMoneyList: [],

  //运费自动填充字段
  freightFee: 0,
}

const mutations = {
  //借钱
  setTempBorrowedMoneyList(state, tempBorrowedMoneyList) {
    state.tempBorrowedMoneyList = tempBorrowedMoneyList
  },
  //还款
  setRepaymentList(state, tempRepaymentList) {
    state.tempRepaymentList = tempRepaymentList
  },
  //向外借钱
  setTempLendMoneyList(state, tempLendMoneyList) {
    state.tempLendMoneyList = tempLendMoneyList
  },
  //资金收回
  setTempRecoverMoneyList(state, tempRecoverMoneyList) {
    state.tempRecoverMoneyList = tempRecoverMoneyList
  },

  //运费填充
  setFreightFee(state, freightFee) {
    state.freightFee = freightFee
  },
  //清空状态
  clearFreightFeeState(state) {
    state.freightFee = ''
  }
}

const actions = {
  // 获取临时借款列表
  getTempBorrowedMoneyList({commit}, payload) {
    return new Promise((resolve, reject) => {
      listBorrowedMoney().then(response => {
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
  },
  //获取还款信息
  getRepaymentList({commit}, payload) {
    return new Promise((resolve, reject) => {
      listRepayment().then(response => {
        let repaymentList = response.rows;
        commit('setRepaymentList', repaymentList)
        resolve(response)
      }).catch(err => {
        reject(err)
      })
    })
  },
  //向外借钱
  getTempLendMoneyList({commit}, payload) {
    return new Promise((resolve, reject) => {
      listLendMoney().then(response => {
        let tempLendMoneyList = response.rows
        commit('setTempLendMoneyList', tempLendMoneyList)
        resolve(response)
      }).catch(err => {
        reject(err)
      })
    })
  },
  //资金收回
  getTempRecoverMoneyList({commit}, payload) {
    return new Promise((resolve, reject) => {
        listRecoverMoney().then(response => {
          let tempRecoverMoneyList = response.rows
          commit('setTempRecoverMoneyList', tempRecoverMoneyList)
          resolve(response)
        })
      }
    )
  },

  //填充运费
  setFreightFree({commit}, payload) {
    commit('setFreightFee', payload)
  },
  //清空运费
  clearFreightFree({commit}) {
    commit('clearFreightFeeState')
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
