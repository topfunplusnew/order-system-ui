import {defineStore} from 'pinia'
import {ref} from "vue";
// @ts-ignore
import LayOut from '../layout/Index.vue'
import {treeselect} from "../api/api/system/menu.ts";
import {MenuInfo} from "../interfaces/menu.ts";
// 你可以任意命名 `defineStore()` 的返回值，但最好使用 store 的名字，同时以 `use` 开头且以 `Store` 结尾。
// (比如 `useUserStore`，`useCartStore`，`useProductStore`)
// 第一个参数是你的应用中 Store 的唯一 ID。

//menu和tabs进行通讯
export const useManuTabsStore = defineStore('menu-tabs', () => {
    //定义状态
    const menuOpenList = ref<MenuInfo[]>([{
        children: [],
        component: '',
        createBy: '',
        createTime: '',
        icon: '',
        isCache: '',
        isFrame: '',
        menuId: 1,
        menuName: '首页',
        menuType: "F",
        orderNum: 1,
        parentId: 0,
        parentName: '',
        path: '/',
        perms: '',
        status: '1',
        visible: '1',
    }])
    //action
    const addToOpenList = (menuItems: MenuInfo) => {
        menuOpenList.value.push(menuItems)
        console.log(menuOpenList.value)
    }
    const deleteToOpenList = (id?: number, menuItems?: any) => {
        // @ts-ignore
        menuOpenList.value = menuOpenList.value.filter(item => {
            if (menuItems == undefined) {
                return item.menuId != id
            } else {
                return item.menuId != id || item.menuId != menuItems.id
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
    //点击某个菜单自动聚焦
    const focus = ref(1)
    const changeIsShow = () => {
        isShow.value = !isShow.value
    }
    const changeFocus = (id: number) => {
        focus.value = id;
    }
    return {
        isShow,
        focus,
        changeIsShow,
        changeFocus
    }
})


//获取菜单信息
export const useSysMenuInfoStore = defineStore('menu-info', () => {
    //定义状态
    const menu_list = ref([])
    const getMenuList = () => {
        treeselect().then(r => {
            menu_list.value = r.data.data;
        })
        return menu_list
    }
    return {
        menu_list,
        getMenuList
    }
})
