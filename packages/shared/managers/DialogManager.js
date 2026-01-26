/**
 * 全局弹窗状态管理器
 * 用于管理路由切换时弹窗的隐藏和恢复
 */
class DialogManager {
	constructor() {
		this.routeDialogStates = new Map();
		this.currentRoute = '';
		this.routeWatchers = [];
	}

	/**
	 * 注册弹窗组件
	 * @param {string} routePath - 路由路径
	 * @param {string} dialogId - 弹窗唯一标识
	 * @param {Object} dialogComponent - 弹窗组件实例
	 */
	registerDialog(routePath, dialogId, dialogComponent) {
		if (!this.routeDialogStates.has(routePath)) {
			this.routeDialogStates.set(routePath, new Map());
		}

		this.routeDialogStates.get(routePath).set(dialogId, {
			component: dialogComponent,
			visible: false,
			wasVisible: false
		});
	}

	/**
	 * 注销弹窗组件
	 * @param {string} routePath - 路由路径
	 * @param {string} dialogId - 弹窗唯一标识
	 */
	unregisterDialog(routePath, dialogId) {
		if (this.routeDialogStates.has(routePath)) {
			this.routeDialogStates.get(routePath).delete(dialogId);
			if (this.routeDialogStates.get(routePath).size === 0) {
				this.routeDialogStates.delete(routePath);
			}
		}
	}

	/**
	 * 更新弹窗显示状态
	 * @param {string} routePath - 路由路径
	 * @param {string} dialogId - 弹窗唯一标识
	 * @param {boolean} visible - 是否显示
	 */
	updateDialogState(routePath, dialogId, visible) {
		if (this.routeDialogStates.has(routePath)) {
			const dialogState = this.routeDialogStates.get(routePath).get(dialogId);
			if (dialogState) {
				dialogState.visible = visible;
				dialogState.wasVisible = visible;
			}
		}
	}

	/**
	 * 路由切换前保存当前路由的弹窗状态并隐藏所有弹窗
	 * @param {string} fromRoute - 离开的路由
	 */
	hideDialogsOnRouteLeave(fromRoute) {
		if (this.routeDialogStates.has(fromRoute)) {
			const dialogs = this.routeDialogStates.get(fromRoute);
			dialogs.forEach((dialogState, dialogId) => {
				dialogState.wasVisible = dialogState.visible;
				if (dialogState.visible && dialogState.component) {
					this.hideDialog(dialogState.component);
				}
			});
		}
	}

	/**
	 * 路由切换后恢复目标路由的弹窗状态
	 * @param {string} toRoute - 进入的路由
	 */
	restoreDialogsOnRouteEnter(toRoute) {
		if (this.routeDialogStates.has(toRoute)) {
			const dialogs = this.routeDialogStates.get(toRoute);
			dialogs.forEach((dialogState, dialogId) => {
				if (dialogState.wasVisible && dialogState.component) {
					setTimeout(() => {
						this.showDialog(dialogState.component);
					}, 50);
				}
			});
		}
	}

	/**
	 * 隐藏弹窗
	 * @param {Object} component - 组件实例
	 */
	hideDialog(component) {
		const dialogProps = ['dialogVisible', 'visible', 'open', 'show'];

		for (const prop of dialogProps) {
			if (component.hasOwnProperty(prop)) {
				component[prop] = false;
				break;
			}
		}
	}

	/**
	 * 显示弹窗
	 * @param {Object} component - 组件实例
	 */
	showDialog(component) {
		const dialogProps = ['dialogVisible', 'visible', 'open', 'show'];

		for (const prop of dialogProps) {
			if (component.hasOwnProperty(prop)) {
				component[prop] = true;
				break;
			}
		}
	}

	/**
	 * 处理路由变化
	 * @param {string} fromRoute - 来源路由
	 * @param {string} toRoute - 目标路由
	 */
	handleRouteChange(fromRoute, toRoute) {
		if (fromRoute && fromRoute !== toRoute) {
			this.hideDialogsOnRouteLeave(fromRoute);
		}

		if (toRoute) {
			this.currentRoute = toRoute;
			setTimeout(() => {
				this.restoreDialogsOnRouteEnter(toRoute);
			}, 100);
		}
	}

	/**
	 * 清除指定路由的所有弹窗状态
	 * @param {string} routePath - 路由路径
	 */
	clearRouteDialogs(routePath) {
		if (this.routeDialogStates.has(routePath)) {
			this.routeDialogStates.delete(routePath);
		}
	}

	/**
	 * 获取当前路由的弹窗数量
	 * @param {string} routePath - 路由路径
	 * @returns {number} 弹窗数量
	 */
	getDialogCount(routePath) {
		if (this.routeDialogStates.has(routePath)) {
			return this.routeDialogStates.get(routePath).size;
		}
		return 0;
	}
}

// 导出单例实例
const dialogManager = new DialogManager();
export { DialogManager };
export default dialogManager;
