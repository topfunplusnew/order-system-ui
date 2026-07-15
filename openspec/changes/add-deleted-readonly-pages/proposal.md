# Change: Add deleted-data readonly query pages

## Why
当前订单、收款、付款、冲抵款的逻辑删除数据只能通过正常页面反向参数查询，前端缺少独立的只读入口，不便于业务人员查看、搜索和导出已经删除的信息。

## What Changes
- 新增 5 个只读页面：已删除订单、已删除调整单、已删除收款、已删除付款、已删除冲抵款。
- 5 个页面复用对应原页面的查询字段、表格字段和导出能力，但固定查询已删除数据。
- 4 个列表接口统一传 `queryNotDeleted: false`：`/system/goodsOrder/list`、`/system/receiveMoney/list`、`/system/payment/list`、`/system/record/list`。
- 5 个导出入口统一传 `queryNotDeleted: false`：`/system/goodsOrder/exportDirectory`、`/system/goodsOrder/export`、`/system/receiveMoney/export`、`/system/payment/export`、`/system/record/export`。
- 已删除页面禁用新增、修改、删除、导入、审核、取消审核、付款、附件变更、开票等写操作；订单页面保留“查看”按钮。
- 将已删除页面上的“最后修改时间/最后修改人”语义改成“删除时间/删除人”，没有对应列的页面补齐。
- 冲抵款页面优先展示后端返回的账户类型字段，避免已删除实体缺少资金变动导致前端推导失败。

## Impact
- Affected specs: `deleted-readonly-pages`
- Affected code:
  - `packages/order-system/src/views/dashboard/components/goodsOrder/ElTableOrder.vue`
  - `packages/order-system/src/views/system/receiveMoney/index.vue`
  - `packages/order-system/src/views/system/payment/index.vue`
  - `packages/order-system/src/views/system/record/index.vue`
  - `packages/order-system/src/api/system/goodsOrder.js`
  - `packages/order-system/src/api/system/receiveMoney.js`
  - `packages/order-system/src/api/system/payment.js`
  - `packages/order-system/src/api/system/record.js`
  - router/menu permission configuration, depending on whether this project stores routes in backend menu data or local route metadata

## API Notes From Apifox MCP
- Apifox OpenAPI was refreshed before analysis.
- `queryNotDeleted` semantics in Apifox: missing or `true` means normal non-deleted data; `false` means logically deleted data.
- `/system/goodsOrder/export` explicitly documents deleted export support, including deleted order details and deleted invoice-derived columns.
- `/system/goodsOrder/exportDirectory` explicitly documents deleted order-directory export support.
- `/system/payment/list` and `/system/record/list` include `queryNotDeleted` as a boolean query parameter.
- `/system/receiveMoney/list` examples include deleted rows when `queryNotDeleted=false`; export follows the same requested flag.
