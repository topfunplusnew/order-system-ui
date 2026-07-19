# Receive And Payment Reports Implementation Plan

**Goal:** Add two finance report pages backed by the updated statistics list and export endpoints.

**Architecture:** Two thin route wrappers select a report configuration consumed by one shared Vue 2 component. A standalone configuration module owns labels, endpoints, API functions, filenames, and table columns.

**Tech Stack:** Vue 2, Element UI, Axios request wrapper, Jest, ESLint

### Task 1: Contract tests

- [x] Test the exact receive and payment GET request contracts.
- [x] Test both report configurations and the complete ordered field list.
- [x] Test that both route wrappers select the correct report type.
- [x] Test the shared component source for required-date guards, list/export behavior, pagination, and all 20 displayed columns.
- [x] Run focused Jest and confirm failures are caused by missing implementation.

### Task 2: API and configuration

- [x] Add `getReceiveReport` and `getPaymentReport` to the statement API module.
- [x] Add report metadata and ordered column definitions to `fundReportConfig.js`.
- [x] Run focused tests and confirm API/config tests pass.

### Task 3: Shared report component and wrappers

- [x] Implement the compact four-field search form with required date validation.
- [x] Implement toolbar, print, export, horizontal table, amount formatting, pagination, and loading state.
- [x] Implement reset behavior that restores today's date before querying.
- [x] Create receive and payment wrappers at the exact requested paths.
- [x] Run all focused tests and confirm they pass.

### Task 4: Verification

- [x] Run targeted ESLint against changed source and test files.
- [x] Run the order-system staging build.
- [x] Run `git diff --check` and inspect `git status --short` for unrelated changes.
- [x] Mark OpenSpec and implementation checklists complete only after the evidence is green.
