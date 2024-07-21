package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.BankacceptanceMapper;
import com.ruoyi.system.domain.Bankacceptance;
import com.ruoyi.system.service.IBankacceptanceService;

/**
 * 银行承兑Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class BankacceptanceServiceImpl implements IBankacceptanceService 
{
    @Autowired
    private BankacceptanceMapper bankacceptanceMapper;

    /**
     * 查询银行承兑
     * 
     * @param id 银行承兑主键
     * @return 银行承兑
     */
    @Override
    public Bankacceptance selectBankacceptanceById(Long id)
    {
        return bankacceptanceMapper.selectBankacceptanceById(id);
    }

    /**
     * 查询银行承兑列表
     * 
     * @param bankacceptance 银行承兑
     * @return 银行承兑
     */
    @Override
    public List<Bankacceptance> selectBankacceptanceList(Bankacceptance bankacceptance)
    {
        return bankacceptanceMapper.selectBankacceptanceList(bankacceptance);
    }

    /**
     * 新增银行承兑
     * 
     * @param bankacceptance 银行承兑
     * @return 结果
     */
    @Override
    public int insertBankacceptance(Bankacceptance bankacceptance)
    {
        return bankacceptanceMapper.insertBankacceptance(bankacceptance);
    }

    /**
     * 修改银行承兑
     * 
     * @param bankacceptance 银行承兑
     * @return 结果
     */
    @Override
    public int updateBankacceptance(Bankacceptance bankacceptance)
    {
        bankacceptance.setUpdateTime(DateUtils.getNowDate());
        return bankacceptanceMapper.updateBankacceptance(bankacceptance);
    }

    /**
     * 批量删除银行承兑
     * 
     * @param ids 需要删除的银行承兑主键
     * @return 结果
     */
    @Override
    public int deleteBankacceptanceByIds(Long[] ids)
    {
        return bankacceptanceMapper.deleteBankacceptanceByIds(ids);
    }

    /**
     * 删除银行承兑信息
     * 
     * @param id 银行承兑主键
     * @return 结果
     */
    @Override
    public int deleteBankacceptanceById(Long id)
    {
        return bankacceptanceMapper.deleteBankacceptanceById(id);
    }
}
