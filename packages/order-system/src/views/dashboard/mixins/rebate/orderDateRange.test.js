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
import { convertOrderDateRangeToParams, pickFilterValue, resolveBeginEndTime } from './orderDateRange';

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

describe('convertOrderDateRangeToParams（范围查找，已启用）', () => {
	test('把 daterange 数组转换成 params.beginTime / params.endTime', () => {
		const { query, hasOrderDateRange } = convertOrderDateRangeToParams({ supplier: '沙河氢氟酸', orderDateRange: ['2024-09-03', '2026-09-30'] });

		expect(hasOrderDateRange).toBe(true);
		expect(query.params.beginTime).toBe('2024-09-03');
		expect(query.params.endTime).toBe('2026-09-30');
		expect(query.supplier).toBe('沙河氢氟酸');
	});

	test('orderDateRange 不作为请求参数发出去', () => {
		const { query } = convertOrderDateRangeToParams({ orderDateRange: ['2024-09-03', '2026-09-30'] });

		expect(Object.prototype.hasOwnProperty.call(query, 'orderDateRange')).toBe(false);
	});

	test('只选了一边时另一边为空（部分范围）', () => {
		const onlyBegin = convertOrderDateRangeToParams({ orderDateRange: ['2024-09-03', null] }).query;
		expect(onlyBegin.params.beginTime).toBe('2024-09-03');
		expect(onlyBegin.params.endTime).toBeNull();

		const onlyEnd = convertOrderDateRangeToParams({ orderDateRange: [null, '2026-09-30'] }).query;
		expect(onlyEnd.params.beginTime).toBeNull();
		expect(onlyEnd.params.endTime).toBe('2026-09-30');
	});

	test('清空时间选择器（null）会清掉范围条件', () => {
		const { query, hasOrderDateRange } = convertOrderDateRangeToParams({ orderDateRange: null, params: { beginTime: '2024-09-03', endTime: '2026-09-30' } });

		expect(hasOrderDateRange).toBe(true);
		expect(query.params.beginTime).toBeNull();
		expect(query.params.endTime).toBeNull();
	});

	test('没有携带 orderDateRange 时不改动原有 params 条件', () => {
		const { query, hasOrderDateRange } = convertOrderDateRangeToParams({ params: { beginTime: '2024-09-03', endTime: '2026-09-30', orderDateSort: 'desc' } });

		expect(hasOrderDateRange).toBe(false);
		expect(query.params.beginTime).toBe('2024-09-03');
		expect(query.params.endTime).toBe('2026-09-30');
		expect(query.params.orderDateSort).toBe('desc');
	});

	test('不修改入参，且入参为空时安全返回', () => {
		const input = { orderDateRange: ['2024-09-03', '2024-09-30'] };
		const { query } = convertOrderDateRangeToParams(input);

		expect(input.orderDateRange).toEqual(['2024-09-03', '2024-09-30']);
		expect(query).not.toBe(input);
		expect(convertOrderDateRangeToParams(undefined).query).toEqual({});
	});
});

