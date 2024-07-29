package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Bankacceptance;

/**
 * 商业票据、银行承兑Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface BankacceptanceMapper 
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
     * 删除商业票据、银行承兑
     * 
     * @param id 商业票据、银行承兑主键
     * @return 结果
     */
    public int deleteBankacceptanceById(Long id);

    /**
     * 批量删除商业票据、银行承兑
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBankacceptanceByIds(Long[] ids);
}
