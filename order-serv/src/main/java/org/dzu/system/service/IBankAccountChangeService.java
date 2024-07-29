package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.BankAccountChange;

/**
 * 银行账号变动流水Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IBankAccountChangeService 
{
    /**
     * 查询银行账号变动流水
     * 
     * @param id 银行账号变动流水主键
     * @return 银行账号变动流水
     */
    public BankAccountChange selectBankAccountChangeById(Long id);

    /**
     * 查询银行账号变动流水列表
     * 
     * @param bankAccountChange 银行账号变动流水
     * @return 银行账号变动流水集合
     */
    public List<BankAccountChange> selectBankAccountChangeList(BankAccountChange bankAccountChange);

    /**
     * 新增银行账号变动流水
     * 
     * @param bankAccountChange 银行账号变动流水
     * @return 结果
     */
    public int insertBankAccountChange(BankAccountChange bankAccountChange);

    /**
     * 修改银行账号变动流水
     * 
     * @param bankAccountChange 银行账号变动流水
     * @return 结果
     */
    public int updateBankAccountChange(BankAccountChange bankAccountChange);

    /**
     * 批量删除银行账号变动流水
     * 
     * @param ids 需要删除的银行账号变动流水主键集合
     * @return 结果
     */
    public int deleteBankAccountChangeByIds(Long[] ids);

    /**
     * 删除银行账号变动流水信息
     * 
     * @param id 银行账号变动流水主键
     * @return 结果
     */
    public int deleteBankAccountChangeById(Long id);
}
