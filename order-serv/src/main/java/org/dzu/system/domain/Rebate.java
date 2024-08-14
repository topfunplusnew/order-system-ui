package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.util.List;

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
    @Excel(name = "订单编号")
    @Length(max = 400, message = "订单编号长度不能超过400个字符")
    @NotNull(message = "订单编号不能为空")
    @TableField(value = "orderDetailID")
    private String orderDetailID;

    /** 日期 */
    @Excel(name = "日期")
    @TableField(value = "rebateDate")
    private String rebateDate;

    /** 金额 */
    @DecimalMaxDigits
    @TableField(value = "rebate")
    private Double rebate;

    /** 类型（返利、降价、售后质量赔偿） */
    @Excel(name = "类型")
    @Pattern(regexp = "返利|降价|售后质量赔偿", message = "类型格式错误")
    @TableField(value = "rebateType")
    private String rebateType;

    /** 收款户名 */
    @Excel(name = "收款户名")
    @NotNull(message = "收款户名不能为空")
    @Length(max = 32, message = "收款户名长度不能超过32个字符")
    @TableField(value = "inAcountsName")
    private String inAcountsName;

    /** 收款账号 */
    @Excel(name = "收款账号")
    @NotNull(message = "收款账号不能为空")
    @Length(max = 32, message = "收款账号长度不能超过32个字符")
    @TableField(value = "inBankNo")
    private String inBankNo;

    /** 供应商 */
    @Excel(name = "供应商")
    @NotNull(message = "供应商不能为空")
    @Length(max = 20, message = "供应商长度不能超过20个字符")
    @TableField(value = "supplier")
    private String supplier;

    /** 供应商ID */
    @Excel(name = "供应商ID")
    @NotNull(message = "供应商ID不能为空")
    @TableField(value = "supplierID")
    private Long supplierID;

    /** 付款户名 */
    @Excel(name = "付款户名")
    @Length(max = 32, message = "付款户名长度不能超过32个字符")
    @NotNull(message = "付款户名不能为空")
    @TableField(value = "outAcountsName")
    private String outAcountsName;

    /** 付款账号 */
    @Excel(name = "付款账号")
    @NotNull(message = "付款账号不能为空")
    @Length(max = 32, message = "付款账号长度不能超过32个字符")
    @TableField(value = "outBankNo")
    private String outBankNo;

    /** 返利原因 */
    @Excel(name = "返利原因")
    @Length(max = 255, message = "返利原因长度不能超过255个字符")
    @NotNull(message = "返利原因不能为空")
    @TableField(value = "rebateReason")
    private String rebateReason;

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

    /** 对应的订单详情 */
    @TableField(exist = false)
    private List<OrderDetail> orderDetails;




    // 接下来的字段不关联返利,仅仅是传递搜索信息

    /** 订单的开始时间 */
    @TableField(exist = false)
    private String orderStartTime;
    /** 订单的结束时间 */
    @TableField(exist = false)
    private String orderEndTime;

    /** 返利的开始时间 */
    @TableField(exist = false)
    private String rebateStartTime;
    /** 返利的结束时间 */
    @TableField(exist = false)
    private String rebateEndTime;

    public String getRebateStartTime() {
        return rebateStartTime;
    }

    public void setRebateStartTime(String rebateStartTime) {
        this.rebateStartTime = rebateStartTime;
    }

    public String getRebateEndTime() {
        return rebateEndTime;
    }

    public void setRebateEndTime(String rebateEndTime) {
        this.rebateEndTime = rebateEndTime;
    }

    public String getOrderStartTime() {
        return orderStartTime;
    }

    public void setOrderStartTime(String orderStartTime) {
        this.orderStartTime = orderStartTime;
    }

    public String getOrderEndTime() {
        return orderEndTime;
    }

    public void setOrderEndTime(String orderEndTime) {
        this.orderEndTime = orderEndTime;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public String getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(String orderDetailID) {
        this.orderDetailID = orderDetailID;
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
            .append("ordetDetaildId", getOrderDetailID())
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
