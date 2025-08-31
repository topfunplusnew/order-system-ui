import { getDateRangeDays } from '../utils/index.js';

(async () => {
	console.log('=== 测试（ESM）：显式传入 7 天 ===');
	const r1 = await getDateRangeDays(7);
	console.log(r1);

	console.log('\n=== 测试（ESM）：显式传入 0 天 ===');
	const r0 = await getDateRangeDays(0);
	console.log(r0);

	console.log('\n=== 测试（ESM）：不传 days（将触发配置读取）===');
	try {
		const r2 = await getDateRangeDays();
		console.log('配置路径返回：', r2);
	} catch (e) {
		console.error('配置路径抛错：', e && e.message ? e.message : e);
	}

	console.log('\n测试完成');
})();
