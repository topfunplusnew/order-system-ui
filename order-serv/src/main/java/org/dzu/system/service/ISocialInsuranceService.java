package org.dzu.system.service;

import org.dzu.system.domain.SocialInsurance;

import java.util.List;

/**
 * 社保基金Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface ISocialInsuranceService 
{
    /**
     * 查询社保基金
     * 
     * @param id 社保基金主键
     * @return 社保基金
     */
    public SocialInsurance selectSocialInsuranceById(Long id);

    /**
     * 查询社保基金列表
     * 
     * @param socialInsurance 社保基金
     * @return 社保基金集合
     */
    public List<SocialInsurance> selectSocialInsuranceList(SocialInsurance socialInsurance);

    /**
     * 新增社保基金
     * 
     * @param socialInsurance 社保基金
     * @return 结果
     */
    public int insertSocialInsurance(SocialInsurance socialInsurance);

    /**
     * 修改社保基金
     * 
     * @param socialInsurance 社保基金
     * @return 结果
     */
    public int updateSocialInsurance(SocialInsurance socialInsurance);

    /**
     * 批量删除社保基金
     * 
     * @param ids 需要删除的社保基金主键集合
     * @return 结果
     */
    public int deleteSocialInsuranceByIds(Long[] ids);

    /**
     * 删除社保基金信息
     * 
     * @param id 社保基金主键
     * @return 结果
     */
    public int deleteSocialInsuranceById(Long id);
}
