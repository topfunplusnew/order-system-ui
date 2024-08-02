package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/**
 * 平账信息对象 BalanceAccounts
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("BalanceAccounts")
public class BalanceAccounts extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 操作时间 */
    @Excel(name = "操作时间")
    @TableField(value = "operateDate")
    @NotNull(message = "操作时间不能为空")
    @Length(max = 50, message = "操作时间的字符长度不允许超过50")
    private String operateDate;

    /** 金额 */
    @DecimalMaxDigits
    @TableField(value = "moneyAmount")
    private Double moneyAmount;

    /** 对方公司 */
    @Excel(name = "对方公司")
    @TableField(value = "companyName")
    @Length(max = 150, message = "对方公司名称的字符长度不允许超过150")
    private String companyName;

    /** 对方公司ID */
    @Excel(name = "对方公司ID")
    @TableField(value = "companyID")
    private Long companyID;

    /** 对方公司类型（1、客户 2、供应商） */
    @Excel(name = "对方公司类型", readConverterExp = "1=客户,2=供应商")
    @TableField(value = "companyType")
    @Min(value = 1, message = "公司类型必须为1（客户）或2（供应商）")
    @Max(value = 2, message = "公司类型必须为1（客户）或2（供应商）")
    private Long companyType;

    /** 备注 */
    @Excel(name = "备注")
    @TableField(value = "comments")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
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
    @OnlyZeroOrOne
    @TableField(value = "delFlag")
    private Long delFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setOperateDate(String operateDate) 
    {
        this.operateDate = operateDate;
    }

    public String getOperateDate() 
    {
        return operateDate;
    }
    public void setMoneyAmount(Double moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Double getMoneyAmount() 
    {
        return moneyAmount;
    }
    public void setCompanyName(String companyName) 
    {
        this.companyName = companyName;
    }

    public String getCompanyName() 
    {
        return companyName;
    }
    public void setCompanyID(Long companyID) 
    {
        this.companyID = companyID;
    }

    public Long getCompanyID() 
    {
        return companyID;
    }
    public void setCompanyType(Long companyType) 
    {
        this.companyType = companyType;
    }

    public Long getCompanyType() 
    {
        return companyType;
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
            .append("operateDate", getOperateDate())
            .append("moneyAmount", getMoneyAmount())
            .append("companyName", getCompanyName())
            .append("companyID", getCompanyID())
            .append("companyType", getCompanyType())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
