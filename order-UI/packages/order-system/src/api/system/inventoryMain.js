import request from '@/utils/request';

// 查询库存库存主表列表
export function listInventoryMain(query) {
    return request({
        url: '/system/inventoryMain/list',
        method: 'get',
        params: query
    });
}

// 查询库存库存主表详细
export function getInventoryMain(id) {
    return request({
        url: '/system/inventoryMain/' + id,
        method: 'get'
    });
}

// 新增库存库存主表
export function addInventoryMain(data) {
    return request({
        url: '/system/inventoryMain',
        method: 'post',
        data: data
    });
}

// 修改库存库存主表
export function updateInventoryMain(data) {
    return request({
        url: '/system/inventoryMain',
        method: 'put',
        data: data
    });
}

// 删除库存库存主表
export function delInventoryMain(id) {
    return request({
        url: '/system/inventoryMain/' + id,
        method: 'delete'
    });
}

export function listExitInventory(query) {
    return request({
        url: '/system/inventoryDetail/canExList',
        method: 'get',
        params: query
    });
}

// 查看一个产品级别库存累计变动
export function listInventoryDetails(query) {
    return request({
        url: '/system/inventoryMain/inventoryChanges',
        method: 'get',
        params: query
    });
}

// 库存审核
export function auditInventory(data) {
    return request({
        url: '/system/inventoryMain/audit',
        method: 'put',
        params: {
            id: data.id,
            isaudit: data.isaudit
        }
    });
}

// 更新库存附件 二次上传 审核后可以上传
export function updateInventoryAttachments(data) {
    return request({
        url: '/system/inventoryMain/attachments',
        method: 'put',
        data: data
    });
}