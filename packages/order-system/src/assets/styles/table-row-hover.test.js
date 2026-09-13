/*
 * 用户需求：NoneInvoiceIn、NoneInvoiceOut、InvoiceOtherHave、InvoiceOther 四个组件表格行鼠标经过时高亮更醒目，但不能遮挡文字。
 * 实际改动：抽出 assets/styles/table-row-hover.scss（行背景色 + 首列 inset 强调条，不使用遮罩层），由四个组件分别引入。
 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

const SRC_ROOT = path.resolve(__dirname, '../..');
const PARTIAL_PATH = path.join(__dirname, 'table-row-hover.scss');
const PARTIAL_IMPORT = "@import '~@/assets/styles/table-row-hover.scss';";

const HOVER_COMPONENTS = ['views/system/noneInvoice/InvoiceIn.vue', 'views/system/noneInvoice/InvoiceOut.vue', 'views/system/invoiceOther/index.vue', 'views/system/invoiceOther/invoicehave.vue'];

const readSource = relativePath => fs.readFileSync(path.join(SRC_ROOT, relativePath), 'utf8');

describe('表格行悬停高亮样式', () => {
	const partialSource = fs.readFileSync(PARTIAL_PATH, 'utf8');

	test.each(HOVER_COMPONENTS)('%s 引入统一的悬停高亮样式', relativePath => {
		const source = readSource(relativePath);

		expect(source).toContain(PARTIAL_IMPORT);
		// 必须是 scoped SCSS 块，::v-deep 才能被 vue-loader 正确处理
		expect(source).toMatch(/<style scoped lang="scss">[\s\S]*table-row-hover\.scss[\s\S]*<\/style>/);
	});

	test('高亮同时覆盖主表格与固定列同步的 hover-row 行', () => {
		// Element 会在主表格与 fixed 列上同时打 hover-row，只写 tr:hover 会导致固定列颜色断层
		expect(partialSource).toContain('tr.hover-row > td');
		expect(partialSource).toContain('tr:hover > td');
	});

	test('覆盖 Element 默认悬停色并给出更醒目的底色', () => {
		expect(partialSource).toContain('background-color: $table-row-hover-bg !important;');
		expect(partialSource).toMatch(/\$table-row-hover-bg:\s*#d9ecff;/);
	});

	test('强调条使用 inset 内阴影，不做遮罩层，避免遮挡文字', () => {
		expect(partialSource).toContain('box-shadow: inset 3px 0 0 0 $table-row-hover-accent;');
		// 不出现绝对定位遮罩 / 半透明覆盖层
		expect(partialSource).not.toMatch(/position:\s*absolute/);
		expect(partialSource).not.toMatch(/opacity\s*:/);
		expect(partialSource).not.toMatch(/::?(after|before)/);
	});
});
