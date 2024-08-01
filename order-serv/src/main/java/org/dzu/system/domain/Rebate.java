package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
/**
 * 返利回扣对象 Rebate
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("Rebate")
public class Rebate extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号", readConverterExp = "U=UID")
    @TableField(value = "ordersNo")
    private String ordersNo;

    /** 日期 */
    @Excel(name = "日期")
    @TableField(value = "rebateDate")
    private String rebateDate;

    /** 金额 */
    @DecimalMaxDigits
    @TableField(value = "rebate")
    private Double rebate;

    /** 类型（返利、降价、售后质量赔偿） */
    @Excel(name = "类型", readConverterExp = "返=利、降价、售后质量赔偿")
    @TableField(value = "rebateType")
    private String rebateType;

    /** 收款户名 */
    @Excel(name = "收款户名")
    @TableField(value = "inAcountsName")
    private String inAcountsName;

    /** 收款账号 */
    @Excel(name = "收款账号")
    @TableField(value = "inBankNo")
    private String inBankNo;

    /** 供应商 */
    @Excel(name = "供应商")
    @TableField(value = "supplier")
    private String supplier;

    /** 供应商ID */
    @Excel(name = "供应商ID")
    @TableField(value = "supplierID")
    private Long supplierID;

    /** 付款户名 */
    @Excel(name = "付款户名")
    @TableField(value = "outAcountsName")
    private String outAcountsName;

    /** 付款款账号 */
    @Excel(name = "付款款账号")
    @TableField(value = "outBankNo")
    private String outBankNo;

    /** 返利原因 */
    @Excel(name = "返利原因")
    @TableField(value = "rebateReason")
    private String rebateReason;

    /** 备注 */
    @Excel(name = "备注")
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
    @OnlyZeroOrOne
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
    public void setRebateDate(String rebateDate) 
    {
        this.rebateDate = rebateDate;
    }

    public String getRebateDate() 
    {
        return rebateDate;
    }
    public void setRebate(Double rebate) 
    {
        this.rebate = rebate;
    }

    public Double getRebate() 
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
    public void setSupplierID(Long supplierID) 
    {
        this.supplierID = supplierID;
    }

    public Long getSupplierID() 
    {
        return supplierID;
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
            .append("supplierID", getSupplierID())
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
