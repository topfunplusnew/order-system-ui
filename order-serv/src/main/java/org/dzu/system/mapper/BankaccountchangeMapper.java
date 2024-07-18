package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Bankaccountchange;

/**
 * 银行账号变更Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface BankaccountchangeMapper 
{
    /**
     * 查询银行账号变更
     * 
     * @param id 银行账号变更主键
     * @return 银行账号变更
     */
    public Bankaccountchange selectBankaccountchangeById(Long id);

    /**
     * 查询银行账号变更列表
     * 
     * @param bankaccountchange 银行账号变更
     * @return 银行账号变更集合
     */
    public List<Bankaccountchange> selectBankaccountchangeList(Bankaccountchange bankaccountchange);

    /**
     * 新增银行账号变更
     * 
     * @param bankaccountchange 银行账号变更
     * @return 结果
     */
    public int insertBankaccountchange(Bankaccountchange bankaccountchange);

    /**
     * 修改银行账号变更
     * 
     * @param bankaccountchange 银行账号变更
     * @return 结果
     */
    public int updateBankaccountchange(Bankaccountchange bankaccountchange);

    /**
     * 删除银行账号变更
     * 
     * @param id 银行账号变更主键
     * @return 结果
     */
    public int deleteBankaccountchangeById(Long id);

    /**
     * 批量删除银行账号变更
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBankaccountchangeByIds(Long[] ids);
}
