package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import java.util.List;

/**
 * 商业票据、银行承兑对象 bankacceptance
 * 
 * @author ml
 * @date 2024-07-19
 */
public class Bankacceptance extends BaseEntity
{
    public static final int MAX = 20;
    private static final long serialVersionUID = 1L;


    /** 主键 */
    private Long id;

    /** 操作日期 */
    @Excel(name = "操作日期")
    private String operateDate;

    /** 票据号码 */
    @Excel(name = "票据号码")
    private String billNo;

    /** 出票日期 */
    @Excel(name = "出票日期")
    private String issueDate;

    /** 到期日期 */
    @Excel(name = "到期日期")
    private String dueDate;

    /** 我方承兑账户 */
    @Excel(name = "我方承兑账户")
    private String billAccount;

    /** 票据日期 */
    @Excel(name = "票据日期")
    private String billDate;

    /** 分类（收入、支出） */
    @Excel(name = "分类", readConverterExp = "收=入、支出")
    private String billType;

    /** 事由 */
    @Excel(name = "事由")
    private String reason;

    /** 票据金额 */
    @Excel(name = "票据金额")
    private Long billAmount;

    /** 贴息点数 */
    @Excel(name = "贴息点数")
    private Long inDiscountPoints;

    /** 贴息金额 */
    @Excel(name = "贴息金额")
    private Long inDiscountAmount;

    /** 票据种类（电子/纸质） */
    @Excel(name = "票据种类", readConverterExp = "电=子/纸质")
    private String billCategory;

    /** 来源 */
    @Excel(name = "来源")
    private String origin;

    /** 背书人 */
    @Excel(name = "背书人")
    private String endorser;

    /** 被背书人 */
    @Excel(name = "被背书人")
    private String endorsee;

    /** 背书事由（出卖/付货款） */
    @Excel(name = "背书事由", readConverterExp = "出=卖/付货款")
    private String endorseReason;

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
    /*票据表*/
    private List<Bankacceptance> bankList;

    public List<Bankacceptance> getbankList() {
        return bankList;
    }

    public void setbankList(List<Bankacceptance> bankList) {
        this.bankList = bankList;
    }

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
    public void setBillAmount(Long billAmount) 
    {
        this.billAmount = billAmount;
    }

    public Long getBillAmount() 
    {
        return billAmount;
    }
    public void setInDiscountPoints(Long inDiscountPoints) 
    {
        this.inDiscountPoints = inDiscountPoints;
    }

    public Long getInDiscountPoints() 
    {
        return inDiscountPoints;
    }
    public void setInDiscountAmount(Long inDiscountAmount) 
    {
        this.inDiscountAmount = inDiscountAmount;
    }

    public Long getInDiscountAmount() 
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
