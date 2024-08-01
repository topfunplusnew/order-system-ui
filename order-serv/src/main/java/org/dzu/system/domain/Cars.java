package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.PhoneLength;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.OnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 外部车辆信息对象 cars
 * 
 * @author ml
 * @date 2024-07-29
 */
@TableName("cars")
public class Cars extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;


    /** 车牌 */
    @Excel(name = "车牌")
    @Length(max = 20, message = "车牌的字符长度不允许超过20")
    @NotNull(message = "车牌不能为空")
    @TableField("carNo")
    private String carNo;

    /** 司机 */
    @Excel(name = "司机")
    @Length(max = 20, message = "司机的字符长度不允许超过20")
    @TableField("driver")
    @NotNull(message = "司机不能为空")
    private String driver;

    /** 司机电话 */
    @Excel(name = "司机电话")
    @PhoneLength
    @TableField("tel")
    @NotNull(message = "司机电话不能为空")
    private String tel;

    /** 开户行 */
    @Excel(name = "开户行")
    @TableField("bankName")
    @Length(max = 50, message = "开户行的字符长度不允许超过50")
    private String bankName;

    /** 开户名 */
    @Excel(name = "开户名")
    @Length(max = 50, message = "开户名的字符长度不允许超过50")
    @TableField("acountsName")
    private String acountsName;

    /** 账号 */
    @Excel(name = "账号")
    @Length(max = 50, message = "账号的字符长度不允许超过50")
    @TableField("bankNo")
    private String bankNo;

    /** 账号类型（1收款，2付款） */
    @Excel(name = "账号类型")
    @NotNull(message = "账号类型不能为空")
    @Min(value = 1, message = "账号类型的值不允许小于1")
    @Max(value = 2, message = "账号类型的值不允许大于2")
    @TableField("acountsType")
    private Long acountsType;

    /** 运输类型(陆运，海运) */
    @Excel(name = "运输类型(陆运，海运)")
    @Pattern(regexp = "陆运|海运", message = "运输类型必须是：陆运或海运")
    @NotNull(message = "运输类型不能为空")
    @TableField("carType")
    private String carType;

    /** 添加时间 */
    @Excel(name = "添加时间")
    @TableField("addtime")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    @TableField("userId")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    @TableField("UserName")
    private String UserName;

    /** 删除标记 */
    @OnlyZeroOrOne
    @TableField("delFlag")
    private Long delFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setCarNo(String carNo) 
    {
        this.carNo = carNo;
    }

    public String getCarNo() 
    {
        return carNo;
    }
    public void setDriver(String driver) 
    {
        this.driver = driver;
    }

    public String getDriver() 
    {
        return driver;
    }
    public void setTel(String tel) 
    {
        this.tel = tel;
    }

    public String getTel() 
    {
        return tel;
    }
    public void setBankName(String bankName) 
    {
        this.bankName = bankName;
    }

    public String getBankName() 
    {
        return bankName;
    }
    public void setAcountsName(String acountsName) 
    {
        this.acountsName = acountsName;
    }

    public String getAcountsName() 
    {
        return acountsName;
    }
    public void setBankNo(String bankNo) 
    {
        this.bankNo = bankNo;
    }

    public String getBankNo() 
    {
        return bankNo;
    }
    public void setAcountsType(Long acountsType) 
    {
        this.acountsType = acountsType;
    }

    public Long getAcountsType() 
    {
        return acountsType;
    }
    public void setCarType(String carType) 
    {
        this.carType = carType;
    }

    public String getCarType() 
    {
        return carType;
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
            .append("carNo", getCarNo())
            .append("driver", getDriver())
            .append("tel", getTel())
            .append("bankName", getBankName())
            .append("acountsName", getAcountsName())
            .append("bankNo", getBankNo())
            .append("acountsType", getAcountsType())
            .append("carType", getCarType())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
