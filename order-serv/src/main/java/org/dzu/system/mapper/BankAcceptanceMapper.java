package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.BankAcceptance;

import java.util.List;

/**
 * 商业票据、银行承兑Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface BankAcceptanceMapper extends BaseMapper<BankAcceptance>
{
    /**
     * 查询商业票据、银行承兑
     * 
     * @param id 商业票据、银行承兑主键
     * @return 商业票据、银行承兑
     */
    public BankAcceptance selectBankAcceptanceById(Long id);

    /**
     * 查询商业票据、银行承兑列表
     * 
     * @param bankAcceptance 商业票据、银行承兑
     * @return 商业票据、银行承兑集合
     */
    public List<BankAcceptance> selectBankAcceptanceList(BankAcceptance bankAcceptance);

    /**
     * 新增商业票据、银行承兑
     * 
     * @param bankAcceptance 商业票据、银行承兑
     * @return 结果
     */
    public int insertBankAcceptance(BankAcceptance bankAcceptance);

    /**
     * 修改商业票据、银行承兑
     * 
     * @param bankAcceptance 商业票据、银行承兑
     * @return 结果
     */
    public int updateBankAcceptance(BankAcceptance bankAcceptance);

    /**
     * 删除商业票据、银行承兑
     * 
     * @param id 商业票据、银行承兑主键
     * @return 结果
     */
    public int deleteBankAcceptanceById(Long id);

    /**
     * 批量删除商业票据、银行承兑
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBankAcceptanceByIds(Long[] ids);
}
