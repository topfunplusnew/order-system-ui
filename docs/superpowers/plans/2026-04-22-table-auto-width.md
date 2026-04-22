# Table Auto Width Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Element UI business tables auto-fit regular data columns by content while preserving fixed-width utility columns and explicit-width business columns.

**Architecture:** Implement a shared table auto-width utility that operates on `ElTable` instances and DOM colgroups, then register a lightweight global mixin that only activates on `ElTable` components to trigger recalculation on mount, update, activation, and window resize. Reuse the same utility in `FitTable.vue` so the legacy wrapper stops calling the nonexistent plugin resize API.

**Tech Stack:** Vue 2.6, Element UI 2.15, Jest 29, jsdom

---

### Task 1: Add a failing regression test for shared table auto-width behavior

**Files:**
- Create: `packages/order-system/src/utils/tableAutoWidth.test.js`
- Test: `packages/order-system/src/utils/tableAutoWidth.test.js`

- [ ] **Step 1: Write the failing test**

```js
import { describe, expect, test } from '@jest/globals';
import { applyAutoWidthToTable } from '@/utils/tableAutoWidth';

function defineScrollWidth(element, value) {
	Object.defineProperty(element, 'scrollWidth', {
		configurable: true,
		get: () => value
	});
}

function createTableDom(columnId) {
	const root = document.createElement('div');
	root.className = 'el-table';
	root.innerHTML = `
		<table class="el-table__header">
			<colgroup><col name="${columnId}" /></colgroup>
			<thead><tr><th class="${columnId}"><div class="cell">header</div></th></tr></thead>
		</table>
		<table class="el-table__body">
			<colgroup><col name="${columnId}" /></colgroup>
			<tbody><tr><td class="${columnId}"><div class="cell">body</div></td></tr></tbody>
		</table>
	`;
	document.body.appendChild(root);
	return root;
}

describe('table auto width', () => {
	test('auto fits regular columns without explicit width', () => {
		const columnId = 'el-table_1_column_1';
		const table = createTableDom(columnId);
		const [headerCell, bodyCell] = table.querySelectorAll(`.${columnId} .cell`);

		defineScrollWidth(headerCell, 90);
		defineScrollWidth(bodyCell, 180);

		const tableVm = {
			$el: table,
			store: {
				states: {
					columns: [{ id: columnId, type: 'default', property: 'name', width: undefined }]
				}
			}
		};

		applyAutoWidthToTable(tableVm, { padding: 16 });

		expect(table.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('196');
	});
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `yarn workspace order-system test packages/order-system/src/utils/tableAutoWidth.test.js --runInBand`
Expected: FAIL with `Cannot find module '@/utils/tableAutoWidth'`

- [ ] **Step 3: Write the second failing test for exclusions**

```js
test('skips explicit-width and interactive action columns', () => {
	const explicitId = 'el-table_1_column_2';
	const actionId = 'el-table_1_column_3';
	const table = document.createElement('div');
	table.className = 'el-table';
	table.innerHTML = `
		<table>
			<colgroup>
				<col name="${explicitId}" />
				<col name="${actionId}" />
			</colgroup>
			<thead>
				<tr>
					<th class="${explicitId}"><div class="cell">日期</div></th>
					<th class="${actionId}"><div class="cell">操作</div></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="${explicitId}"><div class="cell">2026-04-22 10:00:00</div></td>
					<td class="${actionId}"><div class="cell"><button type="button">编辑</button></div></td>
				</tr>
			</tbody>
		</table>
	`;
	document.body.appendChild(table);

	applyAutoWidthToTable({
		$el: table,
		store: {
			states: {
				columns: [
					{ id: explicitId, type: 'default', property: 'date', width: 180 },
					{ id: actionId, type: 'default', property: undefined, width: undefined }
				]
			}
		}
	});

	expect(table.querySelector(`col[name="${explicitId}"]`).hasAttribute('width')).toBe(false);
	expect(table.querySelector(`col[name="${actionId}"]`).hasAttribute('width')).toBe(false);
});
```

- [ ] **Step 4: Run test to verify it fails**

Run: `yarn workspace order-system test packages/order-system/src/utils/tableAutoWidth.test.js --runInBand`
Expected: FAIL because the utility still does not exist

- [ ] **Step 5: Commit**

```bash
git add packages/order-system/src/utils/tableAutoWidth.test.js
git commit -m "test: add table auto width regression coverage"
```

### Task 2: Implement the shared auto-width utility

**Files:**
- Create: `packages/order-system/src/utils/tableAutoWidth.js`
- Test: `packages/order-system/src/utils/tableAutoWidth.test.js`

- [ ] **Step 1: Write the minimal implementation**

```js
const DEFAULT_PADDING = 32;
const EXCLUDED_TYPES = new Set(['selection', 'index', 'expand']);
const INTERACTIVE_SELECTOR = 'button,a,input,select,textarea,.el-button,.el-link,.el-switch,.el-dropdown,.el-select,.el-input';

export function isAutoWidthExcludedColumn(column, cells = []) {
	if (!column || !column.id) return true;
	if (EXCLUDED_TYPES.has(column.type)) return true;
	if (column.width !== undefined && column.width !== null && column.width !== '') return true;
	return cells.some(cell => cell.querySelector && cell.querySelector(INTERACTIVE_SELECTOR));
}

