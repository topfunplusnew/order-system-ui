## 1. API and shared history dialog
- [x] 1.1 Add failing tests for the company history endpoint and five-column dialog mapping.
- [x] 1.2 Add `getCompanyHistory` to the company API module.
- [x] 1.3 Add the shared `CompanyEditHistoryDialog` component.

## 2. Customer and supplier edit flow
- [x] 2.1 Add failing source-contract tests for both operation actions and reason-gated editing.
- [x] 2.2 Add the history action and shared dialog to both pages.
- [x] 2.3 Prompt when `shouldTrackEditReason` is true and submit `editReason` with updates.
- [x] 2.4 Clear pending reasons on cancellation, new edits, and successful submission.

## 3. Verification
- [x] 3.1 Run focused Jest tests.
- [x] 3.2 Run targeted ESLint checks.
- [x] 3.3 Run the staging build and inspect the final diff.
