//@ts-ignore
import {createApp} from 'vue'
// @ts-ignore
import App from './App.vue'
import Layui from '@layui/layui-vue'
import '@layui/layui-vue/lib/index.css'
import {createPinia, Pinia} from "pinia";
// import {createRouter, createWebHashHistory} from "vue-router";
import LayJsonSchemaForm from "@layui/json-schema-form";
import "@layui/json-schema-form/lib/index.css";
//路由配置
// @ts-ignore
import LayOut from "./layout/Index.vue";
// @ts-ignore
import Login from "./view/Login.vue";
import {router} from "./router";
//pinia
const pinia: Pinia = createPinia()

//router

createApp(App).use(Layui).use(pinia).use(router).use(LayJsonSchemaForm).mount('#app')
