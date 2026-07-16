# Company Edit History Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add customer and supplier modification history and enforce backend-directed edit reasons.

**Architecture:** Extend the company API, render history through one shared Element UI dialog, and integrate the reason gate into each existing page's edit flow. The backend remains the only writer of history records.

**Tech Stack:** Vue 2, Element UI, Axios request wrapper, Jest, ESLint

---

### Task 1: Company history API

**Files:**
- Modify: `packages/order-system/src/api/system/company.js`
- Test: `packages/order-system/src/api/system/company.history.test.js`

- [x] Write a test that calls `getCompanyHistory(12, '客户')` and expects `GET /system/company/history/12` with `{ companyType: '客户' }`.
- [x] Run the test and confirm it fails because the export is missing.
- [x] Add the API function using the existing request wrapper.
- [x] Run the test and confirm it passes.

### Task 2: Shared history dialog

**Files:**
- Create: `packages/order-system/src/views/dashboard/components/company/CompanyEditHistoryDialog.vue`
- Test: `packages/order-system/src/views/dashboard/components/company/CompanyEditHistoryDialog.test.js`

- [x] Write a source-contract test for the dialog title and the five Apifox field mappings.
- [x] Run the test and confirm the component is missing.
- [x] Implement a controlled dialog with `visible`, `companyId`, and `companyType` props, loading state, empty state, and request error handling.
- [x] Run the test and confirm it passes.

### Task 3: Customer and supplier integration

**Files:**
- Modify: `packages/order-system/src/views/system/company/index.vue`
- Modify: `packages/order-system/src/views/system/companygive/index.vue`
- Test: `packages/order-system/src/views/system/company/company-edit-history.test.js`

- [x] Write source-contract tests requiring a history action on both pages, the shared dialog, `shouldTrackEditReason`, and `editReason` submission.
- [x] Run the tests and confirm they fail on the missing integration.
- [x] Add page state and methods to open the shared history dialog with the correct company type.
- [x] Change each edit handler to clear stale reason state, fetch detail, prompt when required, and open the existing form.
- [x] Preserve `editReason` in update payloads and clear it on cancel or successful update.
- [x] Run the tests and confirm they pass.

### Task 4: Verification

**Files:**
- Verify all files listed above.

- [x] Run focused Jest tests with `--runInBand --coverage=false` and require zero failures.
- [x] Run root ESLint with `--no-ignore` against changed source and test files and require zero errors attributable to the change.
- [x] Run `npm run build:stage` from `packages/order-system` and require exit code 0.
- [x] Run `git diff --check` and inspect `git status --short` to preserve unrelated changes.
