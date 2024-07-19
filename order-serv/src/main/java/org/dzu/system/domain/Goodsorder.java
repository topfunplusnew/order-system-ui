package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

/**
 * 订单对象 goodsorder
 * 
 * @author ml
 * @date 2024-07-19
 */
public class Goodsorder extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号", readConverterExp = "U=UID")
    private String ordersNo;

    /** 日期 */
    @Excel(name = "日期")
    private String orderDate;

    /** 客户 */
    @Excel(name = "客户")
    private String customer;

    /** 客户ID */
    @Excel(name = "客户ID")
    private Long customerId;

    /** 陆运车辆ID */
    @Excel(name = "陆运车辆ID")
    private Long landcarId;

    /** 陆运车牌 */
    @Excel(name = "陆运车牌")
    private String landCarNo;

    /** 陆运司机电话 */
    @Excel(name = "陆运司机电话")
    private String landDriverTel;

    /** 陆地司机姓名 */
    @Excel(name = "陆地司机姓名")
    private String landDriverName;

    /** 海运车辆ID */
    @Excel(name = "海运车辆ID")
    private Long seacarId;

    /** 海运车牌 */
    @Excel(name = "海运车牌")
    private String seaCarNo;

    /** 海运司机电话 */
    @Excel(name = "海运司机电话")
    private String seaDriverTel;

    /** 海运司机姓名 */
    @Excel(name = "海运司机姓名")
    private String seaDriverName;

    /** 审核人编号 */
    @Excel(name = "审核人编号")
    private Long checkUserId;

    /** 审核状态（已审核、未审核） */
    @Excel(name = "审核状态", readConverterExp = "已=审核、未审核")
    private String checkState;

    /** 开票状态（未开票，部分开票，已开票） */
    @Excel(name = "开票状态", readConverterExp = "未=开票，部分开票，已开票")
    private String invoiceState;

    /** 附件路径 */
    @Excel(name = "附件路径")
    private String path;

    /** 打款状态(申请中，已打款，未打款) */
    @Excel(name = "打款状态(申请中，已打款，未打款)")
    private String PaymentState;

    /** 陆运银行户名 */
    @Excel(name = "陆运银行户名")
    private String landBankName;

    /** 陆运银行账号 */
    @Excel(name = "陆运银行账号")
    private String landBankNo;

    /** 海运银行户名 */
    @Excel(name = "海运银行户名")
    private String seaBankName;

    /** 海运银行账号 */
    @Excel(name = "海运银行账号")
    private String seaBankNo;

    /** 收到条附件路径 */
    @Excel(name = "收到条附件路径")
    private String receiveProof;

    /** 销售经理 */
    @Excel(name = "销售经理")
    private String saleManager;

    /** 车队 */
    @Excel(name = "车队")
    private String fleet;

    /** 是否被调整单（ 是  否） */
    @Excel(name = "是否被调整单", readConverterExp = "是=,否=")
    private String isAdjusted;

    /** 调整日期 */
    @Excel(name = "调整日期")
    private String adjustDate;

    /** 是否调整单（是  否） */
    @Excel(name = "是否调整单", readConverterExp = "是=,否=")
    private String isAdjust;

    /** 原订单编号 */
    @Excel(name = "原订单编号")
    private Long adjustOrderid;

    /** 是否可编辑 */
    @Excel(name = "是否可编辑")
    private Long isedit;

    /** 客户是否开票 */
    @Excel(name = "客户是否开票")
    private Long customerIsInvoice;

    /** 供应商是否开票 */
    @Excel(name = "供应商是否开票")
    private Long isSupplierInvoice;

    /** 作废标记 */
    @Excel(name = "作废标记")
    private Long cancelFlag;

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
    public void setOrdersNo(String ordersNo) 
    {
        this.ordersNo = ordersNo;
    }

    public String getOrdersNo() 
    {
        return ordersNo;
    }
    public void setOrderDate(String orderDate) 
    {
        this.orderDate = orderDate;
    }

    public String getOrderDate() 
    {
        return orderDate;
    }
    public void setCustomer(String customer) 
    {
        this.customer = customer;
    }

    public String getCustomer() 
    {
        return customer;
    }
    public void setCustomerId(Long customerId) 
    {
        this.customerId = customerId;
    }

    public Long getCustomerId() 
    {
        return customerId;
    }
    public void setLandcarId(Long landcarId) 
    {
        this.landcarId = landcarId;
    }

    public Long getLandcarId() 
    {
        return landcarId;
    }
    public void setLandCarNo(String landCarNo) 
    {
        this.landCarNo = landCarNo;
    }

    public String getLandCarNo() 
    {
        return landCarNo;
    }
    public void setLandDriverTel(String landDriverTel) 
    {
        this.landDriverTel = landDriverTel;
    }

    public String getLandDriverTel() 
    {
        return landDriverTel;
    }
    public void setLandDriverName(String landDriverName) 
    {
        this.landDriverName = landDriverName;
    }

    public String getLandDriverName() 
    {
        return landDriverName;
    }
    public void setSeacarId(Long seacarId) 
    {
        this.seacarId = seacarId;
    }

    public Long getSeacarId() 
    {
        return seacarId;
    }
    public void setSeaCarNo(String seaCarNo) 
    {
        this.seaCarNo = seaCarNo;
    }

    public String getSeaCarNo() 
    {
        return seaCarNo;
    }
    public void setSeaDriverTel(String seaDriverTel) 
    {
        this.seaDriverTel = seaDriverTel;
    }

    public String getSeaDriverTel() 
    {
        return seaDriverTel;
    }
    public void setSeaDriverName(String seaDriverName) 
    {
        this.seaDriverName = seaDriverName;
    }

    public String getSeaDriverName() 
    {
        return seaDriverName;
    }
    public void setCheckUserId(Long checkUserId) 
    {
        this.checkUserId = checkUserId;
    }

    public Long getCheckUserId() 
    {
        return checkUserId;
    }
    public void setCheckState(String checkState) 
    {
        this.checkState = checkState;
    }

    public String getCheckState() 
    {
        return checkState;
    }
    public void setInvoiceState(String invoiceState) 
    {
        this.invoiceState = invoiceState;
    }

    public String getInvoiceState() 
    {
        return invoiceState;
    }
    public void setPath(String path) 
    {
        this.path = path;
    }

    public String getPath() 
    {
        return path;
    }
    public void setPaymentState(String PaymentState) 
    {
        this.PaymentState = PaymentState;
    }

    public String getPaymentState() 
    {
        return PaymentState;
    }
    public void setLandBankName(String landBankName) 
    {
        this.landBankName = landBankName;
    }

    public String getLandBankName() 
    {
        return landBankName;
    }
    public void setLandBankNo(String landBankNo) 
    {
        this.landBankNo = landBankNo;
    }

    public String getLandBankNo() 
    {
        return landBankNo;
    }
    public void setSeaBankName(String seaBankName) 
    {
        this.seaBankName = seaBankName;
    }

    public String getSeaBankName() 
    {
        return seaBankName;
    }
    public void setSeaBankNo(String seaBankNo) 
    {
        this.seaBankNo = seaBankNo;
    }

    public String getSeaBankNo() 
    {
        return seaBankNo;
    }
    public void setReceiveProof(String receiveProof) 
    {
        this.receiveProof = receiveProof;
    }

    public String getReceiveProof() 
    {
        return receiveProof;
    }
    public void setSaleManager(String saleManager) 
    {
        this.saleManager = saleManager;
    }

    public String getSaleManager() 
    {
        return saleManager;
    }
    public void setFleet(String fleet) 
    {
        this.fleet = fleet;
    }

    public String getFleet() 
    {
        return fleet;
    }
    public void setIsAdjusted(String isAdjusted) 
    {
        this.isAdjusted = isAdjusted;
    }

    public String getIsAdjusted() 
    {
        return isAdjusted;
    }
    public void setAdjustDate(String adjustDate) 
    {
        this.adjustDate = adjustDate;
    }

    public String getAdjustDate() 
    {
        return adjustDate;
    }
    public void setIsAdjust(String isAdjust) 
    {
        this.isAdjust = isAdjust;
    }

    public String getIsAdjust() 
    {
        return isAdjust;
    }
    public void setAdjustOrderid(Long adjustOrderid) 
    {
        this.adjustOrderid = adjustOrderid;
    }

    public Long getAdjustOrderid() 
    {
        return adjustOrderid;
    }
    public void setIsedit(Long isedit) 
    {
        this.isedit = isedit;
    }

    public Long getIsedit() 
    {
        return isedit;
    }
    public void setCustomerIsInvoice(Long customerIsInvoice) 
    {
        this.customerIsInvoice = customerIsInvoice;
    }

    public Long getCustomerIsInvoice() 
    {
        return customerIsInvoice;
    }
    public void setIsSupplierInvoice(Long isSupplierInvoice) 
    {
        this.isSupplierInvoice = isSupplierInvoice;
    }

    public Long getIsSupplierInvoice() 
    {
        return isSupplierInvoice;
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

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("ordersNo", getOrdersNo())
            .append("orderDate", getOrderDate())
            .append("customer", getCustomer())
            .append("customerId", getCustomerId())
            .append("landcarId", getLandcarId())
            .append("landCarNo", getLandCarNo())
            .append("landDriverTel", getLandDriverTel())
            .append("landDriverName", getLandDriverName())
            .append("seacarId", getSeacarId())
            .append("seaCarNo", getSeaCarNo())
            .append("seaDriverTel", getSeaDriverTel())
            .append("seaDriverName", getSeaDriverName())
            .append("checkUserId", getCheckUserId())
            .append("checkState", getCheckState())
            .append("invoiceState", getInvoiceState())
            .append("path", getPath())
            .append("PaymentState", getPaymentState())
            .append("landBankName", getLandBankName())
            .append("landBankNo", getLandBankNo())
            .append("seaBankName", getSeaBankName())
            .append("seaBankNo", getSeaBankNo())
            .append("receiveProof", getReceiveProof())
            .append("saleManager", getSaleManager())
            .append("fleet", getFleet())
            .append("isAdjusted", getIsAdjusted())
            .append("adjustDate", getAdjustDate())
            .append("isAdjust", getIsAdjust())
            .append("adjustOrderid", getAdjustOrderid())
            .append("isedit", getIsedit())
            .append("customerIsInvoice", getCustomerIsInvoice())
            .append("isSupplierInvoice", getIsSupplierInvoice())
            .append("cancelFlag", getCancelFlag())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
