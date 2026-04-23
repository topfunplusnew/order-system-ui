import { afterEach, describe, expect, jest, test } from '@jest/globals';
import { applyAutoWidthToTable, createTableAutoWidthMixin } from '@/utils/tableAutoWidth';

function defineScrollWidth(element, value) {
	Object.defineProperty(element, 'scrollWidth', {
		configurable: true,
		get: () => value
	});
}

function createTableVm(columns, markup) {
	const table = document.createElement('div');
	table.className = 'el-table';
	table.innerHTML = markup;
	document.body.appendChild(table);

	return {
		$el: table,
		store: {
			states: {
				columns
			}
		}
	};
}

afterEach(() => {
	document.body.innerHTML = '';
});

describe('applyAutoWidthToTable', () => {
	test('auto fits regular columns without explicit width', () => {
		const columnId = 'el-table_1_column_1';
		const tableVm = createTableVm(
			[{ id: columnId, type: 'default', property: 'customerName', width: undefined }],
			`
				<table>
					<colgroup><col name="${columnId}" /></colgroup>
					<thead>
						<tr>
							<th class="${columnId}"><div class="cell">客户</div></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="${columnId}"><div class="cell">茂名海晟</div></td>
						</tr>
					</tbody>
				</table>
			`
		);
		const [headerCell, bodyCell] = tableVm.$el.querySelectorAll(`.${columnId} .cell`);

		defineScrollWidth(headerCell, 90);
		defineScrollWidth(bodyCell, 180);

		applyAutoWidthToTable(tableVm, { padding: 16 });

		expect(tableVm.$el.classList.contains('r-table')).toBe(true);
		expect(tableVm.store.states.columns[0].width).toBe(196);
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('196');
	});

	test('skips explicit-width and interactive action columns', () => {
		const explicitId = 'el-table_1_column_2';
		const actionId = 'el-table_1_column_3';
		const tableVm = createTableVm(
			[
				{ id: explicitId, type: 'default', property: 'orderDate', width: 180 },
				{ id: actionId, type: 'default', property: undefined, width: undefined }
			],
			`
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
							<td class="${explicitId}"><div class="cell">2026-04-23 10:00:00</div></td>
							<td class="${actionId}"><div class="cell"><button type="button">查看</button></div></td>
						</tr>
					</tbody>
				</table>
			`
		);

		applyAutoWidthToTable(tableVm);

		expect(tableVm.$el.querySelector(`col[name="${explicitId}"]`).hasAttribute('width')).toBe(false);
		expect(tableVm.$el.querySelector(`col[name="${actionId}"]`).hasAttribute('width')).toBe(false);
	});

	test('prefers descendant content width for wrapped slot content', () => {
		const columnId = 'el-table_1_column_4';
		const tableVm = createTableVm(
			[{ id: columnId, type: 'default', property: 'supplier', width: undefined }],
			`
				<table>
					<colgroup><col name="${columnId}" /></colgroup>
					<thead>
						<tr>
							<th class="${columnId}">
								<div class="cell">
									<div class="text-container">
										<span class="text-content">供应商</span>
									</div>
								</div>
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="${columnId}">
								<div class="cell">
									<div class="text-container">
										<span class="text-content">威海中玻镀膜玻璃股份有限公司</span>
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			`
		);
		const bodyCell = tableVm.$el.querySelector(`td.${columnId} .cell`);
		const bodyTextContent = tableVm.$el.querySelector(`td.${columnId} .text-content`);

		defineScrollWidth(bodyCell, 120);
		defineScrollWidth(bodyTextContent, 260);

		applyAutoWidthToTable(tableVm, { padding: 16 });

		expect(tableVm.store.states.columns[0].width).toBe(276);
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('276');
	});

	test('caps columns with empty body content at two hundred pixels', () => {
		const columnId = 'el-table_1_column_5';
		const tableVm = createTableVm(
			[{ id: columnId, type: 'default', property: 'comments', width: undefined }],
			`
				<table>
					<colgroup><col name="${columnId}" /></colgroup>
					<thead>
						<tr>
							<th class="${columnId}"><div class="cell">计提厂家降价金额</div></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="${columnId}"><div class="cell"></div></td>
						</tr>
					</tbody>
				</table>
			`
		);
		const headerCell = tableVm.$el.querySelector(`th.${columnId} .cell`);
		const bodyCell = tableVm.$el.querySelector(`td.${columnId} .cell`);

		defineScrollWidth(headerCell, 260);
		defineScrollWidth(bodyCell, 800);

		applyAutoWidthToTable(tableVm, { padding: 8 });

		expect(tableVm.store.states.columns[0].width).toBe(200);
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('200');
	});
});

