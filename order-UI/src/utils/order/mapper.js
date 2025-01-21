// 根据对应表名返回特定方法
import { getBankAcceptance } from '@/api/system/bankAcceptance';
import { getGoodsOrder } from '@/api/system/goodsOrder';
import { getInvoiceIn } from '@/api/system/invoiceIn';
import { getInvoiceOther } from '@/api/system/invoiceOther';
import { getInvoiceOut } from '@/api/system/invoiceOut';
import { getOffsetting } from '@/api/system/Offsetting';
import { getOrderDetail } from '@/api/system/orderDetail';
import { getPayment } from '@/api/system/payment';
import { getRebate } from '@/api/system/Rebate';
import { TableName } from '@/api/tool/enums';
import { getDetail } from '../../api/system/detail';
import { getInventoryMain } from '../../api/system/inventoryMain';

export function getFunction(tableName) {
	switch (tableName) {
		case TableName.GOODS_ORDER:
			return getGoodsOrder;
		case TableName.PAYMENT:
			return getPayment;
		case TableName.INVOICE_IN:
			return getInvoiceIn;
		case TableName.INVOICE_OUT:
			return getInvoiceOut;
		case TableName.INVOICE_OTHER:
			return getInvoiceOther;
		case TableName.OFFSETTING:
			return getOffsetting;
		case TableName.REBATE:
			return getRebate;
		case TableName.INVENTORMAIN:
			return getInventoryMain;
		case TableName.INVENTORDETAIL:
			return getDetail;
		case TableName.ORDER_DETAIL:
			return getOrderDetail;
		case TableName.BANK_ACCOUNT_CHANGE:
			return getBankAcceptance;
	}
}
