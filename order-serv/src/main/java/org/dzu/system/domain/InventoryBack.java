package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

/**
 * 库存备份对象 inventory_back
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("inventory_back")
public class InventoryBack extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 原货物存储ID */
    @Excel(name = "原货物存储ID")
    @Length(max = 20, message = "原货物存储ID长度不能超过20")
    @TableField(value = "inventoryID")
    private Long inventoryID;

    /** 仓库ID */
    @Excel(name = "仓库ID")
    @Length(max = 20, message = "仓库ID长度不能超过20")
    @TableField(value = "storeHouseid")
    private Long storeHouseid;

    /** 仓库名称 */
    @Excel(name = "仓库名称")
    @Length(max = 20, message = "仓库名称长度不能超过20")
    @TableField(value = "storeHouseName")
    private String storeHouseName;

    /** 入库日期 */
    @Excel(name = "入库日期",dateFormat = "yyyy-MM-dd")
    @TableField(value = "storeDate")
    private String storeDate;

    /** 库存量（片数） */
    @Excel(name = "库存量", readConverterExp = "片数")
    @Length(max = 20, message = "库存量长度不能超过20")
    @TableField(value = "stockNumber")
    private Long stockNumber;

    /** 供应商 */
    @Excel(name = "供应商")
    @Length(max = 20, message = "供应商长度不能超过20")
    @TableField(value = "supplier")
    private String supplier;

    /** 供应商ID */
    @Excel(name = "供应商ID")
    @Length(max = 20, message = "供应商ID长度不能超过20")
    @TableField(value = "supplierId")
    private Long supplierId;

    /** 级别编码 */
    @Excel(name = "级别编码")
    @Length(max = 20, message = "级别编码长度不能超过20")
    @TableField(value = "levelID")
    private Long levelID;

    /** 级别名称 */
    @Excel(name = "级别名称")
    @Length(max = 20, message = "级别名称长度不能超过20")
    @TableField(value = "levelName")
    private String levelName;

    /** 计量单位 */
    @Excel(name = "计量单位")
    @Length(max = 20, message = "计量单位长度不能超过20")
    @TableField(value = "countingUnit")
    private String countingUnit;

    /** 厚度 */
    @DecimalMaxDigits
    @TableField(value = "height")
    private Double height;

    /** 长度 */
    @DecimalMaxDigits
    @TableField(value = "length")
    private Double length;

    /** 宽度 */
    @DecimalMaxDigits
    @TableField(value = "width")
    private Double width;

    /** 出厂片数 */
    @Excel(name = "出厂片数")
    @TableField(value = "pieces")
    private Long pieces;

    /** 每包片数 */
    @Excel(name = "每包片数")
    @TableField(value = "piecesPerPack")
    private Long piecesPerPack;

    /** 包数 */
    @Excel(name = "包数")
    @TableField(value = "packs")
    private Long packs;

    /** 出厂单价 */
    @DecimalMaxDigits
    @TableField(value = "price")
    private Double price;

    /** 出厂是否含税 */
    @Excel(name = "出厂是否含税")
    @TableField(value = "isIncludeTaxFactory")
    private Long isIncludeTaxFactory;

    /** 杂费 */
    @DecimalMaxDigits
    @TableField(value = "sundryCost")
    private Double sundryCost;

    /** 出厂货款 */
    @DecimalMaxDigits
    @TableField(value = "paymentFactory")
    private Double paymentFactory;

    /** 卸货价 */
    @DecimalMaxDigits
    @TableField(value = "paymentUnload")
    private Double paymentUnload;

    /** 销售是否含税（0不含税，1含税） */
    @Excel(name = "销售是否含税", readConverterExp = "0=不含税，1含税")
    @TableField(value = "isIncludeTaxSale")
    private Long isIncludeTaxSale;

    /** 总货款 */
    @Excel(name = "总货款")
    @TableField(value = "payments")
    private String payments;

    /** 陆运车辆ID */
    @Excel(name = "陆运车辆ID")
    @TableField(value = "landCarID")
    private Long landCarID;

    /** 陆运车牌 */
    @Excel(name = "陆运车牌")
    @TableField(value = "landCarNo")
    private String landCarNo;

    /** 陆运司机电话 */
    @Excel(name = "陆运司机电话")
    @TableField(value = "landDriverTel")
    private String landDriverTel;

    /** 陆地司机姓名 */
    @Excel(name = "陆地司机姓名")
    @TableField(value = "landDriverName")
    private String landDriverName;

    /** 海运车辆ID */
    @Excel(name = "海运车辆ID")
    @TableField(value = "seaCarID")
    private Long seaCarID;

    /** 海运车牌 */
    @Excel(name = "海运车牌")
    @TableField(value = "seaCarNo")
    private String seaCarNo;

    /** 海运司机电话 */
    @Excel(name = "海运司机电话")
    @TableField(value = "seaDriverTel")
    private String seaDriverTel;

    /** 海运司机姓名 */
    @Excel(name = "海运司机姓名")
    @TableField(value = "seaDriverName")
    private String seaDriverName;

    /** 误差 */
    @DecimalMaxDigits
    @TableField(value = "erro")
    private Double erro;

    /** 吨位 */
    @DecimalMaxDigits
    @TableField(value = "tonnage")
    private Double tonnage;

    /** 陆运费单价 */
    @DecimalMaxDigits
    @TableField(value = "landFreightPrice")
    private Double landFreightPrice;

    /** 陆运费 */
    @DecimalMaxDigits
    @TableField(value = "landFreight")
    private Double landFreight;

    /** 海运费 */
    @DecimalMaxDigits
    @TableField(value = "seaFreight")
    private Double seaFreight;

    /** 运费（海运费+陆运费） */
    @Excel(name = "运费", readConverterExp = "海=运费+陆运费")
    @TableField(value = "freight")
    private Double freight;

    /** 其他费用 */
    @DecimalMaxDigits
    @TableField(value = "otherCost")
    private Double otherCost;

    /** 利润 */
    @DecimalMaxDigits
    @TableField(value = "profit")
    private Double profit;

    /** 不含税利润 */
    @DecimalMaxDigits
    @TableField(value = "profitNoTax")
    private Double profitNoTax;

    /** 实际片数 */
    @Excel(name = "实际片数")
    @TableField(value = "actualPieces")
    private Long actualPieces;

    /** 总货款杂费 */
    @DecimalMaxDigits
    @TableField(value = "paymentsWithSundry")
    private Double paymentsWithSundry;

    /** 加费 */
    @DecimalMaxDigits
    @TableField(value = "additionalFees")
    private Double additionalFees;

    /** 返利金额 */
    @DecimalMaxDigits
    @TableField(value = "rebate")
    private Double rebate;

    /** 客户佣金 */
    @DecimalMaxDigits
    @TableField(value = "customerCommission")
    private Double customerCommission;

    /** 备注 */
    @Excel(name = "备注")
    @TableField(value = "comments")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间")
    @TableField(value = "addtime")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    @TableField(value = "userId")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    @TableField(value = "UserName")
    private String UserName;

    /** 删除标记 */
    @FlagOnlyZeroOrOne
    @TableField(value = "delFlag")
    private Long delFlag;

    /** 订单仓库选择时是否显示（ 显示， 不显示） */
    @Excel(name = "订单仓库选择时是否显示", readConverterExp = "显=示，,不=显示")
    @TableField(value = "showFlag")
    private Long showFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setInventoryID(Long inventoryID) 
    {
        this.inventoryID = inventoryID;
    }

    public Long getInventoryID() 
    {
        return inventoryID;
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
    public void setHeight(Double height) 
    {
        this.height = height;
    }

    public Double getHeight() 
    {
        return height;
    }
    public void setLength(Double length) 
    {
        this.length = length;
    }

    public Double getLength() 
    {
        return length;
    }
    public void setWidth(Double width) 
    {
        this.width = width;
    }

    public Double getWidth() 
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
    public void setPrice(Double price) 
    {
        this.price = price;
    }

    public Double getPrice() 
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
    public void setSundryCost(Double sundryCost) 
    {
        this.sundryCost = sundryCost;
    }

    public Double getSundryCost() 
    {
        return sundryCost;
    }
    public void setPaymentFactory(Double paymentFactory) 
    {
        this.paymentFactory = paymentFactory;
    }

    public Double getPaymentFactory() 
    {
        return paymentFactory;
    }
    public void setPaymentUnload(Double paymentUnload) 
    {
        this.paymentUnload = paymentUnload;
    }

    public Double getPaymentUnload() 
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
    public void setLandCarID(Long landCarID) 
    {
        this.landCarID = landCarID;
    }

    public Long getLandCarID() 
    {
        return landCarID;
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
    public void setSeaCarID(Long seaCarID) 
    {
        this.seaCarID = seaCarID;
    }

    public Long getSeaCarID() 
    {
        return seaCarID;
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
    public void setErro(Double erro) 
    {
        this.erro = erro;
    }

    public Double getErro() 
    {
        return erro;
    }
    public void setTonnage(Double tonnage) 
    {
        this.tonnage = tonnage;
    }

    public Double getTonnage() 
    {
        return tonnage;
    }
    public void setLandFreightPrice(Double landFreightPrice) 
    {
        this.landFreightPrice = landFreightPrice;
    }

    public Double getLandFreightPrice() 
    {
        return landFreightPrice;
    }
    public void setLandFreight(Double landFreight) 
    {
        this.landFreight = landFreight;
    }

    public Double getLandFreight() 
    {
        return landFreight;
    }
    public void setSeaFreight(Double seaFreight) 
    {
        this.seaFreight = seaFreight;
    }

    public Double getSeaFreight() 
    {
        return seaFreight;
    }
    public void setFreight(Double freight) 
    {
        this.freight = freight;
    }

    public Double getFreight() 
    {
        return freight;
    }
    public void setOtherCost(Double otherCost) 
    {
        this.otherCost = otherCost;
    }

    public Double getOtherCost() 
    {
        return otherCost;
    }
    public void setProfit(Double profit) 
    {
        this.profit = profit;
    }

    public Double getProfit() 
    {
        return profit;
    }
    public void setProfitNoTax(Double profitNoTax) 
    {
        this.profitNoTax = profitNoTax;
    }

    public Double getProfitNoTax() 
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
    public void setPaymentsWithSundry(Double paymentsWithSundry) 
    {
        this.paymentsWithSundry = paymentsWithSundry;
    }

    public Double getPaymentsWithSundry() 
    {
        return paymentsWithSundry;
    }
    public void setAdditionalFees(Double additionalFees) 
    {
        this.additionalFees = additionalFees;
    }

    public Double getAdditionalFees() 
    {
        return additionalFees;
    }
    public void setRebate(Double rebate) 
    {
        this.rebate = rebate;
    }

    public Double getRebate() 
    {
        return rebate;
    }
    public void setCustomerCommission(Double customerCommission) 
    {
        this.customerCommission = customerCommission;
    }

    public Double getCustomerCommission() 
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
            .append("inventoryID", getInventoryID())
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
            .append("landCarID", getLandCarID())
            .append("landCarNo", getLandCarNo())
            .append("landDriverTel", getLandDriverTel())
            .append("landDriverName", getLandDriverName())
            .append("seaCarID", getSeaCarID())
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
