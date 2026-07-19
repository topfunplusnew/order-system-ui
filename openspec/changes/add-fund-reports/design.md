## Context
The receive and payment reports have the same filters, response shape, table layout, pagination behavior, and export flow. Their only differences are the page title, the business-type column label, and the query/export endpoints.

## Goals / Non-Goals
- Goals: match the provided Excel column order, use the updated Apifox contracts, enforce the required date, and avoid duplicated page logic.
- Non-Goals: add frontend Excel generation, change backend response fields, or add new route/menu records managed by the backend.

## Decisions
- Implement one `FundReport` component configured by a `report-type` prop.
- Keep report metadata in `fundReportConfig.js` so labels, APIs, export paths, filenames, and column definitions are testable without mounting the component.
- Keep the two requested route files as thin wrappers so backend menu component paths remain stable.
- Send `date`, `selfAccountName`, `otherCompanyName`, `otherAccountName`, `pageNum`, and `pageSize` directly to the selected list API.
- Use the project's global `download` helper for backend-generated Excel files.
- Use the project's existing `right-toolbar`, print mixin, horizontal table scrolling, and pagination components.

## Data Flow
1. The wrapper selects `receive` or `payment`.
2. The shared component resolves its report configuration and initializes `date` to today.
3. Query and pagination calls validate `date`, then call the configured GET API.
4. The response `rows` and `total` populate the table and pagination.
5. Export validates `date`, then posts the same filters to the configured export endpoint.

## Error Handling
- A missing date shows an Element UI warning and prevents query/export requests.
- Failed list requests clear loading state through `finally` without replacing the existing global request error handling.
- Reset restores the required date to today, clears the other three filters, resets pagination, and reloads the report.

## Verification
- Jest covers API contracts, report configuration, wrapper selection, 20-column source mapping, and date guards.
- Targeted ESLint covers all changed JavaScript and Vue files.
- The staging build verifies Vue 2 template compilation and imports.
