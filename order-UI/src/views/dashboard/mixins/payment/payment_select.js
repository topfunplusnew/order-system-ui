export const PAYMENT_TYPES = {
	SUPPLIER: '供应商',
	DRIVER: '司机',
	CUSTOMER: '客户'
};
export var mixin_payment_select = {
	data() {
		return {
			options: [
				{
					value: '客户',
					label: '客户'
				},
				{
					value: '供应商',
					label: '供应商'
				},
				{
					value: '司机',
					label: '司机'
				}
			],
			value: '客户'
		};
	},
	methods: {}
};