describe('createTableAutoWidthMixin', () => {
	test('schedules width recalculation for ElTable components on mount', () => {
		jest.useFakeTimers();

		const columnId = 'el-table_1_column_6';
		const tableVm = createTableVm(
			[{ id: columnId, type: 'default', property: 'supplier', width: undefined }],
			`
				<table>
					<colgroup><col name="${columnId}" /></colgroup>
					<thead>
						<tr>
							<th class="${columnId}"><div class="cell">供应商</div></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="${columnId}"><div class="cell">金星玻璃工业双辽有限公司-鲁运</div></td>
						</tr>
					</tbody>
				</table>
			`
		);
		const [headerCell, bodyCell] = tableVm.$el.querySelectorAll(`.${columnId} .cell`);
		const mixin = createTableAutoWidthMixin({ delay: 0, padding: 12 });

		defineScrollWidth(headerCell, 60);
		defineScrollWidth(bodyCell, 240);

		Object.entries(mixin.methods).forEach(([name, method]) => {
			tableVm[name] = method;
		});
		tableVm.$options = { name: 'ElTable' };
		tableVm.$nextTick = callback => callback();
		tableVm.doLayout = jest.fn();

		mixin.mounted.call(tableVm);
		jest.runOnlyPendingTimers();

		expect(tableVm.doLayout).toHaveBeenCalled();
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('252');

		mixin.beforeDestroy.call(tableVm);
	});

	test('keeps manually resized columns out of later auto width recalculation', () => {
		const columnId = 'el-table_1_column_7';
		const column = { id: columnId, type: 'default', property: 'supplier', width: undefined };
		const tableVm = createTableVm(
			[column],
			`
				<table>
					<colgroup><col name="${columnId}" /></colgroup>
					<thead>
						<tr>
							<th class="${columnId}"><div class="cell">供应商</div></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="${columnId}"><div class="cell">金星玻璃工业双辽有限公司-鲁运</div></td>
						</tr>
					</tbody>
				</table>
			`
		);
		const [headerCell, bodyCell] = tableVm.$el.querySelectorAll(`.${columnId} .cell`);
		const mixin = createTableAutoWidthMixin({ delay: 0, padding: 8 });
		const listeners = {};

		defineScrollWidth(headerCell, 60);
		defineScrollWidth(bodyCell, 240);

		Object.entries(mixin.methods).forEach(([name, method]) => {
			tableVm[name] = method;
		});
		tableVm.$options = { name: 'ElTable' };
		tableVm.$nextTick = callback => callback();
		tableVm.doLayout = jest.fn();
		tableVm.$on = jest.fn((eventName, handler) => {
			listeners[eventName] = handler;
		});
		tableVm.$off = jest.fn();

		mixin.mounted.call(tableVm);
		expect(typeof listeners['header-dragend']).toBe('function');

		listeners['header-dragend'](320, 80, column);
		defineScrollWidth(bodyCell, 520);

		applyAutoWidthToTable(tableVm, { padding: 8 });

		expect(column.width).toBe(320);
		expect(column.realWidth).toBe(320);
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('320');

		mixin.beforeDestroy.call(tableVm);
	});
});
