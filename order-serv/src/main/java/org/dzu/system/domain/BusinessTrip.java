package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.dzu.common.annotation.OnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 出差对象 BusinessTrip
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("BusinessTrip")
public class BusinessTrip extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 报销人ID */
    @Excel(name = "报销人ID")
    @Length(max = 20, message = "报销人ID长度不能超过20个字符")
    @TableField(value = "employeeID")
    @NotNull(message = "报销人ID不能为空")
    private Long employeeID;

    /** 报销人 */
    @Excel(name = "报销人")
    @TableField(value = "employee")
    @NotNull(message = "报销人不能为空")
    @Length(max = 20, message = "报销人长度不能超过20个字符")
    private String employee;

    /** 共同出差人员 */
    @Excel(name = "共同出差人员")
    @TableField(value = "personnel")
    @Length(max = 100, message = "共同出差人员长度不能超过100个字符")
    private String personnel;

    /** 出差时间 */
    @Excel(name = "出差时间",dateFormat = "yyyy-MM-dd")
    @TableField(value = "starttime")
    @NotNull(message = "出差时间不能为空")
    private String starttime;

    /** 出差结束时间 */
    @Excel(name = "出差结束时间",dateFormat = "yyyy-MM-dd")
    @TableField(value = "endtime")
    @NotNull(message = "出差结束时间不能为空")
    private String endtime;

    /** 附件地址 */
    @Excel(name = "附件地址")
    @Length(max = 50, message = "附件地址长度不能超过50个字符")
    @TableField(value = "attachmentPath")
    private String attachmentPath;

    /** 是否已报销（0未报销，1已报销） */
    @Excel(name = "是否已报销", readConverterExp = "0=未报销，1已报销")
    @TableField(value = "isReimburse")
    @NotNull(message = "是否已报销不能为空")
    private Long isReimburse;

    /** 备注 */
    @Excel(name = "备注")
    @TableField(value = "comments")
    @Length(max = 200, message = "备注长度不能超过200个字符")
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
    @OnlyZeroOrOne
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
    public void setEmployeeID(Long employeeID) 
    {
        this.employeeID = employeeID;
    }

    public Long getEmployeeID() 
    {
        return employeeID;
    }
    public void setEmployee(String employee) 
    {
        this.employee = employee;
    }

    public String getEmployee() 
    {
        return employee;
    }
    public void setPersonnel(String personnel) 
    {
        this.personnel = personnel;
    }

    public String getPersonnel() 
    {
        return personnel;
    }
    public void setStarttime(String starttime) 
    {
        this.starttime = starttime;
    }

    public String getStarttime() 
    {
        return starttime;
    }
    public void setEndtime(String endtime) 
    {
        this.endtime = endtime;
    }

    public String getEndtime() 
    {
        return endtime;
    }
    public void setAttachmentPath(String attachmentPath) 
    {
        this.attachmentPath = attachmentPath;
    }

    public String getAttachmentPath() 
    {
        return attachmentPath;
    }
    public void setIsReimburse(Long isReimburse) 
    {
        this.isReimburse = isReimburse;
    }

    public Long getIsReimburse() 
    {
        return isReimburse;
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
            .append("employeeID", getEmployeeID())
            .append("employee", getEmployee())
            .append("personnel", getPersonnel())
            .append("starttime", getStarttime())
            .append("endtime", getEndtime())
            .append("attachmentPath", getAttachmentPath())
            .append("isReimburse", getIsReimburse())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
