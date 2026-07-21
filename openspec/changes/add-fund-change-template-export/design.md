## Context
All fourteen templates expose the same core shape: computed `columns`, processed `tableData`, `diffSummaryTableData`, `summaryModuleLabel`, and `summaryOnly`. Their business mapping differs, but export mechanics do not.

## Decisions
- Keep XLSX generation in a shared utility and rendering in a shared `FundChangeExportButton` component.
- Each template passes its existing columns and processed rows to the shared button.
- The detail sheet contains module, backup date, change state, and every visible business column.
- The summary sheet contains the existing backend summary label/value rows.
- When `summaryOnly` is true, omit the detail sheet and export only summary rows.
- Use client-side XLSX generation because the export source is already computed frontend data and no matching backend endpoint exists.

## Error Handling
- Disable the button when neither detail nor summary rows exist.
- Catch workbook generation failures and show an Element UI error message.
- Normalize invalid worksheet names and filenames.

## Verification
- Unit tests cover workbook data construction, filenames, summary-only behavior, and empty data.
- Source-contract tests ensure all fourteen templates import and render the shared export button.
- Targeted ESLint and the staging build verify Vue 2 compilation.
