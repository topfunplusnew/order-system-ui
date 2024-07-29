package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.PaymentMapper;
import org.dzu.system.domain.Payment;
import org.dzu.system.service.IPaymentService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 付款信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class PaymentServiceImpl implements IPaymentService
{
    @Autowired
    private PaymentMapper paymentMapper;

    /**
     * 查询付款信息
     *
     * @param id 付款信息主键
     * @return 付款信息
     */
    @Override
    public Payment selectPaymentById(Long id)
    {
        return paymentMapper.selectPaymentById(id);
    }

    /**
     * 查询付款信息列表
     *
     * @param payment 付款信息
     * @return 付款信息
     */
    @Override
    public List<Payment> selectPaymentList(Payment payment)
    {
        return paymentMapper.selectPaymentList(payment);
    }

    /**
     * 新增付款信息
     *
     * @param payment 付款信息
     * @return 结果
     */
    @Override
    public int insertPayment(Payment payment)
    {
        payment.setAddtime(String.valueOf(DateUtils.getNowDate()));
        payment.setUserId(SecurityUtils.getUserId());
        payment.setUserName(SecurityUtils.getUserTruename());
        payment.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return paymentMapper.insertPayment(payment);
    }

    /**
     * 修改付款信息
     * 
     * @param payment 付款信息
     * @return 结果
     */
    @Override
    public int updatePayment(Payment payment)
    {
        payment.setUserId(SecurityUtils.getUserId());
        payment.setUserName(SecurityUtils.getUserTruename());
        payment.setUpdateTime(DateUtils.getNowDate());
        return paymentMapper.updatePayment(payment);
    }

    /**
     * 批量删除付款信息
     * 
     * @param ids 需要删除的付款信息主键
     * @return 结果
     */
    @Override
    public int deletePaymentByIds(Long[] ids)
    {
        return paymentMapper.deletePaymentByIds(ids);
    }

    /**
     * 删除付款信息信息
     * 
     * @param id 付款信息主键
     * @return 结果
     */
    @Override
    public int deletePaymentById(Long id)
    {
        return paymentMapper.deletePaymentById(id);
    }
}
