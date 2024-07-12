//@ts-ignore
import {createApp} from 'vue'
// @ts-ignore
import App from './App.vue'
import Layui from '@layui/layui-vue'
import '@layui/layui-vue/lib/index.css'

createApp(App).use(Layui).mount('#app')
