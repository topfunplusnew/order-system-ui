# 油卡登记台账页面设计

## 背景

后端提供一套 `/system/oilCardLedger/*` 接口，通过 `cardType` 区分主卡和副卡数据。前端需要创建 `system/oilCardLedgerMain/index` 与 `system/oilCardLedgerSub/index` 两个菜单组件，并保持两个页面的权限、列名、表单字段和油卡选择范围彼此独立。

## 目标

- 创建主卡登记与副卡登记两个页面入口。
- 复用一个共享台账组件，避免列表、表单和接口逻辑重复。
- 完成列表、详情、新增、修改、删除、批量删除和导出功能。
- 严格区分主卡与副卡的列名、充值金额字段和权限标识。
- 所有请求只提交后端允许的业务字段，不回传实体公共字段或关联对象。

## 非目标

- 不修改后端接口、数据库或菜单路由数据。
- 不重构已有油卡管理、油卡充值或车辆管理页面。
- 不新增附件、审批或自动结算能力。

## 页面与组件结构

### 页面入口

- `packages/order-system/src/views/system/oilCardLedgerMain/index.vue`
  - 固定卡类型为 `主卡`。
  - 权限前缀为 `system:oilcardledgermain`。
- `packages/order-system/src/views/system/oilCardLedgerSub/index.vue`
  - 固定卡类型为 `副卡`。
  - 权限前缀为 `system:oilcardledgersub`。

两个入口只负责传入卡类型、页面标题、权限前缀和主副卡展示配置。

### 共享组件

创建 `packages/order-system/src/views/system/components/OilCardLedgerPage.vue`，负责：

- 查询表单与分页。
- 主副卡差异化表格列。
- 新增和修改弹窗。
- 油卡与车辆下拉加载。
- 删除、批量删除和导出。
- 接口异常提示与加载状态。

### 纯逻辑配置

创建 `oilCardLedger.config.js`，集中维护：

- 主副卡表格列定义及显示标签。
- 查询参数构造。
- 新增/修改请求字段白名单。
- 副卡提交时移除 `rechargeAmount`。
- 删除 ID 的逗号拼接。

该文件不依赖 Vue，可使用 Jest 做行为测试。

## 数据流

### 查询

页面初始化和分页变化时请求：

```text
GET /system/oilCardLedger/list
```

请求固定包含当前页面的 `cardType`，并支持：

- `params[oilCardNo]`
- `params[licensePlate]`
- `params[beginTime]`
- `params[endTime]`
- `hasReceipt`
- `locationReason`
- `pageNum`
- `pageSize`

### 下拉数据

- 油卡：`GET /system/oilCard/list?oilType=主卡|副卡`，提交 `id`，展示 `oilCardNo`。
- 车辆：`GET /system/vehicles/list`，提交 `id`，展示 `licensePlate`；允许清空。

### 新增与修改

新增调用 `POST /system/oilCardLedger`，修改调用 `PUT /system/oilCardLedger`。

请求白名单：

- `id`，仅修改时提交。
- `oilCardId`
- `useDate`
- `vehicleId`
- `locationReason`
- `rechargeAmount`，仅主卡提交。
- `openingBalance`
- `transferAmount`
- `refuelingVolume`
- `unitPrice`
- `refuelingAmount`
- `hasReceipt`
- `closingBalance`
- `comments`

前端不提交 `cardType`、用户字段、审计字段、删除标记和关联对象。

### 删除

单条或批量 ID 统一转换为逗号分隔路径参数：

```text
DELETE /system/oilCardLedger/1,2,3
```

### 导出

导出调用 `POST /system/oilCardLedger/export`，携带当前全部查询条件以及固定 `cardType`，不携带分页参数。

## 主副卡差异

主卡展示 `rechargeAmount`，标签为“充值金额”；副卡不渲染该字段，提交前也必须删除该属性。

`transferAmount`：

- 主卡标签：“主卡转副卡充值金额”
- 副卡标签：“主卡转副卡圈存金额”

`refuelingAmount`：

- 主卡标签：“金额(元）”
- 副卡标签：“加油金额(元）”

## 校验与错误处理

- `oilCardId`、`useDate` 必填。
- `locationReason` 最长 255 字符。
- `comments` 最长 500 字符。
- `hasReceipt` 仅允许“是”或“否”。
- 金额、单价和加油量字段使用非负数输入。
- 请求失败沿用项目统一 Axios/Element UI 错误处理。
- 表单保存期间禁用重复提交。

## 测试与验证

Jest 源码契约测试覆盖：

- API 方法、HTTP 方法和路径。
- 主副卡列定义与差异标签。
- 查询和导出固定携带 `cardType`。
- 导出移除分页参数。
- 请求体字段白名单。
- 副卡移除 `rechargeAmount`。
- 批量删除 ID 拼接。
- 两个入口的卡类型与权限配置。

完成后执行目标 Jest、目标 ESLint 和 staging 构建。

## 风险与处理

- Apifox 响应模型使用通用 `AjaxResult`，列表按 RuoYi 标准的 `rows`、`total` 解析；详情兼容 `response.data`。
- 油卡和车辆数据量可能超过默认分页，下拉请求使用较大的 `pageSize`，但不改变后端接口。
- 菜单路由由后端下发，本次只保证两个指定组件路径存在，不修改后端菜单数据。
