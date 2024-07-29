package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.SocialinsuranceMapper;
import org.dzu.system.domain.Socialinsurance;
import org.dzu.system.service.ISocialinsuranceService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 社保基金Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class SocialinsuranceServiceImpl implements ISocialinsuranceService
{
    @Autowired
    private SocialinsuranceMapper socialinsuranceMapper;

    /**
     * 查询社保基金
     *
     * @param id 社保基金主键
     * @return 社保基金
     */
    @Override
    public Socialinsurance selectSocialinsuranceById(Long id)
    {
        return socialinsuranceMapper.selectSocialinsuranceById(id);
    }

    /**
     * 查询社保基金列表
     *
     * @param socialinsurance 社保基金
     * @return 社保基金
     */
    @Override
    public List<Socialinsurance> selectSocialinsuranceList(Socialinsurance socialinsurance)
    {
        return socialinsuranceMapper.selectSocialinsuranceList(socialinsurance);
    }

    /**
     * 新增社保基金
     *
     * @param socialinsurance 社保基金
     * @return 结果
     */
    @Override
    public int insertSocialinsurance(Socialinsurance socialinsurance)
    {
        socialinsurance.setAddtime(String.valueOf(DateUtils.getNowDate()));
        socialinsurance.setUserId(SecurityUtils.getUserId());
        socialinsurance.setUserName(SecurityUtils.getUserTruename());
        socialinsurance.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return socialinsuranceMapper.insertSocialinsurance(socialinsurance);
    }

    /**
     * 修改社保基金
     * 
     * @param socialinsurance 社保基金
     * @return 结果
     */
    @Override
    public int updateSocialinsurance(Socialinsurance socialinsurance)
    {
        socialinsurance.setUserId(SecurityUtils.getUserId());
        socialinsurance.setUserName(SecurityUtils.getUserTruename());
        socialinsurance.setUpdateTime(DateUtils.getNowDate());
        return socialinsuranceMapper.updateSocialinsurance(socialinsurance);
    }

    /**
     * 批量删除社保基金
     * 
     * @param ids 需要删除的社保基金主键
     * @return 结果
     */
    @Override
    public int deleteSocialinsuranceByIds(Long[] ids)
    {
        return socialinsuranceMapper.deleteSocialinsuranceByIds(ids);
    }

    /**
     * 删除社保基金信息
     * 
     * @param id 社保基金主键
     * @return 结果
     */
    @Override
    public int deleteSocialinsuranceById(Long id)
    {
        return socialinsuranceMapper.deleteSocialinsuranceById(id);
    }
}
