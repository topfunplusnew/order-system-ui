## ADDED Requirements

### Requirement: Export fund change template data
The system SHALL allow users to export the currently displayed data from every fund change template.

#### Scenario: Export detail and summary data
- **WHEN** a template contains detail rows and summary rows
- **THEN** the exported XLSX workbook contains a detail sheet and a difference-summary sheet
- **AND** the detail sheet preserves the template's current business column order

#### Scenario: Export summary-only data
- **WHEN** a template is rendered in summary-only mode
- **THEN** the workbook contains only the difference-summary sheet

#### Scenario: No exportable data
- **WHEN** a template has neither detail rows nor summary rows
- **THEN** the export action is disabled
