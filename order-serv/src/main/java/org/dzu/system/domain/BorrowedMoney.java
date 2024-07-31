package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/**
 * 从外部借款信息对象 borrowedMoney
 * 
 * @author ml
 * @date 2024-07-29
 */
public class BorrowedMoney extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 贷款编号（UUID） */
    @Excel(name = "贷款编号")
    @Length(max = 50, message = "贷款编号的字符长度不允许超过50")
    private String loanNO;

    /** 贷款来源 */
    @Excel(name = "贷款来源")
    @Length(max = 50, message = "贷款来源的字符长度不允许超过50")
    private String origin;

    /** 借入金额 */
    @NotNull(message = "借入金额不能为空")
    @DecimalMaxDigits
    private Double moneyAmount;

    /** 贷款利率 */
    @NotNull(message = "贷款利率不能为空")
    @DecimalMaxDigits
    private Double ratio;

    /** 贷款发放日期 */
    @Excel(name = "贷款发放日期")
    @Length(max = 50, message = "贷款发放日期的字符长度不允许超过50")
    private String loanDate;

    /** 贷款年限（年） */
    @Excel(name = "贷款年限")
    @Length(max = 50, message = "贷款年限的字符长度不允许超过50")
    private String loanDuring;

    /** 抵押担保 */
    @Excel(name = "抵押担保")
    @Length(max = 200, message = "抵押担保的字符长度不允许超过200")
    private String mortgageGuarantee;

    /** 打入账户 */
    @Excel(name = "打入账户")
    @Length(max = 80, message = "打入账户的字符长度不允许超过80")
    private String acountsName;

    /** 打入账号 */
    @Excel(name = "打入账号")
    @Length(max = 80, message = "打入账号的字符长度不允许超过80")
    private String bankNo;

    /** 已还款标记 */
    @Excel(name = "已还款标记",readConverterExp = "0=已还款,1=未还款")
    @NotNull(message = "已还款标记不能为空")
    @Max(value = 1,message = "还款标记必须为0或1")
    @Min(value = 0,message = "还款标记必须为0或1")
    private Long isEnd;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
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
    public void setMoneyAmount(Double moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Double getMoneyAmount() 
    {
        return moneyAmount;
    }
    public void setRatio(Double ratio) 
    {
        this.ratio = ratio;
    }

    public Double getRatio() 
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
    public void setIsEnd(Long isEnd) 
    {
        this.isEnd = isEnd;
    }

    public Long getIsEnd() 
    {
        return isEnd;
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
            .append("isEnd", getIsEnd())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
