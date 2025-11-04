import Vue from 'vue';

import Cookies from 'js-cookie';

import Element, { Loading } from 'element-ui';
import './assets/styles/element-variables.scss';
import './element-variables.scss';

import { getConfigKey } from '@/api/system/config';
import { getDicts } from '@/api/system/dict/data';
import '@/assets/styles/index.scss'; // global css
import '@/assets/styles/ruoyi.scss'; // ruoyi css
import { download, onceDownload } from '@/utils/request';
import { addDateRange, handleTree, parseTime, resetForm, selectDictLabel, selectDictLabels } from '@/utils/ruoyi';
import App from './App.vue';
import './assets/icons'; // icon
import directive from './directive'; // directive
import './permission'; // permission control
import plugins from './plugins'; // plugins
import router from './router';
import store from './store';
// 分页组件
import Pagination from '@/components/Pagination';
// 自定义表格工具组件
import RightToolbar from '@/components/RightToolbar';
// 富文本组件
import Editor from '@/components/Editor';
// 文件上传组件
import FileUpload from '@/components/FileUpload';
// 图片上传组件
import ImageUpload from '@/components/ImageUpload';
// 图片预览组件
import ImagePreview from '@/components/ImagePreview';
// 字典标签组件
import DictTag from '@/components/DictTag';
// 头部标签组件
import VueMeta from 'vue-meta';
// 字典数据组件
import DictData from '@/components/DictData';
import ModelPlugin from './components/ModelDialog';
// 引入表格横向滚动插件
import horizontalScroll from 'el-table-horizontal-scroll';
// 打印
import print from 'print-js';
import 'print-js/dist/print.css';
// 表单生成器
import VForm from 'vform-builds'; // 引入VForm库
import 'vform-builds/dist/VFormDesigner.css'; // 引入VForm样式
import service from './utils/request';
import { Logger } from '@/utils/order/logger';
// 虚拟滚动
import VueVirtualScroller from 'vue-virtual-scroller';
import 'vue-virtual-scroller/dist/vue-virtual-scroller.css';
import DatePickerDialog from './views/dashboard/components/common/DatePickerDialog.vue';
import Antd, { message } from 'ant-design-vue';
import 'ant-design-vue/dist/antd.css';
// 漫游组件
import 'vue-tour/dist/vue-tour.css';
import VueTour from 'vue-tour';
import keepAliveDialog from '@/views/dashboard/mixins/keepAliveDialog';
// 引入通用弹窗混入和组件
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import CustomTableColumn from '@/components/CustomTableColumn/index.vue';
// 引入列显隐控制混入
import { columnVisibilityMixin } from '@/mixins/columnVisibilityMixin';
// 全局注册弹窗拖拽与位置重算指令
import elDragDialog from '@/views/dashboard/directive/dialog/drugDialog';
import elRelenDialog from '@/views/dashboard/directive/dialog/relenDialog';
import { checkVersion } from './utils/versionChecker';
message.config({
	top: '10px',
	getContainer: () => document.getElementById('messsage-box-div')
});
Vue.use(VueTour);
Vue.use(Antd);
Vue.use(VueVirtualScroller);
Vue.use(ModelPlugin);
window.axios = service;
Vue.prototype.getDicts = getDicts;
Vue.prototype.getConfigKey = getConfigKey;
Vue.prototype.parseTime = parseTime;
Vue.prototype.resetForm = resetForm;
Vue.prototype.addDateRange = addDateRange;
Vue.prototype.selectDictLabel = selectDictLabel;
Vue.prototype.selectDictLabels = selectDictLabels;
Vue.prototype.download = download;
Vue.prototype.handleTree = handleTree;
Vue.prototype.$print = print;
Vue.prototype.$log = new Logger({
	prefix: 'MyApp',
	enableDebug: true
});

// 一键下载
Vue.prototype.downLoadOnce = onceDownload;

