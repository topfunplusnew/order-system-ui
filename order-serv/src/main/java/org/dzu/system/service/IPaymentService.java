package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Payment;

/**
 * 付款信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IPaymentService 
{
    /**
     * 查询付款信息
     * 
     * @param id 付款信息主键
     * @return 付款信息
     */
    public Payment selectPaymentById(Long id);

    Payment selectPaymentByPayNO(String payNO);

    /**
     * 查询付款信息列表
     * 
     * @param payment 付款信息
     * @return 付款信息集合
     */
    public List<Payment> selectPaymentList(Payment payment);

    /**
     * 新增付款信息
     * 
     * @param payment 付款信息
     * @return 结果
     */
    public int insertPayment(Payment payment);

    /**
     * 修改付款信息
     * 
     * @param payment 付款信息
     * @return 结果
     */
    public int updatePayment(Payment payment);

    /**
     * 批量删除付款信息
     * 
     * @param ids 需要删除的付款信息主键集合
     * @return 结果
     */
    public int deletePaymentByIds(Long[] ids);

}
