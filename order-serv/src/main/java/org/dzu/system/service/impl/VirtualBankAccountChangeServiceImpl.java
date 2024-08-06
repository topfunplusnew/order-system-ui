package org.dzu.system.service.impl;

import java.util.List;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.BankChangeConstant;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.VirtualBankAccountChangeMapper;
import org.dzu.system.domain.VirtualBankAccountChange;
import org.dzu.system.service.IVirtualBankAccountChangeService;

/**
 * 虚拟银行账号Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class VirtualBankAccountChangeServiceImpl implements IVirtualBankAccountChangeService
{
    @Autowired
    private VirtualBankAccountChangeMapper virtualBankAccountChangeMapper;

    /**
     * 查询虚拟银行账号
     *
     * @param id 虚拟银行账号主键
     * @return 虚拟银行账号
     */
    @Override
    public VirtualBankAccountChange selectVirtualBankAccountChangeById(Long id)
    {
        return virtualBankAccountChangeMapper.selectVirtualBankAccountChangeById(id);
    }

    /**
     * 查询虚拟银行账号列表
     *
     * @param virtualBankAccountChange 虚拟银行账号
     * @return 虚拟银行账号
     */
    @Override
    public List<VirtualBankAccountChange> selectVirtualBankAccountChangeList(VirtualBankAccountChange virtualBankAccountChange)
    {
        return virtualBankAccountChangeMapper.selectVirtualBankAccountChangeList(virtualBankAccountChange);
    }

    /**
     * 新增虚拟银行账号
     *
     * @param virtualBankAccountChange 虚拟银行账号
     * @return 结果
     */
    @Override
    public int insertVirtualBankAccountChange(VirtualBankAccountChange virtualBankAccountChange)
    {
        virtualBankAccountChange.setAddtime(String.valueOf(DateUtils.getNowDate()));
        virtualBankAccountChange.setUserId(SecurityUtils.getUserId());
        virtualBankAccountChange.setUserName(SecurityUtils.getUserTruename());
        return virtualBankAccountChangeMapper.insertVirtualBankAccountChange(virtualBankAccountChange);
    }

    // 两个插入方法，但是相对于上面的插入，额外设置了类型
   @Override
    public int inserPayment(VirtualBankAccountChange virtualBankAccountChange)
    {
        virtualBankAccountChange.setChangeType(BankChangeConstant.PaymentType.PAYMENT.get());
        return insertVirtualBankAccountChange(virtualBankAccountChange);
    }

    @Override
    public int insertReceipt(VirtualBankAccountChange virtualBankAccountChange){
        virtualBankAccountChange.setChangeType(BankChangeConstant.PaymentType.RECEIPT.get());
        return insertVirtualBankAccountChange(virtualBankAccountChange);
    }


    /**
     * 修改虚拟银行账号
     *
     * @param virtualBankAccountChange 虚拟银行账号
     * @return 结果
     */
    @Override
    public int updateVirtualBankAccountChange(VirtualBankAccountChange virtualBankAccountChange)
    {
        virtualBankAccountChange.setUserId(SecurityUtils.getUserId());
        virtualBankAccountChange.setUserName(SecurityUtils.getUserTruename());
        virtualBankAccountChange.setUpdateTime(DateUtils.getNowDate());
        return virtualBankAccountChangeMapper.updateVirtualBankAccountChange(virtualBankAccountChange);
    }

    /**
     * 批量删除虚拟银行账号
     *
     * @param ids 需要删除的虚拟银行账号主键
     * @return 结果
     */
    @Override
    public int deleteVirtualBankAccountChangeByIds(Long[] ids)
    {
        return virtualBankAccountChangeMapper.deleteVirtualBankAccountChangeByIds(ids);
    }

    /**
     * 删除虚拟银行账号信息
     *
     * @param id 虚拟银行账号主键
     * @return 结果
     */
    @Override
    public int deleteVirtualBankAccountChangeById(Long id)
    {
        return virtualBankAccountChangeMapper.deleteVirtualBankAccountChangeById(id);
    }


   @Override
    public int delete(String tableName,String id){
    // 根据表名和id来删除
        QueryWrapper<VirtualBankAccountChange> query = new QueryWrapper<VirtualBankAccountChange>().eq("tableName", tableName).eq("payNO", id);
        return virtualBankAccountChangeMapper.delete(query);
    }
}
