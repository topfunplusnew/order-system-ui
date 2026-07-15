## 1. Route and Menu Entry
- [x] 1.1 Confirm whether menus/routes for these business pages are backend-managed through `/getRouters` or local route config.
- [x] 1.2 Add frontend component entry points for 已删除订单, 已删除调整单, 已删除收款, 已删除付款, 已删除冲抵款.
- [x] 1.3 Assign distinct route names/cache keys so normal pages and deleted pages do not share stale table state incorrectly.

## 2. Shared Readonly Deleted Mode
- [x] 2.1 Add a deleted/readonly mode flag to each reused page/component.
- [x] 2.2 Ensure list query params always include `queryNotDeleted: false` in deleted mode.
- [x] 2.3 Ensure search/reset pagination flows preserve `queryNotDeleted: false`.
- [x] 2.4 Update export params to include `queryNotDeleted: false` in deleted mode.
- [x] 2.5 Use deleted export filenames such as `已删除订单目录_*.xlsx`, `已删除付款信息_*.xlsx`.

## 3. Orders
- [x] 3.1 Implement 已删除订单 with `isAdjust: 0` and `queryNotDeleted: false`.
- [x] 3.2 Implement 已删除调整单 with `isAdjust: -1` and `queryNotDeleted: false`.
- [x] 3.3 Keep the row "查看" action available.
- [x] 3.4 Disable or hide edit, delete, audit, cancel audit, attachment update, invoice creation, adjustment creation and payment write actions.
- [x] 3.5 Add deleted-mode params to both `/system/goodsOrder/exportDirectory` and `/system/goodsOrder/export`.
- [x] 3.6 Rename or add operation metadata columns as `删除时间` and `删除人`.

## 4. Receive Money
- [x] 4.1 Implement 已删除收款 with `/system/receiveMoney/list` and `queryNotDeleted: false`.
- [x] 4.2 Disable or hide add, edit, delete, import and attachment update behavior.
- [x] 4.3 Keep search, reset, table viewing and export.
- [x] 4.4 Add `queryNotDeleted: false` to `/system/receiveMoney/export`.
- [x] 4.5 Rename existing `updateTime` / `updateByUserName` columns to `删除时间` / `删除人`.

## 5. Payment
- [x] 5.1 Implement 已删除付款 with `/system/payment/list` and `queryNotDeleted: false`.
- [x] 5.2 Disable or hide add, edit, delete, payment execution, import and attachment update behavior.
- [x] 5.3 Keep search, reset, table viewing, non-mutating related-info viewing and export.
- [x] 5.4 Add `queryNotDeleted: false` to `/system/payment/export`.
- [x] 5.5 Rename existing `updateTime` / `updateByUserName` columns to `删除时间` / `删除人`.

## 6. Offset Payment / Record
- [x] 6.1 Implement 已删除冲抵款 with `/system/record/list` and `queryNotDeleted: false`.
- [x] 6.2 Disable or hide add, edit, delete and attachment update behavior.
- [x] 6.3 Keep search, reset, table viewing and export.
- [x] 6.4 Add `queryNotDeleted: false` to `/system/record/export`.
- [x] 6.5 Rename existing `updateTime` / `updateByUserName` columns to `删除时间` / `删除人`.
- [x] 6.6 Display backend-returned account type fields (`selfBankCardType`, `otherBankCardType`) before using frontend-derived account type.

## 7. Validation
- [x] 7.1 Run targeted ESLint on changed Vue/API files with `--no-ignore` if needed.
- [x] 7.2 Run focused Jest tests if any shared query/export helper is introduced.
- [ ] 7.3 Manually smoke-test all five pages: search, reset, pagination, table columns, readonly actions and export param construction.
- [x] 7.4 Confirm no deleted page can trigger POST/PUT/DELETE business write APIs from the UI.
