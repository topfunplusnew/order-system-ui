# Change: Add source document date to freight payment

## Why
The freight payment list shows whether a freight record comes from an order or inventory, but users cannot see the business document date without opening the detail dialog.

## What Changes
- Add an `订单日期` column immediately after `运费来源`.
- Read order dates from `goodsOrder.orderDate` and inventory dates from `inventoryMain.storeDate`.
- Keep the column available in the existing column-visibility toolbar.

## Impact
- Affected code: freight payment page and a focused date-extraction helper/test.
- No backend API changes.

