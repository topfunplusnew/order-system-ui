//审核流程
const state = {
  checkStepList: []
}

const mutations = {
  //添加审核流程
  addCheckStep(state, stepInfo) {
    state.checkStepList.push(stepInfo)
  },
  //清空审核流程列表
  clearCheckStepList(state) {
    state.checkStepList = []
  },
  //修改
  updateStepNum(state, stepNum) {
    state.checkStepList.forEach(item => item.stepnum = stepNum)
  }
}

const actions = {
  //添加审核流程
  addCheckStep({commit}, stepInfo) {
    commit('addCheckStep', stepInfo)
  },
  //清空审核流程列表
  clearCheckStepList({commit}) {
    commit('clearCheckStepList')
  },
  //修改
  updateStepNum({commit}, stepNum) {
    commit('updateStepNum', stepNum)
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
