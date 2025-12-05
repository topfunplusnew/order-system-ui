# 重构说明文档

## 重构概述

本次重构将项目从单一应用结构转换为标准的 Monorepo 结构，同时**保持 `packages/order-system/src/views/` 目录结构完全不变**。

## 新增的包结构

### 1. packages/shared
共享工具函数、常量和类型定义。

**目录结构：**
```
shared/
├── utils/          # 通用工具函数
│   ├── auth.js
│   ├── validate.js
│   ├── date.js
│   └── format.js
├── constants/      # 常量定义
│   └── index.js
├── types/          # 类型定义
│   └── index.js
├── index.js        # 入口文件
└── package.json
```

### 2. packages/ui-components
共享UI组件库。

**目录结构：**
```
ui-components/
├── components/     # 通用组件
│   └── Pagination/
├── index.js        # 入口文件
└── package.json
```

### 3. packages/config
共享配置文件。

**目录结构：**
```
config/
├── eslint-config/  # ESLint 配置
│   └── index.js
├── babel-config/   # Babel 配置
│   └── index.js
├── prettier-config/# Prettier 配置
│   └── index.js
├── index.js        # 入口文件
└── package.json
```

## 配置文件变更

### 1. 根目录 package.json
- 更新项目名称为 `order-system-ui`
- 添加项目描述
- workspaces 配置保持不变

### 2. packages/order-system/package.json
- 添加对共享包的依赖：
  - `@order-system/shared: workspace:*`
  - `@order-system/ui-components: workspace:*`
  - `@order-system/config: workspace:*`

### 3. packages/order-system/.eslintrc.js
- 改为使用共享的 ESLint 配置（通过相对路径引用）

### 4. packages/order-system/babel.config.js
- 改为使用共享的 Babel 配置（通过相对路径引用）

### 5. packages/order-system/vue.config.js
- 添加新的别名配置：
  - `@shared` → `packages/shared`
  - `@ui-components` → `packages/ui-components`
  - `@config` → `packages/config`

### 6. .gitignore
- 更新忽略规则，添加构建产物和缓存目录
- 注释掉 `yarn.lock`（应该提交）

## 保持不变的部分

### ✅ views 目录
- `packages/order-system/src/views/` 目录结构**完全不变**
- 所有视图相关的代码、组件、mixins 都保持原样
- 路由配置保持不变
- 视图之间的引用路径保持不变

### ✅ 业务逻辑
- 所有业务逻辑代码保持不变
- API 调用逻辑不变
- Store 模块不变
- 组件内部逻辑不变

## 使用方式

### 引用共享工具函数

```javascript
// 在 order-system 中使用
import { getToken, setToken } from '@order-system/shared/utils/auth';
import { API_BASE_URL } from '@order-system/shared/constants';
```

### 引用共享组件

```javascript
// 在 order-system 中使用
import { Pagination, DictTag } from '@order-system/ui-components';
```

### 使用别名

```javascript
// 也可以使用配置的别名
import { getToken } from '@shared/utils/auth';
import { Pagination } from '@ui-components';
```

## 后续优化建议

1. **逐步迁移组件**：可以将 `packages/order-system/src/components/` 中的通用组件逐步迁移到 `ui-components` 包

2. **提取工具函数**：可以将 `packages/order-system/src/utils/` 中的通用工具函数逐步迁移到 `shared` 包

3. **添加更多包**：未来可以添加：
   - `packages/mobile-app` - 移动端应用
   - `packages/admin-panel` - 管理后台
   - `packages/docs` - 文档站点

4. **构建优化**：可以考虑引入 `turbo` 或 `nx` 进行并行构建和缓存

## 注意事项

1. **依赖安装**：重构后需要重新运行 `yarn install` 来链接 workspace 包

2. **配置引用**：ESLint 和 Babel 配置使用相对路径引用，避免 workspace 解析问题

3. **别名配置**：Webpack 别名已配置，可以直接使用 `@shared`、`@ui-components` 等别名

4. **向后兼容**：所有原有的引用路径（如 `@/views/`、`@/components/`）都保持不变

## 验证步骤

1. 运行 `yarn install` 安装依赖
2. 运行 `yarn order` 启动开发服务器
3. 检查控制台是否有错误
4. 验证页面功能是否正常
5. 运行 `yarn build` 验证构建是否成功

