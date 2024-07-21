package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.PaymentMapper;
import com.ruoyi.system.domain.Payment;
import com.ruoyi.system.service.IPaymentService;

/**
 * 收付款信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class PaymentServiceImpl implements IPaymentService 
{
    @Autowired
    private PaymentMapper paymentMapper;

    /**
     * 查询收付款信息
     * 
     * @param id 收付款信息主键
     * @return 收付款信息
     */
    @Override
    public Payment selectPaymentById(Long id)
    {
        return paymentMapper.selectPaymentById(id);
    }

    /**
     * 查询收付款信息列表
     * 
     * @param payment 收付款信息
     * @return 收付款信息
     */
    @Override
    public List<Payment> selectPaymentList(Payment payment)
    {
        return paymentMapper.selectPaymentList(payment);
    }

    /**
     * 新增收付款信息
     * 
     * @param payment 收付款信息
     * @return 结果
     */
    @Override
    public int insertPayment(Payment payment)
    {
        return paymentMapper.insertPayment(payment);
    }

    /**
     * 修改收付款信息
     * 
     * @param payment 收付款信息
     * @return 结果
     */
    @Override
    public int updatePayment(Payment payment)
    {
        payment.setUpdateTime(DateUtils.getNowDate());
        return paymentMapper.updatePayment(payment);
    }

    /**
     * 批量删除收付款信息
     * 
     * @param ids 需要删除的收付款信息主键
     * @return 结果
     */
    @Override
    public int deletePaymentByIds(Long[] ids)
    {
        return paymentMapper.deletePaymentByIds(ids);
    }

    /**
     * 删除收付款信息信息
     * 
     * @param id 收付款信息主键
     * @return 结果
     */
    @Override
    public int deletePaymentById(Long id)
    {
        return paymentMapper.deletePaymentById(id);
    }
}
