//@ts-ignore
import {createApp} from 'vue'
// @ts-ignore
import App from './App.vue'
import Layui from '@layui/layui-vue'
import '@layui/layui-vue/lib/index.css'
import {createPinia, Pinia} from "pinia";

//pinia
const pinia: Pinia = createPinia()
createApp(App).use(Layui).use(pinia).mount('#app')
