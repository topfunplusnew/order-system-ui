package org.dzu.system.mapper;

import org.dzu.system.domain.Balanceaccounts;

import java.util.List;

/**
 * 余额账户Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface BalanceaccountsMapper 
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
     * 删除余额账户
     * 
     * @param id 余额账户主键
     * @return 结果
     */
    public int deleteBalanceaccountsById(Long id);

    /**
     * 批量删除余额账户
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBalanceaccountsByIds(Long[] ids);
}
