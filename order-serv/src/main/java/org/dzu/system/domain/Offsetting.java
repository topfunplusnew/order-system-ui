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
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 对冲账信息对象 Offsetting
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("Offsetting")
public class Offsetting extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 冲抵编号（UUID） */
    @Excel(name = "冲抵编号", readConverterExp = "U=UID")
    @Length(max = 50, message = "冲抵编号长度不能超过50个字符")
    @TableField(value = "OffsetNO")
    private String OffsetNO;

    /** 操作时间 */
    @Excel(name = "操作时间")
    @NotNull(message = "操作时间不能为空")
    @Length(max = 50, message = "操作时间长度不能超过50个字符")
    @TableField(value = "operateDate")
    private String operateDate;

    /** 冲抵类型（收入、支出） */
    @Excel(name = "冲抵类型", readConverterExp = "收=入、支出")
    @NotNull(message = "冲抵类型不能为空")
    @Pattern(regexp = "收入|支出", message = "冲抵类型只能是'收入'或'支出'")
    @TableField(value = "operateType")
    private String operateType;

    /** 金额 */
    @DecimalMaxDigits
    @NotNull(message = "金额不能为空")
    @Min(value = 0, message = "金额必须大于或等于0")
    @TableField(value = "moneyAmount")
    private Double moneyAmount;

    /** 公司 */
    @Excel(name = "公司")
    @NotNull(message = "公司名称不能为空")
    @Length(max = 150, message = "公司名称长度不能超过150个字符")
    @TableField(value = "companyName")
    private String companyName;

    /** 公司ID */
    @Excel(name = "公司ID")
    @NotNull(message = "公司ID不能为空")
    @TableField(value = "companyId")
    private Long companyId;

    /** 公司类型（1、客户 2、供应商） */
    @Excel(name = "公司类型", readConverterExp = "1=、客户,2=、供应商")
    @NotNull(message = "公司类型不能为空")
    @Pattern(regexp = "1|2", message = "公司类型只能是'1'（客户）或'2'（供应商）")
    @TableField(value = "companyType")
    private Long companyType;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注长度不能超过200个字符")
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
    public void setOffsetNO(String OffsetNO) 
    {
        this.OffsetNO = OffsetNO;
    }

    public String getOffsetNO() 
    {
        return OffsetNO;
    }
    public void setOperateDate(String operateDate) 
    {
        this.operateDate = operateDate;
    }

    public String getOperateDate() 
    {
        return operateDate;
    }
    public void setOperateType(String operateType) 
    {
        this.operateType = operateType;
    }

    public String getOperateType() 
    {
        return operateType;
    }
    public void setMoneyAmount(Double moneyAmount) 
    {
        this.moneyAmount = moneyAmount;
    }

    public Double getMoneyAmount() 
    {
        return moneyAmount;
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
            .append("OffsetNO", getOffsetNO())
            .append("operateDate", getOperateDate())
            .append("operateType", getOperateType())
            .append("moneyAmount", getMoneyAmount())
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