Vue.prototype.$antdconfirm = Vue.prototype.$confirm;
// 使用: this.form = excludeParams(this.form, this.$exclude)  api/tool/exclude.js
Vue.prototype.$exclude = [
	'addtime',
	'userId',
	'UserName',
	'delFlag',
	'submitflag',
	'cancelFlag',
	'createBy',
	'createTime',
	'updateBy',
	'updateTime',
	'isedit',
	'userName',
	'create_time',
	'update_time',
	'username',
	'cancelflag'
];
Vue.prototype.$excludeWithUpdate = [
	'addtime',
	'userId',
	'delFlag',
	'id',
	'orderDetailList',
	'goodsOrderID',
	'ordersNo',
	'customerID',
	'checkUserId',
	'checkState',
	'isAdjust',
	'adjustDate',
	'isAdjusted',
	'adjustOrderid',
	'receiveProof',
	'paymentState',
	'invoiceState',
	'customerIsInvoice',
	'isSupplierInvoice',
	'orderDateEnd',
	'orderDateStart',
	'landCarID',
	'seaCarID',
	'path',
	'submitflag',
	'cancelFlag',
	'createBy',
	'createTime',
	'updateBy',
	'isedit'
];
Vue.prototype.$imgs = ['png', 'jpg', 'jpeg', 'bmp', 'gif', 'webp'];
Vue.prototype.$datePicker = function () {
	return new Promise(resolve => {
		// 获取一个构造函数
		const DatePickerConstructor = Vue.extend(DatePickerDialog);
		// 实例化
		const datePickerInstance = new DatePickerConstructor({
			propsData: { resolve }
		});
		// 手动挂载到 DOM 上
		datePickerInstance.$mount();
		document.body.appendChild(datePickerInstance.$el);
		// 显示弹框
		datePickerInstance.show();
		// 捕获关闭事件
		datePickerInstance.$on('resolve', data => {
			resolve(data); // 处理日期选择
		});
	});
};

// 引入composition-api写法
import VueCompositionAPI from '@vue/composition-api';
Vue.use(VueCompositionAPI);
// 全局注册 keepAliveDialog 混入，使 system 目录下组件自动应用
Vue.mixin(keepAliveDialog);
// 全局注册通用弹窗混入
Vue.mixin(common_dialog);
// 全局注册列显隐控制混入
Vue.mixin(columnVisibilityMixin);
// 全局指令（若指令文件包含 install 则可直接 use；此处双保险显式注册）
Vue.use(elDragDialog.install ? elDragDialog : { install: v => v.directive('el-drag-dialog', elDragDialog) });
Vue.use(elRelenDialog.install ? elRelenDialog : { install: v => v.directive('el-relen-dialog', elRelenDialog) });

// 引入表格固定列修复工具 - 自动修复所有el-table的固定列错行问题
// import '@/utils/tableFixedColumnAdjustment';

export const isNull = val => {
	return !val ? '暂无' : val;
};

// 全局组件挂载
Vue.component('DictTag', DictTag);
Vue.component('Pagination', Pagination);
Vue.component('RightToolbar', RightToolbar);
Vue.component('Editor', Editor);
Vue.component('FileUpload', FileUpload);
Vue.component('ImageUpload', ImageUpload);
Vue.component('ImagePreview', ImagePreview);
// 全局注册通用弹窗组件
Vue.component('DialogWrapper', DialogWrapper);
// 注册自定义elementui组件
Vue.component('CustomTableColumn', CustomTableColumn);
Vue.use(directive);
Vue.use(plugins);
Vue.use(VueMeta);
// 引入表格横向滚动插件
Vue.use(horizontalScroll);
DictData.install();
Vue.use(Element, {
	size: Cookies.get('size') || 'medium' // set element-ui default size
});
// 表单生成器
Vue.use(VForm);
Vue.config.productionTip = false;

// 每隔 1 分钟检测一次版本号
setInterval(checkVersion, 60 * 1000);
window.addEventListener('app-version-changed', () => {
	MessageBox.confirm('检测到系统已更新，是否立即刷新页面？', '版本更新提示', {
		confirmButtonText: '刷新',
		cancelButtonText: '稍后',
		type: 'warning'
	}).then(() => {
		window.location.reload(true);
	});
});
// 创建vm 挂载全局事件总线
new Vue({
	el: '#app',
	router,
	store,
	beforeCreate() {
		Vue.prototype.$bus = this;
	},
	render: h => h(App)
});
