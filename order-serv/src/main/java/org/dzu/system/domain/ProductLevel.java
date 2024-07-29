package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
/**
 * 产品级别对象 productLevel
 * 
 * @author ml
 * @date 2024-07-29
 */
public class ProductLevel extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 级别编码 */
    @Excel(name = "级别编码")
    private String levelNo;

    /** 级别名称 */
    @Excel(name = "级别名称")
    private String levelName;

    /** 分类编号 */
    @Excel(name = "分类编号")
    private Long categoryNo;

    /** 分类名称 */
    @Excel(name = "分类名称")
    private String categoryName;

    /** 厚度 */
    @DecimalMaxDigits
    private Double height;

    /** 长度 */
    @DecimalMaxDigits
    private Double length;

    /** 宽度 */
    @DecimalMaxDigits
    private Double width;

    /** 吨位 */
    @DecimalMaxDigits
    private Double tonnage;

    /** 添加时间 */
    @Excel(name = "添加时间")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    private String UserName;

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
    public void setLevelNo(String levelNo) 
    {
        this.levelNo = levelNo;
    }

    public String getLevelNo() 
    {
        return levelNo;
    }
    public void setLevelName(String levelName) 
    {
        this.levelName = levelName;
    }

    public String getLevelName() 
    {
        return levelName;
    }
    public void setCategoryNo(Long categoryNo) 
    {
        this.categoryNo = categoryNo;
    }

    public Long getCategoryNo() 
    {
        return categoryNo;
    }
    public void setCategoryName(String categoryName) 
    {
        this.categoryName = categoryName;
    }

    public String getCategoryName() 
    {
        return categoryName;
    }
    public void setHeight(Double height) 
    {
        this.height = height;
    }

    public Double getHeight() 
    {
        return height;
    }
    public void setLength(Double length) 
    {
        this.length = length;
    }

    public Double getLength() 
    {
        return length;
    }
    public void setWidth(Double width) 
    {
        this.width = width;
    }

    public Double getWidth() 
    {
        return width;
    }
    public void setTonnage(Double tonnage) 
    {
        this.tonnage = tonnage;
    }

    public Double getTonnage() 
    {
        return tonnage;
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
            .append("levelNo", getLevelNo())
            .append("levelName", getLevelName())
            .append("categoryNo", getCategoryNo())
            .append("categoryName", getCategoryName())
            .append("height", getHeight())
            .append("length", getLength())
            .append("width", getWidth())
            .append("tonnage", getTonnage())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
