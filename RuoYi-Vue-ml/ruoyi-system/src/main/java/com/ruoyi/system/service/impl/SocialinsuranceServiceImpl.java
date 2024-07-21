package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.SocialinsuranceMapper;
import com.ruoyi.system.domain.Socialinsurance;
import com.ruoyi.system.service.ISocialinsuranceService;

/**
 * 社会保险信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class SocialinsuranceServiceImpl implements ISocialinsuranceService 
{
    @Autowired
    private SocialinsuranceMapper socialinsuranceMapper;

    /**
     * 查询社会保险信息
     * 
     * @param id 社会保险信息主键
     * @return 社会保险信息
     */
    @Override
    public Socialinsurance selectSocialinsuranceById(Long id)
    {
        return socialinsuranceMapper.selectSocialinsuranceById(id);
    }

    /**
     * 查询社会保险信息列表
     * 
     * @param socialinsurance 社会保险信息
     * @return 社会保险信息
     */
    @Override
    public List<Socialinsurance> selectSocialinsuranceList(Socialinsurance socialinsurance)
    {
        return socialinsuranceMapper.selectSocialinsuranceList(socialinsurance);
    }

    /**
     * 新增社会保险信息
     * 
     * @param socialinsurance 社会保险信息
     * @return 结果
     */
    @Override
    public int insertSocialinsurance(Socialinsurance socialinsurance)
    {
        return socialinsuranceMapper.insertSocialinsurance(socialinsurance);
    }

    /**
     * 修改社会保险信息
     * 
     * @param socialinsurance 社会保险信息
     * @return 结果
     */
    @Override
    public int updateSocialinsurance(Socialinsurance socialinsurance)
    {
        socialinsurance.setUpdateTime(DateUtils.getNowDate());
        return socialinsuranceMapper.updateSocialinsurance(socialinsurance);
    }

    /**
     * 批量删除社会保险信息
     * 
     * @param ids 需要删除的社会保险信息主键
     * @return 结果
     */
    @Override
    public int deleteSocialinsuranceByIds(Long[] ids)
    {
        return socialinsuranceMapper.deleteSocialinsuranceByIds(ids);
    }

    /**
     * 删除社会保险信息信息
     * 
     * @param id 社会保险信息主键
     * @return 结果
     */
    @Override
    public int deleteSocialinsuranceById(Long id)
    {
        return socialinsuranceMapper.deleteSocialinsuranceById(id);
    }
}
