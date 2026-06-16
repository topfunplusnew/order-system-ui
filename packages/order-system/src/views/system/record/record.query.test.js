import { describe, expect, test } from '@jest/globals';
import fs from 'fs';
import path from 'path';

const recordViewSource = fs.readFileSync(path.resolve(__dirname, 'index.vue'), 'utf8');

describe('record query filters', () => {
	test('includes source and target account name filters as top-level query params', () => {
		expect(recordViewSource).toContain('label="支付户名" prop="sourceAccountName"');
		expect(recordViewSource).toContain('v-model="queryParams.sourceAccountName"');
		expect(recordViewSource).toContain('sourceAccountName: null');
		expect(recordViewSource).not.toContain("this.queryParams.params['sourceAccountName']");

		expect(recordViewSource).toContain('label="收款户名" prop="targetAccountName"');
		expect(recordViewSource).toContain('v-model="queryParams.targetAccountName"');
		expect(recordViewSource).toContain('targetAccountName: null');
		expect(recordViewSource).not.toContain("this.queryParams.params['targetAccountName']");
	});
});
