package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 订单运费对象 orderFreight
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("orderFreight")
public class OrderFreight extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号")
    @Length(max = 40, message = "订单编号长度不能超过40个字符")
    @TableField(value = "ordersNo")
    private String ordersNo;

    /** 运费类型（ 陆运、海运） */
    @Excel(name = "运费类型")
    @NotNull(message = "运费类型不能为空")
    @Pattern(regexp = "陆运|海运", message = "运费类型必须是：陆运或海运")
    @TableField(value = "freightType")
    private String freightType;

    /** 金额 */
    @Excel(name = "金额")
    @TableField(value = "moneyAmount")
    private String moneyAmount;

    /** 己方户名 */
    @Excel(name = "己方户名")
    @Length(max = 20, message = "己方户名长度不能超过20个字符")
    @NotNull(message = "己方户名不能为空")
    @TableField(value = "selfAcountsName")
    private String selfAcountsName;

    /** 己方账号 */
    @Excel(name = "己方账号")
    @Length(max = 20, message = "己方账号长度不能超过20个字符")
    @NotNull(message = "己方账号不能为空")
    @TableField(value = "selfBankNo")
    private String selfBankNo;

    /** 己方开户行 */
    @Excel(name = "己方开户行")
    @Length(max = 20, message = "己方开户行长度不能超过20个字符")
    @TableField(value = "selfBankName")
    private String selfBankName;

    /** 对方户名 */
    @Excel(name = "对方户名")
    @NotNull(message = "对方户名不能为空")
    @Length(max = 20, message = "对方户名长度不能超过20个字符")
    @TableField(value = "otherAcountsName")
    private String otherAcountsName;

    /** 对方账号 */
    @Excel(name = "对方账号")
    @NotNull(message = "对方账号不能为空")
    @Length(max = 20, message = "对方账号长度不能超过20个字符")
    @TableField(value = "otherBankNo")
    private String otherBankNo;

    /** 对方开户行 */
    @Excel(name = "对方开户行")
    @Length(max = 20, message = "对方开户行长度不能超过20个字符")
    @TableField(value = "otherBankName")
    private String otherBankName;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
    @TableField(value = "content")
    private String content;

    /** 支付状态（ 已支付、 未支付、  申请中） */
    @Excel(name = "支付状态")
    @Pattern(regexp = "已支付|未支付|申请中", message = "支付状态必须是：已支付或未支付或申请中")
    @TableField(value = "paymentState")
    private String paymentState;

    /** 司机姓名 */
    @Excel(name = "司机姓名")
    @Length(max = 20, message = "司机姓名的字符长度不允许超过20")
    @NotNull(message = "司机姓名不能为空")
    @TableField(value = "driverName")
    private String driverName;

    /** 司机ID */
    @Excel(name = "司机ID")
    @NotNull(message = "司机ID不能为空")
    @TableField(value = "driverId")
    private Long driverId;

    /** 车牌号 */
    @Excel(name = "车牌号")
    @NotNull(message = "车牌号不能为空")
    @Length(max = 32, message = "车牌号的字符长度不允许超过20")
    @TableField(value = "CarNo")
    private String carNo;

    /** 车队 */
    @Excel(name = "车队")
    @Length(max = 20, message = "车队的字符长度不允许超过20")
    @NotNull(message = "车队不能为空")
    @TableField(value = "fleet")
    private String fleet;

    /** 申请人员ID */
    @Excel(name = "申请人员ID")
    @TableField(value = "applyUserId")
    private Long applyUserId;

    /** 申请人员姓名 */
    @Excel(name = "申请人员姓名")
    @Length(max = 20, message = "申请人员姓名的字符长度不允许超过20")
    @TableField(value = "applyUserName")
    private String applyUserName;

    /** 申请日期 */
    @Excel(name = "申请日期")
    @TableField(value = "applyDate")
    private String applyDate;

    /** 是否可编辑 */
    @Excel(name = "是否可编辑")
    @TableField(value = "isedit")
    private Long isedit;

    /** 付款人员ID */
    @Excel(name = "付款人员ID")
    @TableField(value = "payUserId")
    private Long payUserId;

    /** 付款人员姓名 */
    @Excel(name = "付款人员姓名")
    @Length(max = 20, message = "付款人员姓名的字符长度不允许超过20")
    @TableField(value = "payUserName")
    private String payUserName;

    /** 付款日期 */
    @Excel(name = "付款日期")
    @TableField(value = "payDate")
    private String payDate;

    /** 作废标记 */
    @FlagOnlyZeroOrOne
    @TableField(value = "cancelFlag")
    private Long cancelFlag;

    /** 备注 */
    @Excel(name = "备注")
    @TableField(value = "comments")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
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

    /** 额外字段 */
    @Excel(name = "审核状态")
    @TableField(exist = false)
    private String checkState;

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
    public void setFreightType(String freightType) 
    {
        this.freightType = freightType;
    }

    public String getFreightType() 
    {
        return freightType;
    }
    public void setMoneyAmount(String moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public String getMoneyAmount() 
    {
        return moneyAmount;
    }
    public void setSelfAcountsName(String selfAcountsName) 
    {
        this.selfAcountsName = selfAcountsName;
    }

    public String getSelfAcountsName() 
    {
        return selfAcountsName;
    }
    public void setSelfBankNo(String selfBankNo) 
    {
        this.selfBankNo = selfBankNo;
    }

    public String getSelfBankNo() 
    {
        return selfBankNo;
    }
    public void setSelfBankName(String selfBankName) 
    {
        this.selfBankName = selfBankName;
    }

    public String getSelfBankName() 
    {
        return selfBankName;
    }
    public void setOtherAcountsName(String otherAcountsName) 
    {
        this.otherAcountsName = otherAcountsName;
    }

    public String getOtherAcountsName() 
    {
        return otherAcountsName;
    }
    public void setOtherBankNo(String otherBankNo) 
    {
        this.otherBankNo = otherBankNo;
    }

    public String getOtherBankNo() 
    {
        return otherBankNo;
    }
    public void setOtherBankName(String otherBankName) 
    {
        this.otherBankName = otherBankName;
    }

    public String getOtherBankName() 
    {
        return otherBankName;
    }
    public void setContent(String content) 
    {
        this.content = content;
    }

    public String getContent() 
    {
        return content;
    }
    public void setPaymentState(String paymentState) 
    {
        this.paymentState = paymentState;
    }

    public String getPaymentState() 
    {
        return paymentState;
    }
    public void setDriverName(String driverName) 
    {
        this.driverName = driverName;
    }

    public String getDriverName() 
    {
        return driverName;
    }
    public void setDriverId(Long driverId) 
    {
        this.driverId = driverId;
    }

    public Long getDriverId() 
    {
        return driverId;
    }

    public String getCarNo() {
        return carNo;
    }

    public void setCarNo(@NotNull(message = "车牌号不能为空") @Length(max = 32, message = "车牌号的字符长度不允许超过20") String carNo) {
        this.carNo = carNo;
    }

    public void setFleet(String fleet)
    {
        this.fleet = fleet;
    }

    public String getFleet() 
    {
        return fleet;
    }
    public void setApplyUserId(Long applyUserId) 
    {
        this.applyUserId = applyUserId;
    }

    public Long getApplyUserId() 
    {
        return applyUserId;
    }
    public void setApplyUserName(String applyUserName) 
    {
        this.applyUserName = applyUserName;
    }

    public String getApplyUserName() 
    {
        return applyUserName;
    }
    public void setApplyDate(String applyDate) 
    {
        this.applyDate = applyDate;
    }

    public String getApplyDate() 
    {
        return applyDate;
    }
    public void setIsedit(Long isedit) 
    {
        this.isedit = isedit;
    }

    public Long getIsedit() 
    {
        return isedit;
    }
    public void setPayUserId(Long payUserId) 
    {
        this.payUserId = payUserId;
    }

    public Long getPayUserId() 
    {
        return payUserId;
    }
    public void setPayUserName(String payUserName) 
    {
        this.payUserName = payUserName;
    }

    public String getPayUserName() 
    {
        return payUserName;
    }
    public void setPayDate(String payDate) 
    {
        this.payDate = payDate;
    }

    public String getPayDate() 
    {
        return payDate;
    }
    public void setCancelFlag(Long cancelFlag) 
    {
        this.cancelFlag = cancelFlag;
    }

    public Long getCancelFlag() 
    {
        return cancelFlag;
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

    public String getCheckState() {
        return checkState;
    }

    public void setCheckState(String checkState) {
        this.checkState = checkState;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("ordersNo", getOrdersNo())
            .append("freightType", getFreightType())
            .append("moneyAmount", getMoneyAmount())
            .append("selfAcountsName", getSelfAcountsName())
            .append("selfBankNo", getSelfBankNo())
            .append("selfBankName", getSelfBankName())
            .append("otherAcountsName", getOtherAcountsName())
            .append("otherBankNo", getOtherBankNo())
            .append("otherBankName", getOtherBankName())
            .append("content", getContent())
            .append("paymentState", getPaymentState())
            .append("driverName", getDriverName())
            .append("driverId", getDriverId())
            .append("CarNo", getCarNo())
            .append("fleet", getFleet())
            .append("applyUserId", getApplyUserId())
            .append("applyUserName", getApplyUserName())
            .append("applyDate", getApplyDate())
            .append("isedit", getIsedit())
            .append("payUserId", getPayUserId())
            .append("payUserName", getPayUserName())
            .append("payDate", getPayDate())
            .append("cancelFlag", getCancelFlag())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
