package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 商家直接给客户开发票对象 invoiceOther
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("invoiceOther")
public class InvoiceOther extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号")
    @Length(max = 32, message = "订单编号长度不能超过32个字符")
    @TableField(value = "ordersNo")
    private String ordersNo;

    /** 开票日期 */
    @Excel(name = "开票日期",dateFormat = "yyyy-MM-dd")
    @TableField(value = "invoiceDate")
    private String invoiceDate;

    /** 开票金额 */
    @DecimalMaxDigits
    @NotNull(message = "开票金额不能为空")
    @TableField(value = "invoiceAmount")
    private Double invoiceAmount;

    /** 供应商票点 */
    @DecimalMaxDigits
    @NotNull(message = "供应商票点不能为空")
    @TableField(value = "supplierTicketPoint")
    private Double supplierTicketPoint;

    /** 供应商票点金额（开票金额*供应商票点） */
    @Excel(name = "供应商票点金额", readConverterExp = "供应商票点金额=开票金额*供应商票点")
    @NotNull(message = "供应商票点金额不能为空")
    @TableField(value = "supplierPointAmount")
    private Double supplierPointAmount;

    /** 供应商公司名称 */
    @Excel(name = "供应商公司名称")
    @Length(max = 32, message = "供应商公司名称长度不能超过32个字符")
    @NotNull(message = "供应商公司名称不能为空")
    @TableField(value = "Supplier")
    private String Supplier;

    /** 供应商ID */
    @Excel(name = "供应商ID")
    @NotNull(message = "供应商ID不能为空")
    @Length(max = 32, message = "供应商ID长度不能超过32个字符")
    @TableField(value = "SupplierID")
    private Long SupplierID;

    /** 客户公司名称 */
    @Excel(name = "客户公司名称")
    @Length(max = 32, message = "客户公司名称长度不能超过32个字符")
    @NotNull(message = "客户公司名称不能为空")
    @TableField(value = "customer")
    private String customer;

    /** 客户ID */
    @Excel(name = "客户ID")
    @Length(max = 32, message = "客户ID长度不能超过32个字符")
    @NotNull(message = "客户ID不能为空")
    @TableField(value = "CustomerID")
    private Long CustomerID;

    /** 票据单位名称 */
    @Excel(name = "票据单位名称")
    @Length(max = 32, message = "票据单位名称长度不能超过32个字符")
    @NotNull(message = "票据单位名称不能为空")
    @TableField(value = "invoiceCompanyName")
    private String invoiceCompanyName;

    /** 客户票点 */
    @DecimalMaxDigits
    @NotNull(message = "客户票点不能为空")
    @TableField(value = "customerTicketPoint")
    private Double customerTicketPoint;

    /** 票点金额（开票金额*客户票点） */
    @Excel(name = "票点金额", readConverterExp = "开=票金额*客户票点")
    @TableField(value = "customerPointAmount")
    private Double customerPointAmount;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 255, message = "备注长度不能超过255个字符")
    @TableField(value = "comments")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间")
    @TableField(value = "addtime")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    @TableField(value = "userId")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    @TableField(value = "UserName")
    private String UserName;

    /** 删除标记 */
    @FlagOnlyZeroOrOne
    @TableField(value = "delFlag")
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
    public void setInvoiceAmount(Double invoiceAmount) 
    {
        this.invoiceAmount = invoiceAmount;
    }

    public Double getInvoiceAmount() 
    {
        return invoiceAmount;
    }
    public void setSupplierTicketPoint(Double supplierTicketPoint) 
    {
        this.supplierTicketPoint = supplierTicketPoint;
    }

    public Double getSupplierTicketPoint() 
    {
        return supplierTicketPoint;
    }
    public void setSupplierPointAmount(Double supplierPointAmount) 
    {
        this.supplierPointAmount = supplierPointAmount;
    }

    public Double getSupplierPointAmount() 
    {
        return supplierPointAmount;
    }
    public void setSupplier(String Supplier) 
    {
        this.Supplier = Supplier;
    }

    public String getSupplier() 
    {
        return Supplier;
    }
    public void setSupplierID(Long SupplierID) 
    {
        this.SupplierID = SupplierID;
    }

    public Long getSupplierID() 
    {
        return SupplierID;
    }
    public void setCustomer(String customer) 
    {
        this.customer = customer;
    }

    public String getCustomer() 
    {
        return customer;
    }
    public void setCustomerID(Long CustomerID) 
    {
        this.CustomerID = CustomerID;
    }

    public Long getCustomerID() 
    {
        return CustomerID;
    }
    public void setInvoiceCompanyName(String invoiceCompanyName) 
    {
        this.invoiceCompanyName = invoiceCompanyName;
    }

    public String getInvoiceCompanyName() 
    {
        return invoiceCompanyName;
    }
    public void setCustomerTicketPoint(Double customerTicketPoint) 
    {
        this.customerTicketPoint = customerTicketPoint;
    }

    public Double getCustomerTicketPoint() 
    {
        return customerTicketPoint;
    }
    public void setCustomerPointAmount(Double customerPointAmount) 
    {
        this.customerPointAmount = customerPointAmount;
    }

    public Double getCustomerPointAmount() 
    {
        return customerPointAmount;
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
            .append("invoiceAmount", getInvoiceAmount())
            .append("supplierTicketPoint", getSupplierTicketPoint())
            .append("supplierPointAmount", getSupplierPointAmount())
            .append("Supplier", getSupplier())
            .append("SupplierID", getSupplierID())
            .append("customer", getCustomer())
            .append("CustomerID", getCustomerID())
            .append("invoiceCompanyName", getInvoiceCompanyName())
            .append("customerTicketPoint", getCustomerTicketPoint())
            .append("customerPointAmount", getCustomerPointAmount())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
