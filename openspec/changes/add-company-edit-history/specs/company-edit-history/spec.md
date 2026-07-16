## ADDED Requirements

### Requirement: Company modification history
The system SHALL allow users to view customer and supplier modification history from the corresponding row action.

#### Scenario: View customer history
- **WHEN** a user clicks the modification-history action on a customer row
- **THEN** the frontend requests `/system/company/history/{id}` with `companyType=客户`
- **AND** displays modified content, modifier, original content, modification time, and modification reason

#### Scenario: View supplier history
- **WHEN** a user clicks the modification-history action on a supplier row
- **THEN** the frontend requests `/system/company/history/{id}` with `companyType=供应商`
- **AND** displays the returned records newest first as provided by the backend

### Requirement: Required company edit reason
The system SHALL collect and submit an edit reason when the company detail response sets `shouldTrackEditReason` to true.

#### Scenario: Reason is required
- **WHEN** a user starts editing a company whose detail has `shouldTrackEditReason: true`
- **THEN** the frontend requires a non-empty reason before opening the edit form
- **AND** sends that reason in the existing update request as `editReason`

#### Scenario: Reason is not required
- **WHEN** a user starts editing a company whose detail does not set `shouldTrackEditReason` to true
- **THEN** the frontend opens the edit form without prompting for a reason

