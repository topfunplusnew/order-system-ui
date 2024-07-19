package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

/**
 * 货物入库信息对象 inventory_back
 * 
 * @author ml
 * @date 2024-07-19
 */
public class InventoryBack extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 原货物存储ID */
    @Excel(name = "原货物存储ID")
    private Long inventoryId;

    /** 仓库ID */
    @Excel(name = "仓库ID")
    private Long storeHouseid;

    /** 仓库名称 */
    @Excel(name = "仓库名称")
    private String storeHouseName;

    /** 入库日期 */
    @Excel(name = "入库日期")
    private String storeDate;

    /** 库存量（片数） */
    @Excel(name = "库存量", readConverterExp = "片=数")
    private Long stockNumber;

    /** 供应商 */
    @Excel(name = "供应商")
    private String supplier;

    /** 供应商ID */
    @Excel(name = "供应商ID")
    private Long supplierId;

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

    /** 销售是否含税（0不含税，1含税） */
    @Excel(name = "销售是否含税", readConverterExp = "0=不含税，1含税")
    private Long isIncludeTaxSale;

    /** 总货款 */
    @Excel(name = "总货款")
    private String payments;

    /** 陆运车辆ID */
    @Excel(name = "陆运车辆ID")
    private Long landcarId;

    /** 陆运车牌 */
    @Excel(name = "陆运车牌")
    private String landCarNo;

    /** 陆运司机电话 */
    @Excel(name = "陆运司机电话")
    private String landDriverTel;

    /** 陆地司机姓名 */
    @Excel(name = "陆地司机姓名")
    private String landDriverName;

    /** 海运车辆ID */
    @Excel(name = "海运车辆ID")
    private Long seacarId;

    /** 海运车牌 */
    @Excel(name = "海运车牌")
    private String seaCarNo;

    /** 海运司机电话 */
    @Excel(name = "海运司机电话")
    private String seaDriverTel;

    /** 海运司机姓名 */
    @Excel(name = "海运司机姓名")
    private String seaDriverName;

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

    /** 运费（海运费+陆运费） */
    @Excel(name = "运费", readConverterExp = "海=运费+陆运费")
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

    /** 返利金额 */
    @Excel(name = "返利金额")
    private Long rebate;

    /** 客户佣金 */
    @Excel(name = "客户佣金")
    private Long customerCommission;

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

    /** 删除标记 */
    @Excel(name = "删除标记")
    private Long delFlag;

    /** 订单仓库选择时是否显示（ 显示， 不显示） */
    @Excel(name = "订单仓库选择时是否显示", readConverterExp = "显=示，,不=显示")
    private Long showFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setInventoryId(Long inventoryId) 
    {
        this.inventoryId = inventoryId;
    }

    public Long getInventoryId() 
    {
        return inventoryId;
    }
    public void setStoreHouseid(Long storeHouseid) 
    {
        this.storeHouseid = storeHouseid;
    }

    public Long getStoreHouseid() 
    {
        return storeHouseid;
    }
    public void setStoreHouseName(String storeHouseName) 
    {
        this.storeHouseName = storeHouseName;
    }

    public String getStoreHouseName() 
    {
        return storeHouseName;
    }
    public void setStoreDate(String storeDate) 
    {
        this.storeDate = storeDate;
    }

    public String getStoreDate() 
    {
        return storeDate;
    }
    public void setStockNumber(Long stockNumber) 
    {
        this.stockNumber = stockNumber;
    }

    public Long getStockNumber() 
    {
        return stockNumber;
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
    public void setPayments(String payments) 
    {
        this.payments = payments;
    }

    public String getPayments() 
    {
        return payments;
    }
    public void setLandcarId(Long landcarId) 
    {
        this.landcarId = landcarId;
    }

    public Long getLandcarId() 
    {
        return landcarId;
    }
    public void setLandCarNo(String landCarNo) 
    {
        this.landCarNo = landCarNo;
    }

    public String getLandCarNo() 
    {
        return landCarNo;
    }
    public void setLandDriverTel(String landDriverTel) 
    {
        this.landDriverTel = landDriverTel;
    }

    public String getLandDriverTel() 
    {
        return landDriverTel;
    }
    public void setLandDriverName(String landDriverName) 
    {
        this.landDriverName = landDriverName;
    }

    public String getLandDriverName() 
    {
        return landDriverName;
    }
    public void setSeacarId(Long seacarId) 
    {
        this.seacarId = seacarId;
    }

    public Long getSeacarId() 
    {
        return seacarId;
    }
    public void setSeaCarNo(String seaCarNo) 
    {
        this.seaCarNo = seaCarNo;
    }

    public String getSeaCarNo() 
    {
        return seaCarNo;
    }
    public void setSeaDriverTel(String seaDriverTel) 
    {
        this.seaDriverTel = seaDriverTel;
    }

    public String getSeaDriverTel() 
    {
        return seaDriverTel;
    }
    public void setSeaDriverName(String seaDriverName) 
    {
        this.seaDriverName = seaDriverName;
    }

    public String getSeaDriverName() 
    {
        return seaDriverName;
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
    public void setRebate(Long rebate) 
    {
        this.rebate = rebate;
    }

    public Long getRebate() 
    {
        return rebate;
    }
    public void setCustomerCommission(Long customerCommission) 
    {
        this.customerCommission = customerCommission;
    }

    public Long getCustomerCommission() 
    {
        return customerCommission;
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
    public void setDelFlag(Long delFlag) 
    {
        this.delFlag = delFlag;
    }

    public Long getDelFlag() 
    {
        return delFlag;
    }
    public void setShowFlag(Long showFlag) 
    {
        this.showFlag = showFlag;
    }

    public Long getShowFlag() 
    {
        return showFlag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("inventoryId", getInventoryId())
            .append("storeHouseid", getStoreHouseid())
            .append("storeHouseName", getStoreHouseName())
            .append("storeDate", getStoreDate())
            .append("stockNumber", getStockNumber())
            .append("supplier", getSupplier())
            .append("supplierId", getSupplierId())
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
            .append("landcarId", getLandcarId())
            .append("landCarNo", getLandCarNo())
            .append("landDriverTel", getLandDriverTel())
            .append("landDriverName", getLandDriverName())
            .append("seacarId", getSeacarId())
            .append("seaCarNo", getSeaCarNo())
            .append("seaDriverTel", getSeaDriverTel())
            .append("seaDriverName", getSeaDriverName())
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
            .append("rebate", getRebate())
            .append("customerCommission", getCustomerCommission())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .append("showFlag", getShowFlag())
            .toString();
    }
}
