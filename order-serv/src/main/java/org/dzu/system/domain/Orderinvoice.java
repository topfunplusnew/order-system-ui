package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
/**
 * 订单发票对象 orderinvoice
 * 
 * @author ml
 * @date 2024-07-29
 */
public class Orderinvoice extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号", readConverterExp = "U=UID")
    private String ordersNo;

    /** 开票日期 */
    @Excel(name = "开票日期")
    private String invoiceDate;

    /** 开票类型（购入、卖出） */
    @Excel(name = "开票类型", readConverterExp = "购=入、卖出")
    private Double invoiceType;

    /** 应开票金额 */
    @DecimalMaxDigits
    private Double invoiceAmount;

    /** 公司类别（客户、供应商） */
    @Excel(name = "公司类别", readConverterExp = "客=户、供应商")
    private String companyType;

    /** 公司名称 */
    @Excel(name = "公司名称")
    private String companyName;

    /** 公司名称 */
    @Excel(name = "公司名称")
    private Long companyID;

    /** 票据单位名称 */
    @Excel(name = "票据单位名称")
    private String invoiceCompanyName;

    /** 实际开票金额 */
    @DecimalMaxDigits
    private Double actualInvoiceAmount;

    /** 票点 */
    @DecimalMaxDigits
    private Double ticketPoint;

    /** 票点金额（实际开票金额*票点） */
    @Excel(name = "票点金额", readConverterExp = "实=际开票金额*票点")
    private Double ticketPointAmount;

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
    public void setOrdersNo(String ordersNo) 
    {
        this.ordersNo = ordersNo;
    }

    public String getOrdersNo() 
    {
        return ordersNo;
    }
    public void setInvoiceDate(String invoiceDate) 
    {
        this.invoiceDate = invoiceDate;
    }

    public String getInvoiceDate() 
    {
        return invoiceDate;
    }
    public void setInvoiceType(Double invoiceType) 
    {
        this.invoiceType = invoiceType;
    }

    public Double getInvoiceType() 
    {
        return invoiceType;
    }
    public void setInvoiceAmount(Double invoiceAmount) 
    {
        this.invoiceAmount = invoiceAmount;
    }

    public Double getInvoiceAmount() 
    {
        return invoiceAmount;
    }
    public void setCompanyType(String companyType) 
    {
        this.companyType = companyType;
    }

    public String getCompanyType() 
    {
        return companyType;
    }
    public void setCompanyName(String companyName) 
    {
        this.companyName = companyName;
    }

    public String getCompanyName() 
    {
        return companyName;
    }
    public void setCompanyID(Long companyID) 
    {
        this.companyID = companyID;
    }

    public Long getCompanyID() 
    {
        return companyID;
    }
    public void setInvoiceCompanyName(String invoiceCompanyName) 
    {
        this.invoiceCompanyName = invoiceCompanyName;
    }

    public String getInvoiceCompanyName() 
    {
        return invoiceCompanyName;
    }
    public void setActualInvoiceAmount(Double actualInvoiceAmount) 
    {
        this.actualInvoiceAmount = actualInvoiceAmount;
    }

    public Double getActualInvoiceAmount() 
    {
        return actualInvoiceAmount;
    }
    public void setTicketPoint(Double ticketPoint) 
    {
        this.ticketPoint = ticketPoint;
    }

    public Double getTicketPoint() 
    {
        return ticketPoint;
    }
    public void setTicketPointAmount(Double ticketPointAmount) 
    {
        this.ticketPointAmount = ticketPointAmount;
    }

    public Double getTicketPointAmount() 
    {
        return ticketPointAmount;
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
            .append("ordersNo", getOrdersNo())
            .append("invoiceDate", getInvoiceDate())
            .append("invoiceType", getInvoiceType())
            .append("invoiceAmount", getInvoiceAmount())
            .append("companyType", getCompanyType())
            .append("companyName", getCompanyName())
            .append("companyID", getCompanyID())
            .append("invoiceCompanyName", getInvoiceCompanyName())
            .append("actualInvoiceAmount", getActualInvoiceAmount())
            .append("ticketPoint", getTicketPoint())
            .append("ticketPointAmount", getTicketPointAmount())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
