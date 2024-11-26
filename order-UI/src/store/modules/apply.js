// 订单状态信息 由订单Item组件主动推入
const state = {
	checked: ''
};

const mutations = {
	// 使用的时候 传入一个状态 修改
	SET_CHECKED(state, status) {
		state.checked = status;
	},
	CLEAR_CHECKED(state) {
		state.checked = '';
	}
};

const actions = {
	setChecked({ commit }, status) {
		commit('SET_CHECKED', status);
	},
	// 重置标记
	clearChecked({ commit }) {
		commit('CLEAR_CHECKED', status);
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions
};
