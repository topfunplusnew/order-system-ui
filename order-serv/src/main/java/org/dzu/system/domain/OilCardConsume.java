package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 加油卡消费信息对象 OilCardConsume
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("OilCardConsume")
public class OilCardConsume extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 出差编号UUID */
    @Excel(name = "出差编号UUID")
    @Length(max = 50, message = "出差编号UUID长度不能超过 50 个字符")
    @NotNull(message = "出差编号UUID不能为空")
    @TableField(value = "bTripId")
    private String bTripId;

    /** 加油卡卡号 */
    @Excel(name = "加油卡卡号")
    @Length(max = 55, message = "加油卡卡号长度不能超过 55 个字符")
    @NotNull(message = "加油卡卡号不能为空")
    @TableField(value = "oilCardNo")
    private String oilCardNo;

    /** 使用加油卡时间 */
    @Excel(name = "使用加油卡时间")
    @Length(max = 50, message = "使用加油卡时间长度不能超过 50 个字符")
    @NotNull(message = "使用加油卡时间不能为空")
    @TableField(value = "useDate")
    private String useDate;

    /** 使用加油卡车辆车牌号 */
    @Excel(name = "使用加油卡车辆车牌号")
    @Length(max = 55, message = "使用加油卡车辆车牌号长度不能超过 55 个字符")
    @NotNull(message = "使用加油卡车辆车牌号不能为空")
    @TableField(value = "carNo")
    private String carNo;

    /** 期初余额 */
    @Excel(name = "期初余额")
    @Length(max = 55, message = "期初余额长度不能超过 55 个字符")
    @TableField(value = "startCardSurplus")
    private String startCardSurplus;

    /** 加油量（升） */
    @Excel(name = "加油量", readConverterExp = "升")
    @Length(max = 255, message = "加油量长度不能超过 255 个字符")
    @TableField(value = "refuelingNumber")
    private String refuelingNumber;

    /** 单价 */
    @Excel(name = "单价")
    @Length(max = 255, message = "单价长度不能超过 255 个字符")
    @TableField(value = "unitPrice")
    private String unitPrice;

    /** 加油金额(元） */
    @Excel(name = "加油金额(元）")
    @Length(max = 255, message = "加油金额(元）长度不能超过 255 个字符")
    @TableField(value = "refuelingMoney")
    private String refuelingMoney;

    /** 充值金额(元） */
    @Excel(name = "充值金额(元）")
    @Length(max = 255, message = "充值金额(元）长度不能超过 255 个字符")
    @TableField(value = "rechargeMoney")
    private String rechargeMoney;

    /** 加油卡余额 */
    @Excel(name = "加油卡余额")
    @Length(max = 255, message = "加油卡余额长度不能超过 255 个字符")
    @TableField(value = "endCardSurplus")
    private String endCardSurplus;

    /** 加油小票附件 */
    @Excel(name = "加油小票附件")
    @Length(max = 300, message = "加油小票附件长度不能超过 300 个字符")
    @TableField(value = "attachmentOiladd")
    private String attachmentOiladd;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注长度不能超过 200 个字符")
    @TableField(value = "comments")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间")
    @TableField(value = "addtime")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    @TableField(value = "userId")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    @TableField(value = "UserName")
    private String UserName;

    /** 删除标记 */
    @FlagOnlyZeroOrOne
    @TableField(value = "delFlag")
    private Long delFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setbTripId(String bTripId) 
    {
        this.bTripId = bTripId;
    }

    public String getbTripId() 
    {
        return bTripId;
    }
    public void setOilCardNo(String oilCardNo) 
    {
        this.oilCardNo = oilCardNo;
    }

    public String getOilCardNo() 
    {
        return oilCardNo;
    }
    public void setUseDate(String useDate) 
    {
        this.useDate = useDate;
    }

    public String getUseDate() 
    {
        return useDate;
    }
    public void setCarNo(String carNo) 
    {
        this.carNo = carNo;
    }

    public String getCarNo() 
    {
        return carNo;
    }
    public void setStartCardSurplus(String startCardSurplus) 
    {
        this.startCardSurplus = startCardSurplus;
    }

    public String getStartCardSurplus() 
    {
        return startCardSurplus;
    }
    public void setRefuelingNumber(String refuelingNumber) 
    {
        this.refuelingNumber = refuelingNumber;
    }

    public String getRefuelingNumber() 
    {
        return refuelingNumber;
    }
    public void setUnitPrice(String unitPrice) 
    {
        this.unitPrice = unitPrice;
    }

    public String getUnitPrice() 
    {
        return unitPrice;
    }
    public void setRefuelingMoney(String refuelingMoney) 
    {
        this.refuelingMoney = refuelingMoney;
    }

    public String getRefuelingMoney() 
    {
        return refuelingMoney;
    }
    public void setRechargeMoney(String rechargeMoney) 
    {
        this.rechargeMoney = rechargeMoney;
    }

    public String getRechargeMoney() 
    {
        return rechargeMoney;
    }
    public void setEndCardSurplus(String endCardSurplus)
    {
        this.endCardSurplus = endCardSurplus;
    }

    public String getEndCardSurplus()
    {
        return endCardSurplus;
    }
    public void setAttachmentOiladd(String attachmentOiladd) 
    {
        this.attachmentOiladd = attachmentOiladd;
    }

    public String getAttachmentOiladd() 
    {
        return attachmentOiladd;
    }
    public void setComments(String comments) 
    {
        this.comments = comments;
    }

    public String getComments() 
    {
        return comments;
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
            .append("bTripId", getbTripId())
            .append("oilCardNo", getOilCardNo())
            .append("useDate", getUseDate())
            .append("carNo", getCarNo())
            .append("startCardSurplus", getStartCardSurplus())
            .append("refuelingNumber", getRefuelingNumber())
            .append("unitPrice", getUnitPrice())
            .append("refuelingMoney", getRefuelingMoney())
            .append("rechargeMoney", getRechargeMoney())
            .append("endCardSurplus", getEndCardSurplus())
            .append("attachmentOiladd", getAttachmentOiladd())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