describe('resolveBeginEndTime（选择器优先，上级弹窗兜底）', () => {
	test('货物列表弹窗提供了范围时以它为准', () => {
		expect(resolveBeginEndTime({ beginTime: '2024-07-01', endTime: '2024-07-10' }, { beginTime: '2020-01-01', endTime: '2020-01-02' }, true)).toEqual({
			beginTime: '2024-07-01',
			endTime: '2024-07-10'
		});
	});

	test('弹窗里清空范围时按清空处理，不回退上级旧值', () => {
		expect(resolveBeginEndTime({ beginTime: null, endTime: null }, { beginTime: '2020-01-01', endTime: '2020-01-02' }, true)).toEqual({
			beginTime: null,
			endTime: null
		});
	});

	test('没有携带选择器范围时用上级弹窗的开始/结束时间', () => {
		expect(resolveBeginEndTime(undefined, { beginTime: '2020-01-01', endTime: '2020-01-02' }, false)).toEqual({
			beginTime: '2020-01-01',
			endTime: '2020-01-02'
		});
	});

	test('两边都没有时返回 null', () => {
		expect(resolveBeginEndTime(undefined, undefined, false)).toEqual({ beginTime: null, endTime: null });
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

describe('convertOrderDateRangeToParams 已正式启用（apifox 更新后）', () => {
	test('模块注释已更新为"支持范围查找"，不再保留旧的不支持标记', () => {
		const source = fs.readFileSync(path.resolve(__dirname, './orderDateRange.js'), 'utf8');

		expect(source).toContain('已支持范围查找');
		expect(source).toContain('不要再发送 orderDate');
		expect(source).not.toContain('后端尚未支持');
		expect(source).not.toContain('@deprecated');
	});
});

describe('查询请求：时间走范围参数，且清空后不再带旧条件', () => {
	test('getDetailBySupper 用 params.beginTime/endTime 做范围查询', () => {
		const methodSource = sliceMethod(mixinSource, 'getDetailBySupper(query) {');

		expect(methodSource).toContain('convertOrderDateRangeToParams(query)');
		expect(methodSource).toContain('resolveBeginEndTime(baseQuery.params, this.queryParamsSupplier.params, hasOrderDateRange)');
		expect(methodSource).toMatch(/params: \{\s*\.\.\.\(baseQuery\.params \|\| \{\}\),\s*beginTime,\s*endTime\s*\}/);
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

	test('不再发送单个 orderDate（避免与范围叠加多筛一次）', () => {
		expect(sliceMethod(mixinSource, 'getDetailBySupper(query) {')).toContain('delete qs.orderDate;');
		expect(sliceMethod(mixinSource, 'getDirectOrderDetailList(query) {')).toContain('delete requestQuery.orderDate;');
		expect(sliceMethod(mixinSource, 'handleCommitSupplier() {')).not.toMatch(/orderDate\s*:/);
		expect(sliceMethod(rebateSource, 'openAppendOrderList() {')).not.toMatch(/orderDate\s*:/);
	});

	test('getDirectOrderDetailList 同样做范围转换', () => {
		const methodSource = sliceMethod(mixinSource, 'getDirectOrderDetailList(query) {');

		expect(methodSource).toContain('convertOrderDateRangeToParams(query)');
	});

	test('旧的"接口不支持"标记已移除，接口状态已更新为支持范围查找', () => {
		expect(mixinSource).not.toContain('目前只有 orderDate 可用');
		expect(mixinSource).toContain('params.beginTime/params.endTime 支持范围查找');
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
		// 时间选择器清空后不带时间条件（范围参数为 null，ruoyi 的 tansParams 不会拼进 URL）
		expect(request.params.beginTime).toBeNull();
		expect(request.params.endTime).toBeNull();
		expect(request.orderDate).toBeUndefined();
		expect(request.orderDateRange).toBeUndefined();
	});

	test('时间选择器选了范围时，按 params.beginTime/endTime 做范围查询', async () => {
		const ctx = createContext();
		await ctx.getDetailBySupper({
			pageNum: 1,
			pageSize: 20,
			supplier: '沙河氢氟酸',
			orderDateRange: ['2024-09-03', '2026-09-30'],
			params: {}
		});

		const request = lastRequest();
		expect(request.params.beginTime).toBe('2024-09-03');
		expect(request.params.endTime).toBe('2026-09-30');
		// 不再发送单个 orderDate
		expect(request.orderDate).toBeUndefined();
	});

	test('以「根据供应商选择订单」弹窗发起查询时，用该弹窗的开始/结束时间做范围查询', async () => {
		const ctx = createContext();
		// 确定/追加选择走的是这个入参（没有 orderDateRange 字段）
		await ctx.getDetailBySupper(ctx.queryParamsSupplier);

		const request = lastRequest();
		expect(request.supplier).toBe('沙河氢氟酸');
		expect(request.levelName).toBe('级别A');
		expect(request.height).toBe('10');
		expect(request.params.beginTime).toBe('2024-09-03');
		expect(request.params.endTime).toBe('2026-09-30');
		expect(request.orderDate).toBeUndefined();
	});

	test('货物列表弹窗改过时间范围后，会同步回「根据供应商选择订单」弹窗（追加选择沿用）', async () => {
		const ctx = createContext();
		await ctx.getDetailBySupper({
			pageNum: 1,
			pageSize: 20,
			orderDateRange: ['2024-10-01', '2024-10-31'],
			params: {}
		});

		expect(ctx.queryParamsSupplier.params.beginTime).toBe('2024-10-01');
		expect(ctx.queryParamsSupplier.params.endTime).toBe('2024-10-31');
		expect(lastRequest().params.beginTime).toBe('2024-10-01');
	});
});
