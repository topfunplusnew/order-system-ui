package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.Bankacceptance;

/**
 * 银行承兑Service接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface IBankacceptanceService 
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
     * 批量删除银行承兑
     * 
     * @param ids 需要删除的银行承兑主键集合
     * @return 结果
     */
    public int deleteBankacceptanceByIds(Long[] ids);

    /**
     * 删除银行承兑信息
     * 
     * @param id 银行承兑主键
     * @return 结果
     */
    public int deleteBankacceptanceById(Long id);
}
