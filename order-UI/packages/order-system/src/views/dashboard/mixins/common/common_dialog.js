import Vue from 'vue';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';

/**
 * 通用弹窗混入：动态创建 DialogWrapper 实例，每次打开都是新实例
 */
export var common_dialog = {
	data() {
		return {
			currentComponent: null,
			dialogVisible: false,
			// 存储动态创建的弹窗实例
			_dialogInstances: [],
			// 存储弹窗配置，用于重新创建
			_dialogConfigs: []
		};
	},
	watch: {
		dialogVisible(newVal) {
			console.log(`弹窗状态变化: ${newVal}`);
		}
	},
	created() {
		// 确保数组在组件创建时就初始化
		if (!this._dialogConfigs) {
			this._dialogConfigs = [];
		}
		if (!this._dialogInstances) {
			this._dialogInstances = [];
		}
	},
	methods: {
		openDialog(component, title, width = '50%', props = {}, closeConfirm = false) {
			// 确保数组已初始化
			if (!this._dialogConfigs) {
				this._dialogConfigs = [];
			}
			if (!this._dialogInstances) {
				this._dialogInstances = [];
			}

			const dialogId = Date.now() + Math.random(); // 生成唯一ID

			// 保存弹窗配置，用于重新创建
			const dialogConfig = {
				id: dialogId,
				component,
				title,
				width,
				props,
				closeConfirm,
				visible: true
			};
			this._dialogConfigs.push(dialogConfig);

			// 创建弹窗实例
			this._createDialogInstance(dialogConfig);
		},

		_createDialogInstance(config) {
			// 确保数组已初始化
			if (!this._dialogInstances) {
				this._dialogInstances = [];
			}

			const DialogConstructor = Vue.extend(DialogWrapper);
			const instance = new DialogConstructor({
				store: this.$store,
				propsData: {
					currentComponent: config.component,
					dialogVisible: config.visible,
					dialogProps: config.props,
					dialogTitle: config.title,
					dialogWidth: config.width,
					closeConfirm: config.closeConfirm
				}
			}).$mount();

			// 添加配置ID到实例
			instance._configId = config.id;

			document.body.appendChild(instance.$el);
			this._dialogInstances.push(instance); // 监听 close 事件
			instance.$on('close', callback => {
				Promise.resolve(callback(this)).finally(() => {
					this._reallyCloseDialog(config.id);
					this.getList && this.getList();
				});
			});

			// 监听 confirm 事件
			instance.$on('confirm', callback => {
				Promise.resolve(callback(this))
					.then(() => {
						// 只有在成功时才关闭弹窗和刷新列表
						this._reallyCloseDialog(config.id);
						this.getList && this.getList();
					})
					.catch(error => {
						// 失败时不关闭弹窗，只记录错误
						console.error('弹窗确认操作失败:', error);
						// 可以在这里添加全局错误处理逻辑
					});
			});
		},
		_closeDialog(configId) {
			// 确保数组已初始化
			if (!this._dialogConfigs) {
				this._dialogConfigs = [];
			}
			if (!this._dialogInstances) {
				this._dialogInstances = [];
			}

			// 从配置中移除
			const configIndex = this._dialogConfigs.findIndex(config => config.id === configId);
			if (configIndex > -1) {
				this._dialogConfigs.splice(configIndex, 1);
			}

			// 销毁实例
			const instanceIndex = this._dialogInstances.findIndex(instance => instance._configId === configId);
			if (instanceIndex > -1) {
				const instance = this._dialogInstances[instanceIndex];
				if (instance.$el && instance.$el.parentNode) {
					instance.$el.parentNode.removeChild(instance.$el);
				}
				instance.$destroy();
				this._dialogInstances.splice(instanceIndex, 1);
			}
		},

		// 真正关闭弹窗（用户点击关闭或确认时调用）
		_reallyCloseDialog(configId) {
			this._closeDialog(configId);
		},
		// 隐藏所有弹窗（keep-alive deactivated 时调用）
		_hideAllDialogs() {
			if (!this._dialogInstances) {
				this._dialogInstances = [];
				return;
			}
			this._dialogInstances.forEach(instance => {
				if (instance && instance.hideDialog) {
					instance.hideDialog();
				}
			});
		},

		// 显示所有弹窗（keep-alive activated 时调用）
		_showAllDialogs() {
			if (!this._dialogInstances) {
				this._dialogInstances = [];
				return;
			}
			this._dialogInstances.forEach(instance => {
				if (instance && instance.showDialog) {
					instance.showDialog();
				}
			});
		},

		// 重新创建所有弹窗（用于页面激活时）
		_recreateAllDialogs() {
			// 直接显示所有弹窗，不需要重新创建
			this._showAllDialogs();
		}
	}
};
