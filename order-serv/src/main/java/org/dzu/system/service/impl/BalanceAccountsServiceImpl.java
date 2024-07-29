package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BalanceAccountsMapper;
import org.dzu.system.domain.BalanceAccounts;
import org.dzu.system.service.IBalanceAccountsService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 平账信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BalanceAccountsServiceImpl implements IBalanceAccountsService
{
    @Autowired
    private BalanceAccountsMapper balanceAccountsMapper;

    /**
     * 查询平账信息
     *
     * @param id 平账信息主键
     * @return 平账信息
     */
    @Override
    public BalanceAccounts selectBalanceAccountsById(Long id)
    {
        return balanceAccountsMapper.selectBalanceAccountsById(id);
    }

    /**
     * 查询平账信息列表
     *
     * @param balanceAccounts 平账信息
     * @return 平账信息
     */
    @Override
    public List<BalanceAccounts> selectBalanceAccountsList(BalanceAccounts balanceAccounts)
    {
        return balanceAccountsMapper.selectBalanceAccountsList(balanceAccounts);
    }

    /**
     * 新增平账信息
     *
     * @param balanceAccounts 平账信息
     * @return 结果
     */
    @Override
    public int insertBalanceAccounts(BalanceAccounts balanceAccounts)
    {
        balanceAccounts.setAddtime(String.valueOf(DateUtils.getNowDate()));
        balanceAccounts.setUserId(SecurityUtils.getUserId());
        balanceAccounts.setUserName(SecurityUtils.getUserTruename());
        balanceAccounts.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return balanceAccountsMapper.insertBalanceAccounts(balanceAccounts);
    }

    /**
     * 修改平账信息
     * 
     * @param balanceAccounts 平账信息
     * @return 结果
     */
    @Override
    public int updateBalanceAccounts(BalanceAccounts balanceAccounts)
    {
        balanceAccounts.setUserId(SecurityUtils.getUserId());
        balanceAccounts.setUserName(SecurityUtils.getUserTruename());
        balanceAccounts.setUpdateTime(DateUtils.getNowDate());
        return balanceAccountsMapper.updateBalanceAccounts(balanceAccounts);
    }

    /**
     * 批量删除平账信息
     * 
     * @param ids 需要删除的平账信息主键
     * @return 结果
     */
    @Override
    public int deleteBalanceAccountsByIds(Long[] ids)
    {
        return balanceAccountsMapper.deleteBalanceAccountsByIds(ids);
    }

    /**
     * 删除平账信息信息
     * 
     * @param id 平账信息主键
     * @return 结果
     */
    @Override
    public int deleteBalanceAccountsById(Long id)
    {
        return balanceAccountsMapper.deleteBalanceAccountsById(id);
    }
}
