package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
/**
 * 银行卡管理对象 bankaccount
 * 
 * @author ml
 * @date 2024-07-29
 */
public class Bankaccount extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 公司名称 */
    @Excel(name = "公司名称")
    private String companyName;

    /** 对应公司ID */
    @Excel(name = "对应公司ID")
    private Long companyId;

    /** 开户行 */
    @Excel(name = "开户行")
    private String bankName;

    /** 开户名称 */
    @Excel(name = "开户名称")
    private String acountsName;

    /** 账号 */
    @Excel(name = "账号")
    private String bankNo;

    /** 账户类型（己方公司，客户，供应商，司机，其它） */
    @Excel(name = "账户类型", readConverterExp = "己=方公司，客户，供应商，司机，其它")
    private String acountsType;

    /** 备注 */
    @Excel(name = "备注")
    private String comments;

    /** 当前资金额 */
    @DecimalMaxDigits
    private Double amount;

    /** 删除标记 */
    @OnlyZeroOrOne
    private Long delFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setCompanyName(String companyName) 
    {
        this.companyName = companyName;
    }

    public String getCompanyName() 
    {
        return companyName;
    }
    public void setCompanyId(Long companyId) 
    {
        this.companyId = companyId;
    }

    public Long getCompanyId() 
    {
        return companyId;
    }
    public void setBankName(String bankName) 
    {
        this.bankName = bankName;
    }

    public String getBankName() 
    {
        return bankName;
    }
    public void setAcountsName(String acountsName) 
    {
        this.acountsName = acountsName;
    }

    public String getAcountsName() 
    {
        return acountsName;
    }
    public void setBankNo(String bankNo) 
    {
        this.bankNo = bankNo;
    }

    public String getBankNo() 
    {
        return bankNo;
    }
    public void setAcountsType(String acountsType) 
    {
        this.acountsType = acountsType;
    }

    public String getAcountsType() 
    {
        return acountsType;
    }
    public void setComments(String comments) 
    {
        this.comments = comments;
    }

    public String getComments() 
    {
        return comments;
    }
    public void setAmount(Double amount) 
    {
        this.amount = amount;
    }

    public Double getAmount() 
    {
        return amount;
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
            .append("companyName", getCompanyName())
            .append("companyId", getCompanyId())
            .append("bankName", getBankName())
            .append("acountsName", getAcountsName())
            .append("bankNo", getBankNo())
            .append("acountsType", getAcountsType())
            .append("comments", getComments())
            .append("amount", getAmount())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
