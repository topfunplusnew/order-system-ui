package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.Bankaccount;

/**
 * 银行账户Service接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface IBankaccountService 
{
    /**
     * 查询银行账户
     * 
     * @param id 银行账户主键
     * @return 银行账户
     */
    public Bankaccount selectBankaccountById(Long id);

    /**
     * 查询银行账户列表
     * 
     * @param bankaccount 银行账户
     * @return 银行账户集合
     */
    public List<Bankaccount> selectBankaccountList(Bankaccount bankaccount);

    /**
     * 新增银行账户
     * 
     * @param bankaccount 银行账户
     * @return 结果
     */
    public int insertBankaccount(Bankaccount bankaccount);

    /**
     * 修改银行账户
     * 
     * @param bankaccount 银行账户
     * @return 结果
     */
    public int updateBankaccount(Bankaccount bankaccount);

    /**
     * 批量删除银行账户
     * 
     * @param ids 需要删除的银行账户主键集合
     * @return 结果
     */
    public int deleteBankaccountByIds(Long[] ids);

    /**
     * 删除银行账户信息
     * 
     * @param id 银行账户主键
     * @return 结果
     */
    public int deleteBankaccountById(Long id);
}
