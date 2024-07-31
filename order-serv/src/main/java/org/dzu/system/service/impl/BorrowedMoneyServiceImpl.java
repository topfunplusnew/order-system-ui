package org.dzu.system.service.impl;

import org.dzu.common.constant.BankChangeConstant;
import org.dzu.common.constant.BorrowedMoneyConstants;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.common.utils.uuid.UUID;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.BankAccountChange;
import org.dzu.system.domain.BorrowedMoney;
import org.dzu.system.mapper.BorrowedMoneyMapper;
import org.dzu.system.service.IBankAccountChangeService;
import org.dzu.system.service.IBankAccountService;
import org.dzu.system.service.IBorrowedMoneyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

/**
 * 从外部借款信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BorrowedMoneyServiceImpl implements IBorrowedMoneyService {
    @Autowired
    private BorrowedMoneyMapper borrowedMoneyMapper;

    @Autowired
    private IBankAccountChangeService bankAccountChangeService;

    @Autowired
    private IBankAccountService bankAccountService;

    /**
     * 查询从外部借款信息
     *
     * @param id 从外部借款信息主键
     * @return 从外部借款信息
     */
    @Override
    public BorrowedMoney selectBorrowedMoneyById(Long id) {
        return borrowedMoneyMapper.selectBorrowedMoneyById(id);
    }

    /**
     * 查询从外部借款信息列表
     *
     * @param borrowedMoney 从外部借款信息
     * @return 从外部借款信息
     */
    @Override
    public List<BorrowedMoney> selectBorrowedMoneyList(BorrowedMoney borrowedMoney) {
        return borrowedMoneyMapper.selectBorrowedMoneyList(borrowedMoney);
    }

    /**
     * 新增从外部借款信息
     *
     * @param borrowedMoney 从外部借款信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class, isolation = Isolation.SERIALIZABLE)
    public int insertBorrowedMoney(BorrowedMoney borrowedMoney) {
        // 设置一些基础信息
        borrowedMoney.setAddtime(String.valueOf(DateUtils.getNowDate()));
        borrowedMoney.setUserId(SecurityUtils.getUserId());
        borrowedMoney.setUserName(SecurityUtils.getUserTruename());
        borrowedMoney.setDelFlag(Long.valueOf(DelConstants.NODEL));
        if (borrowedMoney.getIsEnd() != null) {
            // 如果前端不传入，则设置为默认值
            borrowedMoney.setIsEnd(BorrowedMoneyConstants.noEnd);
        }

        // 设置UUID
        borrowedMoney.setLoanNO(UUID.fastUUID().toString());

        //同步到银行卡变动中去
        // 1.1 先查询这个银行卡号是否存在
        BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(borrowedMoney.getBankNo());
        if (StringUtils.isNull(bankAccount)) {
            throw new ServiceException("错误，搜索不到对应的银行卡信息,请检查");
        }

        // 1.2 查询到银行卡后开始拼装变动信息
        BankAccountChange bankAccountChange = new BankAccountChange();
        bankAccountChange.setOperateDate(DateUtils.getNowDate().toString());
        bankAccountChange.setChangeType(BankChangeConstant.PaymentType.RECEIPT.get());
        bankAccountChange.setMoneyAmount(borrowedMoney.getMoneyAmount());
        bankAccountChange.setSelfBankNo(borrowedMoney.getBankNo());
        bankAccountChange.setPayNO(borrowedMoney.getLoanNO());
        bankAccountChange.setTableName(BankChangeConstant.TableName.BORROWED_MONEY.get());

        // 1.3调用业务层去把剩余的字段自动补齐
        bankAccountChangeService.insertBankAccountChange(bankAccountChange);

        // 返回插入结果
        return borrowedMoneyMapper.insertBorrowedMoney(borrowedMoney);
    }

    /**
     * 修改从外部借款信息
     *
     * @param borrowedMoney 从外部借款信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class, isolation = Isolation.SERIALIZABLE)
    public int updateBorrowedMoney(BorrowedMoney borrowedMoney) {
        // 设置基础信息
        borrowedMoney.setUserId(SecurityUtils.getUserId());
        borrowedMoney.setUserName(SecurityUtils.getUserTruename());
        borrowedMoney.setUpdateTime(DateUtils.getNowDate());

        // 防止恶意修改UUID导致数据不对账
        String loanNO = selectBorrowedMoneyById(borrowedMoney.getId()).getLoanNO();
        if(!loanNO.equals(borrowedMoney.getLoanNO())){
            throw new ServiceException("非法操作,已经记录你的IP和请求参数");
        }
        //同步到银行卡变动中去

        // 检查本次是修改的卡号是否存在
        BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(borrowedMoney.getBankNo());
        if (StringUtils.isNull(bankAccount)) {
            throw new ServiceException("错误，搜索不到对应的银行卡信息,请检查");
        }

        // 查询到银行卡后开始拼装变动信息
        BankAccountChange bankAccountChange = new BankAccountChange();
        bankAccountChange.setOperateDate(DateUtils.getNowDate().toString());
        bankAccountChange.setChangeType(BankChangeConstant.PaymentType.RECEIPT.get());
        bankAccountChange.setMoneyAmount(borrowedMoney.getMoneyAmount());
        bankAccountChange.setSelfBankNo(borrowedMoney.getBankNo());
        bankAccountChange.setPayNO(borrowedMoney.getLoanNO());
        bankAccountChange.setTableName(BankChangeConstant.TableName.BORROWED_MONEY.get());

        // 1.3调用业务层去把剩余的字段自动补齐
        bankAccountChangeService.updateBankAccountChangeByUUID(bankAccountChange);
        return borrowedMoneyMapper.updateBorrowedMoney(borrowedMoney);
    }

    /**
     * 批量删除从外部借款信息
     *
     * @param ids 需要删除的从外部借款信息主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class, isolation = Isolation.SERIALIZABLE)
    public int deleteBorrowedMoneyByIds(Long[] ids) {
        // 先删除对应流水
        Arrays.stream(ids).parallel().forEach(id ->
                bankAccountChangeService.deleteBankAccountChangeByUUID(new String[]{borrowedMoneyMapper.selectBorrowedMoneyById(id).getLoanNO()})
        );
        return borrowedMoneyMapper.deleteBorrowedMoneyByIds(ids);

    }

    /**
     * 删除从外部借款信息信息
     *
     * @param id 从外部借款信息主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class, isolation = Isolation.SERIALIZABLE)
    public int deleteBorrowedMoneyById(Long id) {
        String loanNO = borrowedMoneyMapper.selectBorrowedMoneyById(id).getLoanNO();
        bankAccountChangeService.deleteBankAccountChangeByUUID(new String[]{loanNO});
        return borrowedMoneyMapper.deleteBorrowedMoneyById(id);
    }
}
