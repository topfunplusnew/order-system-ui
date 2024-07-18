package org.dzu.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BankaccountMapper;
import org.dzu.system.domain.Bankaccount;
import org.dzu.system.service.IBankaccountService;

/**
 * 银行账户Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class BankaccountServiceImpl implements IBankaccountService 
{
    @Autowired
    private BankaccountMapper bankaccountMapper;

    /**
     * 查询银行账户
     * 
     * @param id 银行账户主键
     * @return 银行账户
     */
    @Override
    public Bankaccount selectBankaccountById(Long id)
    {
        return bankaccountMapper.selectBankaccountById(id);
    }

    /**
     * 查询银行账户列表
     * 
     * @param bankaccount 银行账户
     * @return 银行账户
     */
    @Override
    public List<Bankaccount> selectBankaccountList(Bankaccount bankaccount)
    {
        return bankaccountMapper.selectBankaccountList(bankaccount);
    }

    /**
     * 新增银行账户
     * 
     * @param bankaccount 银行账户
     * @return 结果
     */
    @Override
    public int insertBankaccount(Bankaccount bankaccount)
    {
        return bankaccountMapper.insertBankaccount(bankaccount);
    }

    /**
     * 修改银行账户
     * 
     * @param bankaccount 银行账户
     * @return 结果
     */
    @Override
    public int updateBankaccount(Bankaccount bankaccount)
    {
        return bankaccountMapper.updateBankaccount(bankaccount);
    }

    /**
     * 批量删除银行账户
     * 
     * @param ids 需要删除的银行账户主键
     * @return 结果
     */
    @Override
    public int deleteBankaccountByIds(Long[] ids)
    {
        return bankaccountMapper.deleteBankaccountByIds(ids);
    }

    /**
     * 删除银行账户信息
     * 
     * @param id 银行账户主键
     * @return 结果
     */
    @Override
    public int deleteBankaccountById(Long id)
    {
        return bankaccountMapper.deleteBankaccountById(id);
    }
}
