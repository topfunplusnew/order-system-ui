package org.dzu.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BankAccountMapper;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.service.IBankAccountService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 银行账号Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BankAccountServiceImpl implements IBankAccountService
{
    @Autowired
    private BankAccountMapper bankAccountMapper;

    /**
     * 查询银行账号
     *
     * @param id 银行账号主键
     * @return 银行账号
     */
    @Override
    public BankAccount selectBankAccountById(Long id)
    {
        return bankAccountMapper.selectBankAccountById(id);
    }

    /**
     * 查询银行账号列表
     *
     * @param bankAccount 银行账号
     * @return 银行账号
     */
    @Override
    public List<BankAccount> selectBankAccountList(BankAccount bankAccount)
    {
        return bankAccountMapper.selectBankAccountList(bankAccount);
    }

    /**
     * 新增银行账号
     *
     * @param bankAccount 银行账号
     * @return 结果
     */
    @Override
    public int insertBankAccount(BankAccount bankAccount)
    {
        bankAccount.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return bankAccountMapper.insertBankAccount(bankAccount);
    }

    /**
     * 修改银行账号
     * 
     * @param bankAccount 银行账号
     * @return 结果
     */
    @Override
    public int updateBankAccount(BankAccount bankAccount)
    {
        return bankAccountMapper.updateBankAccount(bankAccount);
    }

    /**
     * 批量删除银行账号
     * 
     * @param ids 需要删除的银行账号主键
     * @return 结果
     */
    @Override
    public int deleteBankAccountByIds(Long[] ids)
    {
        return bankAccountMapper.deleteBankAccountByIds(ids);
    }

    /**
     * 删除银行账号信息
     * 
     * @param id 银行账号主键
     * @return 结果
     */
    @Override
    public int deleteBankAccountById(Long id)
    {
        return bankAccountMapper.deleteBankAccountById(id);
    }
}
