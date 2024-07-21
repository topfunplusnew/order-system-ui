package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 收付款信息对象 payment
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public class Payment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 收付款类型（收款，付款） */
    @Excel(name = "收付款类型", readConverterExp = "收=款，付款")
    private String payCategory;

    /** 付款编号（UUID） */
    @Excel(name = "付款编号", readConverterExp = "U=UID")
    private String payNO;

    /** 日期 */
    @Excel(name = "日期")
    private String fundsDate;

    /** 支付类型 */
    @Excel(name = "支付类型")
    private String payType;

    /** 金额 */
    @Excel(name = "金额")
    private Long moneyAmount;

    /** 己方户名 */
    @Excel(name = "己方户名")
    private String selfAcountsName;

    /** 己方账号 */
    @Excel(name = "己方账号")
    private String selfBankNo;

    /** 己方开户行 */
    @Excel(name = "己方开户行")
    private String selfBankName;

    /** 己方账号ID */
    @Excel(name = "己方账号ID")
    private String selfBankID;

    /** 对方户名 */
    @Excel(name = "对方户名")
    private String otherAcountsName;

    /** 对方账号 */
    @Excel(name = "对方账号")
    private String otherBankNo;

    /** 对方开户行 */
    @Excel(name = "对方开户行")
    private String otherBankName;

    /** 支付状态（已支付、未支付、申请中） */
    @Excel(name = "支付状态", readConverterExp = "已=支付、未支付、申请中")
    private String paymentState;

    /** 对方公司 */
    @Excel(name = "对方公司")
    private String company;

    /** 对方公司ID */
    @Excel(name = "对方公司ID")
    private Long companyId;

    /** 对方公司类型（1、客户 2、供应商） */
    @Excel(name = "对方公司类型", readConverterExp = "1=、客户,2=、供应商")
    private Long companyType;

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
    public void setPayCategory(String payCategory) 
    {
        this.payCategory = payCategory;
    }

    public String getPayCategory() 
    {
        return payCategory;
    }
    public void setPayNO(String payNO) 
    {
        this.payNO = payNO;
    }

    public String getPayNO() 
    {
        return payNO;
    }
    public void setFundsDate(String fundsDate) 
    {
        this.fundsDate = fundsDate;
    }

    public String getFundsDate() 
    {
        return fundsDate;
    }
    public void setPayType(String payType) 
    {
        this.payType = payType;
    }

    public String getPayType() 
    {
        return payType;
    }
    public void setMoneyAmount(Long moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Long getMoneyAmount() 
    {
        return moneyAmount;
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
    public void setSelfBankID(String selfBankID) 
    {
        this.selfBankID = selfBankID;
    }

    public String getSelfBankID() 
    {
        return selfBankID;
    }
    public void setOtherAcountsName(String otherAcountsName) 
    {
        this.otherAcountsName = otherAcountsName;
    }

    public String getOtherAcountsName() 
    {
        return otherAcountsName;
    }
    public void setOtherBankNo(String otherBankNo) 
    {
        this.otherBankNo = otherBankNo;
    }

    public String getOtherBankNo() 
    {
        return otherBankNo;
    }
    public void setOtherBankName(String otherBankName) 
    {
        this.otherBankName = otherBankName;
    }

    public String getOtherBankName() 
    {
        return otherBankName;
    }
    public void setPaymentState(String paymentState) 
    {
        this.paymentState = paymentState;
    }

    public String getPaymentState() 
    {
        return paymentState;
    }
    public void setCompany(String company) 
    {
        this.company = company;
    }

    public String getCompany() 
    {
        return company;
    }
    public void setCompanyId(Long companyId) 
    {
        this.companyId = companyId;
    }

    public Long getCompanyId() 
    {
        return companyId;
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

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("payCategory", getPayCategory())
            .append("payNO", getPayNO())
            .append("fundsDate", getFundsDate())
            .append("payType", getPayType())
            .append("moneyAmount", getMoneyAmount())
            .append("selfAcountsName", getSelfAcountsName())
            .append("selfBankNo", getSelfBankNo())
            .append("selfBankName", getSelfBankName())
            .append("selfBankID", getSelfBankID())
            .append("otherAcountsName", getOtherAcountsName())
            .append("otherBankNo", getOtherBankNo())
            .append("otherBankName", getOtherBankName())
            .append("paymentState", getPaymentState())
            .append("company", getCompany())
            .append("companyId", getCompanyId())
            .append("companyType", getCompanyType())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
