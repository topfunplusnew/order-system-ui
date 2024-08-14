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
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 加油卡信息对象 oilCard
 * 
 * @author ml
 * @date 2024-07-29
 */
@TableName("oilCard")
public class OilCard extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId("id")
    private Long id;

    /** 加油卡卡号 */
    @TableField("oilCardNo")
    @Excel(name = "加油卡卡号")
    @NotNull(message = "加油卡卡号不能为空")
    @Length(max = 55, message = "加油卡卡号的字符长度不允许超过55")
    private String oilCardNo;

    /** 加油卡类别（主卡、副卡） */
    @Excel(name = "加油卡类别")
    @TableField("oilType")
    @NotNull(message = "加油卡类别不能为空")
    @Pattern(regexp = "主卡|副卡", message = "加油卡类别必须是：主卡或副卡")
    private String oilType;

    /** 当前金额 */
    @NotNull(message = "当前金额不能为空")
    @TableField("moneyAmount")
    @DecimalMaxDigits
    @Max(value = 10000000, message = "当前金额不能超过100万")
    private Double moneyAmount;

    /** 备注 */
    @Excel(name = "备注")
    @TableField("comments")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
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
    @TableField("userName")
    private String UserName;

    /** 删除标记 */
    @FlagOnlyZeroOrOne
    @TableField("delFlag")
    private Long delFlag;


    // 搜索用的字段, 金额区间
    @TableField(exist = false)
    private Double moneyAmountMin;
    @TableField(exist = false)
    private Double moneyAmountMax;

    public Double getMoneyAmountMin() {
        return moneyAmountMin;
    }

    public void setMoneyAmountMin(Double moneyAmountMin) {
        this.moneyAmountMin = moneyAmountMin;
    }

    public Double getMoneyAmountMax() {
        return moneyAmountMax;
    }

    public void setMoneyAmountMax(Double moneyAmountMax) {
        this.moneyAmountMax = moneyAmountMax;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setOilCardNo(String oilCardNo) 
    {
        this.oilCardNo = oilCardNo;
    }

    public String getOilCardNo() 
    {
        return oilCardNo;
    }
    public void setOilType(String oilType) 
    {
        this.oilType = oilType;
    }

    public String getOilType() 
    {
        return oilType;
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
            .append("oilCardNo", getOilCardNo())
            .append("oilType", getOilType())
            .append("moneyAmount", getMoneyAmount())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
