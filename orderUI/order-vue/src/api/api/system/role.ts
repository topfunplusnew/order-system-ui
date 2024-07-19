import {instance} from "../../http/http.ts";

// 查询角色列表
export function listRole(query: any) {
    return instance({
        url: '/system/role/list',
        method: 'get',
        params: query
    })
}

// 查询角色详细
export function getRole(roleId: number) {
    return instance({
        url: '/system/role/' + roleId,
        method: 'get'
    })
}

// 新增角色
export function addRole(data: any) {
    return instance({
        url: '/system/role',
        method: 'post',
        data: data
    })
}

// 修改角色
export function updateRole(data: any) {
    return instance({
        url: '/system/role',
        method: 'put',
        data: data
    })
}

// 角色数据权限
export function dataScope(data: any) {
    return instance({
        url: '/system/role/dataScope',
        method: 'put',
        data: data
    })
}

// 角色状态修改
export function changeRoleStatus(roleId: number, status: any) {
    const data = {
        roleId,
        status
    }
    return instance({
        url: '/system/role/changeStatus',
        method: 'put',
        data: data
    })
}

// 删除角色
export function delRole(roleId: number) {
    return instance({
        url: '/system/role/' + roleId,
        method: 'delete'
    })
}

// 查询角色已授权用户列表
export function allocatedUserList(query: any) {
    return instance({
        url: '/system/role/authUser/allocatedList',
        method: 'get',
        params: query
    })
}

// 查询角色未授权用户列表
export function unallocatedUserList(query: any) {
    return instance({
        url: '/system/role/authUser/unallocatedList',
        method: 'get',
        params: query
    })
}

// 取消用户授权角色
export function authUserCancel(data: any) {
    return instance({
        url: '/system/role/authUser/cancel',
        method: 'put',
        data: data
    })
}

// 批量取消用户授权角色
export function authUserCancelAll(data: any) {
    return instance({
        url: '/system/role/authUser/cancelAll',
        method: 'put',
        params: data
    })
}

// 授权用户选择
export function authUserSelectAll(data: any) {
    return instance({
        url: '/system/role/authUser/selectAll',
        method: 'put',
        params: data
    })
}

// 根据角色ID查询部门树结构
export function deptTreeSelect(roleId: number) {
    return instance({
        url: '/system/role/deptTree/' + roleId,
        method: 'get'
    })
}
