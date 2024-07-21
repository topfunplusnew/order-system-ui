package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 固定资产信息对象 fixedassets
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public class Fixedassets extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 购入日期 */
    @Excel(name = "购入日期")
    private String buyDate;

    /** 资产编号 */
    @Excel(name = "资产编号")
    private String assetNo;

    /** 资产名称 */
    @Excel(name = "资产名称")
    private String assetName;

    /** 规格型号（车牌号） */
    @Excel(name = "规格型号", readConverterExp = "车=牌号")
    private String specification;

    /** 数量 */
    @Excel(name = "数量")
    private String number;

    /** 计量单位 */
    @Excel(name = "计量单位")
    private String measurementUnit;

    /** 含税金额 */
    @Excel(name = "含税金额")
    private Long amountIncludeTax;

    /** 不含税金额 */
    @Excel(name = "不含税金额")
    private Long amountNoTax;

    /** 户名名称（公户/个人） */
    @Excel(name = "户名名称", readConverterExp = "公=户/个人")
    private String account;

    /** 使用部门 */
    @Excel(name = "使用部门")
    private String department;

    /** 固定资产清理时间 */
    @Excel(name = "固定资产清理时间")
    private String scrapDate;

    /** 清理/变卖价值 */
    @Excel(name = "清理/变卖价值")
    private Long saleAmount;

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
    public void setSpecification(String specification)
    {
        this.specification = specification;
    }

    public String getSpecification()
    {
        return specification;
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
    public void setAmountIncludeTax(Long amountIncludeTax) 
    {
        this.amountIncludeTax = amountIncludeTax;
    }

    public Long getAmountIncludeTax() 
    {
        return amountIncludeTax;
    }
    public void setAmountNoTax(Long amountNoTax) 
    {
        this.amountNoTax = amountNoTax;
    }

    public Long getAmountNoTax() 
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
    public void setSaleAmount(Long saleAmount) 
    {
        this.saleAmount = saleAmount;
    }

    public Long getSaleAmount() 
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

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("buyDate", getBuyDate())
            .append("assetNo", getAssetNo())
            .append("assetName", getAssetName())
            .append("specification", getSpecification())
            .append("number", getNumber())
            .append("measurementUnit", getMeasurementUnit())
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
            .toString();
    }
}
