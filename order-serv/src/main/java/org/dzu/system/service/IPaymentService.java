package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Payment;

/**
 * 资产管理-收付款:收付款信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IPaymentService 
{
    /**
     * 查询资产管理-收付款:收付款信息
     * 
     * @param id 资产管理-收付款:收付款信息主键
     * @return 资产管理-收付款:收付款信息
     */
    public Payment selectPaymentById(Long id);

    /**
     * 查询资产管理-收付款:收付款信息列表
     * 
     * @param payment 资产管理-收付款:收付款信息
     * @return 资产管理-收付款:收付款信息集合
     */
    public List<Payment> selectPaymentList(Payment payment);

    /**
     * 新增资产管理-收付款:收付款信息
     * 
     * @param payment 资产管理-收付款:收付款信息
     * @return 结果
     */
    public int insertPayment(Payment payment);

    /**
     * 修改资产管理-收付款:收付款信息
     * 
     * @param payment 资产管理-收付款:收付款信息
     * @return 结果
     */
    public int updatePayment(Payment payment);

    /**
     * 批量删除资产管理-收付款:收付款信息
     * 
     * @param ids 需要删除的资产管理-收付款:收付款信息主键集合
     * @return 结果
     */
    public int deletePaymentByIds(Long[] ids);

    /**
     * 删除资产管理-收付款:收付款信息信息
     * 
     * @param id 资产管理-收付款:收付款信息主键
     * @return 结果
     */
    public int deletePaymentById(Long id);
}
