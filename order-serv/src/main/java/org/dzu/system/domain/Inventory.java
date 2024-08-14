package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.dzu.common.annotation.PhoneLength;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/**
 * 库存对象 inventory
 * 
 * @author ml
 * @date 2024-07-29
 */
@TableName("inventory")

public class Inventory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 仓库ID */
    @TableField(value = "storeHouseid")
    @NotNull(message = "仓库ID不能为空")
    @Excel(name = "仓库ID")
    private Long storeHouseid;

    /** 仓库名称 */
    @NotNull(message = "仓库名称不能为空")
    @TableField(value = "storeHouseName")
    @Excel(name = "仓库名称")
    @Length(max = 20, message = "仓库名称的字符长度不允许超过20")
    private String storeHouseName;

    /** 入库日期 */
    @NotNull(message = "入库日期不能为空")
    @TableField(value = "storeDate")
    @Excel(name = "入库日期", dateFormat = "yyyy-MM-dd")
    private String storeDate;

    /** 库存量（片数） */
    @NotNull(message = "库存量不能为空")
    @TableField(value = "stockNumber")
    @Excel(name = "库存量(片数）")
    private Long stockNumber;

    /** 供应商 */
    @NotNull(message = "供应商不能为空")
    @TableField(value = "supplier")
    @Excel(name = "供应商")
    @Length(max = 20, message = "供应商的字符长度不允许超过20")
    private String supplier;

    /** 供应商ID */
    @NotNull(message = "供应商ID不能为空")
    @TableField(value = "supplierId")
    @Excel(name = "供应商ID")
    private Long supplierId;

    /** 级别编码 */
    @NotNull(message = "级别编码不能为空")
    @TableField(value = "levelID")
    @Excel(name = "级别编码")
    private Long levelID;

    /** 级别名称 */
    @NotNull(message = "级别名称不能为空")
    @TableField(value = "levelName")
    @Excel(name = "级别名称")
    @Length(max = 20, message = "账号的字符长度不允许超过20")
    private String levelName;

    /** 计量单位 */
    @NotNull(message = "计量单位不能为空")
    @TableField(value = "countingUnit")
    @Excel(name = "计量单位")
    @Length(max = 20, message = "计量单位的字符长度不允许超过20")
    private String countingUnit;

    /** 厚度 */
    @NotNull(message = "厚度不能为空")
    @TableField(value = "thickness")
    @DecimalMaxDigits
    private Double height;

    /** 长度 */
    @NotNull(message = "长度不能为空")
    @TableField(value = "length")
    @DecimalMaxDigits
    private Double length;

    /** 宽度 */
    @NotNull(message = "宽度不能为空")
    @TableField(value = "width")
    @DecimalMaxDigits
    private Double width;

    /** 出厂片数 */
    @NotNull(message = "出厂片数不能为空")
    @TableField(value = "pieces")
    @Excel(name = "出厂片数")
    private Long pieces;

    /** 每包片数 */
    @NotNull(message = "每包片数不能为空")
    @TableField(value = "piecesPerPack")
    @Excel(name = "每包片数")
    private Long piecesPerPack;

    /** 包数 */
    @NotNull(message = "包数不能为空")
    @TableField(value = "packs")
    @Excel(name = "包数")
    private Long packs;

    /** 出厂单价 */
    @NotNull(message = "出厂单价不能为空")
    @TableField(value = "price")
    @DecimalMaxDigits
    private Double price;

    /** 出厂是否含税 */
    @NotNull(message = "出厂是否含税不能为空")
    @TableField(value = "isIncludeTaxFactory")
      @Excel(name = "出厂是否含税", readConverterExp = "0=不含税,1=含税")
    @Max(value = 1, message = "只能为0或1，分别代表不含税或含税")
    @Min(value = 0, message = "只能为0或1，分别代表不含税或含税")
    private Long isIncludeTaxFactory;

    /** 杂费 */
    @NotNull(message = "杂费不能为空")
    @TableField(value = "sundryCost")
    @DecimalMaxDigits
    private Double sundryCost;

    /** 出厂货款 */
    @NotNull(message = "出厂货款不能为空")
    @TableField(value = "payments")
    @DecimalMaxDigits
    private Double paymentFactory;

    /** 卸货价 */
    @NotNull(message = "卸货价不能为空")
    @TableField(value = "unloadPrice")
    @DecimalMaxDigits
    private Double paymentUnload;

    /** 销售是否含税（0不含税，1含税） */
    @NotNull(message = "销售是否含税不能为空")
    @TableField(value = "isIncludeTaxSale")
    @Excel(name = "销售是否含税", readConverterExp = "0=不含税,1=含税")
    @Max(value = 1, message = "只能为0或1，分别代表不含税或含税")
    @Min(value = 0, message = "只能为0或1，分别代表不含税或含税")
    private Long isIncludeTaxSale;

    /** 总货款 */
    @NotNull(message = "总货款不能为空")
    @TableField(value = "totalPayments")
    private String payments;

    /** 陆运车辆ID */

    @TableField(value = "landCarID")
    @Excel(name = "陆运车辆ID")
    private Long landCarID;

    /** 陆运车牌 */
    @TableField(value = "landCarNo")
    @Length(max = 50, message = "陆运车牌的字符长度不允许超过50")
    @Excel(name = "陆运车牌")
    private String landCarNo;

    /** 陆运司机电话 */

    @TableField(value = "landDriverTel")
    @PhoneLength
    private String landDriverTel;

    /** 陆地司机姓名 */
    @Length(max = 20, message = "陆运司机姓名的字符长度不允许超过20")
    @TableField(value = "landDriverName")
    @Excel(name = "陆地司机姓名")
    private String landDriverName;

    /** 海运车辆ID */
    @TableField(value = "seaCarID")
    @Excel(name = "海运车辆ID")
    private Long seaCarID;

    /** 海运车牌 */
    @TableField(value = "seaCarNo")
    @Excel(name = "海运车牌")
    @Length(max = 55, message = "海运车车牌的字符长度不允许超过55")
    private String seaCarNo;

    /** 海运司机电话 */
    @TableField(value = "seaDriverTel")
    @Excel(name = "海运司机电话")
    @PhoneLength
    private String seaDriverTel;

    /** 海运司机姓名 */
    @TableField(value = "seaDriverName")
    @Excel(name = "海运司机姓名")
    @Length(max = 20, message = "海运司机姓名的字符长度不允许超过20")
    private String seaDriverName;

    /** 误差 */
    @TableField(value = "erro")
    @DecimalMaxDigits
    private Double erro;

    /** 吨位 */
    @NotNull(message = "吨位不能为空")
    @DecimalMaxDigits
    @TableField(value = "tonnage")
    private Double tonnage;

    /** 陆运费单价 */
    @NotNull(message = "陆运费单价不能为空")
    @DecimalMaxDigits
    @TableField(value = "landFreightPrice")
    private Double landFreightPrice;

    /** 陆运费 */
    @NotNull(message = "陆运费不能为空")
    @DecimalMaxDigits
    @TableField(value = "landFreight")
    private Double landFreight;

    /** 海运费 */
    @DecimalMaxDigits
    @TableField(value = "seaFreight")
    private Double seaFreight;

    /** 运费（海运费+陆运费） */
    @NotNull(message = "运费不能为空")
    @Excel(name = "运费")
    @DecimalMaxDigits
    @TableField(value = "freight")
    private Double freight;

    /** 其他费用 */
    @NotNull(message = "其他费用不能为空")
    @DecimalMaxDigits
    @TableField(value = "otherCost")
    private Double otherCost;

    /** 利润 */
    @NotNull(message = "利润不能为空")
    @DecimalMaxDigits
    @TableField(value = "profit")
    private Double profit;

    /** 不含税利润 */
    @NotNull(message = "不含税利润不能为空")
    @DecimalMaxDigits
    @TableField(value = "profitNoTax")
    private Double profitNoTax;

    /** 实际片数 */
    @NotNull(message = "实际片数不能为空")
    @Excel(name = "实际片数")
    @TableField(value = "actualPieces")
    private Long actualPieces;

    /** 总货款杂费 */
    @DecimalMaxDigits
    @TableField(value = "totalGoodsCost")
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
    @Length(max = 500, message = "备注的字符长度不允许超过500")
    private String comments;

    /** 添加时间 */
    @TableField(value = "addTime")
    @Excel(name = "添加时间",dateFormat = "yyyy-MM-dd")
    private String addtime;

    /** 操作人员ID */
    @TableField(value = "userId")
    @Excel(name = "操作人员ID")
    private Long userId;

    /** 操作人员姓名 */
    @TableField(value = "userName")
    @Excel(name = "操作人员姓名")
    @Length(max = 20, message = "操作人员姓名的字符长度不允许超过20")
    private String UserName;

    /** 删除标记 */
    @TableField(value = "delFlag")
    @FlagOnlyZeroOrOne
    private Long delFlag;

    /** 订单仓库选择时是否显示（ 显示， 不显示） */
    @TableField(value = "showFlag")
    @Excel(name = "订单仓库选择时是否显示")
    private Long showFlag;
    // goodsCompany

    @TableField(value = "goodsCompany")
    @Excel(name = "货物来源公司")
    private String goodsCompany;

    //exWareHoustId
    @TableField(value = "exWareHoustId")
    private Long exWareHoustId;


    // storeDate的开始和结束时间
    @TableField(exist = false)
    private String storeDateBegin;
    @TableField(exist = false)
    private String storeDateEnd;

    public String getStoreDateEnd() {
        return storeDateEnd;
    }

    public void setStoreDateEnd(String storeDateEnd) {
        this.storeDateEnd = storeDateEnd;
    }

    public String getStoreDateBegin() {
        return storeDateBegin;
    }

    public void setStoreDateBegin(String storeDateBegin) {
        this.storeDateBegin = storeDateBegin;
    }

    public String getGoodsCompany() {
        return goodsCompany;
    }

    public void setGoodsCompany(String goodsCompany) {
        this.goodsCompany = goodsCompany;
    }

    public Long getExWareHoustId() {
        return exWareHoustId;
    }

    public void setExWareHoustId(Long exWareHoustId) {
        this.exWareHoustId = exWareHoustId;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
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
