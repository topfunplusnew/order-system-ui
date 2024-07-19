package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

/**
 * 从外部借入款、贷款对象 borrowedmoney
 * 
 * @author ml
 * @date 2024-07-19
 */
public class Borrowedmoney extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 贷款编号（UUID） */
    @Excel(name = "贷款编号", readConverterExp = "U=UID")
    private String loanNO;

    /** 贷款来源 */
    @Excel(name = "贷款来源")
    private String origin;

    /** 借入金额 */
    @Excel(name = "借入金额")
    private Long moneyAmount;

    /** 贷款利率 */
    @Excel(name = "贷款利率")
    private Long ratio;

    /** 贷款发放日期 */
    @Excel(name = "贷款发放日期")
    private String loanDate;

    /** 贷款年限（年） */
    @Excel(name = "贷款年限", readConverterExp = "年=")
    private String loanDuring;

    /** 抵押担保 */
    @Excel(name = "抵押担保")
    private String mortgageGuarantee;

    /** 打入账户 */
    @Excel(name = "打入账户")
    private String acountsName;

    /** 打入账号 */
    @Excel(name = "打入账号")
    private String bankNo;

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

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setLoanNO(String loanNO) 
    {
        this.loanNO = loanNO;
    }

    public String getLoanNO() 
    {
        return loanNO;
    }
    public void setOrigin(String origin) 
    {
        this.origin = origin;
    }

    public String getOrigin() 
    {
        return origin;
    }
    public void setMoneyAmount(Long moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Long getMoneyAmount() 
    {
        return moneyAmount;
    }
    public void setRatio(Long ratio) 
    {
        this.ratio = ratio;
    }

    public Long getRatio() 
    {
        return ratio;
    }
    public void setLoanDate(String loanDate) 
    {
        this.loanDate = loanDate;
    }

    public String getLoanDate() 
    {
        return loanDate;
    }
    public void setLoanDuring(String loanDuring) 
    {
        this.loanDuring = loanDuring;
    }

    public String getLoanDuring() 
    {
        return loanDuring;
    }
    public void setMortgageGuarantee(String mortgageGuarantee) 
    {
        this.mortgageGuarantee = mortgageGuarantee;
    }

    public String getMortgageGuarantee() 
    {
        return mortgageGuarantee;
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
            .append("loanNO", getLoanNO())
            .append("origin", getOrigin())
            .append("moneyAmount", getMoneyAmount())
            .append("ratio", getRatio())
            .append("loanDate", getLoanDate())
            .append("loanDuring", getLoanDuring())
            .append("mortgageGuarantee", getMortgageGuarantee())
            .append("acountsName", getAcountsName())
            .append("bankNo", getBankNo())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
