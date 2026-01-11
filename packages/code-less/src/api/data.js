import { getRequest } from './request';

/**
 * 基于 CodeLess Server (MongoDB) 的数据存储 API
 * 接口路径: /codeless/data/:schemaKey
 */

/**
 * 1. 查询数据接口 (Read / Search)
 * POST /codeless/data/{schemaKey}/search
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
 * 2. 新增数据接口 (Create)
 * POST /codeless/data/{schemaKey}
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
 * 3. 更新数据接口 (Update)
 * PUT /codeless/data/{schemaKey}/{id}
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
 * 4. 删除数据接口 (Delete)
 * DELETE /codeless/data/{schemaKey}/{id}
 * @param {string} schemaKey 模型标识
 * @param {string|number} id 数据ID
 */
export function apiDeleteData(schemaKey, id) {
  return getRequest()({
    url: `/codeless/data/${schemaKey}/${id}`,
    method: 'delete'
  });
}
