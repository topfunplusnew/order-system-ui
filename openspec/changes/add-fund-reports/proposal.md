# Change: Add receive and payment reports

## Why
Finance users need dedicated receive and payment statement pages that match the provided Excel reports and support backend filtering, pagination, and Excel export.

## What Changes
- Add receive and payment report route components under `system/Statement`.
- Share the search, table, pagination, print, and export behavior through one internal report component.
- Add API functions for `GET /statistics/receiveReport` and `GET /statistics/paymentReport`.
- Require a report date for querying, resetting, and exporting.
- Display the 20 Excel columns in the confirmed order.

## Impact
- Affected capability: finance statements
- Affected code: statement API module and Statement views
