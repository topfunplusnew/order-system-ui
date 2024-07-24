// @ts-ignore
import LayOut from "../layout/Index.vue";
// @ts-ignore
import Login from "../view/Login.vue";
// @ts-ignore
import {createRouter, createWebHashHistory, Router} from "vue-router";
// @ts-ignore
import {routes} from "./routes.ts";
// @ts-ignore
import {layer} from "@layui/layui-vue"

export const router: Router = createRouter({
    history: createWebHashHistory(),
    routes
})

router.beforeEach((to: any) => {
    const token: string | null | undefined = sessionStorage.getItem("token")
    if (to.name == '首页') {
        if (token == undefined) {
            layer.msg("您好,请先登录~", {time: 2000, icon: 2})
            return {
                name: '登录'
            }
        }
    }

    if (to.name == '登录') {
        if (token != undefined) {
            layer.msg("您已经登录过了~", {time: 2000, icon: 1})
            return {
                name: '首页'
            }
        }
    }
    return true
})
