// 简单的入口导出
import CodeLessEditor from './components/CodeLessEditor.vue';

export default {
  install(Vue) {
    Vue.component('CodeLessEditor', CodeLessEditor);
  },
  CodeLessEditor
};
