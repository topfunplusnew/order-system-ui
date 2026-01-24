# 订单管理系统

一个基于 Vue 2 的企业级订单管理系统前端项目，采用 Monorepo 架构管理多个包，提供完整的订单、库存、财务、发票等业务管理功能。

## 📋 目录

- [项目简介](#项目简介)
- [技术栈](#技术栈)
- [项目结构](#项目结构)
- [快速开始](#快速开始)
- [功能模块](#功能模块)
- [开发指南](#开发指南)
- [构建部署](#构建部署)
- [代码规范](#代码规范)
- [常见问题](#常见问题)

## 📖 项目简介

订单管理系统是一个功能完善的企业级管理系统，主要用于管理企业的订单、库存、财务、发票、车辆、出差等核心业务。系统采用前后端分离架构，前端基于 Vue 2 和 Element UI 构建，提供直观友好的用户界面和丰富的业务功能。

### 主要特性

- ✅ **Monorepo 架构**：采用 Yarn Workspaces 管理多个包，代码组织清晰
- ✅ **模块化设计**：共享组件、工具函数、配置文件统一管理
- ✅ **丰富的业务功能**：订单、库存、财务、发票、车辆、出差等全业务覆盖
- ✅ **完善的权限管理**：基于角色的权限控制系统
- ✅ **数据可视化**：集成 ECharts 提供数据报表和图表展示
- ✅ **响应式设计**：适配不同屏幕尺寸，提供良好的用户体验

## 🛠️ 技术栈

### 核心框架

- **Vue** 2.6.12 - 渐进式 JavaScript 框架
- **Vue Router** 3.4.9 - 官方路由管理器
- **Vuex** 3.6.0 - 状态管理模式
- **Element UI** 2.15.14 - 基于 Vue 2 的组件库

### 构建工具

- **Vue CLI** 4.4.6 - Vue.js 开发的标准工具
- **Webpack** 5 - 模块打包器
- **Babel** - JavaScript 编译器
- **Sass** - CSS 预处理器

### 开发工具

- **ESLint** - 代码检查工具
- **Prettier** - 代码格式化工具
- **Jest** - JavaScript 测试框架
- **Husky** - Git hooks 工具

### 其他依赖

- **Axios** 0.28.1 - HTTP 客户端
- **ECharts** 5.4.0 - 数据可视化图表库
- **Lodash** 4.17.21 - JavaScript 工具库
- **Day.js** - 日期处理库
- **XLSX** - Excel 文件处理
- **Print.js** - 打印功能

## 📁 项目结构

```
order-system-ui/
├── order-UI/                          # 主项目目录
│   ├── packages/                      # Monorepo 包目录
│   │   ├── order-system/              # 主应用包
│   │   │   ├── src/
│   │   │   │   ├── api/               # API 接口定义
│   │   │   │   ├── assets/            # 静态资源
│   │   │   │   ├── components/        # 业务组件
│   │   │   │   ├── directive/         # 自定义指令
│   │   │   │   ├── layout/            # 布局组件
│   │   │   │   ├── mixins/            # 混入
│   │   │   │   ├── plugins/           # 插件
│   │   │   │   ├── router/            # 路由配置
│   │   │   │   ├── store/             # Vuex 状态管理
│   │   │   │   ├── utils/             # 工具函数
│   │   │   │   ├── views/             # 页面视图
│   │   │   │   │   ├── dashboard/     # 仪表盘
│   │   │   │   │   ├── system/        # 系统管理模块
│   │   │   │   │   ├── login.vue      # 登录页
│   │   │   │   │   └── ...
│   │   │   │   ├── App.vue            # 根组件
│   │   │   │   └── main.js            # 入口文件
│   │   │   ├── public/                # 公共资源
│   │   │   ├── vue.config.js          # Vue CLI 配置
│   │   │   ├── babel.config.js        # Babel 配置
│   │   │   └── package.json           # 包配置
│   │   ├── shared/                    # 共享代码包
│   │   │   ├── utils/                 # 通用工具函数
│   │   │   ├── constants/             # 常量定义
│   │   │   ├── types/                 # 类型定义
│   │   │   └── package.json
│   │   ├── ui-components/             # 共享UI组件库
│   │   │   ├── components/            # 通用组件
│   │   │   └── package.json
│   │   ├── config/                    # 共享配置文件
│   │   │   ├── eslint-config/        # ESLint 配置
│   │   │   ├── babel-config/          # Babel 配置
│   │   │   ├── prettier-config/       # Prettier 配置
│   │   │   └── package.json
│   │   └── request-logger/            # 请求日志工具
│   ├── doc/                           # 项目文档
│   ├── Dockerfile                     # Docker 配置
│   ├── nginx.conf                     # Nginx 配置
│   ├── package.json                   # 根目录配置
│   └── yarn.lock                      # 依赖锁定文件
└── README.md                          # 项目说明文档
```

## 🚀 快速开始

### 环境要求

- **Node.js** >= 18.20.6
- **npm** >= 3.0.0 或 **Yarn** >= 1.22.0
- **Git** >= 2.0.0

### 安装依赖

```bash
# 使用 Yarn（推荐）
yarn install

# 或忽略引擎版本检查
yarn install-order

# 使用 npm
npm install
```

### 开发模式

```bash
# 启动开发服务器（默认端口：40080）
yarn order

# 或进入主应用目录启动
cd order-UI/packages/order-system
yarn dev
```

开发服务器启动后，访问 `http://localhost:40080` 即可查看应用。

### 构建生产版本

```bash
# 构建测试环境
yarn build

# 构建生产环境
yarn build:prod

# 构建多版本（AI版本）
yarn build:ai
yarn build:ai:prod
yarn build:ai:stage
```

## 📦 功能模块

### 核心业务模块

#### 1. 订单管理 (GoodsOrder)
- 订单创建、编辑、查询
- 订单详情管理
- 订单运费管理
- 订单佣金管理
- 订单调整和历史记录

#### 2. 库存管理 (Inventory)
- 库存主单管理
- 库存明细查询
- 库存盘点
- 出库管理
- 库存报表

#### 3. 财务管理
- **付款管理** (Payment)：付款申请、审核、支付
- **收款管理** (ReceiveMoney)：收款记录、对账
- **借出款管理** (BorrowedMoney)
- **借入款管理** (LendMoney)
- **借出资金回收** (RecoverMoney)
- **贷款还款** (Repayment)
- **银行账户管理** (BankAccount)
- **银行账户变动** (BankAccountChange)
- **平账管理** (BalanceAccounts)

#### 4. 发票管理
- **进项发票** (InvoiceIn)：发票购入管理
- **销项发票** (InvoiceOut)：发票售出管理
- **其他发票** (InvoiceOther)：第三方发票管理

#### 5. 车辆管理
- **车辆信息** (Cars)：车辆档案管理
- **用车申请** (CarApply)：车辆使用申请
- **车队管理** (Fleet)

#### 6. 出差管理
- **商务出差** (BusinessTrip)：出差申请和管理
- **差旅报销** (TripReimbursement)

#### 7. 油卡管理
- **油卡管理** (OilCard)
- **油卡消费** (OilCardConsume)
- **油卡充值** (OilRecharge)
- **油卡资金转移** (OilCardFundTransfer)

#### 8. 公司/客户管理
- **公司管理** (Company)：客户和供应商管理
- **客户拜访** (CustomerVisit)

#### 9. 其他业务模块
- **返利管理** (Rebate)
- **社保管理** (SocialInsurance)
- **固定资产** (FixedAssets)
- **凭证管理** (Voucher)
- **商业票据** (BankAcceptance)
- **报表统计** (Report/Statement)

### 系统管理模块

- **用户管理** (User)
- **角色管理** (Role)
- **菜单管理** (Menu)
- **部门管理** (Dept)
- **岗位管理** (Post)
- **字典管理** (Dict)
- **参数配置** (Config)
- **通知公告** (Notice)
- **操作日志** (Operlog)
- **登录日志** (Logininfor)
- **在线用户** (Online)

## 💻 开发指南

### 包说明

#### @order-system/order-system
主应用包，包含完整的订单管理系统功能。

**重要说明**：`src/views/` 目录结构保持不变，所有视图相关的代码都在此目录下。

#### @order-system/shared
共享工具函数、常量和类型定义。

**使用方式**：
```javascript
import { getToken, setToken } from '@order-system/shared/utils/auth';
import { API_BASE_URL } from '@order-system/shared/constants';
```

#### @order-system/ui-components
共享UI组件库，包含可在多个应用中复用的通用组件。

**使用方式**：
```javascript
import { Pagination } from '@order-system/ui-components';
```

#### @order-system/config
共享配置文件，包含 ESLint、Babel、Prettier 等工具的配置。

### 路径别名

项目配置了以下路径别名，方便引用：

- `@` → `packages/order-system/src`
- `@shared` → `packages/shared`
- `@ui-components` → `packages/ui-components`
- `@config` → `packages/config`

**使用示例**：
```javascript
import { formatDate } from '@/utils/date';
import { API_BASE_URL } from '@shared/constants';
```

### 代码规范

#### ESLint
项目使用 ESLint 进行代码检查，配置文件位于 `packages/config/eslint-config/`。

```bash
# 检查代码
yarn lint

# 自动修复
yarn lint:eslint
```

#### Prettier
项目使用 Prettier 进行代码格式化。

```bash
# 格式化所有文件
yarn prettier

# 检查格式
yarn prettier:check
```

#### Git Hooks
项目配置了 Husky 和 lint-staged，提交代码前会自动运行代码检查和格式化。

### 测试

```bash
# 运行测试
cd order-UI/packages/order-system
yarn test
```

## 🏗️ 构建部署

### 环境变量

项目支持多环境配置，通过 `.env` 文件管理：

- `.env.development` - 开发环境
- `.env.staging` - 测试环境
- `.env.production` - 生产环境

### 构建命令

```bash
# 构建测试环境
yarn build

# 构建生产环境
yarn build:prod

# 构建多版本（支持多环境打包）
yarn build:ai:prod    # 生产环境
yarn build:ai:stage    # 测试环境
```

### Docker 部署

项目提供了 Dockerfile，可以使用 Docker 进行部署：

```bash
# 构建镜像
docker build -t order-system-ui .

# 运行容器
docker run -d -p 80:80 order-system-ui
```

### Nginx 配置

项目提供了 `nginx.conf` 配置文件，可以直接使用或根据实际情况修改。

## 📝 代码规范

### 目录规范

- `packages/order-system/src/views/` - 视图目录，结构保持不变
- `packages/order-system/src/components/` - 业务组件（可逐步迁移到 ui-components）
- `packages/shared/` - 通用工具和常量
- `packages/ui-components/` - 通用UI组件

### 命名规范

- **组件名**：使用 PascalCase，如 `OrderForm.vue`
- **文件名**：使用 kebab-case，如 `order-form.vue`
- **变量名**：使用 camelCase，如 `orderList`
- **常量名**：使用 UPPER_SNAKE_CASE，如 `API_BASE_URL`

### 提交规范

提交信息应遵循以下格式：

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type 类型**：
- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具相关

## ❓ 常见问题

### 1. 依赖安装失败

**问题**：安装依赖时出现版本不兼容错误。

**解决方案**：
```bash
# 忽略引擎版本检查
yarn install-order
```

### 2. 端口被占用

**问题**：开发服务器启动时提示端口 40080 被占用。

**解决方案**：
- 修改 `vue.config.js` 中的 `port` 配置
- 或通过环境变量设置：`PORT=8080 yarn order`

### 3. 构建失败

**问题**：构建时出现内存不足错误。

**解决方案**：
```bash
# 增加 Node.js 内存限制
NODE_OPTIONS=--max_old_space_size=4096 yarn build:prod
```

### 4. 样式不生效

**问题**：修改样式后页面没有更新。

**解决方案**：
- 检查样式文件路径是否正确
- 确认样式文件是否被正确导入
- 清除浏览器缓存

## 📚 相关文档

- [系统介绍与说明](./order-UI/doc/系统介绍与说明.md)
- [重构方案文档](./order-UI/REFACTORING.md)
- [迁移指南](./order-UI/packages/order-system/MIGRATION.md)
- [API 文档](./order-UI/packages/order-system/src/api/订单系统.openapi.json)
