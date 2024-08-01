package org.dzu.system.service.impl;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.BankChangeConstant;
import org.dzu.common.constant.PaymentState;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.uuid.UUID;
import org.dzu.system.domain.BankAccountChange;
import org.dzu.system.domain.ReceiveMoney;
import org.dzu.system.service.IBankAccountChangeService;
import org.dzu.system.service.IBankAccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.PaymentMapper;
import org.dzu.system.domain.Payment;
import org.dzu.system.service.IPaymentService;
 
import org.dzu.common.constant.DelConstants;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

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

    @Autowired
    private IBankAccountService bankAccountService;

    @Autowired
    private IBankAccountChangeService bankAccountChangeService;
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
     * 根据UUiD查询付款信息
     */
    @Override
    public Payment selectPaymentByPayNO(String payNO)
    {
        QueryWrapper<Payment> query = new QueryWrapper<>();
        query.select().eq("payNO", payNO).eq("delFlag", DelConstants.NODEL);
        return paymentMapper.selectOne(query);
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
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class) // 开启最高级别的事务隔离和最小容忍异常
    public int insertPayment(Payment payment)
    {
        // 设置基础信息
        payment.setAddtime(String.valueOf(DateUtils.getNowDate()));
        payment.setUserId(SecurityUtils.getUserId());
        payment.setUserName(SecurityUtils.getUserTruename());
        payment.setDelFlag(Long.valueOf(DelConstants.NODEL));
        // 检查双方的银行卡是否存在
        if (bankAccountService.selectBankAccountByBankNo(payment.getOtherBankNo()) == null)
        {
            throw new RuntimeException("付款方银行卡不存在");
        }
        if(bankAccountService.selectBankAccountByBankNo(payment.getSelfBankNo())==null){
            throw new RuntimeException("收款方银行卡不存在");
        }

        // 确定两方银行卡存在后生成uuid
        payment.setPayNO(UUID.fastUUID().toString());

        // 同步到银行卡变动表
        syncToBankChange(payment);
        return paymentMapper.insertPayment(payment);
    }

    /**
     * 修改付款信息
     * 
     * @param payment 付款信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class) // 开启最高级别的事务隔离和最小容忍异��
    public int updatePayment(Payment payment)
    {
        // 设置基础信息
        payment.setUserId(SecurityUtils.getUserId());
        payment.setUserName(SecurityUtils.getUserTruename());
        payment.setUpdateTime(DateUtils.getNowDate());

        // 检查双方的银行卡是否存在
        if (bankAccountService.selectBankAccountByBankNo(payment.getOtherBankNo()) == null)
        {
            throw new RuntimeException("付款方银行卡不存在");
        }
        if(bankAccountService.selectBankAccountByBankNo(payment.getSelfBankNo())==null){
            throw new RuntimeException("收款方银行卡不存在");
        }

        //确定没有修改UUID
        Payment oldPayment = paymentMapper.selectPaymentById(payment.getId());
        if (!oldPayment.getPayNO().equals(payment.getPayNO()))
        {
            throw new RuntimeException("不允许修改UUID");
        }

        // 因为本次会同一个UUID产生两个数据，不适宜使用更新操作
        // 所以这里直接删除旧数据，插入新数据
        bankAccountChangeService.deleteBankAccountChangeByUUID(new String[]{oldPayment.getPayNO()});
        syncToBankChange(payment);

        return paymentMapper.updatePayment(payment);
    }

    /**
     * 批量删除付款信息
     * 
     * @param ids 需要删除的付款信息主键
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class) // 开启最高级别的事务隔离和最小容忍异常
    public int deletePaymentByIds(Long[] ids)
    {
        // 搜索所有的信息
        String[] array = paymentMapper.selectBatchIds(Arrays.asList(ids)).stream().map(Payment::getPayNO).collect(Collectors.toList()).toArray(new String[0]);
        // 批量删除
        bankAccountChangeService.deleteBankAccountChangeByUUID(array);
        return paymentMapper.deletePaymentByIds(ids);
    }


    /**
     * 同步到银行账户变动表
     * @param payment
     */
    private void syncToBankChange(Payment payment) {
        // 只有已经支付的才能同步，否则直接返回
        if(!payment.getPaymentState().equals(PaymentState.OVER)){
            return;
        }

        // 同步到银行账户变动表，我方付款
        BankAccountChange selfChange = new BankAccountChange();
        selfChange.setSelfBankNo(payment.getSelfBankNo());
        selfChange.setMoneyAmount(payment.getMoneyAmount());
        selfChange.setChangeType(BankChangeConstant.PaymentType.PAYMENT.get());
        selfChange.setTableName(BankChangeConstant.TableName.PAYMENT.get());
        selfChange.setPayNO(payment.getPayNO());
        bankAccountChangeService.insertBankAccountChange(selfChange);

        // 同步到银行账户变动表，对方收款
        BankAccountChange otherChange = new BankAccountChange();
        otherChange.setSelfBankNo(payment.getOtherBankNo());
        otherChange.setMoneyAmount(payment.getMoneyAmount());
        otherChange.setChangeType(BankChangeConstant.PaymentType.RECEIPT.get());
        otherChange.setTableName(BankChangeConstant.TableName.PAYMENT.get());
        otherChange.setPayNO(payment.getPayNO());

        // 插入
        bankAccountChangeService.insertBankAccountChange(otherChange);
    }
}

