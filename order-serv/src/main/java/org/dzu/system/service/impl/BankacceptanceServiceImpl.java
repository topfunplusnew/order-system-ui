package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BankacceptanceMapper;
import org.dzu.system.domain.Bankacceptance;
import org.dzu.system.service.IBankacceptanceService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 商业票据、银行承兑Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BankacceptanceServiceImpl implements IBankacceptanceService
{
    @Autowired
    private BankacceptanceMapper bankacceptanceMapper;

    /**
     * 查询商业票据、银行承兑
     *
     * @param id 商业票据、银行承兑主键
     * @return 商业票据、银行承兑
     */
    @Override
    public Bankacceptance selectBankacceptanceById(Long id)
    {
        return bankacceptanceMapper.selectBankacceptanceById(id);
    }

    /**
     * 查询商业票据、银行承兑列表
     *
     * @param bankacceptance 商业票据、银行承兑
     * @return 商业票据、银行承兑
     */
    @Override
    public List<Bankacceptance> selectBankacceptanceList(Bankacceptance bankacceptance)
    {
        return bankacceptanceMapper.selectBankacceptanceList(bankacceptance);
    }

    /**
     * 新增商业票据、银行承兑
     *
     * @param bankacceptance 商业票据、银行承兑
     * @return 结果
     */
    @Override
    public int insertBankacceptance(Bankacceptance bankacceptance)
    {
        bankacceptance.setAddtime(String.valueOf(DateUtils.getNowDate()));
        bankacceptance.setUserId(SecurityUtils.getUserId());
        bankacceptance.setUserName(SecurityUtils.getUserTruename());
        bankacceptance.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return bankacceptanceMapper.insertBankacceptance(bankacceptance);
    }

    /**
     * 修改商业票据、银行承兑
     * 
     * @param bankacceptance 商业票据、银行承兑
     * @return 结果
     */
    @Override
    public int updateBankacceptance(Bankacceptance bankacceptance)
    {
        bankacceptance.setUserId(SecurityUtils.getUserId());
        bankacceptance.setUserName(SecurityUtils.getUserTruename());
        bankacceptance.setUpdateTime(DateUtils.getNowDate());
        return bankacceptanceMapper.updateBankacceptance(bankacceptance);
    }

    /**
     * 批量删除商业票据、银行承兑
     * 
     * @param ids 需要删除的商业票据、银行承兑主键
     * @return 结果
     */
    @Override
    public int deleteBankacceptanceByIds(Long[] ids)
    {
        return bankacceptanceMapper.deleteBankacceptanceByIds(ids);

    }

    /**
     * 删除商业票据、银行承兑信息
     * 
     * @param id 商业票据、银行承兑主键
     * @return 结果
     */
    @Override
    public int deleteBankacceptanceById(Long id)
    {
        return bankacceptanceMapper.deleteBankacceptanceById(id);
    }
}
