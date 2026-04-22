import { afterEach, describe, expect, jest, test } from '@jest/globals';
import { applyAutoWidthToTable, createTableAutoWidthMixin } from '@/utils/tableAutoWidth';

function defineScrollWidth(element, value) {
	Object.defineProperty(element, 'scrollWidth', {
		configurable: true,
		get: () => value
	});
}

function createColumnMarkup(columnId, content = 'value') {
	return `
		<table>
			<colgroup><col name="${columnId}" /></colgroup>
			<thead>
				<tr>
					<th class="${columnId}">
						<div class="cell">header</div>
					</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="${columnId}">
						<div class="cell">${content}</div>
					</td>
				</tr>
			</tbody>
		</table>
	`;
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
	jest.useRealTimers();
});

describe('applyAutoWidthToTable', () => {
	test('auto fits regular columns without explicit width', () => {
		const columnId = 'el-table_1_column_1';
		const tableVm = createTableVm([{ id: columnId, type: 'default', property: 'customerName', width: undefined }], createColumnMarkup(columnId));
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
							<td class="${explicitId}"><div class="cell">2026-04-22 10:00:00</div></td>
							<td class="${actionId}"><div class="cell"><button type="button">编辑</button></div></td>
						</tr>
					</tbody>
				</table>
			`
		);

		applyAutoWidthToTable(tableVm);

		expect(tableVm.$el.querySelector(`col[name="${explicitId}"]`).hasAttribute('width')).toBe(false);
		expect(tableVm.$el.querySelector(`col[name="${actionId}"]`).hasAttribute('width')).toBe(false);
	});

	test('reapplies width when the function runs again after data changes', () => {
		const columnId = 'el-table_1_column_4';
		const tableVm = createTableVm([{ id: columnId, type: 'default', property: 'remarks', width: undefined }], createColumnMarkup(columnId));
		const [, bodyCell] = tableVm.$el.querySelectorAll(`.${columnId} .cell`);

		defineScrollWidth(bodyCell, 120);
		applyAutoWidthToTable(tableVm, { padding: 8 });
		expect(tableVm.store.states.columns[0].width).toBe(128);
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('128');

		defineScrollWidth(bodyCell, 220);
		applyAutoWidthToTable(tableVm, { padding: 8 });

		expect(tableVm.store.states.columns[0].width).toBe(228);
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('228');
	});

	test('does not apply width when the table explicitly disables auto width', () => {
		const columnId = 'el-table_1_column_6';
		const tableVm = createTableVm([{ id: columnId, type: 'default', property: 'comments', width: undefined }], createColumnMarkup(columnId));
		const [, bodyCell] = tableVm.$el.querySelectorAll(`.${columnId} .cell`);

		tableVm.$el.setAttribute('data-auto-width-disabled', 'true');
		defineScrollWidth(bodyCell, 240);

		applyAutoWidthToTable(tableVm, { padding: 10 });

		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).hasAttribute('width')).toBe(false);
	});

	test('prefers descendant content width for wrapped slot content', () => {
		const columnId = 'el-table_1_column_7';
		const tableVm = createTableVm(
			[{ id: columnId, type: 'default', property: 'supplier', width: undefined }],
			`
				<table>
					<colgroup><col name="${columnId}" /></colgroup>
					<thead>
						<tr>
							<th class="${columnId}">
								<div class="cell" style="padding: 0 14px;">
									<div class="expand-cursor-wrapper">
										<div class="text-container">
											<span class="text-content">供应商</span>
										</div>
									</div>
								</div>
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="${columnId}">
								<div class="cell" style="padding: 0 14px;">
									<div class="expand-cursor-wrapper">
										<div class="text-container">
											<span class="text-content">威海中玻镀膜玻璃股份有限公司</span>
										</div>
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

	test('does not keep growing from the current rendered cell width', () => {
		const columnId = 'el-table_1_column_8';
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
							<td class="${columnId}">
								<div class="cell" style="padding: 0 20px;">
									<span class="text-content">威海中玻镀膜玻璃股份有限公司</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			`
		);
		const bodyCell = tableVm.$el.querySelector(`td.${columnId} .cell`);
		const bodyTextContent = tableVm.$el.querySelector(`td.${columnId} .text-content`);

		defineScrollWidth(bodyCell, 300);
		defineScrollWidth(bodyTextContent, 120);

		applyAutoWidthToTable(tableVm, { padding: 8 });

		expect(tableVm.store.states.columns[0].width).toBe(128);
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('128');
	});

	test('keeps expansion padding within eight pixels total', () => {
		const columnId = 'el-table_1_column_9';
		const tableVm = createTableVm(
			[{ id: columnId, type: 'default', property: 'supplier', width: undefined }],
			`
				<table>
					<colgroup><col name="${columnId}" /></colgroup>
					<thead>
						<tr>
							<th class="${columnId}"><div class="cell" style="padding: 0 20px;">供应商</div></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="${columnId}">
								<div class="cell" style="padding: 0 20px;">
									<div class="expand-cursor-wrapper">
										<div class="text-container">
											<span class="text-content">威海中玻镀膜玻璃股份有限公司-茂名海晟</span>
										</div>
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			`
		);
		const headerCell = tableVm.$el.querySelector(`th.${columnId} .cell`);
		const bodyCell = tableVm.$el.querySelector(`td.${columnId} .cell`);
		const bodyWrapper = tableVm.$el.querySelector(`td.${columnId} .expand-cursor-wrapper`);
		const bodyContainer = tableVm.$el.querySelector(`td.${columnId} .text-container`);
		const bodyTextContent = tableVm.$el.querySelector(`td.${columnId} .text-content`);

		defineScrollWidth(headerCell, 30);
		defineScrollWidth(bodyCell, 400);
		defineScrollWidth(bodyWrapper, 400);
		defineScrollWidth(bodyContainer, 400);
		defineScrollWidth(bodyTextContent, 180);

		applyAutoWidthToTable(tableVm, { padding: 8 });

		expect(tableVm.store.states.columns[0].width).toBe(188);
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('188');
	});

	test('skips header-only tables without body rows', () => {
		const columnId = 'el-table_1_column_10';
		const tableVm = createTableVm(
			[{ id: columnId, type: 'default', property: 'profit', width: undefined }],
			`
				<table>
					<colgroup><col name="${columnId}" /></colgroup>
					<thead>
						<tr>
							<th class="${columnId}">
								<div class="cell">￥1000</div>
							</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			`
		);
		const headerCell = tableVm.$el.querySelector(`th.${columnId} .cell`);

		defineScrollWidth(headerCell, 500);
		applyAutoWidthToTable(tableVm);
		applyAutoWidthToTable(tableVm);

		expect(tableVm.$el.classList.contains('r-table')).toBe(false);
		expect(tableVm.store.states.columns[0].width).toBeUndefined();
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).hasAttribute('width')).toBe(false);
	});

	test('caps columns with empty body content at two hundred pixels', () => {
		const columnId = 'el-table_1_column_11';
		const tableVm = createTableVm(
			[{ id: columnId, type: 'default', property: 'emptyField', width: undefined }],
			`
				<table>
					<colgroup><col name="${columnId}" /></colgroup>
					<thead>
						<tr>
							<th class="${columnId}">
								<div class="cell">总货款杂费</div>
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="${columnId}">
								<div class="cell"></div>
							</td>
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

		const columnId = 'el-table_1_column_5';
		const tableVm = createTableVm([{ id: columnId, type: 'default', property: 'companyName', width: undefined }], createColumnMarkup(columnId));
		const [headerCell, bodyCell] = tableVm.$el.querySelectorAll(`.${columnId} .cell`);
		const mixin = createTableAutoWidthMixin({ delay: 0, padding: 12 });

		defineScrollWidth(headerCell, 80);
		defineScrollWidth(bodyCell, 160);

		Object.entries(mixin.methods).forEach(([name, method]) => {
			tableVm[name] = method;
		});
		tableVm.$options = { name: 'ElTable' };
		tableVm.$nextTick = callback => callback();
		tableVm.doLayout = jest.fn();

		mixin.mounted.call(tableVm);
		jest.runOnlyPendingTimers();

		expect(tableVm.doLayout).toHaveBeenCalled();
		expect(tableVm.$el.querySelector(`col[name="${columnId}"]`).getAttribute('width')).toBe('172');

		mixin.beforeDestroy.call(tableVm);
	});
});
