# Oil Card Ledger Pages Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create main-card and sub-card oil ledger pages that share CRUD, filtering, selection, deletion, and export behavior while preserving their documented field and permission differences.

**Architecture:** Add one request module and one framework-independent configuration helper, then render both menu entries through a shared Vue 2 component. The two entry files provide only the fixed card type, page title, and permission namespace, while the shared component owns API data flow and UI behavior.

**Tech Stack:** Vue 2.6, Element UI, RuoYi request/download helpers, Jest 29, ESLint.

---

### Task 1: Oil card ledger API

**Files:**
- Create: `packages/order-system/src/api/system/oilCardLedger.test.js`
- Create: `packages/order-system/src/api/system/oilCardLedger.js`

- [x] **Step 1: Write the failing API test**

Test `listOilCardLedger`, `getOilCardLedger`, `addOilCardLedger`, `updateOilCardLedger`, and `delOilCardLedger` against their exact URL, method, params, and data contracts using a mocked `@/utils/request`.

- [x] **Step 2: Run the API test and verify RED**

Run: `npx jest src/api/system/oilCardLedger.test.js --runInBand --coverage=false`

Expected: FAIL because `./oilCardLedger` does not exist.

- [x] **Step 3: Implement the request module**

Export the five CRUD functions using `/system/oilCardLedger/list`, `/system/oilCardLedger/{id}`, and `/system/oilCardLedger`.

- [x] **Step 4: Run the API test and verify GREEN**

Run the same Jest command and expect all API assertions to pass.

### Task 2: Shared configuration and payload rules

**Files:**
- Create: `packages/order-system/src/views/system/components/oilCardLedger.config.test.js`
- Create: `packages/order-system/src/views/system/components/oilCardLedger.config.js`

- [x] **Step 1: Write failing configuration tests**

Cover `buildLedgerColumns`, `buildLedgerQuery`, `buildLedgerExportParams`, `buildLedgerPayload`, and `serializeLedgerIds`. Assert exact main/sub labels, fixed card type, removal of pagination for export, request whitelist behavior, omission of sub-card `rechargeAmount`, and comma-separated IDs.

- [x] **Step 2: Run configuration tests and verify RED**

Run: `npx jest src/views/system/components/oilCardLedger.config.test.js --runInBand --coverage=false`

Expected: FAIL because the configuration module does not exist.

- [x] **Step 3: Implement the pure helpers**

Define the shared base columns, insert the main-card recharge column only for `主卡`, map nested oil-card and vehicle fields, whitelist the documented form fields, and normalize query/export/delete arguments.

- [x] **Step 4: Run configuration tests and verify GREEN**

Run the same Jest command and expect all helper assertions to pass.

### Task 3: Shared Vue page and menu entries

**Files:**
- Create: `packages/order-system/src/views/system/oilCardLedger.pages.test.js`
- Create: `packages/order-system/src/views/system/components/OilCardLedgerPage.vue`
- Create: `packages/order-system/src/views/system/oilCardLedgerMain/index.vue`
- Create: `packages/order-system/src/views/system/oilCardLedgerSub/index.vue`

- [x] **Step 1: Write failing source-contract tests**

Read the three Vue sources and assert that the entry components pass `主卡`/`副卡` and their exact permission prefixes, and that the shared component contains fixed-card queries, filtered oil-card loading, optional vehicle loading, detail-backed edit, whitelist payload construction, deletion serialization, and filtered export.

- [x] **Step 2: Run page tests and verify RED**

Run: `npx jest src/views/system/oilCardLedger.pages.test.js --runInBand --coverage=false`

Expected: FAIL because the page files do not exist.

- [x] **Step 3: Implement the shared page**

Build an Element UI search form, dynamic column table, selection toolbar, pagination, create/edit dialog, oil-card and vehicle selects, validation, CRUD methods, and export handler. Use `response.rows`, `response.total`, and `response.data`, and protect save from duplicate submission.

- [x] **Step 4: Implement both entry components**

Render `OilCardLedgerPage` with fixed card type, title, permission prefix, and a stable toolbar table name for each menu path.

- [x] **Step 5: Run page tests and verify GREEN**

Run the same Jest command and expect all source-contract assertions to pass.

### Task 4: Verification and OpenSpec completion

**Files:**
- Modify: `openspec/changes/add-oil-card-ledger-pages/tasks.md`

- [x] **Step 1: Run all focused tests**

Run the three Jest test files together with `--runInBand --coverage=false` and expect zero failures.

- [x] **Step 2: Run targeted ESLint**

Run the local ESLint binary with `--no-ignore` against all new JS and Vue files and expect zero errors.

- [x] **Step 3: Run the staging build**

Run the package staging build using the available local runtime and expect exit code 0.

- [x] **Step 4: Inspect requirements and diff**

Confirm every new code file starts with a comment recording the user requirement and actual change, inspect `git diff --check`, and verify no unrelated files changed.

- [x] **Step 5: Mark the OpenSpec checklist complete**

Change all completed task checkboxes in `openspec/changes/add-oil-card-ledger-pages/tasks.md` to `[x]` only after the corresponding evidence exists.
