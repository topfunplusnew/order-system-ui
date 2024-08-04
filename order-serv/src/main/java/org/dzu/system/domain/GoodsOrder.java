package org.dzu.system.domain;

import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.Valid;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Pattern;

/**
 * 订单对象 goodsOrder
 * 
 * @author ml
 * @date 2024-08-02
 */
@TableName("goodsOrder")
public class GoodsOrder extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号")
    @TableField(value = "ordersNo")
    @Length(max = 50)
    private String ordersNo;

    /** 日期 */
    @Excel(name = "日期")
    @TableField(value = "orderDate")
    @Length(max = 50)
    // 已知前端在此处传入时间戳，必定是数字组成
    @Pattern(regexp = "^[0-9]*$",message = "orderDate必须是时间戳形式的")
    private String orderDate;


    // 需要添加两个字段，用来前端传入两个界限时间，用来查询订单
    // 一个是开始时间，一个是结束时间，同时这个两个字段应该被excel工具和mybatisPlus忽略
    @Pattern(regexp = "^[0-9]*$",message = "orderDateStart必须是时间戳形式的")
    @TableField(exist = false)
    private String orderDateStart;
    @Pattern(regexp = "^[0-9]*$",message = "orderDateEnd必须是时间戳形式的")
    @TableField(exist = false)
    private String orderDateEnd;

    public String getOrderDateStart() {
        return orderDateStart;
    }

    public void setOrderDateStart(@Pattern(regexp = "^[0-9]*$", message = "orderDateStart必须是时间戳形式的") String orderDateStart) {
        this.orderDateStart = orderDateStart;
    }

    public  String getOrderDateEnd() {
        return orderDateEnd;
    }

    public void setOrderDateEnd(@Pattern(regexp = "^[0-9]*$", message = "orderDateEnd必须是时间戳形式的") String orderDateEnd) {
        this.orderDateEnd = orderDateEnd;
    }

    /** 客户 */
    @Excel(name = "客户")
    @TableField(value = "customer")
    @Length(max = 150)
    private String customer;

    /** 客户ID */
    @Excel(name = "客户ID")
    @TableField(value = "customerID")
    @Max(99999999999L)
    private Long customerID;

    /** 陆运车辆ID */
    @Excel(name = "陆运车辆ID")
    @TableField(value = "landCarID")
    @Max(99999999999L)
    private Long landCarID;

    /** 陆运车牌 */
    @Excel(name = "陆运车牌")
    @TableField(value = "landCarNo")
    @Length(max = 50)
    private String landCarNo;

    /** 陆运司机电话 */
    @Excel(name = "陆运司机电话")
    @TableField(value = "landDriverTel")
    @Length(max = 50)
    private String landDriverTel;

    /** 陆地司机姓名 */
    @Excel(name = "陆地司机姓名")
    @TableField(value = "landDriverName")
    @Length(max = 55)
    private String landDriverName;

    /** 海运车辆ID */
    @Excel(name = "海运车辆ID")
    @TableField(value = "seaCarID")
    @Max(99999999999L)
    private Long seaCarID;

    /** 海运车牌 */
    @Excel(name = "海运车牌")
    @TableField(value = "seaCarNo")
    @Length(max = 50)
    private String seaCarNo;

    /** 海运司机电话 */
    @Excel(name = "海运司机电话")
    @TableField(value = "seaDriverTel")
    @Length(max = 50)
    private String seaDriverTel;

    /** 海运司机姓名 */
    @Excel(name = "海运司机姓名")
    @TableField(value = "seaDriverName")
    @Length(max = 55)
    private String seaDriverName;

    /** 审核人编号 */
    @Excel(name = "审核人编号")
    @TableField(value = "checkUserId")
    @Max(99999999999L)
    private Long checkUserId;

    /** 审核状态（已审核、未审核） */
    @Excel(name = "审核状态", readConverterExp = "已=审核、未审核")
    @TableField(value = "checkState")
    @Pattern(regexp = "已审核|未审核")
    private String checkState;

    /** 开票状态（未开票，部分开票，已开票） */
    @Excel(name = "开票状态", readConverterExp = "未=开票，部分开票，已开票")
    @TableField(value = "invoiceState")
    @Pattern(regexp = "未开票|部分开票|已开票")
    private String invoiceState;

    /** 附件路径 */
    @Excel(name = "附件路径")
    @TableField(value = "path")
    @Length(max = 250)
    private String path;

    /** 打款状态(申请中，已打款，未打款) */
    @Excel(name = "打款状态(申请中，已打款，未打款)")
    @TableField(value = "PaymentState")
    @Pattern(regexp = "申请中|已打款|未打款")
    private String PaymentState;

    /** 陆运银行户名 */
    @Excel(name = "陆运银行户名")
    @TableField(value = "landBankName")
    @Length(max = 50)
    private String landBankName;

    /** 陆运银行账号 */
    @Excel(name = "陆运银行账号")
    @TableField(value = "landBankNo")
    @Length(max = 50)
    private String landBankNo;

    /** 海运银行户名 */
    @Excel(name = "海运银行户名")
    @TableField(value = "seaBankName")
    @Length(max = 50)
    private String seaBankName;

    /** 海运银行账号 */
    @Excel(name = "海运银行账号")
    @TableField(value = "seaBankNo")
    @Length(max = 50)
    private String seaBankNo;

    /** 收到条附件路径 */
    @Excel(name = "收到条附件路径")
    @TableField(value = "receiveProof")
    private String receiveProof; // Text type, no specific length validation

    /** 销售经理 */
    @Excel(name = "销售经理")
    @TableField(value = "saleManager")
    @Length(max = 25)
    private String saleManager;

    /** 车队 */
    @Excel(name = "车队")
    @TableField(value = "fleet")
    @Length(max = 50)
    private String fleet;

    /** 是否被调整单（ 是  否） */
    @Excel(name = "是否被调整单", readConverterExp = "是=,否=")
    @TableField(value = "isAdjusted")
    @Pattern(regexp = "是|否")
    private String isAdjusted;

    /** 调整日期 */
    @Excel(name = "调整日期")
    @TableField(value = "adjustDate")
    @Length(max = 50)
    private String adjustDate;

    /** 是否调整单（是  否） */
    @Excel(name = "是否调整单", readConverterExp = "是=,否=")
    @TableField(value = "isAdjust")
    @Pattern(regexp = "是|否")
    private String isAdjust;

    /** 原订单编号 */
    @Excel(name = "原订单编号")
    @TableField(value = "adjustOrderid")
    @Max(99999999999L)
    private Long adjustOrderid;

    /** 是否可编辑 */
    @Excel(name = "是否可编辑")
    @TableField(value = "isedit")
    @Min(0)
    @Max(1)
    private Long isedit;

    /** 客户是否开票 */
    @Excel(name = "客户是否开票")
    @TableField(value = "customerIsInvoice")
    @Min(0)
    @Max(1)
    private Long customerIsInvoice;

    /** 供应商是否开票 */
    @Excel(name = "供应商是否开票")
    @TableField(value = "isSupplierInvoice")
    @Min(0)
    @Max(1)
    private Long isSupplierInvoice;

    /** 作废标记 */
    @FlagOnlyZeroOrOne
    @TableField(value = "cancelFlag")
    private Long cancelFlag;

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

    /** 订单详情信息 */
    @Valid
    @TableField(exist = false)
    private List<@Valid OrderDetail> orderDetailList;

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
    public void setCustomerID(Long customerID) 
    {
        this.customerID = customerID;
    }

    public Long getCustomerID() 
    {
        return customerID;
    }
    public void setLandCarID(Long landCarID) 
    {
        this.landCarID = landCarID;
    }

    public Long getLandCarID() 
    {
        return landCarID;
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
    public void setSeaCarID(Long seaCarID) 
    {
        this.seaCarID = seaCarID;
    }

    public Long getSeaCarID() 
    {
        return seaCarID;
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

    public List<OrderDetail> getOrderDetailList()
    {
        return orderDetailList;
    }

    public void setOrderDetailList(List<OrderDetail> orderDetailList)
    {
        this.orderDetailList = orderDetailList;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("ordersNo", getOrdersNo())
            .append("orderDate", getOrderDate())
            .append("customer", getCustomer())
            .append("customerID", getCustomerID())
            .append("landCarID", getLandCarID())
            .append("landCarNo", getLandCarNo())
            .append("landDriverTel", getLandDriverTel())
            .append("landDriverName", getLandDriverName())
            .append("seaCarID", getSeaCarID())
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
            .append("orderDetailList", getOrderDetailList())
            .toString();
    }
}
