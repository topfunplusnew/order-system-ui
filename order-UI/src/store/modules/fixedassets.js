// 固定资产Vuex
import { listFixedAssets } from '@/api/system/fixedAssets';

const state = {
	fixedassetsList: []
};

const mutations = {
	setFixedassetsList(state, data) {
		state.fixedassetsList = data;
	}
};

const actions = {
	getFixedassetsList({ commit }) {
		listFixedAssets().then(res => {
			commit('setFixedassetsList', res.rows);
		});
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions
};
