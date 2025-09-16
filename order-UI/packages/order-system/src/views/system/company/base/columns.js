// 统一的验证规则和工具方法
import { requiredRule, stringRule, phoneRule, optionalPhoneRule, maxLengthRule } from '@/api/tool';

// 公司管理模块配置
export const companyConfig = {
	// 表格列配置（所有列都支持includeInForm属性，默认为true）
	tableColumns: [
		{
			prop: 'id',
			label: 'ID',
			width: 80,
			align: 'center',
			showOverflowTooltip: false, // 禁用默认 tooltip，使用自定义 popover
			autoWidth: false, // 固定宽度，不自适应
			includeInForm: false, // ID不包含在表单中
			formConfig: {
				show: false
			}
		},
		{
			prop: 'companyName',
			label: '客户名称',
			width: 150,
			align: 'center',
			showOverflowTooltip: false, // 禁用默认 tooltip，使用自定义 popover
			autoWidth: true, // 开启自适应宽度
			minWidth: 120, // 最小宽度
			maxWidth: 300, // 最大宽度
			includeInForm: true, // 明确包含在表单中
			formConfig: {
				show: true,
				type: 'input',
				order: 1,
				sortIndex: 1, // 表单项排序索引
				col: { span: 12 },
				placeholder: '请输入客户名称',
				rules: [{ required: true, message: '请输入客户名称', trigger: 'blur' }, stringRule(), maxLengthRule(50)]
			}
		},
		{
			prop: 'leader',
			label: '老板姓名',
			width: 120,
			align: 'center',
			showOverflowTooltip: false, // 禁用默认 tooltip，使用自定义 popover
			autoWidth: true, // 开启自适应宽度
			minWidth: 100,
			maxWidth: 200,
			includeInForm: true,
			formConfig: {
				show: true,
				type: 'input',
				order: 2,
				sortIndex: 2, // 表单项排序索引
				col: { span: 12 },
				placeholder: '请输入老板姓名',
				rules: [stringRule(), maxLengthRule(20)]
			}
		},
		{
			prop: 'leaderTel',
			label: '老板电话',
			width: 120,
			align: 'center',
			showOverflowTooltip: false, // 禁用默认 tooltip，使用自定义 popover
			autoWidth: true, // 开启自适应宽度
			minWidth: 110,
			maxWidth: 160,
			includeInForm: true,
			formConfig: {
				show: true,
				type: 'input',
				order: 3,
				sortIndex: 3, // 表单项排序索引
				col: { span: 12 },
				placeholder: '请输入老板电话',
				rules: [optionalPhoneRule()] // 使用可选手机号验证规则
			}
		},
		{
			prop: 'relationName',
			label: '联系人',
			width: 100,
			align: 'center',
			showOverflowTooltip: false, // 禁用默认 tooltip，使用自定义 popover
			autoWidth: true, // 开启自适应宽度
			minWidth: 80,
			maxWidth: 150,
			includeInForm: true,
			formConfig: {
				show: true,
				type: 'input',
				order: 4,
				sortIndex: 4, // 表单项排序索引
				col: { span: 12 },
				placeholder: '请输入联系人',
				rules: [{ required: true, message: '请输入联系人', trigger: 'blur' }, stringRule(), maxLengthRule(20)]
			}
		},
		{
			prop: 'salesManager',
			label: '销售经理',
			width: 120,
			align: 'center',
			showOverflowTooltip: false, // 禁用默认 tooltip，使用自定义 popover
			autoWidth: true, // 开启自适应宽度
			minWidth: 100,
			maxWidth: 180,
			includeInForm: true,
			formConfig: {
				show: true,
				type: 'input',
				order: 5,
				sortIndex: 5, // 表单项排序索引
				col: { span: 12 },
				placeholder: '请输入销售经理',
				rules: [{ required: true, message: '请输入销售经理', trigger: 'blur' }, stringRule(), maxLengthRule(20)]
			}
		},
		{
			prop: 'relationTel',
			label: '电话',
			width: 120,
			align: 'center',
			showOverflowTooltip: false, // 禁用默认 tooltip，使用自定义 popover
			autoWidth: true, // 开启自适应宽度
			minWidth: 110,
			maxWidth: 160,
			includeInForm: true,
			formConfig: {
				show: true,
				type: 'input',
				order: 6,
				sortIndex: 6, // 表单项排序索引
				col: { span: 12 },
				placeholder: '请输入联系人电话',
				rules: [{ required: true, message: '请输入联系人电话', trigger: 'blur' }, phoneRule()] // 必填且校验手机号格式
			}
		},
		{
			prop: 'region',
			label: '区域',
			width: 100,
			align: 'center',
			showOverflowTooltip: false, // 禁用默认 tooltip，使用自定义 popover
			autoWidth: true, // 开启自适应宽度
			minWidth: 80,
			maxWidth: 150,
			includeInForm: false, // 表格列不直接对应表单项
			// 表格显示时的值计算函数
			formatter: row => {
				const parts = [row.province, row.city, row.county].filter(Boolean);
				return parts.join(' - ') || '';
			},
			// 虚拟列配置 - 由多个表单项组成
			virtualColumn: true,
			// 关联的表单项
			formItems: ['province', 'city', 'county']
		},
		// 省份表单项（不在表格中显示）
		{
			prop: 'province',
			label: '省份',
			includeInForm: true,
			includeInTable: false, // 不在表格中显示
			formConfig: {
				show: true,
				type: 'select',
				order: 7,
				sortIndex: 7, // 表单项排序索引
				col: { span: 8 },
				placeholder: '请选择省份',
				options: 'provinceList',
				optionLabel: 'name',
				optionValue: 'name',
				change: 'changeProvince',
				rules: [{ required: true, message: '请选择省份', trigger: 'change' }, stringRule(), maxLengthRule(50)]
			}
		},
		// 城市表单项（不在表格中显示）
		{
			prop: 'city',
			label: '城市',
			includeInForm: true,
			includeInTable: false, // 不在表格中显示
			formConfig: {
				show: true,
				type: 'select',
				order: 8,
				sortIndex: 8, // 表单项排序索引
				col: { span: 8 },
				placeholder: '请选择城市',
				options: 'cityList',
				optionLabel: 'name',
				optionValue: 'name',
				change: 'changeCity',
				rules: [{ required: true, message: '请选择城市', trigger: 'change' }, stringRule(), maxLengthRule(50)]
			}
		},
		// 区县表单项（不在表格中显示）
		{
			prop: 'county',
			label: '区县',
			includeInForm: true,
			includeInTable: false, // 不在表格中显示
			formConfig: {
				show: true,
				type: 'select',
				order: 9,
				sortIndex: 9, // 表单项排序索引
				col: { span: 8 },
				placeholder: '请选择区县',
				options: 'districtList',
				optionLabel: 'name',
				optionValue: 'name',
				rules: [stringRule(), maxLengthRule(50)]
			}
		},
		{
			prop: 'address',
			label: '地址',
			width: 200,
			align: 'center',
			showOverflowTooltip: false, // 禁用默认 tooltip，使用自定义 popover
			autoWidth: true, // 开启自适应宽度
			minWidth: 150,
			maxWidth: 400,
			includeInForm: true,
			formConfig: {
				show: true,
				type: 'textarea',
				order: 10,
				sortIndex: 10, // 表单项排序索引
				col: { span: 24 },
				placeholder: '请输入地址',
				rows: 3,
				rules: [stringRule(), maxLengthRule(200)]
			}
		},
		{
			prop: 'comments',
			label: '备注',
			width: 200,
			align: 'center',
			showOverflowTooltip: false, // 禁用默认 tooltip，使用自定义 popover
			autoWidth: true, // 开启自适应宽度
			minWidth: 120,
			maxWidth: 300,
			includeInForm: true,
			formConfig: {
				show: true,
				type: 'textarea',
				order: 11,
				sortIndex: 11, // 表单项排序索引
				col: { span: 24 },
				placeholder: '请输入备注',
				rows: 2,
				rules: [stringRule(), maxLengthRule(200)]
			}
		}
	]
};

// 导出默认配置
export default companyConfig;
