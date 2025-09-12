/**
 * 银行承兑双选择状态管理模块
 * 用于管理内部转账场景下的跨组件承兑状态
 */

import { BankAcceptanceType } from '@/api/tool/enums';

const state = {
	// 双选择状态：记录支出方和收入方的账户类型选择
	dualSelectionState: {
		source: null,
		target: null
	},
	// 是否有任一方选择了承兑类型
	hasAcceptanceSelection: false,
	// 当前激活的表单实例ID（用于区分不同的双选择场景）
	activeFormId: null,
	// 内部转账表单信息保存
	internalTransferFormData: {
		formId: null,
		sourceAccountInfo: null, // 转账账户信息
		targetAccountInfo: null, // 目标账户信息
		formData: null, // 完整表单数据
		timestamp: null // 保存时间戳
	},
	// 承兑表单暂存数据管理
	acceptanceFormDrafts: {
		// 使用 formId + componentId 作为key，存储多个表单实例的草稿
		// 格式: { [formId_componentId]: { formData: {}, timestamp: number } }
	}
};

const mutations = {
	/**
	 * 设置某一方的账户类型选择
	 * @param {Object} state - Vuex state
	 * @param {Object} payload - { role: 'source'|'target', accountType: string, formId: string }
	 */
	SET_ACCOUNT_TYPE_SELECTION(state, { role, accountType, formId }) {
		console.log('SET_ACCOUNT_TYPE_SELECTION called with:', { role, accountType, formId });
		// 边界条件检查
		if (!['source', 'target'].includes(role)) {
			return;
		}
		// 设置激活的表单ID
		state.activeFormId = formId;
		// 更新对应角色的账户类型
		state.dualSelectionState[role] = accountType;
		// 重新计算是否有承兑选择
		state.hasAcceptanceSelection = state.dualSelectionState.source === BankAcceptanceType.ACCEPTANCE || state.dualSelectionState.target === BankAcceptanceType.ACCEPTANCE;
		console.log(state);
	},

	/**
	 * 重置双选择状态
	 * @param {Object} state - Vuex state
	 * @param {string} formId - 可选的表单ID，如果提供则只重置对应表单的状态
	 */
	RESET_DUAL_SELECTION(state, formId = null) {
		if (formId && state.activeFormId !== formId) {
			// 如果指定了formId且不匹配当前激活的表单ID，则不执行重置
			return;
		}

		state.dualSelectionState = {
			source: null,
			target: null
		};
		state.hasAcceptanceSelection = false;
		state.activeFormId = null;
	},

	/**
	 * 清除指定角色的选择
	 * @param {Object} state - Vuex state
	 * @param {Object} payload - { role: 'source'|'target', formId: string }
	 */
	CLEAR_ROLE_SELECTION(state, { role, formId }) {
		if (state.activeFormId !== formId) {
			return;
		}

		state.dualSelectionState[role] = null;

		// 重新计算是否有承兑选择
		state.hasAcceptanceSelection = state.dualSelectionState.source === BankAcceptanceType.ACCEPTANCE || state.dualSelectionState.target === BankAcceptanceType.ACCEPTANCE;
	},

	/**
	 * 保存内部转账表单信息
	 * @param {Object} state - Vuex state
	 * @param {Object} payload - { formId, accountInfo, accountType: 'source'|'target', formData }
	 */
	SAVE_INTERNAL_TRANSFER_FORM_DATA(state, { formId, accountInfo, accountType, formData }) {
		// 如果是新的表单ID，清空之前的数据
		if (state.internalTransferFormData.formId !== formId) {
			state.internalTransferFormData = {
				formId: formId,
				sourceAccountInfo: null,
				targetAccountInfo: null,
				formData: null,
				timestamp: Date.now()
			};
		}

		// 保存账户信息
		if (accountType === 'source') {
			state.internalTransferFormData.sourceAccountInfo = accountInfo;
		} else if (accountType === 'target') {
			state.internalTransferFormData.targetAccountInfo = accountInfo;
		}

		// 保存完整表单数据
		if (formData) {
			state.internalTransferFormData.formData = { ...formData };
		}

		// 更新时间戳
		state.internalTransferFormData.timestamp = Date.now();
	},

	/**
	 * 清除内部转账表单信息
	 * @param {Object} state - Vuex state
	 * @param {string} formId - 可选的表单ID，如果提供则只清除对应表单的信息
	 */
	CLEAR_INTERNAL_TRANSFER_FORM_DATA(state, formId = null) {
		if (formId && state.internalTransferFormData.formId !== formId) {
			// 如果指定了formId且不匹配当前保存的表单ID，则不执行清除
			return;
		}

		state.internalTransferFormData = {
			formId: null,
			sourceAccountInfo: null,
			targetAccountInfo: null,
			formData: null,
			timestamp: null
		};
	},

	/**
	 * 保存承兑表单草稿
	 * @param {Object} state - Vuex state
	 * @param {Object} payload - { formId, componentId, formData }
	 */
	SAVE_ACCEPTANCE_FORM_DRAFT(state, { formId, componentId, formData }) {
		const key = `${formId}_${componentId}`;
		state.acceptanceFormDrafts[key] = {
			formData: { ...formData },
			timestamp: Date.now()
		};
	},

	/**
	 * 清除承兑表单草稿
	 * @param {Object} state - Vuex state
	 * @param {Object} payload - { formId, componentId } 或者 { clearAll: true }
	 */
	CLEAR_ACCEPTANCE_FORM_DRAFT(state, payload) {
		if (payload.clearAll) {
			// 清除所有草稿
			state.acceptanceFormDrafts = {};
		} else {
			const { formId, componentId } = payload;
			const key = `${formId}_${componentId}`;
			delete state.acceptanceFormDrafts[key];
		}
	},

	/**
	 * 清除指定表单ID下的所有承兑表单草稿
	 * @param {Object} state - Vuex state
	 * @param {string} formId - 表单ID
	 */
	CLEAR_ACCEPTANCE_FORM_DRAFTS_BY_FORM_ID(state, formId) {
		const keys = Object.keys(state.acceptanceFormDrafts);
		keys.forEach(key => {
			if (key.startsWith(`${formId}_`)) {
				delete state.acceptanceFormDrafts[key];
			}
		});
	}
};

