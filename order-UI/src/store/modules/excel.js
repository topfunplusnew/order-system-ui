const state = {
  excelData: []
}

const mutations = {
  SET_EXCEL_DATA: (state, data) => {
    state.excelData = data
  },
  CLEAR_EXCEL_DATA: (state) => {
    state.excelData = []
  },
}

const actions = {
  setExcelData({commit}, data) {
    commit('SET_EXCEL_DATA', data)
  },
  clearExcelData({commit}) {
    commit('CLEAR_EXCEL_DATA')
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
