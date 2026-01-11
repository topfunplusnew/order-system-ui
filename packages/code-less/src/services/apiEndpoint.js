import { localCrud } from '../utils/localStorage';
import { Message } from 'element-ui';

// 模型标识
const SCHEMA_KEY = 'api_endpoint';

// HTTP 方法枚举
export const HTTP_METHODS = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];

// 状态枚举
export const ENDPOINT_STATUS = {
  ACTIVE: 'active',
  DEPRECATED: 'deprecated',
  DRAFT: 'draft'
};

/**
 * 生成唯一ID
 */
function generateId() {
  return 'ep_' + Date.now().toString(36) + Math.random().toString(36).substr(2, 9);
}

/**
 * 获取当前时间戳
 */
function getCurrentTimestamp() {
  return new Date().toISOString();
}

/**
 * 校验 API 端点数据
 */
function validateEndpoint(data) {
  if (!data.name || !data.name.trim()) {
    return { valid: false, message: '接口名称不能为空' };
  }
  if (!data.path || !data.path.trim()) {
    return { valid: false, message: '接口路径不能为空' };
  }
  if (!data.path.startsWith('/')) {
    return { valid: false, message: '接口路径必须以 / 开头' };
  }
  if (!data.method || !HTTP_METHODS.includes(data.method)) {
    return { valid: false, message: '请选择有效的 HTTP 方法' };
  }
  return { valid: true };
}

/**
 * 构建标准的 API 端点数据结构
 */
function buildEndpointData(formData) {
  return {
    name: formData.name?.trim() || '',
    path: formData.path?.trim() || '',
    method: formData.method || 'GET',
    description: formData.description?.trim() || '',
    headers: Array.isArray(formData.headers) ? formData.headers : [],
    params: Array.isArray(formData.params) ? formData.params : [],
    body: formData.body || { type: 'json', schema: {} },
    response: formData.response || { successCode: 200, schema: {} },
    tags: Array.isArray(formData.tags) ? formData.tags : [],
    status: formData.status || ENDPOINT_STATUS.DRAFT
  };
}

/**
 * API 端点管理服务
 * 基于 crud.js 的 CRUD 业务逻辑封装
 */
export const apiEndpointService = {
  /**
   * 获取 API 端点列表
   */
  async getEndpointList(query = {}, page = 1, pageSize = 10) {
    return await localCrud.getList(SCHEMA_KEY, query, page, pageSize);
  },

  /**
   * 创建 API 端点
   */
  async createEndpoint(formData) {
    const validation = validateEndpoint(formData);
    if (!validation.valid) {
      Message.error(validation.message);
      return false;
    }

    const endpointData = {
      id: generateId(),
      ...buildEndpointData(formData),
      createdAt: getCurrentTimestamp(),
      updatedAt: getCurrentTimestamp()
    };

    await localCrud.create(SCHEMA_KEY, endpointData);
    Message.success('创建成功');
    return true;
  },

  /**
   * 更新 API 端点
   */
  async updateEndpoint(id, formData) {
    if (!id) {
      Message.error('缺少端点ID');
      return false;
    }

    const validation = validateEndpoint(formData);
    if (!validation.valid) {
      Message.error(validation.message);
      return false;
    }

    const updateData = {
      ...buildEndpointData(formData),
      updatedAt: getCurrentTimestamp()
    };

    await localCrud.update(SCHEMA_KEY, id, updateData);
    Message.success('更新成功');
    return true;
  },

  /**
   * 删除 API 端点
   */
  async deleteEndpoint(id) {
    if (!id) {
      Message.error('缺少端点ID');
      return false;
    }
    await localCrud.remove(SCHEMA_KEY, id);
    Message.success('删除成功');
    return true;
  },

  /**
   * 获取空的端点表单模板
   */
  getEmptyForm() {
    return {
      name: '',
      path: '',
      method: 'GET',
      description: '',
      headers: [],
      params: [],
      body: { type: 'json', schema: {} },
      response: { successCode: 200, schema: {} },
      tags: [],
      status: ENDPOINT_STATUS.DRAFT
    };
  }
};
