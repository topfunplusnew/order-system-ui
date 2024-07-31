package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.BankAccount;

/**
 * 银行账号Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IBankAccountService 
{
    /**
     * 查询银行账号
     * 
     * @param bankNo 银行账号主键
     * @return 银行账号
     */
    public BankAccount selectBankAccountByBankNo(String bankNo);

    /**
     * 查询银行账号
     *
     * @param id 银行账号主键
     * @return 银行账号
     */
    public BankAccount selectBankAccountById(Long id);
    /**
     * 查询银行账号列表
     * 
     * @param bankAccount 银行账号
     * @return 银行账号集合
     */
    public List<BankAccount> selectBankAccountList(BankAccount bankAccount);

    /**
     * 新增银行账号
     * 
     * @param bankAccount 银行账号
     * @return 结果
     */
    public int insertBankAccount(BankAccount bankAccount);

    /**
     * 修改银行账号
     * 
     * @param bankAccount 银行账号
     * @return 结果
     */
    public int updateBankAccount(BankAccount bankAccount);

    /**
     * 批量删除银行账号
     * 
     * @param ids 需要删除的银行账号主键集合
     * @return 结果
     */
    public int deleteBankAccountByIds(Long[] ids);

    /**
     * 删除银行账号信息
     * 
     * @param id 银行账号主键
     * @return 结果
     */
    public int deleteBankAccountById(Long id);
}
