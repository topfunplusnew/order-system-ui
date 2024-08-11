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

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/**
 * 收款信息对象 receiveMoney
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("receiveMoney")
public class ReceiveMoney extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 收款编号（UUID） */
    @Excel(name = "收款编号")
    @TableField(value = "receiveNO")
    @Length(max = 50, message = "收款编号的字符长度不允许超过50")
    private String receiveNO;

    /** 日期 */
    @Excel(name = "日期")
    @TableField(value = "fundsDate")
    @NotNull(message = "日期不能为空")
    @Length(max = 50, message = "日期的字符长度不允许超过50")
    private String fundsDate;

    /** 支付类型 */
    @Excel(name = "支付类型")
    @NotNull(message = "支付类型不能为空")
    @TableField(value = "receiveType")
    @Length(max = 55, message = "支付类型的字符长度不允许超过55")
    private String receiveType;

    /** 对应的表名 */
    @Excel(name = "对应的表名")
    @TableField(value = "tableName")
    @Length(max = 55, message = "对应的表名的字符长度不允许超过55")
    private String tableName;

    /** 对应的表主键 */
    @Excel(name = "对应的表主键")
    @TableField(value = "tID")
    @Length(max = 55, message = "对应的表主键的字符长度不允许超过55")
    private String tID;

    /** 金额 */
    @DecimalMaxDigits
    @TableField(value = "moneyAmount")
    private Double moneyAmount;

    /** 己方户名 */
    @Excel(name = "己方户名")
    @TableField(value = "selfAcountsName")
    @Length(max = 80, message = "己方户名的字符长度不允许超过80")
    private String selfAcountsName;

    /** 己方账号 */
    @Excel(name = "己方账号")
    @TableField(value = "selfBankNo")
    @Length(max = 80, message = "己方账号的字符长度不允许超过80")
    private String selfBankNo;

    /** 己方开户行 */
    @Excel(name = "己方开户行")
    @TableField(value = "selfBankName")
    @Length(max = 150, message = "己方开户行的字符长度不允许超过150")
    private String selfBankName;

    /** 己方账号ID */
    @Excel(name = "己方账号ID")
    @TableField(value = "selfBankID")
    @Length(max = 150, message = "己方账号ID的字符长度不允许超过150")
    private String selfBankID;

    /** 对方户名 */
    @Excel(name = "对方户名")
    @TableField(value = "otherAcountsName")
    @Length(max = 80, message = "对方户名的字符长度不允许超过80")
    private String otherAcountsName;

    /** 对方账号 */
    @Excel(name = "对方账号")
    @TableField(value = "otherBankNo")
    @Length(max = 80, message = "对方账号的字符长度不允许超过80")
    private String otherBankNo;

    /** 对方开户行 */
    @Excel(name = "对方开户行")
    @TableField(value = "otherBankName")
    @Length(max = 150, message = "对方开户行的字符长度不允许超过150")
    private String otherBankName;

    /** 对方公司 */
    @Excel(name = "对方公司")
    @TableField(value = "companyName")
    @Length(max = 150, message = "对方公司的字符长度不允许超过150")
    private String companyName;

    /** 对方公司ID */
    @Excel(name = "对方公司ID")
    @TableField(value = "companyId")
    private Long companyId;

    /** 对方公司类型（1、客户 2、供应商） */
    @Excel(name = "对方公司类型", readConverterExp = "1=客户,2=供应商")
    @TableField(value = "companyType")
    @Min(value = 1, message = "公司类型必须为1（客户）或2（供应商）")
    @Max(value = 2, message = "公司类型必须为1（客户）或2（供应商）")
    private Long companyType;

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
    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setReceiveNO(String receiveNO) 
    {
        this.receiveNO = receiveNO;
    }

    public String getReceiveNO() 
    {
        return receiveNO;
    }
    public void setFundsDate(String fundsDate) 
    {
        this.fundsDate = fundsDate;
    }

    public String getFundsDate() 
    {
        return fundsDate;
    }
    public void setReceiveType(String receiveType) 
    {
        this.receiveType = receiveType;
    }

    public String getReceiveType() 
    {
        return receiveType;
    }
    public void setTableName(String tableName) 
    {
        this.tableName = tableName;
    }

    public String getTableName() 
    {
        return tableName;
    }
    public void settID(String tID) 
    {
        this.tID = tID;
    }

    public String gettID() 
    {
        return tID;
    }
    public void setMoneyAmount(Double moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Double getMoneyAmount() 
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
    public void setSelfBankID(String selfBankID) 
    {
        this.selfBankID = selfBankID;
    }

    public String getSelfBankID()
    {
        return selfBankID;
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
    public void setCompanyName(String companyName) 
    {
        this.companyName = companyName;
    }

    public String getCompanyName() 
    {
        return companyName;
    }
    public void setCompanyId(Long companyId) 
    {
        this.companyId = companyId;
    }

    public Long getCompanyId() 
    {
        return companyId;
    }
    public void setCompanyType(Long companyType) 
    {
        this.companyType = companyType;
    }

    public Long getCompanyType() 
    {
        return companyType;
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
            .append("receiveNO", getReceiveNO())
            .append("fundsDate", getFundsDate())
            .append("receiveType", getReceiveType())
            .append("tableName", getTableName())
            .append("tID", gettID())
            .append("moneyAmount", getMoneyAmount())
            .append("selfAcountsName", getSelfAcountsName())
            .append("selfBankNo", getSelfBankNo())
            .append("selfBankName", getSelfBankName())
            .append("selfBankID", getSelfBankID())
            .append("otherAcountsName", getOtherAcountsName())
            .append("otherBankNo", getOtherBankNo())
            .append("otherBankName", getOtherBankName())
            .append("companyName", getCompanyName())
            .append("companyId", getCompanyId())
            .append("companyType", getCompanyType())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
