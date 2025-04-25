import { getDownLoadProgress } from '@/api/system/onceDownload';
import { Message, MessageBox } from 'element-ui';
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
	async setPercent({ commit }, data) {
		const { data: value } = await getDownLoadProgress();
		Message.success(value.message);
		const percent = fix(value.NowProgress / value.MaxProgress, 1) * 100;
		if (value) {
			commit('SET_PERCENT', percent);
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
