import {instance} from "../../http/http.ts";

// 查询菜单列表
export function listMenu(query: any) {
    return instance({
        url: '/system/menu/list',
        method: 'get',
        params: query
    })
}

// 查询菜单详细
export function getMenu(menuId: number) {
    return instance({
        url: '/system/menu/' + menuId,
        method: 'get'
    })
}

// 查询菜单下拉树结构
export function treeselect() {
    return instance({
        url: '/system/menu/treeselect',
        method: 'get'
    })
}

// 根据角色ID查询菜单下拉树结构
export function roleMenuTreeselect(roleId: number) {
    return instance({
        url: '/system/menu/roleMenuTreeselect/' + roleId,
        method: 'get'
    })
}

// 新增菜单
export function addMenu(data: any) {
    return instance({
        url: '/system/menu',
        method: 'post',
        data: data
    })
}

// 修改菜单
export function updateMenu(data: any) {
    return instance({
        url: '/system/menu',
        method: 'put',
        data: data
    })
}

// 删除菜单
export function delMenu(menuId: number) {
    return instance({
        url: '/system/menu/' + menuId,
        method: 'delete'
    })
}
