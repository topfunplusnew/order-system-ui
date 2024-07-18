package org.dzu.system.service.impl;

import org.dzu.common.utils.DateUtils;
import org.dzu.system.domain.Offsetting;
import org.dzu.system.mapper.OffsettingMapper;
import org.dzu.system.service.IOffsettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 资金调整单信息Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class OffsettingServiceImpl implements IOffsettingService 
{
    @Autowired
    private OffsettingMapper offsettingMapper;

    /**
     * 查询资金调整单信息
     * 
     * @param id 资金调整单信息主键
     * @return 资金调整单信息
     */
    @Override
    public Offsetting selectOffsettingById(Long id)
    {
        return offsettingMapper.selectOffsettingById(id);
    }

    /**
     * 查询资金调整单信息列表
     * 
     * @param offsetting 资金调整单信息
     * @return 资金调整单信息
     */
    @Override
    public List<Offsetting> selectOffsettingList(Offsetting offsetting)
    {
        return offsettingMapper.selectOffsettingList(offsetting);
    }

    /**
     * 新增资金调整单信息
     * 
     * @param offsetting 资金调整单信息
     * @return 结果
     */
    @Override
    public int insertOffsetting(Offsetting offsetting)
    {
        return offsettingMapper.insertOffsetting(offsetting);
    }

    /**
     * 修改资金调整单信息
     * 
     * @param offsetting 资金调整单信息
     * @return 结果
     */
    @Override
    public int updateOffsetting(Offsetting offsetting)
    {
        offsetting.setUpdateTime(DateUtils.getNowDate());
        return offsettingMapper.updateOffsetting(offsetting);
    }

    /**
     * 批量删除资金调整单信息
     * 
     * @param ids 需要删除的资金调整单信息主键
     * @return 结果
     */
    @Override
    public int deleteOffsettingByIds(Long[] ids)
    {
        return offsettingMapper.deleteOffsettingByIds(ids);
    }

    /**
     * 删除资金调整单信息信息
     * 
     * @param id 资金调整单信息主键
     * @return 结果
     */
    @Override
    public int deleteOffsettingById(Long id)
    {
        return offsettingMapper.deleteOffsettingById(id);
    }
}
