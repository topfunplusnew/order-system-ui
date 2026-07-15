## Context
This is a Vue 2 / RuoYi-Vue UI. The existing pages already contain most query, table, detail, attachment and export behavior. The deleted-data pages should therefore be a readonly mode of the existing pages/components, not a second independent implementation.

The requested page count is 5 while the requested list API count is 4. The practical mapping is:

| Page | Source UI | List API | Export API |
| --- | --- | --- | --- |
| 已删除订单 | `system/deletedInfo/order/index`, 订单列表, `isAdjust=0` | `/system/goodsOrder/list` | `/system/goodsOrder/exportDirectory`, `/system/goodsOrder/export` |
| 已删除调整单 | `system/deletedInfo/adjustOrder/index`, 订单列表, `isAdjust=-1` | `/system/goodsOrder/list` | `/system/goodsOrder/exportDirectory`, `/system/goodsOrder/export` |
| 已删除收款 | `system/deletedInfo/receiveMoney/index`, 收款信息 | `/system/receiveMoney/list` | `/system/receiveMoney/export` |
| 已删除付款 | `system/deletedInfo/payment/index`, 付款信息 | `/system/payment/list` | `/system/payment/export` |
| 已删除冲抵款 | `system/deletedInfo/cashRecord/index`, 冲抵款/现金记账 | `/system/record/list` | `/system/record/export` |

## Decisions
- Add a readonly deleted mode, for example `deletedMode` or `queryDeleted`, to the reusable page/component surface.
- In deleted mode, merge `queryNotDeleted: false` into list and export params at the last step before the request. This prevents reset/search code from accidentally dropping the flag.
- Keep normal pages unchanged by default. They continue omitting `queryNotDeleted` or using the backend default (`true`).
- For order pages, preserve the existing "查看" detail button and disable all write-related dropdown items and side actions. Do not call write APIs from deleted mode.
- For receive money, payment and record pages, either hide the operation column or leave only non-mutating actions such as attachment preview and view-related dialogs. Attachment update callbacks must be disabled in deleted mode.
- Use existing backend fields `updateTime` and `updateByUserName` for deleted page display unless backend provides dedicated delete fields. The UI label changes to `删除时间` and `删除人` because the deleted row examples return delete semantics through these fields.
- For record/冲抵款 account type, use backend-returned `selfBankCardType` and `otherBankCardType` in both original and deleted pages where available; only fall back to old derivation when the field is absent.

## Risks / Trade-offs
- Menu source may be backend-managed. If routes are generated from `/getRouters`, menu entries and permissions need backend/menu data changes in addition to local component work.
- Some file preview components expose update callbacks through `CheckFiles`. Deleted mode must avoid passing update handlers or must set the component to readonly if supported.
- Order has many write entry points beyond edit/delete: audit, cancel audit, upload attachments, invoice creation, adjustment relation actions and payment-related actions. Deleted mode needs a targeted audit of every button and event handler.
- Export filenames should clearly distinguish deleted exports to avoid operators mixing normal and deleted workbooks.

## Verification
- Search each changed page for write API imports and calls, then confirm deleted mode cannot trigger them.
- Verify list requests include `queryNotDeleted=false` after search and reset.
- Verify each export request includes `queryNotDeleted=false`.
- Verify visible columns show `删除时间` and `删除人`.
- Verify order deleted pages still open the existing readonly detail dialog from the "查看" action.
