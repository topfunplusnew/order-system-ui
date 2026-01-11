import { apiSearchData, apiCreateData, apiUpdateData, apiDeleteData } from '../api/data';
import { Message } from 'element-ui';

/**
 * CRUD 业务逻辑封装
 */
export const crud = {
  /**
   * 分页查询
   * @param {string} schemaKey 模型标识
   * @param {object} query 查询条件
   * @param {number} page 当前页码
   * @param {number} pageSize 每页条数
   * @returns {Promise<{rows: Array, total: number}>}
   */
  async getList(schemaKey, query = {}, page = 1, pageSize = 10) {
    try {
      const payload = {
        page: parseInt(page),
        pageSize: parseInt(pageSize),
        query: query
      };
      const res = await apiSearchData(schemaKey, payload);
      const data = res.data || res;
      return {
        rows: Array.isArray(data.rows) ? data.rows : [],
        total: typeof data.total === 'number' ? data.total : 0
      };
    } catch (error) {
      console.error('[CodeLess] 获取列表失败:', error);
      throw error;
    }
  },

  /**
   * 创建数据
   * @param {string} schemaKey 模型标识
   * @param {object} formModel 表单数据
   * @returns {Promise<boolean>}
   */
  async create(schemaKey, formModel) {
    try {
      await apiCreateData(schemaKey, formModel);
      Message.success('创建成功');
      return true;
    } catch (error) {
      console.error('[CodeLess] 创建失败:', error);
      throw error;
    }
  },

  /**
   * 更新数据
   * @param {string} schemaKey 模型标识
   * @param {string|number} id 数据ID
   * @param {object} formModel 表单数据
   * @returns {Promise<boolean>}
   */
  async update(schemaKey, id, formModel) {
    if (!id) {
      Message.error('更新失败：缺少ID');
      return false;
    }
    try {
      await apiUpdateData(schemaKey, id, formModel);
      Message.success('更新成功');
      return true;
    } catch (error) {
      console.error('[CodeLess] 更新失败:', error);
      throw error;
    }
  },

  /**
   * 删除数据
   * @param {string} schemaKey 模型标识
   * @param {string|number} id 数据ID
   * @returns {Promise<boolean>}
   */
  async remove(schemaKey, id) {
    if (!id) {
      Message.error('删除失败：缺少ID');
      return false;
    }
    try {
      await apiDeleteData(schemaKey, id);
      Message.success('删除成功');
      return true;
    } catch (error) {
      console.error('[CodeLess] 删除失败:', error);
      throw error;
    }
  }
};
