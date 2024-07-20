package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 虚拟银行账户变动信息对象 virtualbankaccountchange
 * 
 * @author ml
 * @date 2024-07-19
 */
public class Virtualbankaccountchange extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;


    /** 公司ID */
    @Excel(name = "公司ID")
    @Length(max = 80, message = "公司ID不能超过80个字符")
    private String companyId;

    /** 发生操作行为的表 */
    @Excel(name = "发生操作行为的表")
    private String tableName;

    /** 发生操作行为的冲抵款编号（UUID） */
    @Excel(name = "发生操作行为的冲抵款编号")
    private String payNO;

    /** 日期 */
    @Excel(name = "日期")
    @Length(max = 50, message = "日期不能超过50个字符")
    private String operateDate;

    /** 变动类型（收入、支出） */
    @Excel(name = "变动类型")
    @Pattern(regexp = "收入|支出",message = "变动类型只能为收入或者支出")
    @Length(max = 15, message = "变动类型不能超过15个字符")
    private String changeType;

    /** 金额 */
    @Excel(name = "金额")
    @DecimalMaxDigits
    @NotNull(message = "金额不能为空")
    private Double moneyAmount;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注不能超过200个字符")
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
    public void setCompanyId(String companyId) 
    {
        this.companyId = companyId;
    }

    public String getCompanyId() 
    {
        return companyId;
    }
    public void setTableName(String tableName) 
    {
        this.tableName = tableName;
    }

    public String getTableName() 
    {
        return tableName;
    }
    public void setPayNO(String payNO) 
    {
        this.payNO = payNO;
    }

    public String getPayNO() 
    {
        return payNO;
    }
    public void setOperateDate(String operateDate) 
    {
        this.operateDate = operateDate;
    }

    public String getOperateDate() 
    {
        return operateDate;
    }
    public void setChangeType(String changeType) 
    {
        this.changeType = changeType;
    }

    public String getChangeType() 
    {
        return changeType;
    }
    public void setMoneyAmount(Double moneyAmount)
    {
        this.moneyAmount = moneyAmount;
    }

    public Double getMoneyAmount()
    {
        return moneyAmount;
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
            .append("companyId", getCompanyId())
            .append("tableName", getTableName())
            .append("payNO", getPayNO())
            .append("operateDate", getOperateDate())
            .append("changeType", getChangeType())
            .append("moneyAmount", getMoneyAmount())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
