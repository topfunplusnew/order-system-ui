import {defineStore} from 'pinia'
import {ref} from "vue";
import {MenuInfo} from "../interfaces/menu.ts";

// 你可以任意命名 `defineStore()` 的返回值，但最好使用 store 的名字，同时以 `use` 开头且以 `Store` 结尾。
// (比如 `useUserStore`，`useCartStore`，`useProductStore`)
// 第一个参数是你的应用中 Store 的唯一 ID。

//menu和tabs进行通讯
export const useManuTabsStore = defineStore('menu-tabs', () => {
    //定义状态
    const menuOpenList = ref<MenuInfo[]>([])
    //action
    const addToOpenList = (menuItems: MenuInfo) => {
        console.log('addToOpenList执行了')
        menuOpenList.value.push(menuItems)
        console.log(menuOpenList.value)
    }
    const deleteToOpenList = (id?: number, menuItems?: MenuInfo) => {
        menuOpenList.value = menuOpenList.value.filter(item => {
            if (menuItems == undefined) {
                return item.id != id
            } else {
                return item.id != id || item.id != menuItems.id
            }
        })
    }
    return {
        menuOpenList,
        addToOpenList,
        deleteToOpenList
    }
})

//菜单栏切换状态
export const useSwitchStore = defineStore('switch', () => {
    const isShow = ref(true)
    const changeIsShow = () => {
        isShow.value = !isShow.value
    }
    return {
        isShow,
        changeIsShow
    }
})
