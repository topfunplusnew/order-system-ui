import CodeLessSystemLayer from './components/CodeLessSystemLayer.vue';
import CodeLessMenu from './components/CodeLessMenu.vue';
import { setRequest } from './api/request';
import { crud } from './utils/crud';
import { apiEndpointService, HTTP_METHODS, ENDPOINT_STATUS } from './services/apiEndpoint';

export default {
  /**
   * Vue 插件安装方法
   * @param {Vue} Vue Vue构造函数
   * @param {object} options 插件配置
   * @param {Function} options.request Axios实例或请求方法
   * @param {object} options.router VueRouter实例，用于动态注册路由
   */
  install(Vue, options = {}) {
    // 注入请求实例
    if (options.request) {
      setRequest(options.request);
    }

    // 注册全局组件
    Vue.component('CodeLessSystemLayer', CodeLessSystemLayer);
    Vue.component('CodeLessMenu', CodeLessMenu);

    // 挂载全局方法
    Vue.prototype.$codelessCrud = crud;
    Vue.prototype.$codelessApi = apiEndpointService;

    // 动态注册路由
    if (options.router) {
      const routes = [
        {
          path: '/codeless',
          name: 'CodeLess',
          component: CodeLessSystemLayer,
          meta: { title: '低代码平台', icon: 'monitor' }
        }
      ];
      options.router.addRoutes(routes);
      console.log('[CodeLess] 动态路由已注册: /codeless');
    }
  },

  // 导出组件和工具，支持按需引入
  CodeLessSystemLayer,
  CodeLessMenu,
  crud,
  apiEndpointService,
  HTTP_METHODS,
  ENDPOINT_STATUS,
  setRequest
};
