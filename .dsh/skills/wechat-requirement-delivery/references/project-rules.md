# 项目编码铁律（order-system-ui）

来源：`.cursor/rules/master.mdc`、`.cursor/rules/apifox-development-rule.mdc`、`requirements/README.md`。
开工前建议再读一遍原文件，本文件只是速查。

## 技术栈红线

- **Vue2 + Options API + 纯 JavaScript**。
- 禁止：TypeScript、Vue3 Composition API、class-style 语法。
- 项目结构：yarn workspaces monorepo
  - `packages/order-system` 主应用（`src/api`、`src/components`、`src/mixins`、`src/views`、`src/utils`）
  - `packages/shared` 共享库、`packages/ui-components` UI 组件库

## 编码强制项

1. **JSDoc**：每个函数写 JSDoc，类型标注尽量详细（项目无 TS）。写代码前先声明"我会记得写 JSDoc"。
2. **lodash**：能用 lodash 就用，严格执行，不手写等价工具函数。
3. **mathjs**：所有数学运算（合计、税额、差额、比例）一律 mathjs 保证精度，再按指定小数位四舍五入。小数位用户没说 → 必须问。
4. **复用优先**：写需求前先检索库内可复用逻辑（弹窗、方法、枚举、常量、mixins、api 封装），禁止重复造轮子。
5. **响应式**：ERP 场景字段联动多，必须保证页面展示正确并联动更新。
6. **禁止函数套函数**：
   ```js
   // ✗ 抵制
   calculateRemainingAmount() {
     return row => this.computeRemainingAmountForRow(row);
   }
   ```
7. **单文件 ≤ 500 行**，超了拆分组件。
8. **表单初始化**用 `getInitForm()` 返回新对象，`reset()` 里重新赋值，避免对象引用共享。
9. 接口字段命名**保持后端原样**（下划线就下划线），不转驼峰。

## 文件顶部变更记录（强制）

**每改动一个文件，就在该文件顶部追加变更记录注释，最新在上，历史保留不删除。**

```vue
<!--
	变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
	- [YYYY-MM-DD] 本次改动说明（一句话讲清改了什么、为什么）。
	历史：
	- [YYYY-MM-DD] 历史改动说明。
-->
```

```javascript
/**
 * 变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
 * - [YYYY-MM-DD] 本次改动说明。
 * 历史：
 * - [YYYY-MM-DD] 历史改动说明。
 */
```

新增文件同样要在顶部写一条 `[YYYY-MM-DD] 新建`。

## 接口驱动（APIfox 铁律）

- 任何前端代码（data 字段、表单、请求参数、响应处理、表格列、校验、mock）都必须**先拉最新接口文档**，禁止凭记忆或假设写字段。
- 100% 对齐：完整路径、HTTP 方法、参数位置、字段精确命名、required、默认值、长度/范围、正则、枚举、嵌套层级、响应结构、错误码结构、Content-Type。
- 文档标记"已弃用"的接口必须拒绝使用并提醒用户。
- 未明确目标接口时先问："具体哪个项目、哪个接口（路径或接口 ID）？"

## 常用命令

```bash
yarn order                      # 启动 dev server
yarn lint                       # eslint
yarn build                      # stage 构建
yarn build:prod                 # 生产构建
yarn prettier                   # 格式化
```

环境变量文件：`packages/order-system/.env.development|.env.staging|.env.production`。
