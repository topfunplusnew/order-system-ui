import auth from '@/plugins/auth';
import router, { constantRoutes, dynamicRoutes } from '@/router';
import { getRouters } from '@/api/menu';
import Layout from '@/layout/index';
import ParentView from '@/components/ParentView';
import InnerLink from '@/layout/components/InnerLink';

/**
 * 后端菜单转前端路由的兜底规范化：
 * - path: 将重复的 / 压缩为单个 /
 * - name: 将 / 替换为 _，并在全局范围内保证唯一（重复则加前缀/后缀）
 *
 * 说明：这里不改变路由结构与 component/meta，只做必要的字符串规范化。
 */
function normalizeRoutePath(path) {
	if (typeof path !== 'string') return path;
	// 避免误伤外链（一般路由 path 不会出现 ://，但这里做兜底）
	if (path.includes('://')) return path;
	return path.replace(/\/{2,}/g, '/');
}

function sanitizeRouteName(name) {
	if (typeof name !== 'string') return name;
	// 去掉开头的 /，并把剩余的 / 替换为 _
	const sanitized = name.replace(/^\/+/, '').replace(/\//g, '_');
	return sanitized || name;
}

function ensureUniqueRouteName(baseName, usedNames, parentName) {
	if (!baseName) return baseName;
	if (!usedNames.has(baseName)) {
		usedNames.add(baseName);
		return baseName;
	}

	// 优先尝试加父级前缀（更可读）
	const prefixed = parentName ? `${parentName}_${baseName}` : '';
	if (prefixed && !usedNames.has(prefixed)) {
		usedNames.add(prefixed);
		return prefixed;
	}

	// 再使用数字后缀，直到唯一
	let idx = 2;
	let candidate = `${baseName}_${idx}`;
	while (usedNames.has(candidate)) {
		idx += 1;
		candidate = `${baseName}_${idx}`;
	}
	usedNames.add(candidate);
	return candidate;
}

function normalizeBackendRoutes(routes, usedNames, parentName = '') {
	if (!Array.isArray(routes)) return routes;

	routes.forEach(route => {
		if (!route || typeof route !== 'object') return;

		route.path = normalizeRoutePath(route.path);

		if (route.name) {
			const sanitizedName = sanitizeRouteName(route.name);
			route.name = ensureUniqueRouteName(sanitizedName, usedNames, parentName);
		}

		if (Array.isArray(route.children) && route.children.length) {
			normalizeBackendRoutes(route.children, usedNames, route.name || parentName);
		}
	});

	return routes;
}

function joinRoutePath(base, sub) {
	const baseStr = typeof base === 'string' ? base : '';
	const subStr = typeof sub === 'string' ? sub : '';
	return normalizeRoutePath(`${baseStr}/${subStr}`);
}

const permission = {
	state: {
		routes: [],
		addRoutes: [],
		defaultRoutes: [],
		topbarRouters: [],
		sidebarRouters: [],
		routesGenerated: false // 添加标识，防止重复生成路由
	},
	mutations: {
		SET_ROUTES: (state, routes) => {
			state.addRoutes = routes;
			state.routes = constantRoutes.concat(routes);
		},
		SET_DEFAULT_ROUTES: (state, routes) => {
			state.defaultRoutes = constantRoutes.concat(routes);
		},
		SET_TOPBAR_ROUTES: (state, routes) => {
			state.topbarRouters = routes;
		},
		SET_SIDEBAR_ROUTERS: (state, routes) => {
			state.sidebarRouters = routes;
		},
		SET_ROUTES_GENERATED: (state, status) => {
			state.routesGenerated = status;
		},
		RESET_ROUTES: state => {
			state.routes = [];
			state.addRoutes = [];
			state.defaultRoutes = [];
			state.topbarRouters = [];
			state.sidebarRouters = [];
			state.routesGenerated = false;
		}
	},
	actions: {
		// 生成路由
		GenerateRoutes({ commit, state }) {
			return new Promise(resolve => {
				// 如果路由已经生成过，直接返回
				if (state.routesGenerated) {
					console.log('[路由管理] 路由已存在，跳过重复生成');
					resolve(state.addRoutes);
					return;
				}

				// 向后端请求路由数据
				getRouters()
					.then(res => {
						try {
							// 基于已有路由名做兜底去重，避免 addRoutes 直接跳过菜单路由
							const existingRouteNames = new Set();
							router.options.routes.forEach(route => {
								if (route.name) existingRouteNames.add(route.name);
							});

							// 先对后端原始数据做一次规范化，确保 sdata/rdata 产物保持一致
							const baseData = JSON.parse(JSON.stringify(res.data));
							normalizeBackendRoutes(baseData, existingRouteNames);

							const sdata = JSON.parse(JSON.stringify(baseData));
							const rdata = JSON.parse(JSON.stringify(baseData));

							// 过滤并转换路由
							const sidebarRoutes = filterAsyncRouter(sdata);
							const rewriteRoutes = filterAsyncRouter(rdata, false, true);
							const asyncRoutes = filterDynamicRoutes(dynamicRoutes);

							// 添加404路由
							rewriteRoutes.push({
								path: '*',
								redirect: '/404',
								hidden: true
							});

							// 统一在这里添加所有路由，避免重复
							const allRoutesToAdd = [...asyncRoutes, ...rewriteRoutes];

							// 过滤重复的路由
							const filteredRoutes = allRoutesToAdd.filter(route => {
								if (route.name && existingRouteNames.has(route.name)) {
									console.warn(`[路由管理] 跳过重复路由: ${route.name}`);
									return false;
								}
								if (route.name) existingRouteNames.add(route.name);
								return true;
							});

							// 添加路由到router实例
							router.addRoutes(filteredRoutes);

							// 提交到store
							commit('SET_ROUTES', rewriteRoutes);
							commit('SET_SIDEBAR_ROUTERS', constantRoutes.concat(sidebarRoutes));
							commit('SET_DEFAULT_ROUTES', sidebarRoutes);
							commit('SET_TOPBAR_ROUTES', sidebarRoutes);
							commit('SET_ROUTES_GENERATED', true);

							console.log(`[路由管理] 成功添加 ${filteredRoutes.length} 个路由`);
							resolve(rewriteRoutes);
						} catch (error) {
							console.error('[路由管理] 路由生成失败:', error);
							resolve([]);
						}
					})
					.catch(error => {
						console.error('[路由管理] 获取路由数据失败:', error);
						resolve([]);
					});
			});
		},
		// 重置路由状态
		ResetRoutes({ commit }) {
			commit('RESET_ROUTES');
		}
	}
};

// 遍历后台传来的路由字符串，转换为组件对象
function filterAsyncRouter(asyncRouterMap, lastRouter = false, type = false) {
	return asyncRouterMap.filter(route => {
		if (type && route.children) {
			route.children = filterChildren(route.children);
		}
		if (route.component) {
			// Layout ParentView 组件特殊处理
			if (route.component === 'Layout') {
				route.component = Layout;
			} else if (route.component === 'ParentView') {
				route.component = ParentView;
			} else if (route.component === 'InnerLink') {
				route.component = InnerLink;
			} else {
				route.component = loadView(route.component);
			}
		}
		if (route.children != null && route.children && route.children.length) {
			route.children = filterAsyncRouter(route.children, route, type);
		} else {
			delete route['children'];
			delete route['redirect'];
		}
		return true;
	});
}

function filterChildren(childrenMap, lastRouter = false) {
	var children = [];
	childrenMap.forEach((el, index) => {
		if (el.children && el.children.length) {
			if (el.component === 'ParentView' && !lastRouter) {
				el.children.forEach(c => {
					c.path = joinRoutePath(el.path, c.path);
					if (c.children && c.children.length) {
						children = children.concat(filterChildren(c.children, c));
						return;
					}
					children.push(c);
				});
				return;
			}
		}
		if (lastRouter) {
			el.path = joinRoutePath(lastRouter.path, el.path);
			if (el.children && el.children.length) {
				children = children.concat(filterChildren(el.children, el));
				return;
			}
		}
		children = children.concat(el);
	});
	return children;
}

// 动态路由遍历，验证是否具备权限
export function filterDynamicRoutes(routes) {
	const res = [];
	routes.forEach(route => {
		if (route.permissions) {
			if (auth.hasPermiOr(route.permissions)) {
				res.push(route);
			}
		} else if (route.roles) {
			if (auth.hasRoleOr(route.roles)) {
				res.push(route);
			}
		}
	});
	return res;
}

export const loadView = view => {
	// if (process.env.NODE_ENV === 'development') {
	//   return (resolve) => require([`@/views/${view}`], resolve)
	// } else {
	//   // 使用 import 实现生产环境的路由懒加载
	//   return () => import(`@/views/${view}`)
	// }
	return resolve => require([`@/views/${view}`], resolve);
};

export default permission;