const actions = {
	/**
	 * 设置账户类型选择
	 * @param {Object} context - Vuex context
	 * @param {Object} payload - 选择参数
	 */
	setAccountTypeSelection({ commit }, payload) {
		commit('SET_ACCOUNT_TYPE_SELECTION', payload);
	},

	/**
	 * 重置双选择状态
	 * @param {Object} context - Vuex context
	 * @param {string} formId - 表单ID
	 */
	resetDualSelection({ commit }, formId) {
		commit('RESET_DUAL_SELECTION', formId);
	},

	/**
	 * 清除角色选择
	 * @param {Object} context - Vuex context
	 * @param {Object} payload - 清除参数
	 */
	clearRoleSelection({ commit }, payload) {
		commit('CLEAR_ROLE_SELECTION', payload);
	},

	/**
	 * 保存内部转账表单信息
	 * @param {Object} context - Vuex context
	 * @param {Object} payload - 表单信息参数
	 */
	saveInternalTransferFormData({ commit }, payload) {
		commit('SAVE_INTERNAL_TRANSFER_FORM_DATA', payload);
	},

	/**
	 * 清除内部转账表单信息
	 * @param {Object} context - Vuex context
	 * @param {string} formId - 表单ID
	 */
	clearInternalTransferFormData({ commit }, formId) {
		commit('CLEAR_INTERNAL_TRANSFER_FORM_DATA', formId);
	},

	/**
	 * 保存承兑表单草稿
	 * @param {Object} context - Vuex context
	 * @param {Object} payload - 草稿参数
	 */
	saveAcceptanceFormDraft({ commit }, payload) {
		commit('SAVE_ACCEPTANCE_FORM_DRAFT', payload);
	},

	/**
	 * 清除承兑表单草稿
	 * @param {Object} context - Vuex context
	 * @param {Object} payload - 清除参数
	 */
	clearAcceptanceFormDraft({ commit }, payload) {
		commit('CLEAR_ACCEPTANCE_FORM_DRAFT', payload);
	},

	/**
	 * 清除指定表单ID下的所有承兑表单草稿
	 * @param {Object} context - Vuex context
	 * @param {string} formId - 表单ID
	 */
	clearAcceptanceFormDraftsByFormId({ commit }, formId) {
		commit('CLEAR_ACCEPTANCE_FORM_DRAFTS_BY_FORM_ID', formId);
	}
};

