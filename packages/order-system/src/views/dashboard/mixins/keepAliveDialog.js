// mixin: 缓存 keep-alive 下模态框状态
export default {
	data() {
		return {
			// 缓存所有 boolean 可见状态
			_keepAliveStates: {}
		};
	},
	// keep-alive 失活时，记录并隐藏所有 boolean 可见属性
	deactivated() {
		// 仅在组件自身管理的弹窗属性上生效(open或dialogVisible存在)
		if (!this.$data.hasOwnProperty('open') && !this.$data.hasOwnProperty('dialogVisible') && !this._dialogConfigs) {
			return;
		}
		// 确保缓存对象存在
		if (!this._keepAliveStates) this._keepAliveStates = {};

		// 处理普通的布尔弹窗状态
		Object.keys(this.$data).forEach(key => {
			const val = this.$data[key];
			// 判断布尔类型且命名以 Visible 或 visible 或 open 结尾
			if (typeof val === 'boolean' && (key.endsWith('Visible') || key === 'open')) {
				this._keepAliveStates[key] = val;
				this[key] = false;
			}
		});

		// 处理动态创建的弹窗（common_dialog）
		if (this._dialogConfigs && this._dialogConfigs.length > 0) {
			const name = this.$options.name || this.$options._componentTag || 'anonymous';
			console.log('[keepAliveDialog] deactivated 隐藏弹窗', name, 'count:', this._dialogConfigs.length);
			this._keepAliveStates._dynamicDialogs = [...this._dialogConfigs];
			// 隐藏所有动态弹窗
			if (this._hideAllDialogs) {
				this._hideAllDialogs();
			}
		}
	},
	// keep-alive 激活时，恢复所有记录的可见属性
	activated() {
		if (!this._keepAliveStates || Object.keys(this._keepAliveStates).length === 0) {
			return;
		}
		// 恢复普通的布尔弹窗状态
		Object.entries(this._keepAliveStates).forEach(([key, val]) => {
			if (key !== '_dynamicDialogs') {
				this[key] = val;
			}
		});

		// 恢复动态创建的弹窗
		if (this._keepAliveStates._dynamicDialogs) {
			const name = this.$options.name || this.$options._componentTag || 'anonymous';
			const count = this._keepAliveStates._dynamicDialogs.length;
			console.log('[keepAliveDialog] activated 恢复弹窗', name, 'count:', count);
			// 恢复弹窗配置
			this._dialogConfigs = [...this._keepAliveStates._dynamicDialogs];
			// 重新创建弹窗实例
			if (this._recreateAllDialogs) {
				this.$nextTick(() => {
					this._recreateAllDialogs();
				});
			}
		}

		// 清空缓存
		this._keepAliveStates = {};
	},

	// 组件销毁时清理动态弹窗
	beforeDestroy() {
		if (this._dialogInstances && this._dialogInstances.length > 0) {
			const name = this.$options.name || this.$options._componentTag || 'anonymous';
			console.log('[keepAliveDialog] beforeDestroy 清除弹窗（组件被销毁）', name, 'count:', this._dialogInstances.length);
			this._dialogInstances.forEach(instance => {
				if (instance.$el && instance.$el.parentNode) {
					instance.$el.parentNode.removeChild(instance.$el);
				}
				instance.$destroy();
			});
			this._dialogInstances = [];
		}
		if (this._dialogConfigs) {
			this._dialogConfigs = [];
		}
	}
};
