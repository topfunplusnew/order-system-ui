package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.OnlyZeroOrOne;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.NotNull;

/**
 * 产品级别对象 productLevel
 *
 * @author ml
 * @date 2024-07-29
 */
@TableName("productLevel")
public class ProductLevel extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * id
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 级别编码
     */
    @Excel(name = "级别编码")
    @TableField("levelNo")
    @NotNull(message = "级别编码不能为空")
    @Length(max = 20, message = "级别编码的字符长度不允许超过20")
    private String levelNo;

    /**
     * 级别名称
     */
    @Excel(name = "级别名称")
    @TableField("levelName")
    @NotNull(message = "级别名称不能为空")
    @Length(max = 80, message = "级别名称的字符长度不允许超过80")
    private String levelName;

    /**
     * 分类编号
     */
    @Excel(name = "分类编号")
    @TableField("categoryNo")
    @Length(max = 20, message = "分类编号的字符长度不允许超过20")
    @NotNull(message = "分类编号不能为空")
    private Long categoryNo;

    /**
     * 分类名称
     */
    @Excel(name = "分类名称")
    @TableField("categoryName")
    @NotNull(message = "分类名称不能为空")
    @Length(max = 80, message = "分类名称的字符长度不允许超过80")
    private String categoryName;

    /**
     * 厚度
     */
    @Excel(name = "厚度")
    @TableField("height")
    @NotNull(message = "厚度不能为空")
    @DecimalMin(value = "0.0", message = "厚度不能小于0")
    private Double height;

    /**
     * 长度
     */
    @NotNull(message = "长度不能为空")
    @TableField("length")
    @DecimalMin(value = "0.0", message = "长度不能小于0")
    @Excel(name = "长度")
    private Double length;

    /**
     * 宽度
     */
    @NotNull(message = "宽度不能为空")
    @TableField("width")
    @DecimalMin(value = "0.0", message = "宽度不能小于0")
    @Excel(name = "宽度")
    private Double width;

    /**
     * 吨位
     */
    @NotNull(message = "吨位不能为空")
    @TableField("tonnage")
    @DecimalMin(value = "0.0", message = "吨位不能小于0")
    @Excel(name = "吨位")
    private Double tonnage;
    /**
     * 添加时间
     */
    @Excel(name = "添加时间")
    @TableField("addtime")
    private String addtime;

    /**
     * 操作人员ID
     */
    @Excel(name = "操作人员ID")
    @TableField("userId")
    private Long userId;

    /**
     * 操作人员姓名
     */
    @Excel(name = "操作人员姓名")
    @TableField("userName")
    private String UserName;

    /**
     * 删除标记
     */
    @OnlyZeroOrOne
    @TableField("delFlag")
    private Long delFlag;

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setLevelNo(String levelNo) {
        this.levelNo = levelNo;
    }

    public String getLevelNo() {
        return levelNo;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setCategoryNo(Long categoryNo) {
        this.categoryNo = categoryNo;
    }

    public Long getCategoryNo() {
        return categoryNo;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setHeight(Double height) {
        this.height = height;
    }

    public Double getHeight() {
        return height;
    }

    public void setLength(Double length) {
        this.length = length;
    }

    public Double getLength() {
        return length;
    }

    public void setWidth(Double width) {
        this.width = width;
    }

    public Double getWidth() {
        return width;
    }

    public void setTonnage(Double tonnage) {
        this.tonnage = tonnage;
    }

    public Double getTonnage() {
        return tonnage;
    }

    public void setAddtime(String addtime) {
        this.addtime = addtime;
    }

    public String getAddtime() {
        return addtime;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserName(String UserName) {
        this.UserName = UserName;
    }

    public String getUserName() {
        return UserName;
    }

    public void setDelFlag(Long delFlag) {
        this.delFlag = delFlag;
    }

    public Long getDelFlag() {
        return delFlag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
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
