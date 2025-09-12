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
	// 内部转账表单信息保存
	internalTransferFormData: {
		formId: null,
		sourceAccountInfo: null, // 转账账户信息
		targetAccountInfo: null, // 目标账户信息
		formData: null, // 完整表单数据
		timestamp: null // 保存时间戳
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
		// 更新对应角色的账户类型
		state.dualSelectionState[role] = accountType;
		// 重新计算是否有承兑选择
		state.hasAcceptanceSelection = state.dualSelectionState.source === BankAcceptanceType.ACCEPTANCE || state.dualSelectionState.target === BankAcceptanceType.ACCEPTANCE;
		console.log(state);
	},

	/**
	 * 重置双选择状态
	 * @param {Object} state - Vuex state
	 */
	RESET_DUAL_SELECTION(state) {
		state.dualSelectionState = {
			source: null,
			target: null
		};
		state.hasAcceptanceSelection = false;
	},

	/**
	 * 清除指定角色的选择
	 * @param {Object} state - Vuex state
	 * @param {Object} payload - { role: 'source'|'target' }
	 */
	CLEAR_ROLE_SELECTION(state, { role }) {
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
	 */
	resetDualSelection({ commit }) {
		commit('RESET_DUAL_SELECTION');
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
	}
};

export default {
	namespaced: true,
	state,
	mutations,
	actions,
	getters
};
