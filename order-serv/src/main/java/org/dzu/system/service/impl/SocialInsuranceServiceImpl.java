package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.SocialInsuranceMapper;
import org.dzu.system.domain.SocialInsurance;
import org.dzu.system.service.ISocialInsuranceService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 社保基金Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class SocialInsuranceServiceImpl implements ISocialInsuranceService
{
    @Autowired
    private SocialInsuranceMapper socialInsuranceMapper;

    /**
     * 查询社保基金
     *
     * @param id 社保基金主键
     * @return 社保基金
     */
    @Override
    public SocialInsurance selectSocialInsuranceById(Long id)
    {
        return socialInsuranceMapper.selectSocialInsuranceById(id);
    }

    /**
     * 查询社保基金列表
     *
     * @param socialInsurance 社保基金
     * @return 社保基金
     */
    @Override
    public List<SocialInsurance> selectSocialInsuranceList(SocialInsurance socialInsurance)
    {
        return socialInsuranceMapper.selectSocialInsuranceList(socialInsurance);
    }

    /**
     * 新增社保基金
     *
     * @param socialInsurance 社保基金
     * @return 结果
     */
    @Override
    public int insertSocialInsurance(SocialInsurance socialInsurance)
    {
        socialInsurance.setAddtime(String.valueOf(DateUtils.getNowDate()));
        socialInsurance.setUserId(SecurityUtils.getUserId());
        socialInsurance.setUserName(SecurityUtils.getUserTruename());
        socialInsurance.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return socialInsuranceMapper.insertSocialInsurance(socialInsurance);
    }

    /**
     * 修改社保基金
     * 
     * @param socialInsurance 社保基金
     * @return 结果
     */
    @Override
    public int updateSocialInsurance(SocialInsurance socialInsurance)
    {
        socialInsurance.setUserId(SecurityUtils.getUserId());
        socialInsurance.setUserName(SecurityUtils.getUserTruename());
        socialInsurance.setUpdateTime(DateUtils.getNowDate());
        return socialInsuranceMapper.updateSocialInsurance(socialInsurance);
    }

    /**
     * 批量删除社保基金
     * 
     * @param ids 需要删除的社保基金主键
     * @return 结果
     */
    @Override
    public int deleteSocialInsuranceByIds(Long[] ids)
    {
        return socialInsuranceMapper.deleteSocialInsuranceByIds(ids);
    }

    /**
     * 删除社保基金信息
     * 
     * @param id 社保基金主键
     * @return 结果
     */
    @Override
    public int deleteSocialInsuranceById(Long id)
    {
        return socialInsuranceMapper.deleteSocialInsuranceById(id);
    }
}
