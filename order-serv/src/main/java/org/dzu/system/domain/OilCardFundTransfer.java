package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
/**
 * 加油卡圈存对象 oilCardFundTransfer
 * 
 * @author ml
 * @date 2024-07-29
 */
public class OilCardFundTransfer extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 主加油卡卡号 */
    @Excel(name = "主加油卡卡号")
    private String oilMainCardNo;

    /** 副加油卡卡号 */
    @Excel(name = "副加油卡卡号")
    private String oilSecondCardNo;

    /** 充值金额 */
    @DecimalMaxDigits
    private Double rechargeMoney;

    /** 充值时间 */
    @Excel(name = "充值时间")
    private String rechargeDate;

    /** 充值人员姓名 */
    @Excel(name = "充值人员姓名")
    private String rechargeName;

    /** 备注 */
    @Excel(name = "备注")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    private String UserName;

    /** 删除标记 */
    @OnlyZeroOrOne
    private Long delFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setOilMainCardNo(String oilMainCardNo) 
    {
        this.oilMainCardNo = oilMainCardNo;
    }

    public String getOilMainCardNo() 
    {
        return oilMainCardNo;
    }
    public void setOilSecondCardNo(String oilSecondCardNo) 
    {
        this.oilSecondCardNo = oilSecondCardNo;
    }

    public String getOilSecondCardNo() 
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
