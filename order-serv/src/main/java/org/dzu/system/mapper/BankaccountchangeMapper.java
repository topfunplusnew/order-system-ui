package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Bankaccountchange;

/**
 * 银行卡资金变动Mapper接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface BankaccountchangeMapper 
{
    /**
     * 查询银行卡资金变动
     * 
     * @param id 银行卡资金变动主键
     * @return 银行卡资金变动
     */
    public Bankaccountchange selectBankaccountchangeById(Long id);

    /**
     * 查询银行卡资金变动列表
     * 
     * @param bankaccountchange 银行卡资金变动
     * @return 银行卡资金变动集合
     */
    public List<Bankaccountchange> selectBankaccountchangeList(Bankaccountchange bankaccountchange);

    /**
     * 新增银行卡资金变动
     * 
     * @param bankaccountchange 银行卡资金变动
     * @return 结果
     */
    public int insertBankaccountchange(Bankaccountchange bankaccountchange);

    /**
     * 修改银行卡资金变动
     * 
     * @param bankaccountchange 银行卡资金变动
     * @return 结果
     */
    public int updateBankaccountchange(Bankaccountchange bankaccountchange);

    /**
     * 删除银行卡资金变动
     * 
     * @param id 银行卡资金变动主键
     * @return 结果
     */
    public int deleteBankaccountchangeById(Long id);

    /**
     * 批量删除银行卡资金变动
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBankaccountchangeByIds(Long[] ids);
}
