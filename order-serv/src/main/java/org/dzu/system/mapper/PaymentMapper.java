package org.dzu.system.mapper;

import org.dzu.system.domain.Payment;

import java.util.List;

/**
 * 收付款信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface PaymentMapper 
{
    /**
     * 查询收付款信息
     * 
     * @param id 收付款信息主键
     * @return 收付款信息
     */
    public Payment selectPaymentById(Long id);

    /**
     * 查询收付款信息列表
     * 
     * @param payment 收付款信息
     * @return 收付款信息集合
     */
    public List<Payment> selectPaymentList(Payment payment);

    /**
     * 新增收付款信息
     * 
     * @param payment 收付款信息
     * @return 结果
     */
    public int insertPayment(Payment payment);

    /**
     * 修改收付款信息
     * 
     * @param payment 收付款信息
     * @return 结果
     */
    public int updatePayment(Payment payment);

    /**
     * 删除收付款信息
     * 
     * @param id 收付款信息主键
     * @return 结果
     */
    public int deletePaymentById(Long id);

    /**
     * 批量删除收付款信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deletePaymentByIds(Long[] ids);
}
