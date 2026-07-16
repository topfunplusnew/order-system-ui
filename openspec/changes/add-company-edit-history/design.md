## Context
Customer and supplier management are separate Vue pages backed by the same company API. The backend now exposes a dedicated history endpoint and decides per record whether an edit reason is required.

## Goals / Non-Goals
- Goals: expose history in both pages, collect required reasons, and keep field mapping consistent with Apifox.
- Non-Goals: create history records from the frontend, change existing company forms, or refactor both pages into one management component.

## Decisions
- Add `getCompanyHistory(id, companyType)` to the existing company API module.
- Use one `CompanyEditHistoryDialog` component for the five-column history table.
- Keep edit orchestration in each page because their validation and submission paths already differ.
- Store the pending reason on the current form data as `editReason`; clear it on cancel and before every new edit so it cannot leak between records.
- Treat the later, complete requirement as authoritative: the table contains modified content, modifier, original content, modification time, and modification reason.

## Data Flow
1. The history action opens the shared dialog with the row ID and page company type.
2. The dialog calls `GET /system/company/history/{id}?companyType=...` and maps the response directly.
3. The edit action calls the existing company detail endpoint.
4. If `shouldTrackEditReason` is true, a required textarea prompt collects the reason before opening the form.
5. The existing update request submits `editReason`; the backend writes the history record automatically.

## Error Handling
- History request failures show an error and leave an empty table state.
- Missing company detail prevents the edit dialog from opening.
- Cancelling the reason prompt cancels editing and clears pending reason state.

## Verification
- Jest API and source-contract tests cover endpoint parameters, five-column mapping, and reason-gated editing.
- Targeted ESLint checks cover all changed JavaScript and Vue files.
- The staging build verifies Vue template compilation.

