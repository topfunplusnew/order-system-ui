package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

/**
 * 资金调整单信息对象 offsetting
 * 
 * @author ml
 * @date 2024-07-18
 */
public class Offsetting extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 冲抵编号（UUID） */
    @Excel(name = "冲抵编号", readConverterExp = "U=UID")
    private String OffsetNO;

    /** 操作时间 */
    @Excel(name = "操作时间")
    private String operateDate;

    /** 冲抵类型（收入、支出） */
    @Excel(name = "冲抵类型", readConverterExp = "收=入、支出")
    private String operateType;

    /** 金额 */
    @Excel(name = "金额")
    private Long moneyAmount;

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
    public void setOffsetNO(String OffsetNO) 
    {
        this.OffsetNO = OffsetNO;
    }

    public String getOffsetNO() 
    {
        return OffsetNO;
    }
    public void setOperateDate(String operateDate) 
    {
        this.operateDate = operateDate;
    }

    public String getOperateDate() 
    {
        return operateDate;
    }
    public void setOperateType(String operateType) 
    {
        this.operateType = operateType;
    }

    public String getOperateType() 
    {
        return operateType;
    }
    public void setMoneyAmount(Long moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Long getMoneyAmount() 
    {
        return moneyAmount;
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
            .append("OffsetNO", getOffsetNO())
            .append("operateDate", getOperateDate())
            .append("operateType", getOperateType())
            .append("moneyAmount", getMoneyAmount())
            .append("company", getCompany())
            .append("companyId", getCompanyId())
            .append("companyType", getCompanyType())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
