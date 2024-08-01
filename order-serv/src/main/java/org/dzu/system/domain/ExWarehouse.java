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
 * 出库对象 exWarehouse
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("exWarehouse")
public class ExWarehouse extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 订单编号（UUID） */
    @Excel(name = "订单编号", readConverterExp = "U=UID")
    @TableField(value = "ordersNo")
    private String ordersNo;

    /** 仓库ID */
    @Excel(name = "仓库ID")
    @TableField(value = "storeHouseid")
    private Long storeHouseid;

    /** 仓库名称 */
    @Excel(name = "仓库名称")
    @TableField(value = "storeHouseName")
    private String storeHouseName;

    /** 仓库存储的货物ID */
    @Excel(name = "仓库存储的货物ID")
    @TableField(value = "storeID")
    private Long storeID;

    /** 出库日期 */
    @Excel(name = "出库日期")
    @TableField(value = "outDate")
    private String outDate;

    /** 出库量（片数） */
    @Excel(name = "出库量", readConverterExp = "片=数")
    @TableField(value = "outAmount")
    private Long outAmount;

    /** 删除标记 */
    @OnlyZeroOrOne
    @TableField(value = "delFlag")
    private Long delFlag;

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
    public void setOrdersNo(String ordersNo) 
    {
        this.ordersNo = ordersNo;
    }

    public String getOrdersNo() 
    {
        return ordersNo;
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
            .append("ordersNo", getOrdersNo())
            .append("storeHouseid", getStoreHouseid())
            .append("storeHouseName", getStoreHouseName())
            .append("storeID", getStoreID())
            .append("outDate", getOutDate())
            .append("outAmount", getOutAmount())
            .append("delFlag", getDelFlag())
            .append("updateTime", getUpdateTime())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .toString();
    }
}
