/*
 * 用户需求：① 在"根据供应商选择订单"弹窗选好开始/结束时间后，要带到"根据供应商所选货物列表"弹窗的时间选择器中；
 *          ② listOrderDetail 接口目前只有 orderDate 可用，params.beginTime/endTime 不要传递（等后端支持后再加）；
 *          ③ 该弹窗选择产品级别后不再自动填充厚度/长度/宽度。
 * 实际改动：确定时把 orderDateRange 传给货物列表仅用于选择器回显；请求前剔除 params 时间字段；
 *          产品级别只回填级别名称。
 */
/* global describe, test, expect, jest */
import fs from 'fs';
import path from 'path';
import { convertOrderDateRangeToParams, pickFilterValue, stripOrderDateRange } from './orderDateRange';

jest.mock('@/api/system/orderDetail', () => ({
	listOrderDetail: jest.fn(() => Promise.resolve({ rows: [], total: 0 }))
}));
import { listOrderDetail } from '@/api/system/orderDetail';
import { mixin_choose_order } from './choose_order';

const MIXIN_PATH = path.resolve(__dirname, './choose_order.js');
const REBATE_PAGE_PATH = path.resolve(__dirname, '../../../../views/system/rebate/index.vue');
const mixinSource = fs.readFileSync(MIXIN_PATH, 'utf8');
const rebateSource = fs.readFileSync(REBATE_PAGE_PATH, 'utf8');

/** 取某个方法体的源码片段，便于断言 */
const sliceMethod = (source, signature) => {
	const start = source.indexOf(signature);
	expect(start).toBeGreaterThan(-1);
	return source.slice(start, source.indexOf('\n\t\t},', start));
};

describe('stripOrderDateRange（当前启用：只清理，不加 params 时间字段）', () => {
	test('剔除选择器字段 orderDateRange，避免作为请求参数发出去', () => {
		const { query } = stripOrderDateRange({ supplier: '沙河氢氟酸', orderDateRange: ['2024-09-03', '2026-09-30'] });

		expect(Object.prototype.hasOwnProperty.call(query, 'orderDateRange')).toBe(false);
		expect(query.supplier).toBe('沙河氢氟酸');
	});

	test('剔除 params 里残留的 beginTime / endTime（接口不支持，不能传）', () => {
		const { query } = stripOrderDateRange({ params: { beginTime: '2024-09-03', endTime: '2026-09-30', orderDateSort: 'desc' } });

		expect(query.params.beginTime).toBeUndefined();
		expect(query.params.endTime).toBeUndefined();
		// 其它 params 字段保持不变
		expect(query.params.orderDateSort).toBe('desc');
	});

	test('保留 orderDate（接口目前唯一可用的时间字段）', () => {
		const { query } = stripOrderDateRange({ orderDate: '2024-09-03' });

		expect(query.orderDate).toBe('2024-09-03');
	});

	test('返回选择器状态：是否由货物列表弹窗提供、起止日期', () => {
		const withRange = stripOrderDateRange({ orderDateRange: ['2024-09-03', '2026-09-30'] });
		expect(withRange.hasOrderDateRange).toBe(true);
		expect(withRange.orderDateRange).toEqual(['2024-09-03', '2026-09-30']);

		const cleared = stripOrderDateRange({ orderDateRange: null });
		expect(cleared.hasOrderDateRange).toBe(true);
		expect(cleared.orderDateRange).toBeNull();

		// 上级弹窗自己传的查询对象里没有该字段
		expect(stripOrderDateRange({ supplier: 'A' }).hasOrderDateRange).toBe(false);
	});

	test('不修改入参，且入参为空时安全返回', () => {
		const input = { orderDateRange: ['2024-09-03', '2024-09-30'], params: { beginTime: 'x' } };
		const { query } = stripOrderDateRange(input);

		expect(input.orderDateRange).toEqual(['2024-09-03', '2024-09-30']);
		expect(input.params.beginTime).toBe('x');
		expect(query).not.toBe(input);
		expect(stripOrderDateRange(undefined).query).toEqual({});
	});
});

describe('pickFilterValue（清空后的值必须生效）', () => {
	test('表单里清空成空串时用空串，不被上级旧值覆盖', () => {
		expect(pickFilterValue({ supplier: '' }, 'supplier', '沙河氢氟酸')).toBe('');
	});

	test('表单里是 null 时也用 null', () => {
		expect(pickFilterValue({ height: null }, 'height', '10')).toBeNull();
	});

	test('表单里完全没有该字段时才回退上级的值', () => {
		expect(pickFilterValue({}, 'supplier', '沙河氢氟酸')).toBe('沙河氢氟酸');
		expect(pickFilterValue(undefined, 'supplier', '沙河氢氟酸')).toBe('沙河氢氟酸');
	});

	test('上级也没有该字段时返回 null', () => {
		expect(pickFilterValue({}, 'supplier', undefined)).toBeNull();
	});
});

