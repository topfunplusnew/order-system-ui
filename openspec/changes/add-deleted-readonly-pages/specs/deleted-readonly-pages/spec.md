## ADDED Requirements

### Requirement: Deleted Business Pages
The system SHALL provide five readonly pages for logically deleted business data: 已删除订单, 已删除调整单, 已删除收款, 已删除付款, and 已删除冲抵款.

#### Scenario: User opens a deleted page
- **WHEN** a user opens any deleted business page
- **THEN** the page queries the corresponding list API with `queryNotDeleted=false`
- **AND** displays only logically deleted rows returned by the backend.

### Requirement: Deleted Page Search
Deleted pages SHALL keep the same practical search fields as their corresponding original pages while preserving deleted-data filtering.

#### Scenario: User searches deleted rows
- **WHEN** a user changes search fields and submits the search
- **THEN** the request includes the user's filters
- **AND** the request still includes `queryNotDeleted=false`.

#### Scenario: User resets search
- **WHEN** a user resets filters on a deleted page
- **THEN** regular filters are cleared
- **AND** subsequent list requests still include `queryNotDeleted=false`.

### Requirement: Deleted Page Readonly Controls
Deleted pages SHALL disable or hide write operations.

#### Scenario: User views deleted receive money, payment or offset payment
- **WHEN** the deleted receive money, payment or offset payment page is rendered
- **THEN** add, edit, delete, import, payment execution, attachment update and other write controls are unavailable.

#### Scenario: User views deleted order pages
- **WHEN** a deleted order or deleted adjustment row is rendered
- **THEN** the row detail "查看" action is available
- **AND** edit, delete, audit, cancel audit, attachment update, invoice creation, adjustment creation and payment write actions are unavailable.

### Requirement: Deleted Page Export
Deleted pages SHALL support export using the existing export endpoints with deleted-data filtering.

#### Scenario: User exports deleted order directory
- **WHEN** a user exports the deleted order directory or deleted adjustment directory
- **THEN** the frontend calls `/system/goodsOrder/exportDirectory`
- **AND** includes `queryNotDeleted=false`.

#### Scenario: User exports deleted order detail list
- **WHEN** a user exports the deleted order list or deleted adjustment list
- **THEN** the frontend calls `/system/goodsOrder/export`
- **AND** includes `queryNotDeleted=false`.

#### Scenario: User exports deleted money pages
- **WHEN** a user exports deleted receive money, deleted payment, or deleted offset payment
- **THEN** the frontend calls the corresponding export endpoint
- **AND** includes `queryNotDeleted=false`.

### Requirement: Deleted Metadata Columns
Deleted pages SHALL present deletion metadata instead of modification metadata.

#### Scenario: Existing modification columns are present
- **WHEN** an original page has `updateTime` and `updateByUserName` columns
- **THEN** the deleted page displays those fields with labels `删除时间` and `删除人`.

#### Scenario: Modification columns are absent
- **WHEN** a deleted page does not already have metadata columns
- **THEN** it adds `删除时间` and `删除人` columns using backend-provided deletion metadata fields.

### Requirement: Offset Payment Account Type
Offset payment pages SHALL use backend-returned account type fields when they are available.

#### Scenario: Deleted offset payment row has account type fields
- **WHEN** a deleted offset payment row includes `selfBankCardType` or `otherBankCardType`
- **THEN** the page displays those returned values directly
- **AND** does not rely only on fund-change-derived frontend inference.
