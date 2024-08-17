package org.dzu.system.service;

import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.vo.TranseferMoney;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

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

    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class)
    int insertCompanyDefaultBankAccount(BankAccount bankAccount);

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

    // 提供接口允许两个银行卡进行转账
    TranseferMoney transferMoney(TranseferMoney transeferMoney);
}
