/**
 * 组件管理 API
 */
const express = require('express');
const router = express.Router();
const { db } = require('../db');

// 获取组件列表
router.get('/', (req, res) => {
	try {
		const { category } = req.query;
		let sql = 'SELECT * FROM components WHERE 1=1';
		const params = [];

		if (category) {
			sql += ' AND category = ?';
			params.push(category);
		}

		sql += ' ORDER BY category, name';

		const components = db.prepare(sql).all(...params);
		res.json({
			code: 200,
			data: components.map(c => ({
				...c,
				props_schema: JSON.parse(c.props_schema || '{}'),
				default_props: JSON.parse(c.default_props || '{}')
			})),
			msg: '获取成功'
		});
	} catch (error) {
		res.status(500).json({ code: 500, msg: error.message });
	}
});

// 获取组件分类
router.get('/categories', (req, res) => {
	try {
		const categories = [
			{ key: 'basic', name: '基础组件', icon: 'el-icon-s-grid' },
			{ key: 'form', name: '表单组件', icon: 'el-icon-document' },
			{ key: 'data', name: '数据组件', icon: 'el-icon-s-data' },
			{ key: 'layout', name: '布局组件', icon: 'el-icon-s-operation' }
		];
		res.json({ code: 200, data: categories, msg: '获取成功' });
	} catch (error) {
		res.status(500).json({ code: 500, msg: error.message });
	}
});

// 获取单个组件
router.get('/:id', (req, res) => {
	try {
		const component = db.prepare('SELECT * FROM components WHERE id = ?').get(req.params.id);
		if (!component) {
			return res.status(404).json({ code: 404, msg: '组件不存在' });
		}
		res.json({
			code: 200,
			data: {
				...component,
				props_schema: JSON.parse(component.props_schema || '{}'),
				default_props: JSON.parse(component.default_props || '{}')
			},
			msg: '获取成功'
		});
	} catch (error) {
		res.status(500).json({ code: 500, msg: error.message });
	}
});

module.exports = router;
