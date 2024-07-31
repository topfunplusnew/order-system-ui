package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BankAccountChangeMapper;
import org.dzu.system.domain.BankAccountChange;
import org.dzu.system.service.IBankAccountChangeService;
/**
 * 银行账号变动流水Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BankAccountChangeServiceImpl implements IBankAccountChangeService
{
    @Autowired
    private BankAccountChangeMapper bankAccountChangeMapper;

    /**
     * 查询银行账号变动流水
     *
     * @param id 银行账号变动流水主键
     * @return 银行账号变动流水
     */
    @Override
    public BankAccountChange selectBankAccountChangeById(Long id)
    {
        return bankAccountChangeMapper.selectBankAccountChangeById(id);
    }

    /**
     * 查询银行账号变动流水列表
     *
     * @param bankAccountChange 银行账号变动流水
     * @return 银行账号变动流水
     */
    @Override
    public List<BankAccountChange> selectBankAccountChangeList(BankAccountChange bankAccountChange)
    {
        return bankAccountChangeMapper.selectBankAccountChangeList(bankAccountChange);
    }

    /**
     * 新增银行账号变动流水
     *
     * @param bankAccountChange 银行账号变动流水
     * @return 结果
     */
    @Override
    public int insertBankAccountChange(BankAccountChange bankAccountChange)
    {
        bankAccountChange.setAddtime(String.valueOf(DateUtils.getNowDate()));
        bankAccountChange.setUserId(SecurityUtils.getUserId());
        bankAccountChange.setUserName(SecurityUtils.getUserTruename());
        bankAccountChange.setOperateDate(String.valueOf(DateUtils.getNowDate()));
        return bankAccountChangeMapper.insertBankAccountChange(bankAccountChange);
    }

    /**
     * 修改银行账号变动流水
     * 
     * @param bankAccountChange 银行账号变动流水
     * @return 结果
     */
    @Override
    public int updateBankAccountChange(BankAccountChange bankAccountChange)
    {
        bankAccountChange.setUserId(SecurityUtils.getUserId());
        bankAccountChange.setUserName(SecurityUtils.getUserTruename());
        bankAccountChange.setUpdateTime(DateUtils.getNowDate());
        bankAccountChange.setOperateDate(String.valueOf(DateUtils.getNowDate()));
        return bankAccountChangeMapper.updateBankAccountChange(bankAccountChange);
    }

    /**
     * 批量删除银行账号变动流水
     * 
     * @param ids 需要删除的银行账号变动流水主键
     * @return 结果
     */
    @Override
    public int deleteBankAccountChangeByIds(Long[] ids)
    {
        return bankAccountChangeMapper.deleteBankAccountChangeByIds(ids);
    }


    /**
     * 通过UUID更新变动信息
     * @param bankAccountChange
     * @return
     */
    @Override
    public int updateBankAccountChangeByUUID(BankAccountChange bankAccountChange) {
        return bankAccountChangeMapper.updateBankAccountChangeByUUID(bankAccountChange);
    }

    @Override
    public int deleteBankAccountChangeByUUID(String[] uuids){
        return bankAccountChangeMapper.deleteBankAccountChangeByUUIDS(uuids);
    }

}
