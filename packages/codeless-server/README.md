# CodeLess Server

低代码平台 MongoDB 后端服务，提供通用的数据存储 API。

## 技术栈

- **Node.js** - 运行环境
- **Express** - Web 框架
- **MongoDB** - 数据库
- **Mongoose** - ODM

## 快速开始

### 1. 启动 MongoDB

使用 Docker 启动带认证的 MongoDB：

```bash
docker run -d \
  --name codeless-mongo \
  -p 28017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=order \
  -e MONGO_INITDB_ROOT_PASSWORD=8fb5aa88-9041-4e7d-8211-51c86137743e \
  mongo:latest
```

**MongoDB 配置信息：**

| 配置项 | 值 |
|--------|-----|
| 端口 | 28017 |
| 用户名 | order |
| 密码 | 8fb5aa88-9041-4e7d-8211-51c86137743e |
| 数据库 | codeless |

### 2. 安装依赖

```bash
cd packages/codeless-server
npm install
```

### 3. 配置环境变量

```bash
cp .env.example .env
```

`.env` 文件内容：

```env
# MongoDB 连接配置
MONGODB_URI=mongodb://order:8fb5aa88-9041-4e7d-8211-51c86137743e@localhost:28017/codeless?authSource=admin

# 服务端口
PORT=3100
```

### 4. 启动服务

```bash
# 生产模式
npm start

# 开发模式（自动重启）
npm run dev
```

## 与前端集成

### 一键启动（推荐）

在项目根目录执行：

```bash
# 同时启动 codeless-server 和 order-system，日志合并输出
yarn order
```

日志输出示例：
```
[CODELESS] [MongoDB] 连接成功: mongodb://order:***@localhost:28017/codeless
[CODELESS] [CodeLess Server] 服务已启动: http://localhost:3100
[ORDER] App running at: http://localhost:40080/
```

### 单独启动

```bash
# 只启动 order-system（不启动 codeless-server）
yarn order:only

# 只启动 codeless-server
yarn codeless:dev
```

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

## Docker 命令参考

### 启动 MongoDB

```bash
docker run -d \
  --name codeless-mongo \
  -p 28017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=order \
  -e MONGO_INITDB_ROOT_PASSWORD=8fb5aa88-9041-4e7d-8211-51c86137743e \
  mongo:latest
```

### 停止 MongoDB

```bash
docker stop codeless-mongo
```

### 启动已停止的 MongoDB

```bash
docker start codeless-mongo
```

### 删除 MongoDB 容器

```bash
docker rm -f codeless-mongo
```

### 查看 MongoDB 日志

```bash
docker logs -f codeless-mongo
```

### 进入 MongoDB Shell

```bash
docker exec -it codeless-mongo mongosh -u order -p 8fb5aa88-9041-4e7d-8211-51c86137743e --authenticationDatabase admin
```

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
├── .env                      # 环境变量（不提交到 git）
├── .env.example              # 环境变量示例
├── .gitignore
├── package.json
└── README.md
```
