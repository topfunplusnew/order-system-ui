package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.BankChangeConstant;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.BankAccountChange;
import org.dzu.system.mapper.BankAccountChangeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 银行账号变动流水Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BankAccountChangeServiceImpl {
    @Autowired
    private BankAccountChangeMapper bankAccountChangeMapper;

    /**
     * 查询银行账号变动流水
     *
     * @param id 银行账号变动流水主键
     * @return 银行账号变动流水
     */
    public BankAccountChange selectBankAccountChangeById(Long id) {
        return bankAccountChangeMapper.selectBankAccountChangeById(id);
    }

    /**
     * 查询银行账号变动流水列表
     *
     * @param bankAccountChange 银行账号变动流水
     * @return 银行账号变动流水
     */
    public List<BankAccountChange> selectBankAccountChangeList(BankAccountChange bankAccountChange) {
        return bankAccountChangeMapper.selectBankAccountChangeList(bankAccountChange);
    }

    /**
     * 新增银行账号变动流水
     *
     * @param bankAccountChange 银行账号变动流水
     * @return 结果
     */
    public int insertBankAccountChange(BankAccountChange bankAccountChange) {
        bankAccountChange.setAddtime(String.valueOf(DateUtils.getNowDate()));
        bankAccountChange.setUserId(SecurityUtils.getUserId());
        bankAccountChange.setUserName(SecurityUtils.getUserTruename());
        bankAccountChange.setOperateDate(String.valueOf(DateUtils.getNowDate()));
        return bankAccountChangeMapper.insertBankAccountChange(bankAccountChange);
    }

    /**
     * 插入付款变动流水
     *
     * @param bankAccountChange
     * @return
     */
    public int insertPaymenyChange(BankAccountChange bankAccountChange) {
        bankAccountChange.setChangeType(BankChangeConstant.PaymentType.PAYMENT.get());
        return insertBankAccountChange(bankAccountChange);
    }

    /**
     * 插入收款变动流水
     *
     * @param bankAccountChange
     * @return
     */
    public int insertReceiptChange(BankAccountChange bankAccountChange) {
        bankAccountChange.setChangeType(BankChangeConstant.PaymentType.RECEIPT.get());
        return insertBankAccountChange(bankAccountChange);
    }

    /**
     * 修改银行账号变动流水
     *
     * @param bankAccountChange 银行账号变动流水
     * @return 结果
     */
    public int updateBankAccountChange(BankAccountChange bankAccountChange) {
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
    public int deleteBankAccountChangeByIds(Long[] ids) {
        return bankAccountChangeMapper.deleteBankAccountChangeByIds(ids);
    }


    /**
     * 通过UUID更新变动信息
     *
     * @param bankAccountChange
     * @return
     */
    public int updateBankAccountChangeByUUID(BankAccountChange bankAccountChange) {
        return bankAccountChangeMapper.updateBankAccountChangeByUUID(bankAccountChange);
    }

    public int deleteBankAccountChangeByUUID(String[] uuids) {
        return bankAccountChangeMapper.deleteBankAccountChangeByUUIDS(uuids);
    }


    // 通过指定表名和对应主键和支付类型来删除
    public int deleteChange(String tableName, String id, String type) {
        QueryWrapper<BankAccountChange> query = new QueryWrapper<BankAccountChange>().eq("tableName", tableName).eq("payNO", id).eq("changeType", type);
        return bankAccountChangeMapper.delete(query);
    }

    // 通过指定表名和主键来删除
    public int deleteChange(String tableName, String id) {
        QueryWrapper<BankAccountChange> query = new QueryWrapper<BankAccountChange>().eq("tableName", tableName).eq("payNO", id);
        return bankAccountChangeMapper.delete(query);
    }


}
