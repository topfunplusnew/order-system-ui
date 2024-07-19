package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Bankacceptance;

/**
 * 商业票据、银行承兑Service接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface IBankacceptanceService 
{
    /**
     * 查询商业票据、银行承兑
     * 
     * @param id 商业票据、银行承兑主键
     * @return 商业票据、银行承兑
     */
    public Bankacceptance selectBankacceptanceById(Long id);

    /**
     * 查询商业票据、银行承兑列表
     * 
     * @param bankacceptance 商业票据、银行承兑
     * @return 商业票据、银行承兑集合
     */
    public List<Bankacceptance> selectBankacceptanceList(Bankacceptance bankacceptance);

    /**
     * 新增商业票据、银行承兑
     * 
     * @param bankacceptance 商业票据、银行承兑
     * @return 结果
     */
    public int insertBankacceptance(Bankacceptance bankacceptance);

    /**
     * 修改商业票据、银行承兑
     * 
     * @param bankacceptance 商业票据、银行承兑
     * @return 结果
     */
    public int updateBankacceptance(Bankacceptance bankacceptance);

    /**
     * 批量删除商业票据、银行承兑
     * 
     * @param ids 需要删除的商业票据、银行承兑主键集合
     * @return 结果
     */
    public int deleteBankacceptanceByIds(Long[] ids);

    /**
     * 删除商业票据、银行承兑信息
     * 
     * @param id 商业票据、银行承兑主键
     * @return 结果
     */
    public int deleteBankacceptanceById(Long id);
}