export function applyAutoWidthToTable(tableVm, options = {}) {
	if (!tableVm || !tableVm.$el || !tableVm.store || !tableVm.store.states) return;
	const padding = options.padding ?? DEFAULT_PADDING;
	const tableEl = tableVm.$el;
	const columns = tableVm.store.states.columns || [];

	tableEl.classList.add('r-table');

	columns.forEach(column => {
		const cells = Array.from(tableEl.querySelectorAll(`th.${column.id}, td.${column.id}`));
		if (isAutoWidthExcludedColumn(column, cells)) return;

		const width = cells.reduce((max, cell) => {
			const content = cell.querySelector('.cell') || cell;
			return Math.max(max, content.scrollWidth || 0);
		}, 0);

		if (!width) return;

		tableEl.querySelectorAll(`col[name="${column.id}"]`).forEach(col => {
			col.setAttribute('width', String(width + padding));
		});
	});
}
```

- [ ] **Step 2: Run targeted tests to verify they pass**

Run: `yarn workspace order-system test packages/order-system/src/utils/tableAutoWidth.test.js --runInBand`
Expected: PASS

- [ ] **Step 3: Refactor only if needed**

```js
// Keep shared constants exported only if main.js / FitTable.vue needs them.
// Do not add extra configuration surface unless a later task requires it.
```

- [ ] **Step 4: Re-run targeted tests after refactor**

Run: `yarn workspace order-system test packages/order-system/src/utils/tableAutoWidth.test.js --runInBand`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add packages/order-system/src/utils/tableAutoWidth.js packages/order-system/src/utils/tableAutoWidth.test.js
git commit -m "feat: add shared table auto width utility"
```

### Task 3: Register ElTable lifecycle hooks and repair FitTable

**Files:**
- Modify: `packages/order-system/src/main.js`
- Modify: `packages/order-system/src/components/FitTable.vue`
- Modify: `packages/order-system/src/utils/tableAutoWidth.js`
- Test: `packages/order-system/src/utils/tableAutoWidth.test.js`

- [ ] **Step 1: Add a failing test for recalculation scheduling**

```js
test('reapplies width after data-driven updates by reusing the shared utility', () => {
	const columnId = 'el-table_1_column_4';
	const table = createTableDom(columnId);
	const [, bodyCell] = table.querySelectorAll(`.${columnId} .cell`);
	defineScrollWidth(bodyCell, 120);

	const tableVm = {
		$el: table,
		store: {
			states: {
				columns: [{ id: columnId, type: 'default', property: 'name', width: undefined }]
			}
		}
	};

	applyAutoWidthToTable(tableVm, { padding: 8 });
	defineScrollWidth(bodyCell, 220);
	applyAutoWidthToTable(tableVm, { padding: 8 });

	expect(table.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('228');
});
```

- [ ] **Step 2: Run the targeted test**

Run: `yarn workspace order-system test packages/order-system/src/utils/tableAutoWidth.test.js --runInBand`
Expected: FAIL if the utility does not overwrite the previous width correctly

- [ ] **Step 3: Wire the lifecycle hooks**

```js
// main.js
import { createTableAutoWidthMixin } from '@/utils/tableAutoWidth';
Vue.mixin(createTableAutoWidthMixin());
```

```js
// FitTable.vue
import { applyAutoWidthToTable } from '@/utils/tableAutoWidth';
// call applyAutoWidthToTable(this.$refs.tableRef || tableRef.value) after data changes
```

- [ ] **Step 4: Run the focused tests again**

Run: `yarn workspace order-system test packages/order-system/src/utils/tableAutoWidth.test.js --runInBand`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add packages/order-system/src/main.js packages/order-system/src/components/FitTable.vue packages/order-system/src/utils/tableAutoWidth.js packages/order-system/src/utils/tableAutoWidth.test.js
git commit -m "feat: auto apply table content width recalculation"
```

### Task 4: Verify lint and targeted regressions

**Files:**
- Test: `packages/order-system/src/utils/tableAutoWidth.test.js`
- Test: `packages/order-system/src/views/system/shared/repaymentHistoryColumns.test.js`
- Test: `packages/order-system/src/views/system/lowvalueconsumables/lowvalueconsumables.config.test.js`

- [ ] **Step 1: Run the new regression tests**

Run: `yarn workspace order-system test packages/order-system/src/utils/tableAutoWidth.test.js --runInBand`
Expected: PASS

- [ ] **Step 2: Run a small existing regression slice**

Run: `yarn workspace order-system test packages/order-system/src/views/system/shared/repaymentHistoryColumns.test.js packages/order-system/src/views/system/lowvalueconsumables/lowvalueconsumables.config.test.js --runInBand`
Expected: PASS

- [ ] **Step 3: Run lint on changed files**

Run: `yarn workspace order-system lint:eslint src/main.js src/components/FitTable.vue src/utils/tableAutoWidth.js src/utils/tableAutoWidth.test.js`
Expected: PASS

- [ ] **Step 4: Review diff against the approved spec**

```bash
git diff -- packages/order-system/src/main.js \
  packages/order-system/src/components/FitTable.vue \
  packages/order-system/src/utils/tableAutoWidth.js \
  packages/order-system/src/utils/tableAutoWidth.test.js
```

- [ ] **Step 5: Commit**

```bash
git add docs/superpowers/plans/2026-04-22-table-auto-width.md
git commit -m "docs: add table auto width implementation plan"
```
