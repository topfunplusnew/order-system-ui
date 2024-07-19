package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

/**
 * 出库对象 exwarehouse
 * 
 * @author ml
 * @date 2024-07-19
 */
public class Exwarehouse extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 仓库ID */
    @Excel(name = "仓库ID")
    private Long storeHouseid;

    /** 仓库名称 */
    @Excel(name = "仓库名称")
    private String storeHouseName;

    /** 仓库存储的货物ID */
    @Excel(name = "仓库存储的货物ID")
    private Long storeID;

    /** 出库日期 */
    @Excel(name = "出库日期")
    private String outDate;

    /** 出库量（片数） */
    @Excel(name = "出库量", readConverterExp = "片=数")
    private Long outAmount;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号", readConverterExp = "U=UID")
    private String ordersNo;

    /** 删除标记 */
    @Excel(name = "删除标记")
    private Long delFlag;

    /** 添加时间 */
    @Excel(name = "添加时间")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    private String UserName;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setStoreHouseid(Long storeHouseid) 
    {
        this.storeHouseid = storeHouseid;
    }

    public Long getStoreHouseid() 
    {
        return storeHouseid;
    }
    public void setStoreHouseName(String storeHouseName) 
    {
        this.storeHouseName = storeHouseName;
    }

    public String getStoreHouseName() 
    {
        return storeHouseName;
    }
    public void setStoreID(Long storeID) 
    {
        this.storeID = storeID;
    }

    public Long getStoreID() 
    {
        return storeID;
    }
    public void setOutDate(String outDate) 
    {
        this.outDate = outDate;
    }

    public String getOutDate() 
    {
        return outDate;
    }
    public void setOutAmount(Long outAmount) 
    {
        this.outAmount = outAmount;
    }

    public Long getOutAmount() 
    {
        return outAmount;
    }
    public void setOrdersNo(String ordersNo) 
    {
        this.ordersNo = ordersNo;
    }

    public String getOrdersNo() 
    {
        return ordersNo;
    }
    public void setDelFlag(Long delFlag) 
    {
        this.delFlag = delFlag;
    }

    public Long getDelFlag() 
    {
        return delFlag;
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
            .append("storeHouseid", getStoreHouseid())
            .append("storeHouseName", getStoreHouseName())
            .append("storeID", getStoreID())
            .append("outDate", getOutDate())
            .append("outAmount", getOutAmount())
            .append("ordersNo", getOrdersNo())
            .append("delFlag", getDelFlag())
            .append("updateTime", getUpdateTime())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .toString();
    }
}
