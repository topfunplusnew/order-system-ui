import { getDownLoadProgress } from '@/api/system/onceDownload';
import { fix } from '../../api/tool/format';

const state = {
	percent: 0
};
const mutations = {
	SET_PERCENT(state, percent) {
		state.percent = percent;
	}
};

const actions = {
	setPercent({ commit }, data) {
		// 如果传入直接的进度值，直接使用它
		if (data !== undefined) {
			commit('SET_PERCENT', data);
			return;
		}
		
		// 当没有传入数据时，默认为0（重置）
		commit('SET_PERCENT', 0);
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions
};
