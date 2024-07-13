// @ts-ignore
import LayOut from "../layout/Index.vue";
// @ts-ignore
import Login from "../view/Login.vue";
import {RouteRecordRaw} from "vue-router";

//在这里请求后端的路由信息
//路由信息的格式如下：

export const routes: RouteRecordRaw[] = [
    {
        path: '/',
        redirect: '/admin'
    },
    {
        path: '/admin',
        name: '首页',
        component: LayOut
    },
    {
        path: '/login',
        name: '登录',
        component: Login,
    },
]
