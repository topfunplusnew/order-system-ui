package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.RecovermoneyMapper;
import org.dzu.system.domain.Recovermoney;
import org.dzu.system.service.IRecovermoneyService;

/**
 * 资金回收Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class RecovermoneyServiceImpl implements IRecovermoneyService 
{
    @Autowired
    private RecovermoneyMapper recovermoneyMapper;

    /**
     * 查询资金回收
     * 
     * @param id 资金回收主键
     * @return 资金回收
     */
    @Override
    public Recovermoney selectRecovermoneyById(Long id)
    {
        return recovermoneyMapper.selectRecovermoneyById(id);
    }

    /**
     * 查询资金回收列表
     * 
     * @param recovermoney 资金回收
     * @return 资金回收
     */
    @Override
    public List<Recovermoney> selectRecovermoneyList(Recovermoney recovermoney)
    {
        return recovermoneyMapper.selectRecovermoneyList(recovermoney);
    }

    /**
     * 新增资金回收
     * 
     * @param recovermoney 资金回收
     * @return 结果
     */
    @Override
    public int insertRecovermoney(Recovermoney recovermoney)
    {
        return recovermoneyMapper.insertRecovermoney(recovermoney);
    }

    /**
     * 修改资金回收
     * 
     * @param recovermoney 资金回收
     * @return 结果
     */
    @Override
    public int updateRecovermoney(Recovermoney recovermoney)
    {
        recovermoney.setUpdateTime(DateUtils.getNowDate());
        return recovermoneyMapper.updateRecovermoney(recovermoney);
    }

    /**
     * 批量删除资金回收
     * 
     * @param ids 需要删除的资金回收主键
     * @return 结果
     */
    @Override
    public int deleteRecovermoneyByIds(Long[] ids)
    {
        return recovermoneyMapper.deleteRecovermoneyByIds(ids);
    }

    /**
     * 删除资金回收信息
     * 
     * @param id 资金回收主键
     * @return 结果
     */
    @Override
    public int deleteRecovermoneyById(Long id)
    {
        return recovermoneyMapper.deleteRecovermoneyById(id);
    }
}
