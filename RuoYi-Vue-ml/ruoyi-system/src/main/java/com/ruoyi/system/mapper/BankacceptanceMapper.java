package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.Bankacceptance;

/**
 * 银行承兑Mapper接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface BankacceptanceMapper 
{
    /**
     * 查询银行承兑
     * 
     * @param id 银行承兑主键
     * @return 银行承兑
     */
    public Bankacceptance selectBankacceptanceById(Long id);

    /**
     * 查询银行承兑列表
     * 
     * @param bankacceptance 银行承兑
     * @return 银行承兑集合
     */
    public List<Bankacceptance> selectBankacceptanceList(Bankacceptance bankacceptance);

    /**
     * 新增银行承兑
     * 
     * @param bankacceptance 银行承兑
     * @return 结果
     */
    public int insertBankacceptance(Bankacceptance bankacceptance);

    /**
     * 修改银行承兑
     * 
     * @param bankacceptance 银行承兑
     * @return 结果
     */
    public int updateBankacceptance(Bankacceptance bankacceptance);

    /**
     * 删除银行承兑
     * 
     * @param id 银行承兑主键
     * @return 结果
     */
    public int deleteBankacceptanceById(Long id);

    /**
     * 批量删除银行承兑
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBankacceptanceByIds(Long[] ids);
}
