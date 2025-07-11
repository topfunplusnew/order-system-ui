import Vue from 'vue';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';

/**
 * 通用弹窗混入：动态创建 DialogWrapper 实例，每次打开都是新实例
 */
export var common_dialog = {
	methods: {
		openDialog(component, title, width = '50%', props = {}, closeConfirm = false) {
			const DialogConstructor = Vue.extend(DialogWrapper);
			const instance = new DialogConstructor({
				propsData: {
					currentComponent: component,
					dialogVisible: true,
					dialogProps: props,
					dialogTitle: title,
					dialogWidth: width,
					closeConfirm: closeConfirm
				}
			}).$mount();
			document.body.appendChild(instance.$el);
			// 监听 close 事件，执行回调并销毁实例
			instance.$on('close', callback => {
				Promise.resolve(callback(this)).finally(() => {
					this.getList && this.getList();
					document.body.removeChild(instance.$el);
					instance.$destroy();
				});
			});
			// 监听 confirm 事件，执行回调并销毁实例
			instance.$on('confirm', callback => {
				Promise.resolve(callback(this)).finally(() => {
					this.getList && this.getList();
					document.body.removeChild(instance.$el);
					instance.$destroy();
				});
			});
		}
	}
};
