package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.OnlyZeroOrOne;
import org.dzu.common.core.domain.BaseEntity;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

/**
 * 产品级别管理对象 productlevel
 * 
 * @author ml
 * @date 2024-07-19
 */
public class Productlevel extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 级别编码 */
    @Excel(name = "级别编码")
    @NotNull(message = "级别编码是必须的")
    private String levelNo;

    /** 级别名称 */
    @Excel(name = "级别名称")
    @NotNull(message = "级别名称是必须的")
    private String levelName;

    /** 分类编号 */
    @Excel(name = "分类编号")
    @NotNull(message = "分类编号是必须的")
    private Long categoryNo;

    /** 分类名称 */
    @Excel(name = "分类名称")
    @NotNull(message = "分类名称是必须的")
    private String categoryName;

    /** 厚度 */
    @Excel(name = "厚度")
    @NotNull(message = "厚度信息是必须的")
    private Long height;

    /** 长度 */
    @Excel(name = "长度")
    @NotNull(message = "长度信息是必须的")
    private Long length;

    /** 宽度 */
    @Excel(name = "宽度")
    @NotNull(message = "宽度位信息是必须的")
    private Long width;

    /** 吨位 */
    @Excel(name = "吨位")
    @NotNull(message = "吨位信息是必须的")
    private Long tonnage;

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
    @Excel(name = "删除标记")
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
    public void setHeight(Long height) 
    {
        this.height = height;
    }

    public Long getHeight() 
    {
        return height;
    }
    public void setLength(Long length) 
    {
        this.length = length;
    }

    public Long getLength() 
    {
        return length;
    }
    public void setWidth(Long width) 
    {
        this.width = width;
    }

    public Long getWidth() 
    {
        return width;
    }
    public void setTonnage(Long tonnage) 
    {
        this.tonnage = tonnage;
    }

    public Long getTonnage() 
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
