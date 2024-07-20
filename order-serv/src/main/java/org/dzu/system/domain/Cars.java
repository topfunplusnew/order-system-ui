package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.PhoneLength;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 车辆管理对象 cars
 * 
 * @author ml
 * @date 2024-07-19
 */
public class Cars extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 车牌 */
    @Excel(name = "车牌")
    @Length(max = 20, message = "车牌不能超过20个字符")
    private String carNo;

    /** 司机 */
    @Excel(name = "司机")
    @Length(max = 20, message = "司机姓名不能超过20个字符")
    private String driver;

    /** 司机电话 */
    @Excel(name = "司机电话")
    @PhoneLength
    private String tel;


    /** 开户行 */
    @Excel(name = "开户行")
    @Length(max = 50, message = "开户行不能超过50个字符")
    private String bankName;

    /** 开户名 */
    @Excel(name = "开户名")
    @Length(max = 50, message = "开户名不能超过50个字符")
    private String acountsName;

    /** 账号 */
    @Excel(name = "账号")
    @Length(max = 50, message = "账号不能超过50个字符")
    private String bankNo;

    /** 账号类型（1收款，2付款） */
    @Excel(name = "账号类型")
    @Min(value = 1,message = "账户类型只能为1或2")
    @Max(value = 1,message = "账户类型只能为1或2")
    private Long acountsType;

    /** 运输类型(陆运，海运) */
    @Excel(name = "运输类型(陆运，海运)")
    @Pattern(regexp = "海运|陆运",message = "运输类型只能为海运或者陆运")
    private String carType;

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
