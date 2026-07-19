## ADDED Requirements

### Requirement: Freight source document date
The freight payment list SHALL display the source business document date immediately after the freight source column.

#### Scenario: Freight comes from an order
- **WHEN** a freight row contains `goodsOrder`
- **THEN** the displayed order date is `goodsOrder.orderDate`

#### Scenario: Freight comes from inventory
- **WHEN** a freight row contains `inventoryMain`
- **THEN** the displayed order date is `inventoryMain.storeDate`

#### Scenario: Legacy row has no source object
- **WHEN** neither source object contains a date
- **THEN** the column displays `-` without throwing an error

