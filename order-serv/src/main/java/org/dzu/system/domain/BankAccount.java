package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 银行账号对象 bankAccount
 * 
 * @author ml
 * @date 2024-07-29
 */
@TableName("bankAccount")
public class BankAccount extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id",type = IdType.AUTO)
    private Long id;


    /** 公司名称 */
    @Excel(name = "公司名称")
    @Length(max = 50, message = "公司名称的字符长度不允许超过50")
    @NotNull(message = "公司名称不能为空")
    @TableField("companyName")
    private String companyName;

    /** 对应公司ID */
    @Excel(name = "对应公司ID")
    @Length(max = 50, message = "对应公司ID的字符长度不允许超过50")
    @NotNull(message = "对应公司ID不能为空")
    @TableField("companyId")
    private Long companyId;

    /** 开户行 */
    @Excel(name = "开户行")
    @Length(max = 50, message = "开户行的字符长度不允许超过50")
    @NotNull(message = "开户行不能为空")
    @TableField("bankName")
    private String bankName;

    /** 开户名称 */
    @Excel(name = "开户名称")
    @Length(max = 50, message = "开户名称的字符长度不允许超过50")
    @NotNull(message = "开户名称不能为空")
    @TableField("accountsName")
    private String acountsName;

    /** 账号 */
    @Excel(name = "账号")
    @Length(max = 50, message = "账号的字符长度不允许超过50")
    @NotNull(message = "账号不能为空")
    @TableField("bankNo")
    private String bankNo;

    /** 账户类型（己方公司，客户，供应商，司机，其它） */
    @Excel(name = "账户类型")
    @Pattern(regexp = "己方公司|客户|供应商|司机|其它", message = "账户类型必须是：己方公司、客户、供应商、司机、其它")
    @NotNull(message = "账户类型不能为空")
    @TableField("acountsType")
    private String acountsType;
    /** 当前资金额 */
    @DecimalMaxDigits
    @TableField("amount")
    private Double amount;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
    @TableField("comments")
    private String comments;

    /** 删除标记 */
    @OnlyZeroOrOne
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
    public void setAmount(Double amount) 
    {
        this.amount = amount;
    }

    public Double getAmount() 
    {
        return amount;
    }
    public void setComments(String comments) 
    {
        this.comments = comments;
    }

    public String getComments() 
    {
        return comments;
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
            .append("amount", getAmount())
            .append("comments", getComments())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
