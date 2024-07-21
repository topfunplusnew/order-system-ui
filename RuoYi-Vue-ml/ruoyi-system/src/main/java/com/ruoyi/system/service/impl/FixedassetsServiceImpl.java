package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.FixedassetsMapper;
import com.ruoyi.system.domain.Fixedassets;
import com.ruoyi.system.service.IFixedassetsService;

/**
 * 固定资产信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class FixedassetsServiceImpl implements IFixedassetsService 
{
    @Autowired
    private FixedassetsMapper fixedassetsMapper;

    /**
     * 查询固定资产信息
     * 
     * @param id 固定资产信息主键
     * @return 固定资产信息
     */
    @Override
    public Fixedassets selectFixedassetsById(Long id)
    {
        return fixedassetsMapper.selectFixedassetsById(id);
    }

    /**
     * 查询固定资产信息列表
     * 
     * @param fixedassets 固定资产信息
     * @return 固定资产信息
     */
    @Override
    public List<Fixedassets> selectFixedassetsList(Fixedassets fixedassets)
    {
        return fixedassetsMapper.selectFixedassetsList(fixedassets);
    }

    /**
     * 新增固定资产信息
     * 
     * @param fixedassets 固定资产信息
     * @return 结果
     */
    @Override
    public int insertFixedassets(Fixedassets fixedassets)
    {
        return fixedassetsMapper.insertFixedassets(fixedassets);
    }

    /**
     * 修改固定资产信息
     * 
     * @param fixedassets 固定资产信息
     * @return 结果
     */
    @Override
    public int updateFixedassets(Fixedassets fixedassets)
    {
        fixedassets.setUpdateTime(DateUtils.getNowDate());
        return fixedassetsMapper.updateFixedassets(fixedassets);
    }

    /**
     * 批量删除固定资产信息
     * 
     * @param ids 需要删除的固定资产信息主键
     * @return 结果
     */
    @Override
    public int deleteFixedassetsByIds(Long[] ids)
    {
        return fixedassetsMapper.deleteFixedassetsByIds(ids);
    }

    /**
     * 删除固定资产信息信息
     * 
     * @param id 固定资产信息主键
     * @return 结果
     */
    @Override
    public int deleteFixedassetsById(Long id)
    {
        return fixedassetsMapper.deleteFixedassetsById(id);
    }
}
