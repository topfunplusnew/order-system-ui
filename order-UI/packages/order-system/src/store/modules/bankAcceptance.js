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
	activeFormId: null
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
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions,
	getters
};
