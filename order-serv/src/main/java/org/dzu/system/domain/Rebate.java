package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

/**
 * 供应商返利对象 rebate
 * 
 * @author ml
 * @date 2024-07-19
 */
public class Rebate extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号", readConverterExp = "U=UID")
    private String ordersNo;

    /** 日期 */
    @Excel(name = "日期")
    private String rebateDate;

    /** 金额 */
    @Excel(name = "金额")
    private Long rebate;

    /** 返利类型（返利、降价、售后质量赔偿） */
    @Excel(name = "返利类型", readConverterExp = "返=利、降价、售后质量赔偿")
    private String rebateType;

    /** 收款户名 */
    @Excel(name = "收款户名")
    private String inAcountsName;

    /** 收款账号 */
    @Excel(name = "收款账号")
    private String inBankNo;

    /** 供应商 */
    @Excel(name = "供应商")
    private String supplier;

    /** 供应商ID */
    @Excel(name = "供应商ID")
    private Long supplierId;

    /** 付款户名 */
    @Excel(name = "付款户名")
    private String outAcountsName;

    /** 付款款账号 */
    @Excel(name = "付款款账号")
    private String outBankNo;

    /** 返利原因 */
    @Excel(name = "返利原因")
    private String rebateReason;

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
    public void setOrdersNo(String ordersNo) 
    {
        this.ordersNo = ordersNo;
    }

    public String getOrdersNo() 
    {
        return ordersNo;
    }
    public void setRebateDate(String rebateDate) 
    {
        this.rebateDate = rebateDate;
    }

    public String getRebateDate() 
    {
        return rebateDate;
    }
    public void setRebate(Long rebate) 
    {
        this.rebate = rebate;
    }

    public Long getRebate() 
    {
        return rebate;
    }
    public void setRebateType(String rebateType) 
    {
        this.rebateType = rebateType;
    }

    public String getRebateType() 
    {
        return rebateType;
    }
    public void setInAcountsName(String inAcountsName) 
    {
        this.inAcountsName = inAcountsName;
    }

    public String getInAcountsName() 
    {
        return inAcountsName;
    }
    public void setInBankNo(String inBankNo) 
    {
        this.inBankNo = inBankNo;
    }

    public String getInBankNo() 
    {
        return inBankNo;
    }
    public void setSupplier(String supplier) 
    {
        this.supplier = supplier;
    }

    public String getSupplier() 
    {
        return supplier;
    }
    public void setSupplierId(Long supplierId) 
    {
        this.supplierId = supplierId;
    }

    public Long getSupplierId() 
    {
        return supplierId;
    }
    public void setOutAcountsName(String outAcountsName) 
    {
        this.outAcountsName = outAcountsName;
    }

    public String getOutAcountsName() 
    {
        return outAcountsName;
    }
    public void setOutBankNo(String outBankNo) 
    {
        this.outBankNo = outBankNo;
    }

    public String getOutBankNo() 
    {
        return outBankNo;
    }
    public void setRebateReason(String rebateReason) 
    {
        this.rebateReason = rebateReason;
    }

    public String getRebateReason() 
    {
        return rebateReason;
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
            .append("rebateDate", getRebateDate())
            .append("rebate", getRebate())
            .append("rebateType", getRebateType())
            .append("inAcountsName", getInAcountsName())
            .append("inBankNo", getInBankNo())
            .append("supplier", getSupplier())
            .append("supplierId", getSupplierId())
            .append("outAcountsName", getOutAcountsName())
            .append("outBankNo", getOutBankNo())
            .append("rebateReason", getRebateReason())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
