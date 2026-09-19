/*
 * 用户需求：浏览器实测供应商返利选择订单，搜索刷新过程不应出现指令运行错误。
 * 实际改动：复现 Vue 不绑定 this 调用 v-fixed.update 的行为，验证更新位置和最终样式清理。
 */
/* global test, expect */
import fixed from '../directive/module/fixed';

test('Vue 以普通函数调用 update 时能够重设固定布局并恢复原样式', () => {
	const el = document.createElement('div');
	el.style.position = 'relative';
	const oldValue = { mode: 'sticky', position: 'top', offset: 10 };
	fixed.inserted(el, { value: oldValue });
	const update = fixed.update;
	expect(() => update(el, { oldValue, value: { ...oldValue, offset: 30 } })).not.toThrow();
	expect(el.style.top).toBe('30px');
	fixed.unbind(el);
	expect(el.style.position).toBe('relative');
});
