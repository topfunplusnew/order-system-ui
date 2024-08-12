package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.AuditStateConstants;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.AuditInfo;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.PaymentApply;
import org.dzu.system.mapper.AuditInfoMapper;
import org.dzu.system.mapper.BankAccountMapper;
import org.dzu.system.mapper.PaymentApplyMapper;
import org.dzu.system.service.IAuditInfoService;
import org.dzu.system.service.IBankAccountService;
import org.dzu.system.service.IPaymentApplyService;
import org.dzu.system.service.IPaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
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
    @Autowired
    private BankAccountMapper bankAccountMapper;
    @Autowired
    private BankAccountServiceImpl bankAccountServiceImpl;

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

        // 检查申请信息的依赖信息
        String otherBankNo = paymentApply.getOtherBankNo();
        if(otherBankNo==null || otherBankNo.isEmpty()){
            throw new ServiceException("对方账号不能为空");
        }
        BankAccount other = bankAccountServiceImpl.selectBankAccountByBankNo(otherBankNo);
        if(other==null){
            throw new ServiceException("搜索不到卡号:"+otherBankNo+"的对方账号");
        }

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
    @Transactional
    public int deletePaymentApplyByIds(Long[] ids)
    {
        // 需要确保对应的审核信息的submitFlag只能未提交状态
        QueryWrapper<AuditInfo> query = new QueryWrapper<>();
        query.in("applyID",ids).eq("submitflag",AuditStateConstants.SUBMIT_STATE_END);
        if(auditInfoMapper.selectCount(query)>0){
            throw new ServiceException("删除信息中含有已经审核结束的信息，请刷新页面后重新选择");
        }

        int i = paymentApplyMapper.deletePaymentApplyByIds(ids);
        if(i!=ids.length){
            throw new ServiceException("删除信息中含有已经审核结束的信息，请刷新页面后重新选择");
        }

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

    // 根据表名和主键查询是否有通过或正在申请的信息，如果有则返回true，否则返回false

    @Override
    public boolean checkExist(String tableName, Long id) {
        QueryWrapper<PaymentApply> query = new QueryWrapper<>();
        query.eq("tableName",tableName).eq("tID",id);
        // 正在申请或者通过的
        query.and(i->i.eq("checkState",AuditStateConstants.CHECK_STATE_ING).or().eq("checkState",AuditStateConstants.CHECK_STATE_PASS));
        return paymentApplyMapper.selectCount(query)>0;
    }

    @Override
    public boolean checkNotExist(String tableName, Long id) {
        return !checkExist(tableName, id);
    }



    // 根据表名和id获取申请信息

    /**
     * 根据表名和id获取申请信息
     * @param tableName
     * @param id
     * @return
     */
    @Override
    public List<AuditInfo> getApplyInfo(String tableName, Long id){
        QueryWrapper<AuditInfo> query = new QueryWrapper<>();
        query.eq("tableName",tableName).eq("tID",id);
        List<AuditInfo> auditInfos = auditInfoMapper.selectList(query);
        return auditInfos;
    }

}
