package org.dzu.system.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.TreeEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.util.Date;

/**
 * 科目对象 subject
 * 
 * @author ml
 * @date 2024-08-02
 */
@TableName("subject")
public class Subject extends TreeEntity
{
    private static final long serialVersionUID = 1L;


    /** 科目ID */
    @TableId(value = "id")
    private Long id;

    /** 科目名称 */
    @Excel(name = "科目名称")
    @NotNull(message = "科目名称不能为空")
    @Length(max = 50, message = "科目名称长度不能超过50个字符")
    @TableField(value = "title")
    private String title;

    /** 科目类别（收入、支出、其他） */
    @Excel(name = "科目类别", readConverterExp = "收=入、支出、其他")
    @Pattern(regexp = "收入|支出|其他", message = "科目类别只能是'收入'、'支出'或'其他'")
    @TableField(value = "type")
    private String type;

    /** 编号 */
    @Excel(name = "编号")
    @Length(max = 50, message = "编号长度不能超过50个字符")
    @TableField(value = "subjectNo")
    private String subjectNo;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    @Pattern(regexp = "0|1", message = "状态只能是'0'（正常）或'1'（停用）")
    @TableField(value = "STATUS")
    private String STATUS;

    /** 父级ID */
    @TableField(value = "parent_id")
    private Long parentId;

    /** 显示顺序 */
    @TableField(value = "order_num")
    private Integer orderNum;

    /** 创建者 */
    @TableField(value = "create_by")
    @Length(max = 64, message = "创建者长度不能超过64个字符")
    private String createBy;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @TableField(value = "create_time")
    private Date createTime;

    /** 更新者 */
    @TableField(value = "update_by")
    @Length(max = 64, message = "更新者长度不能超过64个字符")
    private String updateBy;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @TableField(value = "update_time")
    private Date updateTime;

    /** 备注 */
    @TableField(value = "remark")
    @Length(max = 500, message = "备注长度不能超过500个字符")
    private String remark;
    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setTitle(String title) 
    {
        this.title = title;
    }

    public String getTitle() 
    {
        return title;
    }
    public void setType(String type) 
    {
        this.type = type;
    }

    public String getType() 
    {
        return type;
    }
    public void setSubjectNo(String subjectNo) 
    {
        this.subjectNo = subjectNo;
    }

    public String getSubjectNo() 
    {
        return subjectNo;
    }
    public void setSTATUS(String STATUS) 
    {
        this.STATUS = STATUS;
    }

    public String getSTATUS() 
    {
        return STATUS;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("title", getTitle())
            .append("type", getType())
            .append("subjectNo", getSubjectNo())
            .append("parentId", getParentId())
            .append("orderNum", getOrderNum())
            .append("STATUS", getSTATUS())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
