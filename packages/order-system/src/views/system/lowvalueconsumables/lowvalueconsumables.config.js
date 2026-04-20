function createAmountValidator(message) {
	return {
		validator: (rule, value, callback) => {
			if (!/^\d+(\.\d{1,2})?$/.test(value)) {
				callback(new Error(message));
			} else {
				callback();
			}
		},
		trigger: 'blur'
	};
}

export function createLowvalueconsumablesColumns() {
	return [
		{ key: 0, label: '购入日期', visible: true },
		{ key: 1, label: '资产编号', visible: true },
		{ key: 2, label: '资产名称', visible: true },
		{ key: 3, label: '规格型号', visible: true },
		{ key: 4, label: '数量', visible: true },
		{ key: 5, label: '计量单位', visible: true },
		{ key: 6, label: '含税金额', visible: true },
		{ key: 7, label: '不含税金额', visible: true },
		{ key: 8, label: '户名名称', visible: true },
		{ key: 9, label: '使用部门', visible: true },
		{ key: 10, label: '使用人', visible: true },
		{ key: 11, label: '低值易耗品台账清理时间', visible: true },
		{ key: 12, label: '清理/变卖价值', visible: true },
		{ key: 13, label: '备注', visible: true }
	];
}

export function createLowvalueconsumablesForm() {
	return {
		id: null,
		buyDate: null,
		assetNo: null,
		assetName: null,
		specification: null,
		number: null,
		measurementUnit: null,
		amountIncludeTax: null,
		amountNoTax: null,
		account: null,
		department: null,
		usePerson: null,
		scrapDate: null,
		saleAmount: null,
		comments: null,
		addtime: null,
		userId: null,
		UserName: null,
		updateTime: null,
		delFlag: null,
		type: 1
	};
}

export function createLowvalueconsumablesRules() {
	return {
		buyDate: [
			{
				required: true,
				message: '购入日期不能为空',
				trigger: 'blur'
			}
		],
		assetNo: [
			{
				required: true,
				message: '资产编号不能为空',
				trigger: 'blur'
			}
		],
		assetName: [
			{
				required: true,
				message: '资产名称不能为空',
				trigger: 'blur'
			}
		],
		specification: [
			{
				required: true,
				message: '规格型号不能为空',
				trigger: 'blur'
			}
		],
		number: [{ required: true, message: '数量不能为空', trigger: 'blur' }],
		measurementUnit: [
			{
				required: true,
				message: '计量单位不能为空',
				trigger: 'blur'
			}
		],
		amountIncludeTax: [
			{
				required: true,
				message: '含税金额不能为空',
				trigger: 'blur'
			},
			createAmountValidator('金额只能为数字且小数点后最多两位')
		],
		amountNoTax: [
			{
				required: true,
				message: '不含税金额不能为空',
				trigger: 'blur'
			},
			createAmountValidator('金额只能为数字且小数点后最多两位')
		],
		account: [
			{
				required: true,
				message: '户名名称不能为空',
				trigger: 'blur'
			}
		],
		scrapDate: [],
		saleDate: [
			{
				required: true,
				message: '销售日期不能为空',
				trigger: 'blur'
			}
		],
		saleAmount: []
	};
}
