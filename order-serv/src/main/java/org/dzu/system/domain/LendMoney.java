package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
/**
 * 向外部借出款信息对象 lendMoney
 * 
 * @author ml
 * @date 2024-07-29
 */
public class LendMoney extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 借出款编号（UUID） */
    @Excel(name = "借出款编号", readConverterExp = "U=UID")
    private String futuresNO;

    /** 期货保证金公司 */
    @Excel(name = "期货保证金公司")
    private String futuresMarginCompany;

    /** 对象类型(员工、客户、供应商、其他) */
    @Excel(name = "对象类型(员工、客户、供应商、其他)")
    private String targetType;

    /** 对象(员工姓名、公司名称) */
    @Excel(name = "对象(员工姓名、公司名称)")
    private String target;

    /** 保证金金额 */
    @DecimalMaxDigits
    private Double moneyAmount;

    /** 对方账户 */
    @Excel(name = "对方账户")
    private String targetAcountsName;

    /** 对方账号 */
    @Excel(name = "对方账号")
    private String targetBankNo;

    /** 对方开户行 */
    @Excel(name = "对方开户行")
    private String targetBankName;

    /** 我方支付账户 */
    @Excel(name = "我方支付账户")
    private String selfAcountsName;

    /** 我方账号 */
    @Excel(name = "我方账号")
    private String selfBankNo;

    /** 我方开户行 */
    @Excel(name = "我方开户行")
    private String selfBankName;

    /** 支付期货保证金时间 */
    @Excel(name = "支付期货保证金时间")
    private String futuresDate;

    /** 事由 */
    @Excel(name = "事由")
    private String reason;

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
    public void setFuturesNO(String futuresNO) 
    {
        this.futuresNO = futuresNO;
    }

    public String getFuturesNO() 
    {
        return futuresNO;
    }
    public void setFuturesMarginCompany(String futuresMarginCompany) 
    {
        this.futuresMarginCompany = futuresMarginCompany;
    }

    public String getFuturesMarginCompany() 
    {
        return futuresMarginCompany;
    }
    public void setTargetType(String targetType) 
    {
        this.targetType = targetType;
    }

    public String getTargetType() 
    {
        return targetType;
    }
    public void setTarget(String target) 
    {
        this.target = target;
    }

    public String getTarget() 
    {
        return target;
    }
    public void setMoneyAmount(Double moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Double getMoneyAmount() 
    {
        return moneyAmount;
    }
    public void setTargetAcountsName(String targetAcountsName) 
    {
        this.targetAcountsName = targetAcountsName;
    }

    public String getTargetAcountsName() 
    {
        return targetAcountsName;
    }
    public void setTargetBankNo(String targetBankNo) 
    {
        this.targetBankNo = targetBankNo;
    }

    public String getTargetBankNo() 
    {
        return targetBankNo;
    }
    public void setTargetBankName(String targetBankName) 
    {
        this.targetBankName = targetBankName;
    }

    public String getTargetBankName() 
    {
        return targetBankName;
    }
    public void setSelfAcountsName(String selfAcountsName) 
    {
        this.selfAcountsName = selfAcountsName;
    }

    public String getSelfAcountsName() 
    {
        return selfAcountsName;
    }
    public void setSelfBankNo(String selfBankNo) 
    {
        this.selfBankNo = selfBankNo;
    }

    public String getSelfBankNo() 
    {
        return selfBankNo;
    }
    public void setSelfBankName(String selfBankName) 
    {
        this.selfBankName = selfBankName;
    }

    public String getSelfBankName() 
    {
        return selfBankName;
    }
    public void setFuturesDate(String futuresDate) 
    {
        this.futuresDate = futuresDate;
    }

    public String getFuturesDate() 
    {
        return futuresDate;
    }
    public void setReason(String reason) 
    {
        this.reason = reason;
    }

    public String getReason() 
    {
        return reason;
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
            .append("futuresNO", getFuturesNO())
            .append("futuresMarginCompany", getFuturesMarginCompany())
            .append("targetType", getTargetType())
            .append("target", getTarget())
            .append("moneyAmount", getMoneyAmount())
            .append("targetAcountsName", getTargetAcountsName())
            .append("targetBankNo", getTargetBankNo())
            .append("targetBankName", getTargetBankName())
            .append("selfAcountsName", getSelfAcountsName())
            .append("selfBankNo", getSelfBankNo())
            .append("selfBankName", getSelfBankName())
            .append("futuresDate", getFuturesDate())
            .append("reason", getReason())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
