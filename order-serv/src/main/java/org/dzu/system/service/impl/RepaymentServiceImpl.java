package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.enums.TableName;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.uuid.UUID;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.BorrowedMoney;
import org.dzu.system.domain.Repayment;
import org.dzu.system.mapper.RepaymentMapper;
import org.dzu.system.service.IBorrowedMoneyService;
import org.dzu.system.service.IRepaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 贷款还款信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class RepaymentServiceImpl implements IRepaymentService {
    @Autowired
    private RepaymentMapper repaymentMapper;

    @Autowired
    private IBorrowedMoneyService borrowedMoneyService;

    @Autowired
    private BankAccountServiceImpl bankAccountService;
    @Autowired
    private PaymentApplyServiceImpl paymentApplyServiceImpl;

    /**
     * 查询贷款还款信息
     *
     * @param id 贷款还款信息主键
     * @return 贷款还款信息
     */
    @Override
    public Repayment selectRepaymentById(Long id) {
        return repaymentMapper.selectRepaymentById(id);
    }

    /**
     * 查询贷款还款信息列表
     *
     * @param repayment 贷款还款信息
     * @return 贷款还款信息
     */
    @Override
    public List<Repayment> selectRepaymentList(Repayment repayment) {
        return repaymentMapper.selectRepaymentList(repayment);
    }

    /**
     * 新增贷款还款信息
     *
     * @param repayment 贷款还款信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class, isolation = Isolation.SERIALIZABLE)// 开启最高级别事务，以及最小容忍错误，防止金额记录出现问题
    public int insertRepayment(Repayment repayment) {
        // 设置基本信息
        repayment.setAddtime(String.valueOf(DateUtils.getNowDate()));
        repayment.setUserId(SecurityUtils.getUserId());
        repayment.setUserName(SecurityUtils.getUserTruename());
        repayment.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 判断借款uuid是否存在，如果不存在就丢异常
        BorrowedMoney query = new BorrowedMoney();
        query.setLoanNO(repayment.getLoanNO());
        List<BorrowedMoney> result = borrowedMoneyService.selectBorrowedMoneyList(query);
        if (result.size() == 0) {
            throw new ServiceException("LoanNo_miss");
        }


        // 确定存在后生成还款UUID
        repayment.setPayNO(UUID.fastUUID().toString());

        // 判断转账的bankNo存是否存在,如果不存在就丢异常
        BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(repayment.getBankNo());
        if (bankAccount == null) {
            throw new ServiceException("BankNo_miss");
        }

        // 判断转账的bankName存是否存在,如果为null则自动补充上去
        if(bankAccount.getAcountsName()==null){
            repayment.setAcountsName(bankAccount.getAcountsName());
        }

//        // 准备同步到变动表
//        BankAccountChange bankAccountChange = new BankAccountChange();
//        bankAccountChange.setSelfBankNo(repayment.getBankNo());
//        bankAccountChange.setMoneyAmount(repayment.getMoneyAmount());
//        bankAccountChange.setPayNO(repayment.getPayNO());
//        bankAccountChange.setChangeType(BankChangeConstant.PaymentType.PAYMENT.get());
//        bankAccountChange.setTableName(TableName.REPAYMENT.get());
//        bankAccountChangeService.insertBankAccountChange(bankAccountChange);
        int i = repaymentMapper.insertRepayment(repayment);
        // 判断是否需要更新对应借款的isEnd属性,如果需要，自动更新
        updateIsEnd(repayment.getLoanNO());

        // 准备插入
        return i;
    }

    /**
     * 修改贷款还款信息
     *
     * @param repayment 贷款还款信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class, isolation = Isolation.SERIALIZABLE)// 开启最高级别事务，以及最小容忍错误，防止金额记录出现问题
    public int updateRepayment(Repayment repayment) {
        // 基础信息填充
        repayment.setUserId(SecurityUtils.getUserId());
        repayment.setUserName(SecurityUtils.getUserTruename());
        repayment.setUpdateTime(DateUtils.getNowDate());
        // 判断借款uuid是否存在，如果不存在就丢异常
        BorrowedMoney query = new BorrowedMoney();
        query.setLoanNO(repayment.getLoanNO());
        List<BorrowedMoney> result = borrowedMoneyService.selectBorrowedMoneyList(query);
        if (result.size() == 0) {
            throw new ServiceException("LoanNo_miss");
        }

        if (paymentApplyServiceImpl.checkExist(TableName.REPAYMENT.get(), repayment.getId())) {
            throw new ServiceException("对应信息存在审核记录,且审核记录不为不通过");
        }

        // 确定没有修改UUID
        if (!repaymentMapper.selectRepaymentById(repayment.getId()).getPayNO().equals(repayment.getPayNO())) {
            throw new ServiceException("PayNO_error");
        }


        // 判断转账的bankNo存是否存在,如果不存在就丢异常
        BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(repayment.getBankNo());
        if (bankAccount == null) {
            throw new ServiceException("BankNo_miss");
        }
        // 判断转账的bankName存是否存在,如果为null则自动补充上去
        if(bankAccount.getAcountsName()==null){
            repayment.setAcountsName(bankAccount.getAcountsName());
        }

//        // 准备同步到变动表
//        BankAccountChange bankAccountChange = new BankAccountChange();
//        bankAccountChange.setSelfBankNo(repayment.getBankNo());
//        bankAccountChange.setMoneyAmount(repayment.getMoneyAmount());
//        bankAccountChange.setPayNO(repayment.getPayNO());
//        bankAccountChange.setChangeType(BankChangeConstant.PaymentType.PAYMENT.get());
//        bankAccountChange.setTableName(TableName.REPAYMENT.get());
//        bankAccountChangeService.updateBankAccountChangeByUUID(bankAccountChange);

        // 判断是否需要更新对应借款的isEnd属性,如果需要，自动更新
        updateIsEnd(repayment.getLoanNO());

        return repaymentMapper.updateRepayment(repayment);
    }

    /**
     * 批量删除贷款还款信息
     *
     * @param ids 需要删除的贷款还款信息主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class, isolation = Isolation.SERIALIZABLE)// 开启最高级别事务，以及最小容忍错误，防止金额记录出现问题
    public int deleteRepaymentByIds(Long[] ids) {
//        // 需要删除银行卡变动，需要修改借款标志
//        List<Repayment> repayments = repaymentMapper.selectBatchIds(Arrays.asList(ids));
//        // 提取loanNO和payNo
//        List<String> Loans = new ArrayList<String>();
//        List<String> Pays = new ArrayList<String>();
//        repayments.parallelStream().forEach(
//                r -> {
//                    Pays.add(r.getPayNO());
//                }
//        );
//
//        //根据uuid删除
//        // 创建一个大小合适的数组并使用Arrays.copyOf
//        String[] array = Arrays.copyOf(Pays.toArray(), Pays.size(), String[].class);
//        bankAccountChangeService.deleteBankAccountChangeByUUID(array);
//
//        //修改借款标志
//        QueryWrapper<BorrowedMoney> borrowedMoneyQueryWrapper = new QueryWrapper<>();
//        borrowedMoneyQueryWrapper.in("LoanNO", Pays.toArray());
//        BorrowedMoney borrowedMoney = new BorrowedMoney();
//        borrowedMoney.setIsEnd(BorrowedMoneyConstants.noEnd);
//        borrowedMoneyMapper.update(borrowedMoney, borrowedMoneyQueryWrapper);

        for (Long id : ids) {
            if (paymentApplyServiceImpl.checkExist(TableName.REPAYMENT.get(), id)) {
                throw new ServiceException("对应信息存在审核记录,且审核记录不为不通过");
            }
        }
        return repaymentMapper.deleteRepaymentByIds(ids);
    }

    @Override
    public List<Repayment> selectRepaymentByLoanNo(String loanNo) {
        QueryWrapper<Repayment> queryWrapper = new QueryWrapper<>();
//        queryWrapper.eq("loanNO", loanNo);
        // 应该查询loanNO相等并且逻辑删除标记delFlag不为1
        queryWrapper.eq("loanNO", loanNo).eq("delFlag", DelConstants.NODEL);

        return repaymentMapper.selectList(queryWrapper);
    }

    private void updateIsEnd(String loanNO) {
        borrowedMoneyService.updateBorrowedMoneyIsEndByLoanNO(loanNO);
    }
}
