import { listBalanceAccounts } from '@/api/system/BalanceAccounts';

const state = {
	// 平账信息
	balanceaccountsList: []
};

const mutations = {
	GET_BALANCEACCOUNTS_LIST(state, payload) {
		state.balanceaccountsList = payload;
	}
};

// 获取平账信息
const actions = {
	getbalanceaccountsList({ commit }) {
		listBalanceAccounts().then(res => {
			commit('GET_BALANCEACCOUNTS_LIST', res.data);
		});
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions
};
