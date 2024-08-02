package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.hibernate.validator.constraints.Length;

/**
 * 审核流程对象 auditflow
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("auditflow")
public class Auditflow
{
    private static final long serialVersionUID = 1L;


    @TableId(value = "id")
    private Long id;

    /** 流程名称 */
    @Excel(name = "流程名称")
    @TableField(value = "flowname")
    @Length(max = 50,message = "流程名称长度不能超过50个字符")
    private String flowname;

    /** 审核步骤 */
    @Excel(name = "审核步骤")
    @TableField(value = "stepnum")
    private Long stepnum;

    /** 步骤序号 */
    @Excel(name = "步骤序号")
    @TableField(value = "step")
    private Long step;

    /** 允许的审核人员ID */
    @Excel(name = "允许的审核人员ID")
    @TableField(value = "auditauthority")
    @Length(max = 500,message = "请减少审核人员")
    private String auditauthority;

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

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("flowname", getFlowname())
            .append("stepnum", getStepnum())
            .append("step", getStep())
            .append("auditauthority", getAuditauthority())
            .toString();
    }
}
