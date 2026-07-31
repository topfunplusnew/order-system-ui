# Change: Add cash withdrawal ledger page

## Why

The backend and the original cash-withdrawal register template are ready, but the frontend does not yet provide the `销售部奖励制度 / 转 、支现金台账` page needed to query, maintain, audit, attach evidence to, and export these records.

## What Changes

- Add the menu component entry `salesReward/cashWithdrawalLedger/index`, resolved under the order-system `views` directory.
- Add API bindings for the cash-withdrawal-ledger list, detail, create, update, attachment replacement, delete, audit, cancel-audit, and export endpoints.
- Reproduce the original Excel register's ten business columns in the page table and export workflow.
- Use day-only date selection and submit `yyyy-MM-dd` values without time components.
- Keep account information as a manually entered text field without bank-account selection or fund-flow linkage.
- Reuse the vehicle-dispatch attachment and audit interaction patterns while supporting separate `withdrawalProof` and `otherAttachment` attachment groups.
- Freeze editing, attachment mutation, and deletion for audited records until audit is cancelled.
- Add focused tests for API contracts, amount validation, request payloads, attachment grouping/replacement, audit parameters, export filtering, and page source contracts.

## Impact

- Affected capability: cash withdrawal ledger management
- Affected code: order-system sales-reward views, API modules, and focused Jest tests
- Backend impact: none
- Menu impact: the backend menu component should point to `salesReward/cashWithdrawalLedger/index`

