package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Pattern;

/**
 * 商业票据、银行承兑对象 bankAcceptance
 * 
 * @author ml
 * @date 2024-07-29
 */
public class BankAcceptance extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 操作日期 */
    @Excel(name = "操作日期",dateFormat = "yyyy-MM-dd")
    private String operateDate;

    /** 票据号码 */
    @Excel(name = "票据号码")
    @Length(max = 30, message = "票据号码的字符长度不允许超过30")
    private String billNo;

    /** 出票日期 */
    @Excel(name = "出票日期",dateFormat = "yyyy-MM-dd")
    private String issueDate;

    /** 到期日期 */
    @Excel(name = "到期日期",dateFormat = "yyyy-MM-dd")
    private String dueDate;

    /** 我方承兑账户 */
    @Excel(name = "我方承兑账户")
    @Length(max = 20, message = "我方承兑账户的字符长度不允许超过20")
    private String billAccount;

    /** 票据日期 */
    @Excel(name = "票据日期",dateFormat = "yyyy-MM-dd")
    private String billDate;

    /** 分类（收入、支出） */
    @Excel(name = "分类(收入/支出)")
    @Pattern(regexp = "收入|支出", message = "分类必须是：收入或支出")
    private String billType;

    /** 事由 */
    @Excel(name = "事由")
    @Length(max = 50, message = "事由的字符长度不允许超过50")
    private String reason;

    /** 票据金额 */
    @DecimalMaxDigits
    private Double billAmount;

    /** 贴息点数 */
    @DecimalMaxDigits
    private Double inDiscountPoints;

    /** 贴息金额 */
    @DecimalMaxDigits
    private Double inDiscountAmount;

    /** 票据种类（电子/纸质） */
    @Excel(name = "票据种类（电子或纸质）")
    @Pattern(regexp = "电子|纸质", message = "票据类型必须是：电子或纸质")
    private String billCategory;

    /** 来源 */
    @Excel(name = "来源")
    @Length(max = 50, message = "来源的字符长度不允许超过50")
    private String origin;

    /** 背书人 */
    @Excel(name = "背书人")
    @Length(max = 20, message = "背书人的字符长度不允许超过20")
    private String endorser;

    /** 被背书人 */
    @Excel(name = "被背书人")
    @Length(max = 20, message = "被背书人的字符长度不允许超过50")
    private String endorsee;

    /** 背书事由（出卖/付货款） */
    @Excel(name = "背书事由")
    @Pattern(regexp = "出卖|付货款", message = "背书事由必须是：出卖或付货款")
    private String endorseReason;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 50, message = "备注的字符长度不允许超过50")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间",dateFormat = "yyyy-MM-dd")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    private String UserName;

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
    public void setOperateDate(String operateDate) 
    {
        this.operateDate = operateDate;
    }

    public String getOperateDate() 
    {
        return operateDate;
    }
    public void setBillNo(String billNo) 
    {
        this.billNo = billNo;
    }

    public String getBillNo() 
    {
        return billNo;
    }
    public void setIssueDate(String issueDate) 
    {
        this.issueDate = issueDate;
    }

    public String getIssueDate() 
    {
        return issueDate;
    }
    public void setDueDate(String dueDate) 
    {
        this.dueDate = dueDate;
    }

    public String getDueDate() 
    {
        return dueDate;
    }
    public void setBillAccount(String billAccount) 
    {
        this.billAccount = billAccount;
    }

    public String getBillAccount() 
    {
        return billAccount;
    }
    public void setBillDate(String billDate) 
    {
        this.billDate = billDate;
    }

    public String getBillDate() 
    {
        return billDate;
    }
    public void setBillType(String billType) 
    {
        this.billType = billType;
    }

    public String getBillType() 
    {
        return billType;
    }
    public void setReason(String reason) 
    {
        this.reason = reason;
    }

    public String getReason() 
    {
        return reason;
    }
    public void setBillAmount(Double billAmount) 
    {
        this.billAmount = billAmount;
    }

    public Double getBillAmount() 
    {
        return billAmount;
    }
    public void setInDiscountPoints(Double inDiscountPoints) 
    {
        this.inDiscountPoints = inDiscountPoints;
    }

    public Double getInDiscountPoints() 
    {
        return inDiscountPoints;
    }
    public void setInDiscountAmount(Double inDiscountAmount) 
    {
        this.inDiscountAmount = inDiscountAmount;
    }

    public Double getInDiscountAmount() 
    {
        return inDiscountAmount;
    }
    public void setBillCategory(String billCategory) 
    {
        this.billCategory = billCategory;
    }

    public String getBillCategory() 
    {
        return billCategory;
    }
    public void setOrigin(String origin) 
    {
        this.origin = origin;
    }

    public String getOrigin() 
    {
        return origin;
    }
    public void setEndorser(String endorser) 
    {
        this.endorser = endorser;
    }

    public String getEndorser() 
    {
        return endorser;
    }
    public void setEndorsee(String endorsee) 
    {
        this.endorsee = endorsee;
    }

    public String getEndorsee() 
    {
        return endorsee;
    }
    public void setEndorseReason(String endorseReason) 
    {
        this.endorseReason = endorseReason;
    }

    public String getEndorseReason() 
    {
        return endorseReason;
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
            .append("billNo", getBillNo())
            .append("issueDate", getIssueDate())
            .append("dueDate", getDueDate())
            .append("billAccount", getBillAccount())
            .append("billDate", getBillDate())
            .append("billType", getBillType())
            .append("reason", getReason())
            .append("billAmount", getBillAmount())
            .append("inDiscountPoints", getInDiscountPoints())
            .append("inDiscountAmount", getInDiscountAmount())
            .append("billCategory", getBillCategory())
            .append("origin", getOrigin())
            .append("endorser", getEndorser())
            .append("endorsee", getEndorsee())
            .append("endorseReason", getEndorseReason())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
