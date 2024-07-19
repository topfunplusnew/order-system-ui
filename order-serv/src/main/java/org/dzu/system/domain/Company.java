package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.OnlyZeroOrOne;
import org.dzu.common.annotation.PhoneLength;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

/**
 * 客户管理对象 company
 * 
 * @author ml
 * @date 2024-07-19
 */
public class Company extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 公司 */
    @Excel(name = "公司")
    private String company;

    /** 联系人 */
    @Excel(name = "联系人")
    private String relationName;

    /** 联系人电话 */
    @Excel(name = "联系人电话")
    @Size(min = 0, max = 11, message = "联系电话长度不能超过11个字符")
    private String relationTel;

    /** 地址 */
    @Excel(name = "地址")
    @Length(max=249,message = "地址长度过大")
    private String address;

    /** 开户行 */
    @Excel(name = "开户行")
    private String bankName;

    /** 开户名 */
    @Excel(name = "开户名")
    private String acountsName;

    /** 账号 */
    @Excel(name = "账号")
    private String bankNo;

    /** 余额 */
    @Excel(name = "余额")
    @DecimalMaxDigits
    private Float surplusMoney;

    /** 客户类别（ 客户，供应商） */
    @Excel(name = "客户类别")
    @Pattern(regexp = "客户|供应商", message = "类型必须是 '客户' 或者 '供应商'")
    private String companyType;


    /** 业务员 */
    @Excel(name = "业务员")
    private String salesman;

    /** 老板 */
    @Excel(name = "老板")
    private String leader;

    /** 联系人电话 */
    @Excel(name = "联系人电话")
    @PhoneLength
    private String leaderTel;



    /** 区域（省+市县+乡镇） */
    @Excel(name = "区域" )
    private String region;

    /** 销售经理 */
    @Excel(name = "销售经理")
    private String salesManager;

    /** 省 */
    @Excel(name = "省")
    private String province;

    /** 市县 */
    @Excel(name = "市县")
    private String city;

    /** 乡镇 */
    @Excel(name = "乡镇")
    private String county;

    /** 备注 */
    @Excel(name = "备注")
    private String comments;

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
    public void setCompany(String company) 
    {
        this.company = company;
    }

    public String getCompany() 
    {
        return company;
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
    public void setSurplusMoney(Float surplusMoney)
    {
        this.surplusMoney = surplusMoney;
    }

    public Float getSurplusMoney()
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
        this.region = region;
    }

    public String getRegion() 
    {
        return this.province+"-"+this.city+"="+this.county;
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
            .append("company", getCompany())
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
