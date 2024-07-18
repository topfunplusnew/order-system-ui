package org.dzu.system.service.impl;

import org.dzu.common.utils.DateUtils;
import org.dzu.system.domain.Bankaccountchange;
import org.dzu.system.mapper.BankaccountchangeMapper;
import org.dzu.system.service.IBankaccountchangeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 银行账号变更Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class BankaccountchangeServiceImpl implements IBankaccountchangeService 
{
    @Autowired
    private BankaccountchangeMapper bankaccountchangeMapper;

    /**
     * 查询银行账号变更
     * 
     * @param id 银行账号变更主键
     * @return 银行账号变更
     */
    @Override
    public Bankaccountchange selectBankaccountchangeById(Long id)
    {
        return bankaccountchangeMapper.selectBankaccountchangeById(id);
    }

    /**
     * 查询银行账号变更列表
     * 
     * @param bankaccountchange 银行账号变更
     * @return 银行账号变更
     */
    @Override
    public List<Bankaccountchange> selectBankaccountchangeList(Bankaccountchange bankaccountchange)
    {
        return bankaccountchangeMapper.selectBankaccountchangeList(bankaccountchange);
    }

    /**
     * 新增银行账号变更
     * 
     * @param bankaccountchange 银行账号变更
     * @return 结果
     */
    @Override
    public int insertBankaccountchange(Bankaccountchange bankaccountchange)
    {
        return bankaccountchangeMapper.insertBankaccountchange(bankaccountchange);
    }

    /**
     * 修改银行账号变更
     * 
     * @param bankaccountchange 银行账号变更
     * @return 结果
     */
    @Override
    public int updateBankaccountchange(Bankaccountchange bankaccountchange)
    {
        bankaccountchange.setUpdateTime(DateUtils.getNowDate());
        return bankaccountchangeMapper.updateBankaccountchange(bankaccountchange);
    }

    /**
     * 批量删除银行账号变更
     * 
     * @param ids 需要删除的银行账号变更主键
     * @return 结果
     */
    @Override
    public int deleteBankaccountchangeByIds(Long[] ids)
    {
        return bankaccountchangeMapper.deleteBankaccountchangeByIds(ids);
    }

    /**
     * 删除银行账号变更信息
     * 
     * @param id 银行账号变更主键
     * @return 结果
     */
    @Override
    public int deleteBankaccountchangeById(Long id)
    {
        return bankaccountchangeMapper.deleteBankaccountchangeById(id);
    }
}
