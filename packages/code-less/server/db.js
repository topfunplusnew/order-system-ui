/**
 * SQLite 数据库初始化
 */
const Database = require('better-sqlite3');
const path = require('path');

const dbPath = path.join(__dirname, '../data/codeless.db');
const db = new Database(dbPath);

// 初始化数据库表
function initDatabase() {
	// 页面表
	db.exec(`
    CREATE TABLE IF NOT EXISTS pages (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      path TEXT UNIQUE,
      description TEXT,
      schema TEXT DEFAULT '[]',
      status INTEGER DEFAULT 0,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

	// 组件表
	db.exec(`
    CREATE TABLE IF NOT EXISTS components (
      id TEXT PRIMARY KEY,
      type TEXT NOT NULL,
      name TEXT NOT NULL,
      icon TEXT,
      category TEXT DEFAULT 'basic',
      props_schema TEXT DEFAULT '{}',
      default_props TEXT DEFAULT '{}',
      template TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

	// 初始化预设组件
	initPresetComponents();
}

// 初始化预设组件
function initPresetComponents() {
	const count = db.prepare('SELECT COUNT(*) as count FROM components').get();
	if (count.count > 0) return;

	const presetComponents = [
		{
			id: 'input',
			type: 'input',
			name: '输入框',
			icon: 'el-icon-edit',
			category: 'form',
			props_schema: JSON.stringify({
				label: { type: 'string', default: '输入框', title: '标签' },
				placeholder: { type: 'string', default: '请输入', title: '占位符' },
				field: { type: 'string', default: '', title: '字段名' },
				required: { type: 'boolean', default: false, title: '是否必填' },
				disabled: { type: 'boolean', default: false, title: '是否禁用' },
				maxlength: { type: 'number', default: null, title: '最大长度' }
			}),
			default_props: JSON.stringify({
				label: '输入框',
				placeholder: '请输入',
				field: '',
				required: false,
				disabled: false
			})
		},
		{
			id: 'select',
			type: 'select',
			name: '下拉选择',
			icon: 'el-icon-arrow-down',
			category: 'form',
			props_schema: JSON.stringify({
				label: { type: 'string', default: '下拉选择', title: '标签' },
				placeholder: { type: 'string', default: '请选择', title: '占位符' },
				field: { type: 'string', default: '', title: '字段名' },
				required: { type: 'boolean', default: false, title: '是否必填' },
				options: { type: 'array', default: [], title: '选项列表' },
				multiple: { type: 'boolean', default: false, title: '是否多选' }
			}),
			default_props: JSON.stringify({
				label: '下拉选择',
				placeholder: '请选择',
				field: '',
				required: false,
				options: [
					{ label: '选项1', value: '1' },
					{ label: '选项2', value: '2' }
				],
				multiple: false
			})
		},
		{
			id: 'datepicker',
			type: 'datepicker',
			name: '日期选择',
			icon: 'el-icon-date',
			category: 'form',
			props_schema: JSON.stringify({
				label: { type: 'string', default: '日期选择', title: '标签' },
				placeholder: { type: 'string', default: '请选择日期', title: '占位符' },
				field: { type: 'string', default: '', title: '字段名' },
				required: { type: 'boolean', default: false, title: '是否必填' },
				type: { type: 'string', default: 'date', title: '类型' }
			}),
			default_props: JSON.stringify({
				label: '日期选择',
				placeholder: '请选择日期',
				field: '',
				required: false,
				type: 'date'
			})
		},
		{
			id: 'button',
			type: 'button',
			name: '按钮',
			icon: 'el-icon-thumb',
			category: 'basic',
			props_schema: JSON.stringify({
				text: { type: 'string', default: '按钮', title: '按钮文字' },
				type: { type: 'string', default: 'primary', title: '按钮类型' },
				size: { type: 'string', default: 'medium', title: '尺寸' },
				action: { type: 'string', default: '', title: '点击事件' }
			}),
			default_props: JSON.stringify({
				text: '按钮',
				type: 'primary',
				size: 'medium',
				action: ''
			})
		},
		{
			id: 'table',
			type: 'table',
			name: '表格',
			icon: 'el-icon-s-grid',
			category: 'data',
			props_schema: JSON.stringify({
				columns: { type: 'array', default: [], title: '列配置' },
				dataSource: { type: 'string', default: '', title: '数据源' },
				border: { type: 'boolean', default: true, title: '显示边框' },
				stripe: { type: 'boolean', default: true, title: '斑马纹' }
			}),
			default_props: JSON.stringify({
				columns: [
					{ prop: 'name', label: '名称', width: '' },
					{ prop: 'value', label: '值', width: '' }
				],
				dataSource: '',
				border: true,
				stripe: true
			})
		},
		{
			id: 'text',
			type: 'text',
			name: '文本',
			icon: 'el-icon-document',
			category: 'basic',
			props_schema: JSON.stringify({
				content: { type: 'string', default: '文本内容', title: '文本内容' },
				fontSize: { type: 'number', default: 14, title: '字体大小' },
				color: { type: 'string', default: '#333', title: '文字颜色' },
				fontWeight: { type: 'string', default: 'normal', title: '字体粗细' }
			}),
			default_props: JSON.stringify({
				content: '文本内容',
				fontSize: 14,
				color: '#333',
				fontWeight: 'normal'
			})
		},
		{
			id: 'textarea',
			type: 'textarea',
			name: '多行文本',
			icon: 'el-icon-tickets',
			category: 'form',
			props_schema: JSON.stringify({
				label: { type: 'string', default: '多行文本', title: '标签' },
				placeholder: { type: 'string', default: '请输入', title: '占位符' },
				field: { type: 'string', default: '', title: '字段名' },
				required: { type: 'boolean', default: false, title: '是否必填' },
				rows: { type: 'number', default: 3, title: '行数' }
			}),
			default_props: JSON.stringify({
				label: '多行文本',
				placeholder: '请输入',
				field: '',
				required: false,
				rows: 3
			})
		},
		{
			id: 'radio',
			type: 'radio',
			name: '单选框',
			icon: 'el-icon-circle-check',
			category: 'form',
			props_schema: JSON.stringify({
				label: { type: 'string', default: '单选框', title: '标签' },
				field: { type: 'string', default: '', title: '字段名' },
				required: { type: 'boolean', default: false, title: '是否必填' },
				options: { type: 'array', default: [], title: '选项列表' }
			}),
			default_props: JSON.stringify({
				label: '单选框',
				field: '',
				required: false,
				options: [
					{ label: '选项1', value: '1' },
					{ label: '选项2', value: '2' }
				]
			})
		},
		{
			id: 'checkbox',
			type: 'checkbox',
			name: '多选框',
			icon: 'el-icon-finished',
			category: 'form',
			props_schema: JSON.stringify({
				label: { type: 'string', default: '多选框', title: '标签' },
				field: { type: 'string', default: '', title: '字段名' },
				required: { type: 'boolean', default: false, title: '是否必填' },
				options: { type: 'array', default: [], title: '选项列表' }
			}),
			default_props: JSON.stringify({
				label: '多选框',
				field: '',
				required: false,
				options: [
					{ label: '选项1', value: '1' },
					{ label: '选项2', value: '2' }
				]
			})
		}
	];

	const stmt = db.prepare(`
    INSERT INTO components (id, type, name, icon, category, props_schema, default_props)
    VALUES (@id, @type, @name, @icon, @category, @props_schema, @default_props)
  `);

	for (const comp of presetComponents) {
		stmt.run(comp);
	}
}

module.exports = { db, initDatabase };
