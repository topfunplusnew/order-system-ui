package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Balanceaccounts;

/**
 * 余额账户Service接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface IBalanceaccountsService 
{
    /**
     * 查询余额账户
     * 
     * @param id 余额账户主键
     * @return 余额账户
     */
    public Balanceaccounts selectBalanceaccountsById(Long id);

    /**
     * 查询余额账户列表
     * 
     * @param balanceaccounts 余额账户
     * @return 余额账户集合
     */
    public List<Balanceaccounts> selectBalanceaccountsList(Balanceaccounts balanceaccounts);

    /**
     * 新增余额账户
     * 
     * @param balanceaccounts 余额账户
     * @return 结果
     */
    public int insertBalanceaccounts(Balanceaccounts balanceaccounts);

    /**
     * 修改余额账户
     * 
     * @param balanceaccounts 余额账户
     * @return 结果
     */
    public int updateBalanceaccounts(Balanceaccounts balanceaccounts);

    /**
     * 批量删除余额账户
     * 
     * @param ids 需要删除的余额账户主键集合
     * @return 结果
     */
    public int deleteBalanceaccountsByIds(Long[] ids);

    /**
     * 删除余额账户信息
     * 
     * @param id 余额账户主键
     * @return 结果
     */
    public int deleteBalanceaccountsById(Long id);
}
