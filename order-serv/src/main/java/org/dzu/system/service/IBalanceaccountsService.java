package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Balanceaccounts;

/**
 * 平账Service接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface IBalanceaccountsService 
{
    /**
     * 查询平账
     * 
     * @param id 平账主键
     * @return 平账
     */
    public Balanceaccounts selectBalanceaccountsById(Long id);

    /**
     * 查询平账列表
     * 
     * @param balanceaccounts 平账
     * @return 平账集合
     */
    public List<Balanceaccounts> selectBalanceaccountsList(Balanceaccounts balanceaccounts);

    /**
     * 新增平账
     * 
     * @param balanceaccounts 平账
     * @return 结果
     */
    public int insertBalanceaccounts(Balanceaccounts balanceaccounts);

    /**
     * 修改平账
     * 
     * @param balanceaccounts 平账
     * @return 结果
     */
    public int updateBalanceaccounts(Balanceaccounts balanceaccounts);

    /**
     * 批量删除平账
     * 
     * @param ids 需要删除的平账主键集合
     * @return 结果
     */
    public int deleteBalanceaccountsByIds(Long[] ids);

    /**
     * 删除平账信息
     * 
     * @param id 平账主键
     * @return 结果
     */
    public int deleteBalanceaccountsById(Long id);
}
