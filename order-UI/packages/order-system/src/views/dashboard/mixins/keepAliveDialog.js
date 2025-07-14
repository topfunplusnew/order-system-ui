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
		if (!this.hasOwnProperty('open') && !this.hasOwnProperty('dialogVisible')) return;
		// 确保缓存对象存在
		if (!this._keepAliveStates) this._keepAliveStates = {};
		Object.keys(this.$data).forEach(key => {
			const val = this.$data[key];
			// 判断布尔类型且命名以 Visible 或 visible 或 open 结尾
			if (typeof val === 'boolean' && (key.endsWith('Visible') || key === 'open')) {
				console.log(key);
				this._keepAliveStates[key] = val;
				this[key] = false;
			}
		});
	},
	// keep-alive 激活时，恢复所有记录的可见属性
	activated() {
		Object.entries(this._keepAliveStates).forEach(([key, val]) => {
			this[key] = val;
		});
		// 清空缓存
		this._keepAliveStates = {};
	}
};
