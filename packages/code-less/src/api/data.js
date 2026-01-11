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
  const storageKey = getStorageKey(schemaKey);
  return getRequest()({
    url: `/system/user-config/${storageKey}`,
    method: 'get'
  }).then(res => {
    // 解析存储的 JSON 数据
    let allData = [];
    try {
      const rawValue = res.data || res.msg || '';
      if (rawValue && typeof rawValue === 'string') {
        allData = JSON.parse(rawValue);
      } else if (Array.isArray(rawValue)) {
        allData = rawValue;
      }
    } catch (e) {
      allData = [];
    }

    // 确保是数组
    if (!Array.isArray(allData)) {
      allData = [];
    }

    // 关键词过滤
    if (params.query?.keyword) {
      const keyword = params.query.keyword.toLowerCase();
      allData = allData.filter(item =>
        (item.name && item.name.toLowerCase().includes(keyword)) ||
        (item.path && item.path.toLowerCase().includes(keyword)) ||
        (item.description && item.description.toLowerCase().includes(keyword))
      );
    }

    // 按更新时间倒序排序
    allData.sort((a, b) => new Date(b.updatedAt || 0) - new Date(a.updatedAt || 0));

    // 分页处理
    const page = params.page || 1;
    const pageSize = params.pageSize || 10;
    const total = allData.length;
    const start = (page - 1) * pageSize;
    const rows = allData.slice(start, start + pageSize);

    return { data: { rows, total } };
  });
}

/**
 * 获取全部数据（内部方法）
 */
async function getAllData(schemaKey) {
  const storageKey = getStorageKey(schemaKey);
  try {
    const res = await getRequest()({
      url: `/system/user-config/${storageKey}`,
      method: 'get'
    });
    const rawValue = res.data || res.msg || '';
    if (rawValue && typeof rawValue === 'string') {
      return JSON.parse(rawValue);
    } else if (Array.isArray(rawValue)) {
      return rawValue;
    }
    return [];
  } catch (e) {
    return [];
  }
}

/**
 * 保存全部数据（内部方法）
 */
async function saveAllData(schemaKey, dataList) {
  const storageKey = getStorageKey(schemaKey);
  return getRequest()({
    url: '/system/user-config',
    method: 'post',
    data: {
      key: storageKey,
      value: JSON.stringify(dataList)
    }
  });
}

/**
 * 2. 新增数据接口 (Create)
 * POST /codeless/data/{schemaKey}
 * @param {string} schemaKey 模型标识
 * @param {object} data 数据对象
 */
export async function apiCreateData(schemaKey, data) {
  const allData = await getAllData(schemaKey);
  allData.push(data);
  return saveAllData(schemaKey, allData);
}

/**
 * 3. 更新数据接口 (Update)
 * PUT /codeless/data/{schemaKey}/{id}
 * @param {string} schemaKey 模型标识
 * @param {string|number} id 数据ID
 * @param {object} data 更新的数据对象
 */
export async function apiUpdateData(schemaKey, id, data) {
  const allData = await getAllData(schemaKey);
  const index = allData.findIndex(item => item.id === id);
  if (index === -1) {
    return Promise.reject(new Error('数据不存在'));
  }
  allData[index] = { ...allData[index], ...data };
  return saveAllData(schemaKey, allData);
}

/**
 * 4. 删除数据接口 (Delete)
 * DELETE /codeless/data/{schemaKey}/{id}
 * @param {string} schemaKey 模型标识
 * @param {string|number} id 数据ID
 */
export async function apiDeleteData(schemaKey, id) {
  const allData = await getAllData(schemaKey);
  const filtered = allData.filter(item => item.id !== id);
  return saveAllData(schemaKey, filtered);
}
