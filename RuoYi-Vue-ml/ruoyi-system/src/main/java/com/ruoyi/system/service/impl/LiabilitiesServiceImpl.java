package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.LiabilitiesMapper;
import com.ruoyi.system.domain.Liabilities;
import com.ruoyi.system.service.ILiabilitiesService;

/**
 * 负债信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class LiabilitiesServiceImpl implements ILiabilitiesService 
{
    @Autowired
    private LiabilitiesMapper liabilitiesMapper;

    /**
     * 查询负债信息
     * 
     * @param id 负债信息主键
     * @return 负债信息
     */
    @Override
    public Liabilities selectLiabilitiesById(Long id)
    {
        return liabilitiesMapper.selectLiabilitiesById(id);
    }

    /**
     * 查询负债信息列表
     * 
     * @param liabilities 负债信息
     * @return 负债信息
     */
    @Override
    public List<Liabilities> selectLiabilitiesList(Liabilities liabilities)
    {
        return liabilitiesMapper.selectLiabilitiesList(liabilities);
    }

    /**
     * 新增负债信息
     * 
     * @param liabilities 负债信息
     * @return 结果
     */
    @Override
    public int insertLiabilities(Liabilities liabilities)
    {
        return liabilitiesMapper.insertLiabilities(liabilities);
    }

    /**
     * 修改负债信息
     * 
     * @param liabilities 负债信息
     * @return 结果
     */
    @Override
    public int updateLiabilities(Liabilities liabilities)
    {
        liabilities.setUpdateTime(DateUtils.getNowDate());
        return liabilitiesMapper.updateLiabilities(liabilities);
    }

    /**
     * 批量删除负债信息
     * 
     * @param ids 需要删除的负债信息主键
     * @return 结果
     */
    @Override
    public int deleteLiabilitiesByIds(Long[] ids)
    {
        return liabilitiesMapper.deleteLiabilitiesByIds(ids);
    }

    /**
     * 删除负债信息信息
     * 
     * @param id 负债信息主键
     * @return 结果
     */
    @Override
    public int deleteLiabilitiesById(Long id)
    {
        return liabilitiesMapper.deleteLiabilitiesById(id);
    }
}
