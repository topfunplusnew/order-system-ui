package org.dzu.system.service;

import org.dzu.system.domain.VirtualBankAccountChange;

import java.util.List;

/**
 * 虚拟银行账号Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IVirtualBankAccountChangeService 
{
    /**
     * 查询虚拟银行账号
     * 
     * @param id 虚拟银行账号主键
     * @return 虚拟银行账号
     */
    public VirtualBankAccountChange selectVirtualBankAccountChangeById(Long id);

    /**
     * 查询虚拟银行账号列表
     * 
     * @param virtualBankAccountChange 虚拟银行账号
     * @return 虚拟银行账号集合
     */
    public List<VirtualBankAccountChange> selectVirtualBankAccountChangeList(VirtualBankAccountChange virtualBankAccountChange);

    /**
     * 新增虚拟银行账号
     * 
     * @param virtualBankAccountChange 虚拟银行账号
     * @return 结果
     */
    public int insertVirtualBankAccountChange(VirtualBankAccountChange virtualBankAccountChange);

    // 两个插入方法，但是相对于上面的插入，额外设置了类型
    int inserPayment(VirtualBankAccountChange virtualBankAccountChange);

    int insertReceipt(VirtualBankAccountChange virtualBankAccountChange);

    /**
     * 修改虚拟银行账号
     * 
     * @param virtualBankAccountChange 虚拟银行账号
     * @return 结果
     */
    public int updateVirtualBankAccountChange(VirtualBankAccountChange virtualBankAccountChange);

    /**
     * 批量删除虚拟银行账号
     * 
     * @param ids 需要删除的虚拟银行账号主键集合
     * @return 结果
     */
    public int deleteVirtualBankAccountChangeByIds(Long[] ids);

    /**
     * 删除虚拟银行账号信息
     * 
     * @param id 虚拟银行账号主键
     * @return 结果
     */
    public int deleteVirtualBankAccountChangeById(Long id);

    int delete(String tableName, String id);
}
