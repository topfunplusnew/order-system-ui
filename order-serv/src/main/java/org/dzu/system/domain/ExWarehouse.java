package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 出库对象 exWarehouse
 *
 */
@TableName("exWarehouse")
public class ExWarehouse extends BaseEntity {
    private static final long serialVersionUID = 1L;

    @TableId(value = "id")
    private Long id;

    @Excel(name = "订单编号")
    @TableField(value = "ordersNo")
    @NotNull(message = "订单编号不能为空")
    @Length(max = 64, message = "订单编号长度不能超过64个字符")
    private String ordersNo;

    @Excel(name = "仓库ID")
    @TableField(value = "storeHouseid")
    @NotNull(message = "仓库ID不能为空")
    private Long storeHouseid;

    @Excel(name = "仓库名称")
    @TableField(value = "storeHouseName")
    @Length(max = 64, message = "仓库名称长度不能超过64个字符")
    @NotNull(message = "仓库名称不能为空")
    private String storeHouseName;

    @Excel(name = "仓库存储的货物ID")
    @TableField(value = "storeID")
    @NotNull(message = "仓库存储的货物ID不能为空")
    private Long storeID;

    @Excel(name = "出库日期", dateFormat = "yyyy-MM-dd")
    @TableField(value = "outDate")
    private String outDate;

    @Excel(name = "出库量", readConverterExp = "片数")
    @TableField(value = "outAmount")
    @NotNull(message = "出库量不能为空")
    private Long outAmount;

    @FlagOnlyZeroOrOne
    @TableField(value = "delFlag")
    private Long delFlag;

    @Excel(name = "添加时间")
    @TableField(value = "addtime")
    private String addtime;

    @Excel(name = "操作人员ID")
    @TableField(value = "userId")
    private Long userId;

    @Excel(name = "操作人员姓名")
    @TableField(value = "UserName")
    private String UserName;

    @TableField(exist = false)
    private String outDateStart;

    @TableField(exist = false)
    private String outDateEnd;

    @TableField(exist = false)
    private String  isOrder;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getOrdersNo() {
        return ordersNo;
    }

    public void setOrdersNo(String ordersNo) {
        this.ordersNo = ordersNo;
    }

    public Long getStoreHouseid() {
        return storeHouseid;
    }

    public void setStoreHouseid(Long storeHouseid) {
        this.storeHouseid = storeHouseid;
    }

    public String getStoreHouseName() {
        return storeHouseName;
    }

    public void setStoreHouseName(String storeHouseName) {
        this.storeHouseName = storeHouseName;
    }

    public Long getStoreID() {
        return storeID;
    }

    public void setStoreID(Long storeID) {
        this.storeID = storeID;
    }

    public String getOutDate() {
        return outDate;
    }

    public void setOutDate(String outDate) {
        this.outDate = outDate;
    }

    public Long getOutAmount() {
        return outAmount;
    }

    public void setOutAmount(Long outAmount) {
        this.outAmount = outAmount;
    }

    public Long getDelFlag() {
        return delFlag;
    }

    public void setDelFlag(Long delFlag) {
        this.delFlag = delFlag;
    }

    public String getAddtime() {
        return addtime;
    }

    public void setAddtime(String addtime) {
        this.addtime = addtime;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return UserName;
    }

    public void setUserName(String UserName) {
        this.UserName = UserName;
    }

    public String getOutDateStart() {
        return outDateStart;
    }

    public void setOutDateStart(String outDateStart) {
        this.outDateStart = outDateStart;
    }

    public String getOutDateEnd() {
        return outDateEnd;
    }

    public void setOutDateEnd(String outDateEnd) {
        this.outDateEnd = outDateEnd;
    }

    public String  getIsOrder() {
        return isOrder;
    }

    public void setIsOrder(String  isOrder) {
        this.isOrder = isOrder;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
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
            .append("isOrder", getIsOrder())
            .toString();
    }
}