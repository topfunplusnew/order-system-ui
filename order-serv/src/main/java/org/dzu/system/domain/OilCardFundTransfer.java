package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/**
 * 加油卡圈存对象 oilCardFundTransfer
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("oilCardFundTransfer")
public class OilCardFundTransfer extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 主加油卡卡号 */
    @Excel(name = "主加油卡卡号")
    @Max(value =25, message = "主加油卡卡号长度不能超过25")
    @Min(value = 0, message = "主加油卡卡号长度不能小于0")
    @NotNull(message = "主加油卡卡号不能为空")
    @TableField(value = "oilMainCardNo")
    private long oilMainCardNo;

    /** 副加油卡卡号 */
    @Excel(name = "副加油卡卡号")
    @Max( value= 25, message = "副加油卡卡号长度不能超过25")
    @Min( value= 0, message = "副加油卡卡号长度不能小于0")
    @NotNull(message = "副加油卡卡号不能为空")
    @TableField(value = "oilSecondCardNo")
    private long oilSecondCardNo;

    /** 充值金额 */
    @DecimalMaxDigits
    @TableField(value = "rechargeMoney")
    private Double rechargeMoney;

    /** 充值时间 */
    @Excel(name = "充值时间")
    @TableField(value = "rechargeDate")
    private String rechargeDate;

    /** 充值人员姓名 */
    @Excel(name = "充值人员姓名")
    @NotNull(message = "充值人员姓名不能为空")
    @Length( max = 25, message = "充值人员姓名长度不能超过25")
    @TableField(value = "rechargeName")
    private String rechargeName;

    /** 备注 */
    @Excel(name = "备注")
    @Length( max = 255, message = "备注长度不能超过255")
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
    @FlagOnlyZeroOrOne
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
    public void setOilMainCardNo(Long oilMainCardNo)
    {
        this.oilMainCardNo = oilMainCardNo;
    }

    public Long getOilMainCardNo()
    {
        return oilMainCardNo;
    }
    public void setOilSecondCardNo(Long oilSecondCardNo)
    {
        this.oilSecondCardNo = oilSecondCardNo;
    }

    public Long getOilSecondCardNo()
    {
        return oilSecondCardNo;
    }
    public void setRechargeMoney(Double rechargeMoney) 
    {
        this.rechargeMoney = rechargeMoney;
    }

    public Double getRechargeMoney() 
    {
        return rechargeMoney;
    }
    public void setRechargeDate(String rechargeDate) 
    {
        this.rechargeDate = rechargeDate;
    }

    public String getRechargeDate() 
    {
        return rechargeDate;
    }
    public void setRechargeName(String rechargeName) 
    {
        this.rechargeName = rechargeName;
    }

    public String getRechargeName() 
    {
        return rechargeName;
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
            .append("oilMainCardNo", getOilMainCardNo())
            .append("oilSecondCardNo", getOilSecondCardNo())
            .append("rechargeMoney", getRechargeMoney())
            .append("rechargeDate", getRechargeDate())
            .append("rechargeName", getRechargeName())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
