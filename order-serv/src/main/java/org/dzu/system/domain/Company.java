package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.dzu.common.annotation.PhoneLength;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 客户、供应商信息对象 company
 * 
 * @author ml
 * @date 2024-07-29
 */
@TableName("company")
public class Company extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id")
    private Long id;

    /** 公司 */
    @Excel(name = "公司")
    @Length(max = 550, message = "公司名称的字符长度不允许超过550")
    @NotNull(message = "公司名称不能为空")
    @TableField(value = "companyName")
    private String companyName;

    /** 联系人 */
    @Excel(name = "联系人")
    @TableField(value = "relationName")
    @Length(max = 50, message = "联系人的字符长度不允许超过50")
    @NotNull(message = "联系人不能为空")
    private String relationName;

    /** 联系人电话 */
    @Excel(name = "联系人电话")
    @PhoneLength
    @TableField(value = "relationTel")
    @NotNull(message = "联系人电话不能为空")
    private String relationTel;

    /** 地址 */
    @Excel(name = "地址")
    @TableField(value = "address")
    @Length(max = 250, message = "地址的字符长度不允许超过250")
    @NotNull(message = "地址不能为空")
    private String address;

    /** 开户行 */
    @Excel(name = "开户行")
    @Length(max = 50, message = "开户行的字符长度不允许超过50")
    @TableField(value = "bankName")
    @NotNull(message = "开户行不能为空")
    private String bankName;

    /** 开户名 */
    @Excel(name = "开户名")
    @Length(max = 50, message = "开户名的字符长度不允许超过50")
    @NotNull(message = "开户名不能为空")
    @TableField(value = "acountsName")
    private String acountsName;

    /** 账号 */
    @Excel(name = "账号")
    @Length(max = 50, message = "账号的字符长度不允许超过50")
    @NotNull(message = "账号不能为空")
    @TableField(value = "bankNo")
    private String bankNo;

    /** 余额 */
    @DecimalMaxDigits
    @TableField(value = "surplusMoney")
    private Double surplusMoney;

    /** 客户类别（客户，供应商） */
    @Excel(name = "客户类别")
    @Pattern(regexp = "客户|供应商",message = "类别只能为字符串\"客户\"或者\"供应商\"")
    @Length(max = 20, message = "客户类别的字符长度不允许超过20")
    @NotNull(message = "客户类别不能为空")
    @TableField(value = "companyType")
    private String companyType;

    /** 业务员 */
    @Excel(name = "业务员")
    @NotNull(message = "业务员不能为空")
    @Length(max = 55, message = "业务员的字符长度不允许超过55")
    @TableField(value = "salesman")
    private String salesman;

    /** 老板 */
    @Excel(name = "老板")
    @NotNull(message = "老板不能为空")
    @Length(max = 50, message = "老板的字符长度不允许超过50")
    @TableField(value = "leader")
    private String leader;

    /** 联系人电话 */
    @Excel(name = "联系人电话")
    @PhoneLength
    @TableField(value = "leaderTel")
    private String leaderTel;

    /** 区域（省+市县+乡镇） */
    @Excel(name = "区域")
    @Length(max = 280, message = "区域的字符长度不允许超过280")
    @TableField(value = "region")
    private String region;

    /** 销售经理 */
    @Excel(name = "销售经理")
    @Length(max = 55, message = "销售经理的字符长度不允许超过55")
    @TableField(value = "salesManager")
    private String salesManager;

    /** 省 */
    @Excel(name = "省")
    @TableField(value = "province")
    @Length(max = 55, message = "省的字符长度不允许超过55")
    private String province;

    /** 市县 */
    @Excel(name = "市县")
    @TableField(value = "city")
    @Length(max = 155, message = "市县的字符长度不允许超过155")
    private String city;

    /** 乡镇 */
    @Excel(name = "乡镇")
    @TableField(value = "county")
    @Length(max = 155, message = "乡镇的字符长度不允许超过155")
    private String county;

    /** 备注 */
    @Excel(name = "备注")
    @TableField(value = "comments")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
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
    @TableField(value = "userName")
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
    public void setCompanyName(String companyName) 
    {
        this.companyName = companyName;
    }

    public String getCompanyName() 
    {
        return companyName;
    }
    public void setRelationName(String relationName) 
    {
        this.relationName = relationName;
    }

    public String getRelationName() 
    {
        return relationName;
    }
    public void setRelationTel(String relationTel) 
    {
        this.relationTel = relationTel;
    }

    public String getRelationTel() 
    {
        return relationTel;
    }
    public void setAddress(String address) 
    {
        this.address = address;
    }

    public String getAddress() 
    {
        return address;
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
    public void setSurplusMoney(Double surplusMoney) 
    {
        this.surplusMoney = surplusMoney;
    }

    public Double getSurplusMoney() 
    {
        return surplusMoney;
    }
    public void setCompanyType(String companyType) 
    {
        this.companyType = companyType;
    }

    public String getCompanyType() 
    {
        return companyType;
    }
    public void setSalesman(String salesman) 
    {
        this.salesman = salesman;
    }

    public String getSalesman() 
    {
        return salesman;
    }
    public void setLeader(String leader) 
    {
        this.leader = leader;
    }

    public String getLeader() 
    {
        return leader;
    }
    public void setLeaderTel(String leaderTel) 
    {
        this.leaderTel = leaderTel;
    }

    public String getLeaderTel() 
    {
        return leaderTel;
    }
    public void setRegion(String region) 
    {
        return;
    }

    public String getRegion() 
    {
         return  province+city+county;
    }
    public void setSalesManager(String salesManager) 
    {
        this.salesManager = salesManager;
    }

    public String getSalesManager() 
    {
        return salesManager;
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
            .append("companyName", getCompanyName())
            .append("relationName", getRelationName())
            .append("relationTel", getRelationTel())
            .append("address", getAddress())
            .append("bankName", getBankName())
            .append("acountsName", getAcountsName())
            .append("bankNo", getBankNo())
            .append("surplusMoney", getSurplusMoney())
            .append("companyType", getCompanyType())
            .append("salesman", getSalesman())
            .append("leader", getLeader())
            .append("leaderTel", getLeaderTel())
            .append("region", getRegion())
            .append("salesManager", getSalesManager())
            .append("province", getProvince())
            .append("city", getCity())
            .append("county", getCounty())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
