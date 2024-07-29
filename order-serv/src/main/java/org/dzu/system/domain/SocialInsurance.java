package org.dzu.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.Excel;
import org.dzu.common.core.domain.BaseEntity;

import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.OnlyZeroOrOne;
/**
 * 社保基金对象 socialInsurance
 * 
 * @author ml
 * @date 2024-07-29
 */
public class SocialInsurance extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 社保缴纳基数 */
    @DecimalMaxDigits
    private Double basicSocialInsurance;

    /** 公积金基数 */
    @DecimalMaxDigits
    private Double basicHousingFund;

    /** 部门 */
    @Excel(name = "部门")
    private String depName;

    /** 姓名 */
    @Excel(name = "姓名")
    private String employeeName;

    /** 人员编号 */
    @Excel(name = "人员编号")
    private String employeeID;

    /** 缴费时间 */
    @Excel(name = "缴费时间")
    private String insuranceDate;

    /** 是否增员（是，否） */
    @Excel(name = "是否增员", readConverterExp = "是=，否")
    private String isRecruiting;

    /** 是否减员 */
    @Excel(name = "是否减员")
    private String isDepletion;

    /** 基本医疗保险-个人 */
    @DecimalMaxDigits
    private Double healthySecuritySelf;

    /** 基本医疗保险-公司 */
    @DecimalMaxDigits
    private Double healthySecurityCompany;

    /** 工伤保险 */
    @DecimalMaxDigits
    private Double injuryInsurance;

    /** 失业保险-个人 */
    @DecimalMaxDigits
    private Double unemploymentSecuritySelf;

    /** 失业保险-公司 */
    @DecimalMaxDigits
    private Double unemploymentSecurityCompany;

    /** 养老保险-个人 */
    @DecimalMaxDigits
    private Double retirementSecuritySelf;

    /** 养老保险-公司 */
    @DecimalMaxDigits
    private Double retirementSecurityCompany;

    /** 大额医保-个人 */
    @DecimalMaxDigits
    private Double largeMedicalSecuritySelf;

    /** 大额医保-公司 */
    @DecimalMaxDigits
    private Double largeMedicalSecurityCompany;

    /** 公积金-个人 */
    @DecimalMaxDigits
    private Double housingFundSelf;

    /** 公积金-公司 */
    @DecimalMaxDigits
    private Double housingFundCompany;

    /** 个人缴费总额 */
    @DecimalMaxDigits
    private Double sumSelf;

    /** 公司缴费总额 */
    @DecimalMaxDigits
    private Double sumCompany;

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
    public void setBasicSocialInsurance(Double basicSocialInsurance) 
    {
        this.basicSocialInsurance = basicSocialInsurance;
    }

    public Double getBasicSocialInsurance() 
    {
        return basicSocialInsurance;
    }
    public void setBasicHousingFund(Double basicHousingFund) 
    {
        this.basicHousingFund = basicHousingFund;
    }

    public Double getBasicHousingFund() 
    {
        return basicHousingFund;
    }
    public void setDepName(String depName) 
    {
        this.depName = depName;
    }

    public String getDepName() 
    {
        return depName;
    }
    public void setEmployeeName(String employeeName) 
    {
        this.employeeName = employeeName;
    }

    public String getEmployeeName() 
    {
        return employeeName;
    }
    public void setEmployeeID(String employeeID) 
    {
        this.employeeID = employeeID;
    }

    public String getEmployeeID() 
    {
        return employeeID;
    }
    public void setInsuranceDate(String insuranceDate) 
    {
        this.insuranceDate = insuranceDate;
    }

    public String getInsuranceDate() 
    {
        return insuranceDate;
    }
    public void setIsRecruiting(String isRecruiting) 
    {
        this.isRecruiting = isRecruiting;
    }

    public String getIsRecruiting() 
    {
        return isRecruiting;
    }
    public void setIsDepletion(String isDepletion) 
    {
        this.isDepletion = isDepletion;
    }

    public String getIsDepletion() 
    {
        return isDepletion;
    }
    public void setHealthySecuritySelf(Double healthySecuritySelf) 
    {
        this.healthySecuritySelf = healthySecuritySelf;
    }

    public Double getHealthySecuritySelf() 
    {
        return healthySecuritySelf;
    }
    public void setHealthySecurityCompany(Double healthySecurityCompany) 
    {
        this.healthySecurityCompany = healthySecurityCompany;
    }

    public Double getHealthySecurityCompany() 
    {
        return healthySecurityCompany;
    }
    public void setInjuryInsurance(Double injuryInsurance) 
    {
        this.injuryInsurance = injuryInsurance;
    }

    public Double getInjuryInsurance() 
    {
        return injuryInsurance;
    }
    public void setUnemploymentSecuritySelf(Double unemploymentSecuritySelf) 
    {
        this.unemploymentSecuritySelf = unemploymentSecuritySelf;
    }

    public Double getUnemploymentSecuritySelf() 
    {
        return unemploymentSecuritySelf;
    }
    public void setUnemploymentSecurityCompany(Double unemploymentSecurityCompany) 
    {
        this.unemploymentSecurityCompany = unemploymentSecurityCompany;
    }

    public Double getUnemploymentSecurityCompany() 
    {
        return unemploymentSecurityCompany;
    }
    public void setRetirementSecuritySelf(Double retirementSecuritySelf) 
    {
        this.retirementSecuritySelf = retirementSecuritySelf;
    }

    public Double getRetirementSecuritySelf() 
    {
        return retirementSecuritySelf;
    }
    public void setRetirementSecurityCompany(Double retirementSecurityCompany) 
    {
        this.retirementSecurityCompany = retirementSecurityCompany;
    }

    public Double getRetirementSecurityCompany() 
    {
        return retirementSecurityCompany;
    }
    public void setLargeMedicalSecuritySelf(Double largeMedicalSecuritySelf) 
    {
        this.largeMedicalSecuritySelf = largeMedicalSecuritySelf;
    }

    public Double getLargeMedicalSecuritySelf() 
    {
        return largeMedicalSecuritySelf;
    }
    public void setLargeMedicalSecurityCompany(Double largeMedicalSecurityCompany) 
    {
        this.largeMedicalSecurityCompany = largeMedicalSecurityCompany;
    }

    public Double getLargeMedicalSecurityCompany() 
    {
        return largeMedicalSecurityCompany;
    }
    public void setHousingFundSelf(Double housingFundSelf) 
    {
        this.housingFundSelf = housingFundSelf;
    }

    public Double getHousingFundSelf() 
    {
        return housingFundSelf;
    }
    public void setHousingFundCompany(Double housingFundCompany) 
    {
        this.housingFundCompany = housingFundCompany;
    }

    public Double getHousingFundCompany() 
    {
        return housingFundCompany;
    }
    public void setSumSelf(Double sumSelf) 
    {
        this.sumSelf = sumSelf;
    }

    public Double getSumSelf() 
    {
        return sumSelf;
    }
    public void setSumCompany(Double sumCompany) 
    {
        this.sumCompany = sumCompany;
    }

    public Double getSumCompany() 
    {
        return sumCompany;
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
            .append("basicSocialInsurance", getBasicSocialInsurance())
            .append("basicHousingFund", getBasicHousingFund())
            .append("depName", getDepName())
            .append("employeeName", getEmployeeName())
            .append("employeeID", getEmployeeID())
            .append("insuranceDate", getInsuranceDate())
            .append("isRecruiting", getIsRecruiting())
            .append("isDepletion", getIsDepletion())
            .append("healthySecuritySelf", getHealthySecuritySelf())
            .append("healthySecurityCompany", getHealthySecurityCompany())
            .append("injuryInsurance", getInjuryInsurance())
            .append("unemploymentSecuritySelf", getUnemploymentSecuritySelf())
            .append("unemploymentSecurityCompany", getUnemploymentSecurityCompany())
            .append("retirementSecuritySelf", getRetirementSecuritySelf())
            .append("retirementSecurityCompany", getRetirementSecurityCompany())
            .append("largeMedicalSecuritySelf", getLargeMedicalSecuritySelf())
            .append("largeMedicalSecurityCompany", getLargeMedicalSecurityCompany())
            .append("housingFundSelf", getHousingFundSelf())
            .append("housingFundCompany", getHousingFundCompany())
            .append("sumSelf", getSumSelf())
            .append("sumCompany", getSumCompany())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
