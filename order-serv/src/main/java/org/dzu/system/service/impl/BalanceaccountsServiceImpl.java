package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BalanceaccountsMapper;
import org.dzu.system.domain.Balanceaccounts;
import org.dzu.system.service.IBalanceaccountsService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 平账Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BalanceaccountsServiceImpl implements IBalanceaccountsService
{
    @Autowired
    private BalanceaccountsMapper balanceaccountsMapper;

    /**
     * 查询平账
     *
     * @param id 平账主键
     * @return 平账
     */
    @Override
    public Balanceaccounts selectBalanceaccountsById(Long id)
    {
        return balanceaccountsMapper.selectBalanceaccountsById(id);
    }

    /**
     * 查询平账列表
     *
     * @param balanceaccounts 平账
     * @return 平账
     */
    @Override
    public List<Balanceaccounts> selectBalanceaccountsList(Balanceaccounts balanceaccounts)
    {
        return balanceaccountsMapper.selectBalanceaccountsList(balanceaccounts);
    }

    /**
     * 新增平账
     *
     * @param balanceaccounts 平账
     * @return 结果
     */
    @Override
    public int insertBalanceaccounts(Balanceaccounts balanceaccounts)
    {
        balanceaccounts.setAddtime(String.valueOf(DateUtils.getNowDate()));
        balanceaccounts.setUserId(SecurityUtils.getUserId());
        balanceaccounts.setUserName(SecurityUtils.getUserTruename());
        balanceaccounts.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return balanceaccountsMapper.insertBalanceaccounts(balanceaccounts);
    }

    /**
     * 修改平账
     * 
     * @param balanceaccounts 平账
     * @return 结果
     */
    @Override
    public int updateBalanceaccounts(Balanceaccounts balanceaccounts)
    {
        balanceaccounts.setUserId(SecurityUtils.getUserId());
        balanceaccounts.setUserName(SecurityUtils.getUserTruename());
        balanceaccounts.setUpdateTime(DateUtils.getNowDate());
        return balanceaccountsMapper.updateBalanceaccounts(balanceaccounts);
    }

    /**
     * 批量删除平账
     * 
     * @param ids 需要删除的平账主键
     * @return 结果
     */
    @Override
    public int deleteBalanceaccountsByIds(Long[] ids)
    {
        return balanceaccountsMapper.deleteBalanceaccountsByIds(ids);
    }

    /**
     * 删除平账信息
     * 
     * @param id 平账主键
     * @return 结果
     */
    @Override
    public int deleteBalanceaccountsById(Long id)
    {
        return balanceaccountsMapper.deleteBalanceaccountsById(id);
    }
}
