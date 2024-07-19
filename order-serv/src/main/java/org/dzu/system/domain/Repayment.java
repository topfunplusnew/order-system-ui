package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

/**
 * 还款记录对象 repayment
 * 
 * @author ml
 * @date 2024-07-19
 */
public class Repayment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 贷款编号（UUID） */
    @Excel(name = "贷款编号", readConverterExp = "U=UID")
    private String loanNO;

    /** 还款编号（UUID） */
    @Excel(name = "还款编号", readConverterExp = "U=UID")
    private String payNO;

    /** 还（本）金额 */
    @Excel(name = "还", readConverterExp = "本=")
    private Long moneyAmount;

    /** 付息（金额） */
    @Excel(name = "付息", readConverterExp = "金=额")
    private Long ratio;

    /** 还款日期 */
    @Excel(name = "还款日期")
    private String payDate;

    /** 还款账户 */
    @Excel(name = "还款账户")
    private String acountsName;

    /** 还款账号 */
    @Excel(name = "还款账号")
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
    public void setRatio(Long ratio) 
    {
        this.ratio = ratio;
    }

    public Long getRatio() 
    {
        return ratio;
    }
    public void setPayDate(String payDate) 
    {
        this.payDate = payDate;
    }

    public String getPayDate() 
    {
        return payDate;
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
            .append("payNO", getPayNO())
            .append("moneyAmount", getMoneyAmount())
            .append("ratio", getRatio())
            .append("payDate", getPayDate())
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
