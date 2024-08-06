package org.dzu.system.service.impl;

import java.util.List;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.AuditStateConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.AuditInfo;
import org.dzu.system.mapper.AuditInfoMapper;
import org.dzu.system.service.IAuditInfoService;
import org.dzu.system.service.IPaymentService;
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

    @Autowired
    private IAuditInfoService auditInfoService;

    @Autowired
    private AuditInfoMapper auditInfoMapper;

    @Autowired
    private IPaymentService paymentService;

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
        // 设置基础信息，申请人信息
        paymentApply.setAddtime(String.valueOf(DateUtils.getNowDate()));
        paymentApply.setUserId(SecurityUtils.getUserId());
        paymentApply.setUserName(SecurityUtils.getUserTruename());
        paymentApply.setDelFlag(Long.valueOf(DelConstants.NODEL));


        // 补充申请人信息
        paymentApply.setApplyPerson(SecurityUtils.getUserTruename());
        paymentApply.setApplyPersonID(SecurityUtils.getUserId());

        //新增加的信息审核状态必定是审核中
        paymentApply.setCheckState(AuditStateConstants.CHECK_STATE_ING);

        // 先返回主键
        int i = paymentApplyMapper.insertPaymentApply(paymentApply);
        // 映射返回主键后创建审核流程
        auditInfoService.insertAuditInfo(paymentApply);

        return i;
    }

    /**
     * 修改付款信息（只有后端调用，前端禁止任何形式的修改）
     * 
     * @param paymentApply 付款信息
     * @return 结果
     */
    @Override
    public int updatePaymentApply(PaymentApply paymentApply)
    {
        // 设置基础信息
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
        int i = paymentApplyMapper.deletePaymentApplyByIds(ids);
        if(i!=ids.length){
            throw new ServiceException("删除信息中含有已经审核结束的信息，请刷新页面后重新选择");
        }
        // 如果上一步没丢出异常，可以确定本次选择的都是还没有审核到最后一步的信息
        // 所以在这里执行删除对应审核流程
        QueryWrapper<AuditInfo> query = new QueryWrapper<>();
        query.in("applyID",ids);
        auditInfoMapper.delete(query);

        return i;
    }

    // 本方法与审核通过后调用 通过applyID找到对应的信息，将其审核状态改为审核通过
    // 同时创建付款信息

    @Override
    public void auditPass(Long applyID) {
        PaymentApply updateInfo = new PaymentApply();
        updateInfo.setId(applyID);
        updateInfo.setCheckState(AuditStateConstants.CHECK_STATE_PASS);
        updateInfo.setSubmitflag(AuditStateConstants.SUBMIT_STATE_END);
        paymentApplyMapper.updateById(updateInfo);

        // 创建付款信息
        paymentService.insertPaymentByApply(applyID);
    }
}
