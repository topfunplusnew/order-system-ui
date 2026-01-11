const BaseDocument = require('../models/BaseDocument');

/**
 * 通用文档服务
 */
const documentService = {
  /**
   * 分页查询
   */
  async search(schemaKey, { page = 1, pageSize = 10, query = {} }) {
    const filter = { schemaKey };
    
    // 关键词搜索（在 data 字段中搜索）
    if (query.keyword) {
      const keyword = query.keyword;
      filter.$or = [
        { 'data.name': { $regex: keyword, $options: 'i' } },
        { 'data.path': { $regex: keyword, $options: 'i' } },
        { 'data.description': { $regex: keyword, $options: 'i' } }
      ];
    }

    const total = await BaseDocument.countDocuments(filter);
    const skip = (page - 1) * pageSize;
    
    const docs = await BaseDocument.find(filter)
      .sort({ updatedAt: -1 })
      .skip(skip)
      .limit(pageSize);

    // 返回 data 字段内容
    const rows = docs.map(doc => doc.data);

    return { rows, total };
  },

  /**
   * 创建文档
   */
  async create(schemaKey, data) {
    const doc = new BaseDocument({
      schemaKey,
      dataId: data.id,
      data
    });
    await doc.save();
    return doc.data;
  },

  /**
   * 更新文档
   */
  async update(schemaKey, id, data) {
    const doc = await BaseDocument.findOneAndUpdate(
      { schemaKey, dataId: id },
      { data: { ...data, id } },
      { new: true }
    );
    if (!doc) {
      throw new Error('文档不存在');
    }
    return doc.data;
  },

  /**
   * 删除文档
   */
  async remove(schemaKey, id) {
    const result = await BaseDocument.findOneAndDelete({ schemaKey, dataId: id });
    if (!result) {
      throw new Error('文档不存在');
    }
    return true;
  },

  /**
   * 获取单个文档
   */
  async getById(schemaKey, id) {
    const doc = await BaseDocument.findOne({ schemaKey, dataId: id });
    return doc ? doc.data : null;
  }
};

module.exports = documentService;
