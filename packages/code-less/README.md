# 低代码开发系统

订单系统前端低代码构建组件，提供可视化页面搭建能力。

## 功能特性

- 📦 **组件库** - 预置多种常用组件（表单、表格、按钮等）
- 🎨 **可视化编辑** - 拖拽式页面设计器
- 👁️ **实时预览** - 所见即所得的预览体验
- 💾 **页面管理** - 创建、编辑、复制、发布页面

## 技术架构

### 后端
- Express.js 服务框架
- SQLite 数据库（better-sqlite3）
- RESTful API 设计

### 前端
- Vue 2 + Element UI
- 拖拽组件设计
- 动态组件渲染

## 快速开始

### 1. 安装依赖

```bash
# 在项目根目录
yarn install

# 或单独安装 code-less 依赖
cd packages/code-less
npm install
```

### 2. 启动后端服务

```bash
# 在 packages/code-less 目录
npm start

# 服务将在 http://localhost:3100 启动
```

### 3. 访问系统

在订单系统中，点击右上角用户名 → 低代码开发

## API 接口

### 页面管理

| 方法 | 路径 | 描述 |
|------|------|------|
| GET | /api/codeless/pages | 获取页面列表 |
| GET | /api/codeless/pages/:id | 获取单个页面 |
| POST | /api/codeless/pages | 创建页面 |
| PUT | /api/codeless/pages/:id | 更新页面 |
| DELETE | /api/codeless/pages/:id | 删除页面 |
| POST | /api/codeless/pages/:id/copy | 复制页面 |

### 组件管理

| 方法 | 路径 | 描述 |
|------|------|------|
| GET | /api/codeless/components | 获取组件列表 |
| GET | /api/codeless/components/categories | 获取组件分类 |

## 目录结构

```
packages/code-less/
├── server/                 # 后端服务
│   ├── app.js             # Express 入口
│   ├── db.js              # 数据库初始化
│   └── routes/            # API 路由
│       ├── pages.js       # 页面管理
│       └── components.js  # 组件管理
├── src/                   # 前端源码
│   ├── api/               # API 封装
│   ├── components/        # 公共组件
│   └── views/             # 页面视图
│       ├── index.vue      # 首页
│       ├── editor.vue     # 编辑器
│       └── preview.vue    # 预览
├── data/                  # SQLite 数据文件
├── package.json
└── README.md
```

## 预置组件

### 基础组件
- **文本** - 静态文本展示
- **按钮** - 操作按钮

### 表单组件
- **输入框** - 单行文本输入
- **多行文本** - 多行文本输入
- **下拉选择** - 单选/多选下拉
- **日期选择** - 日期选择器
- **单选框** - 单选选项
- **多选框** - 多选选项

### 数据组件
- **表格** - 数据表格展示
