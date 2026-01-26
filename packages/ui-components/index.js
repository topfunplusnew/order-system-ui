// 共享UI组件库入口文件
// 导出通用组件，这些组件可以在多个应用中使用

import Pagination from './components/Pagination';
import RightToolbar from './components/RightToolbar';
import DictTag from './components/DictTag';
import SvgIcon from './components/SvgIcon';
import ImageUpload from './components/ImageUpload';
import FileUpload from './components/FileUpload';
import ImagePreview from './components/ImagePreview';
import Editor from './components/Editor';
import Breadcrumb from './components/Breadcrumb';
import Hamburger from './components/Hamburger';
import Screenfull from './components/Screenfull';
import ShowLabel from './components/ShowLabel';

// 全局注册组件
const components = [Pagination, RightToolbar, DictTag, SvgIcon, ImageUpload, FileUpload, ImagePreview, Editor, Breadcrumb, Hamburger, Screenfull, ShowLabel];

const install = function (Vue) {
	components.forEach(component => {
		Vue.component(component.name, component);
	});
};

// 支持使用 Vue.use() 安装
if (typeof window !== 'undefined' && window.Vue) {
	install(window.Vue);
}

export default {
	install,
	Pagination,
	RightToolbar,
	DictTag,
	SvgIcon,
	ImageUpload,
	FileUpload,
	ImagePreview,
	Editor,
	Breadcrumb,
	Hamburger,
	Screenfull,
	ShowLabel
};

// 单独导出组件
export { Pagination, RightToolbar, DictTag, SvgIcon, ImageUpload, FileUpload, ImagePreview, Editor, Breadcrumb, Hamburger, Screenfull, ShowLabel };
