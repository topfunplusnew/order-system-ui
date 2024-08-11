package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.IdType;
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

/**
 * 贷款还款信息对象 repayment
 * 
 * @author ml
 * @date 2024-07-29
 */
@TableName("repayment")
public class Repayment extends BaseEntity  {
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /** 贷款编号（UUID） */
    @Excel(name = "贷款编号")
    @NotNull(message = "缺少关键字段")
    @Length(max = 50, message = "贷款编号的字符长度不允许超过50")
    @TableField("loanNO")
    private String loanNO;

    /** 还款编号（UUID） */
    @Excel(name = "还款编号")
    @Length(max = 50, message = "还款编号的字符长度不允许超过50")
    @TableField("payNO")
    private String payNO;

    /** 还（本）金额 */
    @Excel(name = "还(本)金额")
    @NotNull(message = "还(本)金额不能为空")
    @DecimalMaxDigits
    @TableField("moneyAmount")
    private Double moneyAmount;

    /** 付息（金额） */
    @Excel(name = "付息(金额)")
    @NotNull(message = "付息(金额)不能为空")
    @DecimalMaxDigits
    @TableField("ratio")
    private Double ratio;

    /** 还款日期 */
    @Excel(name = "还款日期")
    @NotNull(message = "还款日期不能为空")
    @Length(max = 50, message = "还款日期的字符长度不允许超过50")
    @TableField("payDate")
    private String payDate;

    /** 还款账户 */
    @Excel(name = "还款账户")
    @Length(max = 80, message = "还款账户的字符长度不允许超过80")
    @TableField("acountsName")
    private String acountsName;

    /** 还款账号 */
    @Excel(name = "还款账号")
    @NotNull(message = "还款账号不能为空")
    @Length(max = 80, message = "还款账号的字符长度不允许超过80")
    @TableField("bankNo")
    private String bankNo;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
    @TableField("comments")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间")
    @TableField("addtime")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    @TableField("userId")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    @TableField("UserName")
    private String UserName;

    /** 删除标记 */
    @FlagOnlyZeroOrOne
    @TableField("delFlag")
    private Long delFlag;


    /** 额外字段，通过联查获取 */
    @Excel(name = "支付状态")
    @TableField(exist = false)
    private String checkState;

    /** 额外字段,开始时间*/
    @TableField(exist = false)
    private String startTime;

    /** 额外字段,结束时间*/
    private String endTime;

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getCheckState() {
        return checkState;
    }

    public void setCheckState(String checkState) {
        this.checkState = checkState;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setLoanNO(String loanNO) 
    {
        this.loanNO = loanNO;
    }

    public String getLoanNO() 
    {
        return loanNO;
    }
    public void setPayNO(String payNO) 
    {
        this.payNO = payNO;
    }

    public String getPayNO() 
    {
        return payNO;
    }
    public void setMoneyAmount(Double moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Double getMoneyAmount() 
    {
        return moneyAmount;
    }
    public void setRatio(Double ratio) 
    {
        this.ratio = ratio;
    }

    public Double getRatio() 
    {
        return ratio;
    }
    public void setPayDate(String payDate) 
    {
        this.payDate = payDate;
    }

    public String getPayDate() 
    {
        return payDate;
    }
    public void setAcountsName(String acountsName) 
    {
        this.acountsName = acountsName;
    }

    public String getAcountsName() 
    {
        return acountsName;
    }
    public void setBankNo(String bankNo) 
    {
        this.bankNo = bankNo;
    }

    public String getBankNo() 
    {
        return bankNo;
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
            .append("loanNO", getLoanNO())
            .append("payNO", getPayNO())
            .append("moneyAmount", getMoneyAmount())
            .append("ratio", getRatio())
            .append("payDate", getPayDate())
            .append("acountsName", getAcountsName())
            .append("bankNo", getBankNo())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
