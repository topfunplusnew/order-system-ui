import ModelDialog from './index.vue';

const ModelPlugin = {
	install(Vue) {
		Vue.prototype.$model = function (options) {
			const ModelConstructor = Vue.extend(ModelDialog);
			// 生成唯一标识
			const uniqueId = `model-dialog-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
			// 创建容器并设置唯一标识
			const container = document.createElement('div');
			container.id = uniqueId;
			document.body.appendChild(container);
			// 创建组件实例
			const instance = new ModelConstructor({
				propsData: {
					visible: true,
					type: options.type || 'object',
					// 数组
					items: options.items || [],
					array: options.array || [],

					// 对象
					data: options.data || {},
					labels: options.labels || {},
					title: options.title || '信息展示',
					needToTotal: options.needToTotal || []
				}
			});
			// 监听 update:visible 事件
			instance.$on('update:visible', val => {
				if (!val) {
					instance.visible = false; // 直接修改 visible 属性
					this.$nextTick(() => {
						instance.$destroy(); // 销毁 Vue 实例

						// 根据唯一标识找到并移除 DOM 节点
						const elementToRemove = document.getElementById(uniqueId);
						if (elementToRemove) {
							document.body.removeChild(elementToRemove);
						}
					});
				}
			});
			// 挂载实例到容器
			instance.$mount(container);
		};
	}
};

export default ModelPlugin;
