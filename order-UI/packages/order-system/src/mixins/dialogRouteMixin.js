/**
 * 弹窗路由管理混入
 * 用于自动管理弹窗在路由切换时的隐藏和显示
 */

import dialogManager from '@/utils/dialogManager';

export const dialogRouteMixin = {
	data() {
		return {
			// 当前组件的弹窗配置
			dialogConfigs: [],
			// 路由监听器
			unwatchRoute: null
		};
	},

	mounted() {
		// 监听路由变化
		this.unwatchRoute = this.$watch('$route', this.handleRouteChange, { immediate: false });

		// 注册当前组件的弹窗
		this.registerCurrentDialogs();
	},

	beforeDestroy() {
		// 注销路由监听
		if (this.unwatchRoute) {
			this.unwatchRoute();
		}

		// 注销当前组件的弹窗
		this.unregisterCurrentDialogs();
	},

	methods: {
		/**
		 * 注册弹窗
		 * @param {string} dialogId - 弹窗唯一标识（建议使用组件名+弹窗用途）
		 * @param {string} dialogProperty - 弹窗显示属性名（如 'open', 'visible', 'dialogVisible'）
		 */
		registerDialog(dialogId, dialogProperty = 'open') {
			const routePath = this.$route.path;
			const config = {
				dialogId,
				dialogProperty,
				routePath
			};

			this.dialogConfigs.push(config);
			dialogManager.registerDialog(routePath, dialogId, this);

			// 重写弹窗属性的 setter，用于监听状态变化
			this.watchDialogProperty(dialogProperty, routePath, dialogId);
		},

		/**
		 * 监听弹窗属性变化
		 * @param {string} property - 属性名
		 * @param {string} routePath - 路由路径
		 * @param {string} dialogId - 弹窗ID
		 */
		watchDialogProperty(property, routePath, dialogId) {
			this.$watch(property, newValue => {
				dialogManager.updateDialogState(routePath, dialogId, newValue);
			});
		},

		/**
		 * 注销弹窗
		 * @param {string} dialogId - 弹窗唯一标识
		 */
		unregisterDialog(dialogId) {
			const routePath = this.$route.path;
			dialogManager.unregisterDialog(routePath, dialogId);

			// 从配置中移除
			this.dialogConfigs = this.dialogConfigs.filter(config => config.dialogId !== dialogId);
		},

		/**
		 * 注册当前组件的所有弹窗
		 * 由子组件重写此方法来注册具体的弹窗
		 */
		registerCurrentDialogs() {
			// 例如：this.registerDialog('addOrderDialog', 'open');
		},

		/**
		 * 注销当前组件的所有弹窗
		 */
		unregisterCurrentDialogs() {
			this.dialogConfigs.forEach(config => {
				dialogManager.unregisterDialog(config.routePath, config.dialogId);
			});
			this.dialogConfigs = [];
		},

		/**
		 * 处理路由变化
		 * @param {Object} to - 目标路由
		 * @param {Object} from - 来源路由
		 */
		handleRouteChange(to, from) {
			const fromPath = from ? from.path : '';
			const toPath = to.path;

			dialogManager.handleRouteChange(fromPath, toPath);
		},

		/**
		 * 更新弹窗状态
		 * @param {string} dialogId - 弹窗标识
		 * @param {boolean} visible - 是否显示
		 */
		updateDialogState(dialogId, visible) {
			const routePath = this.$route.path;
			dialogManager.updateDialogState(routePath, dialogId, visible);
		}
	}
};
