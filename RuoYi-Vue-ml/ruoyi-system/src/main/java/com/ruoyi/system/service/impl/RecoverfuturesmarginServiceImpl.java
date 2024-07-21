package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.RecoverfuturesmarginMapper;
import com.ruoyi.system.domain.Recoverfuturesmargin;
import com.ruoyi.system.service.IRecoverfuturesmarginService;

/**
 * 恢复期货保证金？Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class RecoverfuturesmarginServiceImpl implements IRecoverfuturesmarginService 
{
    @Autowired
    private RecoverfuturesmarginMapper recoverfuturesmarginMapper;

    /**
     * 查询恢复期货保证金？
     * 
     * @param id 恢复期货保证金？主键
     * @return 恢复期货保证金？
     */
    @Override
    public Recoverfuturesmargin selectRecoverfuturesmarginById(Long id)
    {
        return recoverfuturesmarginMapper.selectRecoverfuturesmarginById(id);
    }

    /**
     * 查询恢复期货保证金？列表
     * 
     * @param recoverfuturesmargin 恢复期货保证金？
     * @return 恢复期货保证金？
     */
    @Override
    public List<Recoverfuturesmargin> selectRecoverfuturesmarginList(Recoverfuturesmargin recoverfuturesmargin)
    {
        return recoverfuturesmarginMapper.selectRecoverfuturesmarginList(recoverfuturesmargin);
    }

    /**
     * 新增恢复期货保证金？
     * 
     * @param recoverfuturesmargin 恢复期货保证金？
     * @return 结果
     */
    @Override
    public int insertRecoverfuturesmargin(Recoverfuturesmargin recoverfuturesmargin)
    {
        return recoverfuturesmarginMapper.insertRecoverfuturesmargin(recoverfuturesmargin);
    }

    /**
     * 修改恢复期货保证金？
     * 
     * @param recoverfuturesmargin 恢复期货保证金？
     * @return 结果
     */
    @Override
    public int updateRecoverfuturesmargin(Recoverfuturesmargin recoverfuturesmargin)
    {
        recoverfuturesmargin.setUpdateTime(DateUtils.getNowDate());
        return recoverfuturesmarginMapper.updateRecoverfuturesmargin(recoverfuturesmargin);
    }

    /**
     * 批量删除恢复期货保证金？
     * 
     * @param ids 需要删除的恢复期货保证金？主键
     * @return 结果
     */
    @Override
    public int deleteRecoverfuturesmarginByIds(Long[] ids)
    {
        return recoverfuturesmarginMapper.deleteRecoverfuturesmarginByIds(ids);
    }

    /**
     * 删除恢复期货保证金？信息
     * 
     * @param id 恢复期货保证金？主键
     * @return 结果
     */
    @Override
    public int deleteRecoverfuturesmarginById(Long id)
    {
        return recoverfuturesmarginMapper.deleteRecoverfuturesmarginById(id);
    }
}
