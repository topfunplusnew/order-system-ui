package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

/**
 * 出差报销对象 tripReimbursement
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("tripReimbursement")
public class TripReimbursement extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 出差ID */
    @Excel(name = "出差ID")
    @TableField(value = "bTripId")
    @Length(max = 20, message = "出差ID长度不能超过20个字符")
    private Long bTripId;

    /** 报销项 */
    @Excel(name = "报销项")
    @Length(max = 20, message = "报销项长度不能超过20个字符")
    @TableField(value = "item")
    private String item;

    /** 费用 */
    @Excel(name = "费用")
    @Length(max = 20, message = "费用长度不能超过20个字符")
    @TableField(value = "itemCost")
    private String itemCost;

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
    public void setbTripId(Long bTripId) 
    {
        this.bTripId = bTripId;
    }

    public Long getbTripId() 
    {
        return bTripId;
    }
    public void setItem(String item) 
    {
        this.item = item;
    }

    public String getItem() 
    {
        return item;
    }
    public void setItemCost(String itemCost) 
    {
        this.itemCost = itemCost;
    }

    public String getItemCost() 
    {
        return itemCost;
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
            .append("bTripId", getbTripId())
            .append("item", getItem())
            .append("itemCost", getItemCost())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
