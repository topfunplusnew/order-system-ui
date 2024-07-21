package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 恢复期货保证金？对象 recoverfuturesmargin
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public class Recoverfuturesmargin extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 保证金编号（UUID） */
    @Excel(name = "保证金编号", readConverterExp = "U=UID")
    private String futuresNO;

    /** 还款编号（UUID） */
    @Excel(name = "还款编号", readConverterExp = "U=UID")
    private String recoverNO;

    /** 收回金额 */
    @Excel(name = "收回金额")
    private Long moneyAmount;

    /** 收回日期 */
    @Excel(name = "收回日期")
    private String recoverDate;

    /** 收回账户 */
    @Excel(name = "收回账户")
    private String acountsName;

    /** 收回账号 */
    @Excel(name = "收回账号")
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
    public void setRecoverNO(String recoverNO) 
    {
        this.recoverNO = recoverNO;
    }

    public String getRecoverNO() 
    {
        return recoverNO;
    }
    public void setMoneyAmount(Long moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Long getMoneyAmount() 
    {
        return moneyAmount;
    }
    public void setRecoverDate(String recoverDate) 
    {
        this.recoverDate = recoverDate;
    }

    public String getRecoverDate() 
    {
        return recoverDate;
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

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("futuresNO", getFuturesNO())
            .append("recoverNO", getRecoverNO())
            .append("moneyAmount", getMoneyAmount())
            .append("recoverDate", getRecoverDate())
            .append("acountsName", getAcountsName())
            .append("bankNo", getBankNo())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
