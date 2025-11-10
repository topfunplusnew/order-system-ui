# 订单管理系统 - Monorepo 项目

这是一个基于 Vue 2 的订单管理系统前端项目，采用 Monorepo 架构管理多个包。

## 📁 项目结构

```
order-UI/
├── packages/
│   ├── order-system/        # 主应用 - 订单管理系统
│   ├── shared/              # 共享代码（工具函数、常量、类型）
│   ├── ui-components/       # 共享UI组件库
│   └── config/              # 共享配置文件（ESLint、Babel、Prettier）
├── package.json             # 根目录配置
└── README.md                # 项目说明
```

## 🚀 快速开始

### 安装依赖

```bash
yarn install
# 或
yarn install-order  # 忽略引擎版本检查
```

### 开发

```bash
# 启动所有工作区的开发服务器
yarn order

# 或单独启动主应用
cd packages/order-system
yarn dev
```

### 构建

```bash
# 构建所有包
yarn build

# 构建生产环境
cd packages/order-system
yarn build:prod
```

## 📦 包说明

### @order-system/order-system

主应用包，包含完整的订单管理系统功能。

**重要：** `src/views/` 目录结构保持不变，所有视图相关的代码都在此目录下。

### @order-system/shared

共享工具函数、常量和类型定义。

**使用方式：**
```javascript
import { getToken, setToken } from '@order-system/shared/utils/auth';
import { API_BASE_URL } from '@order-system/shared/constants';
```

### @order-system/ui-components

共享UI组件库，包含可在多个应用中复用的通用组件。

**使用方式：**
```javascript
import { Pagination, DictTag } from '@order-system/ui-components';
```

### @order-system/config

共享配置文件，包含 ESLint、Babel、Prettier 等工具的配置。

**使用方式：**
- ESLint: 在 `.eslintrc.js` 中 `extends: ['@order-system/config/eslint-config']`
- Babel: 在 `babel.config.js` 中 `require('@order-system/config/babel-config')`

## 🔧 开发规范

### 代码规范

- 使用 ESLint 进行代码检查
- 使用 Prettier 进行代码格式化
- 提交前会自动运行 lint-staged 检查

### 目录规范

- `packages/order-system/src/views/` - 视图目录，结构保持不变
- `packages/order-system/src/components/` - 业务组件（可逐步迁移到 ui-components）
- `packages/shared/` - 通用工具和常量
- `packages/ui-components/` - 通用UI组件

## 📝 注意事项

1. **views 目录结构不变**：所有视图相关的代码保持在 `packages/order-system/src/views/` 目录下，不会进行迁移。

2. **依赖管理**：使用 Yarn Workspaces 管理依赖，公共依赖可以提升到根目录。

3. **配置统一**：ESLint、Babel 等配置统一在 `@order-system/config` 包中管理。

4. **别名配置**：在 `vue.config.js` 中配置了以下别名：
   - `@` - 指向 `packages/order-system/src`
   - `@shared` - 指向 `packages/shared`
   - `@ui-components` - 指向 `packages/ui-components`
   - `@config` - 指向 `packages/config`

## 🛠️ 技术栈

- Vue 2.6.12
- Vue Router 3.4.9
- Vuex 3.6.0
- Element UI 2.15.14
- Webpack 5
- Yarn Workspaces

## 📄 License

MIT

