package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BalanceaccountsMapper;
import org.dzu.system.domain.Balanceaccounts;
import org.dzu.system.service.IBalanceaccountsService;

/**
 * 余额账户Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class BalanceaccountsServiceImpl implements IBalanceaccountsService 
{
    @Autowired
    private BalanceaccountsMapper balanceaccountsMapper;

    /**
     * 查询余额账户
     * 
     * @param id 余额账户主键
     * @return 余额账户
     */
    @Override
    public Balanceaccounts selectBalanceaccountsById(Long id)
    {
        return balanceaccountsMapper.selectBalanceaccountsById(id);
    }

    /**
     * 查询余额账户列表
     * 
     * @param balanceaccounts 余额账户
     * @return 余额账户
     */
    @Override
    public List<Balanceaccounts> selectBalanceaccountsList(Balanceaccounts balanceaccounts)
    {
        return balanceaccountsMapper.selectBalanceaccountsList(balanceaccounts);
    }

    /**
     * 新增余额账户
     * 
     * @param balanceaccounts 余额账户
     * @return 结果
     */
    @Override
    public int insertBalanceaccounts(Balanceaccounts balanceaccounts)
    {
        return balanceaccountsMapper.insertBalanceaccounts(balanceaccounts);
    }

    /**
     * 修改余额账户
     * 
     * @param balanceaccounts 余额账户
     * @return 结果
     */
    @Override
    public int updateBalanceaccounts(Balanceaccounts balanceaccounts)
    {
        balanceaccounts.setUpdateTime(DateUtils.getNowDate());
        return balanceaccountsMapper.updateBalanceaccounts(balanceaccounts);
    }

    /**
     * 批量删除余额账户
     * 
     * @param ids 需要删除的余额账户主键
     * @return 结果
     */
    @Override
    public int deleteBalanceaccountsByIds(Long[] ids)
    {
        return balanceaccountsMapper.deleteBalanceaccountsByIds(ids);
    }

    /**
     * 删除余额账户信息
     * 
     * @param id 余额账户主键
     * @return 结果
     */
    @Override
    public int deleteBalanceaccountsById(Long id)
    {
        return balanceaccountsMapper.deleteBalanceaccountsById(id);
    }
}
