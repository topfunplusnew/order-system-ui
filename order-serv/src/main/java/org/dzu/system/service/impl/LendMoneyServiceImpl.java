package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.LendMoneyMapper;
import org.dzu.system.domain.LendMoney;
import org.dzu.system.service.ILendMoneyService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 向外部借出款信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class LendMoneyServiceImpl implements ILendMoneyService
{
    @Autowired
    private LendMoneyMapper lendMoneyMapper;

    /**
     * 查询向外部借出款信息
     *
     * @param id 向外部借出款信息主键
     * @return 向外部借出款信息
     */
    @Override
    public LendMoney selectLendMoneyById(Long id)
    {
        return lendMoneyMapper.selectLendMoneyById(id);
    }

    /**
     * 查询向外部借出款信息列表
     *
     * @param lendMoney 向外部借出款信息
     * @return 向外部借出款信息
     */
    @Override
    public List<LendMoney> selectLendMoneyList(LendMoney lendMoney)
    {
        return lendMoneyMapper.selectLendMoneyList(lendMoney);
    }

    /**
     * 新增向外部借出款信息
     *
     * @param lendMoney 向外部借出款信息
     * @return 结果
     */
    @Override
    public int insertLendMoney(LendMoney lendMoney)
    {
        lendMoney.setAddtime(String.valueOf(DateUtils.getNowDate()));
        lendMoney.setUserId(SecurityUtils.getUserId());
        lendMoney.setUserName(SecurityUtils.getUserTruename());
        lendMoney.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return lendMoneyMapper.insertLendMoney(lendMoney);
    }

    /**
     * 修改向外部借出款信息
     * 
     * @param lendMoney 向外部借出款信息
     * @return 结果
     */
    @Override
    public int updateLendMoney(LendMoney lendMoney)
    {
        lendMoney.setUserId(SecurityUtils.getUserId());
        lendMoney.setUserName(SecurityUtils.getUserTruename());
        lendMoney.setUpdateTime(DateUtils.getNowDate());
        return lendMoneyMapper.updateLendMoney(lendMoney);
    }

    /**
     * 批量删除向外部借出款信息
     * 
     * @param ids 需要删除的向外部借出款信息主键
     * @return 结果
     */
    @Override
    public int deleteLendMoneyByIds(Long[] ids)
    {
        return lendMoneyMapper.deleteLendMoneyByIds(ids);
    }

    /**
     * 删除向外部借出款信息信息
     * 
     * @param id 向外部借出款信息主键
     * @return 结果
     */
    @Override
    public int deleteLendMoneyById(Long id)
    {
        return lendMoneyMapper.deleteLendMoneyById(id);
    }
}
