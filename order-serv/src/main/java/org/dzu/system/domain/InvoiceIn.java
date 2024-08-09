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

import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 发票购入信息对象 invoiceIn
 *
 * @author ml
 * @date 2024-08-01
 */
@TableName("invoiceIn")
public class InvoiceIn extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * id
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 开票日期
     */
    @Excel(name = "开票日期", dateFormat = "yyyy-MM-dd")
    @TableField(value = "invoiceDate")
    // 前端传入时间戳必须是纯数字的
    @Pattern(regexp = "^[0-9]*$", message = "开票日期必须是时间戳")
    @Length(max = 55, message = "开票日期的字符长度不允许超过55")
    private String invoiceDate;

    // 前端传入时间的开始和结束

    @TableField(exist = false)
    @Pattern(regexp = "^[0-9]*$", message = "开始时间必须是时间戳")
    private String beginTime;

    @TableField(exist = false)
    @Pattern(regexp = "^[0-9]*$", message = "结束时间必须是时间戳")
    private String endTime;

    /**
     * 我方开票实体
     */
    @Excel(name = "我方开票实体")
    @Length(max = 55, message = "我方开票实体不能超过55个字符")
    @TableField(value = "invoiceObject")
    private String invoiceObject;

    /**
     * 开票金额
     */
    @DecimalMaxDigits
    @TableField(value = "invoiceAmount")
    @NotNull(message = "开票金额不能为空")
    private Double invoiceAmount;

    /**
     * 对方公司类别（客户、供应商,其他）
     */
    @Excel(name = "对方公司类别")
    @NotNull(message = "对方公司类别不能为空")
    @Pattern(regexp = "客户|供应商|其他", message = "对方公司类别必须是：客户、供应商或其他")
    @TableField(value = "companyType")
    private String companyType;

    /**
     * 对方公司名称
     */
    @Excel(name = "对方公司名称")
    @NotNull(message = "对方公司名称不能为空")
    @Length(max = 120, message = "对方公司名称不能超过120个字符")
    @TableField(value = "companyName")
    private String companyName;

    /**
     * 对方公司ID
     */
    @Excel(name = "对方公司ID")
    @NotNull(message = "对方公司ID不能为空")
    @TableField(value = "companyID")
    private Long companyID;

    /**
     * 票据单位名称
     */
    @Excel(name = "票据单位名称")
    @NotNull(message = "票据单位名称不能为空")
    @Length(max = 120, message = "票据单位名称不能超过120个字符")
    @TableField(value = "invoiceCompanyName")
    private String invoiceCompanyName;

    /**
     * 票点
     */
    @DecimalMaxDigits
    @TableField(value = "ticketPoint")
    @NotNull(message = "票点不能为空")
    private Double ticketPoint;

    /**
     * 票点金额（开票金额*票点）
     */
    @Excel(name = "票点金额", readConverterExp = "票点金额=开票金额*票点")
    @NotNull(message = "票点金额不能为空")
    @DecimalMin(value = "0.0", message = "票点金额不能小于0")
    @DecimalMaxDigits
    @TableField(value = "ticketPointAmount")
    private Double ticketPointAmount;

    /**
     * 是否订单对应票点
     */
    @Excel(name = "是否订单对应票点")
    @NotNull(message = "是否订单对应票点不能为空")
    @TableField(value = "isOrderTax")
    @Min(value = 0, message = "不对订单则为0,否则为对应主键id")
    private Long isOrderTax;

    /**
     * 备注
     */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
    @TableField(value = "comments")
    private String comments;

    /**
     * 添加时间
     */
    @Excel(name = "添加时间", dateFormat = "yyyy-MM-dd")
    @TableField(value = "addtime")
    private String addtime;

    /**
     * 操作人员ID
     */
    @Excel(name = "操作人员ID")
    @TableField(value = "userId")
    private Long userId;

    /**
     * 操作人员姓名
     */
    @Excel(name = "操作人员姓名")
    @TableField(value = "UserName")
    private String UserName;

    /**
     * 删除标记
     */
    @FlagOnlyZeroOrOne
    @TableField(value = "delFlag")
    private Long delFlag;


    /**
     * 额外字段，数据库联动查询获得
     */
    @Excel(name = "审核状态")
    private String checkState;

    public Double getOweAmount() {
        return oweAmount;
    }

    public void setOweAmount(Double oweAmount) {
        this.oweAmount = oweAmount;
    }

    // 欠票金额
    @TableField(exist = false)
    private Double oweAmount;

    public String getCheckState() {
        return checkState;
    }

    public void setCheckState(String checkState) {
        this.checkState = checkState;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setInvoiceDate(String invoiceDate) {
        this.invoiceDate = invoiceDate;
    }

    public String getInvoiceDate() {
        return invoiceDate;
    }

    public void setInvoiceObject(String invoiceObject) {
        this.invoiceObject = invoiceObject;
    }

    public String getInvoiceObject() {
        return invoiceObject;
    }

    public void setInvoiceAmount(Double invoiceAmount) {
        this.invoiceAmount = invoiceAmount;
    }

    public Double getInvoiceAmount() {
        return invoiceAmount;
    }

    public void setCompanyType(String companyType) {
        this.companyType = companyType;
    }

    public String getCompanyType() {
        return companyType;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyID(Long companyID) {
        this.companyID = companyID;
    }

    public Long getCompanyID() {
        return companyID;
    }

    public void setInvoiceCompanyName(String invoiceCompanyName) {
        this.invoiceCompanyName = invoiceCompanyName;
    }

    public String getInvoiceCompanyName() {
        return invoiceCompanyName;
    }

    public void setTicketPoint(Double ticketPoint) {
        this.ticketPoint = ticketPoint;
    }

    public Double getTicketPoint() {
        return ticketPoint;
    }

    public void setTicketPointAmount(Double ticketPointAmount) {
        this.ticketPointAmount = ticketPointAmount;
    }

    public Double getTicketPointAmount() {
        return ticketPointAmount;
    }

    public void setIsOrderTax(Long isOrderTax) {
        this.isOrderTax = isOrderTax;
    }

    public Long getIsOrderTax() {
        return isOrderTax;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public String getComments() {
        return comments;
    }

    public void setAddtime(String addtime) {
        this.addtime = addtime;
    }

    public String getAddtime() {
        return addtime;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserName(String UserName) {
        this.UserName = UserName;
    }

    public String getUserName() {
        return UserName;
    }

    public void setDelFlag(Long delFlag) {
        this.delFlag = delFlag;
    }

    public Long getDelFlag() {
        return delFlag;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getBeginTime() {
        return beginTime;
    }

    public void setBeginTime(String beginTime) {
        this.beginTime = beginTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("invoiceDate", getInvoiceDate())
                .append("invoiceObject", getInvoiceObject())
                .append("invoiceAmount", getInvoiceAmount())
                .append("companyType", getCompanyType())
                .append("companyName", getCompanyName())
                .append("companyID", getCompanyID())
                .append("invoiceCompanyName", getInvoiceCompanyName())
                .append("ticketPoint", getTicketPoint())
                .append("ticketPointAmount", getTicketPointAmount())
                .append("isOrderTax", getIsOrderTax())
                .append("comments", getComments())
                .append("addtime", getAddtime())
                .append("userId", getUserId())
                .append("UserName", getUserName())
                .append("updateTime", getUpdateTime())
                .append("delFlag", getDelFlag())
                .toString();
    }
}
