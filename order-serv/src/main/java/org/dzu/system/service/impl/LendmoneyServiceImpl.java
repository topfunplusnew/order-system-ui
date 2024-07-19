package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.LendmoneyMapper;
import org.dzu.system.domain.Lendmoney;
import org.dzu.system.service.ILendmoneyService;

/**
 * 资金借出（期货）Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class LendmoneyServiceImpl implements ILendmoneyService 
{
    @Autowired
    private LendmoneyMapper lendmoneyMapper;

    /**
     * 查询资金借出（期货）
     * 
     * @param id 资金借出（期货）主键
     * @return 资金借出（期货）
     */
    @Override
    public Lendmoney selectLendmoneyById(Long id)
    {
        return lendmoneyMapper.selectLendmoneyById(id);
    }

    /**
     * 查询资金借出（期货）列表
     * 
     * @param lendmoney 资金借出（期货）
     * @return 资金借出（期货）
     */
    @Override
    public List<Lendmoney> selectLendmoneyList(Lendmoney lendmoney)
    {
        return lendmoneyMapper.selectLendmoneyList(lendmoney);
    }

    /**
     * 新增资金借出（期货）
     * 
     * @param lendmoney 资金借出（期货）
     * @return 结果
     */
    @Override
    public int insertLendmoney(Lendmoney lendmoney)
    {
        return lendmoneyMapper.insertLendmoney(lendmoney);
    }

    /**
     * 修改资金借出（期货）
     * 
     * @param lendmoney 资金借出（期货）
     * @return 结果
     */
    @Override
    public int updateLendmoney(Lendmoney lendmoney)
    {
        lendmoney.setUpdateTime(DateUtils.getNowDate());
        return lendmoneyMapper.updateLendmoney(lendmoney);
    }

    /**
     * 批量删除资金借出（期货）
     * 
     * @param ids 需要删除的资金借出（期货）主键
     * @return 结果
     */
    @Override
    public int deleteLendmoneyByIds(Long[] ids)
    {
        return lendmoneyMapper.deleteLendmoneyByIds(ids);
    }

    /**
     * 删除资金借出（期货）信息
     * 
     * @param id 资金借出（期货）主键
     * @return 结果
     */
    @Override
    public int deleteLendmoneyById(Long id)
    {
        return lendmoneyMapper.deleteLendmoneyById(id);
    }
}
