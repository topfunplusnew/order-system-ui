import relen from './relen';
import Vue from 'vue';

const install = function (Vue) {
	Vue.directive('el-drag-dialog', relen);
};

if (window.Vue) {
	window['el-relen-dialog'] = relen;
	Vue.use(install);
}

relen.install = install;
export default relen;
