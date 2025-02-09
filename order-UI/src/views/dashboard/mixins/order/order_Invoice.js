import { PUBLIC_DICT_TYPE } from '@/utils/order';
import Invoice from '@/views/dashboard/components/goodsOrder/Invoice.vue';
import { getCompany } from '../../../../api/system/company';
import { getGoodsOrder } from '../../../../api/system/goodsOrder';
// 状态
export const Options = [
	{
		value: '已审核',
		label: '已审核'
	},
	{
		value: '未审核',
		label: '未审核'
	}
];

export const OptionInvent = [
	{
		value: 1,
		label: '是'
	},
	{
		value: 0,
		label: '否'
	}
];
/**
 * 客户或者供应商发票功能
 */
export var mixin_order_Invoice = {
	data: function () {
		return {
			// 查询字段
			queryCompanyName: '',
			// 开票选择
			options: Options,
			optionsInvoice: OptionInvent,
			// 开票最大金额
			maxInvent: 0
		};
	},
	methods: {
		// 判断是否含税
		hasInvoice(row, type) {
			return type === PUBLIC_DICT_TYPE.CUSTOMER
				? row.smailOrderDetails.some(item => {
						return item.isIncludeTaxSale === 1;
				  })
				: row.smailOrderDetails.some(item => {
						return item.isIncludeTaxFactory === 1;
				  });
		},
		// 点击客户开票按钮 客户开票 最大开票金额为总货款
		updateOrderItemVisibleCustomerInvoice(row) {
			// 开票实体对象
			const invoiceInfo = {
				domain: 1,
				isOrderTax: row.id
			};
			// 设置该订单信息 需要进行一次查询 获取订单的开票个数
			getGoodsOrder(row.id).then(res => {
				invoiceInfo.orderInfo = res.data;
				// 保存客户和供应商开票个数
				invoiceInfo.customerInvoiceNumber = res.data.customerIsInvoice;
				invoiceInfo.supplierInvoiceNumber = res.data.isSupplierInvoice;
				// 补充最大金额 最大金额为总货款
				this.maxInvent = res.data.allPayments;
				// 打开弹窗
				this.openDialog(
					Invoice,
					'客户开票',
					undefined,
					{
						invoiceInfo: invoiceInfo,
						maxInvent: this.maxInvent
					},
					false
				);
			});
		},
		// 点击供应商开票按钮 如果是供应商开票 则是订单详情中该供应商对应的订单货物的出厂货款
		updateOrderItemVisibleSupplierInvoice(row, supplierID) {
			// 开票实体对象
			const invoiceInfo = {
				domain: 2,
				isOrderTax: row.id
			};
			// 更新订单信息的函数
			const updateGoodsOrder = row => {
				// 更新订单信息
				getGoodsOrder(row.id).then(res => {
					invoiceInfo.orderInfo = res.data;
					// 保存客户和供应商开票个数
					invoiceInfo.customerInvoiceNumber = res.data.customerIsInvoice;
					invoiceInfo.supplierInvoiceNumber = res.data.isSupplierInvoice;
					// 补充最大金额 最大金额为出厂货款
					res.data.orderDetailList.forEach(item => {
						this.maxInvent += item.paymentFactory;
					});
					// 打开弹窗
					this.openDialog(
						Invoice,
						'供应商开票',
						undefined,
						{
							invoiceInfo: invoiceInfo,
							maxInvent: this.maxInvent
						},
						false
					);
				});
			};
			// 如果供应商ID不存在 直接更新
			if (!supplierID) {
				updateGoodsOrder(row);
				return;
			}
			invoiceInfo.companyID = supplierID;
			// 获取公司信息 然后更新订单信息
			getCompany(supplierID, PUBLIC_DICT_TYPE.SUPPLIER).then(res => {
				invoiceInfo.companyName = res.data.companyName;
				invoiceInfo.companyType = res.data.companyType;
				// 然后查询订单详情，拿到开票的个数 这个个数是拿来展示视图
				updateGoodsOrder(row);
			});
		}
	}
};
