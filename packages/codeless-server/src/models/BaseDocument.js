const mongoose = require('mongoose');

/**
 * 通用文档模型
 * 使用动态 schemaKey 来区分不同类型的数据
 * 数据内容存储在 data 字段中（Mixed 类型，支持任意 JSON）
 */
const baseDocumentSchema = new mongoose.Schema({
  // 模型标识（如 api_endpoint、form_schema 等）
  schemaKey: {
    type: String,
    required: true,
    index: true
  },
  // 业务数据 ID（前端生成）
  dataId: {
    type: String,
    required: true
  },
  // 实际数据内容（支持任意 JSON 结构）
  data: {
    type: mongoose.Schema.Types.Mixed,
    required: true
  }
}, {
  timestamps: true,  // 自动添加 createdAt 和 updatedAt
  collection: 'codeless_documents'
});

// 复合索引：schemaKey + dataId 唯一
baseDocumentSchema.index({ schemaKey: 1, dataId: 1 }, { unique: true });

module.exports = mongoose.model('BaseDocument', baseDocumentSchema);
