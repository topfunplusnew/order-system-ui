package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.PaymentMapper;
import org.dzu.system.domain.Payment;
import org.dzu.system.service.IPaymentService;

/**
 * 资产管理-收付款:收付款信息Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class PaymentServiceImpl implements IPaymentService 
{
    @Autowired
    private PaymentMapper paymentMapper;

    /**
     * 查询资产管理-收付款:收付款信息
     * 
     * @param id 资产管理-收付款:收付款信息主键
     * @return 资产管理-收付款:收付款信息
     */
    @Override
    public Payment selectPaymentById(Long id)
    {
        return paymentMapper.selectPaymentById(id);
    }

    /**
     * 查询资产管理-收付款:收付款信息列表
     * 
     * @param payment 资产管理-收付款:收付款信息
     * @return 资产管理-收付款:收付款信息
     */
    @Override
    public List<Payment> selectPaymentList(Payment payment)
    {
        return paymentMapper.selectPaymentList(payment);
    }

    /**
     * 新增资产管理-收付款:收付款信息
     * 
     * @param payment 资产管理-收付款:收付款信息
     * @return 结果
     */
    @Override
    public int insertPayment(Payment payment)
    {
        return paymentMapper.insertPayment(payment);
    }

    /**
     * 修改资产管理-收付款:收付款信息
     * 
     * @param payment 资产管理-收付款:收付款信息
     * @return 结果
     */
    @Override
    public int updatePayment(Payment payment)
    {
        payment.setUpdateTime(DateUtils.getNowDate());
        return paymentMapper.updatePayment(payment);
    }

    /**
     * 批量删除资产管理-收付款:收付款信息
     * 
     * @param ids 需要删除的资产管理-收付款:收付款信息主键
     * @return 结果
     */
    @Override
    public int deletePaymentByIds(Long[] ids)
    {
        return paymentMapper.deletePaymentByIds(ids);
    }

    /**
     * 删除资产管理-收付款:收付款信息信息
     * 
     * @param id 资产管理-收付款:收付款信息主键
     * @return 结果
     */
    @Override
    public int deletePaymentById(Long id)
    {
        return paymentMapper.deletePaymentById(id);
    }
}
