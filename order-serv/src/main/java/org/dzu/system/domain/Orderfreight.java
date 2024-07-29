package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.OnlyZeroOrOne;
/**
 * 订单运费对象 orderfreight
 * 
 * @author ml
 * @date 2024-07-29
 */
public class Orderfreight extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号", readConverterExp = "U=UID")
    private String ordersNo;

    /** 运费类型（ 陆运、海运） */
    @Excel(name = "运费类型", readConverterExp = "陆=运、海运")
    private String freightState;

    /** 金额 */
    @Excel(name = "金额")
    private String moneyAmount;

    /** 己方户名 */
    @Excel(name = "己方户名")
    private String selfAcountsName;

    /** 己方账号 */
    @Excel(name = "己方账号")
    private String selfBankNo;

    /** 己方开户行 */
    @Excel(name = "己方开户行")
    private String selfBankName;

    /** 对方户名 */
    @Excel(name = "对方户名")
    private String otherAcountsName;

    /** 对方账号 */
    @Excel(name = "对方账号")
    private String otherBankNo;

    /** 对方开户行 */
    @Excel(name = "对方开户行")
    private String otherBankName;

    /** 备注 */
    @Excel(name = "备注")
    private String content;

    /** 支付状态（ 已支付、 未支付、  申请中） */
    @Excel(name = "支付状态", readConverterExp = "已=支付、,未=支付、,申=请中")
    private String paymentState;

    /** 司机姓名 */
    @Excel(name = "司机姓名")
    private String driverName;

    /** 司机ID */
    @Excel(name = "司机ID")
    private Long driverId;

    /** 车牌号 */
    @Excel(name = "车牌号")
    private String CarNo;

    /** 车队 */
    @Excel(name = "车队")
    private String fleet;

    /** 备注 */
    @Excel(name = "备注")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间")
    private String addtime;

    /** 申请人员ID */
    @Excel(name = "申请人员ID")
    private Long applyUserId;

    /** 申请人员姓名 */
    @Excel(name = "申请人员姓名")
    private String applyUserName;

    /** 申请日期 */
    @Excel(name = "申请日期")
    private String applyDate;

    /** 是否可编辑 */
    @Excel(name = "是否可编辑")
    private Long isedit;

    /** 付款人员ID */
    @Excel(name = "付款人员ID")
    private Long payUserId;

    /** 付款人员姓名 */
    @Excel(name = "付款人员姓名")
    private String payUserName;

    /** 付款日期 */
    @Excel(name = "付款日期")
    private String payDate;

    /** 作废标记 */
    @OnlyZeroOrOne
    private Long cancelFlag;

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
    public void setFreightState(String freightState) 
    {
        this.freightState = freightState;
    }

    public String getFreightState() 
    {
        return freightState;
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
    public void setCarNo(String CarNo) 
    {
        this.CarNo = CarNo;
    }

    public String getCarNo() 
    {
        return CarNo;
    }
    public void setFleet(String fleet) 
    {
        this.fleet = fleet;
    }

    public String getFleet() 
    {
        return fleet;
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
            .append("freightState", getFreightState())
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
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("applyUserId", getApplyUserId())
            .append("applyUserName", getApplyUserName())
            .append("applyDate", getApplyDate())
            .append("isedit", getIsedit())
            .append("payUserId", getPayUserId())
            .append("payUserName", getPayUserName())
            .append("payDate", getPayDate())
            .append("cancelFlag", getCancelFlag())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