const getters = {
	/**
	 * 获取当前双选择状态
	 * @param {Object} state - Vuex state
	 * @returns {Object} 双选择状态对象
	 */
	dualSelectionState: state => state.dualSelectionState,

	/**
	 * 检查是否有承兑选择
	 * @param {Object} state - Vuex state
	 * @returns {boolean} 是否有承兑选择
	 */
	hasAcceptanceSelection: state => state.hasAcceptanceSelection,

	/**
	 * 检查双方是否都已选择
	 * @param {Object} state - Vuex state
	 * @returns {boolean} 双方是否都已选择
	 */
	bothSelectedInDualMode: state => {
		return !!(state.dualSelectionState.source && state.dualSelectionState.target);
	},

	/**
	 * 获取当前激活的表单ID
	 * @param {Object} state - Vuex state
	 * @returns {string|null} 表单ID
	 */
	activeFormId: state => state.activeFormId,

	/**
	 * 检查是否应该显示承兑抽屉（双选择模式下）
	 * @param {Object} state - Vuex state
	 * @param {Object} getters - Vuex getters
	 * @returns {boolean} 是否应该显示承兑抽屉
	 */
	shouldShowAcceptanceDrawerInDualMode: (state, getters) => {
		return getters.bothSelectedInDualMode && state.hasAcceptanceSelection;
	},

	/**
	 * 获取保存的内部转账表单信息
	 * @param {Object} state - Vuex state
	 * @returns {Object} 内部转账表单信息
	 */
	internalTransferFormData: state => state.internalTransferFormData,

	/**
	 * 获取保存的转账账户信息
	 * @param {Object} state - Vuex state
	 * @returns {Object|null} 转账账户信息
	 */
	sourceAccountInfo: state => state.internalTransferFormData.sourceAccountInfo,

	/**
	 * 获取保存的目标账户信息
	 * @param {Object} state - Vuex state
	 * @returns {Object|null} 目标账户信息
	 */
	targetAccountInfo: state => state.internalTransferFormData.targetAccountInfo,

	/**
	 * 获取保存的完整表单数据
	 * @param {Object} state - Vuex state
	 * @returns {Object|null} 完整表单数据
	 */
	savedFormData: state => state.internalTransferFormData.formData,

	/**
	 * 检查是否有保存的内部转账表单信息
	 * @param {Object} state - Vuex state
	 * @returns {boolean} 是否有保存的信息
	 */
	hasSavedInternalTransferData: state => {
		return !!(state.internalTransferFormData.formId && (state.internalTransferFormData.sourceAccountInfo || state.internalTransferFormData.targetAccountInfo));
	},

	/**
	 * 获取指定承兑表单的草稿数据
	 * @param {Object} state - Vuex state
	 * @returns {Function} 接受 formId 和 componentId 参数的函数
	 */
	getAcceptanceFormDraft: state => (formId, componentId) => {
		const key = `${formId}_${componentId}`;
		return state.acceptanceFormDrafts[key] || null;
	},

	/**
	 * 检查指定承兑表单是否有草稿数据
	 * @param {Object} state - Vuex state
	 * @returns {Function} 接受 formId 和 componentId 参数的函数
	 */
	hasAcceptanceFormDraft: state => (formId, componentId) => {
		const key = `${formId}_${componentId}`;
		return !!(state.acceptanceFormDrafts[key] && state.acceptanceFormDrafts[key].formData);
	},

	/**
	 * 获取所有承兑表单草稿
	 * @param {Object} state - Vuex state
	 * @returns {Object} 所有草稿数据
	 */
	acceptanceFormDrafts: state => state.acceptanceFormDrafts
};

export default {
	namespaced: true,
	state,
	mutations,
	actions,
	getters
};
