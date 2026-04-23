import { describe, expect, test } from '@jest/globals';
import { invokeDialogOpenedHooks } from '@/utils/dialogOpenedHooks';

describe('invokeDialogOpenedHooks', () => {
	test('recursively calls handleDialogOpened on component instances and children', () => {
		const called = [];
		const tree = {
			handleDialogOpened() {
				called.push('root');
			},
			$children: [
				{
					handleDialogOpened() {
						called.push('child-a');
					},
					$children: []
				},
				{
					$children: [
						{
							handleDialogOpened() {
								called.push('grandchild');
							}
						}
					]
				}
			]
		};

		invokeDialogOpenedHooks(tree);

		expect(called).toEqual(['root', 'child-a', 'grandchild']);
	});
});
