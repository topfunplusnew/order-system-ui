# Project Context

## Purpose
该项目是一个基于 RuoYi-Vue 架构的订单管理系统 UI。它旨在为后台业务提供高效的多端支持（PC、AI 生成等），管理订单、运费申请、奖励明细等核心业务。

## Tech Stack
- **Framework**: Vue 2.6.12 (with @vue/composition-api)
- **UI Framework**: Element UI (2.15.14), Ant Design Vue (1.x, used in some packages), umy-ui
- **State Management**: Vuex 3.6.0
- **Routing**: Vue Router 3.4.9
- **Build Tools**: Vue CLI Service (Webpack 5), Yarn Workspaces (Monorepo)
- **Utilities**: Axios, ECharts, Lodash, Dayjs, Mathjs, XLSX
- **Testing**: Jest 29+

## Project Conventions

### Code Style
- **Linter/Formatter**: ESLint + Prettier (配置在项目根目录)
- **Naming**: 
  - 组件名：PascalCase (例如 `ElTableOrder.vue`)
  - 变量/函数：camelCase
  - 常量：UPPER_SNAKE_CASE
- **File Structure**: 
  - 业务代码位于 `packages/` 目录下。
  - API 逻辑集中在 `src/api/`。
  - 公共混入位于 `src/mixins/`。

### Architecture Patterns
- **Monorepo**: 使用 Yarn Workspaces 管理多个子包。
- **Mixins**: 复杂的业务逻辑（如订单处理）通过 `mixin_order_*.js` 进行解耦。
- **Component-driven**: 核心表格和搜索栏被封装为高度可配置的组件（如 `ElTableOrder.vue`）。

### Testing Strategy
- **Unit Testing**: 使用 Jest 进行逻辑测试。
- **Linting**: 提交代码前必须通过 `eslint --fix`。

### Git Workflow
- 虽然在本地环境中，但建议遵循功能分支（feature-driven）开发模式。
- 提交信息应简洁明了，描述变更意图。

## Domain Context
- **核心模型**: 订单 (GoodsOrder), 运费申请 (ApplyFreight), 奖励 (SalesReward).
- **业务流程**: 订单审核、运费核算、发货管理、销售奖励自动计算。

## Important Constraints
- 需要支持 Vue 2 模板编译环境。
- 部分旧代码依赖 Ant Design Vue 1.x，新开发应优先考虑 Element UI 兼容性。

## External Dependencies
- 后端 API (Spring Boot/RuoYi base)
- 文件导出服务
- 订单同步系统
