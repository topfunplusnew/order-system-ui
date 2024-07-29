package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Bankaccount;

/**
 * 银行卡管理Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IBankaccountService 
{
    /**
     * 查询银行卡管理
     * 
     * @param id 银行卡管理主键
     * @return 银行卡管理
     */
    public Bankaccount selectBankaccountById(Long id);

    /**
     * 查询银行卡管理列表
     * 
     * @param bankaccount 银行卡管理
     * @return 银行卡管理集合
     */
    public List<Bankaccount> selectBankaccountList(Bankaccount bankaccount);

    /**
     * 新增银行卡管理
     * 
     * @param bankaccount 银行卡管理
     * @return 结果
     */
    public int insertBankaccount(Bankaccount bankaccount);

    /**
     * 修改银行卡管理
     * 
     * @param bankaccount 银行卡管理
     * @return 结果
     */
    public int updateBankaccount(Bankaccount bankaccount);

    /**
     * 批量删除银行卡管理
     * 
     * @param ids 需要删除的银行卡管理主键集合
     * @return 结果
     */
    public int deleteBankaccountByIds(Long[] ids);

    /**
     * 删除银行卡管理信息
     * 
     * @param id 银行卡管理主键
     * @return 结果
     */
    public int deleteBankaccountById(Long id);
}
