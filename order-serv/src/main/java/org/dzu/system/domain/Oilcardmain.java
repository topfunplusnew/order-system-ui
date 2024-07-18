package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

/**
 * 加油卡主卡登记信息对象 oilcardmain
 * 
 * @author ml
 * @date 2024-07-18
 */
public class Oilcardmain extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 加油卡卡号 */
    @Excel(name = "加油卡卡号")
    private String oilCardNo;

    /** 使用加油卡时间 */
    @Excel(name = "使用加油卡时间")
    private String useDate;

    /** 使用加油卡车辆车牌号 */
    @Excel(name = "使用加油卡车辆车牌号")
    private String carNo;

    /** 地点、事由 */
    @Excel(name = "地点、事由")
    private String destination;

    /** 期初余额 */
    @Excel(name = "期初余额")
    private String startCardSurplus;

    /** 主卡转副卡充值金额 */
    @Excel(name = "主卡转副卡充值金额")
    private String toPlusCardMoney;

    /** 加油量（升） */
    @Excel(name = "加油量", readConverterExp = "升=")
    private String refuelingNumber;

    /** 单价 */
    @Excel(name = "单价")
    private String unitPrice;

    /** 加油金额(元） */
    @Excel(name = "加油金额(元）")
    private String refuelingMoney;

    /** 充值金额 */
    @Excel(name = "充值金额")
    private String rechargeMoney;

    /** 是否有小票 */
    @Excel(name = "是否有小票")
    private String isTicket;

    /** 加油卡余额 */
    @Excel(name = "加油卡余额")
    private String endCardSurplus;

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
    @Excel(name = "删除标记")
    private Long delFlag;

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
    public void setUseDate(String useDate) 
    {
        this.useDate = useDate;
    }

    public String getUseDate() 
    {
        return useDate;
    }
    public void setCarNo(String carNo) 
    {
        this.carNo = carNo;
    }

    public String getCarNo() 
    {
        return carNo;
    }
    public void setDestination(String destination) 
    {
        this.destination = destination;
    }

    public String getDestination() 
    {
        return destination;
    }
    public void setStartCardSurplus(String startCardSurplus) 
    {
        this.startCardSurplus = startCardSurplus;
    }

    public String getStartCardSurplus() 
    {
        return startCardSurplus;
    }
    public void setToPlusCardMoney(String toPlusCardMoney) 
    {
        this.toPlusCardMoney = toPlusCardMoney;
    }

    public String getToPlusCardMoney() 
    {
        return toPlusCardMoney;
    }
    public void setRefuelingNumber(String refuelingNumber) 
    {
        this.refuelingNumber = refuelingNumber;
    }

    public String getRefuelingNumber() 
    {
        return refuelingNumber;
    }
    public void setUnitPrice(String unitPrice) 
    {
        this.unitPrice = unitPrice;
    }

    public String getUnitPrice() 
    {
        return unitPrice;
    }
    public void setRefuelingMoney(String refuelingMoney) 
    {
        this.refuelingMoney = refuelingMoney;
    }

    public String getRefuelingMoney() 
    {
        return refuelingMoney;
    }
    public void setRechargeMoney(String rechargeMoney) 
    {
        this.rechargeMoney = rechargeMoney;
    }

    public String getRechargeMoney() 
    {
        return rechargeMoney;
    }
    public void setIsTicket(String isTicket) 
    {
        this.isTicket = isTicket;
    }

    public String getIsTicket() 
    {
        return isTicket;
    }
    public void setEndCardSurplus(String endCardSurplus) 
    {
        this.endCardSurplus = endCardSurplus;
    }

    public String getEndCardSurplus() 
    {
        return endCardSurplus;
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
            .append("useDate", getUseDate())
            .append("carNo", getCarNo())
            .append("destination", getDestination())
            .append("startCardSurplus", getStartCardSurplus())
            .append("toPlusCardMoney", getToPlusCardMoney())
            .append("refuelingNumber", getRefuelingNumber())
            .append("unitPrice", getUnitPrice())
            .append("refuelingMoney", getRefuelingMoney())
            .append("rechargeMoney", getRechargeMoney())
            .append("isTicket", getIsTicket())
            .append("endCardSurplus", getEndCardSurplus())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
