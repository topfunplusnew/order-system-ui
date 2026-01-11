/**
 * 本地存储工具 - 用于在后端接口实现前进行数据模拟存储
 * 后端实现后可切换为真实 API 调用
 */

const STORAGE_PREFIX = 'codeless_';

/**
 * 获取存储 Key
 */
function getStorageKey(schemaKey) {
  return `${STORAGE_PREFIX}${schemaKey}`;
}

/**
 * 获取所有数据
 */
function getAllData(schemaKey) {
  const key = getStorageKey(schemaKey);
  const data = localStorage.getItem(key);
  return data ? JSON.parse(data) : [];
}

/**
 * 保存所有数据
 */
function saveAllData(schemaKey, dataList) {
  const key = getStorageKey(schemaKey);
  localStorage.setItem(key, JSON.stringify(dataList));
}

/**
 * 本地 CRUD 操作
 */
export const localCrud = {
  /**
   * 分页查询
   */
  async getList(schemaKey, query = {}, page = 1, pageSize = 10) {
    let allData = getAllData(schemaKey);
    
    // 关键词搜索
    if (query.keyword) {
      const keyword = query.keyword.toLowerCase();
      allData = allData.filter(item => 
        (item.name && item.name.toLowerCase().includes(keyword)) ||
        (item.path && item.path.toLowerCase().includes(keyword))
      );
    }
    
    // 按更新时间倒序
    allData.sort((a, b) => new Date(b.updatedAt) - new Date(a.updatedAt));
    
    // 分页
    const total = allData.length;
    const start = (page - 1) * pageSize;
    const rows = allData.slice(start, start + pageSize);
    
    return { rows, total };
  },

  /**
   * 创建数据
   */
  async create(schemaKey, data) {
    const allData = getAllData(schemaKey);
    allData.push(data);
    saveAllData(schemaKey, allData);
    return true;
  },

  /**
   * 更新数据
   */
  async update(schemaKey, id, updateData) {
    const allData = getAllData(schemaKey);
    const index = allData.findIndex(item => item.id === id);
    if (index === -1) {
      throw new Error('数据不存在');
    }
    allData[index] = { ...allData[index], ...updateData };
    saveAllData(schemaKey, allData);
    return true;
  },

  /**
   * 删除数据
   */
  async remove(schemaKey, id) {
    const allData = getAllData(schemaKey);
    const filtered = allData.filter(item => item.id !== id);
    saveAllData(schemaKey, filtered);
    return true;
  }
};