describe('convertOrderDateRangeToParams（后端支持后才启用）', () => {
	test('实现保留完好：仍能把 orderDateRange 转成 params.beginTime/endTime', () => {
		const { query, hasOrderDateRange } = convertOrderDateRangeToParams({ orderDateRange: ['2024-09-03', '2026-09-30'] });

		expect(hasOrderDateRange).toBe(true);
		expect(query.params.beginTime).toBe('2024-09-03');
		expect(query.params.endTime).toBe('2026-09-30');
		expect(Object.prototype.hasOwnProperty.call(query, 'orderDateRange')).toBe(false);
	});

	test('标注为暂不启用（@deprecated + 明确标记）', () => {
		const source = fs.readFileSync(path.resolve(__dirname, './orderDateRange.js'), 'utf8');

		expect(source).toContain('@deprecated');
		expect(source).toContain('params.beginTime / params.endTime 后端尚未支持');
		expect(source).toContain('待后端明确说支持以后');
	});
});

describe('查询请求不混传三个时间字段，且清空后不再带旧条件', () => {
	test('getDetailBySupper 只做清理，不组装 params 时间条件', () => {
		const methodSource = sliceMethod(mixinSource, 'getDetailBySupper(query) {');

		expect(methodSource).toContain('stripOrderDateRange(query)');
		// 不能出现 beginTime/endTime 的取值或对象字段（注释里的说明不算）
		expect(methodSource).not.toMatch(/beginTime\s*[:,]/);
		expect(methodSource).not.toMatch(/endTime\s*[:,]/);
		expect(methodSource).toMatch(/params: \{\s*\.\.\.\(baseQuery\.params \|\| \{\}\)\s*\}/);
	});

	test('筛选条件以货物列表弹窗的表单为准（清空后不被上级旧值覆盖）', () => {
		const methodSource = sliceMethod(mixinSource, 'getDetailBySupper(query) {');

		expect(methodSource).toContain("pickFilterValue(baseQuery, 'supplier', this.queryParamsSupplier.supplier)");
		expect(methodSource).toContain("pickFilterValue(baseQuery, 'levelName', this.queryParamsSupplier.levelName)");
		expect(methodSource).toContain("pickFilterValue(baseQuery, 'height', this.queryParamsSupplier.height)");
		expect(methodSource).toContain("pickFilterValue(baseQuery, 'length', this.queryParamsSupplier.length)");
		expect(methodSource).toContain("pickFilterValue(baseQuery, 'width', this.queryParamsSupplier.width)");
		// 不能再用上级值优先的老写法
		expect(methodSource).not.toContain('this.queryParamsSupplier.supplier || baseQuery.supplier');
	});

	test('时间跟随选择器：选了就带开始日期，清空就不带 orderDate', () => {
		const methodSource = sliceMethod(mixinSource, 'getDetailBySupper(query) {');

		expect(methodSource).toContain("const orderDate = hasOrderDateRange ? (orderDateRange && orderDateRange[0]) || null : pickFilterValue(baseQuery, 'orderDate', null);");
		expect(methodSource).toContain('delete qs.orderDate;');
	});

	test('getDirectOrderDetailList 同样只做清理并跟随选择器', () => {
		const methodSource = sliceMethod(mixinSource, 'getDirectOrderDetailList(query) {');

		expect(methodSource).toContain('stripOrderDateRange(query)');
		expect(methodSource).not.toMatch(/beginTime\s*[:,]/);
		expect(methodSource).not.toMatch(/endTime\s*[:,]/);
		expect(methodSource).toContain('delete requestQuery.orderDate;');
	});

	test('混合文件里保留了接口限制标记', () => {
		expect(mixinSource).toContain('listOrderDetail 目前只有 orderDate 可用');
	});
});

