package org.dzu.system.service.impl;

import org.dzu.common.utils.DateUtils;
import org.dzu.system.domain.Futuresmargin;
import org.dzu.system.mapper.FuturesmarginMapper;
import org.dzu.system.service.IFuturesmarginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 期货保证金信息Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class FuturesmarginServiceImpl implements IFuturesmarginService 
{
    @Autowired
    private FuturesmarginMapper futuresmarginMapper;

    /**
     * 查询期货保证金信息
     * 
     * @param id 期货保证金信息主键
     * @return 期货保证金信息
     */
    @Override
    public Futuresmargin selectFuturesmarginById(Long id)
    {
        return futuresmarginMapper.selectFuturesmarginById(id);
    }

    /**
     * 查询期货保证金信息列表
     * 
     * @param futuresmargin 期货保证金信息
     * @return 期货保证金信息
     */
    @Override
    public List<Futuresmargin> selectFuturesmarginList(Futuresmargin futuresmargin)
    {
        return futuresmarginMapper.selectFuturesmarginList(futuresmargin);
    }

    /**
     * 新增期货保证金信息
     * 
     * @param futuresmargin 期货保证金信息
     * @return 结果
     */
    @Override
    public int insertFuturesmargin(Futuresmargin futuresmargin)
    {
        return futuresmarginMapper.insertFuturesmargin(futuresmargin);
    }

    /**
     * 修改期货保证金信息
     * 
     * @param futuresmargin 期货保证金信息
     * @return 结果
     */
    @Override
    public int updateFuturesmargin(Futuresmargin futuresmargin)
    {
        futuresmargin.setUpdateTime(DateUtils.getNowDate());
        return futuresmarginMapper.updateFuturesmargin(futuresmargin);
    }

    /**
     * 批量删除期货保证金信息
     * 
     * @param ids 需要删除的期货保证金信息主键
     * @return 结果
     */
    @Override
    public int deleteFuturesmarginByIds(Long[] ids)
    {
        return futuresmarginMapper.deleteFuturesmarginByIds(ids);
    }

    /**
     * 删除期货保证金信息信息
     * 
     * @param id 期货保证金信息主键
     * @return 结果
     */
    @Override
    public int deleteFuturesmarginById(Long id)
    {
        return futuresmarginMapper.deleteFuturesmarginById(id);
    }
}
