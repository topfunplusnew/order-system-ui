package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.PaymentApply;

/**
 * 付款信息Service接口
 * 
 * @author ml
 * @date 2024-08-01
 */
public interface IPaymentApplyService 
{
    /**
     * 查询付款信息
     * 
     * @param id 付款信息主键
     * @return 付款信息
     */
    public PaymentApply selectPaymentApplyById(Long id);

    /**
     * 查询付款信息列表
     * 
     * @param paymentApply 付款信息
     * @return 付款信息集合
     */
    public List<PaymentApply> selectPaymentApplyList(PaymentApply paymentApply);

    /**
     * 新增付款信息
     * 
     * @param paymentApply 付款信息
     * @return 结果
     */
    public int insertPaymentApply(PaymentApply paymentApply);

    /**
     * 修改付款信息
     * 
     * @param paymentApply 付款信息
     * @return 结果
     */
    public int updatePaymentApply(PaymentApply paymentApply);

    /**
     * 批量删除付款信息
     * 
     * @param ids 需要删除的付款信息主键集合
     * @return 结果
     */
    public int deletePaymentApplyByIds(Long[] ids);

    /**
     * 删除付款信息信息
     * 
     * @param id 付款信息主键
     * @return 结果
     */
    public int deletePaymentApplyById(Long id);
}
