## ADDED Requirements

### Requirement: Separate main-card and sub-card ledger pages

The frontend SHALL provide component paths `system/oilCardLedgerMain/index` and `system/oilCardLedgerSub/index`, and each page SHALL use its own permission prefix and fixed card type.

#### Scenario: Open main-card ledger

- **WHEN** the main-card ledger component is rendered
- **THEN** its queries and exports use `cardType=主卡`
- **AND** its actions use the `system:oilcardledgermain:*` permission namespace

#### Scenario: Open sub-card ledger

- **WHEN** the sub-card ledger component is rendered
- **THEN** its queries and exports use `cardType=副卡`
- **AND** its actions use the `system:oilcardledgersub:*` permission namespace

### Requirement: Oil card ledger CRUD operations

The frontend SHALL support paginated list queries, record creation, detail-backed editing, single and batch deletion, and filtered export through `/system/oilCardLedger/*`.

#### Scenario: Query ledger records

- **WHEN** a user searches or changes pages
- **THEN** the frontend requests `/system/oilCardLedger/list` with the fixed card type, pagination, and entered filters

#### Scenario: Save a ledger record

- **WHEN** a valid create or edit form is submitted
- **THEN** the frontend sends only the supported business fields to the matching POST or PUT endpoint

#### Scenario: Delete selected ledger records

- **WHEN** a user confirms deletion of one or more records
- **THEN** the frontend sends the selected IDs as a comma-separated path parameter

#### Scenario: Export filtered ledger records

- **WHEN** a user exports the current result set
- **THEN** the frontend sends the current filters and fixed card type without pagination parameters

### Requirement: Main-card and sub-card field differences

The frontend SHALL render the documented column and form differences for main-card and sub-card ledgers.

#### Scenario: Render main-card fields

- **WHEN** the shared page is configured for a main card
- **THEN** it displays and submits `rechargeAmount`
- **AND** uses the main-card labels for transfer and refueling amounts

#### Scenario: Render sub-card fields

- **WHEN** the shared page is configured for a sub card
- **THEN** it does not render or submit `rechargeAmount`
- **AND** uses the sub-card labels for transfer and refueling amounts

### Requirement: Related oil-card and vehicle selection

The frontend SHALL load oil cards filtered by the page card type and SHALL allow an optional company vehicle selection.

#### Scenario: Select an oil card

- **WHEN** the ledger form is opened
- **THEN** the oil-card options contain only cards whose `oilType` matches the current page

#### Scenario: Clear a vehicle

- **WHEN** a user clears the vehicle selection while editing
- **THEN** the frontend submits `vehicleId` as null
