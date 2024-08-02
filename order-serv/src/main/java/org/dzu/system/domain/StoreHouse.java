package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 库房对象 StoreHouse
 * 
 * @author ml
 * @date 2024-07-29
 */
public class StoreHouse extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 仓库名称 */
    @Excel(name = "仓库名称")
    @NotNull(message = "仓库名称不能为空")
    @Length(max = 20, message = "仓库名称的字符长度不允许超过20")
    private String storeHouseName;

    /** 地址 */
    @Excel(name = "地址")
    @NotNull(message = "地址不能为空")
    @Length(max = 30, message = "地址的字符长度不允许超过30")
    private String address;

    /** 删除标记 */
    @FlagOnlyZeroOrOne
    private Long delFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setStoreHouseName(String storeHouseName) 
    {
        this.storeHouseName = storeHouseName;
    }

    public String getStoreHouseName() 
    {
        return storeHouseName;
    }
    public void setAddress(String address) 
    {
        this.address = address;
    }

    public String getAddress() 
    {
        return address;
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
            .append("storeHouseName", getStoreHouseName())
            .append("address", getAddress())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
