# CodeLess Server

低代码平台 MongoDB 后端服务，提供通用的数据存储 API。

## 技术栈

- **Node.js** - 运行环境
- **Express** - Web 框架
- **MongoDB** - 数据库
- **Mongoose** - ODM

## 快速开始

### 1. 安装依赖

```bash
cd packages/codeless-server
npm install
```

### 2. 配置环境变量

```bash
cp .env.example .env
```

编辑 `.env` 文件：

```env
# MongoDB 连接地址
MONGODB_URI=mongodb://localhost:27017/codeless

# 服务端口
PORT=3100
```

### 3. 启动 MongoDB

确保 MongoDB 服务已启动：

```bash
# macOS (Homebrew)
brew services start mongodb-community

# Linux (systemd)
sudo systemctl start mongod

# Docker
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

### 4. 启动服务

```bash
# 生产模式
npm start

# 开发模式（自动重启）
npm run dev
```

服务启动后访问：`http://localhost:3100`

## API 接口

所有接口基础路径：`/codeless/data`

### 通用说明

- `schemaKey`: 数据模型标识（如 `api_endpoint`、`form_schema`）
- 响应格式：`{ code: 200, msg: "操作成功", data: {...} }`

### 接口列表

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/codeless/data/:schemaKey/search` | 分页查询 |
| POST | `/codeless/data/:schemaKey` | 新增数据 |
| GET | `/codeless/data/:schemaKey/:id` | 获取单条 |
| PUT | `/codeless/data/:schemaKey/:id` | 更新数据 |
| DELETE | `/codeless/data/:schemaKey/:id` | 删除数据 |
| GET | `/codeless/health` | 健康检查 |

### 请求示例

#### 分页查询

```bash
curl -X POST http://localhost:3100/codeless/data/api_endpoint/search \
  -H "Content-Type: application/json" \
  -d '{
    "page": 1,
    "pageSize": 10,
    "query": {
      "keyword": "用户"
    }
  }'
```

#### 新增数据

```bash
curl -X POST http://localhost:3100/codeless/data/api_endpoint \
  -H "Content-Type: application/json" \
  -d '{
    "id": "ep_123",
    "name": "获取用户列表",
    "path": "/api/users",
    "method": "GET"
  }'
```

#### 更新数据

```bash
curl -X PUT http://localhost:3100/codeless/data/api_endpoint/ep_123 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "获取用户列表（已更新）"
  }'
```

#### 删除数据

```bash
curl -X DELETE http://localhost:3100/codeless/data/api_endpoint/ep_123
```

## 数据结构

MongoDB 中的文档结构：

```javascript
{
  _id: ObjectId,
  schemaKey: "api_endpoint",  // 数据模型标识
  dataId: "ep_123",           // 业务数据 ID
  data: {                     // 实际业务数据
    id: "ep_123",
    name: "获取用户列表",
    path: "/api/users",
    method: "GET",
    ...
  },
  createdAt: ISODate,
  updatedAt: ISODate
}
```

## 与前端集成

### 代理配置

在 `order-system/vue.config.js` 中已配置代理：

```javascript
proxy: {
  '/dev-api/codeless': {
    target: 'http://localhost:3100',
    changeOrigin: true,
    pathRewrite: { '^/dev-api': '' }
  }
}
```

### 启动顺序

1. 启动 MongoDB
2. 启动 codeless-server: `npm run dev`
3. 启动 order-system: `yarn order`

## 目录结构

```
codeless-server/
├── src/
│   ├── index.js              # 入口文件
│   ├── config/
│   │   ├── index.js          # 配置
│   │   └── db.js             # MongoDB 连接
│   ├── models/
│   │   └── BaseDocument.js   # 通用文档模型
│   ├── services/
│   │   └── documentService.js # 数据服务层
│   └── routes/
│       └── data.js           # API 路由
├── .env.example
├── .gitignore
├── package.json
└── README.md
```
