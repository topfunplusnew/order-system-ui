package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 虚拟银行账号对象 virtualBankAccountChange
 * 
 * @author ml
 * @date 2024-07-29
 */
@TableName("virtualBankAccountChange")
public class VirtualBankAccountChange extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 公司ID */
    @TableField(value = "companyId")
    @Excel(name = "公司ID")
    @NotNull(message = "公司ID不能为空")
    @Length(max = 80, message = "公司ID的字符长度不允许超过80")
    private String companyId;

    /** 发生操作行为的表 */
    @Excel(name = "发生操作行为的表")
    @TableField(value = "tableName")
    @Length(max = 80, message = "发生操作行为的表的字符长度不允许超过80")
    private String tableName;

    /** 发生操作行为的冲抵款编号（UUID） */
    @TableField(value = "payNO")
    @NotNull(message = "发生操作行为的冲抵款编号不能为空")
    @Excel(name = "发生操作行为的冲抵款编号")
    @Length(max = 50, message = "冲抵款编号的字符长度不允许超过50")
    private String payNO;

    /** 日期 */
    @Excel(name = "日期")
    @TableField(value = "operateDate")
    @Length(max = 50, message = "日期的字符长度不允许超过50")
    private String operateDate;

    /** 变动类型（收入、支出） */
    @TableField(value = "changeType")
    @Excel(name = "变动类型", readConverterExp = "收=入、支出")
    @NotNull(message = "变动类型不能为空")
    @Pattern(regexp = "收入|支出", message = "变动类型必须是：收入或支出")
    private String changeType;

    /** 金额 */
    @NotNull(message = "金额不能为空")
    @TableField(value = "moneyAmount")
    @DecimalMaxDigits
    private Double moneyAmount;

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

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setCompanyId(String companyId) 
    {
        this.companyId = companyId;
    }

    public String getCompanyId() 
    {
        return companyId;
    }
    public void setTableName(String tableName) 
    {
        this.tableName = tableName;
    }

    public String getTableName() 
    {
        return tableName;
    }
    public void setPayNO(String payNO) 
    {
        this.payNO = payNO;
    }

    public String getPayNO() 
    {
        return payNO;
    }
    public void setOperateDate(String operateDate) 
    {
        this.operateDate = operateDate;
    }

    public String getOperateDate() 
    {
        return operateDate;
    }
    public void setChangeType(String changeType) 
    {
        this.changeType = changeType;
    }

    public String getChangeType() 
    {
        return changeType;
    }
    public void setMoneyAmount(Double moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Double getMoneyAmount() 
    {
        return moneyAmount;
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
            .append("companyId", getCompanyId())
            .append("tableName", getTableName())
            .append("payNO", getPayNO())
            .append("operateDate", getOperateDate())
            .append("changeType", getChangeType())
            .append("moneyAmount", getMoneyAmount())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
