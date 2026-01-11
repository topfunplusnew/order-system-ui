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
   */
  install(Vue, options = {}) {
    // 注入请求实例
    if (options.request) {
      setRequest(options.request);
    }

    Vue.component('CodeLessEditor', CodeLessEditor);
    
    // 挂载全局 CRUD 方法
    Vue.prototype.$codelessCrud = crud;
  },
  
  // 导出组件和工具，支持按需引入
  CodeLessEditor,
  crud,
  setRequest
};
