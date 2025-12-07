/**
 * 页面管理 API
 */
const express = require('express');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');
const { db } = require('../db');

// 获取页面列表
router.get('/', (req, res) => {
	try {
		const { status, keyword } = req.query;
		let sql = 'SELECT * FROM pages WHERE 1=1';
		const params = [];

		if (status !== undefined && status !== '') {
			sql += ' AND status = ?';
			params.push(parseInt(status));
		}

		if (keyword) {
			sql += ' AND (name LIKE ? OR description LIKE ?)';
			params.push(`%${keyword}%`, `%${keyword}%`);
		}

		sql += ' ORDER BY updated_at DESC';

		const pages = db.prepare(sql).all(...params);
		res.json({
			code: 200,
			data: pages.map(p => ({
				...p,
				schema: JSON.parse(p.schema || '[]')
			})),
			msg: '获取成功'
		});
	} catch (error) {
		res.status(500).json({ code: 500, msg: error.message });
	}
});

// 获取单个页面
router.get('/:id', (req, res) => {
	try {
		const page = db.prepare('SELECT * FROM pages WHERE id = ?').get(req.params.id);
		if (!page) {
			return res.status(404).json({ code: 404, msg: '页面不存在' });
		}
		res.json({
			code: 200,
			data: {
				...page,
				schema: JSON.parse(page.schema || '[]')
			},
			msg: '获取成功'
		});
	} catch (error) {
		res.status(500).json({ code: 500, msg: error.message });
	}
});

// 创建页面
router.post('/', (req, res) => {
	try {
		const { name, path, description, schema } = req.body;
		if (!name) {
			return res.status(400).json({ code: 400, msg: '页面名称不能为空' });
		}

		const id = uuidv4();
		const schemaStr = JSON.stringify(schema || []);

		db.prepare(
			`
      INSERT INTO pages (id, name, path, description, schema)
      VALUES (?, ?, ?, ?, ?)
    `
		).run(id, name, path || `/${id}`, description || '', schemaStr);

		res.json({ code: 200, data: { id }, msg: '创建成功' });
	} catch (error) {
		if (error.message.includes('UNIQUE constraint failed')) {
			return res.status(400).json({ code: 400, msg: '页面路径已存在' });
		}
		res.status(500).json({ code: 500, msg: error.message });
	}
});

// 更新页面
router.put('/:id', (req, res) => {
	try {
		const { name, path, description, schema, status } = req.body;
		const page = db.prepare('SELECT * FROM pages WHERE id = ?').get(req.params.id);

		if (!page) {
			return res.status(404).json({ code: 404, msg: '页面不存在' });
		}

		const updates = [];
		const params = [];

		if (name !== undefined) {
			updates.push('name = ?');
			params.push(name);
		}
		if (path !== undefined) {
			updates.push('path = ?');
			params.push(path);
		}
		if (description !== undefined) {
			updates.push('description = ?');
			params.push(description);
		}
		if (schema !== undefined) {
			updates.push('schema = ?');
			params.push(JSON.stringify(schema));
		}
		if (status !== undefined) {
			updates.push('status = ?');
			params.push(status);
		}

		updates.push('updated_at = CURRENT_TIMESTAMP');
		params.push(req.params.id);

		db.prepare(`UPDATE pages SET ${updates.join(', ')} WHERE id = ?`).run(...params);

		res.json({ code: 200, msg: '更新成功' });
	} catch (error) {
		if (error.message.includes('UNIQUE constraint failed')) {
			return res.status(400).json({ code: 400, msg: '页面路径已存在' });
		}
		res.status(500).json({ code: 500, msg: error.message });
	}
});

// 删除页面
router.delete('/:id', (req, res) => {
	try {
		const result = db.prepare('DELETE FROM pages WHERE id = ?').run(req.params.id);
		if (result.changes === 0) {
			return res.status(404).json({ code: 404, msg: '页面不存在' });
		}
		res.json({ code: 200, msg: '删除成功' });
	} catch (error) {
		res.status(500).json({ code: 500, msg: error.message });
	}
});

// 复制页面
router.post('/:id/copy', (req, res) => {
	try {
		const page = db.prepare('SELECT * FROM pages WHERE id = ?').get(req.params.id);
		if (!page) {
			return res.status(404).json({ code: 404, msg: '页面不存在' });
		}

		const newId = uuidv4();
		db.prepare(
			`
      INSERT INTO pages (id, name, path, description, schema)
      VALUES (?, ?, ?, ?, ?)
    `
		).run(newId, `${page.name}_副本`, `/${newId}`, page.description, page.schema);

		res.json({ code: 200, data: { id: newId }, msg: '复制成功' });
	} catch (error) {
		res.status(500).json({ code: 500, msg: error.message });
	}
});

module.exports = router;
