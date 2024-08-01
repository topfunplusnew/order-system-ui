package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.dzu.common.annotation.OnlyZeroOrOne;
/**
 * 付款信息对象 paymentApply
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("paymentApply")
public class PaymentApply extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    @TableId(value = "id")
    private Long id;

    /** 对应的表名 */
    @Excel(name = "对应的表名")
    @TableField(value = "tableName")
    private String tableName;

    /** 对应的表主键 */
    @Excel(name = "对应的表主键")
    @TableField(value = "tID")
    private String tID;

    /** 日期 */
    @Excel(name = "日期")
    @TableField(value = "fundsDate")
    private String fundsDate;

    /** 支付类型 */
    @Excel(name = "支付类型")
    @TableField(value = "payType")
    private String payType;

    /** 金额 */
    @Excel(name = "金额")
    @TableField(value = "moneyAmount")
    private Long moneyAmount;

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

    /** 对方公司 */
    @Excel(name = "对方公司")
    @TableField(value = "companyName")
    private String companyName;

    /** 对方公司ID */
    @Excel(name = "对方公司ID")
    @TableField(value = "companyId")
    private Long companyId;

    /** 对方公司类型（客户、供应商、司机、个人、其他） */
    @Excel(name = "对方公司类型", readConverterExp = "客=户、供应商、司机、个人、其他")
    @TableField(value = "companyType")
    private String companyType;

    /** 付款原因 */
    @Excel(name = "付款原因")
    @TableField(value = "reason")
    private String reason;

    /** 附件 */
    @Excel(name = "附件")
    @TableField(value = "attachment")
    private String attachment;

    /** 申请人 */
    @Excel(name = "申请人")
    @TableField(value = "applyPerson")
    private String applyPerson;

    /** 申请人ID */
    @Excel(name = "申请人ID")
    @TableField(value = "applyPersonID")
    private Long applyPersonID;

    /** 审核状态（审核中、通过、未通过） */
    @Excel(name = "审核状态", readConverterExp = "审=核中、通过、未通过")
    @TableField(value = "checkState")
    private String checkState;

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

    /** 提交标记 */
    @Excel(name = "提交标记")
    @TableField(value = "submitflag")
    private Long submitflag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
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
    public void setMoneyAmount(Long moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Long getMoneyAmount() 
    {
        return moneyAmount;
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
    public void setCompanyType(String companyType) 
    {
        this.companyType = companyType;
    }

    public String getCompanyType() 
    {
        return companyType;
    }
    public void setReason(String reason) 
    {
        this.reason = reason;
    }

    public String getReason() 
    {
        return reason;
    }
    public void setAttachment(String attachment) 
    {
        this.attachment = attachment;
    }

    public String getAttachment() 
    {
        return attachment;
    }
    public void setApplyPerson(String applyPerson) 
    {
        this.applyPerson = applyPerson;
    }

    public String getApplyPerson() 
    {
        return applyPerson;
    }
    public void setApplyPersonID(Long applyPersonID) 
    {
        this.applyPersonID = applyPersonID;
    }

    public Long getApplyPersonID() 
    {
        return applyPersonID;
    }
    public void setCheckState(String checkState) 
    {
        this.checkState = checkState;
    }

    public String getCheckState() 
    {
        return checkState;
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
    public void setSubmitflag(Long submitflag) 
    {
        this.submitflag = submitflag;
    }

    public Long getSubmitflag() 
    {
        return submitflag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("tableName", getTableName())
            .append("tID", gettID())
            .append("fundsDate", getFundsDate())
            .append("payType", getPayType())
            .append("moneyAmount", getMoneyAmount())
            .append("otherAcountsName", getOtherAcountsName())
            .append("otherBankNo", getOtherBankNo())
            .append("otherBankName", getOtherBankName())
            .append("companyName", getCompanyName())
            .append("companyId", getCompanyId())
            .append("companyType", getCompanyType())
            .append("reason", getReason())
            .append("attachment", getAttachment())
            .append("applyPerson", getApplyPerson())
            .append("applyPersonID", getApplyPersonID())
            .append("checkState", getCheckState())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .append("submitflag", getSubmitflag())
            .toString();
    }
}
