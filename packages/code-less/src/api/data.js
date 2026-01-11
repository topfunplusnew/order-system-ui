import { getRequest } from './request';

/**
 * 查询数据接口 (分页/筛选)
 * @param {string} schemaKey 模型标识
 * @param {object} params 查询参数 { page, pageSize, query }
 */
export function apiSearchData(schemaKey, params) {
  return getRequest()({
    url: `/codeless/data/${schemaKey}/search`,
    method: 'post',
    data: params
  });
}

/**
 * 新增数据接口
 * @param {string} schemaKey 模型标识
 * @param {object} data 数据对象
 */
export function apiCreateData(schemaKey, data) {
  return getRequest()({
    url: `/codeless/data/${schemaKey}`,
    method: 'post',
    data: data
  });
}

/**
 * 更新数据接口
 * @param {string} schemaKey 模型标识
 * @param {string|number} id 数据ID
 * @param {object} data 更新的数据对象
 */
export function apiUpdateData(schemaKey, id, data) {
  return getRequest()({
    url: `/codeless/data/${schemaKey}/${id}`,
    method: 'put',
    data: data
  });
}

/**
 * 删除数据接口
 * @param {string} schemaKey 模型标识
 * @param {string|number} id 数据ID
 */
export function apiDeleteData(schemaKey, id) {
  return getRequest()({
    url: `/codeless/data/${schemaKey}/${id}`,
    method: 'delete'
  });
}
