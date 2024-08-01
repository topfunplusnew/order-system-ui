package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.OnlyZeroOrOne;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.util.Date;

/**
 * 向外部借出款信息对象 lendMoney
 */
@TableName("lendMoney")
public class LendMoney extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * id
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 借出款编号（UUID）
     */
    @Excel(name = "借出款编号", readConverterExp = "U=UID")
    @Length(max = 50, message = "借出款编号的字符长度不允许超过50")
    @TableField("futuresNO")
    private String futuresNO;

    /**
     * 期货保证金公司
     */
    @Excel(name = "期货保证金公司")
    @Length(max = 80, message = "期货保证金公司的字符长度不允许超过80")
    @TableField("futuresMarginCompany")
    private String futuresMarginCompany;

    /**
     * 对象类型(员工、客户、供应商、其他)
     */
    @Excel(name = "对象类型(员工、客户、供应商、其他)")
    @Length(max = 50, message = "对象类型的字符长度不允许超过50")
    @Pattern(regexp = "^(员工|客户|供应商|其他)$", message = "对象类型的值只能是员工、客户、供应商、其他")
    @TableField("targetType")
    private String targetType;

    /**
     * 对象(员工姓名、公司名称)
     */
    @Excel(name = "对象(员工姓名、公司名称)")
    @Length(max = 50, message = "对象的字符长度不允许超过50")
    @TableField("target")
    private String target;

    /**
     * 保证金金额
     */
    @DecimalMaxDigits
    @TableField("moneyAmount")
    private Double moneyAmount;

    /**
     * 对方账户
     */
    @Excel(name = "对方账户")
    @Length(max = 80, message = "对方账户的字符长度不允许超过80")
    @TableField("targetAcountsName")
    private String targetAcountsName;

    /**
     * 对方账号
     */
    @Excel(name = "对方账号")
    @Length(max = 80, message = "对方账号的字符长度不允许超过80")
    @TableField("targetBankNo")
    private String targetBankNo;

    /**
     * 对方开户行
     */
    @Excel(name = "对方开户行")
    @Length(max = 80, message = "对方开户行的字符长度不允许超过80")
    @TableField("targetBankName")
    private String targetBankName;

    /**
     * 我方支付账户
     */
    @Excel(name = "我方支付账户")
    @Length(max = 80, message = "我方支付账户的字符长度不允许超过80")
    @TableField("selfAcountsName")
    private String selfAcountsName;

    /**
     * 我方账号
     */
    @Excel(name = "我方账号")
    @Length(max = 80, message = "我方账号的字符长度不允许超过80")
    @TableField("selfBankNo")
    private String selfBankNo;

    /**
     * 我方开户行
     */
    @Excel(name = "我方开户行")
    @Length(max = 80, message = "我方开户行的字符长度不允许超过80")
    @TableField("selfBankName")
    private String selfBankName;

    /**
     * 支付期货保证金时间
     */
    @Excel(name = "支付期货保证金时间")
    @NotNull(message = "支付期货保证金时间不能为空")
    @Length(max = 50, message = "支付期货保证金时间的字符长度不允许超过50")
    @TableField("futuresDate")
    private String futuresDate;

    /**
     * 事由
     */
    @Excel(name = "事由")
    @Length(max = 200, message = "事由的字符长度不允许超过200")
    @TableField("reason")
    private String reason;

    /**
     * 备注
     */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
    @TableField("comments")
    private String comments;

    /**
     * 添加时间
     */
    @Excel(name = "添加时间")
    @TableField("addtime")
    private String addtime;

    /**
     * 操作人员ID
     */
    @Excel(name = "操作人员ID")
    @TableField("userId")
    private Long userId;

    /**
     * 操作人员姓名
     */
    @Excel(name = "操作人员姓名")
    @TableField("UserName")
    private String UserName;

    /**
     * 更新时间
     */
    @TableField("update_time")
    private Date updateTime;

    /**
     * 删除标记
     */
    @OnlyZeroOrOne
    @TableField("delFlag")
    private Long delFlag;

    // Getters and Setters

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setFuturesNO(String futuresNO) {
        this.futuresNO = futuresNO;
    }

    public String getFuturesNO() {
        return futuresNO;
    }

    public void setFuturesMarginCompany(String futuresMarginCompany) {
        this.futuresMarginCompany = futuresMarginCompany;
    }

    public String getFuturesMarginCompany() {
        return futuresMarginCompany;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    public String getTarget() {
        return target;
    }

    public void setMoneyAmount(Double moneyAmount) {
        this.moneyAmount = moneyAmount;
    }

    public Double getMoneyAmount() {
        return moneyAmount;
    }

    public void setTargetAcountsName(String targetAcountsName) {
        this.targetAcountsName = targetAcountsName;
    }

    public String getTargetAcountsName() {
        return targetAcountsName;
    }

    public void setTargetBankNo(String targetBankNo) {
        this.targetBankNo = targetBankNo;
    }

    public String getTargetBankNo() {
        return targetBankNo;
    }

    public void setTargetBankName(String targetBankName) {
        this.targetBankName = targetBankName;
    }

    public String getTargetBankName() {
        return targetBankName;
    }

    public void setSelfAcountsName(String selfAcountsName) {
        this.selfAcountsName = selfAcountsName;
    }

    public String getSelfAcountsName() {
        return selfAcountsName;
    }

    public void setSelfBankNo(String selfBankNo) {
        this.selfBankNo = selfBankNo;
    }

    public String getSelfBankNo() {
        return selfBankNo;
    }

    public void setSelfBankName(String selfBankName) {
        this.selfBankName = selfBankName;
    }

    public String getSelfBankName() {
        return selfBankName;
    }

    public void setFuturesDate(String futuresDate) {
        this.futuresDate = futuresDate;
    }

    public String getFuturesDate() {
        return futuresDate;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getReason() {
        return reason;
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

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setDelFlag(Long delFlag) {
        this.delFlag = delFlag;
    }

    public Long getDelFlag() {
        return delFlag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("futuresNO", getFuturesNO())
                .append("futuresMarginCompany", getFuturesMarginCompany())
                .append("targetType", getTargetType())
                .append("target", getTarget())
                .append("moneyAmount", getMoneyAmount())
                .append("targetAcountsName", getTargetAcountsName())
                .append("targetBankNo", getTargetBankNo())
                .append("targetBankName", getTargetBankName())
                .append("selfAcountsName", getSelfAcountsName())
                .append("selfBankNo", getSelfBankNo())
                .append("selfBankName", getSelfBankName())
                .append("futuresDate", getFuturesDate())
                .append("reason", getReason())
                .append("comments", getComments())
                .append("addtime", getAddtime())
                .append("userId", getUserId())
                .append("UserName", getUserName())
                .append("updateTime", getUpdateTime())
                .append("delFlag", getDelFlag())
                .toString();
    }
}