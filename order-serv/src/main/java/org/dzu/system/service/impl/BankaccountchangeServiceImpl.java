package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BankaccountchangeMapper;
import org.dzu.system.domain.Bankaccountchange;
import org.dzu.system.service.IBankaccountchangeService;
/**
 * 银行卡资金变动Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BankaccountchangeServiceImpl implements IBankaccountchangeService
{
    @Autowired
    private BankaccountchangeMapper bankaccountchangeMapper;

    /**
     * 查询银行卡资金变动
     *
     * @param id 银行卡资金变动主键
     * @return 银行卡资金变动
     */
    @Override
    public Bankaccountchange selectBankaccountchangeById(Long id)
    {
        return bankaccountchangeMapper.selectBankaccountchangeById(id);
    }

    /**
     * 查询银行卡资金变动列表
     *
     * @param bankaccountchange 银行卡资金变动
     * @return 银行卡资金变动
     */
    @Override
    public List<Bankaccountchange> selectBankaccountchangeList(Bankaccountchange bankaccountchange)
    {
        return bankaccountchangeMapper.selectBankaccountchangeList(bankaccountchange);
    }

    /**
     * 新增银行卡资金变动
     *
     * @param bankaccountchange 银行卡资金变动
     * @return 结果
     */
    @Override
    public int insertBankaccountchange(Bankaccountchange bankaccountchange)
    {
        bankaccountchange.setAddtime(String.valueOf(DateUtils.getNowDate()));
        bankaccountchange.setUserId(SecurityUtils.getUserId());
        bankaccountchange.setUserName(SecurityUtils.getUserTruename());
        return bankaccountchangeMapper.insertBankaccountchange(bankaccountchange);
    }

    /**
     * 修改银行卡资金变动
     * 
     * @param bankaccountchange 银行卡资金变动
     * @return 结果
     */
    @Override
    public int updateBankaccountchange(Bankaccountchange bankaccountchange)
    {
        bankaccountchange.setUserId(SecurityUtils.getUserId());
        bankaccountchange.setUserName(SecurityUtils.getUserTruename());
        bankaccountchange.setUpdateTime(DateUtils.getNowDate());
        return bankaccountchangeMapper.updateBankaccountchange(bankaccountchange);
    }

    /**
     * 批量删除银行卡资金变动
     * 
     * @param ids 需要删除的银行卡资金变动主键
     * @return 结果
     */
    @Override
    public int deleteBankaccountchangeByIds(Long[] ids)
    {
        return bankaccountchangeMapper.deleteBankaccountchangeByIds(ids);
    }

    /**
     * 删除银行卡资金变动信息
     * 
     * @param id 银行卡资金变动主键
     * @return 结果
     */
    @Override
    public int deleteBankaccountchangeById(Long id)
    {
        return bankaccountchangeMapper.deleteBankaccountchangeById(id);
    }
}
