import { apiSearchData, apiCreateData, apiUpdateData, apiDeleteData } from '../api/data';
import { Message } from 'element-ui';

/**
 * CURD 业务逻辑封装
 * 包含错误处理、成功提示、参数组装等
 */
export const crud = {
  /**
   * 1. 分页查询 (Retrieve)
   * 封装了分页参数组装和返回值处理
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
      
      // 兼容后端可能返回的不同结构，确保返回 { rows, total }
      // 假设 axios 拦截器已经处理了 res.data，这里 res 就是后端返回的数据体
      const data = res.data || res; 
      
      return {
        rows: Array.isArray(data.rows) ? data.rows : [],
        total: typeof data.total === 'number' ? data.total : 0
      };
    } catch (error) {
      console.error('[CodeLess] 获取列表失败:', error);
      // 这里的 error 已经被 request 拦截器处理过，通常不需要再次 Message.error
      // 如果需要特定处理可以加
      throw error;
    }
  },

  /**
   * 2. 创建数据 (Create)
   * 封装了成功提示
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
   * 3. 更新数据 (Update)
   * 封装了成功提示
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
   * 4. 删除数据 (Delete)
   * 封装了确认逻辑（注意：UI层通常先弹窗确认，这里是执行删除动作）
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
