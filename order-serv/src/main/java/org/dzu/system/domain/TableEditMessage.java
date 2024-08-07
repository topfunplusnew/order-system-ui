package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

/**
 * 编辑原因对象 tableEditMessage
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("tableEditMessage")
public class TableEditMessage extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 表名 */
    @Excel(name = "表名")
    @Length(max = 24, message = "表名长度不能超过24个字符")
    @TableField(value = "tableName")
    private String tableName;

    /** 修改时间 */
    @Excel(name = "修改时间")
    @TableField(value = "modifyTime")
    @Length(max = 20, message = "修改时间长度不能超过20个字符")
    private String modifyTime;

    /** 修改原因 */
    @Excel(name = "修改原因")
    @Length(max = 200, message = "修改原因长度不能超过200个字符")
    @TableField(value = "reason")
    private String reason;

    /** 修改表对应信息的id */
    @Excel(name = "修改表对应信息的id")
    @TableField(value = "tid")
    @Length(max = 20, message = "修改表对应信息的id长度不能超过20个字符")
    private Long tid;

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
    public void setTableName(String tableName) 
    {
        this.tableName = tableName;
    }

    public String getTableName() 
    {
        return tableName;
    }
    public void setModifyTime(String modifyTime) 
    {
        this.modifyTime = modifyTime;
    }

    public String getModifyTime() 
    {
        return modifyTime;
    }
    public void setReason(String reason) 
    {
        this.reason = reason;
    }

    public String getReason() 
    {
        return reason;
    }
    public void setTid(Long tid) 
    {
        this.tid = tid;
    }

    public Long getTid() 
    {
        return tid;
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
            .append("tableName", getTableName())
            .append("modifyTime", getModifyTime())
            .append("reason", getReason())
            .append("tid", getTid())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .toString();
    }
}
