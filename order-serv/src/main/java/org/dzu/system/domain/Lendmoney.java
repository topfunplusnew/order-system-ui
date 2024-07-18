package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

/**
 * 借贷对象 lendmoney
 * 
 * @author ml
 * @date 2024-07-18
 */
public class Lendmoney extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 付款编号（UUID） */
    @Excel(name = "付款编号", readConverterExp = "U=UID")
    private String payNO;

    /** 金额 */
    @Excel(name = "金额")
    private Long moneyAmount;

    /** 借出类型（公司/个人） */
    @Excel(name = "借出类型", readConverterExp = "公=司/个人")
    private String lendType;

    /** 公司/个人名称 */
    @Excel(name = "公司/个人名称")
    private String company;

    /** 对方户名 */
    @Excel(name = "对方户名")
    private String otherAcountsName;

    /** 对方账号 */
    @Excel(name = "对方账号")
    private String otherBankNo;

    /** 对方开户行 */
    @Excel(name = "对方开户行")
    private String otherBankName;

    /** 对方账号ID */
    @Excel(name = "对方账号ID")
    private String otherBankID;

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

    /** 打入账户 */
    @Excel(name = "打入账户")
    private String acountsName;

    /** 打入账号 */
    @Excel(name = "打入账号")
    private String bankNo;

    /** 打入时间 */
    @Excel(name = "打入时间")
    private String payTime;

    /** 缘由 */
    @Excel(name = "缘由")
    private Long originReason;

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
    public void setPayNO(String payNO) 
    {
        this.payNO = payNO;
    }

    public String getPayNO() 
    {
        return payNO;
    }
    public void setMoneyAmount(Long moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Long getMoneyAmount() 
    {
        return moneyAmount;
    }
    public void setLendType(String lendType) 
    {
        this.lendType = lendType;
    }

    public String getLendType() 
    {
        return lendType;
    }
    public void setCompany(String company) 
    {
        this.company = company;
    }

    public String getCompany() 
    {
        return company;
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
    public void setOtherBankID(String otherBankID) 
    {
        this.otherBankID = otherBankID;
    }

    public String getOtherBankID() 
    {
        return otherBankID;
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
    public void setPayTime(String payTime) 
    {
        this.payTime = payTime;
    }

    public String getPayTime() 
    {
        return payTime;
    }
    public void setOriginReason(Long originReason) 
    {
        this.originReason = originReason;
    }

    public Long getOriginReason() 
    {
        return originReason;
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
            .append("payNO", getPayNO())
            .append("moneyAmount", getMoneyAmount())
            .append("lendType", getLendType())
            .append("company", getCompany())
            .append("otherAcountsName", getOtherAcountsName())
            .append("otherBankNo", getOtherBankNo())
            .append("otherBankName", getOtherBankName())
            .append("otherBankID", getOtherBankID())
            .append("selfAcountsName", getSelfAcountsName())
            .append("selfBankNo", getSelfBankNo())
            .append("selfBankName", getSelfBankName())
            .append("selfBankID", getSelfBankID())
            .append("acountsName", getAcountsName())
            .append("bankNo", getBankNo())
            .append("payTime", getPayTime())
            .append("originReason", getOriginReason())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
