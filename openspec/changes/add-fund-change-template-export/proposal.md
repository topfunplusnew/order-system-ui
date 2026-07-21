# Change: Add exports to all fund change templates

## Why
The fourteen fund change detail templates can display before, after, difference, and backend summary data, but users cannot export the displayed tables for reconciliation or archiving.

## What Changes
- Add one shared XLSX export utility for fund change templates.
- Add one shared export button component.
- Integrate the export button into all fourteen templates.
- Export detail rows and difference summaries as separate workbook sheets.
- Disable export when the current template has no exportable rows.

## Impact
- Affected capability: fund change detail templates
- Affected code: `packages/ui-components/components/FundChangeTemplates`
