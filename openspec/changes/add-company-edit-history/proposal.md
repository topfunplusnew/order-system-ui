# Change: Add customer and supplier edit history

## Why
Customer and supplier records currently support editing but do not expose their modification history, and edits that require a reason can be submitted without collecting one in the UI.

## What Changes
- Add a modification-history action to customer and supplier rows.
- Display company history from `GET /system/company/history/{id}` in a shared table dialog.
- Prompt for a required edit reason when company detail returns `shouldTrackEditReason: true`.
- Submit the collected reason as `editReason` with the existing company update request.

## Impact
- Affected capability: company information management
- Affected code: company API module, customer page, supplier page, shared company history dialog

