/**
 * 附件上传管理模块
 * 全局文件 ID 池管理
 */

const state = {
	// 全局的附件 ID 池
	attachmentIds: []
};

const mutations = {
	// 添加附件 ID 到全局池
	ADD_ATTACHMENT_ID(state, fileId) {
		if (!state.attachmentIds.includes(fileId)) {
			state.attachmentIds.push(fileId);
		}
	},

	// 从全局池移除附件 ID
	REMOVE_ATTACHMENT_ID(state, fileId) {
		const index = state.attachmentIds.indexOf(fileId);
		if (index > -1) {
			state.attachmentIds.splice(index, 1);
		}
	},

	// 清空全局附件 ID 池
	CLEAR_ATTACHMENT_IDS(state) {
		state.attachmentIds = [];
	},

	// 设置全局附件 ID 池
	SET_ATTACHMENT_IDS(state, ids) {
		state.attachmentIds = [...ids];
	}
};

const actions = {
	// 添加附件 ID
	addAttachmentId({ commit }, fileId) {
		commit('ADD_ATTACHMENT_ID', fileId);
	},

	// 移除附件 ID
	removeAttachmentId({ commit }, fileId) {
		commit('REMOVE_ATTACHMENT_ID', fileId);
	},

	// 清空附件 ID 池
	clearAttachmentIds({ commit }) {
		commit('CLEAR_ATTACHMENT_IDS');
	},

	// 设置附件 ID 池
	setAttachmentIds({ commit }, ids) {
		commit('SET_ATTACHMENT_IDS', ids);
	}
};

const getters = {
	// 获取全局附件 ID 数组
	getAttachmentIds: state => {
		return state.attachmentIds;
	},

	// 获取标准格式的 params 对象
	getParams: state => {
		return {
			params: {
				attachmentIds: state.attachmentIds
			}
		};
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions,
	getters
};
