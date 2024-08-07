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

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 固定资产对象 fixedAssets
 * 
 * @author ml
 * @date 2024-07-29
 */
@TableName("fixedAssets")
public class FixedAssets extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value="id")
    private Long id;

    /** 购入日期 */
    @NotNull(message = "购入日期不能为空")
    @TableField("buyDate")
    @Excel(name = "购入日期",dateFormat = "yyyy-MM-dd")
    private String buyDate;

    /** 资产编号 */
    @Excel(name = "资产编号")
    @NotNull(message = "资产编号不能为空")
    @TableField("assetNo")
    @Length(max = 30, message = "资产编号的字符长度不允许超过30")
    private String assetNo;

    /** 资产名称 */
    @Excel(name = "资产名称")
    @TableField("assetName")
    @Length(max = 20, message = "资产名称的字符长度不允许超过20")
    @NotNull(message = "资产名称不能为空")
    private String assetName;

    /** 规格型号（车牌号） */
    @TableField("specification")
    @Length(max = 50, message = "规格型号的字符长度不允许超过50")
    @NotNull(message = "规格型号不能为空")
    @Excel(name = "规格型号", readConverterExp = "车牌号")
    private String  specification;

    /** 数量 */
    @Excel(name = "数量")
    @TableField("number")
    @NotNull(message = "数量不能为空")
    @Length(max = 20, message = "数量的字符长度不允许超过20")
    private String number;

    /** 计量单位 */
    @Excel(name = "计量单位")
    @TableField("measurementUnit")
    @NotNull(message = "计量单位的字符长度不允许超过20")
    @Length(max = 20, message = "计量单位的字符长度不允许超过20")
    private String measurementUnit;

    /** 含税金额 */
    @DecimalMaxDigits
    @TableField("amountIncludeTax")
    private Double amountIncludeTax;

    /** 不含税金额 */
    @DecimalMaxDigits
    @TableField("amountNoTax")
    private Double amountNoTax;

    /** 户名名称（公户/个人） */
    @Excel(name = "户名名称")
    @Pattern(regexp = "公户|个人", message = "户名名称必须是：公户或个人")
    @NotNull(message = "户名名称不能为空")
    @TableField("account")
    private String account;

    /** 使用部门 */
    @Excel(name = "使用部门")
    @TableField("department")
    @NotNull(message = "使用部门的字符长度不允许超过20")
    @Length(max = 20, message = "使用部门的字符长度不允许超过20")
    private String department;

    /** 固定资产清理时间 */
    @Excel(name = "固定资产清理时间",dateFormat = "yyyy-MM-dd")
    @TableField("scrapDate")
    private String scrapDate;

    /** 清理/变卖价值 */
    @DecimalMaxDigits
    @TableField("scrapAmount")
    private Double saleAmount;

    /** 备注 */
    @Excel(name = "备注")
    @TableField("comments")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间",dateFormat = "yyyy-MM-dd")
    @TableField("addtime")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    @TableField("userId")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    @TableField("userName")
    @Length(max = 20, message = "操作人员姓名的字符长度不允许超过20")
    private String UserName;

    /** 删除标记 */
    @FlagOnlyZeroOrOne
    @TableField("delFlag")
    private Long delFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setBuyDate(String buyDate) 
    {
        this.buyDate = buyDate;
    }

    public String getBuyDate() 
    {
        return buyDate;
    }
    public void setAssetNo(String assetNo) 
    {
        this.assetNo = assetNo;
    }

    public String getAssetNo() 
    {
        return assetNo;
    }
    public void setAssetName(String assetName) 
    {
        this.assetName = assetName;
    }

    public String getAssetName() 
    {
        return assetName;
    }
    public void setspecification(String  specification)
    {
        this. specification =  specification;
    }

    public String getspecification()
    {
        return  specification;
    }
    public void setNumber(String number) 
    {
        this.number = number;
    }

    public String getNumber() 
    {
        return number;
    }
    public void setMeasurementUnit(String measurementUnit)
    {
        this.measurementUnit = measurementUnit;
    }

    public String getMeasurementUnit()
    {
        return measurementUnit;
    }
    public void setAmountIncludeTax(Double amountIncludeTax) 
    {
        this.amountIncludeTax = amountIncludeTax;
    }

    public Double getAmountIncludeTax() 
    {
        return amountIncludeTax;
    }
    public void setAmountNoTax(Double amountNoTax) 
    {
        this.amountNoTax = amountNoTax;
    }

    public Double getAmountNoTax() 
    {
        return amountNoTax;
    }
    public void setAccount(String account) 
    {
        this.account = account;
    }

    public String getAccount() 
    {
        return account;
    }
    public void setDepartment(String department) 
    {
        this.department = department;
    }

    public String getDepartment() 
    {
        return department;
    }
    public void setScrapDate(String scrapDate) 
    {
        this.scrapDate = scrapDate;
    }

    public String getScrapDate() 
    {
        return scrapDate;
    }
    public void setSaleAmount(Double saleAmount) 
    {
        this.saleAmount = saleAmount;
    }

    public Double getSaleAmount() 
    {
        return saleAmount;
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

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("buyDate", getBuyDate())
            .append("assetNo", getAssetNo())
            .append("assetName", getAssetName())
            .append(" specification", getspecification())
            .append("number", getNumber())
            .append("measurementUnit ", getMeasurementUnit())
            .append("amountIncludeTax", getAmountIncludeTax())
            .append("amountNoTax", getAmountNoTax())
            .append("account", getAccount())
            .append("department", getDepartment())
            .append("scrapDate", getScrapDate())
            .append("saleAmount", getSaleAmount())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
