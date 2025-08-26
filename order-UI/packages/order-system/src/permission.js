import router from './router';
import store from './store';
import { Message } from 'element-ui';
import NProgress from 'nprogress';
import 'nprogress/nprogress.css';
import { getToken } from '@/utils/auth';
import { isRelogin } from '@/utils/request';

NProgress.configure({ showSpinner: false });

const whiteList = ['/login', '/register'];

router.beforeEach((to, from, next) => {
	NProgress.start();
	if (getToken()) {
		to.meta.title && store.dispatch('settings/setTitle', to.meta.title);
		/* has token*/
		if (to.path === '/login') {
			next({ path: '/' });
			NProgress.done();
		} else if (whiteList.indexOf(to.path) !== -1) {
			next();
		} else {
			if (store.getters.roles.length === 0) {
				isRelogin.show = true;
				// 判断当前用户是否已拉取完user_info信息
				store
					.dispatch('GetInfo')
					.then(() => {
						isRelogin.show = false;
						store.dispatch('GenerateRoutes').then(accessRoutes => {
							// 路由添加逻辑移到store中统一处理，这里不再重复添加
							// 注意：路由已经在 GenerateRoutes action 中添加完成
							next({ ...to, replace: true }); // hack方法 确保addRoutes已完成
						});
					})
					.catch(err => {
						store.dispatch('LogOut').then(() => {
							Message.error(err);
							next({ path: '/' });
						});
					});
			} else {
				next();
			}
		}
	} else {
		// 没有token
		if (whiteList.indexOf(to.path) !== -1) {
			// 在免登录白名单，直接进入
			next();
		} else {
			next(`/login?redirect=${encodeURIComponent(to.fullPath)}`); // 否则全部重定向到登录页
			NProgress.done();
		}
	}
});

router.afterEach(() => {
	NProgress.done();
});
