// 根据对应表名返回特定方法
import { TableName } from '@/api/tool/enums';
import { getGoodsOrder } from '@/api/system/goodsOrder';
import { getPayment } from '@/api/system/payment';
import { getInvoiceIn } from '@/api/system/invoiceIn';
import { getInvoiceOut } from '@/api/system/invoiceOut';
import { getInvoiceOther } from '@/api/system/invoiceOther';
import { getOffsetting } from '@/api/system/Offsetting';
import { getRebate } from '@/api/system/Rebate';
import { getInventory } from '@/api/system/inventory';
import { getOrderDetail } from '@/api/system/orderDetail';

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
    case TableName.INVENTORY:
      return getInventory;
    case TableName.ORDER_DETAIL:
      return getOrderDetail
  }
}
