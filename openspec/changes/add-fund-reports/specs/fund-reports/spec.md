## ADDED Requirements

### Requirement: Receive and payment report pages
The system SHALL provide receive and payment report pages that share the same reporting behavior while using their corresponding backend endpoints.

#### Scenario: Query receive report
- **WHEN** a user opens or searches the receive report with a valid date
- **THEN** the frontend requests `GET /statistics/receiveReport`
- **AND** displays the paged response using the confirmed 20-column receive-report layout

#### Scenario: Query payment report
- **WHEN** a user opens or searches the payment report with a valid date
- **THEN** the frontend requests `GET /statistics/paymentReport`
- **AND** displays the paged response using the confirmed 20-column payment-report layout

### Requirement: Required report date
The system SHALL require a date before querying or exporting either report.

#### Scenario: Date is missing
- **WHEN** a user attempts to query or export without a date
- **THEN** the frontend shows a warning
- **AND** does not call the corresponding backend endpoint

#### Scenario: Reset report filters
- **WHEN** a user resets report filters
- **THEN** the frontend restores the date to today
- **AND** clears the three account/company text filters
- **AND** reloads page one

### Requirement: Backend Excel export
The system SHALL export each report through its dedicated backend export endpoint using the active filters.

#### Scenario: Export receive report
- **WHEN** a user exports the receive report with a valid date
- **THEN** the frontend posts the active filters to `/statistics/export/receiveReport`

#### Scenario: Export payment report
- **WHEN** a user exports the payment report with a valid date
- **THEN** the frontend posts the active filters to `/statistics/export/paymentReport`
