## ADDED Requirements

### Requirement: Cash withdrawal ledger route

The system SHALL provide the order-system view component `salesReward/cashWithdrawalLedger/index` for the backend-driven menu entry.

#### Scenario: Dynamic menu resolves the page

- **WHEN** a menu route references `salesReward/cashWithdrawalLedger/index`
- **THEN** the order-system application loads the cash withdrawal ledger page from the `views` directory

### Requirement: Ledger list and filters

The page SHALL query the cash withdrawal ledger with pagination and flat filters for an inclusive withdrawal-date range, account information, handler name, purpose, and audit state.

#### Scenario: User searches by date range

- **WHEN** the user selects a start and end date and starts a search
- **THEN** the page submits `beginWithdrawalDate` and `endWithdrawalDate` as `yyyy-MM-dd` values without time components

#### Scenario: User filters text and audit state

- **WHEN** the user enters account, handler, or purpose text or selects an audit state
- **THEN** the page sends the documented flat controller query fields and resets pagination to the first page

### Requirement: Workbook-aligned ledger columns

The page SHALL display the workbook's ten business columns in order: withdrawal date, withdrawal amount, account information, withdrawal proof, handler, purpose, other attachment, audit state, auditor, and remark.

#### Scenario: List data is rendered

- **WHEN** ledger rows are returned
- **THEN** each row is rendered using the ten workbook-aligned business columns and an additional fixed operation column

### Requirement: Create and edit ledger records

The page SHALL create and edit ledger records using the documented business fields, a day-only withdrawal date, a manually entered account, and an amount greater than zero with at most 20 integer digits and 8 decimal digits.

#### Scenario: User creates a valid ledger

- **WHEN** the user completes all required fields and submits a valid amount
- **THEN** the page creates the record without sending audit or audit-user fields

#### Scenario: User enters an invalid amount

- **WHEN** the amount is zero, negative, non-decimal text, has more than 20 integer digits, or has more than 8 decimal digits
- **THEN** the page blocks submission and displays a validation message

#### Scenario: User edits an unaudited ledger

- **WHEN** the selected record is `未审核`
- **THEN** the page loads detail and submits the complete editable business fields to the update endpoint

### Requirement: Categorized attachments

The page SHALL display and edit `withdrawalProof` and `otherAttachment` attachments as separate groups while maintaining the backend's single complete attachment collection.

#### Scenario: User creates a record with attachments

- **WHEN** files have been uploaded in either attachment group before creation
- **THEN** the page merges their IDs into `params.attachmentIds` in the create request

#### Scenario: User edits attachments

- **WHEN** an unaudited record's retained attachment set changes
- **THEN** the page merges both groups and sends the full ID set to the attachment replacement endpoint after the main update succeeds

#### Scenario: User views audited attachments

- **WHEN** a record is `已审核`
- **THEN** the user can view or download its attachments but cannot upload, remove, or replace them

### Requirement: Audit-state enforcement

The page SHALL support audit and cancel-audit operations and SHALL freeze audited records from editing, attachment mutation, and deletion.

#### Scenario: User audits a record

- **WHEN** an authorized user confirms audit for an unaudited row
- **THEN** the page calls the audit endpoint with `approved=true` and refreshes the row with the returned state

#### Scenario: User cancels audit

- **WHEN** an authorized user confirms cancellation for an audited row
- **THEN** the page calls the audit endpoint with `approved=false` and restores edit, attachment, and delete controls after success

#### Scenario: Audit request fails

- **WHEN** the audit or cancel-audit request returns an error
- **THEN** the page restores the previous switch/action state and displays the backend message

### Requirement: Delete and export

The page SHALL delete one or more unaudited records and export all records matching the active non-pagination filters.

#### Scenario: User deletes selected records

- **WHEN** every selected row is unaudited and the user confirms deletion
- **THEN** the page sends comma-separated IDs to the delete endpoint and refreshes the list after success

#### Scenario: Selection contains an audited row

- **WHEN** the current selection includes an audited record
- **THEN** the page prevents batch deletion and explains that audit must first be cancelled

#### Scenario: User exports filtered data

- **WHEN** the user starts export
- **THEN** the page posts the active filters without pagination and downloads the returned XLSX blob

