package org.dzu.system.domain;

import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
/**
 * 出差对象 BusinessTrip
 * 
 * @author ml
 * @date 2024-08-10
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
    @TableField(value = "employeeID")
    private Long employeeID;

    /** 报销人 */
    @Excel(name = "报销人")
    @TableField(value = "employee")
    private String employee;

    /** 共同出差人员 */
    @Excel(name = "共同出差人员")
    @TableField(value = "personnel")
    private String personnel;

    /** 出差时间 */
    @Excel(name = "出差时间")
    @TableField(value = "starttime")
    private String starttime;

    /** 出差结束时间 */
    @Excel(name = "出差结束时间")
    @TableField(value = "endtime")
    private String endtime;

    /** 附件地址 */
    @Excel(name = "附件地址")
    @TableField(value = "attachmentPath")
    private String attachmentPath;

    /** 是否已报销（0未报销，1已报销） */
    @Excel(name = "是否已报销", readConverterExp = "0=未报销,1=已报销")
    @TableField(value = "isReimburse")
    private Long isReimburse;

    /** 备注 */
    @Excel(name = "备注")
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

    /** 出差报销信息 */
    private List<TripReimbursement> tripReimbursementList;

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

    public List<TripReimbursement> getTripReimbursementList()
    {
        return tripReimbursementList;
    }

    public void setTripReimbursementList(List<TripReimbursement> tripReimbursementList)
    {
        this.tripReimbursementList = tripReimbursementList;
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
            .append("tripReimbursementList", getTripReimbursementList())
            .toString();
    }
}
