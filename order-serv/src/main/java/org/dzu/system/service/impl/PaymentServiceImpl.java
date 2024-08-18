package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.constant.PaymentState;
import org.dzu.common.constant.YesOrNoConstants;
import org.dzu.common.enums.TableName;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.common.utils.uuid.UUID;
import org.dzu.system.domain.*;
import org.dzu.system.mapper.OilRechargeMapper;
import org.dzu.system.mapper.OrderFreightMapper;
import org.dzu.system.mapper.PaymentMapper;
import org.dzu.system.service.IPaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 付款信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class PaymentServiceImpl implements IPaymentService {
    @Autowired
    private PaymentMapper paymentMapper;

    @Autowired
    private BankAccountServiceImpl bankAccountService;

    @Autowired
    private BankAccountChangeServiceImpl bankAccountChangeService;

    @Autowired
    private OrderFreightMapper orderFreightMapper;
    @Autowired
    private OilRechargeMapper oilRechargeMapper;
    @Autowired
    private OilRechargeServiceImpl oilRechargeServiceImpl;
    @Autowired
    private OilCardServiceImpl oilCardServiceImpl;

    /**
     * 查询付款信息
     *
     * @param id 付款信息主键
     * @return 付款信息
     */
    @Override
    public Payment selectPaymentById(Long id) {
        return paymentMapper.selectPaymentById(id);
    }

    /**
     * 根据UUiD查询付款信息
     */
    @Override
    public Payment selectPaymentByPayNO(String payNO) {
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
    public List<Payment> selectPaymentList(Payment payment) {
        return paymentMapper.selectPaymentList(payment);
    }

    /**
     * 新增付款信息
     *
     * @param payment 付款信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class) // 开启最高级别的事务隔离和最小容忍异常
    public int insertPayment(Payment payment) {
        // 设置基础信息
        payment.setAddtime(String.valueOf(DateUtils.getNowDate()));
        payment.setUserId(SecurityUtils.getUserId());
        payment.setUserName(SecurityUtils.getUserTruename());
        payment.setDelFlag(Long.valueOf(DelConstants.NODEL));
        payment.setPaymentState(PaymentState.NO_OVER);

        // 检查双方的银行卡是否存在
        if (payment.getOtherBankNo() != null && bankAccountService.selectBankAccountByBankNo(payment.getOtherBankNo()) == null) {
            throw new RuntimeException("收款方银行卡不存在");
        }
        if (bankAccountService.selectBankAccountByBankNo(payment.getSelfBankNo()) == null) {
            throw new RuntimeException("己方付款银行卡不存在");
        }

        // 确定两方银行卡存在后生成uuid
        payment.setPayNO(UUID.fastUUID().toString());

        return paymentMapper.insertPayment(payment);
    }

    /**
     * 修改付款信息
     *
     * @param payment 付款信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class) // 开启最高级别的事务隔离和最小容忍异��
    public int updatePayment(Payment payment) {
        // 检查双方的银行卡是否存在
        if (payment.getOtherBankNo() != null && bankAccountService.selectBankAccountByBankNo(payment.getOtherBankNo()) == null) {
            throw new RuntimeException("收款方银行卡不存在");
        }
        if (bankAccountService.selectBankAccountByBankNo(payment.getSelfBankNo()) == null) {
            throw new RuntimeException("己方付款银行卡不存在");
        }

        //确定没有修改UUID
        Payment oldPayment = paymentMapper.selectPaymentById(payment.getId());
        if (!oldPayment.getPayNO().equals(payment.getPayNO())) {
            throw new RuntimeException("不允许修改UUID");
        }
        // 判断本信息是否提交，如果提交了，不允许修改
        if (oldPayment.getPaymentState().equals(PaymentState.OVER)) {
            throw new ServiceException("已经提交的信息不允许修改");
        }
        // 如果本次更改是修改状态为支付，那么需要复杂的联动修改其他表
        if (payment.getPaymentState().equals(PaymentState.OVER)) {
            if (payment.getSelfBankNo() == null) {
                throw new ServiceException("请选择支付卡");
            }
            // 检测选择支付的卡是否存在
            BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(payment.getSelfBankNo());
            if (bankAccount == null) {
                throw new ServiceException("请输入正确的支付卡号");
            }
            syncToOtherTable(payment, oldPayment);
        }
        return paymentMapper.updatePayment(payment);
    }


    /**
     * 批量删除付款信息
     *
     * @param ids 需要删除的付款信息主键
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class) // 开启最高级别的事务隔离和最小容忍异常
    public int deletePaymentByIds(Long[] ids) {
        List<Payment> payments = paymentMapper.selectBatchIds(Arrays.asList(ids));
        // 搜索所有的信息
        String[] array = payments.stream().map(Payment::getPayNO).collect(Collectors.toList()).toArray(new String[0]);
        // 批量删除
        bankAccountChangeService.deleteBankAccountChangeByUUID(array);
        int i = paymentMapper.deletePaymentByIds(ids);
        if (i != ids.length) {
            throw new ServiceException("含有已经支付的信息！");
        }
        return i;

    }

    @Override
    public void insertPaymentByApply(Long applyID) {
        paymentMapper.insertPaymentByApply(applyID);
    }


    /**
     * 同步到银行账户变动表
     *
     * @param payment
     */
    private void syncToBankChange(Payment payment) {
        // 只有已经支付的才能同步，否则直接返回
        if (!payment.getPaymentState().equals(PaymentState.OVER)) {
            return;
        }

        // 创建资金变动
        BankAccountChange self = new BankAccountChange();
        self.setSelfBankNo(payment.getSelfBankNo());
        self.setMoneyAmount(payment.getMoneyAmount());
        // if判断是因为有的付款信息是从付款页面直接发起的,这种没有关联表名和tid,所以直接赋值为payment的相关信息
        if (payment.getPayNO() != null) {
            self.setPayNO(payment.gettID());
        } else {
            self.setPayNO(String.valueOf(payment.getId()));
        }
        if (payment.getTableName() != null) {
            self.setTableName(payment.getTableName());
        } else {
            self.setTableName(TableName.PAYMENT.get());
        }
        bankAccountChangeService.insertPaymenyChange(self);
        BankAccountChange other = new BankAccountChange();
        other.setSelfBankNo(payment.getOtherBankNo());
        other.setMoneyAmount(payment.getMoneyAmount());
        if (payment.getPayNO() != null) {
            other.setPayNO(payment.gettID());
        } else {
            other.setPayNO(String.valueOf(payment.getId()));
        }
        if (payment.getTableName() != null) {
            other.setTableName(payment.getTableName());
        } else {
            other.setTableName(TableName.PAYMENT.get());
        }
        bankAccountChangeService.insertReceiptChange(other);
    }


    // 复杂联动，根据表名做适合的对其他表的修改，
    private void syncToOtherTable(Payment payment, Payment oldPayment) {


        // 第一步是修改资金变动表
        // 因为本次会同一个UUID产生两个数据，不适宜使用更新操作
        // 所以这里直接删除旧数据，插入新数据
        bankAccountChangeService.deleteBankAccountChangeByUUID(new String[]{oldPayment.getPayNO()});
        syncToBankChange(payment);

        // 第二步是修改其他表，目前涉及运费表、借款还款表
        // 先拿一下表名，如果为空则直接跳过，因为不涉及对应表的联动修改
        if (StringUtils.isEmpty(payment.getTableName())) {
            return;
        }
        switch (TableName.fromTableName(payment.getTableName().toLowerCase().trim())) {
            case ORDER_FREIGHT:
                // 处理运费表的逻辑
                QueryWrapper<OrderFreight> query = new QueryWrapper<OrderFreight>().eq("id", payment.gettID()).eq("delFlag", DelConstants.NODEL);
                orderFreightMapper.selectList(query).forEach(orderFreight -> {
                    // 这里直接使用遍历可以少些个空值判断，后续同理
                    orderFreight.setPaymentState(PaymentState.OVER);
                    orderFreight.setIsedit(Long.valueOf(YesOrNoConstants.NO_num));
                    orderFreightMapper.updateOrderFreight(orderFreight);
                });
                break;
            case OIL_RECHARGE:
                // 进行油卡金额的变动
                QueryWrapper<OilRecharge> queryOliRecharge = new QueryWrapper<OilRecharge>().eq("id", payment.gettID()).eq("delFlag", DelConstants.NODEL);


                // 这里不使用油卡充值中的金额,而是使用付款信息中的金额
                for (OilRecharge oilRecharge : oilRechargeMapper.selectList(queryOliRecharge)) {
                    oilCardServiceImpl.updateOilCardMoney(oilRecharge.getOilCardNo(), payment.getMoneyAmount());
                }

                break;
            // 其他表的处理逻辑
            default:
                break;
        }
    }
}

