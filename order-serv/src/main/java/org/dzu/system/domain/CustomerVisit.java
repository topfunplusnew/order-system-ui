package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 走访记录对象 CustomerVisit
 * 
 * @author ml
 * @date 2024-08-01
 */
@TableName("CustomerVisit")
public class CustomerVisit extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 省 */
    @Excel(name = "省")
    @TableField(value = "province")
    @Length(max = 10, message = "省长度不能超过10个字符")
    private String province;

    /** 市县 */
    @Excel(name = "市县")
    @TableField(value = "city")
    @Length(max = 10, message = "市县长度不能超过10个字符")
    private String city;

    /** 乡镇（街道） */
    @Excel(name = "乡镇", readConverterExp = "街道")
    @TableField(value = "county")
    @Length(max = 10, message = "乡镇（街道）长度不能超过10个字符")
    private String county;

    /** 客户 */
    @Excel(name = "客户")
    @Length(max = 20, message = "客户长度不能超过20个字符")
    @NotNull(message = "客户不能为空")
    @TableField(value = "customer")
    private String customer;

    /** 负责人 */
    @Excel(name = "负责人")
    @Length(max = 20, message = "负责人长度不能超过20个字符")
    @TableField(value = "leaderName")
    private String leaderName;

    /** 负责人电话 */
    @Excel(name = "负责人电话")
    @TableField(value = "LeaderTel")
    private String LeaderTel;

    /** 厂房设备 */
    @Excel(name = "厂房设备")
    @TableField(value = "equipment")
    private String equipment;

    /** 竞争对手 */
    @Excel(name = "竞争对手")
    @TableField(value = "competitor")
    private String competitor;

    /** 当地经销商 */
    @Excel(name = "当地经销商")
    @TableField(value = "localDealer")
    private String localDealer;

    /** 月用货量（车数） */
    @Excel(name = "月用货量", readConverterExp = "车数")
    @TableField(value = "monthlyConsumption")
    private String monthlyConsumption;

    /** 白玻用货习惯及厂家 */
    @Excel(name = "白玻用货习惯及厂家")
    @Length(max = 50, message = "白玻用货习惯及厂家长度不能超过50个字符")
    @TableField(value = "whiteGlassFactory")
    private String whiteGlassFactory;

    /** lowe玻璃用货厂家及用量 */
    @Excel(name = "lowe玻璃用货厂家及用量")
    @Length(max = 500, message = "lowe玻璃用货厂家及用量长度不能超过500个字符")
    @TableField(value = "loweGlassConsumption")
    private String loweGlassConsumption;

    /** 色玻、过度色玻璃用货厂家及用量 */
    @Excel(name = "色玻、过度色玻璃用货厂家及用量")
    @Length(max = 500, message = "色��、过度色����用货厂家及用量长度不能超过500个字符")
    @TableField(value = "colorGlassConsumption")
    private String colorGlassConsumption;

    /** 特色厚度、特殊尺寸、协议品用货厂家及用量 */
    @Excel(name = "特色厚度、特殊尺寸、协议品用货厂家及用量")
    @Length(max = 500, message = "特色厚度、特殊尺寸、协议品用货厂家及用量长度不能超过500个字符")
    @TableField(value = "specialGlassConsumption")
    private String specialGlassConsumption;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 500, message = "备注长度不能超过500个字符")
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

    /** 走访日期 */
    @Excel(name = "走访日期")
    @TableField(value = "visitDate")
    private String visitDate;

    /** 审核标志 */
    @Excel(name = "审核标志")
    @TableField(value = "checkState")
    private Long checkState;

    /** 审核人ID */
    @Excel(name = "审核人ID")
    @TableField(value = "checkUserID")
    private Long checkUserID;

    /** 审核人 */
    @Excel(name = "审核人")
    @TableField(value = "checkUserName")
    private String checkUserName;

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
    public void setProvince(String province) 
    {
        this.province = province;
    }

    public String getProvince() 
    {
        return province;
    }
    public void setCity(String city) 
    {
        this.city = city;
    }

    public String getCity() 
    {
        return city;
    }
    public void setCounty(String county) 
    {
        this.county = county;
    }

    public String getCounty() 
    {
        return county;
    }
    public void setCustomer(String customer) 
    {
        this.customer = customer;
    }

    public String getCustomer() 
    {
        return customer;
    }
    public void setLeaderName(String leaderName) 
    {
        this.leaderName = leaderName;
    }

    public String getLeaderName() 
    {
        return leaderName;
    }
    public void setLeaderTel(String LeaderTel) 
    {
        this.LeaderTel = LeaderTel;
    }

    public String getLeaderTel() 
    {
        return LeaderTel;
    }
    public void setEquipment(String equipment) 
    {
        this.equipment = equipment;
    }

    public String getEquipment() 
    {
        return equipment;
    }
    public void setCompetitor(String competitor) 
    {
        this.competitor = competitor;
    }

    public String getCompetitor() 
    {
        return competitor;
    }
    public void setLocalDealer(String localDealer) 
    {
        this.localDealer = localDealer;
    }

    public String getLocalDealer() 
    {
        return localDealer;
    }
    public void setMonthlyConsumption(String monthlyConsumption) 
    {
        this.monthlyConsumption = monthlyConsumption;
    }

    public String getMonthlyConsumption() 
    {
        return monthlyConsumption;
    }
    public void setWhiteGlassFactory(String whiteGlassFactory) 
    {
        this.whiteGlassFactory = whiteGlassFactory;
    }

    public String getWhiteGlassFactory() 
    {
        return whiteGlassFactory;
    }
    public void setLoweGlassConsumption(String loweGlassConsumption) 
    {
        this.loweGlassConsumption = loweGlassConsumption;
    }

    public String getLoweGlassConsumption() 
    {
        return loweGlassConsumption;
    }
    public void setColorGlassConsumption(String colorGlassConsumption) 
    {
        this.colorGlassConsumption = colorGlassConsumption;
    }

    public String getColorGlassConsumption() 
    {
        return colorGlassConsumption;
    }
    public void setSpecialGlassConsumption(String specialGlassConsumption) 
    {
        this.specialGlassConsumption = specialGlassConsumption;
    }

    public String getSpecialGlassConsumption() 
    {
        return specialGlassConsumption;
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
    public void setVisitDate(String visitDate) 
    {
        this.visitDate = visitDate;
    }

    public String getVisitDate() 
    {
        return visitDate;
    }
    public void setCheckState(Long checkState) 
    {
        this.checkState = checkState;
    }

    public Long getCheckState() 
    {
        return checkState;
    }
    public void setCheckUserID(Long checkUserID) 
    {
        this.checkUserID = checkUserID;
    }

    public Long getCheckUserID() 
    {
        return checkUserID;
    }
    public void setCheckUserName(String checkUserName) 
    {
        this.checkUserName = checkUserName;
    }

    public String getCheckUserName() 
    {
        return checkUserName;
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
            .append("province", getProvince())
            .append("city", getCity())
            .append("county", getCounty())
            .append("customer", getCustomer())
            .append("leaderName", getLeaderName())
            .append("LeaderTel", getLeaderTel())
            .append("equipment", getEquipment())
            .append("competitor", getCompetitor())
            .append("localDealer", getLocalDealer())
            .append("monthlyConsumption", getMonthlyConsumption())
            .append("whiteGlassFactory", getWhiteGlassFactory())
            .append("loweGlassConsumption", getLoweGlassConsumption())
            .append("colorGlassConsumption", getColorGlassConsumption())
            .append("specialGlassConsumption", getSpecialGlassConsumption())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("visitDate", getVisitDate())
            .append("checkState", getCheckState())
            .append("checkUserID", getCheckUserID())
            .append("checkUserName", getCheckUserName())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
