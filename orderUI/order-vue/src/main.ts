//@ts-ignore
import {createApp} from 'vue'
// @ts-ignore
import App from './App.vue'
import Layui from '@layui/layui-vue'
import '@layui/layui-vue/lib/index.css'
import {createPinia, Pinia} from "pinia";
// import {createRouter, createWebHashHistory} from "vue-router";

//路由配置
// @ts-ignore
import LayOut from "./layout/Index.vue";
// @ts-ignore
import Login from "./view/Login.vue";
import {router} from "./router";
//pinia
const pinia: Pinia = createPinia()

//router

createApp(App).use(Layui).use(pinia).use(router).mount('#app')
