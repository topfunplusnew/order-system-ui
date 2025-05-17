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
		// 如果传入直接的进度值，先确保它是有效数字
		if (data !== undefined) {
			// 确保进度是数字且在有效范围内
			const percent = Number(data);
			if (!isNaN(percent)) {
				// 限制进度在0-100之间
				const validPercent = Math.max(0, Math.min(100, percent));
				commit('SET_PERCENT', validPercent);
				return;
			}
		}

		// 当没有传入有效数据时，默认为0（重置）
		commit('SET_PERCENT', 0);
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions
};