describe('时间选择器回显与产品级别回填', () => {
	test('确定时把开始/结束时间作为 orderDateRange 带给货物列表（仅回显）', () => {
		const methodSource = sliceMethod(mixinSource, 'handleCommitSupplier() {');

		expect(methodSource).toContain('orderDateRange: beginTime || endTime ? [beginTime, endTime] : null,');
	});

	test('追加选择货物时同样带上时间范围', () => {
		const methodSource = sliceMethod(rebateSource, 'openAppendOrderList() {');

		expect(methodSource).toContain('orderDateRange: beginTime || endTime ? [beginTime, endTime] : null,');
	});

	test('货物列表的时间选择器绑定 orderDateRange（两个弹窗的契约）', () => {
		const listSource = fs.readFileSync(path.resolve(__dirname, '../../components/rebate/OrderDetailList.vue'), 'utf8');

		expect(listSource).toContain('v-model="queryParams.orderDateRange"');
	});

	test('选择产品级别后不再自动填充厚度/长度/宽度', () => {
		const methodSource = sliceMethod(rebateSource, 'handleSupplierProductLevelSelect(value) {');

		expect(methodSource).toContain('this.queryParamsSupplier.levelName = value.levelName;');
		expect(methodSource).not.toContain('this.queryParamsSupplier.height');
		expect(methodSource).not.toContain('this.queryParamsSupplier.length');
		expect(methodSource).not.toContain('this.queryParamsSupplier.width');
	});
});

describe('getDetailBySupper 实际组装出的请求参数', () => {
	// 直接调用混入里的方法，用一个假的 this，验证真的请求参数（而不是只做字符串断言）
	const createContext = () => ({
		...mixin_choose_order.data(),
		queryParamsSupplier: {
			pageNum: 1,
			pageSize: 20,
			supplier: '沙河氢氟酸',
			levelName: '级别A',
			height: '10',
			length: '20',
			width: '30',
			params: { beginTime: '2024-09-03', endTime: '2026-09-30' }
		},
		goods: [],
		needToSelectOrderDetailList: [],
		orderGoodsListVisible: false,
		orderDetailTotal: 0,
		$message: { info: jest.fn(), warning: jest.fn(), error: jest.fn() },
		$nextTick: callback => callback && callback(),
		restoreAppendSelection: () => {},
		getDetailBySupper: mixin_choose_order.methods.getDetailBySupper
	});

	const lastRequest = () => listOrderDetail.mock.calls[listOrderDetail.mock.calls.length - 1][0];

	beforeEach(() => {
		listOrderDetail.mockClear();
		jest.useFakeTimers();
	});

	afterEach(() => {
		jest.useRealTimers();
	});

	test('货物列表弹窗清空表单后，请求里不再带清空前的条件', async () => {
		const ctx = createContext();
		// 用户在货物列表弹窗里把所有筛选清空后点击搜索（空串/null 表示已清空）
		await ctx.getDetailBySupper({
			pageNum: 1,
			pageSize: 20,
			supplier: '',
			levelName: '',
			height: '',
			length: '',
			width: '',
			orderDateRange: null,
			params: {}
		});

		expect(listOrderDetail).toHaveBeenCalledTimes(1);
		const request = lastRequest();
		expect(request.supplier).toBe('');
		expect(request.levelName).toBe('');
		expect(request.height).toBe('');
		expect(request.length).toBe('');
		expect(request.width).toBe('');
		// 时间选择器清空后不带 orderDate，也不带后端不支持的 params 时间字段
		expect(request.orderDate).toBeUndefined();
		expect(request.params.beginTime).toBeUndefined();
		expect(request.params.endTime).toBeUndefined();
		expect(request.orderDateRange).toBeUndefined();
	});

	test('时间选择器选了范围时，按开始日期带上 orderDate', async () => {
		const ctx = createContext();
		await ctx.getDetailBySupper({
			pageNum: 1,
			pageSize: 20,
			supplier: '沙河氢氟酸',
			orderDateRange: ['2024-09-03', '2026-09-30'],
			params: {}
		});

		const request = lastRequest();
		expect(request.orderDate).toBe('2024-09-03');
		expect(request.params.beginTime).toBeUndefined();
		expect(request.params.endTime).toBeUndefined();
	});

	test('以「根据供应商选择订单」弹窗发起查询时，条件照旧生效且不传 params 时间字段', async () => {
		const ctx = createContext();
		// 确定/追加选择走的是这个入参（没有 orderDateRange 字段）
		await ctx.getDetailBySupper(ctx.queryParamsSupplier);

		const request = lastRequest();
		expect(request.supplier).toBe('沙河氢氟酸');
		expect(request.levelName).toBe('级别A');
		expect(request.height).toBe('10');
		expect(request.params.beginTime).toBeUndefined();
		expect(request.params.endTime).toBeUndefined();
	});
});
