package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 汽车信息对象 cars
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public class Cars extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 车牌 */
    @Excel(name = "车牌")
    private String carNo;

    /** 司机 */
    @Excel(name = "司机")
    private String driver;

    /** 司机电话 */
    @Excel(name = "司机电话")
    private String tel;

    /** 开户行 */
    @Excel(name = "开户行")
    private String bankName;

    /** 开户名 */
    @Excel(name = "开户名")
    private String acountsName;

    /** 账号 */
    @Excel(name = "账号")
    private String bankNo;

    /** 账号类型（1收款，2付款） */
    @Excel(name = "账号类型", readConverterExp = "1=收款，2付款")
    private Long acountsType;

    /** 运输类型(陆运，海运) */
    @Excel(name = "运输类型(陆运，海运)")
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
