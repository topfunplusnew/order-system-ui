package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.OnlyZeroOrOne;
/**
 * 车辆派出管理对象 carapply
 * 
 * @author ml
 * @date 2024-07-29
 */
public class Carapply extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 申请时间 */
    @Excel(name = "申请时间")
    private String applyDate;

    /** 申请人 */
    @Excel(name = "申请人")
    private String applyUser;

    /** 部门 */
    @Excel(name = "部门")
    private String department;

    /** 车牌 */
    @Excel(name = "车牌")
    private String carNo;

    /** 是否携带油卡 */
    @Excel(name = "是否携带油卡")
    private Long isUseOilCard;

    /** 油卡号 */
    @Excel(name = "油卡号")
    private String iolCardNo;

    /** 随同乘车人员 */
    @Excel(name = "随同乘车人员")
    private String peers;

    /** 用车时间 */
    @Excel(name = "用车时间")
    private String startTime;

    /** 还车时间 */
    @Excel(name = "还车时间")
    private String endTime;

    /** 用车事由 */
    @Excel(name = "用车事由")
    private String ApplyPurpose;

    /** 出车前里程 */
    @Excel(name = "出车前里程")
    private String startMile;

    /** 出车前车况（外观是否损坏，车胎等） */
    @Excel(name = "出车前车况", readConverterExp = "外=观是否损坏，车胎等")
    private String startCarState;

    /** 回来后里程 */
    @Excel(name = "回来后里程")
    private String endMile;

    /** 回来后车况（外观是否损坏，车胎等） */
    @Excel(name = "回来后车况", readConverterExp = "外=观是否损坏，车胎等")
    private String endCarState;

    /** 用车里程数 */
    @Excel(name = "用车里程数")
    private String miles;

    /** 回程停靠位置 */
    @Excel(name = "回程停靠位置")
    private String backStopPlace;

    /** 行程中违法次数 */
    @Excel(name = "行程中违法次数")
    private String violationsCount;

    /** 违章罚款金额金额 */
    @Excel(name = "违章罚款金额金额")
    private String fine;

    /** 行程中是否维修/保养 */
    @Excel(name = "行程中是否维修/保养")
    private String isMaintenance;

    /** 保养金额 */
    @Excel(name = "保养金额")
    private String maintenanceMoney;

    /** 行程中使用加油卡加油次数 */
    @Excel(name = "行程中使用加油卡加油次数")
    private String refuelingFrequency;

    /** 加油金额 */
    @Excel(name = "加油金额")
    private String refuelingMoney;

    /** 加油卡余额 */
    @Excel(name = "加油卡余额")
    private String oilCardSurplus;

    /** 加油小票记录是否交给公司管理车辆人员 */
    @Excel(name = "加油小票记录是否交给公司管理车辆人员")
    private String isOilTicket;

    /** 现金加油金额 */
    @Excel(name = "现金加油金额")
    private String refuelingCash;

    /** 派车人 */
    @Excel(name = "派车人")
    private String dispatchPerson;

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

    /** 附件路径 */
    @Excel(name = "附件路径")
    private String path;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setApplyDate(String applyDate) 
    {
        this.applyDate = applyDate;
    }

    public String getApplyDate() 
    {
        return applyDate;
    }
    public void setApplyUser(String applyUser) 
    {
        this.applyUser = applyUser;
    }

    public String getApplyUser() 
    {
        return applyUser;
    }
    public void setDepartment(String department) 
    {
        this.department = department;
    }

    public String getDepartment() 
    {
        return department;
    }
    public void setCarNo(String carNo) 
    {
        this.carNo = carNo;
    }

    public String getCarNo() 
    {
        return carNo;
    }
    public void setIsUseOilCard(Long isUseOilCard) 
    {
        this.isUseOilCard = isUseOilCard;
    }

    public Long getIsUseOilCard() 
    {
        return isUseOilCard;
    }
    public void setIolCardNo(String iolCardNo) 
    {
        this.iolCardNo = iolCardNo;
    }

    public String getIolCardNo() 
    {
        return iolCardNo;
    }
    public void setPeers(String peers) 
    {
        this.peers = peers;
    }

    public String getPeers() 
    {
        return peers;
    }
    public void setStartTime(String startTime) 
    {
        this.startTime = startTime;
    }

    public String getStartTime() 
    {
        return startTime;
    }
    public void setEndTime(String endTime) 
    {
        this.endTime = endTime;
    }

    public String getEndTime() 
    {
        return endTime;
    }
    public void setApplyPurpose(String ApplyPurpose) 
    {
        this.ApplyPurpose = ApplyPurpose;
    }

    public String getApplyPurpose() 
    {
        return ApplyPurpose;
    }
    public void setStartMile(String startMile) 
    {
        this.startMile = startMile;
    }

    public String getStartMile() 
    {
        return startMile;
    }
    public void setStartCarState(String startCarState) 
    {
        this.startCarState = startCarState;
    }

    public String getStartCarState() 
    {
        return startCarState;
    }
    public void setEndMile(String endMile) 
    {
        this.endMile = endMile;
    }

    public String getEndMile() 
    {
        return endMile;
    }
    public void setEndCarState(String endCarState) 
    {
        this.endCarState = endCarState;
    }

    public String getEndCarState() 
    {
        return endCarState;
    }
    public void setMiles(String miles) 
    {
        this.miles = miles;
    }

    public String getMiles() 
    {
        return miles;
    }
    public void setBackStopPlace(String backStopPlace) 
    {
        this.backStopPlace = backStopPlace;
    }

    public String getBackStopPlace() 
    {
        return backStopPlace;
    }
    public void setViolationsCount(String violationsCount) 
    {
        this.violationsCount = violationsCount;
    }

    public String getViolationsCount() 
    {
        return violationsCount;
    }
    public void setFine(String fine) 
    {
        this.fine = fine;
    }

    public String getFine() 
    {
        return fine;
    }
    public void setIsMaintenance(String isMaintenance) 
    {
        this.isMaintenance = isMaintenance;
    }

    public String getIsMaintenance() 
    {
        return isMaintenance;
    }
    public void setMaintenanceMoney(String maintenanceMoney) 
    {
        this.maintenanceMoney = maintenanceMoney;
    }

    public String getMaintenanceMoney() 
    {
        return maintenanceMoney;
    }
    public void setRefuelingFrequency(String refuelingFrequency) 
    {
        this.refuelingFrequency = refuelingFrequency;
    }

    public String getRefuelingFrequency() 
    {
        return refuelingFrequency;
    }
    public void setRefuelingMoney(String refuelingMoney) 
    {
        this.refuelingMoney = refuelingMoney;
    }

    public String getRefuelingMoney() 
    {
        return refuelingMoney;
    }
    public void setOilCardSurplus(String oilCardSurplus) 
    {
        this.oilCardSurplus = oilCardSurplus;
    }

    public String getOilCardSurplus() 
    {
        return oilCardSurplus;
    }
    public void setIsOilTicket(String isOilTicket) 
    {
        this.isOilTicket = isOilTicket;
    }

    public String getIsOilTicket() 
    {
        return isOilTicket;
    }
    public void setRefuelingCash(String refuelingCash) 
    {
        this.refuelingCash = refuelingCash;
    }

    public String getRefuelingCash() 
    {
        return refuelingCash;
    }
    public void setDispatchPerson(String dispatchPerson) 
    {
        this.dispatchPerson = dispatchPerson;
    }

    public String getDispatchPerson() 
    {
        return dispatchPerson;
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
    public void setPath(String path) 
    {
        this.path = path;
    }

    public String getPath() 
    {
        return path;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("applyDate", getApplyDate())
            .append("applyUser", getApplyUser())
            .append("department", getDepartment())
            .append("carNo", getCarNo())
            .append("isUseOilCard", getIsUseOilCard())
            .append("iolCardNo", getIolCardNo())
            .append("peers", getPeers())
            .append("startTime", getStartTime())
            .append("endTime", getEndTime())
            .append("ApplyPurpose", getApplyPurpose())
            .append("startMile", getStartMile())
            .append("startCarState", getStartCarState())
            .append("endMile", getEndMile())
            .append("endCarState", getEndCarState())
            .append("miles", getMiles())
            .append("backStopPlace", getBackStopPlace())
            .append("violationsCount", getViolationsCount())
            .append("fine", getFine())
            .append("isMaintenance", getIsMaintenance())
            .append("maintenanceMoney", getMaintenanceMoney())
            .append("refuelingFrequency", getRefuelingFrequency())
            .append("refuelingMoney", getRefuelingMoney())
            .append("oilCardSurplus", getOilCardSurplus())
            .append("isOilTicket", getIsOilTicket())
            .append("refuelingCash", getRefuelingCash())
            .append("dispatchPerson", getDispatchPerson())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .append("path", getPath())
            .toString();
    }
}
