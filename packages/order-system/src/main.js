// ========== Vue 核心 ==========
import Vue from 'vue';
import VueCompositionAPI from '@vue/composition-api';
import VueMeta from 'vue-meta';

// ========== Vue 路由和状态管理 ==========
import router from './router';
import store from './store';

// ========== 第三方库 ==========
import Cookies from 'js-cookie';
import print from 'print-js';

// ========== UI 框架 ==========
import Element, { MessageBox } from 'element-ui';
import Antd, { message } from 'ant-design-vue';
import { UTable, UTableColumn } from 'umy-ui';
import VForm from 'vform-builds';

// ========== 应用入口和布局 ==========
import App from './App.vue';

// ========== API ==========
import { getConfigKey } from '@/api/system/config';
import { getDicts } from '@/api/system/dict/data';
import { getUserConfig, saveUserConfig } from '@/api/user-config/index.js';

// ========== 工具函数 ==========
import service from './utils/request';
import { download, downloadByGetMethod, onceDownload } from '@/utils/request';
import { addDateRange, handleTree, parseTime, resetForm, selectDictLabel, selectDictLabels } from '@/utils/ruoyi';
import { Logger } from '@/utils/order/logger';
import { createTableAutoWidthMixin } from '@/utils/tableAutoWidth';
import { checkVersion } from './utils/versionChecker';

// ========== 共享 UI 组件 ==========
import { Pagination, RightToolbar, Editor, FileUpload, ImageUpload, ImagePreview, DictTag } from '@order-system/ui-components';

// ========== 业务组件 ==========
import DictData from '@/components/DictData';
import ModelPlugin from './components/ModelDialog';
import DatePickerDialog from './views/dashboard/components/common/DatePickerDialog.vue';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import CustomTableColumn from '@/components/CustomTableColumn/index.vue';

// ========== 混入 ==========
import keepAliveDialog from '@/views/dashboard/mixins/keepAliveDialog';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';

// ========== 指令 ==========
import directive from './directive';
import elDragDialog from '@/views/dashboard/directive/dialog/drugDialog';
import elRelenDialog from '@/views/dashboard/directive/dialog/relenDialog';

// ========== 插件 ==========
import plugins from './plugins';
import horizontalScroll from 'el-table-horizontal-scroll';
import VueVirtualScroller from 'vue-virtual-scroller';
import VueTour from 'vue-tour';
import FitColumnPlugin from 'v-fit-columns';

// ========== 样式 ==========
import './assets/styles/element-variables.scss';
import './element-variables.scss';
import '@/assets/styles/index.scss';
import '@/assets/styles/ruoyi.scss';
import './assets/icons';
import './permission';
import 'print-js/dist/print.css';
import 'vform-builds/dist/VFormDesigner.css';
import 'vue-virtual-scroller/dist/vue-virtual-scroller.css';
import 'ant-design-vue/dist/antd.css';
import 'vue-tour/dist/vue-tour.css';
import 'umy-ui/lib/theme-chalk/index.css';

message.config({
	top: '10px',
	getContainer: () => document.getElementById('messsage-box-div')
});
Vue.component(UTable.name, UTable);
Vue.component(UTableColumn.name, UTableColumn);
Vue.use(VueTour);
Vue.use(Antd);
Vue.use(VueVirtualScroller);
Vue.use(ModelPlugin);
Vue.use(FitColumnPlugin);
window.axios = service;
Vue.prototype.getDicts = getDicts;
Vue.prototype.getConfigKey = getConfigKey;
Vue.prototype.parseTime = parseTime;
Vue.prototype.resetForm = resetForm;
Vue.prototype.addDateRange = addDateRange;
Vue.prototype.selectDictLabel = selectDictLabel;
Vue.prototype.selectDictLabels = selectDictLabels;
Vue.prototype.download = download;
Vue.prototype.downloadByGetMethod = downloadByGetMethod;
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
Vue.prototype.$exclude = ['addtime', 'userId', 'UserName', 'delFlag', 'submitflag', 'cancelFlag', 'createBy', 'createTime', 'updateBy', 'updateTime', 'isedit', 'userName', 'create_time', 'update_time', 'username', 'cancelflag'];
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

Vue.use(VueCompositionAPI);
// 全局注册 keepAliveDialog 混入，使 system 目录下组件自动应用
Vue.mixin(keepAliveDialog);
// 全局注册通用弹窗混入
Vue.mixin(common_dialog);
// 全局注册 el-table 自动列宽混入
Vue.mixin(createTableAutoWidthMixin());
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
// RightToolbar 需要注入 API 函数，创建一个包装组件
Vue.component('RightToolbar', {
	extends: RightToolbar,
	props: {
		// 如果父组件没有传入，使用默认的 API 函数
		getUserConfig: {
			type: Function,
			default: getUserConfig
		},
		saveUserConfig: {
			type: Function,
			default: saveUserConfig
		}
	}
});
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

// 启动时立即检查一次版本号
checkVersion();
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
