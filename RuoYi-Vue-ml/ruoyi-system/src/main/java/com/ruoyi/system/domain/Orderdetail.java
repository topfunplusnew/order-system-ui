package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 订单详情对象 orderdetail
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public class Orderdetail extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 订单详情ID */
    @Excel(name = "订单详情ID")
    private Long orderId;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号", readConverterExp = "U=UID")
    private String ordersNo;

    /** 订单日期 */
    @Excel(name = "订单日期")
    private String orderDate;

    /** 供应商 */
    @Excel(name = "供应商")
    private String supplier;

    /** 供应商ID */
    @Excel(name = "供应商ID")
    private Long supplierId;

    /** 客户 */
    @Excel(name = "客户")
    private String customer;

    /** 客户ID */
    @Excel(name = "客户ID")
    private Long customerId;

    /** 级别编码 */
    @Excel(name = "级别编码")
    private Long levelID;

    /** 级别名称 */
    @Excel(name = "级别名称")
    private String levelName;

    /** 计量单位 */
    @Excel(name = "计量单位")
    private String countingUnit;

    /** 厚度 */
    @Excel(name = "厚度")
    private Long height;

    /** 长度 */
    @Excel(name = "长度")
    private Long length;

    /** 宽度 */
    @Excel(name = "宽度")
    private Long width;

    /** 出厂片数 */
    @Excel(name = "出厂片数")
    private Long pieces;

    /** 每包片数 */
    @Excel(name = "每包片数")
    private Long piecesPerPack;

    /** 包数 */
    @Excel(name = "包数")
    private Long packs;

    /** 出厂单价 */
    @Excel(name = "出厂单价")
    private Long price;

    /** 出厂是否含税 */
    @Excel(name = "出厂是否含税")
    private Long isIncludeTaxFactory;

    /** 杂费 */
    @Excel(name = "杂费")
    private Long sundryCost;

    /** 出厂货款 */
    @Excel(name = "出厂货款")
    private Long paymentFactory;

    /** 卸货价 */
    @Excel(name = "卸货价")
    private Long paymentUnload;

    /** 销售是否含税 */
    @Excel(name = "销售是否含税")
    private Long isIncludeTaxSale;

    /** 总货款 */
    @Excel(name = "总货款")
    private Long payments;

    /** 误差 */
    @Excel(name = "误差")
    private Long erro;

    /** 吨位 */
    @Excel(name = "吨位")
    private Long tonnage;

    /** 陆运费单价 */
    @Excel(name = "陆运费单价")
    private Long landFreightPrice;

    /** 陆运费 */
    @Excel(name = "陆运费")
    private Long landFreight;

    /** 海运费 */
    @Excel(name = "海运费")
    private Long seaFreight;

    /** 总运费 */
    @Excel(name = "总运费")
    private Long freight;

    /** 其他费用 */
    @Excel(name = "其他费用")
    private Long otherCost;

    /** 利润 */
    @Excel(name = "利润")
    private Long profit;

    /** 不含税利润 */
    @Excel(name = "不含税利润")
    private Long profitNoTax;

    /** 实际片数 */
    @Excel(name = "实际片数")
    private Long actualPieces;

    /** 总货款杂费 */
    @Excel(name = "总货款杂费")
    private Long paymentsWithSundry;

    /** 加费 */
    @Excel(name = "加费")
    private Long additionalFees;

    /** 仓库ID */
    @Excel(name = "仓库ID")
    private Long storeHouseID;

    /** 仓库名称 */
    @Excel(name = "仓库名称")
    private String storeHouseName;

    /** 仓库存储的货物ID */
    @Excel(name = "仓库存储的货物ID")
    private Long storeID;

    /** 物流利润 */
    @Excel(name = "物流利润")
    private Long logisticsProfit;

    /** 客户佣金 */
    @Excel(name = "客户佣金")
    private Long customerCommission;

    /** 是否被调整单（ 是  否） */
    @Excel(name = "是否被调整单", readConverterExp = "是=,否=")
    private String isAdjusted;

    /** 调整日期 */
    @Excel(name = "调整日期")
    private String adjustDate;

    /** 作废标记 */
    @Excel(name = "作废标记")
    private Long cancelFlag;

    /** 备注 */
    @Excel(name = "备注")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    private String UserName;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setOrderId(Long orderId) 
    {
        this.orderId = orderId;
    }

    public Long getOrderId() 
    {
        return orderId;
    }
    public void setOrdersNo(String ordersNo) 
    {
        this.ordersNo = ordersNo;
    }

    public String getOrdersNo() 
    {
        return ordersNo;
    }
    public void setOrderDate(String orderDate) 
    {
        this.orderDate = orderDate;
    }

    public String getOrderDate() 
    {
        return orderDate;
    }
    public void setSupplier(String supplier) 
    {
        this.supplier = supplier;
    }

    public String getSupplier() 
    {
        return supplier;
    }
    public void setSupplierId(Long supplierId) 
    {
        this.supplierId = supplierId;
    }

    public Long getSupplierId() 
    {
        return supplierId;
    }
    public void setCustomer(String customer) 
    {
        this.customer = customer;
    }

    public String getCustomer() 
    {
        return customer;
    }
    public void setCustomerId(Long customerId) 
    {
        this.customerId = customerId;
    }

    public Long getCustomerId() 
    {
        return customerId;
    }
    public void setLevelID(Long levelID) 
    {
        this.levelID = levelID;
    }

    public Long getLevelID() 
    {
        return levelID;
    }
    public void setLevelName(String levelName) 
    {
        this.levelName = levelName;
    }

    public String getLevelName() 
    {
        return levelName;
    }
    public void setCountingUnit(String countingUnit) 
    {
        this.countingUnit = countingUnit;
    }

    public String getCountingUnit() 
    {
        return countingUnit;
    }
    public void setHeight(Long height) 
    {
        this.height = height;
    }

    public Long getHeight() 
    {
        return height;
    }
    public void setLength(Long length) 
    {
        this.length = length;
    }

    public Long getLength() 
    {
        return length;
    }
    public void setWidth(Long width) 
    {
        this.width = width;
    }

    public Long getWidth() 
    {
        return width;
    }
    public void setPieces(Long pieces) 
    {
        this.pieces = pieces;
    }

    public Long getPieces() 
    {
        return pieces;
    }
    public void setPiecesPerPack(Long piecesPerPack) 
    {
        this.piecesPerPack = piecesPerPack;
    }

    public Long getPiecesPerPack() 
    {
        return piecesPerPack;
    }
    public void setPacks(Long packs) 
    {
        this.packs = packs;
    }

    public Long getPacks() 
    {
        return packs;
    }
    public void setPrice(Long price) 
    {
        this.price = price;
    }

    public Long getPrice() 
    {
        return price;
    }
    public void setIsIncludeTaxFactory(Long isIncludeTaxFactory) 
    {
        this.isIncludeTaxFactory = isIncludeTaxFactory;
    }

    public Long getIsIncludeTaxFactory() 
    {
        return isIncludeTaxFactory;
    }
    public void setSundryCost(Long sundryCost) 
    {
        this.sundryCost = sundryCost;
    }

    public Long getSundryCost() 
    {
        return sundryCost;
    }
    public void setPaymentFactory(Long paymentFactory) 
    {
        this.paymentFactory = paymentFactory;
    }

    public Long getPaymentFactory() 
    {
        return paymentFactory;
    }
    public void setPaymentUnload(Long paymentUnload) 
    {
        this.paymentUnload = paymentUnload;
    }

    public Long getPaymentUnload() 
    {
        return paymentUnload;
    }
    public void setIsIncludeTaxSale(Long isIncludeTaxSale) 
    {
        this.isIncludeTaxSale = isIncludeTaxSale;
    }

    public Long getIsIncludeTaxSale() 
    {
        return isIncludeTaxSale;
    }
    public void setPayments(Long payments) 
    {
        this.payments = payments;
    }

    public Long getPayments() 
    {
        return payments;
    }
    public void setErro(Long erro) 
    {
        this.erro = erro;
    }

    public Long getErro() 
    {
        return erro;
    }
    public void setTonnage(Long tonnage) 
    {
        this.tonnage = tonnage;
    }

    public Long getTonnage() 
    {
        return tonnage;
    }
    public void setLandFreightPrice(Long landFreightPrice) 
    {
        this.landFreightPrice = landFreightPrice;
    }

    public Long getLandFreightPrice() 
    {
        return landFreightPrice;
    }
    public void setLandFreight(Long landFreight) 
    {
        this.landFreight = landFreight;
    }

    public Long getLandFreight() 
    {
        return landFreight;
    }
    public void setSeaFreight(Long seaFreight) 
    {
        this.seaFreight = seaFreight;
    }

    public Long getSeaFreight() 
    {
        return seaFreight;
    }
    public void setFreight(Long freight) 
    {
        this.freight = freight;
    }

    public Long getFreight() 
    {
        return freight;
    }
    public void setOtherCost(Long otherCost) 
    {
        this.otherCost = otherCost;
    }

    public Long getOtherCost() 
    {
        return otherCost;
    }
    public void setProfit(Long profit) 
    {
        this.profit = profit;
    }

    public Long getProfit() 
    {
        return profit;
    }
    public void setProfitNoTax(Long profitNoTax) 
    {
        this.profitNoTax = profitNoTax;
    }

    public Long getProfitNoTax() 
    {
        return profitNoTax;
    }
    public void setActualPieces(Long actualPieces) 
    {
        this.actualPieces = actualPieces;
    }

    public Long getActualPieces() 
    {
        return actualPieces;
    }
    public void setPaymentsWithSundry(Long paymentsWithSundry) 
    {
        this.paymentsWithSundry = paymentsWithSundry;
    }

    public Long getPaymentsWithSundry() 
    {
        return paymentsWithSundry;
    }
    public void setAdditionalFees(Long additionalFees) 
    {
        this.additionalFees = additionalFees;
    }

    public Long getAdditionalFees() 
    {
        return additionalFees;
    }
    public void setStoreHouseID(Long storeHouseID) 
    {
        this.storeHouseID = storeHouseID;
    }

    public Long getStoreHouseID() 
    {
        return storeHouseID;
    }
    public void setStoreHouseName(String storeHouseName) 
    {
        this.storeHouseName = storeHouseName;
    }

    public String getStoreHouseName() 
    {
        return storeHouseName;
    }
    public void setStoreID(Long storeID) 
    {
        this.storeID = storeID;
    }

    public Long getStoreID() 
    {
        return storeID;
    }
    public void setLogisticsProfit(Long logisticsProfit) 
    {
        this.logisticsProfit = logisticsProfit;
    }

    public Long getLogisticsProfit() 
    {
        return logisticsProfit;
    }
    public void setCustomerCommission(Long customerCommission) 
    {
        this.customerCommission = customerCommission;
    }

    public Long getCustomerCommission() 
    {
        return customerCommission;
    }
    public void setIsAdjusted(String isAdjusted) 
    {
        this.isAdjusted = isAdjusted;
    }

    public String getIsAdjusted() 
    {
        return isAdjusted;
    }
    public void setAdjustDate(String adjustDate) 
    {
        this.adjustDate = adjustDate;
    }

    public String getAdjustDate() 
    {
        return adjustDate;
    }
    public void setCancelFlag(Long cancelFlag) 
    {
        this.cancelFlag = cancelFlag;
    }

    public Long getCancelFlag() 
    {
        return cancelFlag;
    }
    public void setComments(String comments) 
    {
        this.comments = comments;
    }

    public String getComments() 
    {
        return comments;
    }
    public void setAddtime(String addtime) 
    {
        this.addtime = addtime;
    }

    public String getAddtime() 
    {
        return addtime;
    }
    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }
    public void setUserName(String UserName) 
    {
        this.UserName = UserName;
    }

    public String getUserName() 
    {
        return UserName;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("orderId", getOrderId())
            .append("ordersNo", getOrdersNo())
            .append("orderDate", getOrderDate())
            .append("supplier", getSupplier())
            .append("supplierId", getSupplierId())
            .append("customer", getCustomer())
            .append("customerId", getCustomerId())
            .append("levelID", getLevelID())
            .append("levelName", getLevelName())
            .append("countingUnit", getCountingUnit())
            .append("height", getHeight())
            .append("length", getLength())
            .append("width", getWidth())
            .append("pieces", getPieces())
            .append("piecesPerPack", getPiecesPerPack())
            .append("packs", getPacks())
            .append("price", getPrice())
            .append("isIncludeTaxFactory", getIsIncludeTaxFactory())
            .append("sundryCost", getSundryCost())
            .append("paymentFactory", getPaymentFactory())
            .append("paymentUnload", getPaymentUnload())
            .append("isIncludeTaxSale", getIsIncludeTaxSale())
            .append("payments", getPayments())
            .append("erro", getErro())
            .append("tonnage", getTonnage())
            .append("landFreightPrice", getLandFreightPrice())
            .append("landFreight", getLandFreight())
            .append("seaFreight", getSeaFreight())
            .append("freight", getFreight())
            .append("otherCost", getOtherCost())
            .append("profit", getProfit())
            .append("profitNoTax", getProfitNoTax())
            .append("actualPieces", getActualPieces())
            .append("paymentsWithSundry", getPaymentsWithSundry())
            .append("additionalFees", getAdditionalFees())
            .append("storeHouseID", getStoreHouseID())
            .append("storeHouseName", getStoreHouseName())
            .append("storeID", getStoreID())
            .append("logisticsProfit", getLogisticsProfit())
            .append("customerCommission", getCustomerCommission())
            .append("isAdjusted", getIsAdjusted())
            .append("adjustDate", getAdjustDate())
            .append("cancelFlag", getCancelFlag())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
