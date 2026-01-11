const express = require('express');
const router = express.Router();
const documentService = require('../services/documentService');

/**
 * 统一响应格式
 */
function success(data, msg = '操作成功') {
  return { code: 200, msg, data };
}

function error(msg = '操作失败', code = 500) {
  return { code, msg, data: null };
}

/**
 * POST /data/:schemaKey/search
 * 分页查询
 */
router.post('/:schemaKey/search', async (req, res) => {
  try {
    const { schemaKey } = req.params;
    const { page, pageSize, query } = req.body;
    const result = await documentService.search(schemaKey, { page, pageSize, query });
    res.json(success(result));
  } catch (err) {
    console.error('[API] 查询失败:', err);
    res.status(500).json(error(err.message));
  }
});

/**
 * POST /data/:schemaKey
 * 新增数据
 */
router.post('/:schemaKey', async (req, res) => {
  try {
    const { schemaKey } = req.params;
    const data = req.body;
    const result = await documentService.create(schemaKey, data);
    res.json(success(result, '创建成功'));
  } catch (err) {
    console.error('[API] 创建失败:', err);
    res.status(500).json(error(err.message));
  }
});

/**
 * GET /data/:schemaKey/:id
 * 获取单条数据
 */
router.get('/:schemaKey/:id', async (req, res) => {
  try {
    const { schemaKey, id } = req.params;
    const result = await documentService.getById(schemaKey, id);
    if (!result) {
      return res.status(404).json(error('数据不存在', 404));
    }
    res.json(success(result));
  } catch (err) {
    console.error('[API] 查询失败:', err);
    res.status(500).json(error(err.message));
  }
});

/**
 * PUT /data/:schemaKey/:id
 * 更新数据
 */
router.put('/:schemaKey/:id', async (req, res) => {
  try {
    const { schemaKey, id } = req.params;
    const data = req.body;
    const result = await documentService.update(schemaKey, id, data);
    res.json(success(result, '更新成功'));
  } catch (err) {
    console.error('[API] 更新失败:', err);
    res.status(500).json(error(err.message));
  }
});

/**
 * DELETE /data/:schemaKey/:id
 * 删除数据
 */
router.delete('/:schemaKey/:id', async (req, res) => {
  try {
    const { schemaKey, id } = req.params;
    await documentService.remove(schemaKey, id);
    res.json(success(null, '删除成功'));
  } catch (err) {
    console.error('[API] 删除失败:', err);
    res.status(500).json(error(err.message));
  }
});

module.exports = router;
