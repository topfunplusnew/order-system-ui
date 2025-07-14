/**
 * 全局弹窗状态管理器
 * 用于管理路由切换时弹窗的隐藏和恢复
 */

class DialogManager {
	constructor() {
		// 存储每个路由对应的弹窗状态
		this.routeDialogStates = new Map();
		// 当前路由
		this.currentRoute = '';
		// 路由监听器
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
			wasVisible: false // 记录路由切换前的状态
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
			// 如果该路由下没有弹窗了，删除整个路由记录
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
				// 保存当前状态
				dialogState.wasVisible = dialogState.visible;
				// 如果弹窗当前是显示的，则隐藏它
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
	/**
	 * 路由切换后恢复目标路由的弹窗状态
	 * @param {string} toRoute - 进入的路由
	 */
	restoreDialogsOnRouteEnter(toRoute) {
		if (this.routeDialogStates.has(toRoute)) {
			const dialogs = this.routeDialogStates.get(toRoute);
			dialogs.forEach((dialogState, dialogId) => {
				// 如果之前是显示状态，则恢复显示
				if (dialogState.wasVisible && dialogState.component) {
					// 延迟执行，确保DOM更新完成
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
		// 通用的隐藏方法，适配不同的弹窗属性名
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
		// 通用的显示方法，适配不同的弹窗属性名
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
			// 延迟恢复，确保路由切换完成
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
export default new DialogManager();
