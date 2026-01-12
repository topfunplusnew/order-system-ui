// 菜单路由 mock（用于前端联调/排查菜单问题时绕开后端）
// 注意：permission 模块里使用的是 getRouters() 的返回结构（res.data 为路由数组）
export default {
	code: 200,
	msg: '操作成功',
	data: [
		{
			name: 'System',
			path: '/system',
			hidden: false,
			redirect: 'noRedirect',
			component: 'Layout',
			alwaysShow: true,
			meta: { title: '系统管理', icon: 'system', noCache: false, link: null },
			children: [
				{
					name: 'Menu',
					path: 'menu',
					hidden: false,
					component: 'system/menu/index',
					meta: { title: '模块管理', icon: 'tree-table', noCache: false, link: null }
				},
				{
					name: 'Dict',
					path: 'dict',
					hidden: false,
					component: 'system/dict/index',
					meta: { title: '字典管理', icon: 'dict', noCache: false, link: null }
				}
			]
		},
		{
			name: 'Users',
			path: '/users',
			hidden: false,
			redirect: 'noRedirect',
			component: 'Layout',
			alwaysShow: true,
			meta: { title: '用户信息管理', icon: 'peoples', noCache: false, link: null },
			children: [
				{
					name: 'User',
					path: 'user',
					hidden: false,
					component: 'system/user/index',
					meta: { title: '用户管理', icon: 'user', noCache: false, link: null }
				},
				{
					name: 'Role',
					path: 'role',
					hidden: false,
					component: 'system/role/index',
					meta: { title: '角色管理', icon: 'peoples', noCache: false, link: null }
				}
			]
		},
		{
			// 故意保留“问题样例”：name 含 /，path 含双斜杠，用于验证兜底是否生效
			name: '/baseInfo',
			path: '//baseInfo',
			hidden: false,
			redirect: 'noRedirect',
			component: 'Layout',
			alwaysShow: true,
			meta: { title: '基础信息维护', icon: 'documentation', noCache: false, link: null },
			children: [
				{
					name: 'Company',
					path: 'company',
					hidden: false,
					component: 'system/company/index',
					meta: { title: '客户信息', icon: 'documentation', noCache: false, link: null }
				}
			]
		},
		{
			// 故意保留“问题样例”：重复 name（Order）用于验证去重兜底
			name: 'Order',
			path: '/order',
			hidden: false,
			redirect: 'noRedirect',
			component: 'Layout',
			alwaysShow: true,
			meta: { title: '订单管理', icon: 'documentation', noCache: false, link: null },
			children: [
				{
					name: 'Order',
					path: 'order',
					hidden: false,
					redirect: 'noRedirect',
					component: 'ParentView',
					alwaysShow: true,
					meta: { title: '订单信息', icon: 'documentation', noCache: false, link: null },
					children: [
						{
							name: 'GoodsOrder',
							path: 'GoodsOrder',
							hidden: false,
							component: 'system/goodsorder/index',
							meta: { title: '订单列表', icon: 'documentation', noCache: false, link: null }
						}
					]
				}
			]
		},
		{
			// 故意保留“问题样例”：name 含 /
			name: 'System/giftInventory',
			path: '/gift',
			hidden: false,
			redirect: 'noRedirect',
			component: 'Layout',
			alwaysShow: true,
			meta: { title: '礼品信息', icon: 'documentation', noCache: false, link: null },
			children: [
				{
					name: 'GiftIn',
					path: 'giftIn',
					hidden: false,
					component: 'system/giftIn/index.vue',
					meta: { title: '购入礼品信息', icon: 'documentation', noCache: false, link: null }
				},
				{
					name: 'GiftOut',
					path: 'giftOut',
					hidden: false,
					component: 'system/giftOut/index.vue',
					meta: { title: '礼品出库信息', icon: 'documentation', noCache: false, link: null }
				},
				{
					name: 'System/giftInventory',
					path: 'system/giftInventory',
					hidden: false,
					component: 'system/giftInventory/index',
					meta: { title: '礼品库存信息', icon: 'documentation', noCache: false, link: null }
				}
			]
		}
	]
};

