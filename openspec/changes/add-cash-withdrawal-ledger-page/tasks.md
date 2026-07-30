## 1. API and business helpers

- [x] 1.1 Add failing tests for every cash-withdrawal-ledger API URL, method, query/body placement, audit boolean, and blob export response.
- [x] 1.2 Add the dedicated cash-withdrawal-ledger API module.
- [x] 1.3 Add failing tests for day-range mapping, export-filter construction, decimal validation, form payload whitelisting, attachment grouping, and merged attachment ID serialization.
- [x] 1.4 Add the tested business helpers used by the page.

## 2. Page implementation

- [x] 2.1 Add a failing source-contract test for the requested route component, permissions, ten workbook columns, day-only pickers, manual account input, two attachment flags, frozen audited rows, and audit/export wiring.
- [x] 2.2 Add `views/salesReward/cashWithdrawalLedger/index.vue` with query, pagination, column controls, CRUD dialogs, attachment groups, audit/cancel-audit, and export.
- [x] 2.3 Ensure every new or modified code file starts with a comment that records the user requirement and the actual implementation.

## 3. Verification

- [x] 3.1 Run the focused Jest tests and confirm the red-green cycle.
- [x] 3.2 Run targeted ESLint checks for all touched code files.
- [x] 3.3 Run `git diff --check`.
- [x] 3.4 Run the order-system staging build and inspect the final diff without changing unrelated user work.
