package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 社会保险信息对象 socialinsurance
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public class Socialinsurance extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 社保缴纳基数 */
    @Excel(name = "社保缴纳基数")
    private Long basicSocialInsurance;

    /** 公积金基数 */
    @Excel(name = "公积金基数")
    private Long basicHousingFund;

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
    @Excel(name = "基本医疗保险-个人")
    private Long healthySecuritySelf;

    /** 基本医疗保险-公司 */
    @Excel(name = "基本医疗保险-公司")
    private Long healthySecurityCompany;

    /** 工伤保险 */
    @Excel(name = "工伤保险")
    private Long injuryInsurance;

    /** 失业保险-个人 */
    @Excel(name = "失业保险-个人")
    private Long unemploymentSecuritySelf;

    /** 失业保险-公司 */
    @Excel(name = "失业保险-公司")
    private Long unemploymentSecurityCompany;

    /** 养老保险-个人 */
    @Excel(name = "养老保险-个人")
    private Long retirementSecuritySelf;

    /** 养老保险-公司 */
    @Excel(name = "养老保险-公司")
    private Long retirementSecurityCompany;

    /** 大额医保-个人 */
    @Excel(name = "大额医保-个人")
    private Long largeMedicalSecuritySelf;

    /** 大额医保-公司 */
    @Excel(name = "大额医保-公司")
    private Long largeMedicalSecurityCompany;

    /** 公积金-个人 */
    @Excel(name = "公积金-个人")
    private Long housingFundSelf;

    /** 公积金-公司 */
    @Excel(name = "公积金-公司")
    private Long housingFundCompany;

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

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setBasicSocialInsurance(Long basicSocialInsurance) 
    {
        this.basicSocialInsurance = basicSocialInsurance;
    }

    public Long getBasicSocialInsurance() 
    {
        return basicSocialInsurance;
    }
    public void setBasicHousingFund(Long basicHousingFund) 
    {
        this.basicHousingFund = basicHousingFund;
    }

    public Long getBasicHousingFund() 
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
    public void setHealthySecuritySelf(Long healthySecuritySelf) 
    {
        this.healthySecuritySelf = healthySecuritySelf;
    }

    public Long getHealthySecuritySelf() 
    {
        return healthySecuritySelf;
    }
    public void setHealthySecurityCompany(Long healthySecurityCompany) 
    {
        this.healthySecurityCompany = healthySecurityCompany;
    }

    public Long getHealthySecurityCompany() 
    {
        return healthySecurityCompany;
    }
    public void setInjuryInsurance(Long injuryInsurance) 
    {
        this.injuryInsurance = injuryInsurance;
    }

    public Long getInjuryInsurance() 
    {
        return injuryInsurance;
    }
    public void setUnemploymentSecuritySelf(Long unemploymentSecuritySelf) 
    {
        this.unemploymentSecuritySelf = unemploymentSecuritySelf;
    }

    public Long getUnemploymentSecuritySelf() 
    {
        return unemploymentSecuritySelf;
    }
    public void setUnemploymentSecurityCompany(Long unemploymentSecurityCompany) 
    {
        this.unemploymentSecurityCompany = unemploymentSecurityCompany;
    }

    public Long getUnemploymentSecurityCompany() 
    {
        return unemploymentSecurityCompany;
    }
    public void setRetirementSecuritySelf(Long retirementSecuritySelf) 
    {
        this.retirementSecuritySelf = retirementSecuritySelf;
    }

    public Long getRetirementSecuritySelf() 
    {
        return retirementSecuritySelf;
    }
    public void setRetirementSecurityCompany(Long retirementSecurityCompany) 
    {
        this.retirementSecurityCompany = retirementSecurityCompany;
    }

    public Long getRetirementSecurityCompany() 
    {
        return retirementSecurityCompany;
    }
    public void setLargeMedicalSecuritySelf(Long largeMedicalSecuritySelf) 
    {
        this.largeMedicalSecuritySelf = largeMedicalSecuritySelf;
    }

    public Long getLargeMedicalSecuritySelf() 
    {
        return largeMedicalSecuritySelf;
    }
    public void setLargeMedicalSecurityCompany(Long largeMedicalSecurityCompany) 
    {
        this.largeMedicalSecurityCompany = largeMedicalSecurityCompany;
    }

    public Long getLargeMedicalSecurityCompany() 
    {
        return largeMedicalSecurityCompany;
    }
    public void setHousingFundSelf(Long housingFundSelf) 
    {
        this.housingFundSelf = housingFundSelf;
    }

    public Long getHousingFundSelf() 
    {
        return housingFundSelf;
    }
    public void setHousingFundCompany(Long housingFundCompany) 
    {
        this.housingFundCompany = housingFundCompany;
    }

    public Long getHousingFundCompany() 
    {
        return housingFundCompany;
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
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
