// @ts-ignore
import LayOut from "../layout/Index.vue";
// @ts-ignore
import Login from "../view/Login.vue";
import {createRouter, createWebHashHistory, Router} from "vue-router";
import {routes} from "./routes.ts";

export const router: Router = createRouter({
    history: createWebHashHistory(),
    routes
})

router.beforeEach((to) => {
    if (to.name == '首页') {
        console.log("路由守卫")
        if (localStorage.getItem("user") == undefined) {
            return {
                name: '登录'
            }
        }
    }
    return true
})
