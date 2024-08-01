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
 * 付款信息对象 payment
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("payment")
public class Payment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 付款编号（UUID） */
    @Excel(name = "付款编号", readConverterExp = "U=UID")
    @TableField(value = "payNO")
    private String payNO;

    /** 日期 */
    @Excel(name = "日期")
    @TableField(value = "fundsDate")
    private String fundsDate;

    /** 支付类型 */
    @Excel(name = "支付类型")
    @TableField(value = "payType")
    private String payType;

    /** 对应的表名 */
    @Excel(name = "对应的表名")
    @TableField(value = "tableName")
    private String tableName;

    /** 对应的表主键 */
    @Excel(name = "对应的表主键")
    @TableField(value = "tID")
    private String tID;

    /** 金额 */
    @DecimalMaxDigits
    @TableField(value = "moneyAmount")
    private Double moneyAmount;

    /** 己方户名 */
    @Excel(name = "己方户名")
    @TableField(value = "selfAcountsName")
    private String selfAcountsName;

    /** 己方账号 */
    @Excel(name = "己方账号")
    @TableField(value = "selfBankNo")
    private String selfBankNo;

    /** 己方开户行 */
    @Excel(name = "己方开户行")
    @TableField(value = "selfBankName")
    private String selfBankName;

    /** 己方账号ID */
    @Excel(name = "己方账号ID")
    @TableField(value = "selfBankID")
    private String selfBankID;

    /** 对方户名 */
    @Excel(name = "对方户名")
    @TableField(value = "otherAcountsName")
    private String otherAcountsName;

    /** 对方账号 */
    @Excel(name = "对方账号")
    @TableField(value = "otherBankNo")
    private String otherBankNo;

    /** 对方开户行 */
    @Excel(name = "对方开户行")
    @TableField(value = "otherBankName")
    private String otherBankName;

    /** 支付状态（已支付、未支付、申请中） */
    @Excel(name = "支付状态", readConverterExp = "已=支付、未支付、申请中")
    @TableField(value = "paymentState")
    private String paymentState;

    /** 对方公司 */
    @Excel(name = "对方公司")
    @TableField(value = "companyName")
    private String companyName;

    /** 对方公司ID */
    @Excel(name = "对方公司ID")
    @TableField(value = "companyId")
    private Long companyId;

    /** 对方公司类型（1、客户 2、供应商） */
    @Excel(name = "对方公司类型", readConverterExp = "1=、客户,2=、供应商")
    @TableField(value = "companyType")
    private Long companyType;

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
    public void setPayNO(String payNO) 
    {
        this.payNO = payNO;
    }

    public String getPayNO() 
    {
        return payNO;
    }
    public void setFundsDate(String fundsDate) 
    {
        this.fundsDate = fundsDate;
    }

    public String getFundsDate() 
    {
        return fundsDate;
    }
    public void setPayType(String payType) 
    {
        this.payType = payType;
    }

    public String getPayType() 
    {
        return payType;
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
    public void setPaymentState(String paymentState) 
    {
        this.paymentState = paymentState;
    }

    public String getPaymentState() 
    {
        return paymentState;
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
            .append("payNO", getPayNO())
            .append("fundsDate", getFundsDate())
            .append("payType", getPayType())
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
            .append("paymentState", getPaymentState())
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
