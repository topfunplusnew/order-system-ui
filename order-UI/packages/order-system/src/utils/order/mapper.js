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
import CARS from '@/components/NeedToShow/CARS.vue';
import BORROWMONEY from '@/components/NeedToShow/BORROWMONEY.vue';
import ORDER_FREIGHT from '@/components/NeedToShow/ORDER_FREIGHT.vue';
import OIL_RECHARGE from '@/components/NeedToShow/OIL_RECHARGE.vue';
import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
import ORDER_COMMISION from '@/components/NeedToShow/ORDER_COMMISION.vue';
import { getCommission } from '@/api/commission';
import ORDER_DETAIL from '@/components/NeedToShow/ORDER_DETAIL.vue';
import BUSSNIESS_TRIP from '@/components/NeedToShow/BUSSNIESS_TRIP.vue';

// 根据表名  获取对应的get函数方法
export function getFunction(tableName) {
	switch (tableName) {
		// 订单列表
		case TableName.GOODS_ORDER:
			return getGoodsOrder;
		case TableName.ORDER_DETAIL:
			return getOrderDetail;
		// 订单佣金信息
		case TableName.ORDERCOMMISION:
			return getCommission;
		// 付款
		case TableName.PAYMENT:
			return getPayment;
		// 发票的三个 收入支出和第三方
		case TableName.INVOICE_IN:
			return getInvoiceIn;
		case TableName.INVOICE_OUT:
			return getInvoiceOut;
		case TableName.INVOICE_OTHER:
			return getInvoiceOther;
		// 冲抵货款 后来改为cash record
		case TableName.OFFSETTING:
			return getRecord;
		// 返利信息
		case TableName.REBATE:
			return getRebate;
		// 库存的主表和从表
		case TableName.INVENTORMAIN:
			return getInventoryMain;
		case TableName.INVENTORDETAIL:
			return getDetail;
		// 虚拟资金变动
		case TableName.BANK_ACCOUNT_CHANGE:
			return getBankAcceptance;
		// 借款信息
		case TableName.BORROWED_MONEY:
			return getBorrowedMoney;
		// 出差信息
		case TableName.BUSINESS_TRIP:
			return getBusinessTrip;
		// 车辆申请
		case TableName.CAR_APPLY:
			return getCarApply;
		// 外部车辆信息
		case TableName.CARS:
			return getCars;
		// 客户或者供应商信息
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

// 这个方法可以根据表名获取对应的组件 然后展示
export class TableComponentsTools {
	getComponentsByTableName(tableName) {
		if (!tableName) {
			this.$message.error('getComponentsByTableName函数调用出错，表名或表ID为空');
			throw new Error('getComponentsByTableName函数调用出错，表名为空');
		}
		switch (tableName) {
			// 如果是订单信息
			case TableName.GOODS_ORDER: {
				return GOODS_ORDER;
			}
			// 如果是订单佣金
			case TableName.ORDERCOMMISION: {
				return ORDER_COMMISION;
			}
			// 订单个体信息
			case TableName.ORDER_DETAIL: {
				return ORDER_DETAIL;
			}
			// 如果是车辆信息
			case TableName.CARS: {
				return CARS;
			}
			// 如果是借钱信息
			case TableName.BORROWED_MONEY: {
				return BORROWMONEY;
			}
			// 如果是订单运费
			case TableName.ORDER_FREIGHT: {
				return ORDER_FREIGHT;
			}
			// 如果是油卡充值
			case TableName.OIL_RECHARGE: {
				return OIL_RECHARGE;
			}
			// 如果是发票购入
			case TableName.INVOICE_IN: {
				return INVOICE_IN;
			}
			// 如果是出差
			case TableName.BUSINESS_TRIP: {
				return BUSSNIESS_TRIP;
			}
		}
	}

	// 根据表名获取对应的信息
	async getInformationByTableName(tableName, tID) {
		if (!tableName || !tID) {
			this.$message.error('getInformationByTableName函数调用出错，表名或表ID为空');
			throw new Error('getInformationByTableName函数调用出错，表名或表ID为空');
		}
		const { data } = await getFunction(tableName)(tID);
		return data;
	}
}
