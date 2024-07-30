package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.PhoneLength;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.OnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 车队对象 fleet
 * 
 * @author ml
 * @date 2024-07-29
 */
public class Fleet extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 车队名称 */
    @Excel(name = "车队名称")
    @Length(max = 20, message = "车队名称的字符长度不允许超过20")
    @NotNull(message = "车队名称不能为空")
    private String fName;

    /** 车队经理 */
    @Excel(name = "车队经理")
    @Length(max = 20, message = "车队经理的字符长度不允许超过20")
    @NotNull(message = "车队经理不能为空")
    private String fLeader;

    /** 车队经理电话 */
    @Excel(name = "车队经理电话")
    @PhoneLength(message = "车队经理电话的字符长度不允许超过15")
    private String tel;

    /** 地址 */
    @Excel(name = "地址")
    @Length(max = 30, message = "地址的字符长度不允许超过30")
    @NotNull(message = "地址不能为空")
    private String address;

    /** 添加时间 */
    @Excel(name = "添加时间")
    private String addtime;

    /** 编辑时间 */
    @Excel(name = "编辑时间")
    private String editTime;

    /** 删除标记 */
    @OnlyZeroOrOne
    private Long delFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setfName(String fName) 
    {
        this.fName = fName;
    }

    public String getfName() 
    {
        return fName;
    }
    public void setfLeader(String fLeader) 
    {
        this.fLeader = fLeader;
    }

    public String getfLeader() 
    {
        return fLeader;
    }
    public void setTel(String tel) 
    {
        this.tel = tel;
    }

    public String getTel() 
    {
        return tel;
    }
    public void setAddress(String address) 
    {
        this.address = address;
    }

    public String getAddress() 
    {
        return address;
    }
    public void setAddtime(String addtime) 
    {
        this.addtime = addtime;
    }

    public String getAddtime() 
    {
        return addtime;
    }
    public void setEditTime(String editTime) 
    {
        this.editTime = editTime;
    }

    public String getEditTime() 
    {
        return editTime;
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
            .append("fName", getfName())
            .append("fLeader", getfLeader())
            .append("tel", getTel())
            .append("address", getAddress())
            .append("addtime", getAddtime())
            .append("editTime", getEditTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
