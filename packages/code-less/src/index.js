// 简单的入口导出
import CodeLessEditor from './components/CodeLessEditor.vue';
import { setRequest } from './api/request';
import { crud } from './utils/crud';

export default {
  /**
   * Vue 插件安装方法
   * @param {Vue} Vue Vue构造函数
   * @param {object} options 插件配置
   * @param {Function} options.request Axios实例或请求方法
   * @param {object} options.router VueRouter实例，用于动态注册路由
   */
  install(Vue, options = {}) {
    // 1. 注入请求实例
    if (options.request) {
      setRequest(options.request);
    }

    // 2. 注册全局组件
    Vue.component('CodeLessEditor', CodeLessEditor);
    
    // 3. 挂载全局 CRUD 方法
    Vue.prototype.$codelessCrud = crud;

    // 4. 动态注册路由
    if (options.router) {
      const routes = [
        {
          path: '/codeless',
          name: 'CodeLess',
          component: CodeLessEditor,
          meta: { title: '低代码平台', icon: 'monitor' }
        }
      ];
      
      // Vue Router 3.x 使用 addRoutes
      options.router.addRoutes(routes);
      console.log('[CodeLess] 动态路由已注册: /codeless');
    }
  },
  
  // 导出组件和工具，支持按需引入
  CodeLessEditor,
  crud,
  setRequest
};
