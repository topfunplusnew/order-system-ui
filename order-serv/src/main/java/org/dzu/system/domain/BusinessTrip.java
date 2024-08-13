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

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.util.List;
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
    @NotNull(message = "报销人ID不能为空")
    private Long employeeID;

    /** 报销人 */
    @Excel(name = "报销人")
    @TableField(value = "employee")
    @Length(max = 150, message = "报销人的字符长度不允许超过150")
    private String employee;

    /** 部门 */
    @Excel(name = "部门")
    @TableField(value = "deptName")
    @NotNull(message = "部门不能为空")
    @Length(max = 255, message = "部门名称的字符长度不允许超过255")
    private String deptName;

    /** 共同出差人员 */
    @Excel(name = "共同出差人员")
    @TableField(value = "personnel")
    @Length(max = 150, message = "共同出差人员的字符长度不允许超过150")
    private String personnel;

    /** 出差时间 */
    @Excel(name = "出差时间")
    @TableField(value = "starttime")
    @Length(max = 50, message = "出差时间的字符长度不允许超过50")
    private String starttime;

    /** 出差结束时间 */
    @Excel(name = "出差结束时间")
    @TableField(value = "endtime")
    @Length(max = 50, message = "出差结束时间的字符长度不允许超过50")
    private String endtime;

    /** 附件地址 */
    @Excel(name = "附件地址")
    @TableField(value = "attachmentPath")
    @Length(max = 250, message = "附件地址的字符长度不允许超过250")
    private String attachmentPath;

    /** 是否已报销（0未报销，1已报销） */
    @Excel(name = "是否已报销", readConverterExp = "0=未报销,1=已报销")
    @TableField(value = "isReimburse")
    @Max(value = 1, message = "是否已报销只能是0或1")
    @Min(value = 0, message = "是否已报销只能是0或1")
    private Long isReimburse;

    /** 备注 */
    @Excel(name = "备注")
    @TableField(value = "comments")
    @Length(max = 550, message = "备注的字符长度不允许超过550")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间")
    @TableField(value = "addtime")
    @Length(max = 50, message = "添加时间的字符长度不允许超过50")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    @TableField(value = "userId")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    @TableField(value = "UserName")
    @Length(max = 50, message = "操作人员姓名的字符长度不允许超过50")
    private String UserName;

    /** 删除标记 */
    @FlagOnlyZeroOrOne
    @TableField(value = "delFlag")
    private Long delFlag;


    @Excel(name = "审核状态")
    @TableField(value = "checkState")
    private String checkState;


    public String getCheckState() {
        return checkState;
    }

    public void setCheckState(String checkState) {
        this.checkState = checkState;
    }

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

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
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
