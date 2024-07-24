import { createApp, ref, watch } from 'vue'
import App from './App.vue'
import Layui from '@layui/layui-vue'
import '@layui/layui-vue/lib/index.css'
import { createPinia, Pinia } from 'pinia'
// import {createRouter, createWebHashHistory} from "vue-router";
import LayJsonSchemaForm from '@layui/json-schema-form'
import '@layui/json-schema-form/lib/index.css'
//路由配置
import { router } from './router'
//pinia
const pinia: Pinia = createPinia()
createApp(App)
  .use(Layui)
  .use(pinia)
  .use(router)
  .use(LayJsonSchemaForm)
  .mount('#app')
