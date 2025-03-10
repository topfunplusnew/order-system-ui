import { getDownLoadProgress } from '@/api/system/onceDownload';

const state = {
	percent: 0
};
const mutations = {
	SET_PERCENT(state, percent) {
		state.percent = percent;
	}
};

const actions = {
	async setPercent({ commit }, data) {
		const { data: value } = await getDownLoadProgress();
		if (value) {
			commit('SET_PERCENT', value.NowProgress);
		}
		if (data) {
			commit('SET_PERCENT', data);
		}
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions
};
