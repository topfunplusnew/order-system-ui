## Context

The source workbook `todo/转 、支现金台账.xlsx` contains a title row and ten fixed columns: withdrawal date, amount, account name plus last five account digits, withdrawal proof, handler, purpose, other attachment, audit state, auditor, and remark. The backend contract is documented in `todo/转 、支现金台账前端对接说明.md` and confirmed against the latest Apifox definitions for `转 、支现金台账Controller`.

The page belongs to the existing Vue 2 + Element UI order-system package. The vehicle-dispatch page already establishes the local conventions for attachment display/upload and audit-state interaction.

## Goals / Non-Goals

- Goals:
  - Provide complete list, query, create, edit, delete, audit, cancel-audit, attachment, and export behavior.
  - Match the backend's field names, permission strings, status values, and attachment flags exactly.
  - Preserve the workbook's business-column order while keeping row actions in an additional fixed operation column.
  - Prevent invalid mutations of audited rows in the UI and still rely on backend validation as the authority.
- Non-Goals:
  - Do not add or query bank-account selectors.
  - Do not generate account flows or financial mutations.
  - Do not add backend menus, permissions, schemas, or API behavior.
  - Do not modify the provided workbook.

## Decisions

- Decision: create `packages/order-system/src/views/salesReward/cashWithdrawalLedger/index.vue` as the requested route component.
  - Rationale: this is the exact component path expected by the dynamic RuoYi menu resolver.
- Decision: create a dedicated `packages/order-system/src/api/salesReward/cashWithdrawalLedger.js` module.
  - Rationale: the controller has distinct permissions and attachment/audit contracts and should not be mixed into the existing generic sales-reward API.
- Decision: use an Element UI `daterange` query control with `value-format="yyyy-MM-dd"`, mapped to flat `beginWithdrawalDate` and `endWithdrawalDate` query fields; use a day-only date picker in the form.
  - Rationale: Apifox requires inclusive day-only boundaries and forbids time components.
- Decision: use plain text inputs for `accountInfo` and `handlerName`.
  - Rationale: the backend explicitly does not link these fields to bank-account or user records.
- Decision: model `withdrawalProof` and `otherAttachment` as two visible attachment groups, backed by the shared upload/check components used by vehicle dispatch.
  - Rationale: the backend stores one `attachmentList`, but grouping by exact `flag` is required by the workbook and export contract.
- Decision: create uploads before the main create request; on create, submit their IDs in `params.attachmentIds`. On edit, update the main record first and then replace the complete merged attachment ID set through `/attachments`.
  - Rationale: this is the sequence required by the controller contract. The edit endpoint itself rejects attachment updates.
- Decision: use a decimal-text validator before converting/submitting the amount, accepting only values greater than zero with at most 20 integer digits and 8 decimal digits.
  - Rationale: JavaScript floating-point arithmetic must not be used to transform financial values, while the backend column is `DECIMAL(28,8)`.
- Decision: render an audit switch/action only for users with audit permission, call `approved=true` or `approved=false`, and restore the previous UI state if the request fails.
  - Rationale: this follows the vehicle-dispatch interaction while matching the new controller signature.
- Decision: disable edit, attachment mutation, and delete for `已审核` rows, while keeping attachment viewing/downloading available.
  - Rationale: audited records are fully frozen by the backend contract.
- Decision: export with the active non-pagination filters and `responseType: 'blob'`.
  - Rationale: the export endpoint returns the workbook stream rather than a standard JSON response.

## Risks / Trade-offs

- Shared attachment components may eagerly delete attachment records rather than only updating relationships.
  - Mitigation: inspect their emitted values and use the controller's complete-replacement endpoint; audited rows receive view-only configuration.
- A create upload can become orphaned if the subsequent create request fails.
  - Mitigation: surface the backend error and retain the dialog state so the user can retry; do not introduce undocumented destructive cleanup.
- Updating the main record can succeed while attachment replacement fails.
  - Mitigation: report the attachment-specific failure, keep the dialog open, and reload detail so the user sees the persisted main fields and current attachment relationship.
- Existing uncommitted changes are present in `packages/order-system/vue.config.js` and the two source files under `todo/`.
  - Mitigation: do not modify or revert those files.

## Verification

- Focused Jest tests demonstrate API methods/URLs, flat date filters, payload whitelisting, decimal validation, attachment flag grouping, complete attachment ID merging, audit booleans, export filter stripping, and page source contracts.
- Targeted ESLint runs against every new or modified JavaScript/Vue file.
- `git diff --check` confirms no whitespace errors.
- The order-system staging build confirms Vue 2 template compilation and module resolution.

