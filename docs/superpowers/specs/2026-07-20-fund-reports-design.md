# Receive And Payment Reports Design

## Scope

Add `system/Statement/receiveReport.vue` and `system/Statement/paymentReport.vue`. Both route components render one shared finance report component and differ only by report type.

## Search And Actions

- Required date, defaulting to today.
- Optional self account name, other company name, and other account name.
- Query, reset, export, column visibility, print, and pagination follow existing Statement page behavior.
- Query and export stop before any request when the date is empty.
- Reset restores today's date, clears optional filters, and queries page one.

## Endpoints

- Receive list: `GET /statistics/receiveReport`
- Payment list: `GET /statistics/paymentReport`
- Receive export: `POST /statistics/export/receiveReport`
- Payment export: `POST /statistics/export/paymentReport`

## Columns

The shared table displays: sequence, source, date, income/payment type, other company name, other company type, amount, self account name, self account number, self bank, self account type, other account name, other account number, other bank, comments, bank flow number, creator, created time, last modified time, and last modifier.

## Component Boundaries

- `fundReportConfig.js`: immutable report metadata and the 19 backend-field column definitions.
- `components/FundReport.vue`: form state, validation, request flow, toolbar, 20-column table, pagination, print, and export.
- `receiveReport.vue` and `paymentReport.vue`: stable route entry points that only select the report type.

## Verification

Use focused Jest source/API contract tests, targeted ESLint, a staging build, and whitespace/diff checks. Existing unrelated worktree changes remain untouched.
