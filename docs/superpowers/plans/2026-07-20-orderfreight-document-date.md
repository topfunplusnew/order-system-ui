# Order Freight Document Date Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Display the order or inventory business date in the freight payment list.

**Architecture:** A pure helper owns nested response-field selection. The existing Vue page calls it from a new table column and registers the column in RightToolbar configuration.

**Tech Stack:** Vue 2, Element UI, Jest, ESLint

---

### Task 1: Date extraction helper

**Files:**
- Create: `packages/order-system/src/views/system/orderfreight/orderFreightDocumentDate.js`
- Test: `packages/order-system/src/views/system/orderfreight/orderFreightDocumentDate.test.js`

- [x] Write tests expecting `goodsOrder.orderDate`, `inventoryMain.storeDate`, and an empty string for missing source data.
- [x] Run the tests and confirm the helper is missing.
- [x] Implement the pure helper with order-first fallback behavior.
- [x] Run the tests and confirm they pass.

### Task 2: Freight payment table integration

**Files:**
- Modify: `packages/order-system/src/views/system/orderfreight/index.vue`
- Test: `packages/order-system/src/views/system/orderfreight/orderFreightDocumentDate.test.js`

- [x] Add a source-contract assertion for the detailed header comment and column placement.
- [x] Run the test and confirm the Vue integration is missing.
- [x] Add the detailed top-of-file comment, import the helper, expose it through methods, insert the column, and shift later column indexes.
- [x] Run focused tests and targeted ESLint.
- [x] Run the staging build and `git diff --check`.
