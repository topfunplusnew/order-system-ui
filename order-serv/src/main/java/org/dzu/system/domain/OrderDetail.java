package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Max;
import javax.validation.constraints.NotNull;

/**
 * 订单详情对象 orderDetail
 *
 * @author ml
 * @date 2024-08-01
 */
@TableName("orderDetail")
public class OrderDetail extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * id
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 订单编号（UUID）
     */
    @Excel(name = "订单编号", readConverterExp = "UUID")
    @TableField(value = "ordersNo")
    private String ordersNo;

    /**
     * 订单日期
     */
    @Excel(name = "订单日期", dateFormat = "yyyy-MM-dd")
    @TableField(value = "orderDate")
    private String orderDate;

    /**
     * 供应商
     */
    @Excel(name = "供应商")
    @Length(max = 20, message = "供应商长度不能超过20个字符")
    @TableField(value = "supplier")
    private String supplier;

    /**
     * 供应商ID
     */
    @Excel(name = "供应商ID")
    @TableField(value = "supplierID")
    private Long supplierID;

    /**
     * 客户
     */
    @Excel(name = "客户")
    @Length(max = 20, message = "客户长度不能超过20个字符")
    @NotNull(message = "客户不能为空")
    @TableField(value = "customer")
    private String customer;

    /**
     * 客户ID
     */
    @Excel(name = "客户ID")
    @NotNull(message = "客户ID不能为空")
    @TableField(value = "customerID")
    private Long customerID;

    /**
     * 级别编码
     */
    @Excel(name = "级别编码")
    @NotNull(message = "级别编码不能为空")
    @TableField(value = "levelID")
    private Long levelID;

    /**
     * 级别名称
     */
    @Excel(name = "级别名称")
    @Length(max = 20, message = "级别名称长度不能超过20个字符")
    @NotNull(message = "级别名称不能为空")
    @TableField(value = "levelName")
    private String levelName;

    /**
     * 计量单位
     */
    @Excel(name = "计量单位")
    @NotNull(message = "计量单位不能为空")
    @Length(max = 20, message = "计量单位长度不能超过20个字符")
    @TableField(value = "countingUnit")
    private String countingUnit;

    /**
     * 厚度
     */
    @DecimalMaxDigits
    @TableField(value = "height")
    private Double height;

    /**
     * 长度
     */
    @DecimalMaxDigits
    @TableField(value = "length")
    private Double length;

    /**
     * 宽度
     */
    @DecimalMaxDigits
    @TableField(value = "width")
    private Double width;

    /**
     * 出厂片数
     */
    @Excel(name = "出厂片数")
    @TableField(value = "pieces")
    private Long pieces;

    /**
     * 每包片数
     */
    @Excel(name = "每包片数")
    @TableField(value = "piecesPerPack")
    private Long piecesPerPack;

    /**
     * 包数
     */
    @Excel(name = "包数")
    @TableField(value = "packs")
    private Long packs;

    /**
     * 出厂单价
     */
    @DecimalMaxDigits
    @TableField(value = "price")
    private Double price;

    /**
     * 出厂是否含税
     */
    @Excel(name = "出厂是否含税")

    @TableField(value = "isIncludeTaxFactory")
    private Long isIncludeTaxFactory;

    /**
     * 杂费
     */
    @DecimalMaxDigits
    @TableField(value = "sundryCost")
    private Double sundryCost;

    /**
     * 出厂货款
     */
    @DecimalMaxDigits
    @TableField(value = "paymentFactory")
    private Double paymentFactory;

    /**
     * 卸货价
     */
    @DecimalMaxDigits
    @TableField(value = "paymentUnload")
    private Double paymentUnload;

    /**
     * 销售是否含税
     */
    @Excel(name = "销售是否含税")
    @TableField(value = "isIncludeTaxSale")
    private Long isIncludeTaxSale;

    /**
     * 总货款
     */
    @DecimalMaxDigits
    @TableField(value = "payments")
    private Double payments;

    /**
     * 误差
     */
    @DecimalMaxDigits
    @TableField(value = "erro")
    private Double erro;

    /**
     * 吨位
     */
    @DecimalMaxDigits
    @TableField(value = "tonnage")
    private Double tonnage;

    /**
     * 陆运费单价
     */
    @DecimalMaxDigits
    @TableField(value = "landFreightPrice")
    private Double landFreightPrice;

    /**
     * 陆运费
     */
    @DecimalMaxDigits
    @TableField(value = "landFreight")
    private Double landFreight;

    /**
     * 海运费
     */
    @DecimalMaxDigits
    @TableField(value = "seaFreight")
    private Double seaFreight;

    /**
     * 总运费
     */
    @DecimalMaxDigits
    @TableField(value = "freight")
    private Double freight;

    /**
     * 其他费用
     */
    @DecimalMaxDigits
    @TableField(value = "otherCost")
    private Double otherCost;

    /**
     * 利润
     */
    @DecimalMaxDigits
    @TableField(value = "profit")
    private Double profit;

    /**
     * 不含税利润
     */
    @DecimalMaxDigits
    @TableField(value = "profitNoTax")
    private Double profitNoTax;

    /**
     * 实际片数
     */
    @Excel(name = "实际片数")
    @Max(value = 9223372036854775807L, message = "实际片数长度不能超过19个字符")
    @TableField(value = "actualPieces")
    private Long actualPieces;

    /**
     * 总货款杂费
     */
    @DecimalMaxDigits
    @TableField(value = "paymentsWithSundry")
    private Double paymentsWithSundry;

    /**
     * 加费
     */
    @DecimalMaxDigits
    @TableField(value = "additionalFees")
    private Double additionalFees;

    /**
     * 仓库ID
     */
    @Excel(name = "仓库ID")
