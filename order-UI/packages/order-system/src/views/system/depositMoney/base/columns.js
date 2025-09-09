import { validationRules, validateAmount } from '@/api/tool';
import { DEPOSIT_TYPE, DEPOSIT_OPTIONS } from '@/api/tool/enums';

/**
 * 保证金管理 - 表格列配置和表单配置
 */
export default {
	// 表格列配置
	tableColumns: [
		{
			key: 'id',
			prop: 'id',
			label: 'ID',
			visible: false,
			includeInForm: false,
			width: 80
		},
		{
			key: 'depositCompany',
			prop: 'depositCompany',
			label: '保证金公司',
			visible: true,
			includeInForm: true,
			width: 120,
			showOverflowTooltip: true,
			formConfig: {
				type: 'input',
				show: true,
				required: true,
				placeholder: '请输入保证金公司',
				rules: validationRules.required,
				col: { span: 12 },
				order: 1
			}
		},
		{
			key: 'type',
			prop: 'type',
			label: '保证金类型',
			visible: true,
			includeInForm: true,
			width: 120,
			formConfig: {
				type: 'select',
				show: true,
				required: true,
				placeholder: '请选择保证金类型',
				rules: [{ required: true, message: '保证金类型不能为空', trigger: 'change' }],
				options: DEPOSIT_OPTIONS,
				optionLabel: 'label',
				optionValue: 'value',
				col: { span: 12 },
				order: 2
			}
		},
		{
			key: 'targetType',
			prop: 'targetType',
			label: '对象类型',
			visible: true,
			includeInForm: true,
			width: 100,
			formConfig: {
				type: 'select',
				show: true,
				required: true,
				placeholder: '请选择对象类型',
				rules: [{ required: true, message: '对象类型不能为空', trigger: 'change' }],
				options: [
					{ label: '员工', value: '员工' },
					{ label: '客户', value: '客户' },
					{ label: '供应商', value: '供应商' },
					{ label: '其他', value: '其他' }
				],
				optionLabel: 'label',
				optionValue: 'value',
				change: 'handleTargetTypeChange',
				col: { span: 12 },
				order: 3
			}
		},
		{
			key: 'target',
			prop: 'target',
			label: '对象名称',
			visible: true,
			includeInForm: true,
			width: 150,
			showOverflowTooltip: true,
			formConfig: {
				type: 'input',
				show: true,
				required: true,
				placeholder: '请输入对象名称',
				rules: validationRules.required,
				col: { span: 12 },
				order: 4
			}
		},
		{
			key: 'moneyAmount',
			prop: 'moneyAmount',
			label: '保证金金额',
			visible: true,
			includeInForm: true,
			width: 120,
			align: 'right',
			formConfig: {
				type: 'input',
				show: true,
				required: true,
				placeholder: '请输入保证金金额',
				rules: [
					{ required: true, message: '保证金金额不能为空', trigger: 'blur' },
					{ validator: validateAmount, trigger: 'blur' }
				],
				col: { span: 12 },
				order: 5
			}
		},
		{
			key: 'unrefundedAmount',
			prop: 'unrefundedAmount',
			label: '未退款金额',
			visible: true,
			includeInForm: false,
			width: 120,
			align: 'right'
		},
		{
			key: 'targetAccountsName',
			prop: 'targetAccountsName',
			label: '对方账户',
			visible: true,
			includeInForm: true,
			width: 150,
			showOverflowTooltip: true,
			formConfig: {
				type: 'bankSelect',
				show: true,
				required: true,
				placeholder: '请选择对方账户',
				rules: validationRules.required,
				col: { span: 12 },
				order: 6,
				bankType: 'other'
			}
		},
		{
			key: 'targetBankNo',
			prop: 'targetBankNo',
			label: '对方账号',
			visible: true,
			includeInForm: true,
			width: 180,
			formConfig: {
				type: 'input',
				show: true,
				readonly: true,
				placeholder: '自动填充',
				col: { span: 12 },
				order: 7
			}
		},
		{
			key: 'targetBankName',
			prop: 'targetBankName',
			label: '对方开户行',
			visible: true,
			includeInForm: true,
			width: 150,
			showOverflowTooltip: true,
			formConfig: {
				type: 'input',
				show: true,
				readonly: true,
				placeholder: '自动填充',
				col: { span: 12 },
				order: 8
			}
		},
		{
			key: 'selfAccountsName',
			prop: 'selfAccountsName',
			label: '我方收款账户',
			visible: true,
			includeInForm: true,
			width: 150,
			showOverflowTooltip: true,
			formConfig: {
				type: 'bankSelect',
				show: true,
				required: true,
				placeholder: '请选择我方账户',
				rules: validationRules.required,
				col: { span: 12 },
				order: 9,
				bankType: 'self'
			}
		},
		{
			key: 'selfBankNo',
			prop: 'selfBankNo',
			label: '我方账号',
			visible: true,
			includeInForm: true,
			width: 180,
			formConfig: {
				type: 'input',
				show: true,
				readonly: true,
				placeholder: '自动填充',
				col: { span: 12 },
				order: 10
			}
		},
		{
			key: 'selfBankName',
			prop: 'selfBankName',
			label: '我方开户行',
			visible: true,
			includeInForm: true,
			width: 150,
			showOverflowTooltip: true,
			formConfig: {
				type: 'input',
				show: true,
				readonly: true,
				placeholder: '自动填充',
				col: { span: 12 },
				order: 11
			}
		},
		{
			key: 'depositDate',
			prop: 'depositDate',
			label: '收取时间',
			visible: true,
			includeInForm: true,
			width: 160,
			formConfig: {
				type: 'datetime',
				show: true,
				required: true,
				placeholder: '请选择收取时间',
				rules: [{ required: true, message: '收取时间不能为空', trigger: 'change' }],
				col: { span: 12 },
				order: 12
			}
		},
		{
			key: 'reason',
			prop: 'reason',
			label: '事由',
			visible: true,
			includeInForm: true,
			width: 150,
			showOverflowTooltip: true,
			formConfig: {
				type: 'input',
				show: true,
				required: true,
				placeholder: '请输入事由',
				rules: validationRules.required,
				col: { span: 12 },
				order: 13
			}
		},
		{
			key: 'comments',
			prop: 'comments',
			label: '备注',
			visible: true,
			includeInForm: true,
			width: 150,
			showOverflowTooltip: true,
			formConfig: {
				type: 'textarea',
				show: true,
				placeholder: '请输入备注',
				rows: 3,
				col: { span: 24 },
				order: 14
			}
		},
		{
			key: 'addtime',
			prop: 'addtime',
			label: '添加时间',
			visible: false,
			includeInForm: false,
			width: 160
		},
		{
			key: 'UserName',
			prop: 'UserName',
			label: '操作人员',
			visible: true,
			includeInForm: false,
			width: 100
		}
	],

	// 查询表单配置
	queryFormConfig: [
		{
			key: 'depositCompany',
			label: '保证金公司',
			type: 'input',
			placeholder: '请输入保证金公司'
		},
		{
			key: 'type',
			label: '保证金类型',
			type: 'select',
			placeholder: '请选择保证金类型',
			options: DEPOSIT_OPTIONS,
			optionLabel: 'label',
			optionValue: 'value'
		},
		{
			key: 'targetType',
			label: '对象类型',
			type: 'select',
			placeholder: '请选择对象类型',
			options: [
				{ label: '员工', value: '员工' },
				{ label: '客户', value: '客户' },
				{ label: '供应商', value: '供应商' },
				{ label: '其他', value: '其他' }
			],
			optionLabel: 'label',
			optionValue: 'value'
		},
		{
			key: 'target',
			label: '对象名称',
			type: 'input',
			placeholder: '请输入对象名称'
		},
		{
			key: 'depositDate',
			label: '收取时间',
			type: 'daterange',
			placeholder: ['开始日期', '结束日期']
		}
	],

	// 常量引用
	constants: {
		DEPOSIT_TYPE,
		DEPOSIT_OPTIONS
	}
};
