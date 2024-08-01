package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.PaymentApplyMapper;
import org.dzu.system.domain.PaymentApply;
import org.dzu.system.service.IPaymentApplyService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 付款信息Service业务层处理
 *
 * @author ml
 * @date 2024-08-01
 */
@Service
public class PaymentApplyServiceImpl implements IPaymentApplyService
{
    @Autowired
    private PaymentApplyMapper paymentApplyMapper;

    /**
     * 查询付款信息
     *
     * @param id 付款信息主键
     * @return 付款信息
     */
    @Override
    public PaymentApply selectPaymentApplyById(Long id)
    {
        return paymentApplyMapper.selectPaymentApplyById(id);
    }

    /**
     * 查询付款信息列表
     *
     * @param paymentApply 付款信息
     * @return 付款信息
     */
    @Override
    public List<PaymentApply> selectPaymentApplyList(PaymentApply paymentApply)
    {
        return paymentApplyMapper.selectPaymentApplyList(paymentApply);
    }

    /**
     * 新增付款信息
     *
     * @param paymentApply 付款信息
     * @return 结果
     */
    @Override
    public int insertPaymentApply(PaymentApply paymentApply)
    {
        paymentApply.setAddtime(String.valueOf(DateUtils.getNowDate()));
        paymentApply.setUserId(SecurityUtils.getUserId());
        paymentApply.setUserName(SecurityUtils.getUserTruename());
        paymentApply.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return paymentApplyMapper.insertPaymentApply(paymentApply);
    }

    /**
     * 修改付款信息
     * 
     * @param paymentApply 付款信息
     * @return 结果
     */
    @Override
    public int updatePaymentApply(PaymentApply paymentApply)
    {
        paymentApply.setUserId(SecurityUtils.getUserId());
        paymentApply.setUserName(SecurityUtils.getUserTruename());
        paymentApply.setUpdateTime(DateUtils.getNowDate());
        return paymentApplyMapper.updatePaymentApply(paymentApply);
    }

    /**
     * 批量删除付款信息
     * 
     * @param ids 需要删除的付款信息主键
     * @return 结果
     */
    @Override
    public int deletePaymentApplyByIds(Long[] ids)
    {
        return paymentApplyMapper.deletePaymentApplyByIds(ids);
    }

    /**
     * 删除付款信息信息
     * 
     * @param id 付款信息主键
     * @return 结果
     */
    @Override
    public int deletePaymentApplyById(Long id)
    {
        return paymentApplyMapper.deletePaymentApplyById(id);
    }
}
