/*
 * 用户需求：开票时在订单列表调整分页大小（或翻页、搜索）后，已勾选的订单和已分配金额会丢失。
 * 实际改动：表格加 row-key + 选择列加 reserve-selection 保留跨分页勾选；无差量的 selection-change 直接返回；清空时同步清勾选。
 *
 * 背景（Element UI 行为，已在真实浏览器验证）：
 *   element-ui/packages/table/src/store/index.js 的 setData：
 *     数据换成新数组实例时，若未开启 reserveSelection 会执行 clearSelection() 并 emit('selection-change', [])。
 *   SelectGoods.getList() 每次都会重新赋值 goodsOrderList（新数组），因此调整分页大小/翻页/搜索都会触发清空，
 *   进而把 Vuex 里的 selectedOrders 清空、开票金额回退，QueueInvoiceList 监听到空选择后禁用"开具发票"按钮。
 *   开启 reserveSelection 后走 updateSelectionByRowKey()，勾选与 Vuex 数据都不会被清掉。
 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

describe('SelectGoods 跨分页保留已选订单', () => {
	const componentPath = path.resolve(__dirname, './SelectGoods.vue');
	const source = fs.readFileSync(componentPath, 'utf8');

	test('订单列表表格声明 row-key，选择列开启 reserve-selection', () => {
		const tableStart = source.indexOf('<el-table');
		expect(tableStart).toBeGreaterThan(-1);
		const tableSource = source.slice(tableStart, source.indexOf('</el-table>', tableStart));

		// reserve-selection 需要 row-key 才能按行保留
		expect(tableSource).toMatch(/\brow-key="id"/);
		expect(tableSource).toContain('type="selection"');
		expect(tableSource).toMatch(/type="selection"[^>]*reserve-selection/);
	});

	test('选中集合无差量时不报错、不改动金额', () => {
		// 分页变化后会抛出空 selection-change，此时 addedRows/removedRows 都为空
		expect(source).toContain('if (!_row) {');
		expect(source).toContain('this.preOrderList = [];');
		// 不再直接取 _row.params，避免空行导致的异常
		expect(source).not.toContain('if (_row.params.totalInvoiceAmount == null');
	});

	test('清空已选订单时同步清空表格勾选，避免勾选框与 Vuex 状态不一致', () => {
		const clearHandlerStart = source.indexOf("this.$bus.$on('invoice-clear'");
		expect(clearHandlerStart).toBeGreaterThan(-1);
		const handlerSource = source.slice(clearHandlerStart, source.indexOf('});', clearHandlerStart));

		expect(handlerSource).toContain('excel/clearSelectedOrders');
		// 先清 preOrderList，再清勾选，避免把金额又加回去
		expect(handlerSource.indexOf('this.preOrderList = [];')).toBeLessThan(handlerSource.indexOf('clearSelection()'));
	});
});