//    @NotNull(message = "仓库ID不能为空")
    @TableField(value = "storeHouseID")
    private Long storeHouseID;

    /**
     * 仓库名称
     */
    @Excel(name = "仓库名称")
    @Length(max = 20, message = "仓库名称长度不能超过20个字符")
    @TableField(value = "storeHouseName")
    private String storeHouseName;

    /**
     * 仓库存储的货物ID
     */
    @Excel(name = "仓库存储的货物ID")


    @TableField(value = "storeID")
    private Long storeID;

    /**
     * 物流利润
     */
    @DecimalMaxDigits
    @TableField(value = "logisticsProfit")
    private Double logisticsProfit;

    /**
     * 客户佣金
     */
    @DecimalMaxDigits
    @TableField(value = "customerCommission")
    private Double customerCommission;

    /**
     * 是否被调整单（ 是  否）
     */
    @Excel(name = "是否被调整单", readConverterExp = "是=,否=")
    @TableField(value = "isAdjusted")
    private String isAdjusted;

    /**
     * 调整日期
     */
    @Excel(name = "调整日期")
    @TableField(value = "adjustDate")
    private String adjustDate;

    /**
     * 作废标记
     */
    @FlagOnlyZeroOrOne
    @TableField(value = "cancelFlag")
    private Long cancelFlag;

    /**
     * 备注
     */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注长度不能超过200个字符")
    @TableField(value = "comments")
    private String comments;

    /**
     * 添加时间
     */
    @Excel(name = "添加时间")
    @TableField(value = "addtime")
    private String addtime;

    /**
     * 操作人员ID
     */
    @Excel(name = "操作人员ID")
    @TableField(value = "userId")
    private Long userId;

    /**
     * 操作人员姓名
     */
    @Excel(name = "操作人员姓名")
    @TableField(value = "UserName")
    private String UserName;

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setOrdersNo(String ordersNo) {
        this.ordersNo = ordersNo;
    }

    public String getOrdersNo() {
        return ordersNo;
    }

    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    public String getSupplier() {
        return supplier;
    }

    public void setSupplierID(Long supplierID) {
        this.supplierID = supplierID;
    }

    public Long getSupplierID() {
        return supplierID;
    }

    public void setCustomer(String customer) {
        this.customer = customer;
    }

    public String getCustomer() {
        return customer;
    }

    public void setCustomerID(Long customerID) {
        this.customerID = customerID;
    }

    public Long getCustomerID() {
        return customerID;
    }

    public void setLevelID(Long levelID) {
        this.levelID = levelID;
    }

    public Long getLevelID() {
        return levelID;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setCountingUnit(String countingUnit) {
        this.countingUnit = countingUnit;
    }

    public String getCountingUnit() {
        return countingUnit;
    }

    public void setHeight(Double height) {
        this.height = height;
    }

    public Double getHeight() {
        return height;
    }

    public void setLength(Double length) {
        this.length = length;
    }

    public Double getLength() {
        return length;
    }

    public void setWidth(Double width) {
        this.width = width;
    }

    public Double getWidth() {
        return width;
    }

    public void setPieces(Long pieces) {
        this.pieces = pieces;
    }

    public Long getPieces() {
        return pieces;
    }

    public void setPiecesPerPack(Long piecesPerPack) {
        this.piecesPerPack = piecesPerPack;
    }

    public Long getPiecesPerPack() {
        return piecesPerPack;
    }

    public void setPacks(Long packs) {
        this.packs = packs;
    }

    public Long getPacks() {
        return packs;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Double getPrice() {
        return price;
    }

    public void setIsIncludeTaxFactory(Long isIncludeTaxFactory) {
        this.isIncludeTaxFactory = isIncludeTaxFactory;
    }

    public Long getIsIncludeTaxFactory() {
        return isIncludeTaxFactory;
    }

    public void setSundryCost(Double sundryCost) {
        this.sundryCost = sundryCost;
    }

    public Double getSundryCost() {
        return sundryCost;
    }

    public void setPaymentFactory(Double paymentFactory) {
        this.paymentFactory = paymentFactory;
    }

    public Double getPaymentFactory() {
        return paymentFactory;
    }

    public void setPaymentUnload(Double paymentUnload) {
        this.paymentUnload = paymentUnload;
    }

    public Double getPaymentUnload() {
        return paymentUnload;
    }

    public void setIsIncludeTaxSale(Long isIncludeTaxSale) {
        this.isIncludeTaxSale = isIncludeTaxSale;
    }

    public Long getIsIncludeTaxSale() {
        return isIncludeTaxSale;
    }

    public void setPayments(Double payments) {
        this.payments = payments;
    }

    public Double getPayments() {
        return payments;
    }

    public void setErro(Double erro) {
        this.erro = erro;
    }

    public Double getErro() {
        return erro;
    }

    public void setTonnage(Double tonnage) {
        this.tonnage = tonnage;
    }

    public Double getTonnage() {
        return tonnage;
    }

    public void setLandFreightPrice(Double landFreightPrice) {
        this.landFreightPrice = landFreightPrice;
    }

    public Double getLandFreightPrice() {
        return landFreightPrice;
    }

    public void setLandFreight(Double landFreight) {
        this.landFreight = landFreight;
    }

    public Double getLandFreight() {
        return landFreight;
    }

    public void setSeaFreight(Double seaFreight) {
        this.seaFreight = seaFreight;
    }

    public Double getSeaFreight() {
        return seaFreight;
    }

    public void setFreight(Double freight) {
        this.freight = freight;
    }

    public Double getFreight() {
        return freight;
    }

    public void setOtherCost(Double otherCost) {
        this.otherCost = otherCost;
    }

    public Double getOtherCost() {
        return otherCost;
    }

    public void setProfit(Double profit) {
        this.profit = profit;
    }

    public Double getProfit() {
        return profit;
    }

    public void setProfitNoTax(Double profitNoTax) {
        this.profitNoTax = profitNoTax;
    }

    public Double getProfitNoTax() {
        return profitNoTax;
    }

    public void setActualPieces(Long actualPieces) {
        this.actualPieces = actualPieces;
    }

    public Long getActualPieces() {
        return actualPieces;
    }

    public void setPaymentsWithSundry(Double paymentsWithSundry) {
        this.paymentsWithSundry = paymentsWithSundry;
    }

    public Double getPaymentsWithSundry() {
        return paymentsWithSundry;
    }

    public void setAdditionalFees(Double additionalFees) {
        this.additionalFees = additionalFees;
    }

    public Double getAdditionalFees() {
        return additionalFees;
    }

    public void setStoreHouseID(Long storeHouseID) {
        this.storeHouseID = storeHouseID;
    }

    public Long getStoreHouseID() {
        return storeHouseID;
    }

    public void setStoreHouseName(String storeHouseName) {
        this.storeHouseName = storeHouseName;
    }

    public String getStoreHouseName() {
        return storeHouseName;
    }

    public void setStoreID(Long storeID) {
        this.storeID = storeID;
    }

    public Long getStoreID() {
        return storeID;
    }

    public void setLogisticsProfit(Double logisticsProfit) {
        this.logisticsProfit = logisticsProfit;
    }

    public Double getLogisticsProfit() {
        return logisticsProfit;
    }

    public void setCustomerCommission(Double customerCommission) {
        this.customerCommission = customerCommission;
    }

    public Double getCustomerCommission() {
        return customerCommission;
    }

    public void setIsAdjusted(String isAdjusted) {
        this.isAdjusted = isAdjusted;
    }

    public String getIsAdjusted() {
        return isAdjusted;
    }

    public void setAdjustDate(String adjustDate) {
        this.adjustDate = adjustDate;
    }

    public String getAdjustDate() {
        return adjustDate;
    }

    public void setCancelFlag(Long cancelFlag) {
        this.cancelFlag = cancelFlag;
    }

    public Long getCancelFlag() {
        return cancelFlag;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public String getComments() {
        return comments;
    }

    public void setAddtime(String addtime) {
        this.addtime = addtime;
    }

    public String getAddtime() {
        return addtime;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserName(String UserName) {
        this.UserName = UserName;
    }

    public String getUserName() {
        return UserName;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("ordersNo", getOrdersNo())
                .append("orderDate", getOrderDate())
                .append("supplier", getSupplier())
                .append("supplierID", getSupplierID())
                .append("customer", getCustomer())
                .append("customerID", getCustomerID())
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
