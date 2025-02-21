import { getBalanceAccounts } from '../../api/system/BalanceAccounts';
import { getBankAcceptance } from '../../api/system/bankAcceptance';
import { getBorrowedMoney } from '../../api/system/borrowedMoney';
import { getBusinessTrip } from '../../api/system/BusinessTrip';
import { getCarApply } from '../../api/system/carApply';
import { getCars } from '../../api/system/cars';
import { getCompany } from '../../api/system/company';
import { getCustomerVisit } from '../../api/system/CustomerVisit';
import { getDetail } from '../../api/system/detail';
import { getExWarehouse } from '../../api/system/exWarehouse';
import { getFixedAssets } from '../../api/system/fixedAssets';
import { getFleet } from '../../api/system/fleet';
import { getGoodsOrder } from '../../api/system/goodsOrder';
import { getInventory } from '../../api/system/inventory';
import { getInventoryMain } from '../../api/system/inventoryMain';
import { getInvoiceIn } from '../../api/system/invoiceIn';
import { getInvoiceOther } from '../../api/system/invoiceOther';
import { getInvoiceOut } from '../../api/system/invoiceOut';
import { getLendMoney } from '../../api/system/lendMoney';
import { getOffsetting } from '../../api/system/Offsetting';
import { getOilCard } from '../../api/system/oilCard';
import { getOilCardConsume } from '../../api/system/OilCardConsume';
import { getOilCardFundTransfer } from '../../api/system/oilCardFundTransfer';
import { getOilRecharge } from '../../api/system/oilRecharge';
import { getOrderDetail } from '../../api/system/orderDetail';
import { getOrderFreight } from '../../api/system/orderFreight';
import { getPayment } from '../../api/system/payment';
import { getProductLevel } from '../../api/system/productLevel';
import { getRebate } from '../../api/system/Rebate';
import { getReceiveMoney } from '../../api/system/receiveMoney';
import { getRecoverMoney } from '../../api/system/recoverMoney';
import { getRepayment } from '../../api/system/repayment';
import { getSocialInsurance } from '../../api/system/socialInsurance';
import { getStoreHouse } from '../../api/system/StoreHouse';
import { TableName } from '../../api/tool/enums';
import { getGenTable } from '../../api/tool/gen';
import { getRecord } from '@/api/system/record';

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
			return getRecord;
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
		// 2025-01-24新增
		case TableName.BORROWED_MONEY:
			return getBorrowedMoney;
		case TableName.BUSINESS_TRIP:
			return getBusinessTrip;
		case TableName.CAR_APPLY:
			return getCarApply;
		case TableName.CARS:
			return getCars;
		case TableName.COMPANY:
			return getCompany;
		case TableName.CUSTOMER_VISIT:
			return getCustomerVisit;
		case TableName.EX_WAREHOUSE:
			return getExWarehouse;
		case TableName.FIXED_ASSETS:
			return getFixedAssets;
		case TableName.FLEET:
			return getFleet;
		case TableName.GEN_TABLE:
			return getGenTable;
		case TableName.INVENTORY:
			return getInventory;
		case TableName.LEND_MONEY:
			return getLendMoney;
		case TableName.OIL_CARD:
			return getOilCard;
		case TableName.OIL_CARD_CONSUME:
			return getOilCardConsume;
		case TableName.OIL_CARD_FUND_TRANSFER:
			return getOilCardFundTransfer;
		case TableName.OIL_RECHARGE:
			return getOilRecharge;
		case TableName.ORDER_FREIGHT:
			return getOrderFreight;
		case TableName.PRODUCT_LEVEL:
			return getProductLevel;
		case TableName.RECEIVE_MONEY:
			return getReceiveMoney;
		case TableName.RECOVER_MONEY:
			return getRecoverMoney;
		case TableName.REPAYMENT:
			return getRepayment;
		case TableName.SOCIAL_INSURANCE:
			return getSocialInsurance;
		case TableName.BALANCEACCOUNT:
			return getBalanceAccounts;
		case TableName.STOREHOUSE:
			return getStoreHouse;
		case TableName.BANK_ACCEPTANCE:
			return getBankAcceptance;
	}
}
