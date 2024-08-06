package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.BalanceAccounts;

/**
 * 平账信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IBalanceAccountsService 
{
    /**
     * 查询平账信息
     * 
     * @param id 平账信息主键
     * @return 平账信息
     */
    public BalanceAccounts selectBalanceAccountsById(Long id);

    /**
     * 查询平账信息列表
     * 
     * @param balanceAccounts 平账信息
     * @return 平账信息集合
     */
    public List<BalanceAccounts> selectBalanceAccountsList(BalanceAccounts balanceAccounts);

    /**
     * 新增平账信息
     * 
     * @param balanceAccounts 平账信息
     * @return 结果
     */
    public int insertBalanceAccounts(BalanceAccounts balanceAccounts);

    /**
     * 修改平账信息
     * 
     * @param balanceAccounts 平账信息
     * @return 结果
     */
    public int updateBalanceAccounts(BalanceAccounts balanceAccounts);

    /**
     * 批量删除平账信息
     * 
     * @param ids 需要删除的平账信息主键集合
     * @return 结果
     */
    public int deleteBalanceAccountsByIds(Long[] ids);
}
