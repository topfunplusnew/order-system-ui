const fs = require('fs');
const path = require('path');
const { describe, expect, test } = require('@jest/globals');

const tableFiles = ['payment/index.vue', 'receiveMoney/index.vue'];

function readSystemView(relativeFile) {
	return fs.readFileSync(path.resolve(__dirname, relativeFile), 'utf8');
}

describe('payment and receive money active operation rows', () => {
	test.each(tableFiles)('%s keeps the last operation row highlighted by company type', relativeFile => {
		const source = readSystemView(relativeFile);

		expect(source).toContain(':row-class-name="getCompanyTypeRowClassName"');
		expect(source).toContain('getCompanyTypeRowClassName({ row })');
		expect(source).toContain('activeCompanyTypeRowId');
		expect(source).toContain('setCompanyTypeActiveRow(scope.row)');
		expect(source).toContain('company-type-customer-active-row');
		expect(source).toContain('company-type-supplier-active-row');
	});
});
