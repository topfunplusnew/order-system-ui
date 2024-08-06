package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BankAcceptanceMapper;
import org.dzu.system.domain.BankAcceptance;
import org.dzu.system.service.IBankAcceptanceService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 商业票据、银行承兑Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BankAcceptanceServiceImpl implements IBankAcceptanceService
{
    @Autowired
    private BankAcceptanceMapper bankAcceptanceMapper;

    /**
     * 查询商业票据、银行承兑
     *
     * @param id 商业票据、银行承兑主键
     * @return 商业票据、银行承兑
     */
    @Override
    public BankAcceptance selectBankAcceptanceById(Long id)
    {
        return bankAcceptanceMapper.selectBankAcceptanceById(id);
    }

    /**
     * 查询商业票据、银行承兑列表
     *
     * @param bankAcceptance 商业票据、银行承兑
     * @return 商业票据、银行承兑
     */
    @Override
    public List<BankAcceptance> selectBankAcceptanceList(BankAcceptance bankAcceptance)
    {
        return bankAcceptanceMapper.selectBankAcceptanceList(bankAcceptance);
    }

    /**
     * 新增商业票据、银行承兑
     *
     * @param bankAcceptance 商业票据、银行承兑
     * @return 结果
     */
    @Override
    public int insertBankAcceptance(BankAcceptance bankAcceptance)
    {
        bankAcceptance.setAddtime(String.valueOf(DateUtils.getNowDate()));
        bankAcceptance.setUserId(SecurityUtils.getUserId());
        bankAcceptance.setUserName(SecurityUtils.getUserTruename());
        bankAcceptance.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return bankAcceptanceMapper.insertBankAcceptance(bankAcceptance);
    }

    /**
     * 修改商业票据、银行承兑
     * 
     * @param bankAcceptance 商业票据、银行承兑
     * @return 结果
     */
    @Override
    public int updateBankAcceptance(BankAcceptance bankAcceptance)
    {

        return bankAcceptanceMapper.updateBankAcceptance(bankAcceptance);
    }

    /**
     * 批量删除商业票据、银行承兑
     * 
     * @param ids 需要删除的商业票据、银行承兑主键
     * @return 结果
     */
    @Override
    public int deleteBankAcceptanceByIds(Long[] ids)
    {
        return bankAcceptanceMapper.deleteBankAcceptanceByIds(ids);
    }

    /**
     * 删除商业票据、银行承兑信息
     * 
     * @param id 商业票据、银行承兑主键
     * @return 结果
     */
    @Override
    public int deleteBankAcceptanceById(Long id)
    {
        return bankAcceptanceMapper.deleteBankAcceptanceById(id);
    }
}
