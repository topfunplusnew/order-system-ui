package org.dzu.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
/**
 * 审核流程对象 auditInfo
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("auditInfo")
public class AuditInfo extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    @TableId(value = "id")
    private Long id;

    /** 流程名称 */
    @Excel(name = "流程名称")
    @TableField(value = "flowname")
    private String flowname;

    /** 对应的表主键 */
    @Excel(name = "对应的表主键")
    @TableField(value = "applyID")
    private Long applyID;

    /** 审核总共步骤 */
    @Excel(name = "审核总共步骤")
    @TableField(value = "stepnum")
    private Long stepnum;

    /** 步骤序号 */
    @Excel(name = "步骤序号")
    @TableField(value = "step")
    private Long step;

    /** 允许的审核人员ID（多个人员用逗号分隔） */
    @Excel(name = "允许的审核人员ID", readConverterExp = "多=个人员用逗号分隔")
    @TableField(value = "auditauthority")
    private String auditauthority;

    /** 审核时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "审核时间", width = 30, dateFormat = "yyyy-MM-dd")
    @TableField(value = "auditdate")
    private Date auditdate;

    /** 审核人员ID */
    @Excel(name = "审核人员ID")
    @TableField(value = "userId")
    private Long userId;

    /** 审核人员姓名 */
    @Excel(name = "审核人员姓名")
    @TableField(value = "UserName")
    private String UserName;

    /** 审核状态（审核中、通过、未通过） */
    @Excel(name = "审核状态", readConverterExp = "审=核中、通过、未通过")
    @TableField(value = "checkState")
    private String checkState;

    /** 审核意见 */
    @Excel(name = "审核意见")
    @TableField(value = "auditcomment")
    private String auditcomment;

    /** 提交标记 */
    @Excel(name = "提交标记")
    @TableField(value = "submitflag")
    private Long submitflag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setFlowname(String flowname) 
    {
        this.flowname = flowname;
    }

    public String getFlowname() 
    {
        return flowname;
    }
    public void setApplyID(Long applyID) 
    {
        this.applyID = applyID;
    }

    public Long getApplyID() 
    {
        return applyID;
    }
    public void setStepnum(Long stepnum) 
    {
        this.stepnum = stepnum;
    }

    public Long getStepnum() 
    {
        return stepnum;
    }
    public void setStep(Long step) 
    {
        this.step = step;
    }

    public Long getStep() 
    {
        return step;
    }
    public void setAuditauthority(String auditauthority) 
    {
        this.auditauthority = auditauthority;
    }

    public String getAuditauthority() 
    {
        return auditauthority;
    }
    public void setAuditdate(Date auditdate) 
    {
        this.auditdate = auditdate;
    }

    public Date getAuditdate() 
    {
        return auditdate;
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
    public void setCheckState(String checkState) 
    {
        this.checkState = checkState;
    }

    public String getCheckState() 
    {
        return checkState;
    }
    public void setAuditcomment(String auditcomment) 
    {
        this.auditcomment = auditcomment;
    }

    public String getAuditcomment() 
    {
        return auditcomment;
    }
    public void setSubmitflag(Long submitflag) 
    {
        this.submitflag = submitflag;
    }

    public Long getSubmitflag() 
    {
        return submitflag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("flowname", getFlowname())
            .append("applyID", getApplyID())
            .append("stepnum", getStepnum())
            .append("step", getStep())
            .append("auditauthority", getAuditauthority())
            .append("auditdate", getAuditdate())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("checkState", getCheckState())
            .append("auditcomment", getAuditcomment())
            .append("submitflag", getSubmitflag())
            .toString();
    }
}
